Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AD04409;
	Mon, 23 Jun 2025 22:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716049; cv=none; b=BDdXnBxVamB2iIaeRiBeW0UKAvqvK1Oiij2BJK3kGOXQVbkbKGRZWd/O50qhZ4pJmPar+WRvgMcZRt1AxkLfPRDRlfLWGUU9NX3ATRDixwNxIgIoPQLHZDOV6Hzg7tQmjQqBLmoaZwyK9EaCf31Z3iY/bwmg6TbfBmBfJU6BKvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716049; c=relaxed/simple;
	bh=tIkt8YcSfNciI7IX6IjLqdTBQvgh+iKbW/2xWBBQcXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYsc0fbnrtpb42nLW7CqYr40Q3F0t2UXpV00UeBDZ6yl3dZJ18umw23UvsjYQOIzMPwscomfttT/CLrzzCdt4Sj57X4o9s6mNe6Pk3pyj7VjENA/rsCcd7K9/E1njnAlEVCFjuZ21kWvjyPQMbyeRBdos3hoOmSiEkC+JITLy1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLjSkGER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLjSkGER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F57DC4CEED;
	Mon, 23 Jun 2025 22:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716048;
	bh=tIkt8YcSfNciI7IX6IjLqdTBQvgh+iKbW/2xWBBQcXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLjSkGER0YkpvYQvZFd4+Tj6wvxjrwgpsMKGShEiXjZ93vaFe/4W10GuoYy5pgww0
	 kgKTShbtJeGT0Nd6QoPLZ2opwQzGFmQ9PNZ2RFHvXqUPditpreoFd9iyJnijIaeX22
	 CAILGChMJcfAcuL1CTuPsYNoFpW2LsDULtI3BsMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 237/290] mm/hugetlb: unshare page tables during VMA split, not before
Date: Mon, 23 Jun 2025 15:08:18 +0200
Message-ID: <20250623130634.052248304@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 081056dc00a27bccb55ccc3c6f230a3d5fd3f7e0 upstream.

Currently, __split_vma() triggers hugetlb page table unsharing through
vm_ops->may_split().  This happens before the VMA lock and rmap locks are
taken - which is too early, it allows racing VMA-locked page faults in our
process and racing rmap walks from other processes to cause page tables to
be shared again before we actually perform the split.

Fix it by explicitly calling into the hugetlb unshare logic from
__split_vma() in the same place where THP splitting also happens.  At that
point, both the VMA and the rmap(s) are write-locked.

An annoying detail is that we can now call into the helper
hugetlb_unshare_pmds() from two different locking contexts:

1. from hugetlb_split(), holding:
    - mmap lock (exclusively)
    - VMA lock
    - file rmap lock (exclusively)
2. hugetlb_unshare_all_pmds(), which I think is designed to be able to
   call us with only the mmap lock held (in shared mode), but currently
   only runs while holding mmap lock (exclusively) and VMA lock

Backporting note:
This commit fixes a racy protection that was introduced in commit
b30c14cd6102 ("hugetlb: unshare some PMDs when splitting VMAs"); that
commit claimed to fix an issue introduced in 5.13, but it should actually
also go all the way back.

[jannh@google.com: v2]
  Link: https://lkml.kernel.org/r/20250528-hugetlb-fixes-splitrace-v2-1-1329349bad1a@google.com
Link: https://lkml.kernel.org/r/20250528-hugetlb-fixes-splitrace-v2-0-1329349bad1a@google.com
Link: https://lkml.kernel.org/r/20250527-hugetlb-fixes-splitrace-v1-1-f4136f5ec58a@google.com
Fixes: 39dde65c9940 ("[PATCH] shared page table for hugetlb page")
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[b30c14cd6102: hugetlb: unshare some PMDs when splitting VMAs]
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[stable backport: code got moved from mmap.c to vma.c]
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    3 ++
 mm/hugetlb.c            |   60 +++++++++++++++++++++++++++++++++++-------------
 mm/mmap.c               |    6 ++++
 3 files changed, 53 insertions(+), 16 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -281,6 +281,7 @@ long hugetlb_change_protection(struct vm
 
 bool is_hugetlb_entry_migration(pte_t pte);
 void hugetlb_unshare_all_pmds(struct vm_area_struct *vma);
+void hugetlb_split(struct vm_area_struct *vma, unsigned long addr);
 
 #else /* !CONFIG_HUGETLB_PAGE */
 
@@ -491,6 +492,8 @@ static inline vm_fault_t hugetlb_fault(s
 
 static inline void hugetlb_unshare_all_pmds(struct vm_area_struct *vma) { }
 
+static inline void hugetlb_split(struct vm_area_struct *vma, unsigned long addr) {}
+
 #endif /* !CONFIG_HUGETLB_PAGE */
 /*
  * hugepages at page global directory. If arch support
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -96,7 +96,7 @@ static void hugetlb_vma_lock_free(struct
 static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
-		unsigned long start, unsigned long end);
+		unsigned long start, unsigned long end, bool take_locks);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
@@ -4903,26 +4903,40 @@ static int hugetlb_vm_op_split(struct vm
 {
 	if (addr & ~(huge_page_mask(hstate_vma(vma))))
 		return -EINVAL;
+	return 0;
+}
 
+void hugetlb_split(struct vm_area_struct *vma, unsigned long addr)
+{
 	/*
 	 * PMD sharing is only possible for PUD_SIZE-aligned address ranges
 	 * in HugeTLB VMAs. If we will lose PUD_SIZE alignment due to this
 	 * split, unshare PMDs in the PUD_SIZE interval surrounding addr now.
+	 * This function is called in the middle of a VMA split operation, with
+	 * MM, VMA and rmap all write-locked to prevent concurrent page table
+	 * walks (except hardware and gup_fast()).
 	 */
+	vma_assert_write_locked(vma);
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+
 	if (addr & ~PUD_MASK) {
-		/*
-		 * hugetlb_vm_op_split is called right before we attempt to
-		 * split the VMA. We will need to unshare PMDs in the old and
-		 * new VMAs, so let's unshare before we split.
-		 */
 		unsigned long floor = addr & PUD_MASK;
 		unsigned long ceil = floor + PUD_SIZE;
 
-		if (floor >= vma->vm_start && ceil <= vma->vm_end)
-			hugetlb_unshare_pmds(vma, floor, ceil);
+		if (floor >= vma->vm_start && ceil <= vma->vm_end) {
+			/*
+			 * Locking:
+			 * Use take_locks=false here.
+			 * The file rmap lock is already held.
+			 * The hugetlb VMA lock can't be taken when we already
+			 * hold the file rmap lock, and we don't need it because
+			 * its purpose is to synchronize against concurrent page
+			 * table walks, which are not possible thanks to the
+			 * locks held by our caller.
+			 */
+			hugetlb_unshare_pmds(vma, floor, ceil, /* take_locks = */ false);
+		}
 	}
-
-	return 0;
 }
 
 static unsigned long hugetlb_vm_op_pagesize(struct vm_area_struct *vma)
@@ -7305,9 +7319,16 @@ void move_hugetlb_state(struct folio *ol
 	}
 }
 
+/*
+ * If @take_locks is false, the caller must ensure that no concurrent page table
+ * access can happen (except for gup_fast() and hardware page walks).
+ * If @take_locks is true, we take the hugetlb VMA lock (to lock out things like
+ * concurrent page fault handling) and the file rmap lock.
+ */
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 				   unsigned long start,
-				   unsigned long end)
+				   unsigned long end,
+				   bool take_locks)
 {
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
@@ -7331,8 +7352,12 @@ static void hugetlb_unshare_pmds(struct
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
 				start, end);
 	mmu_notifier_invalidate_range_start(&range);
-	hugetlb_vma_lock_write(vma);
-	i_mmap_lock_write(vma->vm_file->f_mapping);
+	if (take_locks) {
+		hugetlb_vma_lock_write(vma);
+		i_mmap_lock_write(vma->vm_file->f_mapping);
+	} else {
+		i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+	}
 	for (address = start; address < end; address += PUD_SIZE) {
 		ptep = hugetlb_walk(vma, address, sz);
 		if (!ptep)
@@ -7342,8 +7367,10 @@ static void hugetlb_unshare_pmds(struct
 		spin_unlock(ptl);
 	}
 	flush_hugetlb_tlb_range(vma, start, end);
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
-	hugetlb_vma_unlock_write(vma);
+	if (take_locks) {
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+		hugetlb_vma_unlock_write(vma);
+	}
 	/*
 	 * No need to call mmu_notifier_arch_invalidate_secondary_tlbs(), see
 	 * Documentation/mm/mmu_notifier.rst.
@@ -7358,7 +7385,8 @@ static void hugetlb_unshare_pmds(struct
 void hugetlb_unshare_all_pmds(struct vm_area_struct *vma)
 {
 	hugetlb_unshare_pmds(vma, ALIGN(vma->vm_start, PUD_SIZE),
-			ALIGN_DOWN(vma->vm_end, PUD_SIZE));
+			ALIGN_DOWN(vma->vm_end, PUD_SIZE),
+			/* take_locks = */ true);
 }
 
 #ifdef CONFIG_CMA
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2402,7 +2402,13 @@ int __split_vma(struct vma_iterator *vmi
 	init_vma_prep(&vp, vma);
 	vp.insert = new;
 	vma_prepare(&vp);
+	/*
+	 * Get rid of huge pages and shared page tables straddling the split
+	 * boundary.
+	 */
 	vma_adjust_trans_huge(vma, vma->vm_start, addr, 0);
+	if (is_vm_hugetlb_page(vma))
+		hugetlb_split(vma, addr);
 
 	if (new_below) {
 		vma->vm_start = addr;


