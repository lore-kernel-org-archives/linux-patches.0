Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93649502554;
	Wed, 30 Sep 2026 17:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788927; cv=none; b=mb91DgQOlLEHtVzECHY2f1xwcr0/wZnGNnH20EmXr5ExXoY8+NGiSOtoaUGU5L1DebKnWndpM41J+MnHBjGheonO7o33ZdLBWYYT0pNFu85Fc0VEygLiclc2vrA+G7AoInI92A6cc7WFpm0QnW5U+YxKhZaviRIb9haARrGy8n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788927; c=relaxed/simple;
	bh=9vijwZFPphXZizDrmYZPN53V40t4E+9gJAS2PsMk7f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tueMolrojhBErfudlq30uX4srU10GkFHZ8vzqdf41P2e1b8hUiwJH7TKqQCOWDhVQwh54sbkvCm+DU23OohRVGO0YB6TpKaenEyMtAk8hAE/i6Fc99HSHOFpqu02zSsg3dgpkBYOyuYC5KplpCI723+xkWLwfzibcsJ7virpTWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iENWqvHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iENWqvHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A645B1F000FF;
	Wed, 30 Sep 2026 17:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788926;
	bh=qnt/hBaA39STa7usUKbgUE8/QBdN1CAE5Kp9eqZlWn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iENWqvHB9FD+gznvQ9HJEIKaLE9uB5mApgXWslO0jUz9LjHeaJHMka5oHwhvgJY5v
	 GNTGUYB94nsB2wrBGwqD9ZJNzrNipDBojAcXfisEqfU50FLyrE1VgKt9pwXHrB+KS+
	 5G79Nvgoi82s+P9lNN1+2snx/6pErfDgna2S7eGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Yu Junzhe <junzheyu1@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/877] netfilter: nf_tables: Simplify chain netdev notifier
Date: Wed, 30 Sep 2026 17:20:06 +0200
Message-ID: <20260930152421.072397159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 543f258b7c6ba..19a553550c769 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -319,17 +319,16 @@ static const struct nft_chain_type nft_chain_filter_netdev = {
 };
 
 static void nft_netdev_event(unsigned long event, struct net_device *dev,
-			     struct nft_ctx *ctx)
+			     struct nft_base_chain *basechain)
 {
-	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
 	struct nft_hook *hook;
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
 		if (hook->ops.dev != dev)
 			continue;
 
-		if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
-			nf_unregister_net_hook(ctx->net, &hook->ops);
+		if (!(basechain->chain.table->flags & NFT_TABLE_F_DORMANT))
+			nf_unregister_net_hook(dev_net(dev), &hook->ops);
 
 		list_del_rcu(&hook->list);
 		kfree_rcu(hook, rcu);
@@ -343,25 +342,20 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct nft_base_chain *basechain;
 	struct nftables_pernet *nft_net;
-	struct nft_chain *chain, *nr;
+	struct nft_chain *chain;
 	struct nft_table *table;
-	struct nft_ctx ctx = {
-		.net	= dev_net(dev),
-	};
 
 	if (event != NETDEV_UNREGISTER)
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
 
@@ -370,8 +364,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
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



