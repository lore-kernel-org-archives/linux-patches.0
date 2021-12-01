Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4E72CAA
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A301A21891;
	Wed,  1 Dec 2021 18:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BZ9yxaTfKeg4EKSbSnXTLYZa6V+LUFTOK0Lrhh/tepk=;
	b=VWE3eBFdHdF2Hid+nEnSLh58/CbHOOafJNeyFT5YL2mA6516eqtx55AqcznQbxJB8PwF6O
	o75QDbzaNGb15MypTAfksSZopmcTjJ6IF/udESWssKurmq9zxLDgpTV1kisZH/AwKZZ7d4
	tJg75UEeBn3E4RaRGT7NddET426RtVs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BZ9yxaTfKeg4EKSbSnXTLYZa6V+LUFTOK0Lrhh/tepk=;
	b=63SlIrUIEW7aOmWEuTVIiDT0x60zT5+MJgxb9trVJ83yDigqchOQX8mXoEGq4gwH/XD9Fy
	IdiMafr4I+Bn5jCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6BD4113D9D;
	Wed,  1 Dec 2021 18:15:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 0J+eGbS7p2HPSAAAMHmgww
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
Subject: [PATCH v2 08/33] mm: Use struct slab in kmem_obj_info()
Date: Wed,  1 Dec 2021 19:14:45 +0100
Message-Id: <20211201181510.18784-9-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5088; i=vbabka@suse.cz; h=from:subject; bh=rqxRHBo8Lf2ztOUBJMH62wCHp4QXoSoJ8QLKLQTT3h0=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7tv0JomP3mNV8VcopenY//mchamshwEM3ZFyFGK etwsebCJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7bwAKCRDgIcpz8YmpEMAUB/ 4vStMd0fbKlfj2a5aBKnW9dtQh9FPPr20d1fjPjC3c+zOHhChAvvvxMgc8xQ6GU3tg5qahPQA5ZN64 MuASZEeya7SvSXd4lKvFqOlakdNGG09IqY/Z6C62UhftBy+piBZNm+ybtvrpp3+1WiIbOhYWZyovll M4O/dVae2cHbBVjGelxRDEUjKrSXLFAxcF0ueJ3Ns6A3gtVfpCjBJhn7Eklix/ejaUBDd1PjCkf8jQ Gw3xrcYSRTrxqLZfejS/m5ENdK07N7+PwjdhYHPUPX3dCw0OMYDINmomGJLLmEiahoxBJxQuMiFjyk ZMKbt7WfOXTNreqh8WJdzx12UPdHx4
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

All three implementations of slab support kmem_obj_info() which reports
details of an object allocated from the slab allocator.  By using the
slab type instead of the page type, we make it obvious that this can
only be called for slabs.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.c        | 12 ++++++------
 mm/slab.h        |  4 ++--
 mm/slab_common.c |  8 ++++----
 mm/slob.c        |  4 ++--
 mm/slub.c        | 12 ++++++------
 5 files changed, 20 insertions(+), 20 deletions(-)

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
index e5d080a93009..bddefca7d584 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
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
index 6ae7c63cedc0..bc8a1fa146a5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4322,31 +4322,31 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
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
+	if (WARN_ON_ONCE(objp < base || objp >= base + slab->objects * s->size || (objp - base) % s->size) ||
 	    !(s->flags & SLAB_STORE_USER))
 		return;
 #ifdef CONFIG_SLUB_DEBUG
-- 
2.33.1

