Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1137D1E04AF;
	Wed,  6 Nov 2024 12:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897168; cv=none; b=hojZWXzcg2yvHLWqxi/NwXxAutTpu2YvvvlCD0ISHZE7ljpqp7Fpqh/fTlGACwiER6f150I7gq4EPHh6FRXIoxYi0gZPOiWGZuk56guagp9sYW/gTitGfHowLrlq+hBQD1UTXWBHaF3S8aDHRN0dfKb/kN9H/eVkFgdea1XiNLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897168; c=relaxed/simple;
	bh=bQc0QKwjeVyLnDxKPX4Tfqqnb1XMbzq727hmmfjsfFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYtpFoDuu5HJ1fYDpGoEdR9LZWgBo2NTAnPqDmE72JdTLreSOORCv1mzhqVjG/9JGYD3Ha26WR7kL4VgYP3BdTPTiDJi5aMKTNXN+y1vx/uxPm2+Qg367IJqyj1J7aVOsf99vHJ7RUlGu/OEL0kTh0FYg72UyImNXqNwR4K+Q94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8R2RRNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8R2RRNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C19AC4CECD;
	Wed,  6 Nov 2024 12:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897167;
	bh=bQc0QKwjeVyLnDxKPX4Tfqqnb1XMbzq727hmmfjsfFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8R2RRNdgU3EBK9oVYiRiM+uRFcHtXvzH8iQg7idt0Y0m+nXJ3K/DZ+kSgatxpKWj
	 J5Pa2b39uIlcZ9VShNu6MTqzhWDFAVFrL7gFmKGzDMsa7apar5ncQLUd0Q03c+ZzVI
	 i1X3mMbm6qqK9xpRGs9YnqKEaMPDGkfURUQupf34=
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
Subject: [PATCH 6.1 090/126] mm/page_alloc: rename ALLOC_HIGH to ALLOC_MIN_RESERVE
Date: Wed,  6 Nov 2024 13:04:51 +0100
Message-ID: <20241106120308.501197124@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@techsingularity.net>

[ Upstream commit 524c48072e5673f4511f1ad81493e2485863fd65 ]

Patch series "Discard __GFP_ATOMIC", v3.

Neil's patch has been residing in mm-unstable as commit 2fafb4fe8f7a ("mm:
discard __GFP_ATOMIC") for a long time and recently brought up again.
Most recently, I was worried that __GFP_HIGH allocations could use
high-order atomic reserves which is unintentional but there was no
response so lets revisit -- this series reworks how min reserves are used,
protects highorder reserves and then finishes with Neil's patch with very
minor modifications so it fits on top.

There was a review discussion on renaming __GFP_DIRECT_RECLAIM to
__GFP_ALLOW_BLOCKING but I didn't think it was that big an issue and is
orthogonal to the removal of __GFP_ATOMIC.

There were some concerns about how the gfp flags affect the min reserves
but it never reached a solid conclusion so I made my own attempt.

The series tries to iron out some of the details on how reserves are used.
ALLOC_HIGH becomes ALLOC_MIN_RESERVE and ALLOC_HARDER becomes
ALLOC_NON_BLOCK and documents how the reserves are affected.  For example,
ALLOC_NON_BLOCK (no direct reclaim) on its own allows 25% of the min
reserve.  ALLOC_MIN_RESERVE (__GFP_HIGH) allows 50% and both combined
allows deeper access again.  ALLOC_OOM allows access to 75%.

High-order atomic allocations are explicitly handled with the caveat that
no __GFP_ATOMIC flag means that any high-order allocation that specifies
GFP_HIGH and cannot enter direct reclaim will be treated as if it was
GFP_ATOMIC.

This patch (of 6):

__GFP_HIGH aliases to ALLOC_HIGH but the name does not really hint what it
means.  As ALLOC_HIGH is internal to the allocator, rename it to
ALLOC_MIN_RESERVE to document that the min reserves can be depleted.

Link: https://lkml.kernel.org/r/20230113111217.14134-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20230113111217.14134-2-mgorman@techsingularity.net
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
 mm/internal.h   | 4 +++-
 mm/page_alloc.c | 8 ++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index d01130efce5fb..1be79a5147549 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -755,7 +755,9 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #endif
 
 #define ALLOC_HARDER		 0x10 /* try to alloc harder */
-#define ALLOC_HIGH		 0x20 /* __GFP_HIGH set */
+#define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
+				       * of the min watermark.
+				       */
 #define ALLOC_CPUSET		 0x40 /* check for correct cpuset */
 #define ALLOC_CMA		 0x80 /* allow allocations from CMA areas */
 #ifdef CONFIG_ZONE_DMA32
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a905b850d31c4..f5b870780d3fd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3983,7 +3983,7 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 	/* free_pages may go negative - that's OK */
 	free_pages -= __zone_watermark_unusable_free(z, order, alloc_flags);
 
-	if (alloc_flags & ALLOC_HIGH)
+	if (alloc_flags & ALLOC_MIN_RESERVE)
 		min -= min / 2;
 
 	if (unlikely(alloc_harder)) {
@@ -4825,18 +4825,18 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	unsigned int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 
 	/*
-	 * __GFP_HIGH is assumed to be the same as ALLOC_HIGH
+	 * __GFP_HIGH is assumed to be the same as ALLOC_MIN_RESERVE
 	 * and __GFP_KSWAPD_RECLAIM is assumed to be the same as ALLOC_KSWAPD
 	 * to save two branches.
 	 */
-	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_HIGH);
+	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_MIN_RESERVE);
 	BUILD_BUG_ON(__GFP_KSWAPD_RECLAIM != (__force gfp_t) ALLOC_KSWAPD);
 
 	/*
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
-	 * set both ALLOC_HARDER (__GFP_ATOMIC) and ALLOC_HIGH (__GFP_HIGH).
+	 * set both ALLOC_HARDER (__GFP_ATOMIC) and ALLOC_MIN_RESERVE(__GFP_HIGH).
 	 */
 	alloc_flags |= (__force int)
 		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
-- 
2.43.0



