ARG TAILSCALE_VERSION=latest

FROM tailscale/tailscale:$TAILSCALE_VERSION

LABEL maintainer="wimmme@gmail.com"

ENV CADDY_TARGET=
ENV TS_TAILNET=
ENV TS_HOSTNAME=
ENV TS_EXTRA_FLAGS=
ENV TS_USERSPACE=true
ENV TS_STATE_DIR=/var/lib/tailscale/ 
ENV TS_AUTH_ONCE=true

RUN apk update && apk upgrade --no-cache && apk add --no-cache ca-certificates mailcap caddy
RUN caddy upgrade
RUN tailscale update --yes

# Ensure Caddy can access the tailscale socket, Caddy expects it to be under /var/run/tailscale so make a symlink
RUN mkdir --parents /var/run/tailscale && ln -s /tmp/tailscaled.sock /var/run/tailscale/tailscaled.sock

# Add the modified startup script
COPY start.sh /usr/bin/start.sh
RUN  chmod +x /usr/bin/start.sh

# And run it
CMD  [ "start.sh" ]

