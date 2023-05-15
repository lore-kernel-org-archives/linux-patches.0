Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC66FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BFEC433D2;
	Mon, 15 May 2023 16:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169537;
	bh=07W4MZZ8HK+x+MYtjrUtZYJWO2I3AfY2z41xcPwN/xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3MSU5o/QGMiZlppQsnIFMGVwQkMr/zz7yyp7KSP/cx0uXlxYQS6+mdoP//tS9IwE
	 a9ucQuvmp3g/3aN2VCV/7NlsAK4RCv30lh+zJCHG2pW1TvCuzP4k+tETAkeFzonwBi
	 DA9kynA4asaSCbxbuhDCg+AQLWIzi0l5wlAu+kL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 060/246] netfilter: nf_tables: extended netlink error reporting for netdevice
Date: Mon, 15 May 2023 18:24:32 +0200
Message-Id: <20230515161724.380531623@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
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

[ Upstream commit c3c060adc0249355411a93e61888051e6902b8a1 ]

Flowtable and netdev chains are bound to one or several netdevice,
extend netlink error reporting to specify the the netdevice that
triggers the error.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 8509f62b0b07 ("netfilter: nf_tables: hit ENOENT on unexisting chain/flowtable update with missing attributes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 38 ++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 46f60648a57d1..6e027fc9b443f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1955,7 +1955,8 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
 
 static int nf_tables_parse_netdev_hooks(struct net *net,
 					const struct nlattr *attr,
-					struct list_head *hook_list)
+					struct list_head *hook_list,
+					struct netlink_ext_ack *extack)
 {
 	struct nft_hook *hook, *next;
 	const struct nlattr *tmp;
@@ -1969,10 +1970,12 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 
 		hook = nft_netdev_hook_alloc(net, tmp);
 		if (IS_ERR(hook)) {
+			NL_SET_BAD_ATTR(extack, tmp);
 			err = PTR_ERR(hook);
 			goto err_hook;
 		}
 		if (nft_hook_list_find(hook_list, hook)) {
+			NL_SET_BAD_ATTR(extack, tmp);
 			kfree(hook);
 			err = -EEXIST;
 			goto err_hook;
@@ -2005,20 +2008,23 @@ struct nft_chain_hook {
 
 static int nft_chain_parse_netdev(struct net *net,
 				  struct nlattr *tb[],
-				  struct list_head *hook_list)
+				  struct list_head *hook_list,
+				  struct netlink_ext_ack *extack)
 {
 	struct nft_hook *hook;
 	int err;
 
 	if (tb[NFTA_HOOK_DEV]) {
 		hook = nft_netdev_hook_alloc(net, tb[NFTA_HOOK_DEV]);
-		if (IS_ERR(hook))
+		if (IS_ERR(hook)) {
+			NL_SET_BAD_ATTR(extack, tb[NFTA_HOOK_DEV]);
 			return PTR_ERR(hook);
+		}
 
 		list_add_tail(&hook->list, hook_list);
 	} else if (tb[NFTA_HOOK_DEVS]) {
 		err = nf_tables_parse_netdev_hooks(net, tb[NFTA_HOOK_DEVS],
-						   hook_list);
+						   hook_list, extack);
 		if (err < 0)
 			return err;
 
@@ -2086,7 +2092,7 @@ static int nft_chain_parse_hook(struct net *net,
 
 	INIT_LIST_HEAD(&hook->list);
 	if (nft_base_chain_netdev(family, hook->num)) {
-		err = nft_chain_parse_netdev(net, ha, &hook->list);
+		err = nft_chain_parse_netdev(net, ha, &hook->list, extack);
 		if (err < 0) {
 			module_put(type->owner);
 			return err;
@@ -7580,7 +7586,8 @@ static const struct nla_policy nft_flowtable_hook_policy[NFTA_FLOWTABLE_HOOK_MAX
 static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 				    const struct nlattr *attr,
 				    struct nft_flowtable_hook *flowtable_hook,
-				    struct nft_flowtable *flowtable, bool add)
+				    struct nft_flowtable *flowtable,
+				    struct netlink_ext_ack *extack, bool add)
 {
 	struct nlattr *tb[NFTA_FLOWTABLE_HOOK_MAX + 1];
 	struct nft_hook *hook;
@@ -7627,7 +7634,8 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 	if (tb[NFTA_FLOWTABLE_HOOK_DEVS]) {
 		err = nf_tables_parse_netdev_hooks(ctx->net,
 						   tb[NFTA_FLOWTABLE_HOOK_DEVS],
-						   &flowtable_hook->list);
+						   &flowtable_hook->list,
+						   extack);
 		if (err < 0)
 			return err;
 	}
@@ -7770,7 +7778,8 @@ static void nft_flowtable_hooks_destroy(struct list_head *hook_list)
 }
 
 static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
-				struct nft_flowtable *flowtable)
+				struct nft_flowtable *flowtable,
+				struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
@@ -7781,7 +7790,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	int err;
 
 	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, flowtable, false);
+				       &flowtable_hook, flowtable, extack, false);
 	if (err < 0)
 		return err;
 
@@ -7886,7 +7895,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 
 		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
-		return nft_flowtable_update(&ctx, info->nlh, flowtable);
+		return nft_flowtable_update(&ctx, info->nlh, flowtable, extack);
 	}
 
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
@@ -7927,7 +7936,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 		goto err3;
 
 	err = nft_flowtable_parse_hook(&ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, flowtable, true);
+				       &flowtable_hook, flowtable, extack, true);
 	if (err < 0)
 		goto err4;
 
@@ -7979,7 +7988,8 @@ static void nft_flowtable_hook_release(struct nft_flowtable_hook *flowtable_hook
 }
 
 static int nft_delflowtable_hook(struct nft_ctx *ctx,
-				 struct nft_flowtable *flowtable)
+				 struct nft_flowtable *flowtable,
+				 struct netlink_ext_ack *extack)
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
@@ -7989,7 +7999,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	int err;
 
 	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
-				       &flowtable_hook, flowtable, false);
+				       &flowtable_hook, flowtable, extack, false);
 	if (err < 0)
 		return err;
 
@@ -8071,7 +8081,7 @@ static int nf_tables_delflowtable(struct sk_buff *skb,
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 	if (nla[NFTA_FLOWTABLE_HOOK])
-		return nft_delflowtable_hook(&ctx, flowtable);
+		return nft_delflowtable_hook(&ctx, flowtable, extack);
 
 	if (flowtable->use > 0) {
 		NL_SET_BAD_ATTR(extack, attr);
-- 
2.39.2



