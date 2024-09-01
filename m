Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBCF1C68C;
	Sun,  1 Sep 2024 16:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209252; cv=none; b=uj2YdSYOMZsQgCynqEBIUbiM5uPeTI3QdMDEVcgVFIpdLcLcHPsuZWCc9GMCfcX2lxP7u62eNYpf3LQxBFB+q46xiyB0ZOjYTzj42dfd5XRGOQe9ZvQrzSJj3F9hO4gUGskCtOWwEKBjZNIN1jBqW2aLDtL8RZxr/4WNtu8+6X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209252; c=relaxed/simple;
	bh=bKmaNKmQOU+62MXIPRr0INsIYKpt1hir+U1s4/Jlav8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fREvYd/rF3DkJ+M8SyJZun9dHsLODsLgsnXr0+ZRnkZuhm00ij2AgpRQJr5PO91sBa7sLHVgzytzTMO/jAJiFurBWYhVyjLM6Qb7NPyh+YayJVzOBjZmVzcJ/cpmsbElYJFaieJvT1e48XjXRUkXXvizsuifjr/kQaTIUlZjvIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vM6DIdoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vM6DIdoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3357C4CEC8;
	Sun,  1 Sep 2024 16:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209252;
	bh=bKmaNKmQOU+62MXIPRr0INsIYKpt1hir+U1s4/Jlav8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vM6DIdozDoctfXDoIUzfZnNzxpOuD0k3eB6TY7S24UYVI/7P+CUrKVwXZ4BZ13bZU
	 1fWI8X+gLtNXwFnXlxgQg45HfvfIIEO4aYMcsGPdMGMy/8XsdboaWnsZgRSuaTMFis
	 eoMeAYFVWbNhBFd/zlSb0+uYhv8bIQWArxKysbgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 47/71] netfilter: nf_tables_ipv6: consider network offset in netdev/egress validation
Date: Sun,  1 Sep 2024 18:17:52 +0200
Message-ID: <20240901160803.666371913@linuxfoundation.org>
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

[ Upstream commit 70c261d500951cf3ea0fcf32651aab9a65a91471 ]

>From netdev/egress, skb->len can include the ethernet header, therefore,
subtract network offset from skb->len when validating IPv6 packet length.

Fixes: 42df6e1d221d ("netfilter: Introduce egress hook")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables_ipv6.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index ec7eaeaf4f04c..f1d6a65280475 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -31,8 +31,8 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 	struct ipv6hdr *ip6h, _ip6h;
 	unsigned int thoff = 0;
 	unsigned short frag_off;
+	u32 pkt_len, skb_len;
 	int protohdr;
-	u32 pkt_len;
 
 	ip6h = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb),
 				  sizeof(*ip6h), &_ip6h);
@@ -43,7 +43,8 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 		return -1;
 
 	pkt_len = ntohs(ip6h->payload_len);
-	if (pkt_len + sizeof(*ip6h) > pkt->skb->len)
+	skb_len = pkt->skb->len - skb_network_offset(pkt->skb);
+	if (pkt_len + sizeof(*ip6h) > skb_len)
 		return -1;
 
 	protohdr = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &flags);
-- 
2.43.0



