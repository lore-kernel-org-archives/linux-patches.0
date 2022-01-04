Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056782CA7
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:11:00 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 230EF1F398;
	Tue,  4 Jan 2022 00:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r/9GRM1wKTGUJP0nx+VBbfm6M5Dh8MHDWKxDDmjiXMQ=;
	b=ykEUHH7DaENHUy6ExuUcTubovEmNKmZOnSZwgfKXmmsptUUv0yhBQ2ldWjI/UYfCHEjH7R
	fwDsVKbXLASK0MveUz8TvDJbTX+xftpEHoP8J4aic4ZSReErx+zd6KVc8UfL7u0hr1L/ph
	l/SPQtY7MbnjuSqjGrlfCrdLAXamu30=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255058;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r/9GRM1wKTGUJP0nx+VBbfm6M5Dh8MHDWKxDDmjiXMQ=;
	b=SrSBjdlQ1zdaasKfZG/rwldBhtu3OGEijkB84pImB84fKYeOiL4QZAOXo5+54/urHKhkE2
	bZowonnqw2DdEOBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E3CBF139D1;
	Tue,  4 Jan 2022 00:10:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id oBYXN5GQ02FEQwAAMHmgww
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
	Vlastimil Babka <vbabka@suse.cz>,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com
Subject: [PATCH v4 26/32] mm/kfence: Convert kfence_guarded_alloc() to struct slab
Date: Tue,  4 Jan 2022 01:10:40 +0100
Message-Id: <20220104001046.12263-27-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2616; h=from:subject; bh=ebf99JA0JUFS8hR5i+Q9WIOfxROG6KOiIr2oSEnpdfU=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05CAxKL+8XpPG+tHXG/rEDsSOazvUDmcH4h06cbA LlP5mQiJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQgAAKCRDgIcpz8YmpEH/hCA CU3QxDuJ2g1z5AZ8lVEst2UoUjtcd/fiDDNkjeyQSmkB74sNw+ZLSlLyzTM5qr0yeXV5PGOFHg/WjY rsZso9vUG3xnqeGqrQG9bKWmXcFFcK0OWV3d7RzkgxvJTmHM/cg2xmt8lBgibkdKlXbXirDXvnWHmm 52XEaqrENbNra2dBuT0Xzm7odYeA57SihSx9oKO1ti0Qdcp3b2FswJizgCdEJd1ig9E2QD0hM1Ugj6 v/2pWa9ANC6gywhOicfwhKpEdAdbLLKrTYo2Jl+4Tz8RgLujq2bu9xyNrzpdye7TBo8qOtB5UWCQt9 P+dr2FO9ODl4GfrIYxiyNMB2iWXkKl
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

The function sets some fields that are being moved from struct page to
struct slab so it needs to be converted.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <kasan-dev@googlegroups.com>
---
 mm/kfence/core.c        | 12 ++++++------
 mm/kfence/kfence_test.c |  6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 09945784df9e..4eb60cf5ff8b 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -360,7 +360,7 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 {
 	struct kfence_metadata *meta = NULL;
 	unsigned long flags;
-	struct page *page;
+	struct slab *slab;
 	void *addr;
 
 	/* Try to obtain a free object. */
@@ -424,13 +424,13 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 
 	alloc_covered_add(alloc_stack_hash, 1);
 
-	/* Set required struct page fields. */
-	page = virt_to_page(meta->addr);
-	page->slab_cache = cache;
+	/* Set required slab fields. */
+	slab = virt_to_slab((void *)meta->addr);
+	slab->slab_cache = cache;
 	if (IS_ENABLED(CONFIG_SLUB))
-		page->objects = 1;
+		slab->objects = 1;
 	if (IS_ENABLED(CONFIG_SLAB))
-		page->s_mem = addr;
+		slab->s_mem = addr;
 
 	/* Memory initialization. */
 	for_each_canary(meta, set_canary_byte);
diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index f7276711d7b9..a22b1af85577 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -282,7 +282,7 @@ static void *test_alloc(struct kunit *test, size_t size, gfp_t gfp, enum allocat
 			alloc = kmalloc(size, gfp);
 
 		if (is_kfence_address(alloc)) {
-			struct page *page = virt_to_head_page(alloc);
+			struct slab *slab = virt_to_slab(alloc);
 			struct kmem_cache *s = test_cache ?:
 					kmalloc_caches[kmalloc_type(GFP_KERNEL)][__kmalloc_index(size, false)];
 
@@ -291,8 +291,8 @@ static void *test_alloc(struct kunit *test, size_t size, gfp_t gfp, enum allocat
 			 * even for KFENCE objects; these are required so that
 			 * memcg accounting works correctly.
 			 */
-			KUNIT_EXPECT_EQ(test, obj_to_index(s, page_slab(page), alloc), 0U);
-			KUNIT_EXPECT_EQ(test, objs_per_slab(s, page_slab(page)), 1);
+			KUNIT_EXPECT_EQ(test, obj_to_index(s, slab, alloc), 0U);
+			KUNIT_EXPECT_EQ(test, objs_per_slab(s, slab), 1);
 
 			if (policy == ALLOCATE_ANY)
 				return alloc;
-- 
2.34.1

