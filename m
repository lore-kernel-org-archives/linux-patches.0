Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716AF63DA
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 12:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F59C433F1;
	Thu,  5 Jan 2023 12:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923404;
	bh=JpRoCOycaWZnoJoaIeuyi/UYW4SMCrZhAs7rTvx7/Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ka4L/A7YzwB5ugviM15u1av5f2yLWBLUWRROkoExpf5orcIwKK4h54ZrhK25Hnxon
	 CEtvYkHmTyCbAb6lpUzS4JHmgS4fCp6CY+zfY2UqmBhoXJ9FMGsaE91JsLzrURc+mj
	 fd8FtS80Ops/8Uduv6ZEWQ6oywgVYIw4x3RLiua8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Yang Shi <shy828301@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.9 001/251] mm/khugepaged: fix GUP-fast interaction by sending IPI
Date: Thu,  5 Jan 2023 13:52:18 +0100
Message-Id: <20230105125334.799380749@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jann Horn <jannh@google.com>

commit 2ba99c5e08812494bc57f319fb562f527d9bacd8 upstream.

Since commit 70cbc3cc78a99 ("mm: gup: fix the fast GUP race against THP
collapse"), the lockless_pages_from_mm() fastpath rechecks the pmd_t to
ensure that the page table was not removed by khugepaged in between.

However, lockless_pages_from_mm() still requires that the page table is
not concurrently freed.  Fix it by sending IPIs (if the architecture uses
semi-RCU-style page table freeing) before freeing/reusing page tables.

Link: https://lkml.kernel.org/r/20221129154730.2274278-2-jannh@google.com
Link: https://lkml.kernel.org/r/20221128180252.1684965-2-jannh@google.com
Link: https://lkml.kernel.org/r/20221125213714.4115729-2-jannh@google.com
Fixes: ba76149f47d8 ("thp: khugepaged")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[manual backport: two of the three places in khugepaged that can free
ptes were refactored into a common helper between 5.15 and 6.0;
TLB flushing was refactored between 5.4 and 5.10;
TLB flushing was refactored between 4.19 and 5.4;
pmd collapse for PTE-mapped THP was only added in 5.4;
ugly hack for s390 in <=4.19 and arm]
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/tlb.h |    6 ++++++
 mm/khugepaged.c           |   15 +++++++++++++++
 mm/memory.c               |    5 +++++
 3 files changed, 26 insertions(+)

--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -60,6 +60,12 @@ struct mmu_table_batch {
 extern void tlb_table_flush(struct mmu_gather *tlb);
 extern void tlb_remove_table(struct mmu_gather *tlb, void *table);
 
+void tlb_remove_table_sync_one(void);
+
+#else
+
+static inline void tlb_remove_table_sync_one(void) { }
+
 #endif
 
 /*
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -20,6 +20,19 @@
 #include <asm/pgalloc.h>
 #include "internal.h"
 
+/* gross hack for <=4.19 stable */
+#if defined(CONFIG_S390) || defined(CONFIG_ARM)
+static void tlb_remove_table_smp_sync(void *arg)
+{
+        /* Simply deliver the interrupt */
+}
+
+static void tlb_remove_table_sync_one(void)
+{
+        smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
+}
+#endif
+
 enum scan_result {
 	SCAN_FAIL,
 	SCAN_SUCCEED,
@@ -1044,6 +1057,7 @@ static void collapse_huge_page(struct mm
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+	tlb_remove_table_sync_one();
 
 	spin_lock(pte_ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte);
@@ -1293,6 +1307,7 @@ static void retract_page_tables(struct a
 				_pmd = pmdp_collapse_flush(vma, addr, pmd);
 				spin_unlock(ptl);
 				atomic_long_dec(&mm->nr_ptes);
+				tlb_remove_table_sync_one();
 				pte_free(mm, pmd_pgtable(_pmd));
 			}
 			up_write(&mm->mmap_sem);
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -349,6 +349,11 @@ static void tlb_remove_table_smp_sync(vo
 	/* Simply deliver the interrupt */
 }
 
+void tlb_remove_table_sync_one(void)
+{
+	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
+}
+
 static void tlb_remove_table_one(void *table)
 {
 	/*


