Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B941D61B5;
	Wed, 19 Feb 2025 08:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954546; cv=none; b=UcOw36TSvFf109bxB6arVCmW4FAdSTCy5VRsg6dn46opMqeOLyiwAB9A8ffO+VQO2C9/fxpGCZiDtnWBlJDWBzud7ZeLmmzxCvj2yR2yIsskDUpchopYhHFJpsBBku2hmPvW85Bq82romqacaJo6TvjYoxg2LQa/NxcsMnG8sls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954546; c=relaxed/simple;
	bh=Ek4RahccHqYqhbP1np9LYBFo3hF+EojmvqSrzRMQd+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAhqEeYDQvC7kV8ohoLjgfG+79U+DX1T2mH25sFNBtJ+hT3cmQbGzD9zKGMCc9vVJgKGHj+W7oLcD9qkd2eMF6VKNYfqOTrqeivID99vtzKnCRLrQKivrr+nZCmGK0EUwQtqTvrU2tWpM9MbwIOyGtzYTelzCCuq+w6FCBHF70Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGxEtmVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGxEtmVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82150C4CEE6;
	Wed, 19 Feb 2025 08:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954545;
	bh=Ek4RahccHqYqhbP1np9LYBFo3hF+EojmvqSrzRMQd+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGxEtmVhJp0MEjLGOx6b08SFQxQKQiZOY0tfHK3Lf/vh88TphJIFfwI7/x6p2bzlc
	 QAgAuh05w6j8H74eDV+VklnzZYRLmmRS6x+7VDg9NK0vPF01RBbSuEU1Vw7of6Ks2w
	 AMhvVDw6PE69wAQYzWdDt8adBMkP0A/14rYcZkjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 235/274] Revert "net: skb: introduce and use a single page frag cache"
Date: Wed, 19 Feb 2025 09:28:09 +0100
Message-ID: <20250219082618.775483707@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 011b0335903832facca86cd8ed05d7d8d94c9c76 ]

This reverts commit dbae2b062824 ("net: skb: introduce and use a single
page frag cache"). The intended goal of such change was to counter a
performance regression introduced by commit 3226b158e67c ("net: avoid
32 x truesize under-estimation for tiny skbs").

Unfortunately, the blamed commit introduces another regression for the
virtio_net driver. Such a driver calls napi_alloc_skb() with a tiny
size, so that the whole head frag could fit a 512-byte block.

The single page frag cache uses a 1K fragment for such allocation, and
the additional overhead, under small UDP packets flood, makes the page
allocator a bottleneck.

Thanks to commit bf9f1baa279f ("net: add dedicated kmem_cache for
typical/small skb->head"), this revert does not re-introduce the
original regression. Actually, in the relevant test on top of this
revert, I measure a small but noticeable positive delta, just above
noise level.

The revert itself required some additional mangling due to the
introduction of the SKB_HEAD_ALIGN() helper and local lock infra in the
affected code.

Suggested-by: Eric Dumazet <edumazet@google.com>
Fixes: dbae2b062824 ("net: skb: introduce and use a single page frag cache")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Link: https://patch.msgid.link/e649212fde9f0fdee23909ca0d14158d32bb7425.1738877290.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |   1 -
 net/core/dev.c            |  17 +++++++
 net/core/skbuff.c         | 103 ++------------------------------------
 3 files changed, 22 insertions(+), 99 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7966a3d0e5bbc..4cb08af483438 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4048,7 +4048,6 @@ void netif_receive_skb_list(struct list_head *head);
 gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb);
 void napi_gro_flush(struct napi_struct *napi, bool flush_old);
 struct sk_buff *napi_get_frags(struct napi_struct *napi);
-void napi_get_frags_check(struct napi_struct *napi);
 gro_result_t napi_gro_frags(struct napi_struct *napi);
 
 static inline void napi_free_frags(struct napi_struct *napi)
diff --git a/net/core/dev.c b/net/core/dev.c
index 26cce0504f105..571d38ca2bee7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6783,6 +6783,23 @@ netif_napi_dev_list_add(struct net_device *dev, struct napi_struct *napi)
 	list_add_rcu(&napi->dev_list, higher); /* adds after higher */
 }
 
+/* Double check that napi_get_frags() allocates skbs with
+ * skb->head being backed by slab, not a page fragment.
+ * This is to make sure bug fixed in 3226b158e67c
+ * ("net: avoid 32 x truesize under-estimation for tiny skbs")
+ * does not accidentally come back.
+ */
+static void napi_get_frags_check(struct napi_struct *napi)
+{
+	struct sk_buff *skb;
+
+	local_bh_disable();
+	skb = napi_get_frags(napi);
+	WARN_ON_ONCE(skb && skb->head_frag);
+	napi_free_frags(napi);
+	local_bh_enable();
+}
+
 void netif_napi_add_weight_locked(struct net_device *dev,
 				  struct napi_struct *napi,
 				  int (*poll)(struct napi_struct *, int),
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6841e61a6bd0b..b32d4e1fa4428 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -220,67 +220,9 @@ static void skb_under_panic(struct sk_buff *skb, unsigned int sz, void *addr)
 #define NAPI_SKB_CACHE_BULK	16
 #define NAPI_SKB_CACHE_HALF	(NAPI_SKB_CACHE_SIZE / 2)
 
-#if PAGE_SIZE == SZ_4K
-
-#define NAPI_HAS_SMALL_PAGE_FRAG	1
-#define NAPI_SMALL_PAGE_PFMEMALLOC(nc)	((nc).pfmemalloc)
-
-/* specialized page frag allocator using a single order 0 page
- * and slicing it into 1K sized fragment. Constrained to systems
- * with a very limited amount of 1K fragments fitting a single
- * page - to avoid excessive truesize underestimation
- */
-
-struct page_frag_1k {
-	void *va;
-	u16 offset;
-	bool pfmemalloc;
-};
-
-static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp)
-{
-	struct page *page;
-	int offset;
-
-	offset = nc->offset - SZ_1K;
-	if (likely(offset >= 0))
-		goto use_frag;
-
-	page = alloc_pages_node(NUMA_NO_NODE, gfp, 0);
-	if (!page)
-		return NULL;
-
-	nc->va = page_address(page);
-	nc->pfmemalloc = page_is_pfmemalloc(page);
-	offset = PAGE_SIZE - SZ_1K;
-	page_ref_add(page, offset / SZ_1K);
-
-use_frag:
-	nc->offset = offset;
-	return nc->va + offset;
-}
-#else
-
-/* the small page is actually unused in this build; add dummy helpers
- * to please the compiler and avoid later preprocessor's conditionals
- */
-#define NAPI_HAS_SMALL_PAGE_FRAG	0
-#define NAPI_SMALL_PAGE_PFMEMALLOC(nc)	false
-
-struct page_frag_1k {
-};
-
-static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp_mask)
-{
-	return NULL;
-}
-
-#endif
-
 struct napi_alloc_cache {
 	local_lock_t bh_lock;
 	struct page_frag_cache page;
-	struct page_frag_1k page_small;
 	unsigned int skb_count;
 	void *skb_cache[NAPI_SKB_CACHE_SIZE];
 };
@@ -290,23 +232,6 @@ static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache) = {
 	.bh_lock = INIT_LOCAL_LOCK(bh_lock),
 };
 
-/* Double check that napi_get_frags() allocates skbs with
- * skb->head being backed by slab, not a page fragment.
- * This is to make sure bug fixed in 3226b158e67c
- * ("net: avoid 32 x truesize under-estimation for tiny skbs")
- * does not accidentally come back.
- */
-void napi_get_frags_check(struct napi_struct *napi)
-{
-	struct sk_buff *skb;
-
-	local_bh_disable();
-	skb = napi_get_frags(napi);
-	WARN_ON_ONCE(!NAPI_HAS_SMALL_PAGE_FRAG && skb && skb->head_frag);
-	napi_free_frags(napi);
-	local_bh_enable();
-}
-
 void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
 {
 	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
@@ -813,10 +738,8 @@ struct sk_buff *napi_alloc_skb(struct napi_struct *napi, unsigned int len)
 
 	/* If requested length is either too small or too big,
 	 * we use kmalloc() for skb->head allocation.
-	 * When the small frag allocator is available, prefer it over kmalloc
-	 * for small fragments
 	 */
-	if ((!NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) ||
+	if (len <= SKB_WITH_OVERHEAD(1024) ||
 	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
 	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
 		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX | SKB_ALLOC_NAPI,
@@ -826,32 +749,16 @@ struct sk_buff *napi_alloc_skb(struct napi_struct *napi, unsigned int len)
 		goto skb_success;
 	}
 
+	len = SKB_HEAD_ALIGN(len);
+
 	if (sk_memalloc_socks())
 		gfp_mask |= __GFP_MEMALLOC;
 
 	local_lock_nested_bh(&napi_alloc_cache.bh_lock);
 	nc = this_cpu_ptr(&napi_alloc_cache);
-	if (NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) {
-		/* we are artificially inflating the allocation size, but
-		 * that is not as bad as it may look like, as:
-		 * - 'len' less than GRO_MAX_HEAD makes little sense
-		 * - On most systems, larger 'len' values lead to fragment
-		 *   size above 512 bytes
-		 * - kmalloc would use the kmalloc-1k slab for such values
-		 * - Builds with smaller GRO_MAX_HEAD will very likely do
-		 *   little networking, as that implies no WiFi and no
-		 *   tunnels support, and 32 bits arches.
-		 */
-		len = SZ_1K;
 
-		data = page_frag_alloc_1k(&nc->page_small, gfp_mask);
-		pfmemalloc = NAPI_SMALL_PAGE_PFMEMALLOC(nc->page_small);
-	} else {
-		len = SKB_HEAD_ALIGN(len);
-
-		data = page_frag_alloc(&nc->page, len, gfp_mask);
-		pfmemalloc = page_frag_cache_is_pfmemalloc(&nc->page);
-	}
+	data = page_frag_alloc(&nc->page, len, gfp_mask);
+	pfmemalloc = page_frag_cache_is_pfmemalloc(&nc->page);
 	local_unlock_nested_bh(&napi_alloc_cache.bh_lock);
 
 	if (unlikely(!data))
-- 
2.39.5



