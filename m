Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5F42CA8
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:59 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CB57D212BC;
	Tue,  4 Jan 2022 00:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YjegpdWpFeLRS01Hfzpc6UdrF/Ml0TEZLI/cOzLH1Rw=;
	b=hokgIIP8caXlYS3I0yuJSwELb378UbDlTR4WE4YHwtgQopGxwV5JTYUA6MeTbISYaKkpjZ
	3/DcUidBj9ZbcqVy9iCBVdoi4uJUIBqJ4x/1ervWFNuaptt+/64jyQJtXfsWZs3ab0Yby9
	rO8GCSA7pWLRlpytzV4iipvkLer/+9g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YjegpdWpFeLRS01Hfzpc6UdrF/Ml0TEZLI/cOzLH1Rw=;
	b=gfQ7hcIA8TD6BdT7nSEPSk9U8qLzY+rENNaV42hlDphgodn5N8ynaXeMWq2+aFhxNXjPAe
	u+vpeU5WqD61PWAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A07D8139D1;
	Tue,  4 Jan 2022 00:10:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id WD+NJo+Q02FEQwAAMHmgww
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
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v4 16/32] mm/slub: Convert pfmemalloc_match() to take a struct slab
Date: Tue,  4 Jan 2022 01:10:30 +0100
Message-Id: <20220104001046.12263-17-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3028; i=vbabka@suse.cz; h=from:subject; bh=Pn37dXMX8RKLEDtW9qNrBwy1C9fNUsRg9YSuuIjgvy0=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05B3Nw881zQB5O5PLVqOx2iK61+7RWmpQNa1ZlHg Ny0a2HuJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQdwAKCRDgIcpz8YmpEJJmB/ 4u2nYrhjfc2+CZyn2iVdcaDZJp+/e3e+VyZDov1JKAM0sFhSicSJ4fbWk3gHQX9qgMSTP8dqvhtvFE hKypS5t61RA1CcqNdxZ7ycWDsb0jvJVlmLg0lgMNExKWDFCzYeIRMq8qlTysbDDhk1hmJP3pRTulrz SeDFdsI8WYnaV0tS0oy5by1z5r899Hl81tiaTwbkQudP6v9a8KA85uir8N0viAU2juiy4OTO0cgaY6 sY0NDi9BylX3kAj4txLm/UU+Z2Ag+LS/tD48EkxBN6B6WkF4yRRg0R4WUO8CgqPFKFKXZi9byVJ1V9 0L2mhsddjiaBQn9tWqmY5vAT4WJFSl
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Preparatory for mass conversion. Use the new slab_test_pfmemalloc()
helper.  As it doesn't do VM_BUG_ON(!PageSlab()) we no longer need the
pfmemalloc_match_unsafe() variant.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 mm/slub.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4d64c5b42629..c369806084e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2128,7 +2128,7 @@ static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain);
 static inline void put_cpu_partial(struct kmem_cache *s, struct page *page,
 				   int drain) { }
 #endif
-static inline bool pfmemalloc_match(struct page *page, gfp_t gfpflags);
+static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
 
 /*
  * Try to allocate a partial slab from a specific node.
@@ -2154,7 +2154,7 @@ static void *get_partial_node(struct kmem_cache *s, struct kmem_cache_node *n,
 	list_for_each_entry_safe(page, page2, &n->partial, slab_list) {
 		void *t;
 
-		if (!pfmemalloc_match(page, gfpflags))
+		if (!pfmemalloc_match(page_slab(page), gfpflags))
 			continue;
 
 		t = acquire_slab(s, n, page, object == NULL);
@@ -2832,22 +2832,9 @@ slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
 #endif
 }
 
-static inline bool pfmemalloc_match(struct page *page, gfp_t gfpflags)
+static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags)
 {
-	if (unlikely(PageSlabPfmemalloc(page)))
-		return gfp_pfmemalloc_allowed(gfpflags);
-
-	return true;
-}
-
-/*
- * A variant of pfmemalloc_match() that tests page flags without asserting
- * PageSlab. Intended for opportunistic checks before taking a lock and
- * rechecking that nobody else freed the page under us.
- */
-static inline bool pfmemalloc_match_unsafe(struct page *page, gfp_t gfpflags)
-{
-	if (unlikely(__PageSlabPfmemalloc(page)))
+	if (unlikely(slab_test_pfmemalloc(slab)))
 		return gfp_pfmemalloc_allowed(gfpflags);
 
 	return true;
@@ -2949,7 +2936,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	 * PFMEMALLOC but right now, we are losing the pfmemalloc
 	 * information when the page leaves the per-cpu allocator
 	 */
-	if (unlikely(!pfmemalloc_match_unsafe(page, gfpflags)))
+	if (unlikely(!pfmemalloc_match(page_slab(page), gfpflags)))
 		goto deactivate_slab;
 
 	/* must check again c->page in case we got preempted and it changed */
@@ -3061,7 +3048,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 		}
 	}
 
-	if (unlikely(!pfmemalloc_match(page, gfpflags)))
+	if (unlikely(!pfmemalloc_match(page_slab(page), gfpflags)))
 		/*
 		 * For !pfmemalloc_match() case we don't load freelist so that
 		 * we don't make further mismatched allocations easier.
-- 
2.34.1

