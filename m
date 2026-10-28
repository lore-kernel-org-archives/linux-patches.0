Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216432;
	b=lmPcGt0Aa8IjiXyCm0RN1MldlKj06NrZLCYDyFBvrg/vpMP1Ue+6H2BsOotVhghPAwzD
	 mrN0JfllAhlGWACYcX5mlInWMxA9pKvtkJrMlvJ33DgEGea59X4RlWkCyleep64ItOaJ0
	 nx4zS0HKl9/nW5c2t1AgK4O9eGr8UiZ/iAOa6KbqlXB7XfcPynC3kjtEP86dD0FjORHGh
	 yBk7CDnOz6NnXnUH91RE+8ArwIGQSZufr5bNUPBQkWeRTm7jc1d7sLEvbSb6Iq+l3I7cS
	 p/lFAXa+0TNq5L0zqNO+4NV0QXaG9iFXUVLczDIbbS26HyEvtiLy8sjnlkqO25yMkSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Sd+mnmvt/EwYF+VyMPefnbLQ6Dh2lgPIbPOHoeg1TY=;
	b=wCGA5njLT+NM41+TkKXVFfGCkEegY+KYWdzY+1UZTQpHMUhW4QmFydSYadb0VF/AonPM
	 iiOZzXm+Mwa+gg0gWmkCsnIBl3G8xUTPS8QvTAWr2jnA7I4V7SEGEPXcYRAoLJoRWVTj8
	 fYuxglZL9feKylj5y5dJFW+RynAkEqqbo5ao1RZ1HzWnJwcpcJSYoYAuwwDyUmcS9qt7a
	 /35ntNC47D11uHLtHPwsc1k38dI333VrLukU1YS6u0TstaEvSIojLAsL8eds0VtgO7YHf
	 uSnsMQzFbL2HOxXDPPANSfO3PByq6MW/LiUDGBH/nqv0SWkPISM7tGLLlbpL1zFEVrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zMKX+CRF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AE2606A332;
	Wed, 28 Oct 2026 19:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zMKX+CRF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23B61F01825;
	Wed, 28 Oct 2026 19:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216432;
	bh=7Sd+mnmvt/EwYF+VyMPefnbLQ6Dh2lgPIbPOHoeg1TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zMKX+CRFhE4Cm+c22VJ8bTW3fgmWIqgga3zG834aMiXvdg3MlSQXHHkLFNO2W6M98
	 HmJmgDqakFvVWqH7cKndo4dC8QmakXaJxSEtsz+RzMQbRzMERxrgeDl7AMxXwtISe2
	 VnRcMIHe72BY5FlF1cdLqzQXW4gndF46yUCgcN2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1511/1887] netfilter: nf_tables: skip double clone set expressions on element insert
Date: Wed, 28 Oct 2026 18:00:07 +0100
Message-ID: <20261028170533.850041087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b2e49f3b2bf1c..cdb2e1a344367 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -852,8 +852,6 @@ void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
 			const u32 *key, const u32 *key_end, const u32 *data,
 			u64 timeout, u64 expiration, gfp_t gfp);
-int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
-			    struct nft_expr *expr_array[]);
 void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
 			       struct nft_set_elem_expr *elem_expr);
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1a47904c377f7..99fba693ab4f6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6131,39 +6131,11 @@ void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
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
@@ -6186,7 +6158,8 @@ static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 			goto err_elem_expr_setup;
 
 		elem_expr->size += expr_array[i]->ops->size;
-		nft_expr_destroy(ctx, expr_array[i]);
+		if (override_exprs)
+			nft_expr_destroy(ctx, expr_array[i]);
 		expr_array[i] = NULL;
 	}
 
@@ -6194,7 +6167,9 @@ static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 
 err_elem_expr_setup:
 	for (; i < num_exprs; i++) {
-		nft_expr_destroy(ctx, expr_array[i]);
+		if (override_exprs)
+			nft_expr_destroy(ctx, expr_array[i]);
+
 		expr_array[i] = NULL;
 	}
 
@@ -6427,6 +6402,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_elem elem;
 	struct nft_set_binding *binding;
 	struct nft_object *obj = NULL;
+	bool override_exprs = false;
 	struct nft_userdata *udata;
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
@@ -6533,6 +6509,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 		expr_array[0] = expr;
 		num_exprs = 1;
+		override_exprs = true;
 
 		if (set->num_exprs && set->exprs[0]->ops != expr->ops) {
 			err = -EOPNOTSUPP;
@@ -6561,6 +6538,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			}
 			expr_array[i] = expr;
 			num_exprs++;
+			override_exprs = true;
 
 			if (set->num_exprs && expr->ops != set->exprs[i]->ops) {
 				err = -EOPNOTSUPP;
@@ -6574,9 +6552,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
@@ -6721,7 +6698,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		udata->len = ulen - 1;
 		nla_memcpy(&udata->data, nla[NFTA_SET_ELEM_USERDATA], ulen);
 	}
-	err = nft_set_elem_expr_setup(ctx, &tmpl, ext, expr_array, num_exprs);
+	err = nft_set_elem_expr_setup(ctx, &tmpl, ext, expr_array, num_exprs,
+				      override_exprs);
 	if (err < 0)
 		goto err_elem_free;
 
@@ -6792,9 +6770,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
index cd5ed0b53a90d..a1dfce36b539c 100644
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
 					  priv->expr_array[0]))
-- 
2.53.0



