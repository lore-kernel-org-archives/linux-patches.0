Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526ED1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWhGdoYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B93C433C8;
	Wed,  4 Oct 2023 18:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443849;
	bh=LXo/pn2aA1d9APUtcM3+dyn+TQ3zZIli4Zd1g8+3lPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWhGdoYr0SQyXWlEYVMO+OJml4R/nqCsXdkaHjyn0NXrxTFHvpXQxdx4UKVkp3qFZ
	 cbxyZcsTP1l1iUmecwEyZ3X6K95o5mRj1pYM/pnvjESr1AYUnDFZGww5TflX7umTPl
	 GNcA/xOyxOY8k8KUAbNeho0whLN7ojYYf2xzoGGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Rich <kevinrich1337@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 024/321] netfilter: nf_tables: disallow rule removal from chain binding
Date: Wed,  4 Oct 2023 19:52:49 +0200
Message-ID: <20231004175230.286705894@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit f15f29fd4779be8a418b66e9d52979bb6d6c2325 ]

Chain binding only requires the rule addition/insertion command within
the same transaction. Removal of rules from chain bindings within the
same transaction makes no sense, userspace does not utilize this
feature. Replace nft_chain_is_bound() check to nft_chain_binding() in
rule deletion commands. Replace command implies a rule deletion, reject
this command too.

Rule flush command can also safely rely on this nft_chain_binding()
check because unbound chains are not allowed since 62e1e94b246e
("netfilter: nf_tables: reject unbound chain set before commit phase").

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Reported-by: Kevin Rich <kevinrich1337@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1c2fb32bfa5f6..db0a56b2da705 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1432,7 +1432,7 @@ static int nft_flush_table(struct nft_ctx *ctx)
 		if (!nft_is_active_next(ctx->net, chain))
 			continue;
 
-		if (nft_chain_is_bound(chain))
+		if (nft_chain_binding(chain))
 			continue;
 
 		ctx->chain = chain;
@@ -1477,7 +1477,7 @@ static int nft_flush_table(struct nft_ctx *ctx)
 		if (!nft_is_active_next(ctx->net, chain))
 			continue;
 
-		if (nft_chain_is_bound(chain))
+		if (nft_chain_binding(chain))
 			continue;
 
 		ctx->chain = chain;
@@ -2910,6 +2910,9 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
 		return PTR_ERR(chain);
 	}
 
+	if (nft_chain_binding(chain))
+		return -EOPNOTSUPP;
+
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, chain, nla);
 
 	if (nla[NFTA_CHAIN_HOOK]) {
@@ -3968,6 +3971,11 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (info->nlh->nlmsg_flags & NLM_F_REPLACE) {
+		if (nft_chain_binding(chain)) {
+			err = -EOPNOTSUPP;
+			goto err_destroy_flow_rule;
+		}
+
 		err = nft_delrule(&ctx, old_rule);
 		if (err < 0)
 			goto err_destroy_flow_rule;
@@ -4075,7 +4083,7 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 			NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_CHAIN]);
 			return PTR_ERR(chain);
 		}
-		if (nft_chain_is_bound(chain))
+		if (nft_chain_binding(chain))
 			return -EOPNOTSUPP;
 	}
 
@@ -4109,7 +4117,7 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 		list_for_each_entry(chain, &table->chains, list) {
 			if (!nft_is_active_next(net, chain))
 				continue;
-			if (nft_chain_is_bound(chain))
+			if (nft_chain_binding(chain))
 				continue;
 
 			ctx.chain = chain;
@@ -11070,7 +11078,7 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 	ctx.family = table->family;
 	ctx.table = table;
 	list_for_each_entry(chain, &table->chains, list) {
-		if (nft_chain_is_bound(chain))
+		if (nft_chain_binding(chain))
 			continue;
 
 		ctx.chain = chain;
-- 
2.40.1



