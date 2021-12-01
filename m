Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8945E2CB2
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0A010218E0;
	Wed,  1 Dec 2021 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382520; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pRNn3FUWmIkB+AIBt8k4Hc3p8VqTdjyb4KkYPCXkybg=;
	b=ELzro/zIxjVcRcN04EgCAo22xNe9OBJSJDb3yhxSZGuQ9259suTkCJSXQVIbMMJsY8Ow+W
	Mr5zTKf5qsTwbjwbDYGphhlaSIxjrs8g1Vn+DKuhueggUyaL9PfXfbE/PrIMOpo2wAc4dD
	s1vO6dRNQ0U4iqKykj8uElhVMmrYY20=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382520;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pRNn3FUWmIkB+AIBt8k4Hc3p8VqTdjyb4KkYPCXkybg=;
	b=kmr6F2+S1arvtzhRZO9wnXSmRb0Fqlw/CTQvGuUnDXUW/CBZ3QhyJk6fs+tQ0K2s+5NtDN
	YDF27BS9XOA/cbBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D33C213D9D;
	Wed,  1 Dec 2021 18:15:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id yAUOM7e7p2HPSAAAMHmgww
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
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com
Subject: [PATCH v2 26/33] mm/kfence: Convert kfence_guarded_alloc() to struct slab
Date: Wed,  1 Dec 2021 19:15:03 +0100
Message-Id: <20211201181510.18784-27-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2616; h=from:subject; bh=+CNHtzGum/tOmd/kW8GAUx888uquumIQ2d0wfPG8TF4=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7ubr9qa0wQH93+qc0CSNF9NLizxF8+su0OTZzLH lGacLvSJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7mwAKCRDgIcpz8YmpEJDXCA CpJyrm/iqqE/v6T1tHy7bIGV5jHGrybBMM/EmUqQSj86aWhtP8Oi8CPAIFBtOu+CTFldmPk4Nh/0nq uw93aFHn4LHexWfSTIp53E0vyNSuHBYqtokdvrdbJN848c4mu37p5Ip8eLzmFavLDfrBdCoQYkGvpL IEcYpRa+yB8sVCIywEoZSrPi6OQwzslxQspXoZb7yM7Pm6AHdV/uPNfOui/2aRHVfFh0nYWuvz6ER2 WK77d7PonT7Mpg5p4Hwd82vtUvdGkz/R4PMOTbU3gIYV5zFvZ+2VOTvua7gTWrKL/iQG+0yxHKrhZf QchjOVxsNvaOcxzNOGhcIz4RzdVBRz
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

The function sets some fields that are being moved from struct page to struct
slab so it needs to be converted.

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
2.33.1

