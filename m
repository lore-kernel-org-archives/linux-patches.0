Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867DB2CB1
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D05C0218DF;
	Wed,  1 Dec 2021 18:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p8tv2+xq9sBsttSOv4xOUAPywnT1KNNx/eDzXd9OiSg=;
	b=DQAFhYvruW2e8HkFx+rcGzjlb3OHlyWjcvO/JX3ym16PP5bEXOLe8wKg61hldeLE2SK7SJ
	wLrQOaZyjS/kAx/1ugZXgEGKtcwuNHpjutJi2iILFuOBWRiKR3AqgAF8L7FbK++Ai3U4Bz
	J1sBe5UHwsiCVwFeTEc5DUx6JyJZYl8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382519;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p8tv2+xq9sBsttSOv4xOUAPywnT1KNNx/eDzXd9OiSg=;
	b=M2nU5i8mo5pSFBdpdVrFQaujntGoO4ts0mohQQPKmujXworIK79U1aooucQoyVIwTZ0v8t
	La3Y+yzDhFFt2rAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A467B14050;
	Wed,  1 Dec 2021 18:15:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id SKCaJ7e7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:19 +0000
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
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com
Subject: [PATCH v2 25/33] mm/kasan: Convert to struct folio and struct slab
Date: Wed,  1 Dec 2021 19:15:02 +0100
Message-Id: <20211201181510.18784-26-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9591; i=vbabka@suse.cz; h=from:subject; bh=wdLlaDab2DMicugm8HZ3tbv9bFA1JUWGOF5KHqZutpA=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7uZnahBhsq3DyszeNzgSBLe4X6TtyGjdQLSRoBm 752quM+JATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7mQAKCRDgIcpz8YmpEKAGB/ 9R6s987FhRQpwo6Cbom6KV3SQaHUre1R7fzA0tLie6bWZNHjQ0gdLlamw0fOvSZoMI51dOl2xJLVrH 9bnGWRDjjpc7cSSaYnfWdkZZPTMzI+hCGDtk8MikGfOPfXUmqNNtHKzn2nFJK81HuwIURsOHbPOS18 Qe4zwHNpu/+zMKxN61OREUXQsqUgmYv940e6sNR2hUqE7RJ8p+cLnSDBZpp4gemuRUM3hTr10BmzV4 8kKZjH8GL1Lx1T+sfLxe4anm4BRt6+7QMVMGPPmMrGbOlFyagiIc2Knk6T9tJdIPdxriSRvvZUpimB Z0lgl260tmirQWxrepr0AKJc8MfD+7
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

KASAN accesses some slab related struct page fields so we need to convert it
to struct slab. Some places are a bit simplified thanks to kasan_addr_to_slab()
encapsulating the PageSlab flag check through virt_to_slab().
When resolving object address to either a real slab or a large kmalloc, use
struct folio as the intermediate type for testing the slab flag to avoid
unnecessary implicit compound_head().

[ vbabka@suse.cz: use struct folio, adjust to differences in previous patches ]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <kasan-dev@googlegroups.com>
---
 include/linux/kasan.h  |  9 +++++----
 mm/kasan/common.c      | 23 +++++++++++++----------
 mm/kasan/generic.c     |  8 ++++----
 mm/kasan/kasan.h       |  1 +
 mm/kasan/quarantine.c  |  2 +-
 mm/kasan/report.c      | 13 +++++++++++--
 mm/kasan/report_tags.c | 10 +++++-----
 mm/slab.c              |  2 +-
 mm/slub.c              |  2 +-
 9 files changed, 42 insertions(+), 28 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index d8783b682669..fb78108d694e 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -9,6 +9,7 @@
 
 struct kmem_cache;
 struct page;
+struct slab;
 struct vm_struct;
 struct task_struct;
 
@@ -193,11 +194,11 @@ static __always_inline size_t kasan_metadata_size(struct kmem_cache *cache)
 	return 0;
 }
 
-void __kasan_poison_slab(struct page *page);
-static __always_inline void kasan_poison_slab(struct page *page)
+void __kasan_poison_slab(struct slab *slab);
+static __always_inline void kasan_poison_slab(struct slab *slab)
 {
 	if (kasan_enabled())
-		__kasan_poison_slab(page);
+		__kasan_poison_slab(slab);
 }
 
 void __kasan_unpoison_object_data(struct kmem_cache *cache, void *object);
@@ -322,7 +323,7 @@ static inline void kasan_cache_create(struct kmem_cache *cache,
 				      slab_flags_t *flags) {}
 static inline void kasan_cache_create_kmalloc(struct kmem_cache *cache) {}
 static inline size_t kasan_metadata_size(struct kmem_cache *cache) { return 0; }
-static inline void kasan_poison_slab(struct page *page) {}
+static inline void kasan_poison_slab(struct slab *slab) {}
 static inline void kasan_unpoison_object_data(struct kmem_cache *cache,
 					void *object) {}
 static inline void kasan_poison_object_data(struct kmem_cache *cache,
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 6a1cd2d38bff..7c06db78a76c 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -247,8 +247,9 @@ struct kasan_free_meta *kasan_get_free_meta(struct kmem_cache *cache,
 }
 #endif
 
-void __kasan_poison_slab(struct page *page)
+void __kasan_poison_slab(struct slab *slab)
 {
+	struct page *page = slab_page(slab);
 	unsigned long i;
 
 	for (i = 0; i < compound_nr(page); i++)
@@ -401,9 +402,9 @@ void __kasan_kfree_large(void *ptr, unsigned long ip)
 
 void __kasan_slab_free_mempool(void *ptr, unsigned long ip)
 {
-	struct page *page;
+	struct folio *folio;
 
-	page = virt_to_head_page(ptr);
+	folio = virt_to_folio(ptr);
 
 	/*
 	 * Even though this function is only called for kmem_cache_alloc and
@@ -411,12 +412,14 @@ void __kasan_slab_free_mempool(void *ptr, unsigned long ip)
 	 * !PageSlab() when the size provided to kmalloc is larger than
 	 * KMALLOC_MAX_SIZE, and kmalloc falls back onto page_alloc.
 	 */
-	if (unlikely(!PageSlab(page))) {
+	if (unlikely(!folio_test_slab(folio))) {
 		if (____kasan_kfree_large(ptr, ip))
 			return;
-		kasan_poison(ptr, page_size(page), KASAN_FREE_PAGE, false);
+		kasan_poison(ptr, folio_size(folio), KASAN_FREE_PAGE, false);
 	} else {
-		____kasan_slab_free(page->slab_cache, ptr, ip, false, false);
+		struct slab *slab = folio_slab(folio);
+
+		____kasan_slab_free(slab->slab_cache, ptr, ip, false, false);
 	}
 }
 
@@ -560,7 +563,7 @@ void * __must_check __kasan_kmalloc_large(const void *ptr, size_t size,
 
 void * __must_check __kasan_krealloc(const void *object, size_t size, gfp_t flags)
 {
-	struct page *page;
+	struct slab *slab;
 
 	if (unlikely(object == ZERO_SIZE_PTR))
 		return (void *)object;
@@ -572,13 +575,13 @@ void * __must_check __kasan_krealloc(const void *object, size_t size, gfp_t flag
 	 */
 	kasan_unpoison(object, size, false);
 
-	page = virt_to_head_page(object);
+	slab = virt_to_slab(object);
 
 	/* Piggy-back on kmalloc() instrumentation to poison the redzone. */
-	if (unlikely(!PageSlab(page)))
+	if (unlikely(!slab))
 		return __kasan_kmalloc_large(object, size, flags);
 	else
-		return ____kasan_kmalloc(page->slab_cache, object, size, flags);
+		return ____kasan_kmalloc(slab->slab_cache, object, size, flags);
 }
 
 bool __kasan_check_byte(const void *address, unsigned long ip)
diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
index 5d0b79416c4e..a25ad4090615 100644
--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -330,16 +330,16 @@ DEFINE_ASAN_SET_SHADOW(f8);
 
 static void __kasan_record_aux_stack(void *addr, bool can_alloc)
 {
-	struct page *page = kasan_addr_to_page(addr);
+	struct slab *slab = kasan_addr_to_slab(addr);
 	struct kmem_cache *cache;
 	struct kasan_alloc_meta *alloc_meta;
 	void *object;
 
-	if (is_kfence_address(addr) || !(page && PageSlab(page)))
+	if (is_kfence_address(addr) || !slab)
 		return;
 
-	cache = page->slab_cache;
-	object = nearest_obj(cache, page_slab(page), addr);
+	cache = slab->slab_cache;
+	object = nearest_obj(cache, slab, addr);
 	alloc_meta = kasan_get_alloc_meta(cache, object);
 	if (!alloc_meta)
 		return;
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index aebd8df86a1f..c17fa8d26ffe 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -265,6 +265,7 @@ bool kasan_report(unsigned long addr, size_t size,
 void kasan_report_invalid_free(void *object, unsigned long ip);
 
 struct page *kasan_addr_to_page(const void *addr);
+struct slab *kasan_addr_to_slab(const void *addr);
 
 depot_stack_handle_t kasan_save_stack(gfp_t flags, bool can_alloc);
 void kasan_set_track(struct kasan_track *track, gfp_t flags);
diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
index d8ccff4c1275..587da8995f2d 100644
--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -117,7 +117,7 @@ static unsigned long quarantine_batch_size;
 
 static struct kmem_cache *qlink_to_cache(struct qlist_node *qlink)
 {
-	return virt_to_head_page(qlink)->slab_cache;
+	return virt_to_slab(qlink)->slab_cache;
 }
 
 static void *qlink_to_object(struct qlist_node *qlink, struct kmem_cache *cache)
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index e00999dc6499..3ad9624dcc56 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -150,6 +150,14 @@ struct page *kasan_addr_to_page(const void *addr)
 	return NULL;
 }
 
+struct slab *kasan_addr_to_slab(const void *addr)
+{
+	if ((addr >= (void *)PAGE_OFFSET) &&
+			(addr < high_memory))
+		return virt_to_slab(addr);
+	return NULL;
+}
+
 static void describe_object_addr(struct kmem_cache *cache, void *object,
 				const void *addr)
 {
@@ -248,8 +256,9 @@ static void print_address_description(void *addr, u8 tag)
 	pr_err("\n");
 
 	if (page && PageSlab(page)) {
-		struct kmem_cache *cache = page->slab_cache;
-		void *object = nearest_obj(cache, page_slab(page),	addr);
+		struct slab *slab = page_slab(page);
+		struct kmem_cache *cache = slab->slab_cache;
+		void *object = nearest_obj(cache, slab,	addr);
 
 		describe_object(cache, object, addr, tag);
 	}
diff --git a/mm/kasan/report_tags.c b/mm/kasan/report_tags.c
index 06c21dd77493..1b41de88c53e 100644
--- a/mm/kasan/report_tags.c
+++ b/mm/kasan/report_tags.c
@@ -12,7 +12,7 @@ const char *kasan_get_bug_type(struct kasan_access_info *info)
 #ifdef CONFIG_KASAN_TAGS_IDENTIFY
 	struct kasan_alloc_meta *alloc_meta;
 	struct kmem_cache *cache;
-	struct page *page;
+	struct slab *slab;
 	const void *addr;
 	void *object;
 	u8 tag;
@@ -20,10 +20,10 @@ const char *kasan_get_bug_type(struct kasan_access_info *info)
 
 	tag = get_tag(info->access_addr);
 	addr = kasan_reset_tag(info->access_addr);
-	page = kasan_addr_to_page(addr);
-	if (page && PageSlab(page)) {
-		cache = page->slab_cache;
-		object = nearest_obj(cache, page_slab(page), (void *)addr);
+	slab = kasan_addr_to_slab(addr);
+	if (slab) {
+		cache = slab->slab_cache;
+		object = nearest_obj(cache, slab, (void *)addr);
 		alloc_meta = kasan_get_alloc_meta(cache, object);
 
 		if (alloc_meta) {
diff --git a/mm/slab.c b/mm/slab.c
index 785fffd527fe..fed55fa1b7d0 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2605,7 +2605,7 @@ static struct slab *cache_grow_begin(struct kmem_cache *cachep,
 	 * page_address() in the latter returns a non-tagged pointer,
 	 * as it should be for slab pages.
 	 */
-	kasan_poison_slab(slab_page(slab));
+	kasan_poison_slab(slab);
 
 	/* Get slab management. */
 	freelist = alloc_slabmgmt(cachep, slab, offset,
diff --git a/mm/slub.c b/mm/slub.c
index 61aaaa662c5e..58f0d499a293 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1961,7 +1961,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 
 	slab->slab_cache = s;
 
-	kasan_poison_slab(slab_page(slab));
+	kasan_poison_slab(slab);
 
 	start = slab_address(slab);
 
-- 
2.33.1

