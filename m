Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEC76453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358BDC340EE;
	Tue, 22 Mar 2022 21:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985438;
	bh=E4nHmtAv0Fqu/LoRC6ZvCmDHwa3dac55j0gxoKuqloA=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=Zgf61Nhv9csIcNw7b/j3uyBS+d/Hbml7hzO4a3zHO3bsN8STwYG5VX/QG7KEiPH8V
	 y/dWCEoZrDSi6RCZjLPu0snbV+fpvgaYWKyR+MMpwYSKkjOroEZSEFXfHiwV0pzPtq
	 0cHJNqZSFah7mo7BK/vR7NfL81UioYuqh6vGuit8=
Date: Tue, 22 Mar 2022 14:43:57 -0700
To: weixugc@google.com,vbabka@suse.cz,shakeelb@google.com,rientjes@google.com,mhocko@kernel.org,mgorman@techsingularity.net,hughd@google.com,gthelen@google.com,edumazet@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 107/227] mm/page_alloc: call check_new_pages() while zone spinlock is not held
Message-Id: <20220322214358.358BDC340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Eric Dumazet <edumazet@google.com>
Subject: mm/page_alloc: call check_new_pages() while zone spinlock is not held

For high order pages not using pcp, rmqueue() is currently calling the
costly check_new_pages() while zone spinlock is held, and hard irqs
masked.

This is not needed, we can release the spinlock sooner to reduce zone
spinlock contention.

Note that after this patch, we call __mod_zone_freepage_state() before
deciding to leak the page because it is in bad state.

Link: https://lkml.kernel.org/r/20220304170215.1868106-1-eric.dumazet@gmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-call-check_new_pages-while-zone-spinlock-is-not-held
+++ a/mm/page_alloc.c
@@ -3665,10 +3665,10 @@ struct page *rmqueue(struct zone *prefer
 	 * allocate greater than order-1 page units with __GFP_NOFAIL.
 	 */
 	WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
-	spin_lock_irqsave(&zone->lock, flags);
 
 	do {
 		page = NULL;
+		spin_lock_irqsave(&zone->lock, flags);
 		/*
 		 * order-0 request can reach here when the pcplist is skipped
 		 * due to non-CMA allocation context. HIGHATOMIC area is
@@ -3680,15 +3680,15 @@ struct page *rmqueue(struct zone *prefer
 			if (page)
 				trace_mm_page_alloc_zone_locked(page, order, migratetype);
 		}
-		if (!page)
+		if (!page) {
 			page = __rmqueue(zone, order, migratetype, alloc_flags);
-	} while (page && check_new_pages(page, order));
-	if (!page)
-		goto failed;
-
-	__mod_zone_freepage_state(zone, -(1 << order),
-				  get_pcppage_migratetype(page));
-	spin_unlock_irqrestore(&zone->lock, flags);
+			if (!page)
+				goto failed;
+		}
+		__mod_zone_freepage_state(zone, -(1 << order),
+					  get_pcppage_migratetype(page));
+		spin_unlock_irqrestore(&zone->lock, flags);
+	} while (check_new_pages(page, order));
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 	zone_statistics(preferred_zone, zone, 1);
_
