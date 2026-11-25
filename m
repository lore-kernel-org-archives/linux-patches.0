Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622219;
	b=M3nTOs/U5wfpV6PEYsL5rmEtL/7Nrs5v6qxhLMKkWnxqgW2tjC5SbQsnU9iy/C6ntYLh
	 mekEuBNZh7BFchxAJSn6ba5TLhc+KN4lH/YOzy2fhDugnp6vRH8M+kOEfoJt/aQmj4JKi
	 BAitrW3xunmsFte7iISitJRe1ZvkkY/bCBYTC14patmoYKYmLVKVQKe2TlyYFgpSvIlZ+
	 vk6xDVdmxPSpH/7woEGsJ5v+sWkcgYTFzWhCCmDvhxNkx8nTDd0kH727y9oXu5ssMKTfQ
	 VBuHeVDFgDQ2hWN8gabJ6ozCUWzt1iI/ri/0OGTipSIr/AWDwlQHfiox8nyI8OIaJdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yfPj42Gz+a1+NGRX62knUmFxuQayZqdNSQ5rgz/pO/I=;
	b=AMWgul8cd3A3yqznIC5S6iu/tz4F8QkKxSRdDpp0hTnFmo/nIjQJMMXySd62LceJD8iD
	 mKCdHRiCfzrB1gC5KchRmLiP3iq6qgt96P1oKz1o49DnYenGvOUkjpzG5AucJZZK9Uy0u
	 dYZH9AExJB145AbM0mpIym8F4rcunw1zFNrcESDzyACOi4bIEkwa2GcMmUMhXS34IozMK
	 4HUEQP14XEnwlVXp8NSrOLd6YmQYFhTPV3mPPQqDyQOw+jLJfcL4sfJPXFlTE8BrcQfsX
	 XAs3YHRvfu7r2zLl2wXUS3W6e4R431s/x06njBC/rn6AV0C3lsCv95VlmS39kTUe04Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DTYlAvLd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690E8606A326;
	Wed, 25 Nov 2026 15:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DTYlAvLd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE571F000C0;
	Wed, 25 Nov 2026 15:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622218;
	bh=yfPj42Gz+a1+NGRX62knUmFxuQayZqdNSQ5rgz/pO/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DTYlAvLdvYXMw+eLrTo9dKuSw9aF9Qloye2ew6nKdIB2i+/EP67DnZeDiGGm95rlC
	 o2/fe41o/1b7L3ZTVPlpKAPeDM5q29j/eX61qCZoXN87o/16zsJNaYLVUY48wfEFxi
	 Qb+vAne3u2RNu3cB63b1tMODAyxbePI6yjy9SyR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 467/990] net: virtio: fix UDP tunnel GSO header of VLAN tagged packets
Date: Wed, 25 Nov 2026 15:30:34 +0100
Message-ID: <20261125143833.037088191@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 9e244f94128a4b89004f0564b66e039e58318a34 ]

virtio_net_hdr_tnl_from_skb() builds a wrong header for VLAN tagged UDP
tunnel GSO packets.

1) When the skb carries a hwaccel VLAN tag, tun_put_user() inserts the
   802.1Q header in the frame it copies to user space or vhost-net, and
   passes vlan_hlen = VLAN_HLEN. virtio_net_hdr_from_skb() adds
   vlan_hlen to csum_start, but inner_nh_offset and outer_th_offset do
   not account for it, and are 4 bytes short of the real inner L3 and
   outer UDP headers in the emitted frame.

   tun advertises NETIF_F_HW_VLAN_CTAG_TX and NETIF_F_HW_VLAN_STAG_TX
   in hw_enc_features, and its vlan_features keep the UDP tunnel GSO
   features, so this happens for example with a VLAN filtering bridge
   with a tagged port, or with a vlan device on top of a tap.

2) The outer family comes from skb->protocol, which is ETH_P_8021Q or
   ETH_P_8021AD when the VLAN tag is in the packet data, so a packet
   with an outer IPv6 header is reported as
   VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV4. This happens when
   __vlan_hwaccel_push_inside() inserted the tag because the device does
   not offload it: virtio_net never offloads VLAN insertion but keeps
   UDP tunnel GSO in its vlan_features, and tun does the same with VLAN
   TX offload disabled, or with QinQ (outer tag offloaded, inner tag in
   the data).

The receiver sets inner_network_header and transport_header from these
offsets, and checks them with the wrong outer family. A forwarded
packet that gets segmented again uses the wrong inner headers, and a
receiver checking the outer headers against the virtio header drops
the packet.

Add vlan_hlen to both offsets like csum_start, and take the outer
family from vlan_get_protocol(), which skips VLAN tags in the data.

Fixes: a2fb4bc4e2a6 ("net: implement virtio helpers to handle UDP GSO tunneling.")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/netdev/179421814766.994134.3669228181251158303@kernel.org/
Closes: https://lore.kernel.org/netdev/179433950084.994134.15100186606737698605@kernel.org/
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261110213628.3476051-2-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_net.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index b7b6b542f4763..fc9667176f23c 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -622,7 +622,10 @@ virtio_net_hdr_tnl_from_skb(const struct sk_buff *skb,
 	if (feature_hdrlen && hdr->hdr_len)
 		__virtio_net_set_tnl_hdrlen(skb, hdr);
 
-	if (skb->protocol == htons(ETH_P_IPV6))
+	/* skb->protocol is the VLAN protocol when the tag is in the
+	 * packet data.
+	 */
+	if (vlan_get_protocol(skb) == htons(ETH_P_IPV6))
 		hdr->gso_type |= VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV6;
 	else
 		hdr->gso_type |= VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV4;
@@ -630,8 +633,11 @@ virtio_net_hdr_tnl_from_skb(const struct sk_buff *skb,
 	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL_CSUM)
 		hdr->flags |= VIRTIO_NET_HDR_F_UDP_TUNNEL_CSUM;
 
-	inner_nh = skb->inner_network_header - skb_headroom(skb);
-	outer_th = skb->transport_header - skb_headroom(skb);
+	/* Like csum_start, the offsets must account for a VLAN tag
+	 * the caller inserts in the frame.
+	 */
+	inner_nh = skb->inner_network_header - skb_headroom(skb) + vlan_hlen;
+	outer_th = skb->transport_header - skb_headroom(skb) + vlan_hlen;
 	vhdr->inner_nh_offset = cpu_to_le16(inner_nh);
 	vhdr->outer_th_offset = cpu_to_le16(outer_th);
 	return 0;
-- 
2.53.0



