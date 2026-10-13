Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1A12EA173;
	Tue, 13 Oct 2026 12:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896070; cv=none; b=FHkXpr7zlGyDNdd6yk9FxuTd/9ZfcXIcQCx9Nzi1/nens3uT8E3jgOG2FDqibTgDMm0h/SoNEdQKBlTUSCz3KkDjNErh3hplIXWp028A2L/ydTXYWQFxkoKhmdwZc2e79ChIdIVkIz+33P7tB4B8YgsIo/6W0D8K+GU+HddXLoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896070; c=relaxed/simple;
	bh=GRtUmUyIyNmCxBnqJz03jtLW9ZBYLFpvdlh5vwPj4zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5XjcZAZ4QFKMKms9lisG/rAaoxrKm9guM9plbV/aonlAe9eNLYbUjIhOZdkwBe7a/6CIRG/1Q/cEvCRFUp1L4ItNRXzKG36P8x3cokEdstKy1h+dvc41neG6468QKNotK4w6swgexDLsbfzdYABTFlEJJ5zeNegwht+DN5eij8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPREN+iH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPREN+iH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5939D1F00893;
	Tue, 13 Oct 2026 12:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896068;
	bh=9PPeJ7ayvBWOpqZyTuEIEOuI5kRct+7bVn8Bv+cUlU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sPREN+iHS7hY38TOHxSh5p38LnZXAlTj5kC0g9m84kPLSZ3bgaD9ffaUN/7TCfJHV
	 kB5Mmnj27YVhSmXtnwkcs6jGx338NXL4JHvK0yaAszAHrs5OczbaTIrjgViFlJwqpM
	 /XO6+x1AJj0ygHTneEpOl+92HlK3IYbYjHZ+aIHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junnan Zhang <zhangjn_dev@163.com>,
	Willem de Bruijn <willemb@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 487/497] net/packet: call packet_parse_headers after virtio_net_hdr_to_skb
Date: Tue, 13 Oct 2026 13:40:54 +0200
Message-ID: <20261013112919.435445950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 048dc025b911b..834097e522b59 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1995,8 +1995,7 @@ static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
 	/* On TX skb->data is the L2 header; anchor it for all socket types. */
 	skb_reset_mac_header(skb);
 
-	if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
-	    sock->type == SOCK_RAW)
+	if (!skb->protocol && sock->type == SOCK_RAW)
 		skb->protocol = dev_parse_header_protocol(skb);
 
 	skb_probe_transport_header(skb);
@@ -2666,7 +2665,8 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	struct page *page;
 	int err;
 
-	skb->protocol = proto;
+	if (proto != htons(ETH_P_ALL))
+		skb->protocol = proto;
 	skb->dev = dev;
 	skb->priority = READ_ONCE(po->sk.sk_priority);
 	skb->mark = READ_ONCE(po->sk.sk_mark);
@@ -2730,8 +2730,6 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	if (unlikely(!skb->len))
 		return -EINVAL;
 
-	packet_parse_headers(skb, sock);
-
 	return tp_len;
 }
 
@@ -2971,9 +2969,13 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
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
@@ -3175,7 +3177,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		goto out_free;
 	}
 
-	skb->protocol = proto;
+	if (proto != htons(ETH_P_ALL))
+		skb->protocol = proto;
 	skb->dev = dev;
 	skb->priority = READ_ONCE(sk->sk_priority);
 	skb->mark = sockc.mark;
@@ -3184,16 +3187,18 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
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



