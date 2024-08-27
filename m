Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E811C68B7;
	Tue, 27 Aug 2024 14:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770533; cv=none; b=KrgNSpluhleefEpP/0K06MZcUZBnEnorrkxg7PsQm93tqtlIg9ZYCzBqUzJv1Fue6nuBFytPZGSFxjJJAreLK2oY/3MlioUrzAX0kQVG4YzMaoVNaSjm7z7ZghOo+ugjwCYQqvLuxYC5w/+XJK6X+AZKPN+JiK1nMPHt40NhXug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770533; c=relaxed/simple;
	bh=uEuoxNaZkcCGTOEXkvlPzdTKDIpgGFqMt2EbYYCDAbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpZl536CNs6K8K6nUnwXguTOJcL8WiF9INLQ3Ittc0Yso/vmnEfNNohlHVVIwngl1O8ud/enh4cx+EYvIgzxjJEUdTF0fgwrG+qB6b0yexdsjJdXwK43PH2RxcliYso7NEwijR0j6NY4MaeTtC7p3sCeVbju44uHGeYIJk2q/kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmMu6vPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmMu6vPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C115C4E698;
	Tue, 27 Aug 2024 14:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770532;
	bh=uEuoxNaZkcCGTOEXkvlPzdTKDIpgGFqMt2EbYYCDAbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmMu6vPutD4ObINbu2aRQWtnmOWg+u+KiYvYeWOGx7k3HcOqcLGqm0vA1GdNQOXeh
	 h+ZujROAlYaIQWxvvhfju7aE5Z0zgP1IAD6MyLc7n15mSfNg1L0tKPz6lcT6+jfX7h
	 yfeGcG0BifwzCZ9K8/RWv00RMdroNmG3XsQpmouU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Jianxiong Gao <jxgao@google.com>,
	David Hildenbrand <david@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matthew Wilcox <willy@infradead.org>,
	Mel Gorman <mgorman@suse.de>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/341] mm: fix endless reclaim on machines with unaccepted memory
Date: Tue, 27 Aug 2024 16:37:37 +0200
Message-ID: <20240827143852.012154921@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

[ Upstream commit 807174a93d24c456503692dc3f5af322ee0b640a ]

Unaccepted memory is considered unusable free memory, which is not counted
as free on the zone watermark check.  This causes get_page_from_freelist()
to accept more memory to hit the high watermark, but it creates problems
in the reclaim path.

The reclaim path encounters a failed zone watermark check and attempts to
reclaim memory.  This is usually successful, but if there is little or no
reclaimable memory, it can result in endless reclaim with little to no
progress.  This can occur early in the boot process, just after start of
the init process when the only reclaimable memory is the page cache of the
init executable and its libraries.

Make unaccepted memory free from watermark check point of view.  This way
unaccepted memory will never be the trigger of memory reclaim.  Accept
more memory in the get_page_from_freelist() if needed.

Link: https://lkml.kernel.org/r/20240809114854.3745464-2-kirill.shutemov@linux.intel.com
Fixes: dcdfdd40fa82 ("mm: Add support for unaccepted memory")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Jianxiong Gao <jxgao@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Jianxiong Gao <jxgao@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 39bdbfb5313fb..edb32635037f4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -302,7 +302,7 @@ EXPORT_SYMBOL(nr_online_nodes);
 
 static bool page_contains_unaccepted(struct page *page, unsigned int order);
 static void accept_page(struct page *page, unsigned int order);
-static bool try_to_accept_memory(struct zone *zone, unsigned int order);
+static bool cond_accept_memory(struct zone *zone, unsigned int order);
 static inline bool has_unaccepted_memory(void);
 static bool __free_unaccepted(struct page *page);
 
@@ -2830,9 +2830,6 @@ static inline long __zone_watermark_unusable_free(struct zone *z,
 	if (!(alloc_flags & ALLOC_CMA))
 		unusable_free += zone_page_state(z, NR_FREE_CMA_PAGES);
 #endif
-#ifdef CONFIG_UNACCEPTED_MEMORY
-	unusable_free += zone_page_state(z, NR_UNACCEPTED);
-#endif
 
 	return unusable_free;
 }
@@ -3126,16 +3123,16 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			}
 		}
 
+		cond_accept_memory(zone, order);
+
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
 		if (!zone_watermark_fast(zone, order, mark,
 				       ac->highest_zoneidx, alloc_flags,
 				       gfp_mask)) {
 			int ret;
 
-			if (has_unaccepted_memory()) {
-				if (try_to_accept_memory(zone, order))
-					goto try_this_zone;
-			}
+			if (cond_accept_memory(zone, order))
+				goto try_this_zone;
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 			/*
@@ -3189,10 +3186,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
 			return page;
 		} else {
-			if (has_unaccepted_memory()) {
-				if (try_to_accept_memory(zone, order))
-					goto try_this_zone;
-			}
+			if (cond_accept_memory(zone, order))
+				goto try_this_zone;
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 			/* Try again if zone has deferred pages */
@@ -6619,9 +6614,6 @@ static bool try_to_accept_memory_one(struct zone *zone)
 	struct page *page;
 	bool last;
 
-	if (list_empty(&zone->unaccepted_pages))
-		return false;
-
 	spin_lock_irqsave(&zone->lock, flags);
 	page = list_first_entry_or_null(&zone->unaccepted_pages,
 					struct page, lru);
@@ -6647,23 +6639,29 @@ static bool try_to_accept_memory_one(struct zone *zone)
 	return true;
 }
 
-static bool try_to_accept_memory(struct zone *zone, unsigned int order)
+static bool cond_accept_memory(struct zone *zone, unsigned int order)
 {
 	long to_accept;
-	int ret = false;
+	bool ret = false;
+
+	if (!has_unaccepted_memory())
+		return false;
+
+	if (list_empty(&zone->unaccepted_pages))
+		return false;
 
 	/* How much to accept to get to high watermark? */
 	to_accept = high_wmark_pages(zone) -
 		    (zone_page_state(zone, NR_FREE_PAGES) -
-		    __zone_watermark_unusable_free(zone, order, 0));
+		    __zone_watermark_unusable_free(zone, order, 0) -
+		    zone_page_state(zone, NR_UNACCEPTED));
 
-	/* Accept at least one page */
-	do {
+	while (to_accept > 0) {
 		if (!try_to_accept_memory_one(zone))
 			break;
 		ret = true;
 		to_accept -= MAX_ORDER_NR_PAGES;
-	} while (to_accept > 0);
+	}
 
 	return ret;
 }
@@ -6706,7 +6704,7 @@ static void accept_page(struct page *page, unsigned int order)
 {
 }
 
-static bool try_to_accept_memory(struct zone *zone, unsigned int order)
+static bool cond_accept_memory(struct zone *zone, unsigned int order)
 {
 	return false;
 }
-- 
2.43.0



