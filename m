Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD8F2CAD
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:11:00 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A68601F3A9;
	Tue,  4 Jan 2022 00:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pla5a4Iej320DNkQ6tKcTj24OL1BJI45eWKKd+Flk+o=;
	b=ExNkLO3HAXEW//5F/XmEhqE0amqoC1dTPIql7bKHwKcikbHpSF2lc4rBR3wIzo3lZ43uu8
	R1/F/ZUZEy2hMDc3Q6n6UiQWtCQ220665bRUK0pVRpQzXp9CO7EJvcWbMZHByvnm701AHE
	h3mlgjTB4ftv/b8u3AQmuMUen2eTQCI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255057;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pla5a4Iej320DNkQ6tKcTj24OL1BJI45eWKKd+Flk+o=;
	b=DK9oEdzu41L4BxJXDVVXNvkhcrzFLZQA/mN6pB16yQkXHCKBTEStyMQKOI/RUmiEvWNM6W
	H9JP4o9Qo6GHjIAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7D331139D1;
	Tue,  4 Jan 2022 00:10:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 8Av/HZGQ02FEQwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 04 Jan 2022 00:10:57 +0000
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
Subject: [PATCH v4 24/32] mm/slob: Convert SLOB to use struct slab and struct folio
Date: Tue,  4 Jan 2022 01:10:38 +0100
Message-Id: <20220104001046.12263-25-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5447; i=vbabka@suse.cz; h=from:subject; bh=efSoNIwxYQDjSsYjJEkKb7QGTXcFEua/icOX3C2fZMw=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05B+1beTynrOl+KeyXDuMqC50a6oAESQcqyOCPVh 9D14hUGJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQfgAKCRDgIcpz8YmpEOhkCA CpqCialpZL7ME23W9Tqw/HGQCiIDZlJMryz9VIYCH4ypMpb/t3cpiv2lQwUOa3XX4aliTKfdz+vXt9 +2NOumbedKLqNBBzI5gunwwsKzhomOJAOR1rxNcqnO1Bg82eyxKSesuqHTE+XNo3JlYx0yS/fSMAc9 Komm/hrTHE6jVZlVQYuhRqN820eFoajPNE/VuwSB/BQqMQYtJXeKyyJtxbQFStpsrTjSX8uwMbUrfL Z6w76FcnbC+gFpNFVyEpEuhd+B4vP4L3BdAa2nJw+gtg9ttLne7KjXQZBGQGYptXCPd0NwYv1p9ErV MdRd7FRneIcJaUTX4dNjXVYeuWjsJs
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Use struct slab throughout the slob allocator. Where non-slab page can
appear use struct folio instead of struct page.

[ vbabka@suse.cz: don't introduce wrappers for PageSlobFree in mm/slab.h
  just for the single callers being wrappers in mm/slob.c ]

[ Hyeonggon Yoo <42.hyeyoo@gmail.com>: fix NULL pointer deference ]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 mm/slob.c | 51 +++++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index d2d15e7f191c..3c6cadbbc238 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -30,7 +30,7 @@
  * If kmalloc is asked for objects of PAGE_SIZE or larger, it calls
  * alloc_pages() directly, allocating compound pages so the page order
  * does not have to be separately tracked.
- * These objects are detected in kfree() because PageSlab()
+ * These objects are detected in kfree() because folio_test_slab()
  * is false for them.
  *
  * SLAB is emulated on top of SLOB by simply calling constructors and
@@ -105,21 +105,21 @@ static LIST_HEAD(free_slob_large);
 /*
  * slob_page_free: true for pages on free_slob_pages list.
  */
-static inline int slob_page_free(struct page *sp)
+static inline int slob_page_free(struct slab *slab)
 {
-	return PageSlobFree(sp);
+	return PageSlobFree(slab_page(slab));
 }
 
-static void set_slob_page_free(struct page *sp, struct list_head *list)
+static void set_slob_page_free(struct slab *slab, struct list_head *list)
 {
-	list_add(&sp->slab_list, list);
-	__SetPageSlobFree(sp);
+	list_add(&slab->slab_list, list);
+	__SetPageSlobFree(slab_page(slab));
 }
 
-static inline void clear_slob_page_free(struct page *sp)
+static inline void clear_slob_page_free(struct slab *slab)
 {
-	list_del(&sp->slab_list);
-	__ClearPageSlobFree(sp);
+	list_del(&slab->slab_list);
+	__ClearPageSlobFree(slab_page(slab));
 }
 
 #define SLOB_UNIT sizeof(slob_t)
@@ -234,7 +234,7 @@ static void slob_free_pages(void *b, int order)
  *         freelist, in this case @page_removed_from_list will be set to
  *         true (set to false otherwise).
  */
-static void *slob_page_alloc(struct page *sp, size_t size, int align,
+static void *slob_page_alloc(struct slab *sp, size_t size, int align,
 			      int align_offset, bool *page_removed_from_list)
 {
 	slob_t *prev, *cur, *aligned = NULL;
@@ -301,7 +301,8 @@ static void *slob_page_alloc(struct page *sp, size_t size, int align,
 static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
 							int align_offset)
 {
-	struct page *sp;
+	struct folio *folio;
+	struct slab *sp;
 	struct list_head *slob_list;
 	slob_t *b = NULL;
 	unsigned long flags;
@@ -323,7 +324,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
 		 * If there's a node specification, search for a partial
 		 * page with a matching node id in the freelist.
 		 */
-		if (node != NUMA_NO_NODE && page_to_nid(sp) != node)
+		if (node != NUMA_NO_NODE && slab_nid(sp) != node)
 			continue;
 #endif
 		/* Enough room on this page? */
@@ -358,8 +359,9 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
 		b = slob_new_pages(gfp & ~__GFP_ZERO, 0, node);
 		if (!b)
 			return NULL;
-		sp = virt_to_page(b);
-		__SetPageSlab(sp);
+		folio = virt_to_folio(b);
+		__folio_set_slab(folio);
+		sp = folio_slab(folio);
 
 		spin_lock_irqsave(&slob_lock, flags);
 		sp->units = SLOB_UNITS(PAGE_SIZE);
@@ -381,7 +383,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node,
  */
 static void slob_free(void *block, int size)
 {
-	struct page *sp;
+	struct slab *sp;
 	slob_t *prev, *next, *b = (slob_t *)block;
 	slobidx_t units;
 	unsigned long flags;
@@ -391,7 +393,7 @@ static void slob_free(void *block, int size)
 		return;
 	BUG_ON(!size);
 
-	sp = virt_to_page(block);
+	sp = virt_to_slab(block);
 	units = SLOB_UNITS(size);
 
 	spin_lock_irqsave(&slob_lock, flags);
@@ -401,8 +403,8 @@ static void slob_free(void *block, int size)
 		if (slob_page_free(sp))
 			clear_slob_page_free(sp);
 		spin_unlock_irqrestore(&slob_lock, flags);
-		__ClearPageSlab(sp);
-		page_mapcount_reset(sp);
+		__folio_clear_slab(slab_folio(sp));
+		page_mapcount_reset(slab_page(sp));
 		slob_free_pages(b, 0);
 		return;
 	}
@@ -544,7 +546,7 @@ EXPORT_SYMBOL(__kmalloc_node_track_caller);
 
 void kfree(const void *block)
 {
-	struct page *sp;
+	struct folio *sp;
 
 	trace_kfree(_RET_IP_, block);
 
@@ -552,16 +554,17 @@ void kfree(const void *block)
 		return;
 	kmemleak_free(block);
 
-	sp = virt_to_page(block);
-	if (PageSlab(sp)) {
+	sp = virt_to_folio(block);
+	if (folio_test_slab(sp)) {
 		int align = max_t(size_t, ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 		unsigned int *m = (unsigned int *)(block - align);
 		slob_free(m, *m + align);
 	} else {
-		unsigned int order = compound_order(sp);
-		mod_node_page_state(page_pgdat(sp), NR_SLAB_UNRECLAIMABLE_B,
+		unsigned int order = folio_order(sp);
+
+		mod_node_page_state(folio_pgdat(sp), NR_SLAB_UNRECLAIMABLE_B,
 				    -(PAGE_SIZE << order));
-		__free_pages(sp, order);
+		__free_pages(folio_page(sp, 0), order);
 
 	}
 }
-- 
2.34.1

