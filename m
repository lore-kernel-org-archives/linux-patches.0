Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA8B183CBB;
	Sun,  1 Sep 2024 16:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208044; cv=none; b=bfrtWRMrl+Ja8WJeHkoYHErmVa9g3WoK5p4fI3VZBoPuRKa+Ik1f+X9bsb/dVzICKL6Qvb3zQBPYTMwiKoKNNvbw3jifFdYSGNUEgnGhhunCnByMstv4ztBucfFATjI8k63xzPpE0XAXetDKm+25l7Wr8ZRs/JlDUDFY1x70U+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208044; c=relaxed/simple;
	bh=fmy81NGhasS5xP5MqERSpp1iVuyOhxS4xzOgb0XEgbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnErGEPUk6v+HpmTUXfO+TQrYCfPSsLQyRFz/iqRCluG/XmlRu6L5HEkB3Yu+zCoJz5wUfiQBFODDX/QFBLxdZz/82JDB3ZEwlIr7I8WhkU2x4X+RVSYaSpp5rKVJIOChLPVPOqBFjOfm2O9E1neYIJOsYEJmM6cMkKHHSSDd+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHHdP5nd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHHdP5nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91022C4CEC8;
	Sun,  1 Sep 2024 16:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208044;
	bh=fmy81NGhasS5xP5MqERSpp1iVuyOhxS4xzOgb0XEgbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHHdP5ndU0M/XtBfpmGOmxs7J4LsGSl8jVcTFPD8IlsjNlIVPYqomxHpjlu912ekZ
	 Vjv7LE0Zva0AumrWgJ8f5j3A1pZXH8e9cx2ZvkMSlUX6kCTH3cidzGEoezdEM1QGpk
	 PDTA3u8S3HRxIZY3TofSEhopR4NiioBQO2vVwXGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ortiz <jorge.ortiz.escribano@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 56/93] netfilter: nf_tables: restore IP sanity checks for netdev/egress
Date: Sun,  1 Sep 2024 18:16:43 +0200
Message-ID: <20240901160809.471483953@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 60a7d0ce30804..fcf967286e37c 100644
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
@@ -30,8 +30,10 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
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
@@ -40,7 +42,7 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = iph->protocol;
-	pkt->thoff = thoff;
+	pkt->thoff = skb_network_offset(pkt->skb) + thoff;
 	pkt->fragoff = ntohs(iph->frag_off) & IP_OFFSET;
 
 	return 0;
-- 
2.43.0



