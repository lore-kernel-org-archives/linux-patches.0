Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209685;
	b=kzO4W8iZvP/eBNY9IxUKnswx27XnUbTHB4pAZFeJ5mcuFoUWfnpp5K7cwS/gHhNcsLgi
	 P0yx3XHLJK4+wWGt7fOoymsuWHaXdPZvcOOnrWieAeMtD1RFRPgijNiojFmvbzyYhGoZB
	 VSYUzLnxvoCVRpqV98/aghI9c5Oaqb9HYIPnB+UYFwCfTtrDLcj1A8WxuqrGUQBincyWb
	 U1ja7Q8CkjEKg5SlBhBxSsGDvowSCtmm+9kXx24jwKyYoP6QMLjUjWQRMIjwNWaH3vqSB
	 EPYKxvv2KGMzDEGJrGc9Me1rfOd1DEOs29S04kognaONuqWCSs0HDeq3l6xU4mgYdUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qd0KIm9r/uQeZo8oeIxC7zPEhznpGQml+XSn7bE4diE=;
	b=tOa7fksbCk/Q0u1ecGMF1FUOcuYttDXgckwJqOskNaCBOhGU+/phmQRWPWnYtofygEm7
	 Qm5h7Ge2x4IvYpoy2Y6hushrvhiZw5iK+JX7OmQrkG7O5hGO9STQxPdzwC66TDYQRtaHc
	 oyfnAt+bPsVgHz9OQ7HxNsiAn94mO1knCw6s/AFtZgaA9nMA8P1HYOVOqfMt8xsbwyYBq
	 djDjFKMvgjP1i6wDpsJNEpz9MHntIz17NlWT6ALYBK//DN2VAyHIm1zV5VAvHM3FuJN1x
	 60wJN0Ry1BbAiY5c2LeJair0nsMiMl0/15WysD+wpXS+YfGikeBpvUmtAuYBiHSP3Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kS24nTXD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1F6606A31A;
	Wed, 28 Oct 2026 17:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kS24nTXD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03551F01825;
	Wed, 28 Oct 2026 17:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209685;
	bh=qd0KIm9r/uQeZo8oeIxC7zPEhznpGQml+XSn7bE4diE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kS24nTXDPmEg/FQ7tSv7PsEAUhYupeB69lXaHmiUvXn2MnyYfELbEWQWhMS4d4kz6
	 YtC6viSR0WtPzXy6iDmMpvRfobHacjMZf4C/fOrLiBqveGmqYHDwoo7r1NsA5Qa7LD
	 XI690/xXHxl3NYE5wh2TCZ+b0H6/dfoiPy41kEx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stanislav Fort <disclosure@aisle.com>,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 006/109] netrom: linearize and validate lengths in nr_rx_frame()
Date: Wed, 28 Oct 2026 17:59:50 +0100
Message-ID: <20261028165942.511289780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fort <disclosure@aisle.com>

Linearize skb and add targeted length checks in nr_rx_frame() to
prevent out-of-bounds reads when processing malformed NET/ROM frames.

- Require skb to be linear and at least NR_NETWORK_LEN +
  NR_TRANSPORT_LEN (20 bytes) before reading network/transport fields.
- For the existing sockets path, ensure NR_CONNACK includes the window
  byte (>= 21 bytes), which nr_state1_machine() reads.
- For CONNREQ handling, ensure window (byte 20) and user address
  (bytes 21-27) are present (>= 28 bytes), and do so before
  nr_find_listener() so no listener reference can leak.
- Preserve existing BPQ extension handling:
  - NR_CONNACK len == 22 -> 1 extra byte (TTL)
  - NR_CONNREQ len == 37 -> 2 extra bytes (timeout)

nr_route_frame() only guarantees 15 bytes before handing a frame
addressed to a local node to nr_rx_frame(), so a short frame received
from any AX.25 neighbour is enough to trigger the over-read.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Suggested-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Stanislav Fort <disclosure@aisle.com>
[F6BVP: v4 never reached mainline (whitespace-damaged posting, subsystem
 removed in 7.1); rebased onto mod-orphan, added comments. Tested on a
 two-VM QEMU bench (6.12.94, mkiss link): an AX.25 peer sends CONNREQ
 frames truncated to 20 and 27 bytes; without this patch both are
 accepted as connections, the user callsign being read past the end of
 the frame; with it only the complete 35-byte CONNREQ is accepted.
 v2: apply the CONNACK length check to a plain CONNACK only, so that
 20-byte CONNACK|CHOKE refusals and resets are no longer dropped
 (reported by Sasha Levin). Same fix submitted to mod-orphan.]
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit db51201afd46992c9206fa79878badb2236bb7d3)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/af_netrom.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 33468124d53db..0e70d149abcd5 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -885,6 +885,11 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 	 *	skb->data points to the netrom frame start
 	 */
 
+	if (skb_linearize(skb))
+		return 0;
+	if (skb->len < NR_NETWORK_LEN + NR_TRANSPORT_LEN)
+		return 0;
+
 	src  = (ax25_address *)(skb->data + 0);
 	dest = (ax25_address *)(skb->data + 7);
 
@@ -927,6 +932,17 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	if (sk != NULL) {
+		/*
+		 * nr_state1_machine() reads the window size at byte 20, but
+		 * only for a plain CONNACK. A CONNACK with the choke flag set
+		 * is a refusal or a reset, sent as a 20-byte frame by
+		 * __nr_transmit_reply(), and must not be dropped here.
+		 */
+		if (frametype == NR_CONNACK && !flags &&
+		    skb->len < NR_NETWORK_LEN + NR_TRANSPORT_LEN + 1) {
+			sock_put(sk);
+			return 0;
+		}
 		bh_lock_sock(sk);
 		skb_reset_transport_header(skb);
 
@@ -961,10 +977,14 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 		return 0;
 	}
 
-	sk = nr_find_listener(dest);
+	/* Need window (byte 20) and user address (bytes 21-27) */
+	if (skb->len < NR_NETWORK_LEN + NR_TRANSPORT_LEN + 1 + AX25_ADDR_LEN)
+		return 0;
 
 	user = (ax25_address *)(skb->data + 21);
 
+	sk = nr_find_listener(dest);
+
 	if (sk == NULL || sk_acceptq_is_full(sk) ||
 	    (make = nr_make_new(sk)) == NULL) {
 		nr_transmit_refusal(skb, 0);
-- 
2.53.0



