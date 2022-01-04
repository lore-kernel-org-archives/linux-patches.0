Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047732CA0
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:58 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7CF721F3A3;
	Tue,  4 Jan 2022 00:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p3xfG2yktxRUwtrWucIgvSuDXBIjh2YgtsV7uHrjvrk=;
	b=BTqQwdCk+F/mpmzn861d3Ye/LBW4bJ3QI9wpVZ69KnH2OvQ52owpQq2GCU/XwN3MHeF4Hl
	rJS3H+jQHNvpAVJNuRg+rjmSIuOIRR0iYHC3aOIF9h22Ui/a2ApJk/CNkyeKEcbQBkI73g
	3DUbH3nwJTbE07dGzSVcsgPUzZuiETo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p3xfG2yktxRUwtrWucIgvSuDXBIjh2YgtsV7uHrjvrk=;
	b=5xzXhF9uUvNKed6++MVVq6jAZeeT4FDn/kYmgpehRjrudQjjLHAW8kxxjnyKhWujUxJ29F
	pdz3Qq1Kb3QOWFDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4E5F8139EE;
	Tue,  4 Jan 2022 00:10:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 2FmOEo6Q02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:54 +0000
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
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v4 09/32] mm: Convert check_heap_object() to use struct slab
Date: Tue,  4 Jan 2022 01:10:23 +0100
Message-Id: <20220104001046.12263-10-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6809; i=vbabka@suse.cz; h=from:subject; bh=htdqmLS/rsR83GWzffNKUh7c+r8oOHLC8R6c+MHIv3Y=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05BxKUWz0PoHB9enCrkaS8BYF67mI2OZLc0Kk+xU 76QRoTKJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQcQAKCRDgIcpz8YmpEFQ9B/ 4k4PvrVFvoLaFW4FwS+T8fImIF67F3zsO6oCMGCsVyf5FyRAYTkADTuk86mXoRwhCQ4rGpucQAp/Nj /rn0qRXcx4t0JBSWGMQlwGn+Id0cNKPf4NLdJP8fUvCvTzwIMHeGsV43Ar0FmjxLuysuuGrn/b7/1+ ScbgOnMSa4D9q3TIdNmeCKX+lhGOxRLbWDNVwNk5IYIkq51/10fMBH6oGQf1gPv1h9g17Fyx3MDkzl T3CR8ceHcQOcEzoqdE5F9idMNNuIaWgBXn/Ba4LCRVLQpuQ4HMS7oeN/LB05iSJYbJvyZropRypFBW SaMuXwbniqR6SGBvUX0iCKqY8iqXoR
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Ensure that we're not seeing a tail page inside __check_heap_object() by
converting to a slab instead of a page.  Take the opportunity to mark
the slab as const since we're not modifying it.  Also move the
declaration of __check_heap_object() to mm/slab.h so it's not available
to the wider kernel.

[ vbabka@suse.cz: in check_heap_object() only convert to struct slab for
  actual PageSlab pages; use folio as intermediate step instead of page ]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <guro@fb.com>
---
 include/linux/slab.h |  8 --------
 mm/slab.c            | 14 +++++++-------
 mm/slab.h            | 11 +++++++++++
 mm/slub.c            | 10 +++++-----
 mm/usercopy.c        | 13 +++++++------
 5 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 181045148b06..367366f1d1ff 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -189,14 +189,6 @@ bool kmem_valid_obj(void *object);
 void kmem_dump_obj(void *object);
 #endif
 
-#ifdef CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR
-void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
-			bool to_user);
-#else
-static inline void __check_heap_object(const void *ptr, unsigned long n,
-				       struct page *page, bool to_user) { }
-#endif
-
 /*
  * Some archs want to perform DMA into kmalloc caches and need a guaranteed
  * alignment larger than the alignment of a 64-bit integer.
diff --git a/mm/slab.c b/mm/slab.c
index 44bc1fcd1393..38fcd3f496df 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -372,8 +372,8 @@ static void **dbg_userword(struct kmem_cache *cachep, void *objp)
 static int slab_max_order = SLAB_MAX_ORDER_LO;
 static bool slab_max_order_set __initdata;
 
-static inline void *index_to_obj(struct kmem_cache *cache, struct page *page,
-				 unsigned int idx)
+static inline void *index_to_obj(struct kmem_cache *cache,
+				 const struct page *page, unsigned int idx)
 {
 	return page->s_mem + cache->size * idx;
 }
@@ -4166,8 +4166,8 @@ ssize_t slabinfo_write(struct file *file, const char __user *buffer,
  * Returns NULL if check passes, otherwise const char * to name of cache
  * to indicate an error.
  */
-void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
-			 bool to_user)
+void __check_heap_object(const void *ptr, unsigned long n,
+			 const struct slab *slab, bool to_user)
 {
 	struct kmem_cache *cachep;
 	unsigned int objnr;
@@ -4176,15 +4176,15 @@ void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
 	ptr = kasan_reset_tag(ptr);
 
 	/* Find and validate object. */
-	cachep = page->slab_cache;
-	objnr = obj_to_index(cachep, page, (void *)ptr);
+	cachep = slab->slab_cache;
+	objnr = obj_to_index(cachep, slab_page(slab), (void *)ptr);
 	BUG_ON(objnr >= cachep->num);
 
 	/* Find offset within object. */
 	if (is_kfence_address(ptr))
 		offset = ptr - kfence_object_start(ptr);
 	else
-		offset = ptr - index_to_obj(cachep, page, objnr) - obj_offset(cachep);
+		offset = ptr - index_to_obj(cachep, slab_page(slab), objnr) - obj_offset(cachep);
 
 	/* Allow address range falling entirely within usercopy region. */
 	if (offset >= cachep->useroffset &&
diff --git a/mm/slab.h b/mm/slab.h
index 9ae9f6c3d1cb..039babfde2fe 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -812,4 +812,15 @@ struct kmem_obj_info {
 void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab);
 #endif
 
+#ifdef CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR
+void __check_heap_object(const void *ptr, unsigned long n,
+			 const struct slab *slab, bool to_user);
+#else
+static inline
+void __check_heap_object(const void *ptr, unsigned long n,
+			 const struct slab *slab, bool to_user)
+{
+}
+#endif
+
 #endif /* MM_SLAB_H */
diff --git a/mm/slub.c b/mm/slub.c
index 8e9667815f81..8b82188849ae 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4485,8 +4485,8 @@ EXPORT_SYMBOL(__kmalloc_node);
  * Returns NULL if check passes, otherwise const char * to name of cache
  * to indicate an error.
  */
-void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
-			 bool to_user)
+void __check_heap_object(const void *ptr, unsigned long n,
+			 const struct slab *slab, bool to_user)
 {
 	struct kmem_cache *s;
 	unsigned int offset;
@@ -4495,10 +4495,10 @@ void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
 	ptr = kasan_reset_tag(ptr);
 
 	/* Find object and usable object size. */
-	s = page->slab_cache;
+	s = slab->slab_cache;
 
 	/* Reject impossible pointers. */
-	if (ptr < page_address(page))
+	if (ptr < slab_address(slab))
 		usercopy_abort("SLUB object not in SLUB page?!", NULL,
 			       to_user, 0, n);
 
@@ -4506,7 +4506,7 @@ void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
 	if (is_kfence)
 		offset = ptr - kfence_object_start(ptr);
 	else
-		offset = (ptr - page_address(page)) % s->size;
+		offset = (ptr - slab_address(slab)) % s->size;
 
 	/* Adjust for redzone and reject if within the redzone. */
 	if (!is_kfence && kmem_cache_debug_flags(s, SLAB_RED_ZONE)) {
diff --git a/mm/usercopy.c b/mm/usercopy.c
index b3de3c4eefba..d0d268135d96 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -20,6 +20,7 @@
 #include <linux/atomic.h>
 #include <linux/jump_label.h>
 #include <asm/sections.h>
+#include "slab.h"
 
 /*
  * Checks if a given pointer and length is contained by the current
@@ -223,7 +224,7 @@ static inline void check_page_span(const void *ptr, unsigned long n,
 static inline void check_heap_object(const void *ptr, unsigned long n,
 				     bool to_user)
 {
-	struct page *page;
+	struct folio *folio;
 
 	if (!virt_addr_valid(ptr))
 		return;
@@ -231,16 +232,16 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 	/*
 	 * When CONFIG_HIGHMEM=y, kmap_to_page() will give either the
 	 * highmem page or fallback to virt_to_page(). The following
-	 * is effectively a highmem-aware virt_to_head_page().
+	 * is effectively a highmem-aware virt_to_slab().
 	 */
-	page = compound_head(kmap_to_page((void *)ptr));
+	folio = page_folio(kmap_to_page((void *)ptr));
 
-	if (PageSlab(page)) {
+	if (folio_test_slab(folio)) {
 		/* Check slab allocator for flags and size. */
-		__check_heap_object(ptr, n, page, to_user);
+		__check_heap_object(ptr, n, folio_slab(folio), to_user);
 	} else {
 		/* Verify object does not incorrectly span multiple pages. */
-		check_page_span(ptr, n, page, to_user);
+		check_page_span(ptr, n, folio_page(folio, 0), to_user);
 	}
 }
 
-- 
2.34.1

