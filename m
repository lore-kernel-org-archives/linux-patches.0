Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211658;
	b=m6MWNSyYHFxStFlDTXZ4HGppX1hODyLrBRmp4/CA8LZ6pGmyW5uLpRXQVH3oUfd8U3ED
	 krDU0i/hSpWOBd2iuRG4ODc6lT3il2onlljgADfQe5Zu+gJ07aZY4qxG5A8DVwNGlbbJC
	 6H8olA6kSQBYyECFWLG6lj1JJDH/JKyiAsQVUugSm28qyBlxJ0LyEZHRbNxiUGAOsiye/
	 pqqtwdxbGPopvKJaA9ISOhdBiUi0BOqKjdqK+4/zuUgXooK9pOdJpRUIOugJy7dDEwGG6
	 Sh23EWUOSMABzzw3yXD1nh1/gER+7fsbtmHOEzndEKvL0Z1t9HZooxNMRIrnYuYhx0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xcsmTlhUWYPqRZGKAAnGqP0dD3I61vYs6C1aZHBdYMc=;
	b=uwWXJU5HsyYKaqa7bqrO/LtdgQkeaMA3UmGdjrKxrXaAr4m1K6p1qESjNDt94TbFgmGC
	 jLW070lJrnihergcMmK8qJsB/rMhB5ysZCtHYQ3N5mtMoS7O9Uo1PanBmfZIGrQDdal7P
	 Opo//brSOzj8CSQ0MrN1gO433fbogcHX37EU2twxw/+PweCxCxGFYrJvnUuVYuFTu+ehz
	 LYCmpxHtCbr8mwBFDW0GYuR9TnUguDpqcEdJZ3xjQe5kN7uVmXf2myVnxEVSNaLSWg+oh
	 cX+cjJCEhiFs507P208IflnKJMqp3qOa+sPV2MCkOU9O9q6gwbNkB8SM16ru5G6SYYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K24MJZho;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBF2606A31A;
	Wed, 28 Oct 2026 18:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K24MJZho
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3701F01825;
	Wed, 28 Oct 2026 18:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211658;
	bh=xcsmTlhUWYPqRZGKAAnGqP0dD3I61vYs6C1aZHBdYMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K24MJZhoJouUSIWCIh3qhB1WDBhlWIXMxVLU1Ev2YfYP3YLt+U9pLOj1aDu4Vttbz
	 4VfuINRUHWQYetFlC29NSwQP6/tySF6lsZJos81teaGs7bstf0KBNFxNJ5sETCUCzc
	 6xHOjm5HyDW/DviZmPBNgNgSq/Yhe9HgxM9n1Zmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 453/571] netfilter: nf_tables: fix crash when nf_trace is enabled
Date: Wed, 28 Oct 2026 18:00:00 +0100
Message-ID: <20261028170018.775821369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 399a14ec7993d605740de7b2cd5c0ce8407d12ed ]

do not access info->pkt when info->trace is not 1.
nft_traceinfo is not initialized, except when tracing is enabled.

The 'nft_trace_enabled' static key cannot be used for this, we must
always check info->trace first.

Pass nft_pktinfo directly to avoid this.

Fixes: e34b9ed96ce3 ("netfilter: nf_tables: avoid skb access on nf_stolen")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_core.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 4ee62c0da1b31..bbbd3bbbd1eaa 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -34,25 +34,23 @@ static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 	nft_trace_notify(info);
 }
 
-static inline void nft_trace_packet(struct nft_traceinfo *info,
+static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
+				    struct nft_traceinfo *info,
 				    const struct nft_chain *chain,
 				    const struct nft_rule *rule,
 				    enum nft_trace_types type)
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
-		const struct nft_pktinfo *pkt = info->pkt;
-
 		info->nf_trace = pkt->skb->nf_trace;
 		info->rule = rule;
 		__nft_trace_packet(info, chain, type);
 	}
 }
 
-static inline void nft_trace_copy_nftrace(struct nft_traceinfo *info)
+static inline void nft_trace_copy_nftrace(const struct nft_pktinfo *pkt,
+					  struct nft_traceinfo *info)
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
-		const struct nft_pktinfo *pkt = info->pkt;
-
 		if (info->trace)
 			info->nf_trace = pkt->skb->nf_trace;
 	}
@@ -96,7 +94,6 @@ static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 					 const struct nft_chain *chain,
 					 const struct nft_regs *regs)
 {
-	const struct nft_pktinfo *pkt = info->pkt;
 	enum nft_trace_types type;
 
 	switch (regs->verdict.code) {
@@ -110,7 +107,9 @@ static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 		break;
 	default:
 		type = NFT_TRACETYPE_RULE;
-		info->nf_trace = pkt->skb->nf_trace;
+
+		if (info->trace)
+			info->nf_trace = info->pkt->skb->nf_trace;
 		break;
 	}
 
@@ -261,10 +260,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		switch (regs.verdict.code) {
 		case NFT_BREAK:
 			regs.verdict.code = NFT_CONTINUE;
-			nft_trace_copy_nftrace(&info);
+			nft_trace_copy_nftrace(pkt, &info);
 			continue;
 		case NFT_CONTINUE:
-			nft_trace_packet(&info, chain, rule,
+			nft_trace_packet(pkt, &info, chain, rule,
 					 NFT_TRACETYPE_RULE);
 			continue;
 		}
@@ -306,7 +305,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		goto next_rule;
 	}
 
-	nft_trace_packet(&info, basechain, NULL, NFT_TRACETYPE_POLICY);
+	nft_trace_packet(pkt, &info, basechain, NULL, NFT_TRACETYPE_POLICY);
 
 	if (static_branch_unlikely(&nft_counters_enabled))
 		nft_update_chain_stats(basechain, pkt);
-- 
2.53.0



