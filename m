Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7493A2CA0
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:59 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 17B9D1F392;
	Tue,  4 Jan 2022 00:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKTLd4DgxHNjVGRd3c4iVFc0FageJxZHviKP61npd7M=;
	b=fSd2RfT5zNG8pu+08w3zIRLvYE271eeiah4wPTf5qEo6xZe4o59lVd3MRtoIez1YNY95br
	C66k9j1tEpyLMjLqgA2H3P64QfNINgi3p1tc8iV/2ADLYtqAXa/cV8Ji4aLdUw8gCRyiaf
	JYYZKxP67pL5rh5ngtOfGnmKQw19YSU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKTLd4DgxHNjVGRd3c4iVFc0FageJxZHviKP61npd7M=;
	b=thaOgTnFABWrAWcDT+I+3rs2OqUTGimepBSANSJBcp1ViDNhGZTXzQ/E0S+334mA9+Zaw4
	toS6ELvbp3/+CRBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D1BF9139D1;
	Tue,  4 Jan 2022 00:10:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id KNiVMo+Q02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:55 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <guro@fb.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Julia Lawall <julia.lawall@inria.fr>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v4 17/32] mm/slub: Convert most struct page to struct slab by spatch
Date: Tue,  4 Jan 2022 01:10:31 +0100
Message-Id: <20220104001046.12263-18-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=83051; h=from:subject; bh=CICE7bTa2lHccbGXs9Y5meqRmFcXBPUBvDUiGB9hvX4=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05B4o8QITFt/kCRKh3mx3iUmJLkaCrz38/QebsBZ QeXoim6JATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQeAAKCRDgIcpz8YmpEPzUB/ 9/fbBWTVG3YRj7vXvLJ0XBuDrgVHAg+b5XNN5uzbdFHkUzQ3kGheE6zFGShrhp8oHTiqyG82Z9dl5R tiO4V5lZVxSjtOo/EL6XCRDX89FHyIch86iY95/ppV2sdbRWlgG6Y5Me5eNl+T7X4uHXOnEWFZErtz 7pM/NjmaKHRMMVzeKib/11rT5HWSRGjJ5Q7FRf7QQ8qOqQhuvVq7ohX2r/wYd9CLekNdeJ4shcuD6m o+2M8mAPYnRgy8LA5SlNrLDbXdbhRoCJ0NBQx/OQEEUY+YeLpDuwxApOU8FMdRrasERH0XtaqFAMx5 lGRzZ3MEhl9KS8lXni6artHwZPbGmY
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

The majority of conversion from struct page to struct slab in SLUB
internals can be delegated to a coccinelle semantic patch. This includes
renaming of variables with 'page' in name to 'slab', and similar.

Big thanks to Julia Lawall and Luis Chamberlain for help with
coccinelle.

// Options: --include-headers --no-includes --smpl-spacing include/linux/slub_def.h mm/slub.c
// Note: needs coccinelle 1.1.1 to avoid breaking whitespace, and ocaml for the
// embedded script

// build list of functions to exclude from applying the next rule
@initialize:ocaml@
@@

let ok_function p =
  not (List.mem (List.hd p).current_element ["nearest_obj";"obj_to_index";"objs_per_slab_page";"__slab_lock";"__slab_unlock";"free_nonslab_page";"kmalloc_large_node"])

// convert the type from struct page to struct page in all functions except the
// list from previous rule
// this also affects struct kmem_cache_cpu, but that's ok
@@
position p : script:ocaml() { ok_function p };
@@

- struct page@p
+ struct slab

// in struct kmem_cache_cpu, change the name from page to slab
// the type was already converted by the previous rule
@@
@@

struct kmem_cache_cpu {
...
-struct slab *page;
+struct slab *slab;
...
}

// there are many places that use c->page which is now c->slab after the
// previous rule
@@
struct kmem_cache_cpu *c;
@@

-c->page
+c->slab

@@
@@

struct kmem_cache {
...
- unsigned int cpu_partial_pages;
+ unsigned int cpu_partial_slabs;
...
}

@@
struct kmem_cache *s;
@@

- s->cpu_partial_pages
+ s->cpu_partial_slabs

@@
@@

static void
- setup_page_debug(
+ setup_slab_debug(
 ...)
 {...}

@@
@@

- setup_page_debug(
+ setup_slab_debug(
 ...);

// for all functions (with exceptions), change any "struct slab *page"
// parameter to "struct slab *slab" in the signature, and generally all
// occurences of "page" to "slab" in the body - with some special cases.

@@
identifier fn !~ "free_nonslab_page|obj_to_index|objs_per_slab_page|nearest_obj";
@@
 fn(...,
-   struct slab *page
+   struct slab *slab
    ,...)
 {
<...
- page
+ slab
...>
 }

// similar to previous but the param is called partial_page
@@
identifier fn;
@@

 fn(...,
-   struct slab *partial_page
+   struct slab *partial_slab
    ,...)
 {
<...
- partial_page
+ partial_slab
...>
 }

// similar to previous but for functions that take pointer to struct page ptr
@@
identifier fn;
@@

 fn(...,
-   struct slab **ret_page
+   struct slab **ret_slab
    ,...)
 {
<...
- ret_page
+ ret_slab
...>
 }

// functions converted by previous rules that were temporarily called using
// slab_page(E) so we want to remove the wrapper now that they accept struct
// slab ptr directly
@@
identifier fn =~ "slab_free|do_slab_free";
expression E;
@@

 fn(...,
- slab_page(E)
+ E
  ,...)

// similar to previous but for another pattern
@@
identifier fn =~ "slab_pad_check|check_object";
@@

 fn(...,
- folio_page(folio, 0)
+ slab
  ,...)

// functions that were returning struct page ptr and now will return struct
// slab ptr, including slab_page() wrapper removal
@@
identifier fn =~ "allocate_slab|new_slab";
expression E;
@@

 static
-struct slab *
+struct slab *
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
(
- page
+ slab
|
- partial_page
+ partial_slab
|
- oldpage
+ oldslab
)
;

// this has to be separate from previous rule as page and page2 appear at the
// same line
@@
@@

struct slab *
-page2
+slab2
;

// similar but with initial assignment
@@
expression E;
@@

struct slab *
(
- page
+ slab
|
- flush_page
+ flush_slab
|
- discard_page
+ slab_to_discard
|
- page_to_unfreeze
+ slab_to_unfreeze
)
= E;

// convert most of struct page to struct slab usage inside functions (with
// exceptions), including specific variable renames
@@
identifier fn !~ "nearest_obj|obj_to_index|objs_per_slab_page|__slab_(un)*lock|__free_slab|free_nonslab_page|kmalloc_large_node";
expression E;
@@

 fn(...)
 {
<...
(
- int pages;
+ int slabs;
|
- int pages = E;
+ int slabs = E;
|
- page
+ slab
|
- flush_page
+ flush_slab
|
- partial_page
+ partial_slab
|
- oldpage->pages
+ oldslab->slabs
|
- oldpage
+ oldslab
|
- unsigned int nr_pages;
+ unsigned int nr_slabs;
|
- nr_pages
+ nr_slabs
|
- unsigned int partial_pages = E;
+ unsigned int partial_slabs = E;
|
- partial_pages
+ partial_slabs
)
...>
 }

// this has to be split out from the previous rule so that lines containing
// multiple matching changes will be fully converted
@@
identifier fn !~ "nearest_obj|obj_to_index|objs_per_slab_page|__slab_(un)*lock|__free_slab|free_nonslab_page|kmalloc_large_node";
@@

 fn(...)
 {
<...
(
- slab->pages
+ slab->slabs
|
- pages
+ slabs
|
- page2
+ slab2
|
- discard_page
+ slab_to_discard
|
- page_to_unfreeze
+ slab_to_unfreeze
)
...>
 }

// after we simply changed all occurences of page to slab, some usages need
// adjustment for slab-specific functions, or use slab_page() wrapper
@@
identifier fn !~ "nearest_obj|obj_to_index|objs_per_slab_page|__slab_(un)*lock|__free_slab|free_nonslab_page|kmalloc_large_node";
@@

 fn(...)
 {
<...
(
- page_slab(slab)
+ slab
|
- kasan_poison_slab(slab)
+ kasan_poison_slab(slab_page(slab))
|
- page_address(slab)
+ slab_address(slab)
|
- page_size(slab)
+ slab_size(slab)
|
- PageSlab(slab)
+ folio_test_slab(slab_folio(slab))
|
- page_to_nid(slab)
+ slab_nid(slab)
|
- compound_order(slab)
+ slab_order(slab)
)
...>
 }

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Luis Chamberlain <mcgrof@kernel.org>
---
 include/linux/slub_def.h |   6 +-
 mm/slub.c                | 872 +++++++++++++++++++--------------------
 2 files changed, 439 insertions(+), 439 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 1ef68d4de9c0..00d99afe1c0e 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -48,9 +48,9 @@ enum stat_item {
 struct kmem_cache_cpu {
 	void **freelist;	/* Pointer to next available object */
 	unsigned long tid;	/* Globally unique transaction id */
-	struct page *page;	/* The slab from which we are allocating */
+	struct slab *slab;	/* The slab from which we are allocating */
 #ifdef CONFIG_SLUB_CPU_PARTIAL
-	struct page *partial;	/* Partially allocated frozen slabs */
+	struct slab *partial;	/* Partially allocated frozen slabs */
 #endif
 	local_lock_t lock;	/* Protects the fields above */
 #ifdef CONFIG_SLUB_STATS
@@ -100,7 +100,7 @@ struct kmem_cache {
 	/* Number of per cpu partial objects to keep around */
 	unsigned int cpu_partial;
 	/* Number of per cpu partial pages to keep around */
-	unsigned int cpu_partial_pages;
+	unsigned int cpu_partial_slabs;
 #endif
 	struct kmem_cache_order_objects oo;
 
diff --git a/mm/slub.c b/mm/slub.c
index c369806084e1..e89208f3197a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -417,7 +417,7 @@ static inline unsigned int oo_objects(struct kmem_cache_order_objects x)
 #ifdef CONFIG_SLUB_CPU_PARTIAL
 static void slub_set_cpu_partial(struct kmem_cache *s, unsigned int nr_objects)
 {
-	unsigned int nr_pages;
+	unsigned int nr_slabs;
 
 	s->cpu_partial = nr_objects;
 
@@ -427,8 +427,8 @@ static void slub_set_cpu_partial(struct kmem_cache *s, unsigned int nr_objects)
 	 * growth of the list. For simplicity we assume that the pages will
 	 * be half-full.
 	 */
-	nr_pages = DIV_ROUND_UP(nr_objects * 2, oo_objects(s->oo));
-	s->cpu_partial_pages = nr_pages;
+	nr_slabs = DIV_ROUND_UP(nr_objects * 2, oo_objects(s->oo));
+	s->cpu_partial_slabs = nr_slabs;
 }
 #else
 static inline void
@@ -456,16 +456,16 @@ static __always_inline void __slab_unlock(struct slab *slab)
 	__bit_spin_unlock(PG_locked, &page->flags);
 }
 
-static __always_inline void slab_lock(struct page *page, unsigned long *flags)
+static __always_inline void slab_lock(struct slab *slab, unsigned long *flags)
 {
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		local_irq_save(*flags);
-	__slab_lock(page_slab(page));
+	__slab_lock(slab);
 }
 
-static __always_inline void slab_unlock(struct page *page, unsigned long *flags)
+static __always_inline void slab_unlock(struct slab *slab, unsigned long *flags)
 {
-	__slab_unlock(page_slab(page));
+	__slab_unlock(slab);
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		local_irq_restore(*flags);
 }
@@ -475,7 +475,7 @@ static __always_inline void slab_unlock(struct page *page, unsigned long *flags)
  * by an _irqsave() lock variant. Except on PREEMPT_RT where locks are different
  * so we disable interrupts as part of slab_[un]lock().
  */
-static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
+static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct slab *slab,
 		void *freelist_old, unsigned long counters_old,
 		void *freelist_new, unsigned long counters_new,
 		const char *n)
@@ -485,7 +485,7 @@ static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct page *page
 #if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
     defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
-		if (cmpxchg_double(&page->freelist, &page->counters,
+		if (cmpxchg_double(&slab->freelist, &slab->counters,
 				   freelist_old, counters_old,
 				   freelist_new, counters_new))
 			return true;
@@ -495,15 +495,15 @@ static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct page *page
 		/* init to 0 to prevent spurious warnings */
 		unsigned long flags = 0;
 
-		slab_lock(page, &flags);
-		if (page->freelist == freelist_old &&
-					page->counters == counters_old) {
-			page->freelist = freelist_new;
-			page->counters = counters_new;
-			slab_unlock(page, &flags);
+		slab_lock(slab, &flags);
+		if (slab->freelist == freelist_old &&
+					slab->counters == counters_old) {
+			slab->freelist = freelist_new;
+			slab->counters = counters_new;
+			slab_unlock(slab, &flags);
 			return true;
 		}
-		slab_unlock(page, &flags);
+		slab_unlock(slab, &flags);
 	}
 
 	cpu_relax();
@@ -516,7 +516,7 @@ static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct page *page
 	return false;
 }
 
-static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
+static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct slab *slab,
 		void *freelist_old, unsigned long counters_old,
 		void *freelist_new, unsigned long counters_new,
 		const char *n)
@@ -524,7 +524,7 @@ static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
 #if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
     defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
-		if (cmpxchg_double(&page->freelist, &page->counters,
+		if (cmpxchg_double(&slab->freelist, &slab->counters,
 				   freelist_old, counters_old,
 				   freelist_new, counters_new))
 			return true;
@@ -534,16 +534,16 @@ static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
 		unsigned long flags;
 
 		local_irq_save(flags);
-		__slab_lock(page_slab(page));
-		if (page->freelist == freelist_old &&
-					page->counters == counters_old) {
-			page->freelist = freelist_new;
-			page->counters = counters_new;
-			__slab_unlock(page_slab(page));
+		__slab_lock(slab);
+		if (slab->freelist == freelist_old &&
+					slab->counters == counters_old) {
+			slab->freelist = freelist_new;
+			slab->counters = counters_new;
+			__slab_unlock(slab);
 			local_irq_restore(flags);
 			return true;
 		}
-		__slab_unlock(page_slab(page));
+		__slab_unlock(slab);
 		local_irq_restore(flags);
 	}
 
@@ -562,14 +562,14 @@ static unsigned long object_map[BITS_TO_LONGS(MAX_OBJS_PER_PAGE)];
 static DEFINE_RAW_SPINLOCK(object_map_lock);
 
 static void __fill_map(unsigned long *obj_map, struct kmem_cache *s,
-		       struct page *page)
+		       struct slab *slab)
 {
-	void *addr = page_address(page);
+	void *addr = slab_address(slab);
 	void *p;
 
-	bitmap_zero(obj_map, page->objects);
+	bitmap_zero(obj_map, slab->objects);
 
-	for (p = page->freelist; p; p = get_freepointer(s, p))
+	for (p = slab->freelist; p; p = get_freepointer(s, p))
 		set_bit(__obj_to_index(s, addr, p), obj_map);
 }
 
@@ -599,14 +599,14 @@ static inline bool slab_add_kunit_errors(void) { return false; }
  * Node listlock must be held to guarantee that the page does
  * not vanish from under us.
  */
-static unsigned long *get_map(struct kmem_cache *s, struct page *page)
+static unsigned long *get_map(struct kmem_cache *s, struct slab *slab)
 	__acquires(&object_map_lock)
 {
 	VM_BUG_ON(!irqs_disabled());
 
 	raw_spin_lock(&object_map_lock);
 
-	__fill_map(object_map, s, page);
+	__fill_map(object_map, s, slab);
 
 	return object_map;
 }
@@ -667,17 +667,17 @@ static inline void metadata_access_disable(void)
 
 /* Verify that a pointer has an address that is valid within a slab page */
 static inline int check_valid_pointer(struct kmem_cache *s,
-				struct page *page, void *object)
+				struct slab *slab, void *object)
 {
 	void *base;
 
 	if (!object)
 		return 1;
 
-	base = page_address(page);
+	base = slab_address(slab);
 	object = kasan_reset_tag(object);
 	object = restore_red_left(s, object);
-	if (object < base || object >= base + page->objects * s->size ||
+	if (object < base || object >= base + slab->objects * s->size ||
 		(object - base) % s->size) {
 		return 0;
 	}
@@ -827,14 +827,14 @@ static void slab_fix(struct kmem_cache *s, char *fmt, ...)
 	va_end(args);
 }
 
-static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
+static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
 {
 	unsigned int off;	/* Offset of last byte */
-	u8 *addr = page_address(page);
+	u8 *addr = slab_address(slab);
 
 	print_tracking(s, p);
 
-	print_slab_info(page_slab(page));
+	print_slab_info(slab);
 
 	pr_err("Object 0x%p @offset=%tu fp=0x%p\n\n",
 	       p, p - addr, get_freepointer(s, p));
@@ -866,23 +866,23 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 	dump_stack();
 }
 
-static void object_err(struct kmem_cache *s, struct page *page,
+static void object_err(struct kmem_cache *s, struct slab *slab,
 			u8 *object, char *reason)
 {
 	if (slab_add_kunit_errors())
 		return;
 
 	slab_bug(s, "%s", reason);
-	print_trailer(s, page, object);
+	print_trailer(s, slab, object);
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
-static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
+static bool freelist_corrupted(struct kmem_cache *s, struct slab *slab,
 			       void **freelist, void *nextfree)
 {
 	if ((s->flags & SLAB_CONSISTENCY_CHECKS) &&
-	    !check_valid_pointer(s, page, nextfree) && freelist) {
-		object_err(s, page, *freelist, "Freechain corrupt");
+	    !check_valid_pointer(s, slab, nextfree) && freelist) {
+		object_err(s, slab, *freelist, "Freechain corrupt");
 		*freelist = NULL;
 		slab_fix(s, "Isolate corrupted freechain");
 		return true;
@@ -891,7 +891,7 @@ static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
 	return false;
 }
 
-static __printf(3, 4) void slab_err(struct kmem_cache *s, struct page *page,
+static __printf(3, 4) void slab_err(struct kmem_cache *s, struct slab *slab,
 			const char *fmt, ...)
 {
 	va_list args;
@@ -904,7 +904,7 @@ static __printf(3, 4) void slab_err(struct kmem_cache *s, struct page *page,
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 	slab_bug(s, "%s", buf);
-	print_slab_info(page_slab(page));
+	print_slab_info(slab);
 	dump_stack();
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
@@ -932,13 +932,13 @@ static void restore_bytes(struct kmem_cache *s, char *message, u8 data,
 	memset(from, data, to - from);
 }
 
-static int check_bytes_and_report(struct kmem_cache *s, struct page *page,
+static int check_bytes_and_report(struct kmem_cache *s, struct slab *slab,
 			u8 *object, char *what,
 			u8 *start, unsigned int value, unsigned int bytes)
 {
 	u8 *fault;
 	u8 *end;
-	u8 *addr = page_address(page);
+	u8 *addr = slab_address(slab);
 
 	metadata_access_enable();
 	fault = memchr_inv(kasan_reset_tag(start), value, bytes);
@@ -957,7 +957,7 @@ static int check_bytes_and_report(struct kmem_cache *s, struct page *page,
 	pr_err("0x%p-0x%p @offset=%tu. First byte 0x%x instead of 0x%x\n",
 					fault, end - 1, fault - addr,
 					fault[0], value);
-	print_trailer(s, page, object);
+	print_trailer(s, slab, object);
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 
 skip_bug_print:
@@ -1003,7 +1003,7 @@ static int check_bytes_and_report(struct kmem_cache *s, struct page *page,
  * may be used with merged slabcaches.
  */
 
-static int check_pad_bytes(struct kmem_cache *s, struct page *page, u8 *p)
+static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
 {
 	unsigned long off = get_info_end(s);	/* The end of info */
 
@@ -1016,12 +1016,12 @@ static int check_pad_bytes(struct kmem_cache *s, struct page *page, u8 *p)
 	if (size_from_object(s) == off)
 		return 1;
 
-	return check_bytes_and_report(s, page, p, "Object padding",
+	return check_bytes_and_report(s, slab, p, "Object padding",
 			p + off, POISON_INUSE, size_from_object(s) - off);
 }
 
 /* Check the pad bytes at the end of a slab page */
-static int slab_pad_check(struct kmem_cache *s, struct page *page)
+static int slab_pad_check(struct kmem_cache *s, struct slab *slab)
 {
 	u8 *start;
 	u8 *fault;
@@ -1033,8 +1033,8 @@ static int slab_pad_check(struct kmem_cache *s, struct page *page)
 	if (!(s->flags & SLAB_POISON))
 		return 1;
 
-	start = page_address(page);
-	length = page_size(page);
+	start = slab_address(slab);
+	length = slab_size(slab);
 	end = start + length;
 	remainder = length % s->size;
 	if (!remainder)
@@ -1049,7 +1049,7 @@ static int slab_pad_check(struct kmem_cache *s, struct page *page)
 	while (end > fault && end[-1] == POISON_INUSE)
 		end--;
 
-	slab_err(s, page, "Padding overwritten. 0x%p-0x%p @offset=%tu",
+	slab_err(s, slab, "Padding overwritten. 0x%p-0x%p @offset=%tu",
 			fault, end - 1, fault - start);
 	print_section(KERN_ERR, "Padding ", pad, remainder);
 
@@ -1057,23 +1057,23 @@ static int slab_pad_check(struct kmem_cache *s, struct page *page)
 	return 0;
 }
 
-static int check_object(struct kmem_cache *s, struct page *page,
+static int check_object(struct kmem_cache *s, struct slab *slab,
 					void *object, u8 val)
 {
 	u8 *p = object;
 	u8 *endobject = object + s->object_size;
 
 	if (s->flags & SLAB_RED_ZONE) {
-		if (!check_bytes_and_report(s, page, object, "Left Redzone",
+		if (!check_bytes_and_report(s, slab, object, "Left Redzone",
 			object - s->red_left_pad, val, s->red_left_pad))
 			return 0;
 
-		if (!check_bytes_and_report(s, page, object, "Right Redzone",
+		if (!check_bytes_and_report(s, slab, object, "Right Redzone",
 			endobject, val, s->inuse - s->object_size))
 			return 0;
 	} else {
 		if ((s->flags & SLAB_POISON) && s->object_size < s->inuse) {
-			check_bytes_and_report(s, page, p, "Alignment padding",
+			check_bytes_and_report(s, slab, p, "Alignment padding",
 				endobject, POISON_INUSE,
 				s->inuse - s->object_size);
 		}
@@ -1081,15 +1081,15 @@ static int check_object(struct kmem_cache *s, struct page *page,
 
 	if (s->flags & SLAB_POISON) {
 		if (val != SLUB_RED_ACTIVE && (s->flags & __OBJECT_POISON) &&
-			(!check_bytes_and_report(s, page, p, "Poison", p,
+			(!check_bytes_and_report(s, slab, p, "Poison", p,
 					POISON_FREE, s->object_size - 1) ||
-			 !check_bytes_and_report(s, page, p, "End Poison",
+			 !check_bytes_and_report(s, slab, p, "End Poison",
 				p + s->object_size - 1, POISON_END, 1)))
 			return 0;
 		/*
 		 * check_pad_bytes cleans up on its own.
 		 */
-		check_pad_bytes(s, page, p);
+		check_pad_bytes(s, slab, p);
 	}
 
 	if (!freeptr_outside_object(s) && val == SLUB_RED_ACTIVE)
@@ -1100,8 +1100,8 @@ static int check_object(struct kmem_cache *s, struct page *page,
 		return 1;
 
 	/* Check free pointer validity */
-	if (!check_valid_pointer(s, page, get_freepointer(s, p))) {
-		object_err(s, page, p, "Freepointer corrupt");
+	if (!check_valid_pointer(s, slab, get_freepointer(s, p))) {
+		object_err(s, slab, p, "Freepointer corrupt");
 		/*
 		 * No choice but to zap it and thus lose the remainder
 		 * of the free objects in this slab. May cause
@@ -1113,28 +1113,28 @@ static int check_object(struct kmem_cache *s, struct page *page,
 	return 1;
 }
 
-static int check_slab(struct kmem_cache *s, struct page *page)
+static int check_slab(struct kmem_cache *s, struct slab *slab)
 {
 	int maxobj;
 
-	if (!PageSlab(page)) {
-		slab_err(s, page, "Not a valid slab page");
+	if (!folio_test_slab(slab_folio(slab))) {
+		slab_err(s, slab, "Not a valid slab page");
 		return 0;
 	}
 
-	maxobj = order_objects(compound_order(page), s->size);
-	if (page->objects > maxobj) {
-		slab_err(s, page, "objects %u > max %u",
-			page->objects, maxobj);
+	maxobj = order_objects(slab_order(slab), s->size);
+	if (slab->objects > maxobj) {
+		slab_err(s, slab, "objects %u > max %u",
+			slab->objects, maxobj);
 		return 0;
 	}
-	if (page->inuse > page->objects) {
-		slab_err(s, page, "inuse %u > max %u",
-			page->inuse, page->objects);
+	if (slab->inuse > slab->objects) {
+		slab_err(s, slab, "inuse %u > max %u",
+			slab->inuse, slab->objects);
 		return 0;
 	}
 	/* Slab_pad_check fixes things up after itself */
-	slab_pad_check(s, page);
+	slab_pad_check(s, slab);
 	return 1;
 }
 
@@ -1142,26 +1142,26 @@ static int check_slab(struct kmem_cache *s, struct page *page)
  * Determine if a certain object on a page is on the freelist. Must hold the
  * slab lock to guarantee that the chains are in a consistent state.
  */
-static int on_freelist(struct kmem_cache *s, struct page *page, void *search)
+static int on_freelist(struct kmem_cache *s, struct slab *slab, void *search)
 {
 	int nr = 0;
 	void *fp;
 	void *object = NULL;
 	int max_objects;
 
-	fp = page->freelist;
-	while (fp && nr <= page->objects) {
+	fp = slab->freelist;
+	while (fp && nr <= slab->objects) {
 		if (fp == search)
 			return 1;
-		if (!check_valid_pointer(s, page, fp)) {
+		if (!check_valid_pointer(s, slab, fp)) {
 			if (object) {
-				object_err(s, page, object,
+				object_err(s, slab, object,
 					"Freechain corrupt");
 				set_freepointer(s, object, NULL);
 			} else {
-				slab_err(s, page, "Freepointer corrupt");
-				page->freelist = NULL;
-				page->inuse = page->objects;
+				slab_err(s, slab, "Freepointer corrupt");
+				slab->freelist = NULL;
+				slab->inuse = slab->objects;
 				slab_fix(s, "Freelist cleared");
 				return 0;
 			}
@@ -1172,34 +1172,34 @@ static int on_freelist(struct kmem_cache *s, struct page *page, void *search)
 		nr++;
 	}
 
-	max_objects = order_objects(compound_order(page), s->size);
+	max_objects = order_objects(slab_order(slab), s->size);
 	if (max_objects > MAX_OBJS_PER_PAGE)
 		max_objects = MAX_OBJS_PER_PAGE;
 
-	if (page->objects != max_objects) {
-		slab_err(s, page, "Wrong number of objects. Found %d but should be %d",
-			 page->objects, max_objects);
-		page->objects = max_objects;
+	if (slab->objects != max_objects) {
+		slab_err(s, slab, "Wrong number of objects. Found %d but should be %d",
+			 slab->objects, max_objects);
+		slab->objects = max_objects;
 		slab_fix(s, "Number of objects adjusted");
 	}
-	if (page->inuse != page->objects - nr) {
-		slab_err(s, page, "Wrong object count. Counter is %d but counted were %d",
-			 page->inuse, page->objects - nr);
-		page->inuse = page->objects - nr;
+	if (slab->inuse != slab->objects - nr) {
+		slab_err(s, slab, "Wrong object count. Counter is %d but counted were %d",
+			 slab->inuse, slab->objects - nr);
+		slab->inuse = slab->objects - nr;
 		slab_fix(s, "Object count adjusted");
 	}
 	return search == NULL;
 }
 
-static void trace(struct kmem_cache *s, struct page *page, void *object,
+static void trace(struct kmem_cache *s, struct slab *slab, void *object,
 								int alloc)
 {
 	if (s->flags & SLAB_TRACE) {
 		pr_info("TRACE %s %s 0x%p inuse=%d fp=0x%p\n",
 			s->name,
 			alloc ? "alloc" : "free",
-			object, page->inuse,
-			page->freelist);
+			object, slab->inuse,
+			slab->freelist);
 
 		if (!alloc)
 			print_section(KERN_INFO, "Object ", (void *)object,
@@ -1213,22 +1213,22 @@ static void trace(struct kmem_cache *s, struct page *page, void *object,
  * Tracking of fully allocated slabs for debugging purposes.
  */
 static void add_full(struct kmem_cache *s,
-	struct kmem_cache_node *n, struct page *page)
+	struct kmem_cache_node *n, struct slab *slab)
 {
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
 	lockdep_assert_held(&n->list_lock);
-	list_add(&page->slab_list, &n->full);
+	list_add(&slab->slab_list, &n->full);
 }
 
-static void remove_full(struct kmem_cache *s, struct kmem_cache_node *n, struct page *page)
+static void remove_full(struct kmem_cache *s, struct kmem_cache_node *n, struct slab *slab)
 {
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
 	lockdep_assert_held(&n->list_lock);
-	list_del(&page->slab_list);
+	list_del(&slab->slab_list);
 }
 
 /* Tracking of the number of slabs for debugging purposes */
@@ -1268,7 +1268,7 @@ static inline void dec_slabs_node(struct kmem_cache *s, int node, int objects)
 }
 
 /* Object debug checks for alloc/free paths */
-static void setup_object_debug(struct kmem_cache *s, struct page *page,
+static void setup_object_debug(struct kmem_cache *s, struct slab *slab,
 								void *object)
 {
 	if (!kmem_cache_debug_flags(s, SLAB_STORE_USER|SLAB_RED_ZONE|__OBJECT_POISON))
@@ -1279,89 +1279,89 @@ static void setup_object_debug(struct kmem_cache *s, struct page *page,
 }
 
 static
-void setup_page_debug(struct kmem_cache *s, struct page *page, void *addr)
+void setup_slab_debug(struct kmem_cache *s, struct slab *slab, void *addr)
 {
 	if (!kmem_cache_debug_flags(s, SLAB_POISON))
 		return;
 
 	metadata_access_enable();
-	memset(kasan_reset_tag(addr), POISON_INUSE, page_size(page));
+	memset(kasan_reset_tag(addr), POISON_INUSE, slab_size(slab));
 	metadata_access_disable();
 }
 
 static inline int alloc_consistency_checks(struct kmem_cache *s,
-					struct page *page, void *object)
+					struct slab *slab, void *object)
 {
-	if (!check_slab(s, page))
+	if (!check_slab(s, slab))
 		return 0;
 
-	if (!check_valid_pointer(s, page, object)) {
-		object_err(s, page, object, "Freelist Pointer check fails");
+	if (!check_valid_pointer(s, slab, object)) {
+		object_err(s, slab, object, "Freelist Pointer check fails");
 		return 0;
 	}
 
-	if (!check_object(s, page, object, SLUB_RED_INACTIVE))
+	if (!check_object(s, slab, object, SLUB_RED_INACTIVE))
 		return 0;
 
 	return 1;
 }
 
 static noinline int alloc_debug_processing(struct kmem_cache *s,
-					struct page *page,
+					struct slab *slab,
 					void *object, unsigned long addr)
 {
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
-		if (!alloc_consistency_checks(s, page, object))
+		if (!alloc_consistency_checks(s, slab, object))
 			goto bad;
 	}
 
 	/* Success perform special debug activities for allocs */
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, object, TRACK_ALLOC, addr);
-	trace(s, page, object, 1);
+	trace(s, slab, object, 1);
 	init_object(s, object, SLUB_RED_ACTIVE);
 	return 1;
 
 bad:
-	if (PageSlab(page)) {
+	if (folio_test_slab(slab_folio(slab))) {
 		/*
 		 * If this is a slab page then lets do the best we can
 		 * to avoid issues in the future. Marking all objects
 		 * as used avoids touching the remaining objects.
 		 */
 		slab_fix(s, "Marking all objects used");
-		page->inuse = page->objects;
-		page->freelist = NULL;
+		slab->inuse = slab->objects;
+		slab->freelist = NULL;
 	}
 	return 0;
 }
 
 static inline int free_consistency_checks(struct kmem_cache *s,
-		struct page *page, void *object, unsigned long addr)
+		struct slab *slab, void *object, unsigned long addr)
 {
-	if (!check_valid_pointer(s, page, object)) {
-		slab_err(s, page, "Invalid object pointer 0x%p", object);
+	if (!check_valid_pointer(s, slab, object)) {
+		slab_err(s, slab, "Invalid object pointer 0x%p", object);
 		return 0;
 	}
 
-	if (on_freelist(s, page, object)) {
-		object_err(s, page, object, "Object already free");
+	if (on_freelist(s, slab, object)) {
+		object_err(s, slab, object, "Object already free");
 		return 0;
 	}
 
-	if (!check_object(s, page, object, SLUB_RED_ACTIVE))
+	if (!check_object(s, slab, object, SLUB_RED_ACTIVE))
 		return 0;
 
-	if (unlikely(s != page->slab_cache)) {
-		if (!PageSlab(page)) {
-			slab_err(s, page, "Attempt to free object(0x%p) outside of slab",
+	if (unlikely(s != slab->slab_cache)) {
+		if (!folio_test_slab(slab_folio(slab))) {
+			slab_err(s, slab, "Attempt to free object(0x%p) outside of slab",
 				 object);
-		} else if (!page->slab_cache) {
+		} else if (!slab->slab_cache) {
 			pr_err("SLUB <none>: no slab for object 0x%p.\n",
 			       object);
 			dump_stack();
 		} else
-			object_err(s, page, object,
+			object_err(s, slab, object,
 					"page slab pointer corrupt.");
 		return 0;
 	}
@@ -1370,21 +1370,21 @@ static inline int free_consistency_checks(struct kmem_cache *s,
 
 /* Supports checking bulk free of a constructed freelist */
 static noinline int free_debug_processing(
-	struct kmem_cache *s, struct page *page,
+	struct kmem_cache *s, struct slab *slab,
 	void *head, void *tail, int bulk_cnt,
 	unsigned long addr)
 {
-	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
+	struct kmem_cache_node *n = get_node(s, slab_nid(slab));
 	void *object = head;
 	int cnt = 0;
 	unsigned long flags, flags2;
 	int ret = 0;
 
 	spin_lock_irqsave(&n->list_lock, flags);
-	slab_lock(page, &flags2);
+	slab_lock(slab, &flags2);
 
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
-		if (!check_slab(s, page))
+		if (!check_slab(s, slab))
 			goto out;
 	}
 
@@ -1392,13 +1392,13 @@ static noinline int free_debug_processing(
 	cnt++;
 
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
-		if (!free_consistency_checks(s, page, object, addr))
+		if (!free_consistency_checks(s, slab, object, addr))
 			goto out;
 	}
 
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, object, TRACK_FREE, addr);
-	trace(s, page, object, 0);
+	trace(s, slab, object, 0);
 	/* Freepointer not overwritten by init_object(), SLAB_POISON moved it */
 	init_object(s, object, SLUB_RED_INACTIVE);
 
@@ -1411,10 +1411,10 @@ static noinline int free_debug_processing(
 
 out:
 	if (cnt != bulk_cnt)
-		slab_err(s, page, "Bulk freelist count(%d) invalid(%d)\n",
+		slab_err(s, slab, "Bulk freelist count(%d) invalid(%d)\n",
 			 bulk_cnt, cnt);
 
-	slab_unlock(page, &flags2);
+	slab_unlock(slab, &flags2);
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	if (!ret)
 		slab_fix(s, "Object at 0x%p not freed", object);
@@ -1629,26 +1629,26 @@ slab_flags_t kmem_cache_flags(unsigned int object_size,
 }
 #else /* !CONFIG_SLUB_DEBUG */
 static inline void setup_object_debug(struct kmem_cache *s,
-			struct page *page, void *object) {}
+			struct slab *slab, void *object) {}
 static inline
-void setup_page_debug(struct kmem_cache *s, struct page *page, void *addr) {}
+void setup_slab_debug(struct kmem_cache *s, struct slab *slab, void *addr) {}
 
 static inline int alloc_debug_processing(struct kmem_cache *s,
-	struct page *page, void *object, unsigned long addr) { return 0; }
+	struct slab *slab, void *object, unsigned long addr) { return 0; }
 
 static inline int free_debug_processing(
-	struct kmem_cache *s, struct page *page,
+	struct kmem_cache *s, struct slab *slab,
 	void *head, void *tail, int bulk_cnt,
 	unsigned long addr) { return 0; }
 
-static inline int slab_pad_check(struct kmem_cache *s, struct page *page)
+static inline int slab_pad_check(struct kmem_cache *s, struct slab *slab)
 			{ return 1; }
-static inline int check_object(struct kmem_cache *s, struct page *page,
+static inline int check_object(struct kmem_cache *s, struct slab *slab,
 			void *object, u8 val) { return 1; }
 static inline void add_full(struct kmem_cache *s, struct kmem_cache_node *n,
-					struct page *page) {}
+					struct slab *slab) {}
 static inline void remove_full(struct kmem_cache *s, struct kmem_cache_node *n,
-					struct page *page) {}
+					struct slab *slab) {}
 slab_flags_t kmem_cache_flags(unsigned int object_size,
 	slab_flags_t flags, const char *name)
 {
@@ -1667,7 +1667,7 @@ static inline void inc_slabs_node(struct kmem_cache *s, int node,
 static inline void dec_slabs_node(struct kmem_cache *s, int node,
 							int objects) {}
 
-static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
+static bool freelist_corrupted(struct kmem_cache *s, struct slab *slab,
 			       void **freelist, void *nextfree)
 {
 	return false;
@@ -1772,10 +1772,10 @@ static inline bool slab_free_freelist_hook(struct kmem_cache *s,
 	return *head != NULL;
 }
 
-static void *setup_object(struct kmem_cache *s, struct page *page,
+static void *setup_object(struct kmem_cache *s, struct slab *slab,
 				void *object)
 {
-	setup_object_debug(s, page, object);
+	setup_object_debug(s, slab, object);
 	object = kasan_init_slab_obj(s, object);
 	if (unlikely(s->ctor)) {
 		kasan_unpoison_object_data(s, object);
@@ -1853,7 +1853,7 @@ static void __init init_freelist_randomization(void)
 }
 
 /* Get the next entry on the pre-computed freelist randomized */
-static void *next_freelist_entry(struct kmem_cache *s, struct page *page,
+static void *next_freelist_entry(struct kmem_cache *s, struct slab *slab,
 				unsigned long *pos, void *start,
 				unsigned long page_limit,
 				unsigned long freelist_count)
@@ -1875,32 +1875,32 @@ static void *next_freelist_entry(struct kmem_cache *s, struct page *page,
 }
 
 /* Shuffle the single linked freelist based on a random pre-computed sequence */
-static bool shuffle_freelist(struct kmem_cache *s, struct page *page)
+static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
 {
 	void *start;
 	void *cur;
 	void *next;
 	unsigned long idx, pos, page_limit, freelist_count;
 
-	if (page->objects < 2 || !s->random_seq)
+	if (slab->objects < 2 || !s->random_seq)
 		return false;
 
 	freelist_count = oo_objects(s->oo);
 	pos = get_random_int() % freelist_count;
 
-	page_limit = page->objects * s->size;
-	start = fixup_red_left(s, page_address(page));
+	page_limit = slab->objects * s->size;
+	start = fixup_red_left(s, slab_address(slab));
 
 	/* First entry is used as the base of the freelist */
-	cur = next_freelist_entry(s, page, &pos, start, page_limit,
+	cur = next_freelist_entry(s, slab, &pos, start, page_limit,
 				freelist_count);
-	cur = setup_object(s, page, cur);
-	page->freelist = cur;
+	cur = setup_object(s, slab, cur);
+	slab->freelist = cur;
 
-	for (idx = 1; idx < page->objects; idx++) {
-		next = next_freelist_entry(s, page, &pos, start, page_limit,
+	for (idx = 1; idx < slab->objects; idx++) {
+		next = next_freelist_entry(s, slab, &pos, start, page_limit,
 			freelist_count);
-		next = setup_object(s, page, next);
+		next = setup_object(s, slab, next);
 		set_freepointer(s, cur, next);
 		cur = next;
 	}
@@ -1914,15 +1914,15 @@ static inline int init_cache_random_seq(struct kmem_cache *s)
 	return 0;
 }
 static inline void init_freelist_randomization(void) { }
-static inline bool shuffle_freelist(struct kmem_cache *s, struct page *page)
+static inline bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
 {
 	return false;
 }
 #endif /* CONFIG_SLAB_FREELIST_RANDOM */
 
-static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
+static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
-	struct page *page;
+	struct slab *slab;
 	struct kmem_cache_order_objects oo = s->oo;
 	gfp_t alloc_gfp;
 	void *start, *p, *next;
@@ -1941,60 +1941,60 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	if ((alloc_gfp & __GFP_DIRECT_RECLAIM) && oo_order(oo) > oo_order(s->min))
 		alloc_gfp = (alloc_gfp | __GFP_NOMEMALLOC) & ~(__GFP_RECLAIM|__GFP_NOFAIL);
 
-	page = slab_page(alloc_slab_page(s, alloc_gfp, node, oo));
-	if (unlikely(!page)) {
+	slab = alloc_slab_page(s, alloc_gfp, node, oo);
+	if (unlikely(!slab)) {
 		oo = s->min;
 		alloc_gfp = flags;
 		/*
 		 * Allocation may have failed due to fragmentation.
 		 * Try a lower order alloc if possible
 		 */
-		page = slab_page(alloc_slab_page(s, alloc_gfp, node, oo));
-		if (unlikely(!page))
+		slab = alloc_slab_page(s, alloc_gfp, node, oo);
+		if (unlikely(!slab))
 			goto out;
 		stat(s, ORDER_FALLBACK);
 	}
 
-	page->objects = oo_objects(oo);
+	slab->objects = oo_objects(oo);
 
-	account_slab(page_slab(page), oo_order(oo), s, flags);
+	account_slab(slab, oo_order(oo), s, flags);
 
-	page->slab_cache = s;
+	slab->slab_cache = s;
 
-	kasan_poison_slab(page);
+	kasan_poison_slab(slab_page(slab));
 
-	start = page_address(page);
+	start = slab_address(slab);
 
-	setup_page_debug(s, page, start);
+	setup_slab_debug(s, slab, start);
 
-	shuffle = shuffle_freelist(s, page);
+	shuffle = shuffle_freelist(s, slab);
 
 	if (!shuffle) {
 		start = fixup_red_left(s, start);
-		start = setup_object(s, page, start);
-		page->freelist = start;
-		for (idx = 0, p = start; idx < page->objects - 1; idx++) {
+		start = setup_object(s, slab, start);
+		slab->freelist = start;
+		for (idx = 0, p = start; idx < slab->objects - 1; idx++) {
 			next = p + s->size;
-			next = setup_object(s, page, next);
+			next = setup_object(s, slab, next);
 			set_freepointer(s, p, next);
 			p = next;
 		}
 		set_freepointer(s, p, NULL);
 	}
 
-	page->inuse = page->objects;
-	page->frozen = 1;
+	slab->inuse = slab->objects;
+	slab->frozen = 1;
 
 out:
-	if (!page)
+	if (!slab)
 		return NULL;
 
-	inc_slabs_node(s, page_to_nid(page), page->objects);
+	inc_slabs_node(s, slab_nid(slab), slab->objects);
 
-	return page;
+	return slab;
 }
 
-static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
+static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
 	if (unlikely(flags & GFP_SLAB_BUG_MASK))
 		flags = kmalloc_fix_flags(flags);
@@ -2014,9 +2014,9 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab)
 	if (kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS)) {
 		void *p;
 
-		slab_pad_check(s, folio_page(folio, 0));
+		slab_pad_check(s, slab);
 		for_each_object(p, s, slab_address(slab), slab->objects)
-			check_object(s, folio_page(folio, 0), p, SLUB_RED_INACTIVE);
+			check_object(s, slab, p, SLUB_RED_INACTIVE);
 	}
 
 	__slab_clear_pfmemalloc(slab);
@@ -2030,50 +2030,50 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab)
 
 static void rcu_free_slab(struct rcu_head *h)
 {
-	struct page *page = container_of(h, struct page, rcu_head);
+	struct slab *slab = container_of(h, struct slab, rcu_head);
 
-	__free_slab(page->slab_cache, page_slab(page));
+	__free_slab(slab->slab_cache, slab);
 }
 
-static void free_slab(struct kmem_cache *s, struct page *page)
+static void free_slab(struct kmem_cache *s, struct slab *slab)
 {
 	if (unlikely(s->flags & SLAB_TYPESAFE_BY_RCU)) {
-		call_rcu(&page->rcu_head, rcu_free_slab);
+		call_rcu(&slab->rcu_head, rcu_free_slab);
 	} else
-		__free_slab(s, page_slab(page));
+		__free_slab(s, slab);
 }
 
-static void discard_slab(struct kmem_cache *s, struct page *page)
+static void discard_slab(struct kmem_cache *s, struct slab *slab)
 {
-	dec_slabs_node(s, page_to_nid(page), page->objects);
-	free_slab(s, page);
+	dec_slabs_node(s, slab_nid(slab), slab->objects);
+	free_slab(s, slab);
 }
 
 /*
  * Management of partially allocated slabs.
  */
 static inline void
-__add_partial(struct kmem_cache_node *n, struct page *page, int tail)
+__add_partial(struct kmem_cache_node *n, struct slab *slab, int tail)
 {
 	n->nr_partial++;
 	if (tail == DEACTIVATE_TO_TAIL)
-		list_add_tail(&page->slab_list, &n->partial);
+		list_add_tail(&slab->slab_list, &n->partial);
 	else
-		list_add(&page->slab_list, &n->partial);
+		list_add(&slab->slab_list, &n->partial);
 }
 
 static inline void add_partial(struct kmem_cache_node *n,
-				struct page *page, int tail)
+				struct slab *slab, int tail)
 {
 	lockdep_assert_held(&n->list_lock);
-	__add_partial(n, page, tail);
+	__add_partial(n, slab, tail);
 }
 
 static inline void remove_partial(struct kmem_cache_node *n,
-					struct page *page)
+					struct slab *slab)
 {
 	lockdep_assert_held(&n->list_lock);
-	list_del(&page->slab_list);
+	list_del(&slab->slab_list);
 	n->nr_partial--;
 }
 
@@ -2084,12 +2084,12 @@ static inline void remove_partial(struct kmem_cache_node *n,
  * Returns a list of objects or NULL if it fails.
  */
 static inline void *acquire_slab(struct kmem_cache *s,
-		struct kmem_cache_node *n, struct page *page,
+		struct kmem_cache_node *n, struct slab *slab,
 		int mode)
 {
 	void *freelist;
 	unsigned long counters;
-	struct page new;
+	struct slab new;
 
 	lockdep_assert_held(&n->list_lock);
 
@@ -2098,11 +2098,11 @@ static inline void *acquire_slab(struct kmem_cache *s,
 	 * The old freelist is the list of objects for the
 	 * per cpu allocation list.
 	 */
-	freelist = page->freelist;
-	counters = page->counters;
+	freelist = slab->freelist;
+	counters = slab->counters;
 	new.counters = counters;
 	if (mode) {
-		new.inuse = page->objects;
+		new.inuse = slab->objects;
 		new.freelist = NULL;
 	} else {
 		new.freelist = freelist;
@@ -2111,21 +2111,21 @@ static inline void *acquire_slab(struct kmem_cache *s,
 	VM_BUG_ON(new.frozen);
 	new.frozen = 1;
 
-	if (!__cmpxchg_double_slab(s, page,
+	if (!__cmpxchg_double_slab(s, slab,
 			freelist, counters,
 			new.freelist, new.counters,
 			"acquire_slab"))
 		return NULL;
 
-	remove_partial(n, page);
+	remove_partial(n, slab);
 	WARN_ON(!freelist);
 	return freelist;
 }
 
 #ifdef CONFIG_SLUB_CPU_PARTIAL
-static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain);
+static void put_cpu_partial(struct kmem_cache *s, struct slab *slab, int drain);
 #else
-static inline void put_cpu_partial(struct kmem_cache *s, struct page *page,
+static inline void put_cpu_partial(struct kmem_cache *s, struct slab *slab,
 				   int drain) { }
 #endif
 static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
@@ -2134,12 +2134,12 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
  * Try to allocate a partial slab from a specific node.
  */
 static void *get_partial_node(struct kmem_cache *s, struct kmem_cache_node *n,
-			      struct page **ret_page, gfp_t gfpflags)
+			      struct slab **ret_slab, gfp_t gfpflags)
 {
-	struct page *page, *page2;
+	struct slab *slab, *slab2;
 	void *object = NULL;
 	unsigned long flags;
-	unsigned int partial_pages = 0;
+	unsigned int partial_slabs = 0;
 
 	/*
 	 * Racy check. If we mistakenly see no partial slabs then we
@@ -2151,28 +2151,28 @@ static void *get_partial_node(struct kmem_cache *s, struct kmem_cache_node *n,
 		return NULL;
 
 	spin_lock_irqsave(&n->list_lock, flags);
-	list_for_each_entry_safe(page, page2, &n->partial, slab_list) {
+	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
 		void *t;
 
-		if (!pfmemalloc_match(page_slab(page), gfpflags))
+		if (!pfmemalloc_match(slab, gfpflags))
 			continue;
 
-		t = acquire_slab(s, n, page, object == NULL);
+		t = acquire_slab(s, n, slab, object == NULL);
 		if (!t)
 			break;
 
 		if (!object) {
-			*ret_page = page;
+			*ret_slab = slab;
 			stat(s, ALLOC_FROM_PARTIAL);
 			object = t;
 		} else {
-			put_cpu_partial(s, page, 0);
+			put_cpu_partial(s, slab, 0);
 			stat(s, CPU_PARTIAL_NODE);
-			partial_pages++;
+			partial_slabs++;
 		}
 #ifdef CONFIG_SLUB_CPU_PARTIAL
 		if (!kmem_cache_has_cpu_partial(s)
-			|| partial_pages > s->cpu_partial_pages / 2)
+			|| partial_slabs > s->cpu_partial_slabs / 2)
 			break;
 #else
 		break;
@@ -2187,7 +2187,7 @@ static void *get_partial_node(struct kmem_cache *s, struct kmem_cache_node *n,
  * Get a page from somewhere. Search in increasing NUMA distances.
  */
 static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
-			     struct page **ret_page)
+			     struct slab **ret_slab)
 {
 #ifdef CONFIG_NUMA
 	struct zonelist *zonelist;
@@ -2229,7 +2229,7 @@ static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
 
 			if (n && cpuset_zone_allowed(zone, flags) &&
 					n->nr_partial > s->min_partial) {
-				object = get_partial_node(s, n, ret_page, flags);
+				object = get_partial_node(s, n, ret_slab, flags);
 				if (object) {
 					/*
 					 * Don't check read_mems_allowed_retry()
@@ -2251,7 +2251,7 @@ static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
  * Get a partial page, lock it and return it.
  */
 static void *get_partial(struct kmem_cache *s, gfp_t flags, int node,
-			 struct page **ret_page)
+			 struct slab **ret_slab)
 {
 	void *object;
 	int searchnode = node;
@@ -2259,11 +2259,11 @@ static void *get_partial(struct kmem_cache *s, gfp_t flags, int node,
 	if (node == NUMA_NO_NODE)
 		searchnode = numa_mem_id();
 
-	object = get_partial_node(s, get_node(s, searchnode), ret_page, flags);
+	object = get_partial_node(s, get_node(s, searchnode), ret_slab, flags);
 	if (object || node != NUMA_NO_NODE)
 		return object;
 
-	return get_any_partial(s, flags, ret_page);
+	return get_any_partial(s, flags, ret_slab);
 }
 
 #ifdef CONFIG_PREEMPTION
@@ -2345,20 +2345,20 @@ static void init_kmem_cache_cpus(struct kmem_cache *s)
  * Assumes the slab has been already safely taken away from kmem_cache_cpu
  * by the caller.
  */
-static void deactivate_slab(struct kmem_cache *s, struct page *page,
+static void deactivate_slab(struct kmem_cache *s, struct slab *slab,
 			    void *freelist)
 {
 	enum slab_modes { M_NONE, M_PARTIAL, M_FULL, M_FREE };
-	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
+	struct kmem_cache_node *n = get_node(s, slab_nid(slab));
 	int lock = 0, free_delta = 0;
 	enum slab_modes l = M_NONE, m = M_NONE;
 	void *nextfree, *freelist_iter, *freelist_tail;
 	int tail = DEACTIVATE_TO_HEAD;
 	unsigned long flags = 0;
-	struct page new;
-	struct page old;
+	struct slab new;
+	struct slab old;
 
-	if (page->freelist) {
+	if (slab->freelist) {
 		stat(s, DEACTIVATE_REMOTE_FREES);
 		tail = DEACTIVATE_TO_TAIL;
 	}
@@ -2377,7 +2377,7 @@ static void deactivate_slab(struct kmem_cache *s, struct page *page,
 		 * 'freelist_iter' is already corrupted.  So isolate all objects
 		 * starting at 'freelist_iter' by skipping them.
 		 */
-		if (freelist_corrupted(s, page, &freelist_iter, nextfree))
+		if (freelist_corrupted(s, slab, &freelist_iter, nextfree))
 			break;
 
 		freelist_tail = freelist_iter;
@@ -2404,8 +2404,8 @@ static void deactivate_slab(struct kmem_cache *s, struct page *page,
 	 */
 redo:
 
-	old.freelist = READ_ONCE(page->freelist);
-	old.counters = READ_ONCE(page->counters);
+	old.freelist = READ_ONCE(slab->freelist);
+	old.counters = READ_ONCE(slab->counters);
 	VM_BUG_ON(!old.frozen);
 
 	/* Determine target state of the slab */
@@ -2447,18 +2447,18 @@ static void deactivate_slab(struct kmem_cache *s, struct page *page,
 
 	if (l != m) {
 		if (l == M_PARTIAL)
-			remove_partial(n, page);
+			remove_partial(n, slab);
 		else if (l == M_FULL)
-			remove_full(s, n, page);
+			remove_full(s, n, slab);
 
 		if (m == M_PARTIAL)
-			add_partial(n, page, tail);
+			add_partial(n, slab, tail);
 		else if (m == M_FULL)
-			add_full(s, n, page);
+			add_full(s, n, slab);
 	}
 
 	l = m;
-	if (!cmpxchg_double_slab(s, page,
+	if (!cmpxchg_double_slab(s, slab,
 				old.freelist, old.counters,
 				new.freelist, new.counters,
 				"unfreezing slab"))
@@ -2473,26 +2473,26 @@ static void deactivate_slab(struct kmem_cache *s, struct page *page,
 		stat(s, DEACTIVATE_FULL);
 	else if (m == M_FREE) {
 		stat(s, DEACTIVATE_EMPTY);
-		discard_slab(s, page);
+		discard_slab(s, slab);
 		stat(s, FREE_SLAB);
 	}
 }
 
 #ifdef CONFIG_SLUB_CPU_PARTIAL
-static void __unfreeze_partials(struct kmem_cache *s, struct page *partial_page)
+static void __unfreeze_partials(struct kmem_cache *s, struct slab *partial_slab)
 {
 	struct kmem_cache_node *n = NULL, *n2 = NULL;
-	struct page *page, *discard_page = NULL;
+	struct slab *slab, *slab_to_discard = NULL;
 	unsigned long flags = 0;
 
-	while (partial_page) {
-		struct page new;
-		struct page old;
+	while (partial_slab) {
+		struct slab new;
+		struct slab old;
 
-		page = partial_page;
-		partial_page = page->next;
+		slab = partial_slab;
+		partial_slab = slab->next;
 
-		n2 = get_node(s, page_to_nid(page));
+		n2 = get_node(s, slab_nid(slab));
 		if (n != n2) {
 			if (n)
 				spin_unlock_irqrestore(&n->list_lock, flags);
@@ -2503,8 +2503,8 @@ static void __unfreeze_partials(struct kmem_cache *s, struct page *partial_page)
 
 		do {
 
-			old.freelist = page->freelist;
-			old.counters = page->counters;
+			old.freelist = slab->freelist;
+			old.counters = slab->counters;
 			VM_BUG_ON(!old.frozen);
 
 			new.counters = old.counters;
@@ -2512,16 +2512,16 @@ static void __unfreeze_partials(struct kmem_cache *s, struct page *partial_page)
 
 			new.frozen = 0;
 
-		} while (!__cmpxchg_double_slab(s, page,
+		} while (!__cmpxchg_double_slab(s, slab,
 				old.freelist, old.counters,
 				new.freelist, new.counters,
 				"unfreezing slab"));
 
 		if (unlikely(!new.inuse && n->nr_partial >= s->min_partial)) {
-			page->next = discard_page;
-			discard_page = page;
+			slab->next = slab_to_discard;
+			slab_to_discard = slab;
 		} else {
-			add_partial(n, page, DEACTIVATE_TO_TAIL);
+			add_partial(n, slab, DEACTIVATE_TO_TAIL);
 			stat(s, FREE_ADD_PARTIAL);
 		}
 	}
@@ -2529,12 +2529,12 @@ static void __unfreeze_partials(struct kmem_cache *s, struct page *partial_page)
 	if (n)
 		spin_unlock_irqrestore(&n->list_lock, flags);
 
-	while (discard_page) {
-		page = discard_page;
-		discard_page = discard_page->next;
+	while (slab_to_discard) {
+		slab = slab_to_discard;
+		slab_to_discard = slab_to_discard->next;
 
 		stat(s, DEACTIVATE_EMPTY);
-		discard_slab(s, page);
+		discard_slab(s, slab);
 		stat(s, FREE_SLAB);
 	}
 }
@@ -2544,28 +2544,28 @@ static void __unfreeze_partials(struct kmem_cache *s, struct page *partial_page)
  */
 static void unfreeze_partials(struct kmem_cache *s)
 {
-	struct page *partial_page;
+	struct slab *partial_slab;
 	unsigned long flags;
 
 	local_lock_irqsave(&s->cpu_slab->lock, flags);
-	partial_page = this_cpu_read(s->cpu_slab->partial);
+	partial_slab = this_cpu_read(s->cpu_slab->partial);
 	this_cpu_write(s->cpu_slab->partial, NULL);
 	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 
-	if (partial_page)
-		__unfreeze_partials(s, partial_page);
+	if (partial_slab)
+		__unfreeze_partials(s, partial_slab);
 }
 
 static void unfreeze_partials_cpu(struct kmem_cache *s,
 				  struct kmem_cache_cpu *c)
 {
-	struct page *partial_page;
+	struct slab *partial_slab;
 
-	partial_page = slub_percpu_partial(c);
+	partial_slab = slub_percpu_partial(c);
 	c->partial = NULL;
 
-	if (partial_page)
-		__unfreeze_partials(s, partial_page);
+	if (partial_slab)
+		__unfreeze_partials(s, partial_slab);
 }
 
 /*
@@ -2575,42 +2575,42 @@ static void unfreeze_partials_cpu(struct kmem_cache *s,
  * If we did not find a slot then simply move all the partials to the
  * per node partial list.
  */
-static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
+static void put_cpu_partial(struct kmem_cache *s, struct slab *slab, int drain)
 {
-	struct page *oldpage;
-	struct page *page_to_unfreeze = NULL;
+	struct slab *oldslab;
+	struct slab *slab_to_unfreeze = NULL;
 	unsigned long flags;
-	int pages = 0;
+	int slabs = 0;
 
 	local_lock_irqsave(&s->cpu_slab->lock, flags);
 
-	oldpage = this_cpu_read(s->cpu_slab->partial);
+	oldslab = this_cpu_read(s->cpu_slab->partial);
 
-	if (oldpage) {
-		if (drain && oldpage->pages >= s->cpu_partial_pages) {
+	if (oldslab) {
+		if (drain && oldslab->slabs >= s->cpu_partial_slabs) {
 			/*
 			 * Partial array is full. Move the existing set to the
 			 * per node partial list. Postpone the actual unfreezing
 			 * outside of the critical section.
 			 */
-			page_to_unfreeze = oldpage;
-			oldpage = NULL;
+			slab_to_unfreeze = oldslab;
+			oldslab = NULL;
 		} else {
-			pages = oldpage->pages;
+			slabs = oldslab->slabs;
 		}
 	}
 
-	pages++;
+	slabs++;
 
-	page->pages = pages;
-	page->next = oldpage;
+	slab->slabs = slabs;
+	slab->next = oldslab;
 
-	this_cpu_write(s->cpu_slab->partial, page);
+	this_cpu_write(s->cpu_slab->partial, slab);
 
 	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 
-	if (page_to_unfreeze) {
-		__unfreeze_partials(s, page_to_unfreeze);
+	if (slab_to_unfreeze) {
+		__unfreeze_partials(s, slab_to_unfreeze);
 		stat(s, CPU_PARTIAL_DRAIN);
 	}
 }
@@ -2626,22 +2626,22 @@ static inline void unfreeze_partials_cpu(struct kmem_cache *s,
 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
 	unsigned long flags;
-	struct page *page;
+	struct slab *slab;
 	void *freelist;
 
 	local_lock_irqsave(&s->cpu_slab->lock, flags);
 
-	page = c->page;
+	slab = c->slab;
 	freelist = c->freelist;
 
-	c->page = NULL;
+	c->slab = NULL;
 	c->freelist = NULL;
 	c->tid = next_tid(c->tid);
 
 	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 
-	if (page) {
-		deactivate_slab(s, page, freelist);
+	if (slab) {
+		deactivate_slab(s, slab, freelist);
 		stat(s, CPUSLAB_FLUSH);
 	}
 }
@@ -2650,14 +2650,14 @@ static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
 {
 	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
 	void *freelist = c->freelist;
-	struct page *page = c->page;
+	struct slab *slab = c->slab;
 
-	c->page = NULL;
+	c->slab = NULL;
 	c->freelist = NULL;
 	c->tid = next_tid(c->tid);
 
-	if (page) {
-		deactivate_slab(s, page, freelist);
+	if (slab) {
+		deactivate_slab(s, slab, freelist);
 		stat(s, CPUSLAB_FLUSH);
 	}
 
@@ -2686,7 +2686,7 @@ static void flush_cpu_slab(struct work_struct *w)
 	s = sfw->s;
 	c = this_cpu_ptr(s->cpu_slab);
 
-	if (c->page)
+	if (c->slab)
 		flush_slab(s, c);
 
 	unfreeze_partials(s);
@@ -2696,7 +2696,7 @@ static bool has_cpu_slab(int cpu, struct kmem_cache *s)
 {
 	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
 
-	return c->page || slub_percpu_partial(c);
+	return c->slab || slub_percpu_partial(c);
 }
 
 static DEFINE_MUTEX(flush_lock);
@@ -2758,19 +2758,19 @@ static int slub_cpu_dead(unsigned int cpu)
  * Check if the objects in a per cpu structure fit numa
  * locality expectations.
  */
-static inline int node_match(struct page *page, int node)
+static inline int node_match(struct slab *slab, int node)
 {
 #ifdef CONFIG_NUMA
-	if (node != NUMA_NO_NODE && page_to_nid(page) != node)
+	if (node != NUMA_NO_NODE && slab_nid(slab) != node)
 		return 0;
 #endif
 	return 1;
 }
 
 #ifdef CONFIG_SLUB_DEBUG
-static int count_free(struct page *page)
+static int count_free(struct slab *slab)
 {
-	return page->objects - page->inuse;
+	return slab->objects - slab->inuse;
 }
 
 static inline unsigned long node_nr_objs(struct kmem_cache_node *n)
@@ -2781,15 +2781,15 @@ static inline unsigned long node_nr_objs(struct kmem_cache_node *n)
 
 #if defined(CONFIG_SLUB_DEBUG) || defined(CONFIG_SYSFS)
 static unsigned long count_partial(struct kmem_cache_node *n,
-					int (*get_count)(struct page *))
+					int (*get_count)(struct slab *))
 {
 	unsigned long flags;
 	unsigned long x = 0;
-	struct page *page;
+	struct slab *slab;
 
 	spin_lock_irqsave(&n->list_lock, flags);
-	list_for_each_entry(page, &n->partial, slab_list)
-		x += get_count(page);
+	list_for_each_entry(slab, &n->partial, slab_list)
+		x += get_count(slab);
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	return x;
 }
@@ -2848,25 +2848,25 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags)
  *
  * If this function returns NULL then the page has been unfrozen.
  */
-static inline void *get_freelist(struct kmem_cache *s, struct page *page)
+static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
 {
-	struct page new;
+	struct slab new;
 	unsigned long counters;
 	void *freelist;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_slab->lock));
 
 	do {
-		freelist = page->freelist;
-		counters = page->counters;
+		freelist = slab->freelist;
+		counters = slab->counters;
 
 		new.counters = counters;
 		VM_BUG_ON(!new.frozen);
 
-		new.inuse = page->objects;
+		new.inuse = slab->objects;
 		new.frozen = freelist != NULL;
 
-	} while (!__cmpxchg_double_slab(s, page,
+	} while (!__cmpxchg_double_slab(s, slab,
 		freelist, counters,
 		NULL, new.counters,
 		"get_freelist"));
@@ -2897,15 +2897,15 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			  unsigned long addr, struct kmem_cache_cpu *c)
 {
 	void *freelist;
-	struct page *page;
+	struct slab *slab;
 	unsigned long flags;
 
 	stat(s, ALLOC_SLOWPATH);
 
 reread_page:
 
-	page = READ_ONCE(c->page);
-	if (!page) {
+	slab = READ_ONCE(c->slab);
+	if (!slab) {
 		/*
 		 * if the node is not online or has no normal memory, just
 		 * ignore the node constraint
@@ -2917,7 +2917,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	}
 redo:
 
-	if (unlikely(!node_match(page, node))) {
+	if (unlikely(!node_match(slab, node))) {
 		/*
 		 * same as above but node_match() being false already
 		 * implies node != NUMA_NO_NODE
@@ -2936,12 +2936,12 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	 * PFMEMALLOC but right now, we are losing the pfmemalloc
 	 * information when the page leaves the per-cpu allocator
 	 */
-	if (unlikely(!pfmemalloc_match(page_slab(page), gfpflags)))
+	if (unlikely(!pfmemalloc_match(slab, gfpflags)))
 		goto deactivate_slab;
 
 	/* must check again c->page in case we got preempted and it changed */
 	local_lock_irqsave(&s->cpu_slab->lock, flags);
-	if (unlikely(page != c->page)) {
+	if (unlikely(slab != c->slab)) {
 		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 		goto reread_page;
 	}
@@ -2949,10 +2949,10 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	if (freelist)
 		goto load_freelist;
 
-	freelist = get_freelist(s, page);
+	freelist = get_freelist(s, slab);
 
 	if (!freelist) {
-		c->page = NULL;
+		c->slab = NULL;
 		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 		stat(s, DEACTIVATE_BYPASS);
 		goto new_slab;
@@ -2969,7 +2969,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	 * page is pointing to the page from which the objects are obtained.
 	 * That page must be frozen for per cpu allocations to work.
 	 */
-	VM_BUG_ON(!c->page->frozen);
+	VM_BUG_ON(!c->slab->frozen);
 	c->freelist = get_freepointer(s, freelist);
 	c->tid = next_tid(c->tid);
 	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
@@ -2978,21 +2978,21 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 deactivate_slab:
 
 	local_lock_irqsave(&s->cpu_slab->lock, flags);
-	if (page != c->page) {
+	if (slab != c->slab) {
 		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 		goto reread_page;
 	}
 	freelist = c->freelist;
-	c->page = NULL;
+	c->slab = NULL;
 	c->freelist = NULL;
 	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
-	deactivate_slab(s, page, freelist);
+	deactivate_slab(s, slab, freelist);
 
 new_slab:
 
 	if (slub_percpu_partial(c)) {
 		local_lock_irqsave(&s->cpu_slab->lock, flags);
-		if (unlikely(c->page)) {
+		if (unlikely(c->slab)) {
 			local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 			goto reread_page;
 		}
@@ -3002,8 +3002,8 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			goto new_objects;
 		}
 
-		page = c->page = slub_percpu_partial(c);
-		slub_set_percpu_partial(c, page);
+		slab = c->slab = slub_percpu_partial(c);
+		slub_set_percpu_partial(c, slab);
 		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 		stat(s, CPU_PARTIAL_ALLOC);
 		goto redo;
@@ -3011,15 +3011,15 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 new_objects:
 
-	freelist = get_partial(s, gfpflags, node, &page);
+	freelist = get_partial(s, gfpflags, node, &slab);
 	if (freelist)
 		goto check_new_page;
 
 	slub_put_cpu_ptr(s->cpu_slab);
-	page = new_slab(s, gfpflags, node);
+	slab = new_slab(s, gfpflags, node);
 	c = slub_get_cpu_ptr(s->cpu_slab);
 
-	if (unlikely(!page)) {
+	if (unlikely(!slab)) {
 		slab_out_of_memory(s, gfpflags, node);
 		return NULL;
 	}
@@ -3028,15 +3028,15 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	 * No other reference to the page yet so we can
 	 * muck around with it freely without cmpxchg
 	 */
-	freelist = page->freelist;
-	page->freelist = NULL;
+	freelist = slab->freelist;
+	slab->freelist = NULL;
 
 	stat(s, ALLOC_SLAB);
 
 check_new_page:
 
 	if (kmem_cache_debug(s)) {
-		if (!alloc_debug_processing(s, page, freelist, addr)) {
+		if (!alloc_debug_processing(s, slab, freelist, addr)) {
 			/* Slab failed checks. Next slab needed */
 			goto new_slab;
 		} else {
@@ -3048,7 +3048,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 		}
 	}
 
-	if (unlikely(!pfmemalloc_match(page_slab(page), gfpflags)))
+	if (unlikely(!pfmemalloc_match(slab, gfpflags)))
 		/*
 		 * For !pfmemalloc_match() case we don't load freelist so that
 		 * we don't make further mismatched allocations easier.
@@ -3058,29 +3058,29 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 retry_load_page:
 
 	local_lock_irqsave(&s->cpu_slab->lock, flags);
-	if (unlikely(c->page)) {
+	if (unlikely(c->slab)) {
 		void *flush_freelist = c->freelist;
-		struct page *flush_page = c->page;
+		struct slab *flush_slab = c->slab;
 
-		c->page = NULL;
+		c->slab = NULL;
 		c->freelist = NULL;
 		c->tid = next_tid(c->tid);
 
 		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 
-		deactivate_slab(s, flush_page, flush_freelist);
+		deactivate_slab(s, flush_slab, flush_freelist);
 
 		stat(s, CPUSLAB_FLUSH);
 
 		goto retry_load_page;
 	}
-	c->page = page;
+	c->slab = slab;
 
 	goto load_freelist;
 
 return_single:
 
-	deactivate_slab(s, page, get_freepointer(s, freelist));
+	deactivate_slab(s, slab, get_freepointer(s, freelist));
 	return freelist;
 }
 
@@ -3137,7 +3137,7 @@ static __always_inline void *slab_alloc_node(struct kmem_cache *s,
 {
 	void *object;
 	struct kmem_cache_cpu *c;
-	struct page *page;
+	struct slab *slab;
 	unsigned long tid;
 	struct obj_cgroup *objcg = NULL;
 	bool init = false;
@@ -3184,7 +3184,7 @@ static __always_inline void *slab_alloc_node(struct kmem_cache *s,
 	 */
 
 	object = c->freelist;
-	page = c->page;
+	slab = c->slab;
 	/*
 	 * We cannot use the lockless fastpath on PREEMPT_RT because if a
 	 * slowpath has taken the local_lock_irqsave(), it is not protected
@@ -3193,7 +3193,7 @@ static __always_inline void *slab_alloc_node(struct kmem_cache *s,
 	 * there is a suitable cpu freelist.
 	 */
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) ||
-	    unlikely(!object || !page || !node_match(page, node))) {
+	    unlikely(!object || !slab || !node_match(slab, node))) {
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 	} else {
 		void *next_object = get_freepointer_safe(s, object);
@@ -3298,14 +3298,14 @@ EXPORT_SYMBOL(kmem_cache_alloc_node_trace);
  * lock and free the item. If there is no additional partial page
  * handling required then we can return immediately.
  */
-static void __slab_free(struct kmem_cache *s, struct page *page,
+static void __slab_free(struct kmem_cache *s, struct slab *slab,
 			void *head, void *tail, int cnt,
 			unsigned long addr)
 
 {
 	void *prior;
 	int was_frozen;
-	struct page new;
+	struct slab new;
 	unsigned long counters;
 	struct kmem_cache_node *n = NULL;
 	unsigned long flags;
@@ -3316,7 +3316,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 		return;
 
 	if (kmem_cache_debug(s) &&
-	    !free_debug_processing(s, page, head, tail, cnt, addr))
+	    !free_debug_processing(s, slab, head, tail, cnt, addr))
 		return;
 
 	do {
@@ -3324,8 +3324,8 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 			spin_unlock_irqrestore(&n->list_lock, flags);
 			n = NULL;
 		}
-		prior = page->freelist;
-		counters = page->counters;
+		prior = slab->freelist;
+		counters = slab->counters;
 		set_freepointer(s, tail, prior);
 		new.counters = counters;
 		was_frozen = new.frozen;
@@ -3344,7 +3344,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 
 			} else { /* Needs to be taken off a list */
 
-				n = get_node(s, page_to_nid(page));
+				n = get_node(s, slab_nid(slab));
 				/*
 				 * Speculatively acquire the list_lock.
 				 * If the cmpxchg does not succeed then we may
@@ -3358,7 +3358,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 			}
 		}
 
-	} while (!cmpxchg_double_slab(s, page,
+	} while (!cmpxchg_double_slab(s, slab,
 		prior, counters,
 		head, new.counters,
 		"__slab_free"));
@@ -3376,7 +3376,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 			 * If we just froze the page then put it onto the
 			 * per cpu partial list.
 			 */
-			put_cpu_partial(s, page, 1);
+			put_cpu_partial(s, slab, 1);
 			stat(s, CPU_PARTIAL_FREE);
 		}
 
@@ -3391,8 +3391,8 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 	 * then add it.
 	 */
 	if (!kmem_cache_has_cpu_partial(s) && unlikely(!prior)) {
-		remove_full(s, n, page);
-		add_partial(n, page, DEACTIVATE_TO_TAIL);
+		remove_full(s, n, slab);
+		add_partial(n, slab, DEACTIVATE_TO_TAIL);
 		stat(s, FREE_ADD_PARTIAL);
 	}
 	spin_unlock_irqrestore(&n->list_lock, flags);
@@ -3403,16 +3403,16 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 		/*
 		 * Slab on the partial list.
 		 */
-		remove_partial(n, page);
+		remove_partial(n, slab);
 		stat(s, FREE_REMOVE_PARTIAL);
 	} else {
 		/* Slab must be on the full list */
-		remove_full(s, n, page);
+		remove_full(s, n, slab);
 	}
 
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	stat(s, FREE_SLAB);
-	discard_slab(s, page);
+	discard_slab(s, slab);
 }
 
 /*
@@ -3431,7 +3431,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
  * count (cnt). Bulk free indicated by tail pointer being set.
  */
 static __always_inline void do_slab_free(struct kmem_cache *s,
-				struct page *page, void *head, void *tail,
+				struct slab *slab, void *head, void *tail,
 				int cnt, unsigned long addr)
 {
 	void *tail_obj = tail ? : head;
@@ -3454,7 +3454,7 @@ static __always_inline void do_slab_free(struct kmem_cache *s,
 	/* Same with comment on barrier() in slab_alloc_node() */
 	barrier();
 
-	if (likely(page == c->page)) {
+	if (likely(slab == c->slab)) {
 #ifndef CONFIG_PREEMPT_RT
 		void **freelist = READ_ONCE(c->freelist);
 
@@ -3480,7 +3480,7 @@ static __always_inline void do_slab_free(struct kmem_cache *s,
 
 		local_lock(&s->cpu_slab->lock);
 		c = this_cpu_ptr(s->cpu_slab);
-		if (unlikely(page != c->page)) {
+		if (unlikely(slab != c->slab)) {
 			local_unlock(&s->cpu_slab->lock);
 			goto redo;
 		}
@@ -3495,11 +3495,11 @@ static __always_inline void do_slab_free(struct kmem_cache *s,
 #endif
 		stat(s, FREE_FASTPATH);
 	} else
-		__slab_free(s, page, head, tail_obj, cnt, addr);
+		__slab_free(s, slab, head, tail_obj, cnt, addr);
 
 }
 
-static __always_inline void slab_free(struct kmem_cache *s, struct page *page,
+static __always_inline void slab_free(struct kmem_cache *s, struct slab *slab,
 				      void *head, void *tail, int cnt,
 				      unsigned long addr)
 {
@@ -3508,13 +3508,13 @@ static __always_inline void slab_free(struct kmem_cache *s, struct page *page,
 	 * to remove objects, whose reuse must be delayed.
 	 */
 	if (slab_free_freelist_hook(s, &head, &tail, &cnt))
-		do_slab_free(s, page, head, tail, cnt, addr);
+		do_slab_free(s, slab, head, tail, cnt, addr);
 }
 
 #ifdef CONFIG_KASAN_GENERIC
 void ___cache_free(struct kmem_cache *cache, void *x, unsigned long addr)
 {
-	do_slab_free(cache, slab_page(virt_to_slab(x)), x, NULL, 1, addr);
+	do_slab_free(cache, virt_to_slab(x), x, NULL, 1, addr);
 }
 #endif
 
@@ -3524,7 +3524,7 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 	if (!s)
 		return;
 	trace_kmem_cache_free(_RET_IP_, x, s->name);
-	slab_free(s, slab_page(virt_to_slab(x)), x, NULL, 1, _RET_IP_);
+	slab_free(s, virt_to_slab(x), x, NULL, 1, _RET_IP_);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -3654,7 +3654,7 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 		if (!df.slab)
 			continue;
 
-		slab_free(df.s, slab_page(df.slab), df.freelist, df.tail, df.cnt, _RET_IP_);
+		slab_free(df.s, df.slab, df.freelist, df.tail, df.cnt, _RET_IP_);
 	} while (likely(size));
 }
 EXPORT_SYMBOL(kmem_cache_free_bulk);
@@ -3924,38 +3924,38 @@ static struct kmem_cache *kmem_cache_node;
  */
 static void early_kmem_cache_node_alloc(int node)
 {
-	struct page *page;
+	struct slab *slab;
 	struct kmem_cache_node *n;
 
 	BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));
 
-	page = new_slab(kmem_cache_node, GFP_NOWAIT, node);
+	slab = new_slab(kmem_cache_node, GFP_NOWAIT, node);
 
-	BUG_ON(!page);
-	if (page_to_nid(page) != node) {
+	BUG_ON(!slab);
+	if (slab_nid(slab) != node) {
 		pr_err("SLUB: Unable to allocate memory from node %d\n", node);
 		pr_err("SLUB: Allocating a useless per node structure in order to be able to continue\n");
 	}
 
-	n = page->freelist;
+	n = slab->freelist;
 	BUG_ON(!n);
 #ifdef CONFIG_SLUB_DEBUG
 	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
 	init_tracking(kmem_cache_node, n);
 #endif
 	n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL, false);
-	page->freelist = get_freepointer(kmem_cache_node, n);
-	page->inuse = 1;
-	page->frozen = 0;
+	slab->freelist = get_freepointer(kmem_cache_node, n);
+	slab->inuse = 1;
+	slab->frozen = 0;
 	kmem_cache_node->node[node] = n;
 	init_kmem_cache_node(n);
-	inc_slabs_node(kmem_cache_node, node, page->objects);
+	inc_slabs_node(kmem_cache_node, node, slab->objects);
 
 	/*
 	 * No locks need to be taken here as it has just been
 	 * initialized and there is no concurrent access.
 	 */
-	__add_partial(n, page, DEACTIVATE_TO_HEAD);
+	__add_partial(n, slab, DEACTIVATE_TO_HEAD);
 }
 
 static void free_kmem_cache_nodes(struct kmem_cache *s)
@@ -4241,20 +4241,20 @@ static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
 	return -EINVAL;
 }
 
-static void list_slab_objects(struct kmem_cache *s, struct page *page,
+static void list_slab_objects(struct kmem_cache *s, struct slab *slab,
 			      const char *text)
 {
 #ifdef CONFIG_SLUB_DEBUG
-	void *addr = page_address(page);
+	void *addr = slab_address(slab);
 	unsigned long flags;
 	unsigned long *map;
 	void *p;
 
-	slab_err(s, page, text, s->name);
-	slab_lock(page, &flags);
+	slab_err(s, slab, text, s->name);
+	slab_lock(slab, &flags);
 
-	map = get_map(s, page);
-	for_each_object(p, s, addr, page->objects) {
+	map = get_map(s, slab);
+	for_each_object(p, s, addr, slab->objects) {
 
 		if (!test_bit(__obj_to_index(s, addr, p), map)) {
 			pr_err("Object 0x%p @offset=%tu\n", p, p - addr);
@@ -4262,7 +4262,7 @@ static void list_slab_objects(struct kmem_cache *s, struct page *page,
 		}
 	}
 	put_map(map);
-	slab_unlock(page, &flags);
+	slab_unlock(slab, &flags);
 #endif
 }
 
@@ -4274,23 +4274,23 @@ static void list_slab_objects(struct kmem_cache *s, struct page *page,
 static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
 {
 	LIST_HEAD(discard);
-	struct page *page, *h;
+	struct slab *slab, *h;
 
 	BUG_ON(irqs_disabled());
 	spin_lock_irq(&n->list_lock);
-	list_for_each_entry_safe(page, h, &n->partial, slab_list) {
-		if (!page->inuse) {
-			remove_partial(n, page);
-			list_add(&page->slab_list, &discard);
+	list_for_each_entry_safe(slab, h, &n->partial, slab_list) {
+		if (!slab->inuse) {
+			remove_partial(n, slab);
+			list_add(&slab->slab_list, &discard);
 		} else {
-			list_slab_objects(s, page,
+			list_slab_objects(s, slab,
 			  "Objects remaining in %s on __kmem_cache_shutdown()");
 		}
 	}
 	spin_unlock_irq(&n->list_lock);
 
-	list_for_each_entry_safe(page, h, &discard, slab_list)
-		discard_slab(s, page);
+	list_for_each_entry_safe(slab, h, &discard, slab_list)
+		discard_slab(s, slab);
 }
 
 bool __kmem_cache_empty(struct kmem_cache *s)
@@ -4560,7 +4560,7 @@ void kfree(const void *x)
 		return;
 	}
 	slab = folio_slab(folio);
-	slab_free(slab->slab_cache, slab_page(slab), object, NULL, 1, _RET_IP_);
+	slab_free(slab->slab_cache, slab, object, NULL, 1, _RET_IP_);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -4580,8 +4580,8 @@ static int __kmem_cache_do_shrink(struct kmem_cache *s)
 	int node;
 	int i;
 	struct kmem_cache_node *n;
-	struct page *page;
-	struct page *t;
+	struct slab *slab;
+	struct slab *t;
 	struct list_head discard;
 	struct list_head promote[SHRINK_PROMOTE_MAX];
 	unsigned long flags;
@@ -4600,8 +4600,8 @@ static int __kmem_cache_do_shrink(struct kmem_cache *s)
 		 * Note that concurrent frees may occur while we hold the
 		 * list_lock. page->inuse here is the upper limit.
 		 */
-		list_for_each_entry_safe(page, t, &n->partial, slab_list) {
-			int free = page->objects - page->inuse;
+		list_for_each_entry_safe(slab, t, &n->partial, slab_list) {
+			int free = slab->objects - slab->inuse;
 
 			/* Do not reread page->inuse */
 			barrier();
@@ -4609,11 +4609,11 @@ static int __kmem_cache_do_shrink(struct kmem_cache *s)
 			/* We do not keep full slabs on the list */
 			BUG_ON(free <= 0);
 
-			if (free == page->objects) {
-				list_move(&page->slab_list, &discard);
+			if (free == slab->objects) {
+				list_move(&slab->slab_list, &discard);
 				n->nr_partial--;
 			} else if (free <= SHRINK_PROMOTE_MAX)
-				list_move(&page->slab_list, promote + free - 1);
+				list_move(&slab->slab_list, promote + free - 1);
 		}
 
 		/*
@@ -4626,8 +4626,8 @@ static int __kmem_cache_do_shrink(struct kmem_cache *s)
 		spin_unlock_irqrestore(&n->list_lock, flags);
 
 		/* Release empty slabs */
-		list_for_each_entry_safe(page, t, &discard, slab_list)
-			discard_slab(s, page);
+		list_for_each_entry_safe(slab, t, &discard, slab_list)
+			discard_slab(s, slab);
 
 		if (slabs_node(s, node))
 			ret = 1;
@@ -4788,7 +4788,7 @@ static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
 	 */
 	__flush_cpu_slab(s, smp_processor_id());
 	for_each_kmem_cache_node(s, node, n) {
-		struct page *p;
+		struct slab *p;
 
 		list_for_each_entry(p, &n->partial, slab_list)
 			p->slab_cache = s;
@@ -4966,54 +4966,54 @@ EXPORT_SYMBOL(__kmalloc_node_track_caller);
 #endif
 
 #ifdef CONFIG_SYSFS
-static int count_inuse(struct page *page)
+static int count_inuse(struct slab *slab)
 {
-	return page->inuse;
+	return slab->inuse;
 }
 
-static int count_total(struct page *page)
+static int count_total(struct slab *slab)
 {
-	return page->objects;
+	return slab->objects;
 }
 #endif
 
 #ifdef CONFIG_SLUB_DEBUG
-static void validate_slab(struct kmem_cache *s, struct page *page,
+static void validate_slab(struct kmem_cache *s, struct slab *slab,
 			  unsigned long *obj_map)
 {
 	void *p;
-	void *addr = page_address(page);
+	void *addr = slab_address(slab);
 	unsigned long flags;
 
-	slab_lock(page, &flags);
+	slab_lock(slab, &flags);
 
-	if (!check_slab(s, page) || !on_freelist(s, page, NULL))
+	if (!check_slab(s, slab) || !on_freelist(s, slab, NULL))
 		goto unlock;
 
 	/* Now we know that a valid freelist exists */
-	__fill_map(obj_map, s, page);
-	for_each_object(p, s, addr, page->objects) {
+	__fill_map(obj_map, s, slab);
+	for_each_object(p, s, addr, slab->objects) {
 		u8 val = test_bit(__obj_to_index(s, addr, p), obj_map) ?
 			 SLUB_RED_INACTIVE : SLUB_RED_ACTIVE;
 
-		if (!check_object(s, page, p, val))
+		if (!check_object(s, slab, p, val))
 			break;
 	}
 unlock:
-	slab_unlock(page, &flags);
+	slab_unlock(slab, &flags);
 }
 
 static int validate_slab_node(struct kmem_cache *s,
 		struct kmem_cache_node *n, unsigned long *obj_map)
 {
 	unsigned long count = 0;
-	struct page *page;
+	struct slab *slab;
 	unsigned long flags;
 
 	spin_lock_irqsave(&n->list_lock, flags);
 
-	list_for_each_entry(page, &n->partial, slab_list) {
-		validate_slab(s, page, obj_map);
+	list_for_each_entry(slab, &n->partial, slab_list) {
+		validate_slab(s, slab, obj_map);
 		count++;
 	}
 	if (count != n->nr_partial) {
@@ -5025,8 +5025,8 @@ static int validate_slab_node(struct kmem_cache *s,
 	if (!(s->flags & SLAB_STORE_USER))
 		goto out;
 
-	list_for_each_entry(page, &n->full, slab_list) {
-		validate_slab(s, page, obj_map);
+	list_for_each_entry(slab, &n->full, slab_list) {
+		validate_slab(s, slab, obj_map);
 		count++;
 	}
 	if (count != atomic_long_read(&n->nr_slabs)) {
@@ -5192,15 +5192,15 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 }
 
 static void process_slab(struct loc_track *t, struct kmem_cache *s,
-		struct page *page, enum track_item alloc,
+		struct slab *slab, enum track_item alloc,
 		unsigned long *obj_map)
 {
-	void *addr = page_address(page);
+	void *addr = slab_address(slab);
 	void *p;
 
-	__fill_map(obj_map, s, page);
+	__fill_map(obj_map, s, slab);
 
-	for_each_object(p, s, addr, page->objects)
+	for_each_object(p, s, addr, slab->objects)
 		if (!test_bit(__obj_to_index(s, addr, p), obj_map))
 			add_location(t, s, get_track(s, p, alloc));
 }
@@ -5242,32 +5242,32 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 			struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab,
 							       cpu);
 			int node;
-			struct page *page;
+			struct slab *slab;
 
-			page = READ_ONCE(c->page);
-			if (!page)
+			slab = READ_ONCE(c->slab);
+			if (!slab)
 				continue;
 
-			node = page_to_nid(page);
+			node = slab_nid(slab);
 			if (flags & SO_TOTAL)
-				x = page->objects;
+				x = slab->objects;
 			else if (flags & SO_OBJECTS)
-				x = page->inuse;
+				x = slab->inuse;
 			else
 				x = 1;
 
 			total += x;
 			nodes[node] += x;
 
-			page = slub_percpu_partial_read_once(c);
-			if (page) {
-				node = page_to_nid(page);
+			slab = slub_percpu_partial_read_once(c);
+			if (slab) {
+				node = slab_nid(slab);
 				if (flags & SO_TOTAL)
 					WARN_ON_ONCE(1);
 				else if (flags & SO_OBJECTS)
 					WARN_ON_ONCE(1);
 				else
-					x = page->pages;
+					x = slab->slabs;
 				total += x;
 				nodes[node] += x;
 			}
@@ -5469,33 +5469,33 @@ SLAB_ATTR_RO(objects_partial);
 static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
 {
 	int objects = 0;
-	int pages = 0;
+	int slabs = 0;
 	int cpu;
 	int len = 0;
 
 	for_each_online_cpu(cpu) {
-		struct page *page;
+		struct slab *slab;
 
-		page = slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
+		slab = slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
 
-		if (page)
-			pages += page->pages;
+		if (slab)
+			slabs += slab->slabs;
 	}
 
 	/* Approximate half-full pages , see slub_set_cpu_partial() */
-	objects = (pages * oo_objects(s->oo)) / 2;
-	len += sysfs_emit_at(buf, len, "%d(%d)", objects, pages);
+	objects = (slabs * oo_objects(s->oo)) / 2;
+	len += sysfs_emit_at(buf, len, "%d(%d)", objects, slabs);
 
 #ifdef CONFIG_SMP
 	for_each_online_cpu(cpu) {
-		struct page *page;
+		struct slab *slab;
 
-		page = slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
-		if (page) {
-			pages = READ_ONCE(page->pages);
-			objects = (pages * oo_objects(s->oo)) / 2;
+		slab = slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
+		if (slab) {
+			slabs = READ_ONCE(slab->slabs);
+			objects = (slabs * oo_objects(s->oo)) / 2;
 			len += sysfs_emit_at(buf, len, " C%d=%d(%d)",
-					     cpu, objects, pages);
+					     cpu, objects, slabs);
 		}
 	}
 #endif
@@ -6163,16 +6163,16 @@ static int slab_debug_trace_open(struct inode *inode, struct file *filep)
 
 	for_each_kmem_cache_node(s, node, n) {
 		unsigned long flags;
-		struct page *page;
+		struct slab *slab;
 
 		if (!atomic_long_read(&n->nr_slabs))
 			continue;
 
 		spin_lock_irqsave(&n->list_lock, flags);
-		list_for_each_entry(page, &n->partial, slab_list)
-			process_slab(t, s, page, alloc, obj_map);
-		list_for_each_entry(page, &n->full, slab_list)
-			process_slab(t, s, page, alloc, obj_map);
+		list_for_each_entry(slab, &n->partial, slab_list)
+			process_slab(t, s, slab, alloc, obj_map);
+		list_for_each_entry(slab, &n->full, slab_list)
+			process_slab(t, s, slab, alloc, obj_map);
 		spin_unlock_irqrestore(&n->list_lock, flags);
 	}
 
-- 
2.34.1

