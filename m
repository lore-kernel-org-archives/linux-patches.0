Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E886453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E00CC340EC;
	Tue, 22 Mar 2022 21:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985441;
	bh=0KQ7zTA0G7TDqiIMvbVyZ5xBbQEyvkssveWNFsODP7g=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=xRZKeCtEppkmuuflegs32owXrMaOfwAjLtro/WubjcyzUhmxYnkG8cFnLcXXprlMS
	 jqDTOjq9QIV13dtr0tyICuwkHZB7BzfMtD4JBPLBU6k9sTGxyM61AFGIDrypSc4W1v
	 M84q8r6Vr4CMiMWqiTOlXZPqlJVgvzTR6qlTLvQQ=
Date: Tue, 22 Mar 2022 14:44:00 -0700
To: weixugc@google.com,vbabka@suse.cz,shakeelb@google.com,rientjes@google.com,mhocko@kernel.org,hughd@google.com,gthelen@google.com,edumazet@google.com,mgorman@techsingularity.net,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 108/227] mm/page_alloc: check high-order pages for corruption during PCP operations
Message-Id: <20220322214401.3E00CC340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: check high-order pages for corruption during PCP operations

Eric Dumazet pointed out that commit 44042b449872 ("mm/page_alloc: allow
high-order pages to be stored on the per-cpu lists") only checks the head
page during PCP refill and allocation operations.  This was an oversight
and all pages should be checked.  This will incur a small performance
penalty but it's necessary for correctness.

Link: https://lkml.kernel.org/r/20220310092456.GJ15701@techsingularity.net
Fixes: 44042b449872 ("mm/page_alloc: allow high-order pages to be stored on the per-cpu lists")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Eric Dumazet <edumazet@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-check-high-order-pages-for-corruption-during-pcp-operations
+++ a/mm/page_alloc.c
@@ -2291,23 +2291,36 @@ static inline int check_new_page(struct
 	return 1;
 }
 
+static bool check_new_pages(struct page *page, unsigned int order)
+{
+	int i;
+	for (i = 0; i < (1 << order); i++) {
+		struct page *p = page + i;
+
+		if (unlikely(check_new_page(p)))
+			return true;
+	}
+
+	return false;
+}
+
 #ifdef CONFIG_DEBUG_VM
 /*
  * With DEBUG_VM enabled, order-0 pages are checked for expected state when
  * being allocated from pcp lists. With debug_pagealloc also enabled, they are
  * also checked when pcp lists are refilled from the free lists.
  */
-static inline bool check_pcp_refill(struct page *page)
+static inline bool check_pcp_refill(struct page *page, unsigned int order)
 {
 	if (debug_pagealloc_enabled_static())
-		return check_new_page(page);
+		return check_new_pages(page, order);
 	else
 		return false;
 }
 
-static inline bool check_new_pcp(struct page *page)
+static inline bool check_new_pcp(struct page *page, unsigned int order)
 {
-	return check_new_page(page);
+	return check_new_pages(page, order);
 }
 #else
 /*
@@ -2315,32 +2328,19 @@ static inline bool check_new_pcp(struct
  * when pcp lists are being refilled from the free lists. With debug_pagealloc
  * enabled, they are also checked when being allocated from the pcp lists.
  */
-static inline bool check_pcp_refill(struct page *page)
+static inline bool check_pcp_refill(struct page *page, unsigned int order)
 {
-	return check_new_page(page);
+	return check_new_pages(page, order);
 }
-static inline bool check_new_pcp(struct page *page)
+static inline bool check_new_pcp(struct page *page, unsigned int order)
 {
 	if (debug_pagealloc_enabled_static())
-		return check_new_page(page);
+		return check_new_pages(page, order);
 	else
 		return false;
 }
 #endif /* CONFIG_DEBUG_VM */
 
-static bool check_new_pages(struct page *page, unsigned int order)
-{
-	int i;
-	for (i = 0; i < (1 << order); i++) {
-		struct page *p = page + i;
-
-		if (unlikely(check_new_page(p)))
-			return true;
-	}
-
-	return false;
-}
-
 inline void post_alloc_hook(struct page *page, unsigned int order,
 				gfp_t gfp_flags)
 {
@@ -2982,7 +2982,7 @@ static int rmqueue_bulk(struct zone *zon
 		if (unlikely(page == NULL))
 			break;
 
-		if (unlikely(check_pcp_refill(page)))
+		if (unlikely(check_pcp_refill(page, order)))
 			continue;
 
 		/*
@@ -3600,7 +3600,7 @@ struct page *__rmqueue_pcplist(struct zo
 		page = list_first_entry(list, struct page, lru);
 		list_del(&page->lru);
 		pcp->count -= 1 << order;
-	} while (check_new_pcp(page));
+	} while (check_new_pcp(page, order));
 
 	return page;
 }
_
