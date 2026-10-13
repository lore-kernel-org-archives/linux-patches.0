Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BABC43CEF3;
	Tue, 13 Oct 2026 12:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894079; cv=none; b=HuuxvTvdZMrxZfdvLVqItPuTzw9kJuM4Tqd5Ra7ebxyooCfnXAWzVraLTTXrTMMQIdY0ybydngyTNcQTkUStdWe35XLeh5oUc9PFCIY+6qoqjOz0isuWoyWU6zS7XdPviEL04gi7dwpw8fYnzwIzEl/DePP+fv/BR7mkQY53YxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894079; c=relaxed/simple;
	bh=GfVziaYWjGUm+WoBHaVzu6YM14Jwx7CxpW3CoPyOl/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2eNcaIUN8wcFK0tHxQDBq3QwJwEZRjDC/MTuWHTsHXgjlrTiS0SJ/oSDS2bYzNGFYffUe11IdSbgT4mHdvnAfIdTC39YXIMO6gae4cm1+ay3HZuiGRnS+f2FpxvwG1MXTz0AXrSxU78XHcPjjNiiQADxki7LbK/9/sPv6WydEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDDT+87u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDDT+87u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BA51F000FF;
	Tue, 13 Oct 2026 12:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894076;
	bh=Uoj1fXt925EHee+qFfO0oXNCZ/M223nAVr0R76fppHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IDDT+87uRlFMsRZ+cf4fgmf0XvdLQ0zLkr6mBYgXxMyHDMgqZg4ByveG9smIn3zu/
	 RVddWNVU8TDvgGSU00yq25JyxWuGmiGui1hCynlJAIMH06Xtd7QZ9M1pFvQrPTconT
	 1IG3STwq+y8jlKjPvfGs841jKbbXZ0t8b1dBwL/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 395/621] netfilter: nf_tables: skip double clone set expressions on element insert
Date: Tue, 13 Oct 2026 13:36:30 +0200
Message-ID: <20261013112930.218027557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 83d51da1fbe9d..4c691d5e4ae9b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -867,8 +867,6 @@ struct nft_elem_priv *nft_set_elem_init(const struct nft_set *set,
 					const u32 *key, const u32 *key_end,
 					const u32 *data,
 					u64 timeout, u64 expiration, gfp_t gfp);
-int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
-			    struct nft_expr *expr_array[]);
 void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
 			       struct nft_set_elem_expr *elem_expr);
 void nft_set_elem_destroy(const struct nft_set *set,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ba57295020a2d..31c3ff79b2d5c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6906,39 +6906,11 @@ static void nft_trans_elems_destroy(const struct nft_ctx *ctx,
 		nf_tables_set_elem_destroy(ctx, te->set, te->elems[i].priv);
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
@@ -6961,7 +6933,8 @@ static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 			goto err_elem_expr_setup;
 
 		elem_expr->size += expr_array[i]->ops->size;
-		nft_expr_destroy(ctx, expr_array[i]);
+		if (override_exprs)
+			nft_expr_destroy(ctx, expr_array[i]);
 		expr_array[i] = NULL;
 	}
 
@@ -6969,7 +6942,9 @@ static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 
 err_elem_expr_setup:
 	for (; i < num_exprs; i++) {
-		nft_expr_destroy(ctx, expr_array[i]);
+		if (override_exprs)
+			nft_expr_destroy(ctx, expr_array[i]);
+
 		expr_array[i] = NULL;
 	}
 
@@ -7255,6 +7230,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_binding *binding;
 	struct nft_elem_priv *elem_priv;
 	struct nft_object *obj = NULL;
+	bool override_exprs = false;
 	struct nft_userdata *udata;
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
@@ -7360,6 +7336,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 		expr_array[0] = expr;
 		num_exprs = 1;
+		override_exprs = true;
 
 		if (set->num_exprs && set->exprs[0]->ops != expr->ops) {
 			err = -EOPNOTSUPP;
@@ -7388,6 +7365,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			}
 			expr_array[i] = expr;
 			num_exprs++;
+			override_exprs = true;
 
 			if (set->num_exprs && expr->ops != set->exprs[i]->ops) {
 				err = -EOPNOTSUPP;
@@ -7401,9 +7379,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
@@ -7542,7 +7519,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		udata->len = ulen - 1;
 		nla_memcpy(&udata->data, nla[NFTA_SET_ELEM_USERDATA], ulen);
 	}
-	err = nft_set_elem_expr_setup(ctx, &tmpl, ext, expr_array, num_exprs);
+	err = nft_set_elem_expr_setup(ctx, &tmpl, ext, expr_array, num_exprs,
+				      override_exprs);
 	if (err < 0)
 		goto err_elem_free;
 
@@ -7650,9 +7628,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
index 57bf94ae8724a..827bcf4dcd69c 100644
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
@@ -256,6 +257,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 
 		priv->num_exprs++;
 		priv->expr_array[0] = dynset_expr;
+		priv->override_exprs = true;
 
 		if (set->num_exprs > 1 ||
 		    (set->num_exprs == 1 &&
@@ -288,6 +290,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			}
 			priv->expr_array[i] = dynset_expr;
 			priv->num_exprs++;
+			priv->override_exprs = true;
 
 			if (set->num_exprs) {
 				if (i >= set->num_exprs) {
@@ -306,9 +309,8 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
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
@@ -338,8 +340,10 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
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
 
@@ -366,9 +370,10 @@ static void nft_dynset_destroy(const struct nft_ctx *ctx,
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
 
@@ -392,7 +397,7 @@ static int nft_dynset_dump(struct sk_buff *skb,
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



