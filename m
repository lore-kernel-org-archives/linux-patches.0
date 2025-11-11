Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832BC33BBB5;
	Tue, 11 Nov 2025 01:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823996; cv=none; b=VRUthkA2AFgJ4qLEA9dCzfs1aH/A+kzjeot3Byup1SZVvWyolaVoxGfIYTzLeqcpkUqNbjWfLcLsXZe+SsGGLCHELFKdIXh+V5Lodl0ng9P4IH3apkYZuU9HCP3M9+PF66T2dG76B68WqYth1ju2N7m4P7ECEqTcnC8fOKv0+18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823996; c=relaxed/simple;
	bh=lMtNFKSg09ItOQa8qr7OmUqb0M0Ugl+iXXkxQ0EJCp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ez+Gy+oKtjJaD5RCnqai4SjrE2U2gLYnK1KumPzVfegUGoqdNuHFtoMpVNcejbxWwwDGodLX0bYjU0S0JeD3vKL8TlZ1r/3jPeSKGM466UpS9cyAPYCTMYPClujQj4Tt3t3mSC9RaMYUD2JQL+7IxfOhI73G5NKzGuRhOJNQ7K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWXgVAOT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWXgVAOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E71C116B1;
	Tue, 11 Nov 2025 01:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823996;
	bh=lMtNFKSg09ItOQa8qr7OmUqb0M0Ugl+iXXkxQ0EJCp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWXgVAOTRp+4K1RzMOHOSGSRkm82xv+VUjV0aJmHguvxxWA1KEcW1Yg98xFw/TL8g
	 7K05OYYacZ4BxUFb0jr/YdX//RTPEcfWRJolbJIYh4NNbBtFSvHzzMpZyK0ISaoGDj
	 fdJaD+QRBdXHs/kX34DXDWbN+QRbp5p07Fk4EZyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 417/849] netfilter: nf_tables: all transaction allocations can now sleep
Date: Tue, 11 Nov 2025 09:39:47 +0900
Message-ID: <20251111004546.522844300@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 3d95a2e016abab29ccb6f384576b2038e544a5a8 ]

Now that nft_setelem_flush is not called with rcu read lock held or
disabled softinterrupts anymore this can now use GFP_KERNEL too.

This is the last atomic allocation of transaction elements, so remove
all gfp_t arguments and the wrapper function.

This makes attempts to delete large sets much more reliable, before
this was prone to transient memory allocation failures.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 47 ++++++++++++++---------------------
 1 file changed, 19 insertions(+), 28 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c3c73411c40c4..eed434e0a9702 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -151,12 +151,12 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	bitmap_zero(ctx->reg_inited, NFT_REG32_NUM);
 }
 
-static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
-					     int msg_type, u32 size, gfp_t gfp)
+static struct nft_trans *nft_trans_alloc(const struct nft_ctx *ctx,
+					 int msg_type, u32 size)
 {
 	struct nft_trans *trans;
 
-	trans = kzalloc(size, gfp);
+	trans = kzalloc(size, GFP_KERNEL);
 	if (trans == NULL)
 		return NULL;
 
@@ -172,12 +172,6 @@ static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
 	return trans;
 }
 
-static struct nft_trans *nft_trans_alloc(const struct nft_ctx *ctx,
-					 int msg_type, u32 size)
-{
-	return nft_trans_alloc_gfp(ctx, msg_type, size, GFP_KERNEL);
-}
-
 static struct nft_trans_binding *nft_trans_get_binding(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
@@ -442,8 +436,7 @@ static bool nft_trans_collapse_set_elem_allowed(const struct nft_trans_elem *a,
 
 static bool nft_trans_collapse_set_elem(struct nftables_pernet *nft_net,
 					struct nft_trans_elem *tail,
-					struct nft_trans_elem *trans,
-					gfp_t gfp)
+					struct nft_trans_elem *trans)
 {
 	unsigned int nelems, old_nelems = tail->nelems;
 	struct nft_trans_elem *new_trans;
@@ -466,9 +459,11 @@ static bool nft_trans_collapse_set_elem(struct nftables_pernet *nft_net,
 	/* krealloc might free tail which invalidates list pointers */
 	list_del_init(&tail->nft_trans.list);
 
-	new_trans = krealloc(tail, struct_size(tail, elems, nelems), gfp);
+	new_trans = krealloc(tail, struct_size(tail, elems, nelems),
+			     GFP_KERNEL);
 	if (!new_trans) {
-		list_add_tail(&tail->nft_trans.list, &nft_net->commit_list);
+		list_add_tail(&tail->nft_trans.list,
+			      &nft_net->commit_list);
 		return false;
 	}
 
@@ -484,7 +479,7 @@ static bool nft_trans_collapse_set_elem(struct nftables_pernet *nft_net,
 }
 
 static bool nft_trans_try_collapse(struct nftables_pernet *nft_net,
-				   struct nft_trans *trans, gfp_t gfp)
+				   struct nft_trans *trans)
 {
 	struct nft_trans *tail;
 
@@ -501,7 +496,7 @@ static bool nft_trans_try_collapse(struct nftables_pernet *nft_net,
 	case NFT_MSG_DELSETELEM:
 		return nft_trans_collapse_set_elem(nft_net,
 						   nft_trans_container_elem(tail),
-						   nft_trans_container_elem(trans), gfp);
+						   nft_trans_container_elem(trans));
 	}
 
 	return false;
@@ -537,17 +532,14 @@ static void nft_trans_commit_list_add_tail(struct net *net, struct nft_trans *tr
 	}
 }
 
-static void nft_trans_commit_list_add_elem(struct net *net, struct nft_trans *trans,
-					   gfp_t gfp)
+static void nft_trans_commit_list_add_elem(struct net *net, struct nft_trans *trans)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 
 	WARN_ON_ONCE(trans->msg_type != NFT_MSG_NEWSETELEM &&
 		     trans->msg_type != NFT_MSG_DELSETELEM);
 
-	might_alloc(gfp);
-
-	if (nft_trans_try_collapse(nft_net, trans, gfp)) {
+	if (nft_trans_try_collapse(nft_net, trans)) {
 		kfree(trans);
 		return;
 	}
@@ -7573,7 +7565,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 						}
 
 						ue->priv = elem_priv;
-						nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
+						nft_trans_commit_list_add_elem(ctx->net, trans);
 						goto err_elem_free;
 					}
 				}
@@ -7597,7 +7589,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
-	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
+	nft_trans_commit_list_add_elem(ctx->net, trans);
 	return 0;
 
 err_set_full:
@@ -7863,7 +7855,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	nft_setelem_data_deactivate(ctx->net, set, elem.priv);
 
 	nft_trans_container_elem(trans)->elems[0].priv = elem.priv;
-	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
+	nft_trans_commit_list_add_elem(ctx->net, trans);
 	return 0;
 
 fail_ops:
@@ -7888,9 +7880,8 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 	if (!nft_set_elem_active(ext, iter->genmask))
 		return 0;
 
-	trans = nft_trans_alloc_gfp(ctx, NFT_MSG_DELSETELEM,
-				    struct_size_t(struct nft_trans_elem, elems, 1),
-				    GFP_ATOMIC);
+	trans = nft_trans_alloc(ctx, NFT_MSG_DELSETELEM,
+				struct_size_t(struct nft_trans_elem, elems, 1));
 	if (!trans)
 		return -ENOMEM;
 
@@ -7901,7 +7892,7 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 	nft_trans_elem_set(trans) = set;
 	nft_trans_container_elem(trans)->nelems = 1;
 	nft_trans_container_elem(trans)->elems[0].priv = elem_priv;
-	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_ATOMIC);
+	nft_trans_commit_list_add_elem(ctx->net, trans);
 
 	return 0;
 }
@@ -7918,7 +7909,7 @@ static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
 
 	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
 	nft_trans_container_elem(trans)->elems[0].priv = elem_priv;
-	nft_trans_commit_list_add_elem(ctx->net, trans, GFP_KERNEL);
+	nft_trans_commit_list_add_elem(ctx->net, trans);
 
 	return 0;
 }
-- 
2.51.0



