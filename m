Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F374D6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74315C433D2;
	Tue, 10 Jan 2023 18:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375044;
	bh=pAy+j9Xm+TGWLsRfvcQ04jwxyR262ZZfCzejTTc/S7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xyz5CwUC0tzV/xpVKc2Ht+6Zvj63ZaQIEOffbSjRJ9J7tRVH3g6UEylw6ggcTd771
	 8DVRKJ8g3L5AjJ2UkFJ6P9SrnzmO6AMrAf4t/DSjQ3QNUyIuPiy7EFM/BLgYbz7wo3
	 BSqwmzY2BCSZPVznpLLl54T6Um7HB/n85wN/KZlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 5.15 058/290] net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO
Date: Tue, 10 Jan 2023 19:02:30 +0100
Message-Id: <20230110180033.628653984@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hangbin Liu <liuhangbin@gmail.com>

commit dfed913e8b55a0c2c4906f1242fd38fd9a116e49 upstream.

Currently, the kernel drops GSO VLAN tagged packet if it's created with
socket(AF_PACKET, SOCK_RAW, 0) plus virtio_net_hdr.

The reason is AF_PACKET doesn't adjust the skb network header if there is
a VLAN tag. Then after virtio_net_hdr_set_proto() called, the skb->protocol
will be set to ETH_P_IP/IPv6. And in later inet/ipv6_gso_segment() the skb
is dropped as network header position is invalid.

Let's handle VLAN packets by adjusting network header position in
packet_parse_headers(). The adjustment is safe and does not affect the
later xmit as tap device also did that.

In packet_snd(), packet_parse_headers() need to be moved before calling
virtio_net_hdr_set_proto(), so we can set correct skb->protocol and
network header first.

There is no need to update tpacket_snd() as it calls packet_parse_headers()
in tpacket_fill_skb(), which is already before calling virtio_net_hdr_*
functions.

skb->no_fcs setting is also moved upper to make all skb settings together
and keep consistency with function packet_sendmsg_spkt().

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://lore.kernel.org/r/20220425014502.985464-1-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1888,12 +1888,20 @@ oom:
 
 static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
 {
+	int depth;
+
 	if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
 	    sock->type == SOCK_RAW) {
 		skb_reset_mac_header(skb);
 		skb->protocol = dev_parse_header_protocol(skb);
 	}
 
+	/* Move network header to the right position for VLAN tagged packets */
+	if (likely(skb->dev->type == ARPHRD_ETHER) &&
+	    eth_type_vlan(skb->protocol) &&
+	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
+		skb_set_network_header(skb, depth);
+
 	skb_probe_transport_header(skb);
 }
 
@@ -3008,6 +3016,11 @@ static int packet_snd(struct socket *soc
 	skb->mark = sockc.mark;
 	skb->tstamp = sockc.transmit_time;
 
+	if (unlikely(extra_len == 4))
+		skb->no_fcs = 1;
+
+	packet_parse_headers(skb, sock);
+
 	if (has_vnet_hdr) {
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
 		if (err)
@@ -3016,11 +3029,6 @@ static int packet_snd(struct socket *soc
 		virtio_net_hdr_set_proto(skb, &vnet_hdr);
 	}
 
-	packet_parse_headers(skb, sock);
-
-	if (unlikely(extra_len == 4))
-		skb->no_fcs = 1;
-
 	err = po->xmit(skb);
 	if (unlikely(err != 0)) {
 		if (err > 0)


