Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9671EF38C;
	Wed, 19 Mar 2025 14:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395149; cv=none; b=u2RgGmls50xyU4w5mzxwP2ukl1r4143C3L2xBC4g2+whmd1EJ/OdW8exx0ucSfaOM2jbAYErrFKMSrnsOeQ2jdnQRS6HWUTC+on4qTn5pHmhyrk7oipo7CR3v6yWrfF9qUj/VJ9jEdE24mst0NnRF8xpbJWoNIVLkTnnPzouR6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395149; c=relaxed/simple;
	bh=TZghvX4NJFCEi3dhYhBsAq6he0WcIq0NRaEcgerOo+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4fvwD1itmzJkza5Fp4B1MVK73qYFWhqFCJov5mhkHeH0woCmAopdWjBo9483mTeIve9bE5co/dwkQpNqAjjsQVtMOMn+no2W7tI4+Xrs2cQzdNRIBUCN6rUBIJVsxobZi7+pMasvw76Wx1nK3JkMx2Pr+jcU7+rmpjrxlySDGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydHBeJsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydHBeJsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FCEC4CEE4;
	Wed, 19 Mar 2025 14:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395149;
	bh=TZghvX4NJFCEi3dhYhBsAq6he0WcIq0NRaEcgerOo+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ydHBeJsCO/jCOmDRngDmsthsS4UaHW648EakwK7X4fe2KBWpzDWN6inH5S+jJxYEd
	 mQEG5FyPbprLYeWO/TtBgPAzsYjXadwTH7ucuy+h5wSSPM3ifeMRW50wD0TDz0/CGA
	 +4I69DSlVCsgNff0oPjdvqC7z61FsNg1yGlMOiSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ge Yang <yangge1116@126.com>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <21cnbao@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 223/231] mm/hugetlb: wait for hugetlb folios to be freed
Date: Wed, 19 Mar 2025 07:31:56 -0700
Message-ID: <20250319143032.346103891@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ge Yang <yangge1116@126.com>

[ Upstream commit 67bab13307c83fb742c2556b06cdc39dbad27f07 ]

Since the introduction of commit c77c0a8ac4c52 ("mm/hugetlb: defer freeing
of huge pages if in non-task context"), which supports deferring the
freeing of hugetlb pages, the allocation of contiguous memory through
cma_alloc() may fail probabilistically.

In the CMA allocation process, if it is found that the CMA area is
occupied by in-use hugetlb folios, these in-use hugetlb folios need to be
migrated to another location.  When there are no available hugetlb folios
in the free hugetlb pool during the migration of in-use hugetlb folios,
new folios are allocated from the buddy system.  A temporary state is set
on the newly allocated folio.  Upon completion of the hugetlb folio
migration, the temporary state is transferred from the new folios to the
old folios.  Normally, when the old folios with the temporary state are
freed, it is directly released back to the buddy system.  However, due to
the deferred freeing of hugetlb pages, the PageBuddy() check fails,
ultimately leading to the failure of cma_alloc().

Here is a simplified call trace illustrating the process:
cma_alloc()
    ->__alloc_contig_migrate_range() // Migrate in-use hugetlb folios
        ->unmap_and_move_huge_page()
            ->folio_putback_hugetlb() // Free old folios
    ->test_pages_isolated()
        ->__test_page_isolated_in_pageblock()
             ->PageBuddy(page) // Check if the page is in buddy

To resolve this issue, we have implemented a function named
wait_for_freed_hugetlb_folios().  This function ensures that the hugetlb
folios are properly released back to the buddy system after their
migration is completed.  By invoking wait_for_freed_hugetlb_folios()
before calling PageBuddy(), we ensure that PageBuddy() will succeed.

Link: https://lkml.kernel.org/r/1739936804-18199-1-git-send-email-yangge1116@126.com
Fixes: c77c0a8ac4c5 ("mm/hugetlb: defer freeing of huge pages if in non-task context")
Signed-off-by: Ge Yang <yangge1116@126.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb.h |  5 +++++
 mm/hugetlb.c            |  8 ++++++++
 mm/page_isolation.c     | 10 ++++++++++
 3 files changed, 23 insertions(+)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 25a7b13574c28..12f7a7b9c06e9 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -687,6 +687,7 @@ struct huge_bootmem_page {
 };
 
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
+void wait_for_freed_hugetlb_folios(void);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
@@ -1057,6 +1058,10 @@ static inline int isolate_or_dissolve_huge_page(struct page *page,
 	return -ENOMEM;
 }
 
+static inline void wait_for_freed_hugetlb_folios(void)
+{
+}
+
 static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 					   unsigned long addr,
 					   int avoid_reserve)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1e9aa6de4e21e..e28e820fdb775 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2955,6 +2955,14 @@ int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list)
 	return ret;
 }
 
+void wait_for_freed_hugetlb_folios(void)
+{
+	if (llist_empty(&hpage_freelist))
+		return;
+
+	flush_work(&free_hpage_work);
+}
+
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				    unsigned long addr, int avoid_reserve)
 {
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 7e04047977cfe..6989c5ffd4741 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -611,6 +611,16 @@ int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
 	struct zone *zone;
 	int ret;
 
+	/*
+	 * Due to the deferred freeing of hugetlb folios, the hugepage folios may
+	 * not immediately release to the buddy system. This can cause PageBuddy()
+	 * to fail in __test_page_isolated_in_pageblock(). To ensure that the
+	 * hugetlb folios are properly released back to the buddy system, we
+	 * invoke the wait_for_freed_hugetlb_folios() function to wait for the
+	 * release to complete.
+	 */
+	wait_for_freed_hugetlb_folios();
+
 	/*
 	 * Note: pageblock_nr_pages != MAX_PAGE_ORDER. Then, chunks of free
 	 * pages are not aligned to pageblock_nr_pages.
-- 
2.39.5



