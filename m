Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B25C2CA2
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BECD8218A4;
	Wed,  1 Dec 2021 18:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F+rg5CMNpqVAbBxQDbscRGGomXPEkB8UmLUiWBileU0=;
	b=fd+A5F6axsWvbV7GhRfxq5rrn2Ober/Vh9wYFArZwE2flHD9XZC2OBF4H170gtiNgZZcKv
	jn3W25Ju/wxx1opiBG6e4wRdn4OpUpLiFWv2R7y6P75RI8JcH2LQzs26XyyoKBKqlepnNa
	TlgVSjJq0cFwzzRu8XqRbqpyOJc2HWY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F+rg5CMNpqVAbBxQDbscRGGomXPEkB8UmLUiWBileU0=;
	b=h38QJmQ0uP0HZkJP7w3Cg4hsyLBCtDE6ZWO1O/mUjLzfD9DyR4Fqq/hmsUTtP1ZM2Jd0nX
	ZdYz4C4O4B3nrgCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9AFFA14050;
	Wed,  1 Dec 2021 18:15:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id yBUMJbS7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:16 +0000
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
Subject: [PATCH v2 09/33] mm: Convert check_heap_object() to use struct slab
Date: Wed,  1 Dec 2021 19:14:46 +0100
Message-Id: <20211201181510.18784-10-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6760; i=vbabka@suse.cz; h=from:subject; bh=ZzBM4O+8XzeaWUnjXBfE/ls0l3En3D9S79issp7uHa8=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7txMH9hXvpJtC+9bt7AppmzIjn88jqy0jht5bUp NzPSANSJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7cQAKCRDgIcpz8YmpEIRQB/ 4keqaWRja++qcn2WUu4NzMFdW1Wp0gYeWAkFSM3JXcP0zASu0q3Ii9CBGclsx3imM5Duvskef8fzyH 0IlL/AVA7JbVgnTZ9v0cByzrXBYu93rSG/00mr07AhiRZixd3zeWuY804GQTAmKAw5xqpTiiAL6xcw 4qgZ7CiL9XnmH1foKsOG5fh+jCotiRXqMSjCKj52KbRBR4XreXT//CxLAw7SVdYIW+dSmt3tX7BalC qWXKZg7NSjMpO1KtPvrBGiCfDT7/1QU7E3tyOMRmPV5t0WvcwBPdaAEun3JWSCrPLmIhFOsTr+AjLr 5ypANakCQFUkiawwhyvqVzFNvm6O6d
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Ensure that we're not seeing a tail page inside __check_heap_object()
by converting to a slab instead of a page.  Take the opportunity to
mark the slab as const since we're not modifying it.  Also move the
declaration of __check_heap_object() to mm/slab.h so it's not
available to the wider kernel.

[ vbabka@suse.cz: in check_heap_object() only convert to struct slab for
  actual PageSlab pages; use folio as intermediate step instead of page ]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/slab.h |  8 --------
 mm/slab.c            | 14 +++++++-------
 mm/slab.h            |  9 +++++++++
 mm/slub.c            | 10 +++++-----
 mm/usercopy.c        | 13 +++++++------
 5 files changed, 28 insertions(+), 26 deletions(-)

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
index 9ae9f6c3d1cb..7376c9d8aa2b 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -812,4 +812,13 @@ struct kmem_obj_info {
 void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab);
 #endif
 
+#ifdef CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR
+void __check_heap_object(const void *ptr, unsigned long n,
+			 const struct slab *slab, bool to_user);
+#else
+static inline
+void __check_heap_object(const void *ptr, unsigned long n,
+			 const struct slab *slab, bool to_user) { }
+#endif
+
 #endif /* MM_SLAB_H */
diff --git a/mm/slub.c b/mm/slub.c
index bc8a1fa146a5..0d31274743d9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4484,8 +4484,8 @@ EXPORT_SYMBOL(__kmalloc_node);
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
@@ -4494,10 +4494,10 @@ void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
 	ptr = kasan_reset_tag(ptr);
 
 	/* Find object and usable object size. */
-	s = page->slab_cache;
+	s = slab->slab_cache;
 
 	/* Reject impossible pointers. */
-	if (ptr < page_address(page))
+	if (ptr < slab_address(slab))
 		usercopy_abort("SLUB object not in SLUB page?!", NULL,
 			       to_user, 0, n);
 
@@ -4505,7 +4505,7 @@ void __check_heap_object(const void *ptr, unsigned long n, struct page *page,
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
2.33.1

