Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2582A4BA96;
	Mon,  8 Jan 2024 15:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SC31Kuo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84253C433CA;
	Mon,  8 Jan 2024 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726663;
	bh=2l6ZQbmsNxpK1ak799Dwl7m1/CswxEF0ogI4mhjEGC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SC31Kuo0uSIXHV2oWC2Sle41NNmldcrOmiwl7zboQbQjT3vf0XSFSvQcALseIMG4q
	 0uvfsylFtxY0M80HmohDps8fqgyjdvV4Rhv38lKvfFkAkBwV0gmUdJOBEsJaT61Fm0
	 Yu1hUm7aNCmRQNp46Xj3fooUvzESZikeHws6WDYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/124] netfilter: nf_tables: set transport offset from mac header for netdev/egress
Date: Mon,  8 Jan 2024 16:07:27 +0100
Message-ID: <20240108150603.938636122@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

[ Upstream commit 0ae8e4cca78781401b17721bfb72718fdf7b4912 ]

Before this patch, transport offset (pkt->thoff) provides an offset
relative to the network header. This is fine for the inet families
because skb->data points to the network header in such case. However,
from netdev/egress, skb->data points to the mac header (if available),
thus, pkt->thoff is missing the mac header length.

Add skb_network_offset() to the transport offset (pkt->thoff) for
netdev, so transport header mangling works as expected. Adjust payload
fast eval function to use skb->data now that pkt->thoff provides an
absolute offset. This explains why users report that matching on
egress/netdev works but payload mangling does not.

This patch implicitly fixes payload mangling for IPv4 packets in
netdev/egress given skb_store_bits() requires an offset from skb->data
to reach the transport header.

I suspect that nft_exthdr and the trace infra were also broken from
netdev/egress because they also take skb->data as start, and pkt->thoff
was not correct.

Note that IPv6 is fine because ipv6_find_hdr() already provides a
transport offset starting from skb->data, which includes
skb_network_offset().

The bridge family also uses nft_set_pktinfo_ipv4_validate(), but there
skb_network_offset() is zero, so the update in this patch does not alter
the existing behaviour.

Fixes: 42df6e1d221d ("netfilter: Introduce egress hook")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables_ipv4.h | 2 +-
 net/netfilter/nf_tables_core.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index 947973623dc77..60a7d0ce30804 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -30,7 +30,7 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 		return -1;
 
 	len = iph_totlen(pkt->skb, iph);
-	thoff = iph->ihl * 4;
+	thoff = skb_network_offset(pkt->skb) + (iph->ihl * 4);
 	if (pkt->skb->len < len)
 		return -1;
 	else if (len < thoff)
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 4d0ce12221f66..711c22ab701dd 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -158,7 +158,7 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	else {
 		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			return false;
-		ptr = skb_network_header(skb) + nft_thoff(pkt);
+		ptr = skb->data + nft_thoff(pkt);
 	}
 
 	ptr += priv->offset;
-- 
2.43.0



