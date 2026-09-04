Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6C43242BD;
	Fri,  4 Sep 2026 05:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498532; cv=none; b=s84DL5oUa9KWiioT2PpnXREh9hNryiePSHh/8wPm6ojLZevaLo9Q4HA62BBfiVFmc26XAHBAjMjuX/1HvGwarnNfXY+xZUbuJL5zY5/GZv07slNQsjItBi6XVQpy5I/uQIBZRq0ZfWFzg6rx7kcl3qWy6gOSMhi0Ui5L9y7Qivo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498532; c=relaxed/simple;
	bh=d3YnOrsLD6MaZDj/wWa1Z4izofAT/WbGgTfgebzNtGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6WSb6Pvvrj4+TNpYKltWrY5rhsmVEhK7CJoagUwIOfzIYYMWffHDOGwMbQ+XWCtklmczhN83GeoGKHo78PaXpentT4TshN2DZOkVWM+g2cddJEcdnFDdDS8ZpE1aAdNUXtg+xNSp0echZDiiVLtVLnENQb+FypmnWOhFJbYxsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=greWbsNK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="greWbsNK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E49E1F00A3D;
	Fri,  4 Sep 2026 05:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498531;
	bh=fHIBNKVpjBVnDgGe3z3pSmpLQZ4plTqic6oA0Vu0ywY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=greWbsNK1fT//7uXtliAJICB3UbUrEzcjK5js2yusnfxEHUhzIFfcEr5e0pNQ8BES
	 F4uTd86VlWeXr5IxHxGimJGqc6DKVgnWlr/7jHxY2MEkbXM4ZkaBdpvLOdHnfqXwRf
	 pijtMiwl2bfYvIMOGjSe4XnklB6vpEeYdka2BPoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Brendan Jackman" <brendan.jackman@linux.dev>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 079/713] mm: page_alloc: fix non-movable reclaim storm in defrag_mode
Date: Fri,  4 Sep 2026 06:50:47 +0200
Message-ID: <20260904045805.611312949@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 7e8756d7ad22655b935c384f123071aa9de07a27 upstream.

As we deployed defrag_mode into Meta production, pressure spikes and
excessive swapping were observed on some workloads.  Tracing confirmed
that this is unmovable/reclaimable requests spinning in the allocator and
direct reclaim, causing excessive amounts of swap.

The initial plan for defrag_mode was to rely on kswapd/kcompactd to
produce blocks, and if those are overwhelmed under high pressure, let the
allocator fall back (__rmqueue_steal()) after its retry loops.  However,
that retrying results in more reclaim on some of these workloads than we'd
hoped, sometimes excessively so, spurred on by the !costly order
conditions in should_reclaim_retry().

The storms are dependent on the request type.  Reclaim will inevitably
make room in existing movable blocks, since that's where the LRU pages
live.  So if movable requests retry on reclaim, they make progress.

When non-movable requests spin in reclaim that isn't productive.  They
cannot use the individually freed pages, and the process is unlikely to
accidentally free whole blocks to meet the ALLOC_NOFRAGMENT bar.  They
spin and overreclaim excessively, which tanks performance and triggers
userspace guards like swap exhaustion or pressure based OOM.

To fix this, send non-movable requests, regardless of order, into
pageblock reclaim/compaction.  This way, they help move things along to
meet the ALLOC_NOFRAGMENT bar.  After this patch, the reclaim storms and
excess OOM rates are no longer observed in production.

The longer-term plan is still to have all requests, including the movable
ones, help make blocks to spread the cost of defragmenting more evenly and
fairly; combined with proper watermarking to reduce allocation latencies
in the common case.  However, doing this naively unearths scaling and
concurrency limitations in compaction that need to be addressed first.
Promoting just non-movables for now is the minimally viable bug fix for
the above issue.

[brendan.jackman@linux.dev: fix try_to_compact_pages() kerneldoc]
  Link: https://lore.kernel.org/DK7NM9RPUJOD.11PNJJ5N2OBED@linux.dev
Link: https://lore.kernel.org/20260722150006.3848560-5-hannes@cmpxchg.org
Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: "Brendan Jackman" <brendan.jackman@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
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
 mm/compaction.c |    2 +-
 mm/internal.h   |    6 ++++++
 mm/page_alloc.c |   31 ++++++++++++++++++++++++++-----
 3 files changed, 33 insertions(+), 6 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2825,7 +2825,7 @@ static enum compact_result compact_zone_
 /**
  * try_to_compact_pages - Direct compact to satisfy a high-order allocation
  * @gfp_mask: The GFP mask of the current allocation
- * @order: The order of the current allocation
+ * @order: The order to try to make available
  * @alloc_flags: The allocation flags of the current allocation
  * @ac: The context of current allocation
  * @prio: Determines how hard direct compaction should try to succeed
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1061,6 +1061,12 @@ struct compact_control {
 struct capture_control {
 	struct zone *zone;
 	int migratetype;
+	/*
+	 * Allocation request order. May differ from the compaction
+	 * order: defrag_mode promotes sub-block allocations to
+	 * pageblock-order compaction; capture still matches at the
+	 * original allocation order so prep_new_page() is consistent.
+	 */
 	int order;
 	struct page *page;
 };
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4152,8 +4152,24 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		.order = order,
 		.page = NULL,
 	};
+	int compact_order = order;
 
-	if (!order)
+	/*
+	 * If fallbacks are not permitted (defrag_mode), we either
+	 * need to reclaim space in a block of matching type, or clear
+	 * out an entire block to allow __rmqueue_claim() to convert.
+	 *
+	 * Reclaim by itself is primarily freeing space in movable
+	 * blocks, since that's where the LRU pages live. So this
+	 * works for movable requests, but not for others.
+	 *
+	 * For those, promote the order to help make blocks, instead
+	 * of spinning in reclaim alone unproductively.
+	 */
+	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
+		compact_order = max(order, pageblock_order);
+
+	if (!compact_order)
 		return NULL;
 
 	psi_memstall_enter(&pflags);
@@ -4169,8 +4185,8 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	barrier();
 	WRITE_ONCE(current->capture_control, &capc);
 
-	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
-							       prio, &capc);
+	*compact_result = try_to_compact_pages(gfp_mask, compact_order,
+					       alloc_flags, ac, prio, &capc);
 
 	/*
 	 * Make sure we hide capture control first before we read the captured
@@ -4215,7 +4231,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		struct zone *zone = page_zone(page);
 
 		zone->compact_blockskip_flush = false;
-		compaction_defer_reset(zone, order, true);
+		compaction_defer_reset(zone, compact_order, true);
 		count_vm_event(COMPACTSUCCESS);
 		return page;
 	}
@@ -4455,9 +4471,14 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 	struct page *page = NULL;
 	unsigned long pflags;
 	bool drained = false;
+	int reclaim_order = order;
+
+	/* Match the slowpath compaction promotion in __alloc_pages_direct_compact */
+	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
+		reclaim_order = max(order, pageblock_order);
 
 	psi_memstall_enter(&pflags);
-	*did_some_progress = __perform_reclaim(gfp_mask, order, ac);
+	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order, ac);
 	if (unlikely(!(*did_some_progress)))
 		goto out;
 


