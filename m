Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF60B33987;
	Sun,  1 Sep 2024 16:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208057; cv=none; b=JXlVfQ0ujLVme9z7v3Xn29vN2A/OhQKokq9NmBi5Dm9z69Qh8FE9DEx+O5QifF3FtC9YT2hvy3oDcoLIfnpA5k2cdzIedfXZ2K43PhGSHtq3aY1qzWMCfaiAbKaDtp+YlpU8Pvc7hTdOia8ylcgG0/7nbZZj8Ph225UYmys/6QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208057; c=relaxed/simple;
	bh=Bcx0GYRiCnPmKA1+EGohu2qpAj9iGpAmXJC2rMij4u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqlj7kpzOql7HRp5WcMhdUl21TqVOUqJQEiytMX3SYBTK8QJzXBvy1ZUv0CHT6QrTXyzTt7ljNU7QnjjY3NMttUp9FvRR2c5dyFfUeUvpONFah9yAEJn2yQvZbO3X1NqzbW7In74gETCxPhtaptiO8X0HzrlWahZW+lz3ZSlnsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fiIkGI11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fiIkGI11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C431C4CEC3;
	Sun,  1 Sep 2024 16:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208057;
	bh=Bcx0GYRiCnPmKA1+EGohu2qpAj9iGpAmXJC2rMij4u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fiIkGI11ld0JZl59tOoc3cqmA3XHU9Bu/sZFT00p9cxUUhO4lWnYcBi0tuPT9s3bF
	 zWFU5365qVb7+Btn6UdfAtXvMwLTjHiJPqfu2hJkvL0PjyZ9efBZocm/b2WiDZYA17
	 +JYuy4LiVur2MhfAzfgUfvVJzjtnPKvwnN98aphg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 59/93] netfilter: nf_tables_ipv6: consider network offset in netdev/egress validation
Date: Sun,  1 Sep 2024 18:16:46 +0200
Message-ID: <20240901160809.585140942@linuxfoundation.org>
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
index 467d59b9e5334..a0633eeaec977 100644
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



