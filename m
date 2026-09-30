Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115EF3D9526;
	Wed, 30 Sep 2026 19:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796691; cv=none; b=RkcAp99tBZ+epkn37Mn3v9b9lQDGAoMuQn7kQ2zz9SXhVpr5J8wTzfsYVb5T1Buvc2LGmUf+plOavJUBuWV7LFq4a0hiK65ugW1BSkbYorTTbN6RTvdJbmrsAgJ9WlKZxAcZ7AY6hdsfRxNFrgRVq8oF6Yad8q4F5yX2asMDils=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796691; c=relaxed/simple;
	bh=4C15DZFu835J2pQLJiSRbhMOXXz4yu80FDWO6s5VCso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKd6qz8Dn3fE2ZZHoz4kj/OWGdzJ812cxHyoqdx8aPCd2FqGADGK13Q3aI2/3vzfppJeCETQdFgrWuvlMzgohLoVBscj2+I3+z++AqUCPKrIRxUO/kMIhThDVesuifFE0l5gazU5Q2KNT9ZESTZ04T86BwXyeZt1H+97gLjRz+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBsxke1f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBsxke1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1521F000FF;
	Wed, 30 Sep 2026 19:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796689;
	bh=IrUjvwm/UFGcnTzyvWbbzkKxEGkm9awsbgUkwONa4/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KBsxke1fGUUzpLC6GkpRqFnJBRJtZWuJLQNV6hQTgPoffRIALRvUI3skQuK/Rtpli
	 WqJ1OyWagapqa2wPKHSwFGIZtTOd7eWfvdphKdvK5XJAQp2Jck0aMX2ccaxN9LKoA2
	 tLzXJXu+LZgRX7hR9mv/3pBqMYmIIHkO83JqZfMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Yu Junzhe <junzheyu1@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0957/1193] netfilter: nf_tables: Simplify chain netdev notifier
Date: Wed, 30 Sep 2026 17:27:21 +0200
Message-ID: <20260930152455.506417325@linuxfoundation.org>
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

commit 375f222800bc001bb9cbd2baa1daec006430aeba upstream.

With conditional chain deletion gone, callback code simplifies: Instead
of filling an nft_ctx object, just pass basechain to the per-chain
function. Also plain list_for_each_entry() is safe now.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Yu Junzhe <junzheyu1@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_chain_filter.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index e48de5a2bcbca..867ff860c208c 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -319,9 +319,8 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 };
 
 static void nft_netdev_event(unsigned long event, struct net_device *dev,
-			     struct nft_ctx *ctx)
+			     struct nft_base_chain *basechain)
 {
-	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
 	struct nft_hook *hook;
 
 	if (event != NETDEV_UNREGISTER)
@@ -331,8 +330,8 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 		if (hook->ops.dev != dev)
 			continue;
 
-		if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
-			nf_unregister_net_hook(ctx->net, &hook->ops);
+		if (!(basechain->chain.table->flags & NFT_TABLE_F_DORMANT))
+			nf_unregister_net_hook(dev_net(dev), &hook->ops);
 
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
@@ -346,26 +345,21 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct nft_base_chain *basechain;
 	struct nftables_pernet *nft_net;
-	struct nft_chain *chain, *nr;
+	struct nft_chain *chain;
 	struct nft_table *table;
-	struct nft_ctx ctx = {
-		.net	= dev_net(dev),
-	};
 
 	if (event != NETDEV_UNREGISTER &&
 	    event != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
-	nft_net = nft_pernet(ctx.net);
+	nft_net = nft_pernet(dev_net(dev));
 	mutex_lock(&nft_net->commit_mutex);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (table->family != NFPROTO_NETDEV &&
 		    table->family != NFPROTO_INET)
 			continue;
 
-		ctx.family = table->family;
-		ctx.table = table;
-		list_for_each_entry_safe(chain, nr, &table->chains, list) {
+		list_for_each_entry(chain, &table->chains, list) {
 			if (!nft_is_base_chain(chain))
 				continue;
 
@@ -374,8 +368,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 			    basechain->ops.hooknum != NF_INET_INGRESS)
 				continue;
 
-			ctx.chain = chain;
-			nft_netdev_event(event, dev, &ctx);
+			nft_netdev_event(event, dev, basechain);
 		}
 	}
 	mutex_unlock(&nft_net->commit_mutex);
-- 
2.53.0



