Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FF91DF72E;
	Mon, 12 May 2025 17:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072233; cv=none; b=Qp7j1oYTNzBCT7DRLW6TSnT9BCZIDz7qoMwOOq2l9YVrvgf20WSb6hTaA4mhnlZ1CJAbBNtASdccFgWmHxYtPIUtS6zfIEL86qxQhLQyJnNADUYWxmZfg7ss4uR7cCc3DIfDbqNaiUw5UVTeMlyzAMXPXFBCZnSpj/w7G53+xsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072233; c=relaxed/simple;
	bh=LJHRuCUr8er9t5hy2yXmrWrr2Djd5n0sYVqvUQE6X3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdbs37CiDlgshY7X3q/RAtZ5aB0/dtlszZWanbX1fP8AcCiiMcGM1D5wmRuFiBZl1YoxiQavYNyVetFiBD9jVNsggmXsAV1bJyngkgUZlVgrGhUzKTGnY5mJNWy7pyBM5brs/j1IPJkU8ZOJJxyx3raWVVOjdX2j72LYldD4138=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGuQBt5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGuQBt5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBB6C4CEE7;
	Mon, 12 May 2025 17:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072232;
	bh=LJHRuCUr8er9t5hy2yXmrWrr2Djd5n0sYVqvUQE6X3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGuQBt5KThcysa6ypqwWJ9tk3jCLVFPxOP57Oo3s4XsITORoREVGivWEg1TEHtTYh
	 D58toIx2Hxt23VwRIj4yWECbEtscUuk59ADRyGc/tJjWYXCY16JN/QaES2HLChq1/w
	 YbLWvxU5khxVPMYQIdMLgTRF73PI7d8e4fVE5B58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 176/197] mm: page_alloc: dont steal single pages from biggest buddy
Date: Mon, 12 May 2025 19:40:26 +0200
Message-ID: <20250512172051.554238423@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit c2f6ea38fc1b640aa7a2e155cc1c0410ff91afa2 upstream.

The fallback code searches for the biggest buddy first in an attempt to
steal the whole block and encourage type grouping down the line.

The approach used to be this:

- Non-movable requests will split the largest buddy and steal the
  remainder. This splits up contiguity, but it allows subsequent
  requests of this type to fall back into adjacent space.

- Movable requests go and look for the smallest buddy instead. The
  thinking is that movable requests can be compacted, so grouping is
  less important than retaining contiguity.

c0cd6f557b90 ("mm: page_alloc: fix freelist movement during block
conversion") enforces freelist type hygiene, which restricts stealing to
either claiming the whole block or just taking the requested chunk; no
additional pages or buddy remainders can be stolen any more.

The patch mishandled when to switch to finding the smallest buddy in that
new reality.  As a result, it may steal the exact request size, but from
the biggest buddy.  This causes fracturing for no good reason.

Fix this by committing to the new behavior: either steal the whole block,
or fall back to the smallest buddy.

Remove single-page stealing from steal_suitable_fallback().  Rename it to
try_to_steal_block() to make the intentions clear.  If this fails, always
fall back to the smallest buddy.

The following is from 4 runs of mmtest's thpchallenge.  "Pollute" is
single page fallback, "steal" is conversion of a partially used block.
The numbers for free block conversions (omitted) are comparable.

				     vanilla	      patched

@pollute[unmovable from reclaimable]:	  27		  106
@pollute[unmovable from movable]:	  82		   46
@pollute[reclaimable from unmovable]:	 256		   83
@pollute[reclaimable from movable]:	  46		    8
@pollute[movable from unmovable]:	4841		  868
@pollute[movable from reclaimable]:	5278		12568

@steal[unmovable from reclaimable]:	  11		   12
@steal[unmovable from movable]:		 113		   49
@steal[reclaimable from unmovable]:	  19		   34
@steal[reclaimable from movable]:	  47		   21
@steal[movable from unmovable]:		 250		  183
@steal[movable from reclaimable]:	  81		   93

The allocator appears to do a better job at keeping stealing and polluting
to the first fallback preference.  As a result, the numbers for "from
movable" - the least preferred fallback option, and most detrimental to
compactability - are down across the board.

Link: https://lkml.kernel.org/r/20250225001023.1494422-2-hannes@cmpxchg.org
Fixes: c0cd6f557b90 ("mm: page_alloc: fix freelist movement during block conversion")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |   80 +++++++++++++++++++++++---------------------------------
 1 file changed, 34 insertions(+), 46 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1908,13 +1908,12 @@ static inline bool boost_watermark(struc
  * can claim the whole pageblock for the requested migratetype. If not, we check
  * the pageblock for constituent pages; if at least half of the pages are free
  * or compatible, we can still claim the whole block, so pages freed in the
- * future will be put on the correct free list. Otherwise, we isolate exactly
- * the order we need from the fallback block and leave its migratetype alone.
+ * future will be put on the correct free list.
  */
 static struct page *
-steal_suitable_fallback(struct zone *zone, struct page *page,
-			int current_order, int order, int start_type,
-			unsigned int alloc_flags, bool whole_block)
+try_to_steal_block(struct zone *zone, struct page *page,
+		   int current_order, int order, int start_type,
+		   unsigned int alloc_flags)
 {
 	int free_pages, movable_pages, alike_pages;
 	unsigned long start_pfn;
@@ -1927,7 +1926,7 @@ steal_suitable_fallback(struct zone *zon
 	 * highatomic accounting.
 	 */
 	if (is_migrate_highatomic(block_type))
-		goto single_page;
+		return NULL;
 
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
@@ -1948,14 +1947,10 @@ steal_suitable_fallback(struct zone *zon
 	if (boost_watermark(zone) && (alloc_flags & ALLOC_KSWAPD))
 		set_bit(ZONE_BOOSTED_WATERMARK, &zone->flags);
 
-	/* We are not allowed to try stealing from the whole block */
-	if (!whole_block)
-		goto single_page;
-
 	/* moving whole block can fail due to zone boundary conditions */
 	if (!prep_move_freepages_block(zone, page, &start_pfn, &free_pages,
 				       &movable_pages))
-		goto single_page;
+		return NULL;
 
 	/*
 	 * Determine how many pages are compatible with our allocation.
@@ -1988,9 +1983,7 @@ steal_suitable_fallback(struct zone *zon
 		return __rmqueue_smallest(zone, order, start_type);
 	}
 
-single_page:
-	page_del_and_expand(zone, page, order, current_order, block_type);
-	return page;
+	return NULL;
 }
 
 /*
@@ -2172,14 +2165,19 @@ static bool unreserve_highatomic_pageblo
 }
 
 /*
- * Try finding a free buddy page on the fallback list and put it on the free
- * list of requested migratetype, possibly along with other pages from the same
- * block, depending on fragmentation avoidance heuristics. Returns true if
- * fallback was found so that __rmqueue_smallest() can grab it.
+ * Try finding a free buddy page on the fallback list.
+ *
+ * This will attempt to steal a whole pageblock for the requested type
+ * to ensure grouping of such requests in the future.
+ *
+ * If a whole block cannot be stolen, regress to __rmqueue_smallest()
+ * logic to at least break up as little contiguity as possible.
  *
  * The use of signed ints for order and current_order is a deliberate
  * deviation from the rest of this file, to make the for loop
  * condition simpler.
+ *
+ * Return the stolen page, or NULL if none can be found.
  */
 static __always_inline struct page *
 __rmqueue_fallback(struct zone *zone, int order, int start_migratetype,
@@ -2213,45 +2211,35 @@ __rmqueue_fallback(struct zone *zone, in
 		if (fallback_mt == -1)
 			continue;
 
-		/*
-		 * We cannot steal all free pages from the pageblock and the
-		 * requested migratetype is movable. In that case it's better to
-		 * steal and split the smallest available page instead of the
-		 * largest available page, because even if the next movable
-		 * allocation falls back into a different pageblock than this
-		 * one, it won't cause permanent fragmentation.
-		 */
-		if (!can_steal && start_migratetype == MIGRATE_MOVABLE
-					&& current_order > order)
-			goto find_smallest;
+		if (!can_steal)
+			break;
 
-		goto do_steal;
+		page = get_page_from_free_area(area, fallback_mt);
+		page = try_to_steal_block(zone, page, current_order, order,
+					  start_migratetype, alloc_flags);
+		if (page)
+			goto got_one;
 	}
 
-	return NULL;
+	if (alloc_flags & ALLOC_NOFRAGMENT)
+		return NULL;
 
-find_smallest:
+	/* No luck stealing blocks. Find the smallest fallback page */
 	for (current_order = order; current_order < NR_PAGE_ORDERS; current_order++) {
 		area = &(zone->free_area[current_order]);
 		fallback_mt = find_suitable_fallback(area, current_order,
 				start_migratetype, false, &can_steal);
-		if (fallback_mt != -1)
-			break;
-	}
-
-	/*
-	 * This should not happen - we already found a suitable fallback
-	 * when looking for the largest page.
-	 */
-	VM_BUG_ON(current_order > MAX_PAGE_ORDER);
+		if (fallback_mt == -1)
+			continue;
 
-do_steal:
-	page = get_page_from_free_area(area, fallback_mt);
+		page = get_page_from_free_area(area, fallback_mt);
+		page_del_and_expand(zone, page, order, current_order, fallback_mt);
+		goto got_one;
+	}
 
-	/* take off list, maybe claim block, expand remainder */
-	page = steal_suitable_fallback(zone, page, current_order, order,
-				       start_migratetype, alloc_flags, can_steal);
+	return NULL;
 
+got_one:
 	trace_mm_page_alloc_extfrag(page, order, current_order,
 		start_migratetype, fallback_mt);
 


