Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E6B6453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D78CC340EE;
	Tue, 22 Mar 2022 21:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985410;
	bh=MvlE/YdWISrTBlm8HEn6KO4CRbuwRXLBW8jijui9aFI=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=DGpPWhMES2JMpX2swDCOx9utDKzljS3ZJ5ZWXAvyrGKZYpzz+4e9lfJoDMg6QDTe0
	 qOBHj5cVN7Nd4hioRvQ9zP2TpNxSHKgfo6CfkYOjIsq1jTcCkQNRJV3p4FjEEhyg1V
	 HEjkPa6slnz33/z6mrmGvAZmMtunYb7ljDvEXPH0=
Date: Tue, 22 Mar 2022 14:43:30 -0700
To: vbabka@suse.cz,mhocko@kernel.org,dave.hansen@linux.intel.com,brouer@redhat.com,aaron.lu@intel.com,mgorman@techsingularity.net,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 098/227] mm/page_alloc: fetch the correct pcp buddy during bulk free
Message-Id: <20220322214330.9D78CC340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: fetch the correct pcp buddy during bulk free

Patch series "Follow-up on high-order PCP caching", v2.

Commit 44042b449872 ("mm/page_alloc: allow high-order pages to be stored
on the per-cpu lists") was primarily aimed at reducing the cost of SLUB
cache refills of high-order pages in two ways.  Firstly, zone lock
acquisitions was reduced and secondly, there were fewer buddy list
modifications.  This is a follow-up series fixing some issues that became
apparant after merging.

Patch 1 is a functional fix. It's harmless but inefficient.

Patches 2-5 reduce the overhead of bulk freeing of PCP pages.  While the
overhead is small, it's cumulative and noticable when truncating large
files.  The changelog for patch 4 includes results of a microbench that
deletes large sparse files with data in page cache.  Sparse files were
used to eliminate filesystem overhead.

Patch 6 addresses issues with high-order PCP pages being stored on PCP
lists for too long.  Pages freed on a CPU potentially may not be quickly
reused and in some cases this can increase cache miss rates.  Details are
included in the changelog.


This patch (of 6):

free_pcppages_bulk() prefetches buddies about to be freed but the order
must also be passed in as PCP lists store multiple orders.

Link: https://lkml.kernel.org/r/20220217002227.5739-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20220217002227.5739-2-mgorman@techsingularity.net
Fixes: 44042b449872 ("mm/page_alloc: allow high-order pages to be stored on the per-cpu lists")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fetch-the-correct-pcp-buddy-during-bulk-free
+++ a/mm/page_alloc.c
@@ -1429,10 +1429,10 @@ static bool bulkfree_pcp_prepare(struct
 }
 #endif /* CONFIG_DEBUG_VM */
 
-static inline void prefetch_buddy(struct page *page)
+static inline void prefetch_buddy(struct page *page, unsigned int order)
 {
 	unsigned long pfn = page_to_pfn(page);
-	unsigned long buddy_pfn = __find_buddy_pfn(pfn, 0);
+	unsigned long buddy_pfn = __find_buddy_pfn(pfn, order);
 	struct page *buddy = page + (buddy_pfn - pfn);
 
 	prefetch(buddy);
@@ -1509,7 +1509,7 @@ static void free_pcppages_bulk(struct zo
 			 * prefetch buddy for the first pcp->batch nr of pages.
 			 */
 			if (prefetch_nr) {
-				prefetch_buddy(page);
+				prefetch_buddy(page, order);
 				prefetch_nr--;
 			}
 		} while (count > 0 && --batch_free && !list_empty(list));
_
