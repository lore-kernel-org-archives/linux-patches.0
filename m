Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9D31DED7C;
	Wed,  6 Nov 2024 13:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899336; cv=none; b=nj44R9bwC+4MmRTNUUbWkdwjjZgL8L3icb4d3gdC9yJAiyxUCkZ0+FJ6dXuHyPf5fpfgvcqwjfMmL7nWNQuQmOfWvZLUhNqmFDlI5RG/jkYWAei5oWCtwOOkLJ1IyyGkH0GPArWZHuVroTgXCrc9TmsUEHD6s1BIaezJfijDAXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899336; c=relaxed/simple;
	bh=uiWKNUEXL27mPQ8EbHwevrHmbJgrms8JDovoqqzDlhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTr4eRDMiB8ExIicnn5P9kJ1kL8StSAJdoftOpBu8VXSwqoIYs+6gRIxEieDOmJvxNKGlOJyBTEAdvuhDP2XRFjWA7o6GMUuhwuw14C1xUmUtrVFwCHs7etq5cZZ2oRpda2Eo+RHFs/ZWcnbLo60ssxdIdds/hjFwWh4uB24swU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uy2fZOmi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uy2fZOmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAA3C4CECD;
	Wed,  6 Nov 2024 13:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899336;
	bh=uiWKNUEXL27mPQ8EbHwevrHmbJgrms8JDovoqqzDlhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uy2fZOmiHaHPa4SEQHAHy5x0GIIwBbDYakFnaWT0i9IhAhfEIpEEgYLhntALqGitY
	 ri6K7ZLsu/S/ttbe/G8TyXz50PYbn38SO7KtWQDGTOWm0fnbmkn3F1K01IMU1z9Ofh
	 QPaSEM7/csTpXg+GeYHgJiYH9LPqWhoa9JK7cbCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mel Gorman <mgorman@techsingularity.net>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	NeilBrown <neilb@suse.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 61/73] mm/page_alloc: explicitly record high-order atomic allocations in alloc_flags
Date: Wed,  6 Nov 2024 13:06:05 +0100
Message-ID: <20241106120301.773357090@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@techsingularity.net>

[ Upstream commit eb2e2b425c6984ca8034448a3f2c680622bd3d4d ]

A high-order ALLOC_HARDER allocation is assumed to be atomic.  While that
is accurate, it changes later in the series.  In preparation, explicitly
record high-order atomic allocations in gfp_to_alloc_flags().

Link: https://lkml.kernel.org/r/20230113111217.14134-4-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/internal.h   |  1 +
 mm/page_alloc.c | 29 +++++++++++++++++++++++------
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index e6c96327b5855..136f435e0f1ab 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -603,6 +603,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #else
 #define ALLOC_NOFRAGMENT	  0x0
 #endif
+#define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 enum ttu_flags;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 72835cf4034bc..43122de999c4c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3614,10 +3614,20 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 		 * reserved for high-order atomic allocation, so order-0
 		 * request should skip it.
 		 */
-		if (order > 0 && alloc_flags & ALLOC_HARDER)
+		if (alloc_flags & ALLOC_HIGHATOMIC)
 			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 		if (!page) {
 			page = __rmqueue(zone, order, migratetype, alloc_flags);
+
+			/*
+			 * If the allocation fails, allow OOM handling access
+			 * to HIGHATOMIC reserves as failing now is worse than
+			 * failing a high-order atomic allocation in the
+			 * future.
+			 */
+			if (!page && (alloc_flags & ALLOC_OOM))
+				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
+
 			if (!page) {
 				spin_unlock_irqrestore(&zone->lock, flags);
 				return NULL;
@@ -3912,8 +3922,10 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			return true;
 		}
 #endif
-		if (alloc_harder && !free_area_empty(area, MIGRATE_HIGHATOMIC))
+		if ((alloc_flags & (ALLOC_HIGHATOMIC|ALLOC_OOM)) &&
+		    !free_area_empty(area, MIGRATE_HIGHATOMIC)) {
 			return true;
+		}
 	}
 	return false;
 }
@@ -4172,7 +4184,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			 * If this is a high-order atomic allocation then check
 			 * if the pageblock should be reserved for the future
 			 */
-			if (unlikely(order && (alloc_flags & ALLOC_HARDER)))
+			if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
 				reserve_highatomic_pageblock(page, zone, order);
 
 			return page;
@@ -4691,7 +4703,7 @@ static void wake_all_kswapds(unsigned int order, gfp_t gfp_mask,
 }
 
 static inline unsigned int
-gfp_to_alloc_flags(gfp_t gfp_mask)
+gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 {
 	unsigned int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 
@@ -4717,8 +4729,13 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
 		 * if it can't schedule.
 		 */
-		if (!(gfp_mask & __GFP_NOMEMALLOC))
+		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
 			alloc_flags |= ALLOC_HARDER;
+
+			if (order > 0)
+				alloc_flags |= ALLOC_HIGHATOMIC;
+		}
+
 		/*
 		 * Ignore cpuset mems for GFP_ATOMIC rather than fail, see the
 		 * comment for __cpuset_node_allowed().
@@ -4946,7 +4963,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * kswapd needs to be woken up, and to avoid the cost of setting up
 	 * alloc_flags precisely. So we do that now.
 	 */
-	alloc_flags = gfp_to_alloc_flags(gfp_mask);
+	alloc_flags = gfp_to_alloc_flags(gfp_mask, order);
 
 	/*
 	 * We need to recalculate the starting point for the zonelist iterator
-- 
2.43.0



