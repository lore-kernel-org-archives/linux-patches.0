Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B6319E992;
	Tue, 12 Nov 2024 10:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407660; cv=none; b=jL/e4kY0LBk3TJg2Jvw6RLdLR8BG+vcVOzW6vMWhwrgh3U+oLV0ZgyPsgtWhW+9uO74WsoIJv2QORG/gdx0fei8DeRcXgQqX1ktRTbaaBC4wKxWIn4rtaogxio8sWdmwBaBMmPWYq7N0UwnfrGcZwfF4NKFQA1DrTEVUGv21eLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407660; c=relaxed/simple;
	bh=1VAJVRNvcm1TVFb3xwnI9kuYOvvOBzyZBqr56JMOyiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTRWdgm7uiuXmP0qgwVSDTE/oYyrHaVJt9Fd4U00SzKwcZ+P/3vXZcRFJ9Gy8SmFCJfJD4O6PP2cuitUuoteNyp63agoex6EImKQ+PmSAJU/hd/Ke6/JdmhFksZMdgRwV1xlZI584tuuRgx2wLdZhc0XldJMsWX9LlP9BSUVFuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veIYlb1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veIYlb1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9EAC4CED6;
	Tue, 12 Nov 2024 10:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407660;
	bh=1VAJVRNvcm1TVFb3xwnI9kuYOvvOBzyZBqr56JMOyiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=veIYlb1m3IY6avHnNbNhnuNrxxkh1c1xYFakvy3zhZZySYRIPPlz7BA7c3DfqRbH0
	 lbKkM6qqD1OHnXIZFuTCeH/ZiFhLyp3IbuOjV1KZajwBQj9qt0vb0do7P7RmAlBV+9
	 hQyYyIEPoZCqbnr5oNnc6+R8yojCXHEyhYoPNRlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/119] netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
Date: Tue, 12 Nov 2024 11:20:51 +0100
Message-ID: <20241112101850.363778734@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 8965d42bcf54d42cbc72fe34a9d0ec3f8527debd ]

It would be better to not store nft_ctx inside nft_trans object,
the netlink ctx strucutre is huge and most of its information is
never needed in places that use trans->ctx.

Avoid/reduce its usage if possible, no runtime behaviour change
intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: c03d278fdf35 ("netfilter: nf_tables: wait for rcu grace period on net_device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c     | 17 ++++++++---------
 net/netfilter/nft_immediate.c     |  2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index af62804b27ec7..b5f9ee5810a34 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1157,7 +1157,7 @@ static inline bool nft_chain_is_bound(struct nft_chain *chain)
 
 int nft_chain_add(struct nft_table *table, struct nft_chain *chain);
 void nft_chain_del(struct nft_chain *chain);
-void nf_tables_chain_destroy(struct nft_ctx *ctx);
+void nf_tables_chain_destroy(struct nft_chain *chain);
 
 struct nft_stats {
 	u64			bytes;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index aacb0d7f82e9f..eff94dcb49090 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2068,9 +2068,9 @@ static void nf_tables_chain_free_chain_rules(struct nft_chain *chain)
 	kvfree(chain->blob_next);
 }
 
-void nf_tables_chain_destroy(struct nft_ctx *ctx)
+void nf_tables_chain_destroy(struct nft_chain *chain)
 {
-	struct nft_chain *chain = ctx->chain;
+	const struct nft_table *table = chain->table;
 	struct nft_hook *hook, *next;
 
 	if (WARN_ON(chain->use > 0))
@@ -2082,7 +2082,7 @@ void nf_tables_chain_destroy(struct nft_ctx *ctx)
 	if (nft_is_base_chain(chain)) {
 		struct nft_base_chain *basechain = nft_base_chain(chain);
 
-		if (nft_base_chain_netdev(ctx->family, basechain->ops.hooknum)) {
+		if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {
 			list_for_each_entry_safe(hook, next,
 						 &basechain->hook_list, list) {
 				list_del_rcu(&hook->list);
@@ -2571,7 +2571,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 err_trans:
 	nft_use_dec_restore(&table->use);
 err_destroy_chain:
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(chain);
 
 	return err;
 }
@@ -9415,7 +9415,7 @@ static void nft_commit_release(struct nft_trans *trans)
 		if (nft_trans_chain_update(trans))
 			nft_hooks_destroy(&nft_trans_chain_hooks(trans));
 		else
-			nf_tables_chain_destroy(&trans->ctx);
+			nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
 	case NFT_MSG_DELRULE:
 	case NFT_MSG_DESTROYRULE:
@@ -10406,7 +10406,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		if (nft_trans_chain_update(trans))
 			nft_hooks_destroy(&nft_trans_chain_hooks(trans));
 		else
-			nf_tables_chain_destroy(&trans->ctx);
+			nf_tables_chain_destroy(nft_trans_chain(trans));
 		break;
 	case NFT_MSG_NEWRULE:
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
@@ -11144,7 +11144,7 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 	}
 	nft_chain_del(ctx->chain);
 	nft_use_dec(&ctx->table->use);
-	nf_tables_chain_destroy(ctx);
+	nf_tables_chain_destroy(ctx->chain);
 
 	return 0;
 }
@@ -11219,10 +11219,9 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		nft_obj_destroy(&ctx, obj);
 	}
 	list_for_each_entry_safe(chain, nc, &table->chains, list) {
-		ctx.chain = chain;
 		nft_chain_del(chain);
 		nft_use_dec(&table->use);
-		nf_tables_chain_destroy(&ctx);
+		nf_tables_chain_destroy(chain);
 	}
 	nf_tables_table_destroy(&ctx);
 }
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 6475c7abc1fe3..ac2422c215e54 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -221,7 +221,7 @@ static void nft_immediate_destroy(const struct nft_ctx *ctx,
 			list_del(&rule->list);
 			nf_tables_rule_destroy(&chain_ctx, rule);
 		}
-		nf_tables_chain_destroy(&chain_ctx);
+		nf_tables_chain_destroy(chain);
 		break;
 	default:
 		break;
-- 
2.43.0



