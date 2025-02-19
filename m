Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378181E0DEA;
	Wed, 19 Feb 2025 08:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954586; cv=none; b=cJ+mMgTsqpqWqaq+NAtnJEgOPaStwDKZol28HQgOHAyCiT7Ju4V/MSgkQ5SLNnCGB6nPsKqtHLBmFJGPprKiZwwOWySEPWNAZrWE1at4O4iDIb2UTcGAvRKTtwqFrFFgljeUH1O6QahGKpr/W5lm+0ATGtbjHWihDUkw9tHzm/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954586; c=relaxed/simple;
	bh=U939/yo+vtWzy+WSau7RHZJ0Zt3TPdMvdaGVXAFLHgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4SWJeExtuTHIR6fLG9ztv8DAg9OVfIgJHRhYhVx3mJuOdx8VMdzAuRA3BUbS+m8kpCsP0tiYtF5UJGkhOutLTjVgWkfHVvryhm9/RvvxYqU5wA+2VME4cVCsJRUPcG9S8L/frlRCBMXLZpy03g/V/bIFMKZ8IUbMvZHDex6H7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHgALKNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHgALKNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88A6C4CED1;
	Wed, 19 Feb 2025 08:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954586;
	bh=U939/yo+vtWzy+WSau7RHZJ0Zt3TPdMvdaGVXAFLHgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHgALKNTiZpFhIVJSbPQT8+7QtXLRb7giv4kG/JIOFc+V8xgojjQYe3zkFi4AZxLM
	 x+rlqHJ01hx9oEa6Z0OWBdGLE78zfAaaaKb1FYguZtZYAlqXlqpbpJWwBCZjIi5qQ3
	 ScSba6+zNiEXIm5ZRE/+7/KYiVIiStKBcXeUYIdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 250/274] Reapply "net: skb: introduce and use a single page frag cache"
Date: Wed, 19 Feb 2025 09:28:24 +0100
Message-ID: <20250219082619.362741655@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0892b840318daa6ae739b7cdec5ecdfca4006689 ]

This reverts commit 011b0335903832facca86cd8ed05d7d8d94c9c76.

Sabrina reports that the revert may trigger warnings due to intervening
changes, especially the ability to rise MAX_SKB_FRAGS. Let's drop it
and revisit once that part is also ironed out.

Fixes: 011b03359038 ("Revert "net: skb: introduce and use a single page frag cache"")
Reported-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/6bf54579233038bc0e76056c5ea459872ce362ab.1739375933.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |   1 +
 net/core/dev.c            |  17 -------
 net/core/skbuff.c         | 103 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 99 insertions(+), 22 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4cb08af483438..7966a3d0e5bbc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4048,6 +4048,7 @@ void netif_receive_skb_list(struct list_head *head);
 gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb);
 void napi_gro_flush(struct napi_struct *napi, bool flush_old);
 struct sk_buff *napi_get_frags(struct napi_struct *napi);
+void napi_get_frags_check(struct napi_struct *napi);
 gro_result_t napi_gro_frags(struct napi_struct *napi);
 
 static inline void napi_free_frags(struct napi_struct *napi)
diff --git a/net/core/dev.c b/net/core/dev.c
index 571d38ca2bee7..26cce0504f105 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6783,23 +6783,6 @@ netif_napi_dev_list_add(struct net_device *dev, struct napi_struct *napi)
 	list_add_rcu(&napi->dev_list, higher); /* adds after higher */
 }
 
-/* Double check that napi_get_frags() allocates skbs with
- * skb->head being backed by slab, not a page fragment.
- * This is to make sure bug fixed in 3226b158e67c
- * ("net: avoid 32 x truesize under-estimation for tiny skbs")
- * does not accidentally come back.
- */
-static void napi_get_frags_check(struct napi_struct *napi)
-{
-	struct sk_buff *skb;
-
-	local_bh_disable();
-	skb = napi_get_frags(napi);
-	WARN_ON_ONCE(skb && skb->head_frag);
-	napi_free_frags(napi);
-	local_bh_enable();
-}
-
 void netif_napi_add_weight_locked(struct net_device *dev,
 				  struct napi_struct *napi,
 				  int (*poll)(struct napi_struct *, int),
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b32d4e1fa4428..6841e61a6bd0b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -220,9 +220,67 @@ static void skb_under_panic(struct sk_buff *skb, unsigned int sz, void *addr)
 #define NAPI_SKB_CACHE_BULK	16
 #define NAPI_SKB_CACHE_HALF	(NAPI_SKB_CACHE_SIZE / 2)
 
+#if PAGE_SIZE == SZ_4K
+
+#define NAPI_HAS_SMALL_PAGE_FRAG	1
+#define NAPI_SMALL_PAGE_PFMEMALLOC(nc)	((nc).pfmemalloc)
+
+/* specialized page frag allocator using a single order 0 page
+ * and slicing it into 1K sized fragment. Constrained to systems
+ * with a very limited amount of 1K fragments fitting a single
+ * page - to avoid excessive truesize underestimation
+ */
+
+struct page_frag_1k {
+	void *va;
+	u16 offset;
+	bool pfmemalloc;
+};
+
+static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp)
+{
+	struct page *page;
+	int offset;
+
+	offset = nc->offset - SZ_1K;
+	if (likely(offset >= 0))
+		goto use_frag;
+
+	page = alloc_pages_node(NUMA_NO_NODE, gfp, 0);
+	if (!page)
+		return NULL;
+
+	nc->va = page_address(page);
+	nc->pfmemalloc = page_is_pfmemalloc(page);
+	offset = PAGE_SIZE - SZ_1K;
+	page_ref_add(page, offset / SZ_1K);
+
+use_frag:
+	nc->offset = offset;
+	return nc->va + offset;
+}
+#else
+
+/* the small page is actually unused in this build; add dummy helpers
+ * to please the compiler and avoid later preprocessor's conditionals
+ */
+#define NAPI_HAS_SMALL_PAGE_FRAG	0
+#define NAPI_SMALL_PAGE_PFMEMALLOC(nc)	false
+
+struct page_frag_1k {
+};
+
+static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp_mask)
+{
+	return NULL;
+}
+
+#endif
+
 struct napi_alloc_cache {
 	local_lock_t bh_lock;
 	struct page_frag_cache page;
+	struct page_frag_1k page_small;
 	unsigned int skb_count;
 	void *skb_cache[NAPI_SKB_CACHE_SIZE];
 };
@@ -232,6 +290,23 @@ static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache) = {
 	.bh_lock = INIT_LOCAL_LOCK(bh_lock),
 };
 
+/* Double check that napi_get_frags() allocates skbs with
+ * skb->head being backed by slab, not a page fragment.
+ * This is to make sure bug fixed in 3226b158e67c
+ * ("net: avoid 32 x truesize under-estimation for tiny skbs")
+ * does not accidentally come back.
+ */
+void napi_get_frags_check(struct napi_struct *napi)
+{
+	struct sk_buff *skb;
+
+	local_bh_disable();
+	skb = napi_get_frags(napi);
+	WARN_ON_ONCE(!NAPI_HAS_SMALL_PAGE_FRAG && skb && skb->head_frag);
+	napi_free_frags(napi);
+	local_bh_enable();
+}
+
 void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
 {
 	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
@@ -738,8 +813,10 @@ struct sk_buff *napi_alloc_skb(struct napi_struct *napi, unsigned int len)
 
 	/* If requested length is either too small or too big,
 	 * we use kmalloc() for skb->head allocation.
+	 * When the small frag allocator is available, prefer it over kmalloc
+	 * for small fragments
 	 */
-	if (len <= SKB_WITH_OVERHEAD(1024) ||
+	if ((!NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) ||
 	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
 	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
 		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX | SKB_ALLOC_NAPI,
@@ -749,16 +826,32 @@ struct sk_buff *napi_alloc_skb(struct napi_struct *napi, unsigned int len)
 		goto skb_success;
 	}
 
-	len = SKB_HEAD_ALIGN(len);
-
 	if (sk_memalloc_socks())
 		gfp_mask |= __GFP_MEMALLOC;
 
 	local_lock_nested_bh(&napi_alloc_cache.bh_lock);
 	nc = this_cpu_ptr(&napi_alloc_cache);
+	if (NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) {
+		/* we are artificially inflating the allocation size, but
+		 * that is not as bad as it may look like, as:
+		 * - 'len' less than GRO_MAX_HEAD makes little sense
+		 * - On most systems, larger 'len' values lead to fragment
+		 *   size above 512 bytes
+		 * - kmalloc would use the kmalloc-1k slab for such values
+		 * - Builds with smaller GRO_MAX_HEAD will very likely do
+		 *   little networking, as that implies no WiFi and no
+		 *   tunnels support, and 32 bits arches.
+		 */
+		len = SZ_1K;
 
-	data = page_frag_alloc(&nc->page, len, gfp_mask);
-	pfmemalloc = page_frag_cache_is_pfmemalloc(&nc->page);
+		data = page_frag_alloc_1k(&nc->page_small, gfp_mask);
+		pfmemalloc = NAPI_SMALL_PAGE_PFMEMALLOC(nc->page_small);
+	} else {
+		len = SKB_HEAD_ALIGN(len);
+
+		data = page_frag_alloc(&nc->page, len, gfp_mask);
+		pfmemalloc = page_frag_cache_is_pfmemalloc(&nc->page);
+	}
 	local_unlock_nested_bh(&napi_alloc_cache.bh_lock);
 
 	if (unlikely(!data))
-- 
2.39.5



