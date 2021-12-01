Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D6B2CAD
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:22 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C6495218CE;
	Wed,  1 Dec 2021 18:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VzmgEJc1EAOd9jiBRWrUyGzh82FQZEqVAVgy6PPb4Kk=;
	b=TAkvG9g7JmF7WPX0fNykBv+QyB/4T4LEYxTR6ZAiYwcEJPx9jw5uCxYwYG0enO6zEeTSaZ
	j10zbrjsMyItF2Zfbm+RSaSAYJA3ZTbh+UO7POHTn7myb4nYgLBwPkZGqzEN1oU4UBv1+7
	CDGSWSWuI3ANJAk1HCDarZ43IItz+9U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382518;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VzmgEJc1EAOd9jiBRWrUyGzh82FQZEqVAVgy6PPb4Kk=;
	b=Wcoxig7KW+BS06cwT3Pfcd/bnHkEqWpG35P/gHfBCd/YO0Cvngqid+XNPb+6Gx9/ugOFVL
	6rejJvDPD1bIFYCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9113F13D9D;
	Wed,  1 Dec 2021 18:15:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id QDXRIra7p2HPSAAAMHmgww
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
	Vlastimil Babka <vbabka@suse.cz>,
	Julia Lawall <julia.lawall@inria.fr>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 20/33] mm/slab: Convert most struct page to struct slab by spatch
Date: Wed,  1 Dec 2021 19:14:57 +0100
Message-Id: <20211201181510.18784-21-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=32919; h=from:subject; bh=TwHW3kDtu2csvye5Vr2IAtz9JdaMvruf3iT9mSFIsDM=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7uLlYbPSCMv8PkN05wgCPp6fQen4yypWB23wwHT zv4xcFaJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7iwAKCRDgIcpz8YmpEAH2B/ 4+BMPKT8ksrcUN08e/kTn6RXkgSfM06z7aLekY7JPRWfyGutOOtn6/MSP1AgqO4CGszi9jViiKtMo9 B+bR5ZYs1pcb7Wl59nA/Xxg2m74o9JVPrc/YveS4AChdvQ9l7vcRf6DCNMLHLVP5NuIomBAmQryuu+ 26gRb5T24vK+Hd8PqRcQb+FjEFSp1r6sdObpXKOhP5UNSWm125DuPzxb0ukKKFaSPSqo8og/EtApI0 U4MQNO4iR/91hT8+rG/hNczRbFVG9WTo/NzCN64KF4yCZMiorktabwI7iipFxZxJ5utwovwRcf0ZNA U6NOmqrYzEw8UZGlv2IHWm5r+yVUAR
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

The majority of conversion from struct page to struct slab in SLAB internals
can be delegated to a coccinelle semantic patch. This includes renaming of
variables with 'page' in name to 'slab', and similar.

Big thanks to Julia Lawall and Luis Chamberlain for help with coccinelle.

// Options: --include-headers --no-includes --smpl-spacing mm/slab.c
// Note: needs coccinelle 1.1.1 to avoid breaking whitespace, and ocaml for the
// embedded script script

// build list of functions for applying the next rule
@initialize:ocaml@
@@

let ok_function p =
  not (List.mem (List.hd p).current_element ["kmem_getpages";"kmem_freepages"])

// convert the type in selected functions
@@
position p : script:ocaml() { ok_function p };
@@

- struct page@p
+ struct slab

@@
@@

-PageSlabPfmemalloc(page)
+slab_test_pfmemalloc(slab)

@@
@@

-ClearPageSlabPfmemalloc(page)
+slab_clear_pfmemalloc(slab)

@@
@@

obj_to_index(
 ...,
- page
+ slab_page(slab)
,...)

// for all functions, change any "struct slab *page" parameter to "struct slab
// *slab" in the signature, and generally all occurences of "page" to "slab" in
// the body - with some special cases.
@@
identifier fn;
expression E;
@@

 fn(...,
-   struct slab *page
+   struct slab *slab
    ,...)
 {
<...
(
- int page_node;
+ int slab_node;
|
- page_node
+ slab_node
|
- page_slab(page)
+ slab
|
- page_address(page)
+ slab_address(slab)
|
- page_size(page)
+ slab_size(slab)
|
- page_to_nid(page)
+ slab_nid(slab)
|
- virt_to_head_page(E)
+ virt_to_slab(E)
|
- page
+ slab
)
...>
 }

// rename a function parameter
@@
identifier fn;
expression E;
@@

 fn(...,
-   int page_node
+   int slab_node
    ,...)
 {
<...
- page_node
+ slab_node
...>
 }

// functions converted by previous rules that were temporarily called using
// slab_page(E) so we want to remove the wrapper now that they accept struct
// slab ptr directly
@@
identifier fn =~ "index_to_obj";
expression E;
@@

 fn(...,
- slab_page(E)
+ E
 ,...)

// functions that were returning struct page ptr and now will return struct
// slab ptr, including slab_page() wrapper removal
@@
identifier fn =~ "cache_grow_begin|get_valid_first_slab|get_first_slab";
expression E;
@@

 fn(...)
 {
<...
- slab_page(E)
+ E
...>
 }

// rename any former struct page * declarations
@@
@@

struct slab *
-page
+slab
;

// all functions (with exceptions) with a local "struct slab *page" variable
// that will be renamed to "struct slab *slab"
@@
identifier fn !~ "kmem_getpages|kmem_freepages";
expression E;
@@

 fn(...)
 {
<...
(
- page_slab(page)
+ slab
|
- page_to_nid(page)
+ slab_nid(slab)
|
- kasan_poison_slab(page)
+ kasan_poison_slab(slab_page(slab))
|
- page_address(page)
+ slab_address(slab)
|
- page_size(page)
+ slab_size(slab)
|
- page->pages
+ slab->slabs
|
- page = virt_to_head_page(E)
+ slab = virt_to_slab(E)
|
- virt_to_head_page(E)
+ virt_to_slab(E)
|
- page
+ slab
)
...>
 }

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Luis Chamberlain <mcgrof@kernel.org>
---
 mm/slab.c | 360 +++++++++++++++++++++++++++---------------------------
 1 file changed, 180 insertions(+), 180 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 892f7042b3b9..970b3e13b4c1 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -218,7 +218,7 @@ static void cache_reap(struct work_struct *unused);
 static inline void fixup_objfreelist_debug(struct kmem_cache *cachep,
 						void **list);
 static inline void fixup_slab_list(struct kmem_cache *cachep,
-				struct kmem_cache_node *n, struct page *page,
+				struct kmem_cache_node *n, struct slab *slab,
 				void **list);
 static int slab_early_init = 1;
 
@@ -373,9 +373,9 @@ static int slab_max_order = SLAB_MAX_ORDER_LO;
 static bool slab_max_order_set __initdata;
 
 static inline void *index_to_obj(struct kmem_cache *cache,
-				 const struct page *page, unsigned int idx)
+				 const struct slab *slab, unsigned int idx)
 {
-	return page->s_mem + cache->size * idx;
+	return slab->s_mem + cache->size * idx;
 }
 
 #define BOOT_CPUCACHE_ENTRIES	1
@@ -550,17 +550,17 @@ static struct array_cache *alloc_arraycache(int node, int entries,
 }
 
 static noinline void cache_free_pfmemalloc(struct kmem_cache *cachep,
-					struct page *page, void *objp)
+					struct slab *slab, void *objp)
 {
 	struct kmem_cache_node *n;
-	int page_node;
+	int slab_node;
 	LIST_HEAD(list);
 
-	page_node = page_to_nid(page);
-	n = get_node(cachep, page_node);
+	slab_node = slab_nid(slab);
+	n = get_node(cachep, slab_node);
 
 	spin_lock(&n->list_lock);
-	free_block(cachep, &objp, 1, page_node, &list);
+	free_block(cachep, &objp, 1, slab_node, &list);
 	spin_unlock(&n->list_lock);
 
 	slabs_destroy(cachep, &list);
@@ -761,7 +761,7 @@ static void drain_alien_cache(struct kmem_cache *cachep,
 }
 
 static int __cache_free_alien(struct kmem_cache *cachep, void *objp,
-				int node, int page_node)
+				int node, int slab_node)
 {
 	struct kmem_cache_node *n;
 	struct alien_cache *alien = NULL;
@@ -770,21 +770,21 @@ static int __cache_free_alien(struct kmem_cache *cachep, void *objp,
 
 	n = get_node(cachep, node);
 	STATS_INC_NODEFREES(cachep);
-	if (n->alien && n->alien[page_node]) {
-		alien = n->alien[page_node];
+	if (n->alien && n->alien[slab_node]) {
+		alien = n->alien[slab_node];
 		ac = &alien->ac;
 		spin_lock(&alien->lock);
 		if (unlikely(ac->avail == ac->limit)) {
 			STATS_INC_ACOVERFLOW(cachep);
-			__drain_alien_cache(cachep, ac, page_node, &list);
+			__drain_alien_cache(cachep, ac, slab_node, &list);
 		}
 		__free_one(ac, objp);
 		spin_unlock(&alien->lock);
 		slabs_destroy(cachep, &list);
 	} else {
-		n = get_node(cachep, page_node);
+		n = get_node(cachep, slab_node);
 		spin_lock(&n->list_lock);
-		free_block(cachep, &objp, 1, page_node, &list);
+		free_block(cachep, &objp, 1, slab_node, &list);
 		spin_unlock(&n->list_lock);
 		slabs_destroy(cachep, &list);
 	}
@@ -1557,18 +1557,18 @@ static void check_poison_obj(struct kmem_cache *cachep, void *objp)
 		/* Print some data about the neighboring objects, if they
 		 * exist:
 		 */
-		struct page *page = virt_to_head_page(objp);
+		struct slab *slab = virt_to_slab(objp);
 		unsigned int objnr;
 
-		objnr = obj_to_index(cachep, page, objp);
+		objnr = obj_to_index(cachep, slab_page(slab), objp);
 		if (objnr) {
-			objp = index_to_obj(cachep, page, objnr - 1);
+			objp = index_to_obj(cachep, slab, objnr - 1);
 			realobj = (char *)objp + obj_offset(cachep);
 			pr_err("Prev obj: start=%px, len=%d\n", realobj, size);
 			print_objinfo(cachep, objp, 2);
 		}
 		if (objnr + 1 < cachep->num) {
-			objp = index_to_obj(cachep, page, objnr + 1);
+			objp = index_to_obj(cachep, slab, objnr + 1);
 			realobj = (char *)objp + obj_offset(cachep);
 			pr_err("Next obj: start=%px, len=%d\n", realobj, size);
 			print_objinfo(cachep, objp, 2);
@@ -1579,17 +1579,17 @@ static void check_poison_obj(struct kmem_cache *cachep, void *objp)
 
 #if DEBUG
 static void slab_destroy_debugcheck(struct kmem_cache *cachep,
-						struct page *page)
+						struct slab *slab)
 {
 	int i;
 
 	if (OBJFREELIST_SLAB(cachep) && cachep->flags & SLAB_POISON) {
-		poison_obj(cachep, page->freelist - obj_offset(cachep),
+		poison_obj(cachep, slab->freelist - obj_offset(cachep),
 			POISON_FREE);
 	}
 
 	for (i = 0; i < cachep->num; i++) {
-		void *objp = index_to_obj(cachep, page, i);
+		void *objp = index_to_obj(cachep, slab, i);
 
 		if (cachep->flags & SLAB_POISON) {
 			check_poison_obj(cachep, objp);
@@ -1605,7 +1605,7 @@ static void slab_destroy_debugcheck(struct kmem_cache *cachep,
 }
 #else
 static void slab_destroy_debugcheck(struct kmem_cache *cachep,
-						struct page *page)
+						struct slab *slab)
 {
 }
 #endif
@@ -1619,16 +1619,16 @@ static void slab_destroy_debugcheck(struct kmem_cache *cachep,
  * Before calling the slab page must have been unlinked from the cache. The
  * kmem_cache_node ->list_lock is not held/needed.
  */
-static void slab_destroy(struct kmem_cache *cachep, struct page *page)
+static void slab_destroy(struct kmem_cache *cachep, struct slab *slab)
 {
 	void *freelist;
 
-	freelist = page->freelist;
-	slab_destroy_debugcheck(cachep, page);
+	freelist = slab->freelist;
+	slab_destroy_debugcheck(cachep, slab);
 	if (unlikely(cachep->flags & SLAB_TYPESAFE_BY_RCU))
-		call_rcu(&page->rcu_head, kmem_rcu_free);
+		call_rcu(&slab->rcu_head, kmem_rcu_free);
 	else
-		kmem_freepages(cachep, page_slab(page));
+		kmem_freepages(cachep, slab);
 
 	/*
 	 * From now on, we don't use freelist
@@ -1644,11 +1644,11 @@ static void slab_destroy(struct kmem_cache *cachep, struct page *page)
  */
 static void slabs_destroy(struct kmem_cache *cachep, struct list_head *list)
 {
-	struct page *page, *n;
+	struct slab *slab, *n;
 
-	list_for_each_entry_safe(page, n, list, slab_list) {
-		list_del(&page->slab_list);
-		slab_destroy(cachep, page);
+	list_for_each_entry_safe(slab, n, list, slab_list) {
+		list_del(&slab->slab_list);
+		slab_destroy(cachep, slab);
 	}
 }
 
@@ -2198,7 +2198,7 @@ static int drain_freelist(struct kmem_cache *cache,
 {
 	struct list_head *p;
 	int nr_freed;
-	struct page *page;
+	struct slab *slab;
 
 	nr_freed = 0;
 	while (nr_freed < tofree && !list_empty(&n->slabs_free)) {
@@ -2210,8 +2210,8 @@ static int drain_freelist(struct kmem_cache *cache,
 			goto out;
 		}
 
-		page = list_entry(p, struct page, slab_list);
-		list_del(&page->slab_list);
+		slab = list_entry(p, struct slab, slab_list);
+		list_del(&slab->slab_list);
 		n->free_slabs--;
 		n->total_slabs--;
 		/*
@@ -2220,7 +2220,7 @@ static int drain_freelist(struct kmem_cache *cache,
 		 */
 		n->free_objects -= cache->num;
 		spin_unlock_irq(&n->list_lock);
-		slab_destroy(cache, page);
+		slab_destroy(cache, slab);
 		nr_freed++;
 	}
 out:
@@ -2295,14 +2295,14 @@ void __kmem_cache_release(struct kmem_cache *cachep)
  * which are all initialized during kmem_cache_init().
  */
 static void *alloc_slabmgmt(struct kmem_cache *cachep,
-				   struct page *page, int colour_off,
+				   struct slab *slab, int colour_off,
 				   gfp_t local_flags, int nodeid)
 {
 	void *freelist;
-	void *addr = page_address(page);
+	void *addr = slab_address(slab);
 
-	page->s_mem = addr + colour_off;
-	page->active = 0;
+	slab->s_mem = addr + colour_off;
+	slab->active = 0;
 
 	if (OBJFREELIST_SLAB(cachep))
 		freelist = NULL;
@@ -2319,24 +2319,24 @@ static void *alloc_slabmgmt(struct kmem_cache *cachep,
 	return freelist;
 }
 
-static inline freelist_idx_t get_free_obj(struct page *page, unsigned int idx)
+static inline freelist_idx_t get_free_obj(struct slab *slab, unsigned int idx)
 {
-	return ((freelist_idx_t *)page->freelist)[idx];
+	return ((freelist_idx_t *) slab->freelist)[idx];
 }
 
-static inline void set_free_obj(struct page *page,
+static inline void set_free_obj(struct slab *slab,
 					unsigned int idx, freelist_idx_t val)
 {
-	((freelist_idx_t *)(page->freelist))[idx] = val;
+	((freelist_idx_t *)(slab->freelist))[idx] = val;
 }
 
-static void cache_init_objs_debug(struct kmem_cache *cachep, struct page *page)
+static void cache_init_objs_debug(struct kmem_cache *cachep, struct slab *slab)
 {
 #if DEBUG
 	int i;
 
 	for (i = 0; i < cachep->num; i++) {
-		void *objp = index_to_obj(cachep, page, i);
+		void *objp = index_to_obj(cachep, slab, i);
 
 		if (cachep->flags & SLAB_STORE_USER)
 			*dbg_userword(cachep, objp) = NULL;
@@ -2420,17 +2420,17 @@ static freelist_idx_t next_random_slot(union freelist_init_state *state)
 }
 
 /* Swap two freelist entries */
-static void swap_free_obj(struct page *page, unsigned int a, unsigned int b)
+static void swap_free_obj(struct slab *slab, unsigned int a, unsigned int b)
 {
-	swap(((freelist_idx_t *)page->freelist)[a],
-		((freelist_idx_t *)page->freelist)[b]);
+	swap(((freelist_idx_t *) slab->freelist)[a],
+		((freelist_idx_t *) slab->freelist)[b]);
 }
 
 /*
  * Shuffle the freelist initialization state based on pre-computed lists.
  * return true if the list was successfully shuffled, false otherwise.
  */
-static bool shuffle_freelist(struct kmem_cache *cachep, struct page *page)
+static bool shuffle_freelist(struct kmem_cache *cachep, struct slab *slab)
 {
 	unsigned int objfreelist = 0, i, rand, count = cachep->num;
 	union freelist_init_state state;
@@ -2447,7 +2447,7 @@ static bool shuffle_freelist(struct kmem_cache *cachep, struct page *page)
 			objfreelist = count - 1;
 		else
 			objfreelist = next_random_slot(&state);
-		page->freelist = index_to_obj(cachep, page, objfreelist) +
+		slab->freelist = index_to_obj(cachep, slab, objfreelist) +
 						obj_offset(cachep);
 		count--;
 	}
@@ -2458,51 +2458,51 @@ static bool shuffle_freelist(struct kmem_cache *cachep, struct page *page)
 	 */
 	if (!precomputed) {
 		for (i = 0; i < count; i++)
-			set_free_obj(page, i, i);
+			set_free_obj(slab, i, i);
 
 		/* Fisher-Yates shuffle */
 		for (i = count - 1; i > 0; i--) {
 			rand = prandom_u32_state(&state.rnd_state);
 			rand %= (i + 1);
-			swap_free_obj(page, i, rand);
+			swap_free_obj(slab, i, rand);
 		}
 	} else {
 		for (i = 0; i < count; i++)
-			set_free_obj(page, i, next_random_slot(&state));
+			set_free_obj(slab, i, next_random_slot(&state));
 	}
 
 	if (OBJFREELIST_SLAB(cachep))
-		set_free_obj(page, cachep->num - 1, objfreelist);
+		set_free_obj(slab, cachep->num - 1, objfreelist);
 
 	return true;
 }
 #else
 static inline bool shuffle_freelist(struct kmem_cache *cachep,
-				struct page *page)
+				struct slab *slab)
 {
 	return false;
 }
 #endif /* CONFIG_SLAB_FREELIST_RANDOM */
 
 static void cache_init_objs(struct kmem_cache *cachep,
-			    struct page *page)
+			    struct slab *slab)
 {
 	int i;
 	void *objp;
 	bool shuffled;
 
-	cache_init_objs_debug(cachep, page);
+	cache_init_objs_debug(cachep, slab);
 
 	/* Try to randomize the freelist if enabled */
-	shuffled = shuffle_freelist(cachep, page);
+	shuffled = shuffle_freelist(cachep, slab);
 
 	if (!shuffled && OBJFREELIST_SLAB(cachep)) {
-		page->freelist = index_to_obj(cachep, page, cachep->num - 1) +
+		slab->freelist = index_to_obj(cachep, slab, cachep->num - 1) +
 						obj_offset(cachep);
 	}
 
 	for (i = 0; i < cachep->num; i++) {
-		objp = index_to_obj(cachep, page, i);
+		objp = index_to_obj(cachep, slab, i);
 		objp = kasan_init_slab_obj(cachep, objp);
 
 		/* constructor could break poison info */
@@ -2513,48 +2513,48 @@ static void cache_init_objs(struct kmem_cache *cachep,
 		}
 
 		if (!shuffled)
-			set_free_obj(page, i, i);
+			set_free_obj(slab, i, i);
 	}
 }
 
-static void *slab_get_obj(struct kmem_cache *cachep, struct page *page)
+static void *slab_get_obj(struct kmem_cache *cachep, struct slab *slab)
 {
 	void *objp;
 
-	objp = index_to_obj(cachep, page, get_free_obj(page, page->active));
-	page->active++;
+	objp = index_to_obj(cachep, slab, get_free_obj(slab, slab->active));
+	slab->active++;
 
 	return objp;
 }
 
 static void slab_put_obj(struct kmem_cache *cachep,
-			struct page *page, void *objp)
+			struct slab *slab, void *objp)
 {
-	unsigned int objnr = obj_to_index(cachep, page, objp);
+	unsigned int objnr = obj_to_index(cachep, slab_page(slab), objp);
 #if DEBUG
 	unsigned int i;
 
 	/* Verify double free bug */
-	for (i = page->active; i < cachep->num; i++) {
-		if (get_free_obj(page, i) == objnr) {
+	for (i = slab->active; i < cachep->num; i++) {
+		if (get_free_obj(slab, i) == objnr) {
 			pr_err("slab: double free detected in cache '%s', objp %px\n",
 			       cachep->name, objp);
 			BUG();
 		}
 	}
 #endif
-	page->active--;
-	if (!page->freelist)
-		page->freelist = objp + obj_offset(cachep);
+	slab->active--;
+	if (!slab->freelist)
+		slab->freelist = objp + obj_offset(cachep);
 
-	set_free_obj(page, page->active, objnr);
+	set_free_obj(slab, slab->active, objnr);
 }
 
 /*
  * Grow (by 1) the number of slabs within a cache.  This is called by
  * kmem_cache_alloc() when there are no active objs left in a cache.
  */
-static struct page *cache_grow_begin(struct kmem_cache *cachep,
+static struct slab *cache_grow_begin(struct kmem_cache *cachep,
 				gfp_t flags, int nodeid)
 {
 	void *freelist;
@@ -2562,7 +2562,7 @@ static struct page *cache_grow_begin(struct kmem_cache *cachep,
 	gfp_t local_flags;
 	int page_node;
 	struct kmem_cache_node *n;
-	struct page *page;
+	struct slab *slab;
 
 	/*
 	 * Be lazy and only check for valid flags here,  keeping it out of the
@@ -2582,11 +2582,11 @@ static struct page *cache_grow_begin(struct kmem_cache *cachep,
 	 * Get mem for the objs.  Attempt to allocate a physical page from
 	 * 'nodeid'.
 	 */
-	page = slab_page(kmem_getpages(cachep, local_flags, nodeid));
-	if (!page)
+	slab = kmem_getpages(cachep, local_flags, nodeid);
+	if (!slab)
 		goto failed;
 
-	page_node = page_to_nid(page);
+	page_node = slab_nid(slab);
 	n = get_node(cachep, page_node);
 
 	/* Get colour for the slab, and cal the next value. */
@@ -2605,55 +2605,55 @@ static struct page *cache_grow_begin(struct kmem_cache *cachep,
 	 * page_address() in the latter returns a non-tagged pointer,
 	 * as it should be for slab pages.
 	 */
-	kasan_poison_slab(page);
+	kasan_poison_slab(slab_page(slab));
 
 	/* Get slab management. */
-	freelist = alloc_slabmgmt(cachep, page, offset,
+	freelist = alloc_slabmgmt(cachep, slab, offset,
 			local_flags & ~GFP_CONSTRAINT_MASK, page_node);
 	if (OFF_SLAB(cachep) && !freelist)
 		goto opps1;
 
-	page->slab_cache = cachep;
-	page->freelist = freelist;
+	slab->slab_cache = cachep;
+	slab->freelist = freelist;
 
-	cache_init_objs(cachep, page);
+	cache_init_objs(cachep, slab);
 
 	if (gfpflags_allow_blocking(local_flags))
 		local_irq_disable();
 
-	return page;
+	return slab;
 
 opps1:
-	kmem_freepages(cachep, page_slab(page));
+	kmem_freepages(cachep, slab);
 failed:
 	if (gfpflags_allow_blocking(local_flags))
 		local_irq_disable();
 	return NULL;
 }
 
-static void cache_grow_end(struct kmem_cache *cachep, struct page *page)
+static void cache_grow_end(struct kmem_cache *cachep, struct slab *slab)
 {
 	struct kmem_cache_node *n;
 	void *list = NULL;
 
 	check_irq_off();
 
-	if (!page)
+	if (!slab)
 		return;
 
-	INIT_LIST_HEAD(&page->slab_list);
-	n = get_node(cachep, page_to_nid(page));
+	INIT_LIST_HEAD(&slab->slab_list);
+	n = get_node(cachep, slab_nid(slab));
 
 	spin_lock(&n->list_lock);
 	n->total_slabs++;
-	if (!page->active) {
-		list_add_tail(&page->slab_list, &n->slabs_free);
+	if (!slab->active) {
+		list_add_tail(&slab->slab_list, &n->slabs_free);
 		n->free_slabs++;
 	} else
-		fixup_slab_list(cachep, n, page, &list);
+		fixup_slab_list(cachep, n, slab, &list);
 
 	STATS_INC_GROWN(cachep);
-	n->free_objects += cachep->num - page->active;
+	n->free_objects += cachep->num - slab->active;
 	spin_unlock(&n->list_lock);
 
 	fixup_objfreelist_debug(cachep, &list);
@@ -2701,13 +2701,13 @@ static void *cache_free_debugcheck(struct kmem_cache *cachep, void *objp,
 				   unsigned long caller)
 {
 	unsigned int objnr;
-	struct page *page;
+	struct slab *slab;
 
 	BUG_ON(virt_to_cache(objp) != cachep);
 
 	objp -= obj_offset(cachep);
 	kfree_debugcheck(objp);
-	page = virt_to_head_page(objp);
+	slab = virt_to_slab(objp);
 
 	if (cachep->flags & SLAB_RED_ZONE) {
 		verify_redzone_free(cachep, objp);
@@ -2717,10 +2717,10 @@ static void *cache_free_debugcheck(struct kmem_cache *cachep, void *objp,
 	if (cachep->flags & SLAB_STORE_USER)
 		*dbg_userword(cachep, objp) = (void *)caller;
 
-	objnr = obj_to_index(cachep, page, objp);
+	objnr = obj_to_index(cachep, slab_page(slab), objp);
 
 	BUG_ON(objnr >= cachep->num);
-	BUG_ON(objp != index_to_obj(cachep, page, objnr));
+	BUG_ON(objp != index_to_obj(cachep, slab, objnr));
 
 	if (cachep->flags & SLAB_POISON) {
 		poison_obj(cachep, objp, POISON_FREE);
@@ -2750,97 +2750,97 @@ static inline void fixup_objfreelist_debug(struct kmem_cache *cachep,
 }
 
 static inline void fixup_slab_list(struct kmem_cache *cachep,
-				struct kmem_cache_node *n, struct page *page,
+				struct kmem_cache_node *n, struct slab *slab,
 				void **list)
 {
 	/* move slabp to correct slabp list: */
-	list_del(&page->slab_list);
-	if (page->active == cachep->num) {
-		list_add(&page->slab_list, &n->slabs_full);
+	list_del(&slab->slab_list);
+	if (slab->active == cachep->num) {
+		list_add(&slab->slab_list, &n->slabs_full);
 		if (OBJFREELIST_SLAB(cachep)) {
 #if DEBUG
 			/* Poisoning will be done without holding the lock */
 			if (cachep->flags & SLAB_POISON) {
-				void **objp = page->freelist;
+				void **objp = slab->freelist;
 
 				*objp = *list;
 				*list = objp;
 			}
 #endif
-			page->freelist = NULL;
+			slab->freelist = NULL;
 		}
 	} else
-		list_add(&page->slab_list, &n->slabs_partial);
+		list_add(&slab->slab_list, &n->slabs_partial);
 }
 
 /* Try to find non-pfmemalloc slab if needed */
-static noinline struct page *get_valid_first_slab(struct kmem_cache_node *n,
-					struct page *page, bool pfmemalloc)
+static noinline struct slab *get_valid_first_slab(struct kmem_cache_node *n,
+					struct slab *slab, bool pfmemalloc)
 {
-	if (!page)
+	if (!slab)
 		return NULL;
 
 	if (pfmemalloc)
-		return page;
+		return slab;
 
-	if (!PageSlabPfmemalloc(page))
-		return page;
+	if (!slab_test_pfmemalloc(slab))
+		return slab;
 
 	/* No need to keep pfmemalloc slab if we have enough free objects */
 	if (n->free_objects > n->free_limit) {
-		ClearPageSlabPfmemalloc(page);
-		return page;
+		slab_clear_pfmemalloc(slab);
+		return slab;
 	}
 
 	/* Move pfmemalloc slab to the end of list to speed up next search */
-	list_del(&page->slab_list);
-	if (!page->active) {
-		list_add_tail(&page->slab_list, &n->slabs_free);
+	list_del(&slab->slab_list);
+	if (!slab->active) {
+		list_add_tail(&slab->slab_list, &n->slabs_free);
 		n->free_slabs++;
 	} else
-		list_add_tail(&page->slab_list, &n->slabs_partial);
+		list_add_tail(&slab->slab_list, &n->slabs_partial);
 
-	list_for_each_entry(page, &n->slabs_partial, slab_list) {
-		if (!PageSlabPfmemalloc(page))
-			return page;
+	list_for_each_entry(slab, &n->slabs_partial, slab_list) {
+		if (!slab_test_pfmemalloc(slab))
+			return slab;
 	}
 
 	n->free_touched = 1;
-	list_for_each_entry(page, &n->slabs_free, slab_list) {
-		if (!PageSlabPfmemalloc(page)) {
+	list_for_each_entry(slab, &n->slabs_free, slab_list) {
+		if (!slab_test_pfmemalloc(slab)) {
 			n->free_slabs--;
-			return page;
+			return slab;
 		}
 	}
 
 	return NULL;
 }
 
-static struct page *get_first_slab(struct kmem_cache_node *n, bool pfmemalloc)
+static struct slab *get_first_slab(struct kmem_cache_node *n, bool pfmemalloc)
 {
-	struct page *page;
+	struct slab *slab;
 
 	assert_spin_locked(&n->list_lock);
-	page = list_first_entry_or_null(&n->slabs_partial, struct page,
+	slab = list_first_entry_or_null(&n->slabs_partial, struct slab,
 					slab_list);
-	if (!page) {
+	if (!slab) {
 		n->free_touched = 1;
-		page = list_first_entry_or_null(&n->slabs_free, struct page,
+		slab = list_first_entry_or_null(&n->slabs_free, struct slab,
 						slab_list);
-		if (page)
+		if (slab)
 			n->free_slabs--;
 	}
 
 	if (sk_memalloc_socks())
-		page = get_valid_first_slab(n, page, pfmemalloc);
+		slab = get_valid_first_slab(n, slab, pfmemalloc);
 
-	return page;
+	return slab;
 }
 
 static noinline void *cache_alloc_pfmemalloc(struct kmem_cache *cachep,
 				struct kmem_cache_node *n, gfp_t flags)
 {
-	struct page *page;
+	struct slab *slab;
 	void *obj;
 	void *list = NULL;
 
@@ -2848,16 +2848,16 @@ static noinline void *cache_alloc_pfmemalloc(struct kmem_cache *cachep,
 		return NULL;
 
 	spin_lock(&n->list_lock);
-	page = get_first_slab(n, true);
-	if (!page) {
+	slab = get_first_slab(n, true);
+	if (!slab) {
 		spin_unlock(&n->list_lock);
 		return NULL;
 	}
 
-	obj = slab_get_obj(cachep, page);
+	obj = slab_get_obj(cachep, slab);
 	n->free_objects--;
 
-	fixup_slab_list(cachep, n, page, &list);
+	fixup_slab_list(cachep, n, slab, &list);
 
 	spin_unlock(&n->list_lock);
 	fixup_objfreelist_debug(cachep, &list);
@@ -2870,20 +2870,20 @@ static noinline void *cache_alloc_pfmemalloc(struct kmem_cache *cachep,
  * or cache_grow_end() for new slab
  */
 static __always_inline int alloc_block(struct kmem_cache *cachep,
-		struct array_cache *ac, struct page *page, int batchcount)
+		struct array_cache *ac, struct slab *slab, int batchcount)
 {
 	/*
 	 * There must be at least one object available for
 	 * allocation.
 	 */
-	BUG_ON(page->active >= cachep->num);
+	BUG_ON(slab->active >= cachep->num);
 
-	while (page->active < cachep->num && batchcount--) {
+	while (slab->active < cachep->num && batchcount--) {
 		STATS_INC_ALLOCED(cachep);
 		STATS_INC_ACTIVE(cachep);
 		STATS_SET_HIGH(cachep);
 
-		ac->entry[ac->avail++] = slab_get_obj(cachep, page);
+		ac->entry[ac->avail++] = slab_get_obj(cachep, slab);
 	}
 
 	return batchcount;
@@ -2896,7 +2896,7 @@ static void *cache_alloc_refill(struct kmem_cache *cachep, gfp_t flags)
 	struct array_cache *ac, *shared;
 	int node;
 	void *list = NULL;
-	struct page *page;
+	struct slab *slab;
 
 	check_irq_off();
 	node = numa_mem_id();
@@ -2929,14 +2929,14 @@ static void *cache_alloc_refill(struct kmem_cache *cachep, gfp_t flags)
 
 	while (batchcount > 0) {
 		/* Get slab alloc is to come from. */
-		page = get_first_slab(n, false);
-		if (!page)
+		slab = get_first_slab(n, false);
+		if (!slab)
 			goto must_grow;
 
 		check_spinlock_acquired(cachep);
 
-		batchcount = alloc_block(cachep, ac, page, batchcount);
-		fixup_slab_list(cachep, n, page, &list);
+		batchcount = alloc_block(cachep, ac, slab, batchcount);
+		fixup_slab_list(cachep, n, slab, &list);
 	}
 
 must_grow:
@@ -2955,16 +2955,16 @@ static void *cache_alloc_refill(struct kmem_cache *cachep, gfp_t flags)
 				return obj;
 		}
 
-		page = cache_grow_begin(cachep, gfp_exact_node(flags), node);
+		slab = cache_grow_begin(cachep, gfp_exact_node(flags), node);
 
 		/*
 		 * cache_grow_begin() can reenable interrupts,
 		 * then ac could change.
 		 */
 		ac = cpu_cache_get(cachep);
-		if (!ac->avail && page)
-			alloc_block(cachep, ac, page, batchcount);
-		cache_grow_end(cachep, page);
+		if (!ac->avail && slab)
+			alloc_block(cachep, ac, slab, batchcount);
+		cache_grow_end(cachep, slab);
 
 		if (!ac->avail)
 			return NULL;
@@ -3094,7 +3094,7 @@ static void *fallback_alloc(struct kmem_cache *cache, gfp_t flags)
 	struct zone *zone;
 	enum zone_type highest_zoneidx = gfp_zone(flags);
 	void *obj = NULL;
-	struct page *page;
+	struct slab *slab;
 	int nid;
 	unsigned int cpuset_mems_cookie;
 
@@ -3130,10 +3130,10 @@ static void *fallback_alloc(struct kmem_cache *cache, gfp_t flags)
 		 * We may trigger various forms of reclaim on the allowed
 		 * set and go into memory reserves if necessary.
 		 */
-		page = cache_grow_begin(cache, flags, numa_mem_id());
-		cache_grow_end(cache, page);
-		if (page) {
-			nid = page_to_nid(page);
+		slab = cache_grow_begin(cache, flags, numa_mem_id());
+		cache_grow_end(cache, slab);
+		if (slab) {
+			nid = slab_nid(slab);
 			obj = ____cache_alloc_node(cache,
 				gfp_exact_node(flags), nid);
 
@@ -3157,7 +3157,7 @@ static void *fallback_alloc(struct kmem_cache *cache, gfp_t flags)
 static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
 				int nodeid)
 {
-	struct page *page;
+	struct slab *slab;
 	struct kmem_cache_node *n;
 	void *obj = NULL;
 	void *list = NULL;
@@ -3168,8 +3168,8 @@ static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
 
 	check_irq_off();
 	spin_lock(&n->list_lock);
-	page = get_first_slab(n, false);
-	if (!page)
+	slab = get_first_slab(n, false);
+	if (!slab)
 		goto must_grow;
 
 	check_spinlock_acquired_node(cachep, nodeid);
@@ -3178,12 +3178,12 @@ static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
 	STATS_INC_ACTIVE(cachep);
 	STATS_SET_HIGH(cachep);
 
-	BUG_ON(page->active == cachep->num);
+	BUG_ON(slab->active == cachep->num);
 
-	obj = slab_get_obj(cachep, page);
+	obj = slab_get_obj(cachep, slab);
 	n->free_objects--;
 
-	fixup_slab_list(cachep, n, page, &list);
+	fixup_slab_list(cachep, n, slab, &list);
 
 	spin_unlock(&n->list_lock);
 	fixup_objfreelist_debug(cachep, &list);
@@ -3191,12 +3191,12 @@ static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
 
 must_grow:
 	spin_unlock(&n->list_lock);
-	page = cache_grow_begin(cachep, gfp_exact_node(flags), nodeid);
-	if (page) {
+	slab = cache_grow_begin(cachep, gfp_exact_node(flags), nodeid);
+	if (slab) {
 		/* This slab isn't counted yet so don't update free_objects */
-		obj = slab_get_obj(cachep, page);
+		obj = slab_get_obj(cachep, slab);
 	}
-	cache_grow_end(cachep, page);
+	cache_grow_end(cachep, slab);
 
 	return obj ? obj : fallback_alloc(cachep, flags);
 }
@@ -3326,40 +3326,40 @@ static void free_block(struct kmem_cache *cachep, void **objpp,
 {
 	int i;
 	struct kmem_cache_node *n = get_node(cachep, node);
-	struct page *page;
+	struct slab *slab;
 
 	n->free_objects += nr_objects;
 
 	for (i = 0; i < nr_objects; i++) {
 		void *objp;
-		struct page *page;
+		struct slab *slab;
 
 		objp = objpp[i];
 
-		page = virt_to_head_page(objp);
-		list_del(&page->slab_list);
+		slab = virt_to_slab(objp);
+		list_del(&slab->slab_list);
 		check_spinlock_acquired_node(cachep, node);
-		slab_put_obj(cachep, page, objp);
+		slab_put_obj(cachep, slab, objp);
 		STATS_DEC_ACTIVE(cachep);
 
 		/* fixup slab chains */
-		if (page->active == 0) {
-			list_add(&page->slab_list, &n->slabs_free);
+		if (slab->active == 0) {
+			list_add(&slab->slab_list, &n->slabs_free);
 			n->free_slabs++;
 		} else {
 			/* Unconditionally move a slab to the end of the
 			 * partial list on free - maximum time for the
 			 * other objects to be freed, too.
 			 */
-			list_add_tail(&page->slab_list, &n->slabs_partial);
+			list_add_tail(&slab->slab_list, &n->slabs_partial);
 		}
 	}
 
 	while (n->free_objects > n->free_limit && !list_empty(&n->slabs_free)) {
 		n->free_objects -= cachep->num;
 
-		page = list_last_entry(&n->slabs_free, struct page, slab_list);
-		list_move(&page->slab_list, list);
+		slab = list_last_entry(&n->slabs_free, struct slab, slab_list);
+		list_move(&slab->slab_list, list);
 		n->free_slabs--;
 		n->total_slabs--;
 	}
@@ -3395,10 +3395,10 @@ static void cache_flusharray(struct kmem_cache *cachep, struct array_cache *ac)
 #if STATS
 	{
 		int i = 0;
-		struct page *page;
+		struct slab *slab;
 
-		list_for_each_entry(page, &n->slabs_free, slab_list) {
-			BUG_ON(page->active);
+		list_for_each_entry(slab, &n->slabs_free, slab_list) {
+			BUG_ON(slab->active);
 
 			i++;
 		}
@@ -3474,10 +3474,10 @@ void ___cache_free(struct kmem_cache *cachep, void *objp,
 	}
 
 	if (sk_memalloc_socks()) {
-		struct page *page = virt_to_head_page(objp);
+		struct slab *slab = virt_to_slab(objp);
 
-		if (unlikely(PageSlabPfmemalloc(page))) {
-			cache_free_pfmemalloc(cachep, page, objp);
+		if (unlikely(slab_test_pfmemalloc(slab))) {
+			cache_free_pfmemalloc(cachep, slab, objp);
 			return;
 		}
 	}
@@ -3664,7 +3664,7 @@ void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 	kpp->kp_data_offset = obj_offset(cachep);
 	slab = virt_to_slab(objp);
 	objnr = obj_to_index(cachep, slab_page(slab), objp);
-	objp = index_to_obj(cachep, slab_page(slab), objnr);
+	objp = index_to_obj(cachep, slab, objnr);
 	kpp->kp_objp = objp;
 	if (DEBUG && cachep->flags & SLAB_STORE_USER)
 		kpp->kp_ret = *dbg_userword(cachep, objp);
@@ -4188,7 +4188,7 @@ void __check_heap_object(const void *ptr, unsigned long n,
 	if (is_kfence_address(ptr))
 		offset = ptr - kfence_object_start(ptr);
 	else
-		offset = ptr - index_to_obj(cachep, slab_page(slab), objnr) - obj_offset(cachep);
+		offset = ptr - index_to_obj(cachep, slab, objnr) - obj_offset(cachep);
 
 	/* Allow address range falling entirely within usercopy region. */
 	if (offset >= cachep->useroffset &&
-- 
2.33.1

