Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD6F2C9D
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:26 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 647FB1FDFB;
	Wed,  1 Dec 2021 18:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SPx3DlseVfNM6W+nEWZLSU46FE/QGORigx3Jlr4HhP4=;
	b=RV/+Jfq6L0RyciarPaTMs91WA+2Diur8J4IQz1ESyIajtu89AvrH20hweqa3ihL8b99q70
	4oW93GlFpDffI+kXbKAJYWYwQWAyJE3pOTKTwLfMaD5+UA+0P8p39Bcq/Emu7MX6syT8H2
	wLsj9Ciy6ViCgYaX5aM+FAaYzuFBSrI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382518;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SPx3DlseVfNM6W+nEWZLSU46FE/QGORigx3Jlr4HhP4=;
	b=GDiOn8NN3Fe2xmi9XgF7uBhP41j/mWhcrQc/lhUeqCwwsJiadbTfpjANUeuzYq5fz41ztK
	oYDIDJi4/GhpmzCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 39E9E13D9D;
	Wed,  1 Dec 2021 18:15:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id eHGBDba7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:18 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2 18/33] mm/slub: Finish struct page to struct slab conversion
Date: Wed,  1 Dec 2021 19:14:55 +0100
Message-Id: <20211201181510.18784-19-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=14948; h=from:subject; bh=lJ9UFowjKiQmGWlufBKZUEbEAb22GZwvaTQ8SilihOI=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7uGRXJueD2RdCBGmbUfCx9DIyw8K/xwAEFEAK3r NqdbsbGJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7hgAKCRDgIcpz8YmpEK78B/ 4mdFn0m3RjMHaZ/k8PxUR6B1f/sN01H/19sK9fDPFayPtp+kCjagUz3QTB62WBNtl86S5rbnUQDQpI oveSM3vauTEmWbWi+FDB3v4DL2723AJln7PMdaQsCQiQb8ynhHOmduPKLeYqMU7Qs/4pUAdWrpzcRK O2OJ89aG74Ei9HHXX43f3SVC/pvhq6SzzpC+4O86USEpbgJI8Kl0GUWdPOYy2skQdDmxkimLd1dspT KLXc5l7nG3HFH6q2orZkCykDK5YMf9ULHEdNFBag8iuxN1ATxdUsM2eSB5XdSa3evP2+7Tjog/hOVG tsYg+3kt0IaS4WL4GdMff2IIeeNJea
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

Update comments mentioning pages to mention slabs where appropriate. Also some
goto labels.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/slub_def.h |   2 +-
 mm/slub.c                | 105 +++++++++++++++++++--------------------
 2 files changed, 53 insertions(+), 54 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 00d99afe1c0e..8a9c2876ca89 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -99,7 +99,7 @@ struct kmem_cache {
 #ifdef CONFIG_SLUB_CPU_PARTIAL
 	/* Number of per cpu partial objects to keep around */
 	unsigned int cpu_partial;
-	/* Number of per cpu partial pages to keep around */
+	/* Number of per cpu partial slabs to keep around */
 	unsigned int cpu_partial_slabs;
 #endif
 	struct kmem_cache_order_objects oo;
diff --git a/mm/slub.c b/mm/slub.c
index be46a7151e8c..f5344211d8cc 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -48,7 +48,7 @@
  *   1. slab_mutex (Global Mutex)
  *   2. node->list_lock (Spinlock)
  *   3. kmem_cache->cpu_slab->lock (Local lock)
- *   4. slab_lock(page) (Only on some arches or for debugging)
+ *   4. slab_lock(slab) (Only on some arches or for debugging)
  *   5. object_map_lock (Only for debugging)
  *
  *   slab_mutex
@@ -64,19 +64,19 @@
  *
  *   The slab_lock is only used for debugging and on arches that do not
  *   have the ability to do a cmpxchg_double. It only protects:
- *	A. page->freelist	-> List of object free in a page
- *	B. page->inuse		-> Number of objects in use
- *	C. page->objects	-> Number of objects in page
- *	D. page->frozen		-> frozen state
+ *	A. slab->freelist	-> List of free objects in a slab
+ *	B. slab->inuse		-> Number of objects in use
+ *	C. slab->objects	-> Number of objects in slab
+ *	D. slab->frozen		-> frozen state
  *
  *   Frozen slabs
  *
  *   If a slab is frozen then it is exempt from list management. It is not
  *   on any list except per cpu partial list. The processor that froze the
- *   slab is the one who can perform list operations on the page. Other
+ *   slab is the one who can perform list operations on the slab. Other
  *   processors may put objects onto the freelist but the processor that
  *   froze the slab is the only one that can retrieve the objects from the
- *   page's freelist.
+ *   slab's freelist.
  *
  *   list_lock
  *
@@ -135,7 +135,7 @@
  * minimal so we rely on the page allocators per cpu caches for
  * fast frees and allocs.
  *
- * page->frozen		The slab is frozen and exempt from list processing.
+ * slab->frozen		The slab is frozen and exempt from list processing.
  * 			This means that the slab is dedicated to a purpose
  * 			such as satisfying allocations for a specific
  * 			processor. Objects may be freed in the slab while
@@ -250,7 +250,7 @@ static inline bool kmem_cache_has_cpu_partial(struct kmem_cache *s)
 
 #define OO_SHIFT	16
 #define OO_MASK		((1 << OO_SHIFT) - 1)
-#define MAX_OBJS_PER_PAGE	32767 /* since page.objects is u15 */
+#define MAX_OBJS_PER_PAGE	32767 /* since slab.objects is u15 */
 
 /* Internal SLUB flags */
 /* Poison object */
@@ -423,8 +423,8 @@ static void slub_set_cpu_partial(struct kmem_cache *s, unsigned int nr_objects)
 
 	/*
 	 * We take the number of objects but actually limit the number of
-	 * pages on the per cpu partial list, in order to limit excessive
-	 * growth of the list. For simplicity we assume that the pages will
+	 * slabs on the per cpu partial list, in order to limit excessive
+	 * growth of the list. For simplicity we assume that the slabs will
 	 * be half-full.
 	 */
 	nr_slabs = DIV_ROUND_UP(nr_objects * 2, oo_objects(s->oo));
@@ -594,9 +594,9 @@ static inline bool slab_add_kunit_errors(void) { return false; }
 #endif
 
 /*
- * Determine a map of object in use on a page.
+ * Determine a map of objects in use in a slab.
  *
- * Node listlock must be held to guarantee that the page does
+ * Node listlock must be held to guarantee that the slab does
  * not vanish from under us.
  */
 static unsigned long *get_map(struct kmem_cache *s, struct slab *slab)
@@ -1139,7 +1139,7 @@ static int check_slab(struct kmem_cache *s, struct slab *slab)
 }
 
 /*
- * Determine if a certain object on a page is on the freelist. Must hold the
+ * Determine if a certain object in a slab is on the freelist. Must hold the
  * slab lock to guarantee that the chains are in a consistent state.
  */
 static int on_freelist(struct kmem_cache *s, struct slab *slab, void *search)
@@ -2185,7 +2185,7 @@ static void *get_partial_node(struct kmem_cache *s, struct kmem_cache_node *n,
 }
 
 /*
- * Get a page from somewhere. Search in increasing NUMA distances.
+ * Get a slab from somewhere. Search in increasing NUMA distances.
  */
 static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
 			     struct slab **ret_slab)
@@ -2249,7 +2249,7 @@ static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
 }
 
 /*
- * Get a partial page, lock it and return it.
+ * Get a partial slab, lock it and return it.
  */
 static void *get_partial(struct kmem_cache *s, gfp_t flags, int node,
 			 struct slab **ret_slab)
@@ -2341,7 +2341,7 @@ static void init_kmem_cache_cpus(struct kmem_cache *s)
 }
 
 /*
- * Finishes removing the cpu slab. Merges cpu's freelist with page's freelist,
+ * Finishes removing the cpu slab. Merges cpu's freelist with slab's freelist,
  * unfreezes the slabs and puts it on the proper list.
  * Assumes the slab has been already safely taken away from kmem_cache_cpu
  * by the caller.
@@ -2388,18 +2388,18 @@ static void deactivate_slab(struct kmem_cache *s, struct slab *slab,
 	}
 
 	/*
-	 * Stage two: Unfreeze the page while splicing the per-cpu
-	 * freelist to the head of page's freelist.
+	 * Stage two: Unfreeze the slab while splicing the per-cpu
+	 * freelist to the head of slab's freelist.
 	 *
-	 * Ensure that the page is unfrozen while the list presence
+	 * Ensure that the slab is unfrozen while the list presence
 	 * reflects the actual number of objects during unfreeze.
 	 *
 	 * We setup the list membership and then perform a cmpxchg
-	 * with the count. If there is a mismatch then the page
-	 * is not unfrozen but the page is on the wrong list.
+	 * with the count. If there is a mismatch then the slab
+	 * is not unfrozen but the slab is on the wrong list.
 	 *
 	 * Then we restart the process which may have to remove
-	 * the page from the list that we just put it on again
+	 * the slab from the list that we just put it on again
 	 * because the number of objects in the slab may have
 	 * changed.
 	 */
@@ -2427,9 +2427,8 @@ static void deactivate_slab(struct kmem_cache *s, struct slab *slab,
 		if (!lock) {
 			lock = 1;
 			/*
-			 * Taking the spinlock removes the possibility
-			 * that acquire_slab() will see a slab page that
-			 * is frozen
+			 * Taking the spinlock removes the possibility that
+			 * acquire_slab() will see a slab that is frozen
 			 */
 			spin_lock_irqsave(&n->list_lock, flags);
 		}
@@ -2570,8 +2569,8 @@ static void unfreeze_partials_cpu(struct kmem_cache *s,
 }
 
 /*
- * Put a page that was just frozen (in __slab_free|get_partial_node) into a
- * partial page slot if available.
+ * Put a slab that was just frozen (in __slab_free|get_partial_node) into a
+ * partial slab slot if available.
  *
  * If we did not find a slot then simply move all the partials to the
  * per node partial list.
@@ -2842,12 +2841,12 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags)
 }
 
 /*
- * Check the page->freelist of a page and either transfer the freelist to the
- * per cpu freelist or deactivate the page.
+ * Check the slab->freelist and either transfer the freelist to the
+ * per cpu freelist or deactivate the slab.
  *
- * The page is still frozen if the return value is not NULL.
+ * The slab is still frozen if the return value is not NULL.
  *
- * If this function returns NULL then the page has been unfrozen.
+ * If this function returns NULL then the slab has been unfrozen.
  */
 static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
 {
@@ -2903,7 +2902,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 	stat(s, ALLOC_SLOWPATH);
 
-reread_page:
+reread_slab:
 
 	slab = READ_ONCE(c->slab);
 	if (!slab) {
@@ -2940,11 +2939,11 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	if (unlikely(!pfmemalloc_match(slab, gfpflags)))
 		goto deactivate_slab;
 
-	/* must check again c->page in case we got preempted and it changed */
+	/* must check again c->slab in case we got preempted and it changed */
 	local_lock_irqsave(&s->cpu_slab->lock, flags);
 	if (unlikely(slab != c->slab)) {
 		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
-		goto reread_page;
+		goto reread_slab;
 	}
 	freelist = c->freelist;
 	if (freelist)
@@ -2967,8 +2966,8 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 	/*
 	 * freelist is pointing to the list of objects to be used.
-	 * page is pointing to the page from which the objects are obtained.
-	 * That page must be frozen for per cpu allocations to work.
+	 * slab is pointing to the slab from which the objects are obtained.
+	 * That slab must be frozen for per cpu allocations to work.
 	 */
 	VM_BUG_ON(!c->slab->frozen);
 	c->freelist = get_freepointer(s, freelist);
@@ -2981,7 +2980,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	local_lock_irqsave(&s->cpu_slab->lock, flags);
 	if (slab != c->slab) {
 		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
-		goto reread_page;
+		goto reread_slab;
 	}
 	freelist = c->freelist;
 	c->slab = NULL;
@@ -2995,7 +2994,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 		local_lock_irqsave(&s->cpu_slab->lock, flags);
 		if (unlikely(c->slab)) {
 			local_unlock_irqrestore(&s->cpu_slab->lock, flags);
-			goto reread_page;
+			goto reread_slab;
 		}
 		if (unlikely(!slub_percpu_partial(c))) {
 			local_unlock_irqrestore(&s->cpu_slab->lock, flags);
@@ -3014,7 +3013,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 	freelist = get_partial(s, gfpflags, node, &slab);
 	if (freelist)
-		goto check_new_page;
+		goto check_new_slab;
 
 	slub_put_cpu_ptr(s->cpu_slab);
 	slab = new_slab(s, gfpflags, node);
@@ -3026,7 +3025,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	}
 
 	/*
-	 * No other reference to the page yet so we can
+	 * No other reference to the slab yet so we can
 	 * muck around with it freely without cmpxchg
 	 */
 	freelist = slab->freelist;
@@ -3034,7 +3033,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 	stat(s, ALLOC_SLAB);
 
-check_new_page:
+check_new_slab:
 
 	if (kmem_cache_debug(s)) {
 		if (!alloc_debug_processing(s, slab, freelist, addr)) {
@@ -3056,7 +3055,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 		 */
 		goto return_single;
 
-retry_load_page:
+retry_load_slab:
 
 	local_lock_irqsave(&s->cpu_slab->lock, flags);
 	if (unlikely(c->slab)) {
@@ -3073,7 +3072,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 		stat(s, CPUSLAB_FLUSH);
 
-		goto retry_load_page;
+		goto retry_load_slab;
 	}
 	c->slab = slab;
 
@@ -3170,9 +3169,9 @@ static __always_inline void *slab_alloc_node(struct kmem_cache *s,
 	/*
 	 * Irqless object alloc/free algorithm used here depends on sequence
 	 * of fetching cpu_slab's data. tid should be fetched before anything
-	 * on c to guarantee that object and page associated with previous tid
+	 * on c to guarantee that object and slab associated with previous tid
 	 * won't be used with current tid. If we fetch tid first, object and
-	 * page could be one associated with next tid and our alloc/free
+	 * slab could be one associated with next tid and our alloc/free
 	 * request will be failed. In this case, we will retry. So, no problem.
 	 */
 	barrier();
@@ -3296,7 +3295,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_node_trace);
  * have a longer lifetime than the cpu slabs in most processing loads.
  *
  * So we still attempt to reduce cache line usage. Just take the slab
- * lock and free the item. If there is no additional partial page
+ * lock and free the item. If there is no additional partial slab
  * handling required then we can return immediately.
  */
 static void __slab_free(struct kmem_cache *s, struct slab *slab,
@@ -3374,7 +3373,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 			stat(s, FREE_FROZEN);
 		} else if (new.frozen) {
 			/*
-			 * If we just froze the page then put it onto the
+			 * If we just froze the slab then put it onto the
 			 * per cpu partial list.
 			 */
 			put_cpu_partial(s, slab, 1);
@@ -3428,7 +3427,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
  * with all sorts of special processing.
  *
  * Bulk free of a freelist with several objects (all pointing to the
- * same page) possible by specifying head and tail ptr, plus objects
+ * same slab) possible by specifying head and tail ptr, plus objects
  * count (cnt). Bulk free indicated by tail pointer being set.
  */
 static __always_inline void do_slab_free(struct kmem_cache *s,
@@ -4213,7 +4212,7 @@ static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
 #endif
 
 	/*
-	 * The larger the object size is, the more pages we want on the partial
+	 * The larger the object size is, the more slabs we want on the partial
 	 * list to avoid pounding the page allocator excessively.
 	 */
 	set_min_partial(s, ilog2(s->size) / 2);
@@ -4597,12 +4596,12 @@ static int __kmem_cache_do_shrink(struct kmem_cache *s)
 		 * Build lists of slabs to discard or promote.
 		 *
 		 * Note that concurrent frees may occur while we hold the
-		 * list_lock. page->inuse here is the upper limit.
+		 * list_lock. slab->inuse here is the upper limit.
 		 */
 		list_for_each_entry_safe(slab, t, &n->partial, slab_list) {
 			int free = slab->objects - slab->inuse;
 
-			/* Do not reread page->inuse */
+			/* Do not reread slab->inuse */
 			barrier();
 
 			/* We do not keep full slabs on the list */
@@ -5480,7 +5479,7 @@ static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
 			slabs += slab->slabs;
 	}
 
-	/* Approximate half-full pages , see slub_set_cpu_partial() */
+	/* Approximate half-full slabs, see slub_set_cpu_partial() */
 	objects = (slabs * oo_objects(s->oo)) / 2;
 	len += sysfs_emit_at(buf, len, "%d(%d)", objects, slabs);
 
-- 
2.33.1

