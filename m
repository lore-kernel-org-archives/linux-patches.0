Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624567;
	b=EgRYwPV1+KX0+AhnaM3Bk0sMuOmpwnoHc9p4oRMcOzCQ/tqUcXUhUiYQJY2rMGwiP2kH
	 WXRqx1/LIDkwLTDiQeNPV4HhcwPAtuUPr/VCUsasXwSWrrs9rUGLr8T5o1/gDC0GS3Wco
	 WgIUt+0xFiYpx6YQdzGRr6PFJVpBl0++ELn37HetxehgdeFwoK+Ch74y9fC+1F4y06cyS
	 L+V8eCXjCCy1J1wA5V5xSXwOk42EcSkid40M7V6zfdE7IGm6Vm86weuG30unBRj5U8nJs
	 JolNcFUF8puD4gGaQdtn/2rj6jMeo6/cY1QJyctJ2rABRDAhV3DUYWBra8FWNxDHqaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S/K/z80B4x4+CLNKS6d0URXGLkk00NMWUrXN7jGF4JA=;
	b=3DuPjows44syQstyghwWlI+S/w4yFRIufXhMi7J9Wi3V0cDq1XOrmddfPVfDMrUBwJV8
	 1YY+S6T2+dtgTW12GaI7e3hDE0TleIkBP7r0q3lSp/JcXU7UcYshVxVwxmip8ylrB0pAu
	 ZphKlx+fajy7mBCevrOSHb45s49hKuXjgzM9k7UIOp8ae6P/1y1aKiR78aUfEnOKwpJ79
	 xT8sv63JOUzPDbBF3QB1hm9UHB7NcBQsHQ8hVziq1xADA1kKIJloN3XPBPeTZfAJ3t1bd
	 inwejyoPwOqTqaY4oO6Vi85jEAjwhR/GDjaG+aZt7U4Q79QLXfAXd0u39M2st1VIWHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mxaCTDQE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9CB606A33A;
	Wed, 25 Nov 2026 16:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mxaCTDQE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971F01F000CF;
	Wed, 25 Nov 2026 16:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624567;
	bh=S/K/z80B4x4+CLNKS6d0URXGLkk00NMWUrXN7jGF4JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mxaCTDQE4rPrGbqga189igL2/ggvv5UK0uV9GDzkS2GS/hkvFM7meAc2kJToe7zyd
	 XhVgMvc4V+/0pkblCfV6Sb8n/pCzgPs8qAnmmTdLKQs7SWK/H7u/4eKFExq8PgA2Ke
	 lNBhlCCuxnYRCG4SRZIPaJwHtqxcB1hPN3h780RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/816] netfilter: nf_tables: fix memleak when rule deletion fails with hardware offload
Date: Wed, 25 Nov 2026 15:29:44 +0100
Message-ID: <20261125143854.671080938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit e95b3be75ae0652d40a48a210f0cf5197b3b3783 ]

Allocate flow rule object after transaction has been allocation and rule
deactivation has been performed, otherwise memleak is possible.  Let the
transaction unwind the existing rule deactivation from the abort path,
this needs to update nft_flow_rule_destroy() to skip release if
flow_rule is null.

While at this, remove check for non-null flow_rule in newrule error path
now that nft_flow_rule_destroy() is skipped if flow_rule is null.

Fixes: 63b48c73ff56 ("netfilter: nf_tables_offload: undo updates if transaction fails")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Link: https://patch.msgid.link/20261028062204.1079089-1-hdthky0@gmail.com/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c     | 21 +++++++++------------
 net/netfilter/nf_tables_offload.c |  3 +++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4b6cb990ab743..7553ebdced1d8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -599,16 +599,6 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 	if (trans == NULL)
 		return -ENOMEM;
 
-	if (ctx->chain->flags & NFT_CHAIN_HW_OFFLOAD) {
-		flow = nft_flow_rule_create(ctx->net, rule);
-		if (IS_ERR(flow)) {
-			nft_trans_destroy(trans);
-			return PTR_ERR(flow);
-		}
-
-		nft_trans_flow_rule(trans) = flow;
-	}
-
 	err = nf_tables_delrule_deactivate(ctx, rule);
 	if (err < 0) {
 		nft_trans_destroy(trans);
@@ -616,6 +606,14 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 	}
 	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_PREPARE);
 
+	if (ctx->chain->flags & NFT_CHAIN_HW_OFFLOAD) {
+		flow = nft_flow_rule_create(ctx->net, rule);
+		if (IS_ERR(flow))
+			return PTR_ERR(flow);
+
+		nft_trans_flow_rule(trans) = flow;
+	}
+
 	return 0;
 }
 
@@ -4225,8 +4223,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 err_destroy_flow_rule:
 	nft_use_dec_restore(&chain->use);
 err_destroy_flow:
-	if (flow)
-		nft_flow_rule_destroy(flow);
+	nft_flow_rule_destroy(flow);
 err_release_rule:
 	nft_rule_expr_deactivate(&ctx, rule, NFT_TRANS_PREPARE_ERROR);
 	nf_tables_rule_destroy(&ctx, rule);
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 196dd3c00ad05..7629829c9336e 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -148,6 +148,9 @@ void nft_flow_rule_destroy(struct nft_flow_rule *flow)
 	struct flow_action_entry *entry;
 	int i;
 
+	if (!flow)
+		return;
+
 	flow_action_for_each(i, entry, &flow->rule->action) {
 		switch (entry->id) {
 		case FLOW_ACTION_REDIRECT:
-- 
2.53.0



