Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661956453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E58C340EC;
	Tue, 22 Mar 2022 21:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985395;
	bh=gwx7EbpqxdKZ4x56sd/wrooQG2UM+FkrsbZkthcsn0o=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=D/Js3zL6IPeCs+niDVuf+/BD08mvPcNmRVUzVVo+trHjpJp/zvs4F+2ZMRsbUdxVH
	 aksnPjmXgPscoP/KSRHLwG8Ooz1qNPbWW6zoat9gaEACHNY0IVlBOT69ZVoEZMCLkK
	 mipKtN0Czj3RT+uRQUS6y8GyGD3xU9w+EdlsahOU=
Date: Tue, 22 Mar 2022 14:43:14 -0700
To: willy@infradead.org,vbabka@suse.cz,nsaenzju@redhat.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 093/227] mm/page_alloc: don't pass pfn to free_unref_page_commit()
Message-Id: <20220322214315.30E58C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: mm/page_alloc: don't pass pfn to free_unref_page_commit()

free_unref_page_commit() doesn't make use of its pfn argument, so get
rid of it.

Link: https://lkml.kernel.org/r/20220202140451.415928-1-nsaenzju@redhat.com
Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-pass-pfn-to-free_unref_page_commit
+++ a/mm/page_alloc.c
@@ -3366,8 +3366,8 @@ static int nr_pcp_high(struct per_cpu_pa
 	return min(READ_ONCE(pcp->batch) << 2, high);
 }
 
-static void free_unref_page_commit(struct page *page, unsigned long pfn,
-				   int migratetype, unsigned int order)
+static void free_unref_page_commit(struct page *page, int migratetype,
+				   unsigned int order)
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
@@ -3416,7 +3416,7 @@ void free_unref_page(struct page *page,
 	}
 
 	local_lock_irqsave(&pagesets.lock, flags);
-	free_unref_page_commit(page, pfn, migratetype, order);
+	free_unref_page_commit(page, migratetype, order);
 	local_unlock_irqrestore(&pagesets.lock, flags);
 }
 
@@ -3426,13 +3426,13 @@ void free_unref_page(struct page *page,
 void free_unref_page_list(struct list_head *list)
 {
 	struct page *page, *next;
-	unsigned long flags, pfn;
+	unsigned long flags;
 	int batch_count = 0;
 	int migratetype;
 
 	/* Prepare pages for freeing */
 	list_for_each_entry_safe(page, next, list, lru) {
-		pfn = page_to_pfn(page);
+		unsigned long pfn = page_to_pfn(page);
 		if (!free_unref_page_prepare(page, pfn, 0)) {
 			list_del(&page->lru);
 			continue;
@@ -3448,15 +3448,10 @@ void free_unref_page_list(struct list_he
 			free_one_page(page_zone(page), page, pfn, 0, migratetype, FPI_NONE);
 			continue;
 		}
-
-		set_page_private(page, pfn);
 	}
 
 	local_lock_irqsave(&pagesets.lock, flags);
 	list_for_each_entry_safe(page, next, list, lru) {
-		pfn = page_private(page);
-		set_page_private(page, 0);
-
 		/*
 		 * Non-isolated types over MIGRATE_PCPTYPES get added
 		 * to the MIGRATE_MOVABLE pcp list.
@@ -3466,7 +3461,7 @@ void free_unref_page_list(struct list_he
 			migratetype = MIGRATE_MOVABLE;
 
 		trace_mm_page_free_batched(page);
-		free_unref_page_commit(page, pfn, migratetype, 0);
+		free_unref_page_commit(page, migratetype, 0);
 
 		/*
 		 * Guard against excessive IRQ disabled times when we get
_
