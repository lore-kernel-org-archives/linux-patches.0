Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C85DDF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027D4C433EF;
	Mon, 15 May 2023 16:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168542;
	bh=wqPLNHtjJw4WofteTxseRyq7bnkjVWNpglfvo6yA61E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7WyKOYud2R8NFOfUJ33RhQ1Wv6tw3CmITVuJjZwy0NJuey+hK+ssrrmjR6P8Mf/Z
	 WetuVYxuNFn9PpL4A4l41/OVQY+LGuxNtxyfLU8fn0zCuqesd5bgK9ze1FeiZjsjye
	 wxUjj1QSQt8XKor4mavkw3Vp+ybn0XaD2hf00c2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 083/116] netfilter: nf_tables: split set destruction in deactivate and destroy phase
Date: Mon, 15 May 2023 18:26:20 +0200
Message-Id: <20230515161701.035731114@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ backport for 4.14 of cd5125d8f51882279f50506bb9c7e5e89dc9bef3 ]

Splits unbind_set into destroy_set and unbinding operation.

Unbinding removes set from lists (so new transaction would not
find it anymore) but keeps memory allocated (so packet path continues
to work).

Rebind function is added to allow unrolling in case transaction
that wants to remove set is aborted.

Destroy function is added to free the memory, but this could occur
outside of transaction in the future.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  7 +++++-
 net/netfilter/nf_tables_api.c     | 36 +++++++++++++++++++++----------
 net/netfilter/nft_dynset.c        | 21 +++++++++++++++++-
 net/netfilter/nft_lookup.c        | 20 ++++++++++++++++-
 net/netfilter/nft_objref.c        | 20 ++++++++++++++++-
 5 files changed, 89 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3107895115c25..59da90bb840d9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -463,6 +463,9 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding);
 void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 			  struct nft_set_binding *binding);
+void nf_tables_rebind_set(const struct nft_ctx *ctx, struct nft_set *set,
+			  struct nft_set_binding *binding);
+void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set);
 
 /**
  *	enum nft_set_extensions - set extension type IDs
@@ -716,7 +719,9 @@ struct nft_expr_type {
  *	@eval: Expression evaluation function
  *	@size: full expression size, including private data size
  *	@init: initialization function
- *	@destroy: destruction function
+ *	@activate: activate expression in the next generation
+ *	@deactivate: deactivate expression in next generation
+ *	@destroy: destruction function, called after synchronize_rcu
  *	@dump: function to dump parameters
  *	@type: expression type
  *	@validate: validate expression, called during loop detection
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b24c83cf64b97..39416c568d181 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -327,7 +327,7 @@ static int nft_delrule_by_chain(struct nft_ctx *ctx)
 	return 0;
 }
 
-static int nft_trans_set_add(struct nft_ctx *ctx, int msg_type,
+static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
 			     struct nft_set *set)
 {
 	struct nft_trans *trans;
@@ -347,7 +347,7 @@ static int nft_trans_set_add(struct nft_ctx *ctx, int msg_type,
 	return 0;
 }
 
-static int nft_delset(struct nft_ctx *ctx, struct nft_set *set)
+static int nft_delset(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	int err;
 
@@ -3311,13 +3311,6 @@ static void nft_set_destroy(struct nft_set *set)
 	kvfree(set);
 }
 
-static void nf_tables_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
-{
-	list_del_rcu(&set->list);
-	nf_tables_set_notify(ctx, set, NFT_MSG_DELSET, GFP_ATOMIC);
-	nft_set_destroy(set);
-}
-
 static int nf_tables_delset(struct net *net, struct sock *nlsk,
 			    struct sk_buff *skb, const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[],
@@ -3400,17 +3393,38 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 }
 EXPORT_SYMBOL_GPL(nf_tables_bind_set);
 
-void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
+void nf_tables_rebind_set(const struct nft_ctx *ctx, struct nft_set *set,
 			  struct nft_set_binding *binding)
+{
+	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS &&
+	    nft_is_active(ctx->net, set))
+		list_add_tail_rcu(&set->list, &ctx->table->sets);
+
+	list_add_tail_rcu(&binding->list, &set->bindings);
+}
+EXPORT_SYMBOL_GPL(nf_tables_rebind_set);
+
+void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
+		          struct nft_set_binding *binding)
 {
 	list_del_rcu(&binding->list);
 
 	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS &&
 	    nft_is_active(ctx->net, set))
-		nf_tables_set_destroy(ctx, set);
+		list_del_rcu(&set->list);
 }
 EXPORT_SYMBOL_GPL(nf_tables_unbind_set);
 
+void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS &&
+	    nft_is_active(ctx->net, set)) {
+		nf_tables_set_notify(ctx, set, NFT_MSG_DELSET, GFP_ATOMIC);
+		nft_set_destroy(set);
+	}
+}
+EXPORT_SYMBOL_GPL(nf_tables_destroy_set);
+
 const struct nft_set_ext_type nft_set_ext_types[] = {
 	[NFT_SET_EXT_KEY]		= {
 		.align	= __alignof__(u32),
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index f8688f9bf46ca..800ca627a4577 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -223,14 +223,31 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	return err;
 }
 
+static void nft_dynset_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_dynset *priv = nft_expr_priv(expr);
+
+	nf_tables_rebind_set(ctx, priv->set, &priv->binding);
+}
+
+static void nft_dynset_deactivate(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr)
+{
+	struct nft_dynset *priv = nft_expr_priv(expr);
+
+	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+}
+
 static void nft_dynset_destroy(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
 	struct nft_dynset *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
 	if (priv->expr != NULL)
 		nft_expr_destroy(ctx, priv->expr);
+
+	nf_tables_destroy_set(ctx, priv->set);
 }
 
 static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
@@ -267,6 +284,8 @@ static const struct nft_expr_ops nft_dynset_ops = {
 	.eval		= nft_dynset_eval,
 	.init		= nft_dynset_init,
 	.destroy	= nft_dynset_destroy,
+	.activate	= nft_dynset_activate,
+	.deactivate	= nft_dynset_deactivate,
 	.dump		= nft_dynset_dump,
 };
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 44015a151ad69..c34667f4f48a5 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -118,12 +118,28 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
+static void nft_lookup_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_lookup *priv = nft_expr_priv(expr);
+
+	nf_tables_rebind_set(ctx, priv->set, &priv->binding);
+}
+
+static void nft_lookup_deactivate(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr)
+{
+	struct nft_lookup *priv = nft_expr_priv(expr);
+
+	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+}
+
 static void nft_lookup_destroy(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
 	struct nft_lookup *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+	nf_tables_destroy_set(ctx, priv->set);
 }
 
 static int nft_lookup_dump(struct sk_buff *skb, const struct nft_expr *expr)
@@ -151,6 +167,8 @@ static const struct nft_expr_ops nft_lookup_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_lookup)),
 	.eval		= nft_lookup_eval,
 	.init		= nft_lookup_init,
+	.activate	= nft_lookup_activate,
+	.deactivate	= nft_lookup_deactivate,
 	.destroy	= nft_lookup_destroy,
 	.dump		= nft_lookup_dump,
 };
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 7bcdc48f3d737..d289fa5e4eb96 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -154,12 +154,28 @@ static int nft_objref_map_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static void nft_objref_map_activate(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr)
+{
+	struct nft_objref_map *priv = nft_expr_priv(expr);
+
+	nf_tables_rebind_set(ctx, priv->set, &priv->binding);
+}
+
+static void nft_objref_map_deactivate(const struct nft_ctx *ctx,
+				      const struct nft_expr *expr)
+{
+	struct nft_objref_map *priv = nft_expr_priv(expr);
+
+	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+}
+
 static void nft_objref_map_destroy(const struct nft_ctx *ctx,
 				   const struct nft_expr *expr)
 {
 	struct nft_objref_map *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+	nf_tables_destroy_set(ctx, priv->set);
 }
 
 static struct nft_expr_type nft_objref_type;
@@ -168,6 +184,8 @@ static const struct nft_expr_ops nft_objref_map_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_objref_map)),
 	.eval		= nft_objref_map_eval,
 	.init		= nft_objref_map_init,
+	.activate	= nft_objref_map_activate,
+	.deactivate	= nft_objref_map_deactivate,
 	.destroy	= nft_objref_map_destroy,
 	.dump		= nft_objref_map_dump,
 };
-- 
2.39.2



