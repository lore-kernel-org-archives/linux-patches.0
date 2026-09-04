Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF853EC6AE;
	Fri,  4 Sep 2026 05:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500418; cv=none; b=RQFcSVmpCDLtSVZZLKQyGmLk/3mSEGb4+O88f83ludNRnqke1RJBIy2GRQjlipW9WqSpHX7b3EuxWgbZVqXr18DDfjbTEKlOJlLEDz5YNAdLZs3l1cb3YQguTVW33II8dlQ2jsSppWr6VKO5crVxUjwi0exTLK5nqP3mBhmclRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500418; c=relaxed/simple;
	bh=uue755OsezxfnKxwYs4IpCHvNddb0cYPwFuh1HFUJn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gv86FnvHWwRZkDaGFz3bH82xc5bZIw/YmfUcw8bjutVeq2GPgxMN1M2PGwLkQx2crscrn6julQqd+6tFb3fnMV9I4+nc5Li9BsFZ7UmFcuRPZs4yg1zoXDqKqnTg6PSm6+JS5VkSPGkJO3hiR8bXWSIN/vU5lmn/5uq1NAT7iio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgNxa+Eg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgNxa+Eg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59A81F00A3F;
	Fri,  4 Sep 2026 05:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500416;
	bh=WOaRqcNehiZm8rA0aM4wQVZkkm4IUpI6mB9CI/ssSgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgNxa+EgaxVrD/49ZLfDlsmr3RBhaT0xKKCMVXCA1zWPSoU4Vx5jnawvHMIx752rD
	 GgPfYp3H7w7u1tB94PzGzQjHh4Z9gEZ23gK11DnmgF0i1zgRdZiKbSrV4QsqYoxb1Q
	 3uVTMkK6VLT8F9l0nZGXFLN5G4NffANGRzFH0AQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 049/552] mm: page_alloc: move capture_control to the page allocator
Date: Fri,  4 Sep 2026 06:53:26 +0200
Message-ID: <20260904045748.951443776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka (SUSE) <vbabka@kernel.org>

commit aee220f565cce38f0efcff940ae2b44bdc495408 upstream.

The compaction capturing code assumes the allocation request order and
compaction target order are the same.  That won't be true once defrag_mode
promotes sub-block allocations to pageblock-order compaction: compaction
targets the larger order, while capture should remain at the original
allocation order.

Move the capture_control to the page allocator and give it its own copies
of what the page freeing path matches against - zone, migratetype and the
allocation order - rather than reaching into compaction's live
compact_control.  __alloc_pages_direct_compact() fills in migratetype and
order, and installs and hides current->capture_control around the whole
compaction call; try_to_compact_pages() aims capc->zone at each zone while
it is being compacted.  compact_zone_order() no longer deals with capture
at all.

Pass the capture_control through try_to_compact_pages() /
compact_zone_order() in place of the bare struct page **.

No functional change.

Link: https://lore.kernel.org/20260722150006.3848560-4-hannes@cmpxchg.org
Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compaction.h |    3 +-
 mm/compaction.c            |   50 ++++++++++++---------------------------------
 mm/internal.h              |    4 ++-
 mm/page_alloc.c            |   45 ++++++++++++++++++++++++++++++++++------
 4 files changed, 57 insertions(+), 45 deletions(-)

--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -56,6 +56,7 @@ enum compact_result {
 };
 
 struct alloc_context; /* in mm/internal.h */
+struct capture_control; /* in mm/internal.h */
 
 /*
  * Number of free order-0 pages that should be available above given watermark
@@ -92,7 +93,7 @@ extern int fragmentation_index(struct zo
 extern enum compact_result try_to_compact_pages(gfp_t gfp_mask,
 		unsigned int order, unsigned int alloc_flags,
 		const struct alloc_context *ac, enum compact_priority prio,
-		struct page **page);
+		struct capture_control *capc);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern bool compaction_suitable(struct zone *zone, int order,
 				unsigned long watermark, int highest_zoneidx);
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2780,9 +2780,8 @@ out:
 static enum compact_result compact_zone_order(struct zone *zone, int order,
 		gfp_t gfp_mask, enum compact_priority prio,
 		unsigned int alloc_flags, int highest_zoneidx,
-		struct page **capture)
+		struct capture_control *capc)
 {
-	enum compact_result ret;
 	struct compact_control cc = {
 		.order = order,
 		.search_order = order,
@@ -2797,38 +2796,8 @@ static enum compact_result compact_zone_
 		.ignore_skip_hint = (prio == MIN_COMPACT_PRIORITY),
 		.ignore_block_suitable = (prio == MIN_COMPACT_PRIORITY)
 	};
-	struct capture_control capc = {
-		.cc = &cc,
-		.page = NULL,
-	};
-
-	/*
-	 * Make sure the structs are really initialized before we expose the
-	 * capture control, in case we are interrupted and the interrupt handler
-	 * frees a page.
-	 */
-	barrier();
-	WRITE_ONCE(current->capture_control, &capc);
-
-	ret = compact_zone(&cc, &capc);
-
-	/*
-	 * Make sure we hide capture control first before we read the captured
-	 * page pointer, otherwise an interrupt could free and capture a page
-	 * and we would leak it.
-	 */
-	WRITE_ONCE(current->capture_control, NULL);
-	*capture = READ_ONCE(capc.page);
-	/*
-	 * Technically, it is also possible that compaction is skipped but
-	 * the page is still captured out of luck(IRQ came and freed the page).
-	 * Returning COMPACT_SUCCESS in such cases helps in properly accounting
-	 * the COMPACT[STALL|FAIL] when compaction is skipped.
-	 */
-	if (*capture)
-		ret = COMPACT_SUCCESS;
 
-	return ret;
+	return compact_zone(&cc, capc);
 }
 
 /**
@@ -2838,13 +2807,13 @@ static enum compact_result compact_zone_
  * @alloc_flags: The allocation flags of the current allocation
  * @ac: The context of current allocation
  * @prio: Determines how hard direct compaction should try to succeed
- * @capture: Pointer to free page created by compaction will be stored here
+ * @capc: Free page capture bypassing the freelist
  *
  * This is the main entry point for direct page compaction.
  */
 enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 		unsigned int alloc_flags, const struct alloc_context *ac,
-		enum compact_priority prio, struct page **capture)
+		enum compact_priority prio, struct capture_control *capc)
 {
 	struct zoneref *z;
 	struct zone *zone;
@@ -2871,8 +2840,17 @@ enum compact_result try_to_compact_pages
 			continue;
 		}
 
+		WRITE_ONCE(capc->zone, zone);
+
 		status = compact_zone_order(zone, order, gfp_mask, prio,
-				alloc_flags, ac->highest_zoneidx, capture);
+				alloc_flags, ac->highest_zoneidx, capc);
+
+		WRITE_ONCE(capc->zone, NULL);
+
+		/* Stop if a page has been captured */
+		if (READ_ONCE(capc->page))
+			status = COMPACT_SUCCESS;
+
 		rc = max(status, rc);
 
 		/* The allocation should succeed, stop compacting */
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -908,7 +908,9 @@ struct compact_control {
  * immediately when one is created during the free path.
  */
 struct capture_control {
-	struct compact_control *cc;
+	struct zone *zone;
+	int migratetype;
+	int order;
 	struct page *page;
 };
 
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -763,14 +763,14 @@ static inline struct capture_control *ta
 	return unlikely(capc) &&
 		!(current->flags & PF_KTHREAD) &&
 		!capc->page &&
-		capc->cc->zone == zone ? capc : NULL;
+		capc->zone == zone ? capc : NULL;
 }
 
 static inline bool
 compaction_capture(struct capture_control *capc, struct page *page,
 		   int order, int migratetype)
 {
-	if (!capc || order != capc->cc->order)
+	if (!capc || order != capc->order)
 		return false;
 
 	/* Do not accidentally pollute CMA or isolated regions*/
@@ -786,12 +786,12 @@ compaction_capture(struct capture_contro
 	 * have trouble finding a high-order free page.
 	 */
 	if (order < pageblock_order && migratetype == MIGRATE_MOVABLE &&
-	    capc->cc->migratetype != MIGRATE_MOVABLE)
+	    capc->migratetype != MIGRATE_MOVABLE)
 		return false;
 
-	if (migratetype != capc->cc->migratetype)
-		trace_mm_page_alloc_extfrag(page, capc->cc->order, order,
-					    capc->cc->migratetype, migratetype);
+	if (migratetype != capc->migratetype)
+		trace_mm_page_alloc_extfrag(page, capc->order, order,
+					    capc->migratetype, migratetype);
 
 	capc->page = page;
 	return true;
@@ -4132,6 +4132,12 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	struct page *page = NULL;
 	unsigned long pflags;
 	unsigned int noreclaim_flag;
+	struct capture_control capc = {
+		.zone = NULL,
+		.migratetype = ac->migratetype,
+		.order = order,
+		.page = NULL,
+	};
 
 	if (!order)
 		return NULL;
@@ -4141,8 +4147,33 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	fs_reclaim_acquire(gfp_mask);
 	noreclaim_flag = memalloc_noreclaim_save();
 
+	/*
+	 * Make sure the structs are really initialized before we expose the
+	 * capture control, in case we are interrupted and the interrupt handler
+	 * frees a page.
+	 */
+	barrier();
+	WRITE_ONCE(current->capture_control, &capc);
+
 	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
-								prio, &page);
+							       prio, &capc);
+
+	/*
+	 * Make sure we hide capture control first before we read the captured
+	 * page pointer, otherwise an interrupt could free and capture a page
+	 * and we would leak it.
+	 */
+	WRITE_ONCE(current->capture_control, NULL);
+	page = READ_ONCE(capc.page);
+
+	/*
+	 * Technically, it is also possible that compaction is skipped but
+	 * the page is still captured out of luck(IRQ came and freed the page).
+	 * Returning COMPACT_SUCCESS in such cases helps in properly accounting
+	 * the COMPACT[STALL|FAIL] when compaction is skipped.
+	 */
+	if (page)
+		*compact_result = COMPACT_SUCCESS;
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(gfp_mask);


