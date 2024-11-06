Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C109B646;
	Wed,  6 Nov 2024 13:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899321; cv=none; b=EAIEjQuW6ZNea19W6TjLp15+1TC6foL00FK3RUf7rBasxBotM3J4oQi4QSB1v5xZc/likYDK21BDYXtHZ++kMmrdVcj1I5L2CoIeUh3p81l0aX5F1yflVNi1HuXgwPohDq7+ydrXJlOkjPrqijqdfphp0+1b2rgPQRYajkQ9LV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899321; c=relaxed/simple;
	bh=e9pndrQ1aaf9nd0nfXDm79MgNu1JWoutE42D+x6GxN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffMFoV4D0oJjUVYO28CWli6de7hbGMO+SStonjBLtSuTNkIQZ1x2A3GssAjE1cgN5EA/hBwyxfC+FOpIoRiASEMgyk/HJ8RaKPXXV02yFx+/hHdclYAnmufZn0J3iWh7maLAnmdGz6YL4FGwuq9UlWtXQOOVdrU9KNMdGFGlv2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GoheB3ML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GoheB3ML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65DFC4CECD;
	Wed,  6 Nov 2024 13:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899321;
	bh=e9pndrQ1aaf9nd0nfXDm79MgNu1JWoutE42D+x6GxN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoheB3ML/zjUQANIQ3WvI7CuINvX6342D+FDIygioLDph+Yqkq730A8gu1/fdZrwd
	 UcgqH3OGsRZvwtLxkmiqi2JVRnKCdRUAdxjtc+32nRF+cGXpGvcIVx65LX/dwGuQ0p
	 9Y2miZQxRs/t80CM4YV4ktQuLuDrsO2b2705qi0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Shakeel Butt <shakeelb@google.com>,
	David Rientjes <rientjes@google.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Greg Thelen <gthelen@google.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 56/73] mm/page_alloc: call check_new_pages() while zone spinlock is not held
Date: Wed,  6 Nov 2024 13:06:00 +0100
Message-ID: <20241106120301.630755013@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3313204c8ad553cf93f1ee8cc89456c73a7df938 ]

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 264efa022fa96..474150584ba48 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3698,10 +3698,10 @@ struct page *rmqueue(struct zone *preferred_zone,
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
@@ -3713,15 +3713,15 @@ struct page *rmqueue(struct zone *preferred_zone,
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
-- 
2.43.0



