Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523EF181334;
	Sun,  1 Sep 2024 16:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209240; cv=none; b=LXmlB6Hji72gJlU9sQ090C+y6jpejFHsNmLK7Dw+StXG3nfSZs6WovR6cPEX60fUbRmSdug2qnmOPdGlze1f2ikyYygCUjP/KL8T6tQMdcx++19qpZmnvStIEnJPuhJCUZ3HnV+mzUqP3523mAWYpKEuN9JwO0lMrgNt7/HQaGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209240; c=relaxed/simple;
	bh=zHPNMUMavYDydSEThlaq+zEeeb46Q09WP5bj3AnJ4Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kbm85DCwYqxDdrL1ncn0MYnVpVbWsgQvXg3im/QpeObkDEcoXr7+vgPa18aFsgaaxrICEmU0kJrIt72aNHFOoGnLI0t2GGe3JgdoIsDGg+OteyTxh3xJzE/OSFv+900FK5lMi8V3icepPHaktq6LguXgVKNGRofAajaRnCvaEG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMP84PWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMP84PWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A5BC4CEC4;
	Sun,  1 Sep 2024 16:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209240;
	bh=zHPNMUMavYDydSEThlaq+zEeeb46Q09WP5bj3AnJ4Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMP84PWHzWz0/jbk7cjwQOhqvw2bD2igqG4Hc3Pi+ia3Fy9hSCzHvcbHlfa/ujG1r
	 iPDU0NA1Fg0oQfbwICczVMWYa9QXdrVH203SfD6ZbWsiGTfqzEOoq7Ssi+Sf90LtQz
	 s8Jt7oyeBioySOdt3fPtF9UnPO2lEuBsxRP5+mtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ortiz <jorge.ortiz.escribano@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 44/71] netfilter: nf_tables: restore IP sanity checks for netdev/egress
Date: Sun,  1 Sep 2024 18:17:49 +0200
Message-ID: <20240901160803.554531738@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 5fd0628918977a0afdc2e6bc562d8751b5d3b8c5 ]

Subtract network offset to skb->len before performing IPv4 header sanity
checks, then adjust transport offset from offset from mac header.

Jorge Ortiz says:

When small UDP packets (< 4 bytes payload) are sent from eth0,
`meta l4proto udp` condition is not met because `NFT_PKTINFO_L4PROTO` is
not set. This happens because there is a comparison that checks if the
transport header offset exceeds the total length.  This comparison does
not take into account the fact that the skb network offset might be
non-zero in egress mode (e.g., 14 bytes for Ethernet header).

Fixes: 0ae8e4cca787 ("netfilter: nf_tables: set transport offset from mac header for netdev/egress")
Reported-by: Jorge Ortiz <jorge.ortiz.escribano@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables_ipv4.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index 5225d2bd1a6e9..10b0a7c9e721f 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -19,7 +19,7 @@ static inline void nft_set_pktinfo_ipv4(struct nft_pktinfo *pkt)
 static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 {
 	struct iphdr *iph, _iph;
-	u32 len, thoff;
+	u32 len, thoff, skb_len;
 
 	iph = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb),
 				 sizeof(*iph), &_iph);
@@ -30,15 +30,17 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 		return -1;
 
 	len = iph_totlen(pkt->skb, iph);
-	thoff = skb_network_offset(pkt->skb) + (iph->ihl * 4);
-	if (pkt->skb->len < len)
+	thoff = iph->ihl * 4;
+	skb_len = pkt->skb->len - skb_network_offset(pkt->skb);
+
+	if (skb_len < len)
 		return -1;
 	else if (len < thoff)
 		return -1;
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = iph->protocol;
-	pkt->thoff = thoff;
+	pkt->thoff = skb_network_offset(pkt->skb) + thoff;
 	pkt->fragoff = ntohs(iph->frag_off) & IP_OFFSET;
 
 	return 0;
-- 
2.43.0



