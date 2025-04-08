Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A6F266583;
	Tue,  8 Apr 2025 11:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110972; cv=none; b=S1h5LFhqSjFTZb+aZHDHcpf1Fj3mJLoX1+kAhJBLCOFGWAg0QVy9d43N8EH0KtSPEBTnosjQqdQz2FnU0Yif9rtwokpnSd8XbLQaeLXGK48qp6CJGvAK9zwksi6yX91Qi4zpQ46A5f+Ktt6S4exuO+JLgu10/f58p6NOyh0H06w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110972; c=relaxed/simple;
	bh=2MsHV2uEf/xzSOmn+TXLDrCyzzWGaHWVXvoQOjJBSMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMhQUZ1Ahuc1aGgrgvZIGZiMkde1Wr/dHzUXTTmcVXt5OeCyLHPGpjIVkprXtOpc8e9FkdU6v/eDv87/0fNCyy6DQO4GKyaGLt15ntDJc9T2i28G0KXxSQY1MDGtTCAK8vB3g5idkmXYurQF61bRzVzDnviN2QmMSTRWTdLaQSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTjdPWkk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTjdPWkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD27C4CEE5;
	Tue,  8 Apr 2025 11:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110972;
	bh=2MsHV2uEf/xzSOmn+TXLDrCyzzWGaHWVXvoQOjJBSMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTjdPWkkAW/SX8zx4EvsyXMCRNHgsAWEueMs04PSmA261pTwreuZu1K9Q8L8YZhsX
	 UFXOxIpgimO4TCYNf8JAakRfdwBZWfIHKtTC6eerWjUHnBGPl7v0/1nUT5coqgW2h7
	 775/o1KO6oP+sfRJ2J5yc5g6MIecBUKn2/IWeYFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 263/731] net: libwx: fix Tx descriptor content for some tunnel packets
Date: Tue,  8 Apr 2025 12:42:40 +0200
Message-ID: <20250408104920.399887307@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit a44940d094afa2e04b5b164b1e136fc18bcb4a2d ]

The length of skb header was incorrectly calculated when transmit a tunnel
packet with outer IPv6 extension header, or a IP over IP packet which has
inner IPv6 header. Thus the correct Tx context descriptor cannot be
composed, resulting in Tx ring hang.

Fixes: 3403960cdf86 ("net: wangxun: libwx add tx offload functions")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20250324103235.823096-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c | 61 +++++++++++++--------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 2b3d6586f44a5..9294a9d8c5541 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1082,26 +1082,6 @@ static void wx_tx_ctxtdesc(struct wx_ring *tx_ring, u32 vlan_macip_lens,
 	context_desc->mss_l4len_idx     = cpu_to_le32(mss_l4len_idx);
 }
 
-static void wx_get_ipv6_proto(struct sk_buff *skb, int offset, u8 *nexthdr)
-{
-	struct ipv6hdr *hdr = (struct ipv6hdr *)(skb->data + offset);
-
-	*nexthdr = hdr->nexthdr;
-	offset += sizeof(struct ipv6hdr);
-	while (ipv6_ext_hdr(*nexthdr)) {
-		struct ipv6_opt_hdr _hdr, *hp;
-
-		if (*nexthdr == NEXTHDR_NONE)
-			return;
-		hp = skb_header_pointer(skb, offset, sizeof(_hdr), &_hdr);
-		if (!hp)
-			return;
-		if (*nexthdr == NEXTHDR_FRAGMENT)
-			break;
-		*nexthdr = hp->nexthdr;
-	}
-}
-
 union network_header {
 	struct iphdr *ipv4;
 	struct ipv6hdr *ipv6;
@@ -1112,6 +1092,8 @@ static u8 wx_encode_tx_desc_ptype(const struct wx_tx_buffer *first)
 {
 	u8 tun_prot = 0, l4_prot = 0, ptype = 0;
 	struct sk_buff *skb = first->skb;
+	unsigned char *exthdr, *l4_hdr;
+	__be16 frag_off;
 
 	if (skb->encapsulation) {
 		union network_header hdr;
@@ -1122,14 +1104,18 @@ static u8 wx_encode_tx_desc_ptype(const struct wx_tx_buffer *first)
 			ptype = WX_PTYPE_TUN_IPV4;
 			break;
 		case htons(ETH_P_IPV6):
-			wx_get_ipv6_proto(skb, skb_network_offset(skb), &tun_prot);
+			l4_hdr = skb_transport_header(skb);
+			exthdr = skb_network_header(skb) + sizeof(struct ipv6hdr);
+			tun_prot = ipv6_hdr(skb)->nexthdr;
+			if (l4_hdr != exthdr)
+				ipv6_skip_exthdr(skb, exthdr - skb->data, &tun_prot, &frag_off);
 			ptype = WX_PTYPE_TUN_IPV6;
 			break;
 		default:
 			return ptype;
 		}
 
-		if (tun_prot == IPPROTO_IPIP) {
+		if (tun_prot == IPPROTO_IPIP || tun_prot == IPPROTO_IPV6) {
 			hdr.raw = (void *)inner_ip_hdr(skb);
 			ptype |= WX_PTYPE_PKT_IPIP;
 		} else if (tun_prot == IPPROTO_UDP) {
@@ -1166,7 +1152,11 @@ static u8 wx_encode_tx_desc_ptype(const struct wx_tx_buffer *first)
 			l4_prot = hdr.ipv4->protocol;
 			break;
 		case 6:
-			wx_get_ipv6_proto(skb, skb_inner_network_offset(skb), &l4_prot);
+			l4_hdr = skb_inner_transport_header(skb);
+			exthdr = skb_inner_network_header(skb) + sizeof(struct ipv6hdr);
+			l4_prot = inner_ipv6_hdr(skb)->nexthdr;
+			if (l4_hdr != exthdr)
+				ipv6_skip_exthdr(skb, exthdr - skb->data, &l4_prot, &frag_off);
 			ptype |= WX_PTYPE_PKT_IPV6;
 			break;
 		default:
@@ -1179,7 +1169,11 @@ static u8 wx_encode_tx_desc_ptype(const struct wx_tx_buffer *first)
 			ptype = WX_PTYPE_PKT_IP;
 			break;
 		case htons(ETH_P_IPV6):
-			wx_get_ipv6_proto(skb, skb_network_offset(skb), &l4_prot);
+			l4_hdr = skb_transport_header(skb);
+			exthdr = skb_network_header(skb) + sizeof(struct ipv6hdr);
+			l4_prot = ipv6_hdr(skb)->nexthdr;
+			if (l4_hdr != exthdr)
+				ipv6_skip_exthdr(skb, exthdr - skb->data, &l4_prot, &frag_off);
 			ptype = WX_PTYPE_PKT_IP | WX_PTYPE_PKT_IPV6;
 			break;
 		default:
@@ -1269,13 +1263,20 @@ static int wx_tso(struct wx_ring *tx_ring, struct wx_tx_buffer *first,
 
 	/* vlan_macip_lens: HEADLEN, MACLEN, VLAN tag */
 	if (enc) {
+		unsigned char *exthdr, *l4_hdr;
+		__be16 frag_off;
+
 		switch (first->protocol) {
 		case htons(ETH_P_IP):
 			tun_prot = ip_hdr(skb)->protocol;
 			first->tx_flags |= WX_TX_FLAGS_OUTER_IPV4;
 			break;
 		case htons(ETH_P_IPV6):
+			l4_hdr = skb_transport_header(skb);
+			exthdr = skb_network_header(skb) + sizeof(struct ipv6hdr);
 			tun_prot = ipv6_hdr(skb)->nexthdr;
+			if (l4_hdr != exthdr)
+				ipv6_skip_exthdr(skb, exthdr - skb->data, &tun_prot, &frag_off);
 			break;
 		default:
 			break;
@@ -1298,6 +1299,7 @@ static int wx_tso(struct wx_ring *tx_ring, struct wx_tx_buffer *first,
 						WX_TXD_TUNNEL_LEN_SHIFT);
 			break;
 		case IPPROTO_IPIP:
+		case IPPROTO_IPV6:
 			tunhdr_eiplen_tunlen = (((char *)inner_ip_hdr(skb) -
 						(char *)ip_hdr(skb)) >> 2) <<
 						WX_TXD_OUTER_IPLEN_SHIFT;
@@ -1341,6 +1343,8 @@ static void wx_tx_csum(struct wx_ring *tx_ring, struct wx_tx_buffer *first,
 		vlan_macip_lens = skb_network_offset(skb) <<
 				  WX_TXD_MACLEN_SHIFT;
 	} else {
+		unsigned char *exthdr, *l4_hdr;
+		__be16 frag_off;
 		u8 l4_prot = 0;
 		union {
 			struct iphdr *ipv4;
@@ -1362,7 +1366,12 @@ static void wx_tx_csum(struct wx_ring *tx_ring, struct wx_tx_buffer *first,
 				tun_prot = ip_hdr(skb)->protocol;
 				break;
 			case htons(ETH_P_IPV6):
+				l4_hdr = skb_transport_header(skb);
+				exthdr = skb_network_header(skb) + sizeof(struct ipv6hdr);
 				tun_prot = ipv6_hdr(skb)->nexthdr;
+				if (l4_hdr != exthdr)
+					ipv6_skip_exthdr(skb, exthdr - skb->data,
+							 &tun_prot, &frag_off);
 				break;
 			default:
 				return;
@@ -1386,6 +1395,7 @@ static void wx_tx_csum(struct wx_ring *tx_ring, struct wx_tx_buffer *first,
 							  WX_TXD_TUNNEL_LEN_SHIFT);
 				break;
 			case IPPROTO_IPIP:
+			case IPPROTO_IPV6:
 				tunhdr_eiplen_tunlen = (((char *)inner_ip_hdr(skb) -
 							(char *)ip_hdr(skb)) >> 2) <<
 							WX_TXD_OUTER_IPLEN_SHIFT;
@@ -1408,7 +1418,10 @@ static void wx_tx_csum(struct wx_ring *tx_ring, struct wx_tx_buffer *first,
 			break;
 		case 6:
 			vlan_macip_lens |= (transport_hdr.raw - network_hdr.raw) >> 1;
+			exthdr = network_hdr.raw + sizeof(struct ipv6hdr);
 			l4_prot = network_hdr.ipv6->nexthdr;
+			if (transport_hdr.raw != exthdr)
+				ipv6_skip_exthdr(skb, exthdr - skb->data, &l4_prot, &frag_off);
 			break;
 		default:
 			break;
-- 
2.39.5



