Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB821CCB5F;
	Wed,  6 Nov 2024 13:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899342; cv=none; b=IBjdFPnexgheR8uw3cjzQlhD27rNadoiLVBsueliICOBvPVnFXRoAebBIZ3hKxvCdYKAkvioEz/AEtuIpXw67UfEZ8l76mBc1YPpPnU3JsW2t5DvIOjFJzBJRIzdjRiMpE59WNE/fzphD1yOYb+MLJWYGZzD5UuebqXvy1oa7b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899342; c=relaxed/simple;
	bh=GQMffNVfNUF4SbmwlZD1+3LoPtbqc4ZDIqcPvisIZwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1g4Mgxa1c+XB3UIDszLn60NX86wSF1JjyQGCNi+U56a8kjOta8f08bGpFhkdEE5oa9lS+BvTZTK4ZB8RfcLWpnTmFWbfKLH9qUhxt//lHYNnrt5st5kfS3aq6KwiscqT2Xkucd84LZoz/WWn9viVE2ldquRfOiYArkzyXwLi0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGQC00qV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGQC00qV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83647C4CECD;
	Wed,  6 Nov 2024 13:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899341;
	bh=GQMffNVfNUF4SbmwlZD1+3LoPtbqc4ZDIqcPvisIZwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGQC00qVfLnJ+0A17JHbfRqxp2g6IsKbDcKa2XYXbHlb2Hq0432YgaIs0V6nsuxS7
	 KBZASVCVWcZaLmQBFAeyJjnlmkTj5XZ04QEoVjP6nGQBkbbJzyFuQkVfnOu9mK0ZmK
	 y4x0FoshHvkFCgLe8I74I9jMG3VOiJRpBk0jpxiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mel Gorman <mgorman@techsingularity.net>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	NeilBrown <neilb@suse.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 63/73] mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves
Date: Wed,  6 Nov 2024 13:06:07 +0100
Message-ID: <20241106120301.833826373@linuxfoundation.org>
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

[ Upstream commit 1ebbb21811b76c3b932959787f37985af36f62fa ]

GFP_ATOMIC allocations get flagged ALLOC_HARDER which is a vague
description.  In preparation for the removal of GFP_ATOMIC redefine
__GFP_ATOMIC to simply mean non-blocking and renaming ALLOC_HARDER to
ALLOC_NON_BLOCK accordingly.  __GFP_HIGH is required for access to
reserves but non-blocking is granted more access.  For example, GFP_NOWAIT
is non-blocking but has no special access to reserves.  A __GFP_NOFAIL
blocking allocation is granted access similar to __GFP_HIGH if the only
alternative is an OOM kill.

Link: https://lkml.kernel.org/r/20230113111217.14134-6-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/internal.h   |  7 +++++--
 mm/page_alloc.c | 44 ++++++++++++++++++++++++--------------------
 2 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 717e75313693c..cd444aa7a10af 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -592,7 +592,10 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_OOM		ALLOC_NO_WATERMARKS
 #endif
 
-#define ALLOC_HARDER		 0x10 /* try to alloc harder */
+#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
+				       * to 25% of the min watermark or
+				       * 62.5% if __GFP_HIGH is set.
+				       */
 #define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
 				       * of the min watermark.
 				       */
@@ -607,7 +610,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 /* Flags that allow allocations below the min watermark. */
-#define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
 enum ttu_flags;
 struct tlbflush_unmap_batch;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7778c2b11d8cb..404cee30dcc26 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3878,18 +3878,19 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 		 * __GFP_HIGH allows access to 50% of the min reserve as well
 		 * as OOM.
 		 */
-		if (alloc_flags & ALLOC_MIN_RESERVE)
+		if (alloc_flags & ALLOC_MIN_RESERVE) {
 			min -= min / 2;
 
-		/*
-		 * Non-blocking allocations can access some of the reserve
-		 * with more access if also __GFP_HIGH. The reasoning is that
-		 * a non-blocking caller may incur a more severe penalty
-		 * if it cannot get memory quickly, particularly if it's
-		 * also __GFP_HIGH.
-		 */
-		if (alloc_flags & ALLOC_HARDER)
-			min -= min / 4;
+			/*
+			 * Non-blocking allocations (e.g. GFP_ATOMIC) can
+			 * access more reserves than just __GFP_HIGH. Other
+			 * non-blocking allocations requests such as GFP_NOWAIT
+			 * or (GFP_KERNEL & ~__GFP_DIRECT_RECLAIM) do not get
+			 * access to the min reserve.
+			 */
+			if (alloc_flags & ALLOC_NON_BLOCK)
+				min -= min / 4;
+		}
 
 		/*
 		 * OOM victims can try even harder than the normal reserve
@@ -4729,28 +4730,30 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
-	 * set both ALLOC_HARDER (__GFP_ATOMIC) and ALLOC_MIN_RESERVE(__GFP_HIGH).
+	 * set both ALLOC_NON_BLOCK and ALLOC_MIN_RESERVE(__GFP_HIGH).
 	 */
 	alloc_flags |= (__force int)
 		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
 
-	if (gfp_mask & __GFP_ATOMIC) {
+	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
 		/*
 		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
 		 * if it can't schedule.
 		 */
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
-			alloc_flags |= ALLOC_HARDER;
+			alloc_flags |= ALLOC_NON_BLOCK;
 
 			if (order > 0)
 				alloc_flags |= ALLOC_HIGHATOMIC;
 		}
 
 		/*
-		 * Ignore cpuset mems for GFP_ATOMIC rather than fail, see the
-		 * comment for __cpuset_node_allowed().
+		 * Ignore cpuset mems for non-blocking __GFP_HIGH (probably
+		 * GFP_ATOMIC) rather than fail, see the comment for
+		 * __cpuset_node_allowed().
 		 */
-		alloc_flags &= ~ALLOC_CPUSET;
+		if (alloc_flags & ALLOC_MIN_RESERVE)
+			alloc_flags &= ~ALLOC_CPUSET;
 	} else if (unlikely(rt_task(current)) && in_task())
 		alloc_flags |= ALLOC_MIN_RESERVE;
 
@@ -5188,12 +5191,13 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		WARN_ON_ONCE(order > PAGE_ALLOC_COSTLY_ORDER);
 
 		/*
-		 * Help non-failing allocations by giving them access to memory
-		 * reserves but do not use ALLOC_NO_WATERMARKS because this
+		 * Help non-failing allocations by giving some access to memory
+		 * reserves normally used for high priority non-blocking
+		 * allocations but do not use ALLOC_NO_WATERMARKS because this
 		 * could deplete whole memory reserves which would just make
-		 * the situation worse
+		 * the situation worse.
 		 */
-		page = __alloc_pages_cpuset_fallback(gfp_mask, order, ALLOC_HARDER, ac);
+		page = __alloc_pages_cpuset_fallback(gfp_mask, order, ALLOC_MIN_RESERVE, ac);
 		if (page)
 			goto got_pg;
 
-- 
2.43.0



