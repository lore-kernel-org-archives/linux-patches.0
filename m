Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D011F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7E2C433C9;
	Tue,  1 Aug 2023 09:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881914;
	bh=3Vj2MRMKV3yTa5cT+BUgL4fJJih1jfVifMlINcqFn7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Isb3cqwbJ7eNtBKWscWGhBMBQpC7koEAToDb5eqLg+yHa0xS9CZXLP98e9bgzKeAj
	 6aWe+mVg4j9d6APKDTmEtk6OxHV4rSfrGzFPSFN+wkNTNpM58rL7X8L+w+eDGOYzIP
	 Fu4DPcQN/CufdMkwIDbP1O/4DQHKucHKrfMzUbeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Rich <kevinrich1337@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/155] netfilter: nf_tables: skip immediate deactivate in _PREPARE_ERROR
Date: Tue,  1 Aug 2023 11:19:46 +0200
Message-ID: <20230801091912.793299735@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 0a771f7b266b02d262900c75f1e175c7fe76fec2 ]

On error when building the rule, the immediate expression unbinds the
chain, hence objects can be deactivated by the transaction records.

Otherwise, it is possible to trigger the following warning:

 WARNING: CPU: 3 PID: 915 at net/netfilter/nf_tables_api.c:2013 nf_tables_chain_destroy+0x1f7/0x210 [nf_tables]
 CPU: 3 PID: 915 Comm: chain-bind-err- Not tainted 6.1.39 #1
 RIP: 0010:nf_tables_chain_destroy+0x1f7/0x210 [nf_tables]

Fixes: 4bedf9eee016 ("netfilter: nf_tables: fix chain binding transaction logic")
Reported-by: Kevin Rich <kevinrich1337@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_immediate.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 6b0efab4fad09..6bf1c852e8eaa 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -125,15 +125,27 @@ static void nft_immediate_activate(const struct nft_ctx *ctx,
 	return nft_data_hold(&priv->data, nft_dreg_to_type(priv->dreg));
 }
 
+static void nft_immediate_chain_deactivate(const struct nft_ctx *ctx,
+					   struct nft_chain *chain,
+					   enum nft_trans_phase phase)
+{
+	struct nft_ctx chain_ctx;
+	struct nft_rule *rule;
+
+	chain_ctx = *ctx;
+	chain_ctx.chain = chain;
+
+	list_for_each_entry(rule, &chain->rules, list)
+		nft_rule_expr_deactivate(&chain_ctx, rule, phase);
+}
+
 static void nft_immediate_deactivate(const struct nft_ctx *ctx,
 				     const struct nft_expr *expr,
 				     enum nft_trans_phase phase)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
 	const struct nft_data *data = &priv->data;
-	struct nft_ctx chain_ctx;
 	struct nft_chain *chain;
-	struct nft_rule *rule;
 
 	if (priv->dreg == NFT_REG_VERDICT) {
 		switch (data->verdict.code) {
@@ -143,20 +155,17 @@ static void nft_immediate_deactivate(const struct nft_ctx *ctx,
 			if (!nft_chain_binding(chain))
 				break;
 
-			chain_ctx = *ctx;
-			chain_ctx.chain = chain;
-
-			list_for_each_entry(rule, &chain->rules, list)
-				nft_rule_expr_deactivate(&chain_ctx, rule, phase);
-
 			switch (phase) {
 			case NFT_TRANS_PREPARE_ERROR:
 				nf_tables_unbind_chain(ctx, chain);
-				fallthrough;
+				nft_deactivate_next(ctx->net, chain);
+				break;
 			case NFT_TRANS_PREPARE:
+				nft_immediate_chain_deactivate(ctx, chain, phase);
 				nft_deactivate_next(ctx->net, chain);
 				break;
 			default:
+				nft_immediate_chain_deactivate(ctx, chain, phase);
 				nft_chain_del(chain);
 				chain->bound = false;
 				chain->table->use--;
-- 
2.39.2



