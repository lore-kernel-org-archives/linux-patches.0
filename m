Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0480E2CA4
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:58 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4A6101F3A2;
	Tue,  4 Jan 2022 00:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ynMu9gUcfn+cFnntE/ZYyjBN3wddh509NNHt3XwZiU=;
	b=h8ZplfmX3aDLAXpTvihmcdWJE/nsqoKfgW1G8uh6/DOQX0RvxWhRy1jCM2xd3lQRTfGyuc
	ojc4beTpKB4KWQkVOQgVz5Gec/r2KP67KufxklKqwfT+bJU/uiVHmflxB+lhhgvJjhGMYi
	v+vmZ6UUkrlFwh/5Y97elyB80UfuqN0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ynMu9gUcfn+cFnntE/ZYyjBN3wddh509NNHt3XwZiU=;
	b=rzU2pFfEnRtQa1eYBaAD0QwsQCbn4hcC7cMTdWX5wg1sVKraFqDnz009hS/JsmdCqtm365
	5LDaUAv7CmNsblBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 21231139D1;
	Tue,  4 Jan 2022 00:10:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 8JtxB46Q02FEQwAAMHmgww
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
Subject: [PATCH v4 08/32] mm: Use struct slab in kmem_obj_info()
Date: Tue,  4 Jan 2022 01:10:22 +0100
Message-Id: <20220104001046.12263-9-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5689; i=vbabka@suse.cz; h=from:subject; bh=e+5OAymN3yXP3FQ+RIB0Qh2Z6HFn5ysk930ArWaUv5E=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05BwzFMhNvllRncvLKjg/33YChu5TiX4HqhKU/X6 VvGz5wOJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQcAAKCRDgIcpz8YmpEMNJB/ 9JxSN7GRruaBAn9ppDnq16CUvB2c05JNpYJlfTlUS+19vEzO6aUxaQ0BkmRlDetwAL+0uRJO7HabPu LKxTjHm+6H6VLdg5qyDnbKL84o9A02/a3fB9BooiD3NOgGtkIHTVE5KFqGshLxqfojB8aay5/zbUJR 9uvOuAgTPnwr2nGF1jPC8kju4sQ1rG6Sta8gNfy1SCPgRs9Zpkol7WUe1ChixR5c7sawhyFC0VOlNg RfPjnCFV1K7KA42MP31Y7wbWU3wPEjKq5EMDae1r/pgdGzy6nt4dEt/ihim0KLvIi4Wo/YU8YpDA4M KHrtBXfwWC1CRuwp0amPgyrWuBtZox
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

All three implementations of slab support kmem_obj_info() which reports
details of an object allocated from the slab allocator.  By using the
slab type instead of the page type, we make it obvious that this can
only be called for slabs.

[ vbabka@suse.cz: also convert the related kmem_valid_obj() to folios ]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <guro@fb.com>
---
 mm/slab.c        | 12 ++++++------
 mm/slab.h        |  4 ++--
 mm/slab_common.c | 14 +++++++-------
 mm/slob.c        |  4 ++--
 mm/slub.c        | 13 +++++++------
 5 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 7f147805d0ab..44bc1fcd1393 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3646,21 +3646,21 @@ EXPORT_SYMBOL(__kmalloc_node_track_caller);
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_PRINTK
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 {
 	struct kmem_cache *cachep;
 	unsigned int objnr;
 	void *objp;
 
 	kpp->kp_ptr = object;
-	kpp->kp_page = page;
-	cachep = page->slab_cache;
+	kpp->kp_slab = slab;
+	cachep = slab->slab_cache;
 	kpp->kp_slab_cache = cachep;
 	objp = object - obj_offset(cachep);
 	kpp->kp_data_offset = obj_offset(cachep);
-	page = virt_to_head_page(objp);
-	objnr = obj_to_index(cachep, page, objp);
-	objp = index_to_obj(cachep, page, objnr);
+	slab = virt_to_slab(objp);
+	objnr = obj_to_index(cachep, slab_page(slab), objp);
+	objp = index_to_obj(cachep, slab_page(slab), objnr);
 	kpp->kp_objp = objp;
 	if (DEBUG && cachep->flags & SLAB_STORE_USER)
 		kpp->kp_ret = *dbg_userword(cachep, objp);
diff --git a/mm/slab.h b/mm/slab.h
index 1408ada9ff72..9ae9f6c3d1cb 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -801,7 +801,7 @@ static inline void debugfs_slab_release(struct kmem_cache *s) { }
 #define KS_ADDRS_COUNT 16
 struct kmem_obj_info {
 	void *kp_ptr;
-	struct page *kp_page;
+	struct slab *kp_slab;
 	void *kp_objp;
 	unsigned long kp_data_offset;
 	struct kmem_cache *kp_slab_cache;
@@ -809,7 +809,7 @@ struct kmem_obj_info {
 	void *kp_stack[KS_ADDRS_COUNT];
 	void *kp_free_stack[KS_ADDRS_COUNT];
 };
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page);
+void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab);
 #endif
 
 #endif /* MM_SLAB_H */
diff --git a/mm/slab_common.c b/mm/slab_common.c
index e5d080a93009..dc15566141d4 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -550,13 +550,13 @@ bool slab_is_available(void)
  */
 bool kmem_valid_obj(void *object)
 {
-	struct page *page;
+	struct folio *folio;
 
 	/* Some arches consider ZERO_SIZE_PTR to be a valid address. */
 	if (object < (void *)PAGE_SIZE || !virt_addr_valid(object))
 		return false;
-	page = virt_to_head_page(object);
-	return PageSlab(page);
+	folio = virt_to_folio(object);
+	return folio_test_slab(folio);
 }
 EXPORT_SYMBOL_GPL(kmem_valid_obj);
 
@@ -579,18 +579,18 @@ void kmem_dump_obj(void *object)
 {
 	char *cp = IS_ENABLED(CONFIG_MMU) ? "" : "/vmalloc";
 	int i;
-	struct page *page;
+	struct slab *slab;
 	unsigned long ptroffset;
 	struct kmem_obj_info kp = { };
 
 	if (WARN_ON_ONCE(!virt_addr_valid(object)))
 		return;
-	page = virt_to_head_page(object);
-	if (WARN_ON_ONCE(!PageSlab(page))) {
+	slab = virt_to_slab(object);
+	if (WARN_ON_ONCE(!slab)) {
 		pr_cont(" non-slab memory.\n");
 		return;
 	}
-	kmem_obj_info(&kp, object, page);
+	kmem_obj_info(&kp, object, slab);
 	if (kp.kp_slab_cache)
 		pr_cont(" slab%s %s", cp, kp.kp_slab_cache->name);
 	else
diff --git a/mm/slob.c b/mm/slob.c
index c8a4290012a6..d2d15e7f191c 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -462,10 +462,10 @@ static void slob_free(void *block, int size)
 }
 
 #ifdef CONFIG_PRINTK
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 {
 	kpp->kp_ptr = object;
-	kpp->kp_page = page;
+	kpp->kp_slab = slab;
 }
 #endif
 
diff --git a/mm/slub.c b/mm/slub.c
index 269e10d341a8..8e9667815f81 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4322,31 +4322,32 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 }
 
 #ifdef CONFIG_PRINTK
-void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct page *page)
+void kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
 {
 	void *base;
 	int __maybe_unused i;
 	unsigned int objnr;
 	void *objp;
 	void *objp0;
-	struct kmem_cache *s = page->slab_cache;
+	struct kmem_cache *s = slab->slab_cache;
 	struct track __maybe_unused *trackp;
 
 	kpp->kp_ptr = object;
-	kpp->kp_page = page;
+	kpp->kp_slab = slab;
 	kpp->kp_slab_cache = s;
-	base = page_address(page);
+	base = slab_address(slab);
 	objp0 = kasan_reset_tag(object);
 #ifdef CONFIG_SLUB_DEBUG
 	objp = restore_red_left(s, objp0);
 #else
 	objp = objp0;
 #endif
-	objnr = obj_to_index(s, page, objp);
+	objnr = obj_to_index(s, slab_page(slab), objp);
 	kpp->kp_data_offset = (unsigned long)((char *)objp0 - (char *)objp);
 	objp = base + s->size * objnr;
 	kpp->kp_objp = objp;
-	if (WARN_ON_ONCE(objp < base || objp >= base + page->objects * s->size || (objp - base) % s->size) ||
+	if (WARN_ON_ONCE(objp < base || objp >= base + slab->objects * s->size
+			 || (objp - base) % s->size) ||
 	    !(s->flags & SLAB_STORE_USER))
 		return;
 #ifdef CONFIG_SLUB_DEBUG
-- 
2.34.1

