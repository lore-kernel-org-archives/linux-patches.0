Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C8D3E0C67;
	Tue, 13 Oct 2026 12:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894548; cv=none; b=H3sEOut4WKMHuVlW3vibF1NPd/4uBXo8cxZLfwQ9gkRFZ+ZU/MT2G+xH4Jep6285YSGbH/Vx1xbSvDaTblBLOmhNTYDQ7ZfSAq4gKckW/LI99+gIbTiGrywvp7y6/QVC8bgGQ+FK0Y61ic1Kq3gqy+UrW3EJAiSXo86lxBDjbfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894548; c=relaxed/simple;
	bh=APhW86b+RCKe71GpDZ0U/Be6mJnK2VYUfvqJpZNV8uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWbOrsNnvzcGHVUq6RG/w54pw6jCzSiKckwCHCwE9y+hzkN187gsCIFzJmb7quoqd35L8uQdLOL5T3X/TyWgTmqG4ElT+71tzF2dTf1KqBj/BoRSOb8kF+h6hFKnbDyAIjpFD+u1Rf3k5Jaq7B/jfAd6WRLPYHoClMKGS0EJms0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erbvFICN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erbvFICN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149BE1F000FF;
	Tue, 13 Oct 2026 12:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894546;
	bh=egTe4QKF77GjmWJ51uJnUCkC2o5PWu845Wls+W3q+20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=erbvFICNDFIEpTse4g6jG9tyEcoJSEQ5FniStEa8bjZVRDZN5chDcGCHOarwcvrap
	 hTHZ9YbJvnSgDcRCd51qu9TYBhSj9OBYuUSAyx902sU2EXWYM8ngsSCIDSwzMdxs/q
	 51Fr8isBNzvSNtT0v1P3LS0zfJ+P+EvIYyXawHyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junnan Zhang <zhangjn_dev@163.com>,
	Willem de Bruijn <willemb@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 597/621] net/packet: call packet_parse_headers after virtio_net_hdr_to_skb
Date: Tue, 13 Oct 2026 13:39:52 +0200
Message-ID: <20261013112934.968793317@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 513e23857a3a64fa73a1deb36a385eecd4ad7690 ]

SOCK_RAW packet sockets incorrectly drop VLAN-tagged GSO packets
without VIRTIO_NET_HDR_F_NEEDS_CSUM.

packet_parse_headers() sets skb->protocol to VLAN but advances
skb->network_header past the VLAN tags. virtio_net_hdr_to_skb()
then flow dissects these packets, which parses the network header as a
VLAN tag, and fails.

Call packet_parse_headers() after virtio_net_hdr_to_skb() instead.

This matches tun_get_user() and tap_get_user() and thus simplifies
overall complexity.

Commit 01fdecc0480d ("net: packet: fix wrong transport_header when
sending VLAN-tagged frame") fixed the same issue for the transport
header probe in packet_parse_headers(). That probe is now skipped if
virtio_net_hdr_to_skb() already set the transport header, avoiding a
redundant dissection.

Implementation details:
- Do not set skb->protocol to the RX wildcard ETH_P_ALL. SOCK_RAW then
  derives it from the link layer header, as before. SOCK_DGRAM now
  leaves it 0, or derives it from gso_type for GSO with NEEDS_CSUM.
- Keep virtio_net_hdr_set_proto() last, so that the link layer protocol
  takes priority over gso_type.

Reported-by: Junnan Zhang <zhangjn_dev@163.com>
Closes: https://lore.kernel.org/netdev/20260821085722.24036-1-zhangjn_dev@163.com/
Fixes: dfed913e8b55 ("net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20261007175816.3138556-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index fc56efe64a28e..560fb35a4b433 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1942,8 +1942,7 @@ static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
 	/* On TX skb->data is the L2 header; anchor it for all socket types. */
 	skb_reset_mac_header(skb);
 
-	if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
-	    sock->type == SOCK_RAW)
+	if (!skb->protocol && sock->type == SOCK_RAW)
 		skb->protocol = dev_parse_header_protocol(skb);
 
 	skb_probe_transport_header(skb);
@@ -2613,7 +2612,8 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	struct page *page;
 	int err;
 
-	skb->protocol = proto;
+	if (proto != htons(ETH_P_ALL))
+		skb->protocol = proto;
 	skb->dev = dev;
 	skb->priority = sockc->priority;
 	skb->mark = sockc->mark;
@@ -2677,8 +2677,6 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	if (unlikely(!skb->len))
 		return -EINVAL;
 
-	packet_parse_headers(skb, sock);
-
 	return tp_len;
 }
 
@@ -2918,9 +2916,13 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 				tp_len = -EINVAL;
 				goto tpacket_error;
 			}
-			virtio_net_hdr_set_proto(skb, &vnet_hdr);
 		}
 
+		packet_parse_headers(skb, po->sk.sk_socket);
+
+		if (has_vnet_hdr)
+			virtio_net_hdr_set_proto(skb, &vnet_hdr);
+
 		uarg = kmalloc(sizeof(*uarg), GFP_KERNEL);
 		if (unlikely(!uarg)) {
 			if (likely(len_sum > 0))
@@ -3121,7 +3123,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		goto out_free;
 	}
 
-	skb->protocol = proto;
+	if (proto != htons(ETH_P_ALL))
+		skb->protocol = proto;
 	skb->dev = dev;
 	skb->priority = sockc.priority;
 	skb->mark = sockc.mark;
@@ -3130,16 +3133,18 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	if (unlikely(extra_len == 4))
 		skb->no_fcs = 1;
 
-	packet_parse_headers(skb, sock);
-
 	if (vnet_hdr_sz) {
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
 		if (err)
 			goto out_free;
 		len += vnet_hdr_sz;
-		virtio_net_hdr_set_proto(skb, &vnet_hdr);
 	}
 
+	packet_parse_headers(skb, sock);
+
+	if (vnet_hdr_sz)
+		virtio_net_hdr_set_proto(skb, &vnet_hdr);
+
 	err = packet_xmit(po, skb);
 
 	if (unlikely(err != 0)) {
-- 
2.53.0



