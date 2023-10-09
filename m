Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EC018E05
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xJjKIxZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5159C433C7;
	Mon,  9 Oct 2023 13:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858538;
	bh=IsJ4WyDJLYA2uxPkpQ5qgBza5NKLwxYIKwYv29uNQzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xJjKIxZcmFFVq0XYnzgtI2QJFYaRKvysqKHQ/2+/A1b9gKjhrWX6mXcAS2Jfvr756
	 cIluP1VxQYCgpYPsgHDFvBsNMtONbV7HKJNEGxu+JqtejIpMUulkYe4MIMC8EASTBZ
	 n3yPVJgloy7u5bHQNH14vOcEIZCWO/1B8XbOWDcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/226] netfilter: nf_tables: remove busy mark and gc batch API
Date: Mon,  9 Oct 2023 14:59:42 +0200
Message-ID: <20231009130127.294284441@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit a2dd0233cbc4d8a0abb5f64487487ffc9265beb5 upstream.

Ditch it, it has been replace it by the GC transaction API and it has no
clients anymore.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h | 97 +------------------------------
 net/netfilter/nf_tables_api.c     | 26 +--------
 2 files changed, 5 insertions(+), 118 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 39a0b37e8a1a2..9182b583d4297 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -695,62 +695,6 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
 				const struct nft_set *set, void *elem);
 
-/**
- *	struct nft_set_gc_batch_head - nf_tables set garbage collection batch
- *
- *	@rcu: rcu head
- *	@set: set the elements belong to
- *	@cnt: count of elements
- */
-struct nft_set_gc_batch_head {
-	struct rcu_head			rcu;
-	const struct nft_set		*set;
-	unsigned int			cnt;
-};
-
-#define NFT_SET_GC_BATCH_SIZE	((PAGE_SIZE -				  \
-				  sizeof(struct nft_set_gc_batch_head)) / \
-				 sizeof(void *))
-
-/**
- *	struct nft_set_gc_batch - nf_tables set garbage collection batch
- *
- * 	@head: GC batch head
- * 	@elems: garbage collection elements
- */
-struct nft_set_gc_batch {
-	struct nft_set_gc_batch_head	head;
-	void				*elems[NFT_SET_GC_BATCH_SIZE];
-};
-
-struct nft_set_gc_batch *nft_set_gc_batch_alloc(const struct nft_set *set,
-						gfp_t gfp);
-void nft_set_gc_batch_release(struct rcu_head *rcu);
-
-static inline void nft_set_gc_batch_complete(struct nft_set_gc_batch *gcb)
-{
-	if (gcb != NULL)
-		call_rcu(&gcb->head.rcu, nft_set_gc_batch_release);
-}
-
-static inline struct nft_set_gc_batch *
-nft_set_gc_batch_check(const struct nft_set *set, struct nft_set_gc_batch *gcb,
-		       gfp_t gfp)
-{
-	if (gcb != NULL) {
-		if (gcb->head.cnt + 1 < ARRAY_SIZE(gcb->elems))
-			return gcb;
-		nft_set_gc_batch_complete(gcb);
-	}
-	return nft_set_gc_batch_alloc(set, gfp);
-}
-
-static inline void nft_set_gc_batch_add(struct nft_set_gc_batch *gcb,
-					void *elem)
-{
-	gcb->elems[gcb->head.cnt++] = elem;
-}
-
 struct nft_expr_ops;
 /**
  *	struct nft_expr_type - nf_tables expression type
@@ -1418,47 +1362,12 @@ static inline void nft_set_elem_change_active(const struct net *net,
 
 #endif /* IS_ENABLED(CONFIG_NF_TABLES) */
 
-/*
- * We use a free bit in the genmask field to indicate the element
- * is busy, meaning it is currently being processed either by
- * the netlink API or GC.
- *
- * Even though the genmask is only a single byte wide, this works
- * because the extension structure if fully constant once initialized,
- * so there are no non-atomic write accesses unless it is already
- * marked busy.
- */
-#define NFT_SET_ELEM_BUSY_MASK	(1 << 2)
-
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-#define NFT_SET_ELEM_BUSY_BIT	2
-#elif defined(__BIG_ENDIAN_BITFIELD)
-#define NFT_SET_ELEM_BUSY_BIT	(BITS_PER_LONG - BITS_PER_BYTE + 2)
-#else
-#error
-#endif
-
-static inline int nft_set_elem_mark_busy(struct nft_set_ext *ext)
-{
-	unsigned long *word = (unsigned long *)ext;
-
-	BUILD_BUG_ON(offsetof(struct nft_set_ext, genmask) != 0);
-	return test_and_set_bit(NFT_SET_ELEM_BUSY_BIT, word);
-}
-
-static inline void nft_set_elem_clear_busy(struct nft_set_ext *ext)
-{
-	unsigned long *word = (unsigned long *)ext;
-
-	clear_bit(NFT_SET_ELEM_BUSY_BIT, word);
-}
-
-#define NFT_SET_ELEM_DEAD_MASK	(1 << 3)
+#define NFT_SET_ELEM_DEAD_MASK	(1 << 2)
 
 #if defined(__LITTLE_ENDIAN_BITFIELD)
-#define NFT_SET_ELEM_DEAD_BIT	3
+#define NFT_SET_ELEM_DEAD_BIT	2
 #elif defined(__BIG_ENDIAN_BITFIELD)
-#define NFT_SET_ELEM_DEAD_BIT	(BITS_PER_LONG - BITS_PER_BYTE + 3)
+#define NFT_SET_ELEM_DEAD_BIT	(BITS_PER_LONG - BITS_PER_BYTE + 2)
 #else
 #error
 #endif
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1f06dd065d75e..206755eb35f3a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5637,7 +5637,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_elem_expr;
 	}
 
-	ext->genmask = nft_genmask_cur(ctx->net) | NFT_SET_ELEM_BUSY_MASK;
+	ext->genmask = nft_genmask_cur(ctx->net);
+
 	err = set->ops->insert(ctx->net, set, &elem, &ext2);
 	if (err) {
 		if (err == -EEXIST) {
@@ -5945,29 +5946,6 @@ static int nf_tables_delsetelem(struct net *net, struct sock *nlsk,
 	return err;
 }
 
-void nft_set_gc_batch_release(struct rcu_head *rcu)
-{
-	struct nft_set_gc_batch *gcb;
-	unsigned int i;
-
-	gcb = container_of(rcu, struct nft_set_gc_batch, head.rcu);
-	for (i = 0; i < gcb->head.cnt; i++)
-		nft_set_elem_destroy(gcb->head.set, gcb->elems[i], true);
-	kfree(gcb);
-}
-
-struct nft_set_gc_batch *nft_set_gc_batch_alloc(const struct nft_set *set,
-						gfp_t gfp)
-{
-	struct nft_set_gc_batch *gcb;
-
-	gcb = kzalloc(sizeof(*gcb), gfp);
-	if (gcb == NULL)
-		return gcb;
-	gcb->head.set = set;
-	return gcb;
-}
-
 /*
  * Stateful objects
  */
-- 
2.40.1



