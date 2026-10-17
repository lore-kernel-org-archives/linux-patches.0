Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCC73A5E6F;
	Sat, 17 Oct 2026 18:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260032; cv=none; b=YwJco36KdRTdZQkGDZJjStkqqJw/VuPYZP7FLeVjgQ67a2O7NX6jPMe7xWgclh1Yb3wCWmzo3LRn/R3iJ1c3JRowGPWk6nhnUJwie1gIQzjbTxqjWUNr3IbiFycEyd1lel9hBxXWdSEiPqWgZGwa4z4/N7lLfAg00UFdxNyqyLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260032; c=relaxed/simple;
	bh=7Pqru9kTBnPOihome9nxWToZlKuiS5MaPVxrgydi2To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1wAu9gbsZBKrbwr6JTXJRF0oSJDLNq6bPtz49kyHt3FZNIDPZUMMBmam8KQReRzVfD/zivcXYmzPxd3fUhogkGSEUlooHz48nKsmg8mx1p+owvT7IJniL56JV3TmrUOHASgEXuhpGBV7T/3IeAveEVjcmejtb1GVH2MoMPKXAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFOHnSiP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFOHnSiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A201F000C4;
	Sat, 17 Oct 2026 18:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260031;
	bh=48haBJqxUYlpp1zqyu2IN93Lyp037xc9wqtrcyM15dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fFOHnSiPPTTK88oX2aa2J/1NCJzge1SWoeR93V8SDy6GaboXBKjRTp6aXrgkklRUU
	 DWnR3Tjg+QhRmWWo+GxMzrFU2+shGubz9QHbeMJLoCsfaQtiMg8mnVX8l5BG5dGWk7
	 Tr09ku93wTpnOckWBTLbm13QXfEnkWHwaDbJI6QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1369/1674] netfilter: nf_tables: skip double clone set expressions on element insert
Date: Sat, 17 Oct 2026 18:00:41 +0200
Message-ID: <20261017160506.298533068@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 43559058d21e0493aa220ac167e0279334dea5f9 ]

Both the dynset and newsetelem path clone the existing set expressions
when setting set element expressions if no override expressions are
provided. This results in a double clone, once to clone the template set
expressions then another clone on the new element. Add a flag to
annotate if userspace provides a override expression (ie. expression of
the same type of the set but different configuration), otherwise borrow
the existing expression from the set. Add conditionals to release
expression iif they represent an override. Use this new override_exprs
flag to dump the dynset expression override to userspace.

This simplifies the existing logic and it also fixes a bug with the
connlimit expression which results in a module refcount imbalance
WARNING splat when resorting on the default set expressions.

Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")
Fixes: fca05d4d61e6 ("netfilter: nft_dynset: honor stateful expressions in set definition")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  2 --
 net/netfilter/nf_tables_api.c     | 56 ++++++++++---------------------
 net/netfilter/nft_dynset.c        | 25 ++++++++------
 3 files changed, 33 insertions(+), 50 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index cc52c76a68e88..0a6edf2aec7d2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -855,8 +855,6 @@ void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
 			const u32 *key, const u32 *key_end, const u32 *data,
 			u64 timeout, u64 expiration, gfp_t gfp);
-int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
-			    struct nft_expr *expr_array[]);
 void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
 			       struct nft_set_elem_expr *elem_expr);
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a003839e41d64..a036deb93781a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6466,39 +6466,11 @@ void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
 	kfree(elem);
 }
 
-int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
-			    struct nft_expr *expr_array[])
-{
-	struct nft_expr *expr;
-	int err, i, k;
-
-	for (i = 0; i < set->num_exprs; i++) {
-		expr = kzalloc(set->exprs[i]->ops->size, GFP_KERNEL_ACCOUNT);
-		if (!expr)
-			goto err_expr;
-
-		err = nft_expr_clone(expr, set->exprs[i], GFP_KERNEL_ACCOUNT);
-		if (err < 0) {
-			kfree(expr);
-			goto err_expr;
-		}
-		expr_array[i] = expr;
-	}
-
-	return 0;
-
-err_expr:
-	for (k = i - 1; k >= 0; k--)
-		nft_expr_destroy(ctx, expr_array[k]);
-
-	return -ENOMEM;
-}
-
 static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 				   const struct nft_set_ext_tmpl *tmpl,
 				   const struct nft_set_ext *ext,
 				   struct nft_expr *expr_array[],
-				   u32 num_exprs)
+				   u32 num_exprs, bool override_exprs)
 {
 	struct nft_set_elem_expr *elem_expr = nft_set_ext_expr(ext);
 	u32 len = sizeof(struct nft_set_elem_expr);
@@ -6521,7 +6493,8 @@ static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 			goto err_elem_expr_setup;
 
 		elem_expr->size += expr_array[i]->ops->size;
-		nft_expr_destroy(ctx, expr_array[i]);
+		if (override_exprs)
+			nft_expr_destroy(ctx, expr_array[i]);
 		expr_array[i] = NULL;
 	}
 
@@ -6529,7 +6502,9 @@ static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 
 err_elem_expr_setup:
 	for (; i < num_exprs; i++) {
-		nft_expr_destroy(ctx, expr_array[i]);
+		if (override_exprs)
+			nft_expr_destroy(ctx, expr_array[i]);
+
 		expr_array[i] = NULL;
 	}
 
@@ -6762,6 +6737,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_elem elem;
 	struct nft_set_binding *binding;
 	struct nft_object *obj = NULL;
+	bool override_exprs = false;
 	struct nft_userdata *udata;
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
@@ -6868,6 +6844,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 		expr_array[0] = expr;
 		num_exprs = 1;
+		override_exprs = true;
 
 		if (set->num_exprs && set->exprs[0]->ops != expr->ops) {
 			err = -EOPNOTSUPP;
@@ -6896,6 +6873,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			}
 			expr_array[i] = expr;
 			num_exprs++;
+			override_exprs = true;
 
 			if (set->num_exprs && expr->ops != set->exprs[i]->ops) {
 				err = -EOPNOTSUPP;
@@ -6909,9 +6887,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		}
 	} else if (set->num_exprs > 0 &&
 		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
-		err = nft_set_elem_expr_clone(ctx, set, expr_array);
-		if (err < 0)
-			goto err_set_elem_expr_clone;
+		for (i = 0; i < set->num_exprs; i++)
+			expr_array[i] = set->exprs[i];
 
 		num_exprs = set->num_exprs;
 	}
@@ -7056,7 +7033,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		udata->len = ulen - 1;
 		nla_memcpy(&udata->data, nla[NFTA_SET_ELEM_USERDATA], ulen);
 	}
-	err = nft_set_elem_expr_setup(ctx, &tmpl, ext, expr_array, num_exprs);
+	err = nft_set_elem_expr_setup(ctx, &tmpl, ext, expr_array, num_exprs,
+				      override_exprs);
 	if (err < 0)
 		goto err_elem_free;
 
@@ -7127,9 +7105,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 err_parse_key:
 	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
 err_set_elem_expr:
-	for (i = 0; i < num_exprs && expr_array[i]; i++)
-		nft_expr_destroy(ctx, expr_array[i]);
-err_set_elem_expr_clone:
+	if (override_exprs) {
+		for (i = 0; i < num_exprs && expr_array[i]; i++)
+			nft_expr_destroy(ctx, expr_array[i]);
+	}
+
 	return err;
 }
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index b1c6bb490d462..41a385cc334d6 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -19,7 +19,8 @@ struct nft_dynset {
 	u8				sreg_key;
 	u8				sreg_data;
 	bool				invert;
-	bool				expr;
+	bool				expr:1,
+					override_exprs:1;
 	u8				num_exprs;
 	u64				timeout;
 	struct nft_expr			*expr_array[NFT_SET_EXPR_MAX];
@@ -254,6 +255,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 
 		priv->num_exprs++;
 		priv->expr_array[0] = dynset_expr;
+		priv->override_exprs = true;
 
 		if (set->num_exprs > 1 ||
 		    (set->num_exprs == 1 &&
@@ -286,6 +288,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			}
 			priv->expr_array[i] = dynset_expr;
 			priv->num_exprs++;
+			priv->override_exprs = true;
 
 			if (set->num_exprs) {
 				if (i >= set->num_exprs) {
@@ -304,9 +307,8 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			goto err_expr_free;
 		}
 	} else if (set->num_exprs > 0) {
-		err = nft_set_elem_expr_clone(ctx, set, priv->expr_array);
-		if (err < 0)
-			return err;
+		for (i = 0; i < set->num_exprs; i++)
+			priv->expr_array[i] = set->exprs[i];
 
 		priv->num_exprs = set->num_exprs;
 	}
@@ -339,8 +341,10 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	return 0;
 
 err_expr_free:
-	for (i = 0; i < priv->num_exprs; i++)
-		nft_expr_destroy(ctx, priv->expr_array[i]);
+	if (priv->override_exprs) {
+		for (i = 0; i < priv->num_exprs; i++)
+			nft_expr_destroy(ctx, priv->expr_array[i]);
+	}
 	return err;
 }
 
@@ -367,9 +371,10 @@ static void nft_dynset_destroy(const struct nft_ctx *ctx,
 	struct nft_dynset *priv = nft_expr_priv(expr);
 	int i;
 
-	for (i = 0; i < priv->num_exprs; i++)
-		nft_expr_destroy(ctx, priv->expr_array[i]);
-
+	if (priv->override_exprs) {
+		for (i = 0; i < priv->num_exprs; i++)
+			nft_expr_destroy(ctx, priv->expr_array[i]);
+	}
 	nf_tables_destroy_set(ctx, priv->set);
 }
 
@@ -393,7 +398,7 @@ static int nft_dynset_dump(struct sk_buff *skb,
 			 nf_jiffies64_to_msecs(priv->timeout),
 			 NFTA_DYNSET_PAD))
 		goto nla_put_failure;
-	if (priv->set->num_exprs == 0) {
+	if (priv->set->num_exprs == 0 || priv->override_exprs) {
 		if (priv->num_exprs == 1) {
 			if (nft_expr_dump(skb, NFTA_DYNSET_EXPR,
 					  priv->expr_array[0], reset))
-- 
2.53.0



