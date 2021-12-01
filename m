Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224B62CAB
	for <patches@lists.linux.dev>; Wed,  1 Dec 2021 18:15:22 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E1D4E218B5;
	Wed,  1 Dec 2021 18:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1638382517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eerv0eOXwo1dz/cHVYapVAsLRxt5WoMuFF7LxI7Y1pU=;
	b=ju6NqaXcttO3OWBKxcI/IW2IOUgIzlEHyEWlXi0dCylOXBItZuPtBE+qrJfvKYZjL/YIXa
	I0KWdxsoL5yPsJ8yegxsORd+fJbQyy/KYuoPeuewN0/Naf9oWuvgGuO2afLqLXi7eGiX0d
	35tN2b+KKEW95bk/MgA91c3n0Poq4WU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1638382517;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eerv0eOXwo1dz/cHVYapVAsLRxt5WoMuFF7LxI7Y1pU=;
	b=peRBK6nhVPMNiuDHpTAYQVxJl+yiyXN7Xth/ugmuL05jAxmtOgzA9v3X6lKuyzNrUBDWEf
	hEeJkYHqQ85owRDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BDC8213D9D;
	Wed,  1 Dec 2021 18:15:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id KDKlLbW7p2HPSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Wed, 01 Dec 2021 18:15:17 +0000
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
Subject: [PATCH v2 16/33] mm/slub: Convert pfmemalloc_match() to take a struct slab
Date: Wed,  1 Dec 2021 19:14:53 +0100
Message-Id: <20211201181510.18784-17-vbabka@suse.cz>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201181510.18784-1-vbabka@suse.cz>
References: <20211201181510.18784-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2935; i=vbabka@suse.cz; h=from:subject; bh=N2hV2YbtRFPCsEmwb9JXnEFVgKFfaA6E1imI7J+GczQ=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7uBHnLSf9MYf4PcG3PYdsDhGmAdSogDmnVkl2so SmDS7hSJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7gQAKCRDgIcpz8YmpELj/B/ 4iPrY5wv0VgMWbOoCzjjUxgf3VQZsgTRmmkeMsj4Rha/g9CALiUdB4it+RQJFZnuzylgHuKmcCOtgr 4e5VqEZr4X0xnbePpA98zGpMhWFRpfxrX9EumjCEKVhwZbbNfHbFNPhCv7T2+pXYQIjXrw//AGCI6Z Z/4BSJStFDW6XVodvXubI0zpqj9u73PyTa6RRRi0l5VPmB2VuEuHK5CDZkUCygvq4t9JmDSdjrEFAC 0C9wdSHk9s4TGTB7VBK1T2BGRXRlEGwCQDiRWhMWrMj2Y8H+GXciypJoVlGAPmfp68V4laiMqssQJF nqlYrQgOj4XR0NDHGBSp0wURLAawMX
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Preparatory for mass conversion. Use the new slab_test_pfmemalloc() helper.  As
it doesn't do VM_BUG_ON(!PageSlab()) we no longer need the
pfmemalloc_match_unsafe() variant.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index daa5c5b605d6..8224962c81aa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2129,7 +2129,7 @@ static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain);
 static inline void put_cpu_partial(struct kmem_cache *s, struct page *page,
 				   int drain) { }
 #endif
-static inline bool pfmemalloc_match(struct page *page, gfp_t gfpflags);
+static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
 
 /*
  * Try to allocate a partial slab from a specific node.
@@ -2155,7 +2155,7 @@ static void *get_partial_node(struct kmem_cache *s, struct kmem_cache_node *n,
 	list_for_each_entry_safe(page, page2, &n->partial, slab_list) {
 		void *t;
 
-		if (!pfmemalloc_match(page, gfpflags))
+		if (!pfmemalloc_match(page_slab(page), gfpflags))
 			continue;
 
 		t = acquire_slab(s, n, page, object == NULL);
@@ -2833,22 +2833,9 @@ slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
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
@@ -2950,7 +2937,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	 * PFMEMALLOC but right now, we are losing the pfmemalloc
 	 * information when the page leaves the per-cpu allocator
 	 */
-	if (unlikely(!pfmemalloc_match_unsafe(page, gfpflags)))
+	if (unlikely(!pfmemalloc_match(page_slab(page), gfpflags)))
 		goto deactivate_slab;
 
 	/* must check again c->page in case we got preempted and it changed */
@@ -3062,7 +3049,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 		}
 	}
 
-	if (unlikely(!pfmemalloc_match(page, gfpflags)))
+	if (unlikely(!pfmemalloc_match(page_slab(page), gfpflags)))
 		/*
 		 * For !pfmemalloc_match() case we don't load freelist so that
 		 * we don't make further mismatched allocations easier.
-- 
2.33.1

