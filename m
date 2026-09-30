Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0913FC5BD;
	Wed, 30 Sep 2026 19:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796688; cv=none; b=mU3tvCexUm2emaPH9Mu2XcsX+PDbncUro8YMH3VIcuDGcE/K+AmW7iRHoLt+uOZtjmUe11yvj47R/zI7h6xnwfd2vJLXbHyrGDXkw1GCkH/0zR8wbCAdlPbolk9eYlVvll4aulluf8Uixpj/R9oGdHVeycpFR+VXz4Zo0JBmQlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796688; c=relaxed/simple;
	bh=qZrtakVy0gt9CIZyR8AuQ7h/PnStdsacPFDG7SyGm4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCtSONvHb0nAywK9/US+J6eu+BsGQOfvsRL4WozaE6BR01VEgcPTWZluU1vedAfm1bhAPXl3MV46pZUf/zgieBxbIY6iMaQRpBueNeLZj5suQAz6usfhbBml4JNHytrMTZyE1ATxABxw1+R2OqAQdihpLPmITcGzEuhxY56M86Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrPGl81m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrPGl81m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668BA1F000FF;
	Wed, 30 Sep 2026 19:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796686;
	bh=FLdcedGTvQbvsD/3ObTiPP5w0MMRJrBYn/2drz6RwY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RrPGl81mlvyFfSxfdVyGrGSZy5WK1d8x1AX07WeBU4pXf1NpE3RwidjjpFMSVimuO
	 NkEaU/ULEPicvHUD6lLoOlwtzpk/jtQ3F6KhP90ZUhBtKqI2GJhK9NqGnGWZR7OFeW
	 BHgTwD7RHcH6kagMEgUNmYFZmWK9K8HKhG2FQyXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Yu Junzhe <junzheyu1@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0956/1193] netfilter: nf_tables: Tolerate chains with no remaining hooks
Date: Wed, 30 Sep 2026 17:27:20 +0200
Message-ID: <20260930152455.481236220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Phil Sutter <phil@nwl.cc>

commit fc0133428e7ad65aa6b7c8e65ccfe86e469e4512 upstream.

Do not drop a netdev-family chain if the last interface it is registered
for vanishes. Users dumping and storing the ruleset upon shutdown to
restore it upon next boot may otherwise lose the chain and all contained
rules. They will still lose the list of devices, a later patch will fix
that. For now, this aligns the event handler's behaviour with that for
flowtables.
The controversal situation at netns exit should be no problem here:
event handler will unregister the hooks, core nftables cleanup code will
drop the chain itself.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Yu Junzhe <junzheyu1@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  2 --
 net/netfilter/nf_tables_api.c     | 41 -------------------------------
 net/netfilter/nft_chain_filter.c  | 29 ++++++----------------
 3 files changed, 7 insertions(+), 65 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4056d22724873..51503170290f4 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1233,8 +1233,6 @@ static inline bool nft_is_base_chain(const struct nft_chain *chain)
 	return chain->flags & NFT_CHAIN_BASE;
 }
 
-int __nft_release_basechain(struct nft_ctx *ctx);
-
 unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
 
 static inline bool nft_use_inc(u32 *use)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a9053667e3702..81d67a4ae8765 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11267,47 +11267,6 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 }
 EXPORT_SYMBOL_GPL(nft_data_dump);
 
-static void __nft_release_basechain_now(struct nft_ctx *ctx)
-{
-	struct nft_rule *rule, *nr;
-
-	list_for_each_entry_safe(rule, nr, &ctx->chain->rules, list) {
-		list_del(&rule->list);
-		nf_tables_rule_release(ctx, rule);
-	}
-	nf_tables_chain_destroy(ctx->chain);
-}
-
-int __nft_release_basechain(struct nft_ctx *ctx)
-{
-	struct nft_rule *rule;
-
-	if (WARN_ON_ONCE(!nft_is_base_chain(ctx->chain)))
-		return 0;
-
-	nf_tables_unregister_hook(ctx->net, ctx->chain->table, ctx->chain);
-	list_for_each_entry(rule, &ctx->chain->rules, list)
-		nft_use_dec(&ctx->chain->use);
-
-	nft_chain_del(ctx->chain);
-	nft_use_dec(&ctx->table->use);
-
-	if (!maybe_get_net(ctx->net)) {
-		__nft_release_basechain_now(ctx);
-		return 0;
-	}
-
-	/* wait for ruleset dumps to complete.  Owning chain is no longer in
-	 * lists, so new dumps can't find any of these rules anymore.
-	 */
-	synchronize_rcu();
-
-	__nft_release_basechain_now(ctx);
-	put_net(ctx->net);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(__nft_release_basechain);
-
 static void __nft_release_hook(struct net *net, struct nft_table *table)
 {
 	struct nft_flowtable *flowtable;
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index d170758a1eb5d..e48de5a2bcbca 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -322,37 +322,22 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 			     struct nft_ctx *ctx)
 {
 	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
-	struct nft_hook *hook, *found = NULL;
-	int n = 0;
+	struct nft_hook *hook;
 
 	if (event != NETDEV_UNREGISTER)
 		return;
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
-		if (hook->ops.dev == dev)
-			found = hook;
-
-		n++;
-	}
-	if (!found)
-		return;
+		if (hook->ops.dev != dev)
+			continue;
 
-	if (n > 1) {
 		if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
-			nf_unregister_net_hook(ctx->net, &found->ops);
+			nf_unregister_net_hook(ctx->net, &hook->ops);
 
-		list_del_rcu(&found->list);
-		kfree_rcu(found, rcu);
-		return;
+		list_del_rcu(&hook->list);
+		kfree_rcu(hook, rcu);
+		break;
 	}
-
-	/* UNREGISTER events are also happening on netns exit.
-	 *
-	 * Although nf_tables core releases all tables/chains, only this event
-	 * handler provides guarantee that hook->ops.dev is still accessible,
-	 * so we cannot skip exiting net namespaces.
-	 */
-	__nft_release_basechain(ctx);
 }
 
 static int nf_tables_netdev_event(struct notifier_block *this,
-- 
2.53.0



