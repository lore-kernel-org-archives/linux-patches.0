Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE292C9C
	for <patches@lists.linux.dev>; Tue,  4 Jan 2022 00:10:57 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9D61E212B9;
	Tue,  4 Jan 2022 00:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1641255055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IIGkt9cOdj1PA8Pj7JiUWe1yTq0hQSv8VDmPdrbo2KA=;
	b=h6Zmn1cLAo3PAW76Ql6oj7Gwfc7JJ7jV10i7a+gtNdglHivTfP0fLi3bjx5tmmb8TXCF64
	8sTCd4WnApuyd9TG7yyQz8HJya3NWOsBmnDyj6mDa+6dOOXSCmvkLcTSZfHmDgxnR0EZ7m
	fh9I3iRN/nGIc2Uoxf9l9xROycYxmzs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1641255055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IIGkt9cOdj1PA8Pj7JiUWe1yTq0hQSv8VDmPdrbo2KA=;
	b=+zf7nxDoQym4g0sOn425tBAr+6VHZy5Gg/RjHelSkoHmymBT/ZVjlFtB1OCzcdhrNBdCtU
	VwHAH44UlwmAHyDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 740D0139EE;
	Tue,  4 Jan 2022 00:10:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id yNq5G4+Q02FEQwAAMHmgww
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
Subject: [PATCH v4 15/32] mm/slub: Convert __free_slab() to use struct slab
Date: Tue,  4 Jan 2022 01:10:29 +0100
Message-Id: <20220104001046.12263-16-vbabka@suse.cz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104001046.12263-1-vbabka@suse.cz>
References: <20220104001046.12263-1-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2600; h=from:subject; bh=m9gRxYsC3O4yHQ0l9BXq01ApF6BKbBtUKy1ILt9Fuwk=; b=owGbwMvMwMH4QPFU8cfOlQKMp9WSGBIvTyibn67LupzRbb/5loct3Vtksi9YN24vmnT0ccZ1Z9VM +ZcmnYzGLAyMHAyyYoosvd6TGVeaPpbY5xF3BmYQKxPIFAYuTgGYCIsq+z+dNU4htvpie1lb59x99z T3jR2Pl4sNW5jhX5dIN7t5Jd2a+y55LoxmkBPt1g5f/UEv7ijjjFf5jnIfNszjYu1d/+6++tN2u/9s QrUephc89FwCp0iscdm9YVNPrHfBn76XcXdWVuRLZK/Vuvfg/KQk/yn/n8muZw+8x6nWedxy3qGoOX onX3CVu01+O/Hr5FdcpsyqEUG2/rkRP3i9OTbWFOq4nvmu3GoZVyum474xbsvS264vExYyKm5z/Ph/ /6aTq6TDF+Y/mfP1/dTND0u1xNbtK5POW8q+vttLtJpJT9jNrvRbnY/RnbfJrJyNnxl2B5QnRd2XXf 1Hre62gkVWdJZVn3blE3NxrzRWAA==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
Content-Transfer-Encoding: 8bit

__free_slab() is on the boundary of distinguishing struct slab and
struct page so start with struct slab but convert to folio for working
with flags and folio_page() to call functions that require struct page.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 mm/slub.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 65cbdeae7edb..4d64c5b42629 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2005,35 +2005,34 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
 }
 
-static void __free_slab(struct kmem_cache *s, struct page *page)
+static void __free_slab(struct kmem_cache *s, struct slab *slab)
 {
-	int order = compound_order(page);
+	struct folio *folio = slab_folio(slab);
+	int order = folio_order(folio);
 	int pages = 1 << order;
 
 	if (kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS)) {
 		void *p;
 
-		slab_pad_check(s, page);
-		for_each_object(p, s, page_address(page),
-						page->objects)
-			check_object(s, page, p, SLUB_RED_INACTIVE);
+		slab_pad_check(s, folio_page(folio, 0));
+		for_each_object(p, s, slab_address(slab), slab->objects)
+			check_object(s, folio_page(folio, 0), p, SLUB_RED_INACTIVE);
 	}
 
-	__ClearPageSlabPfmemalloc(page);
-	__ClearPageSlab(page);
-	/* In union with page->mapping where page allocator expects NULL */
-	page->slab_cache = NULL;
+	__slab_clear_pfmemalloc(slab);
+	__folio_clear_slab(folio);
+	folio->mapping = NULL;
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
-	unaccount_slab(page_slab(page), order, s);
-	__free_pages(page, order);
+	unaccount_slab(slab, order, s);
+	__free_pages(folio_page(folio, 0), order);
 }
 
 static void rcu_free_slab(struct rcu_head *h)
 {
 	struct page *page = container_of(h, struct page, rcu_head);
 
-	__free_slab(page->slab_cache, page);
+	__free_slab(page->slab_cache, page_slab(page));
 }
 
 static void free_slab(struct kmem_cache *s, struct page *page)
@@ -2041,7 +2040,7 @@ static void free_slab(struct kmem_cache *s, struct page *page)
 	if (unlikely(s->flags & SLAB_TYPESAFE_BY_RCU)) {
 		call_rcu(&page->rcu_head, rcu_free_slab);
 	} else
-		__free_slab(s, page);
+		__free_slab(s, page_slab(page));
 }
 
 static void discard_slab(struct kmem_cache *s, struct page *page)
-- 
2.34.1

