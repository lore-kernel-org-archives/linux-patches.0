Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209239;
	b=34VUMf1cqIDI+sL3bj776st+FF06iIVh9CDX0bwSp9HOTsIaFWrerpQoCh2P0pf6wKAV
	 p6UzX+HVItvOCAChb5OcqYsJTENHn7Za/Cf18PTAw079yjjyEcRcXEccWAvAsbvmJccHO
	 xP1LEt8xYMI6MAY24ouCfDKat0TVs251Z9BwM4EjJSB8vnJYUocgZCMi8C418LIu8TPz3
	 xIj0Bi9jNvOa3iQzoEYR4jcbcST9wxo7CZZ6m7nfF15mDefHKFodn+6kxs2w5n/Peq+5r
	 wZyzXY/QcLLG25Omu143h6NFow4EAwfiEuymypoZXbNphw1hpAodlTml1UFxMGQLDvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rsA9y3rscfP2VVewzLyygswpBSCmPkoxPFa7/Uwj0tE=;
	b=UAjS9j19OScUseXRPHSsydMQulKG092tqzxZetIle9OgRWq609SmDZYrbbVxnz8ASv4X
	 7K25IahH0vrmwiEaVuZyWFOoU5YD+N0UmdzqD80D+NrVpXMuU6CjzYQ4rCGDMP+zawkoO
	 KJhxVki49PKF18x97Aft5vLWEadTqve3T931i8LLa6fce97fgdXxMRs9IlIALYs2LlS1o
	 PVaTZTLL3LH5caE0lqt81CmYY+CqbJWOcOVHvlmShXj7bzagoH9eCCt04ZIyo277rQCDc
	 pxHdNa8Fe53UF2EmiH1YaduGCAQlV30zY+GgfKCuK0AQ8jfBG3f8KfGQkCjI9X5UXUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pC4Tzx5k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEEF606A31A;
	Wed, 28 Oct 2026 17:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pC4Tzx5k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2862A1F01825;
	Wed, 28 Oct 2026 17:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209238;
	bh=rsA9y3rscfP2VVewzLyygswpBSCmPkoxPFa7/Uwj0tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pC4Tzx5kgvxhyYDk7bEfFnDzA5N8e5aHAAGAtdleqeEp9Dr44DuELmzpz1jiRMrPJ
	 2haZjfBs9P6r9LqPdQfdX2CtgVaLcUPilUcEUb83qnocprsI1akJRFeJWJYgTwWC3z
	 nxTtPkFJG6EHalIiQcsuC16mutFxnqnHzleVfKjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 401/516] netfilter: nf_tables: fix crash when nf_trace is enabled
Date: Wed, 28 Oct 2026 17:59:13 +0100
Message-ID: <20261028170012.979876664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cc6504628a759..4637163b17bc8 100644
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



