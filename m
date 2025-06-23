Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C80223DF0;
	Mon, 23 Jun 2025 21:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715795; cv=none; b=Hfm/EAgWLauI80VVgOVDyoebWBNPHsxNM5cpKjwYD4zNTBjrbtOdnVXv74m+Qgj1YVYNT1WWs/CqQQ5xyAzWkZQ5g+209pLlRnN4bBL/uSPvWiJHBccqKEu726U5cbQbf4cP0mvuGyF5TEvlS31eyFX3YPdGzRmNYexi+FJuODs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715795; c=relaxed/simple;
	bh=YrWCt8B1kBGAjsHMD7jMBVKhnYx7LhxD2VKT5HaG2pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAaR787LtUbRxTnZOWUila4GugBTo90qYsDW7h1Qtozfbv6++FHEAOJWy2ikTkuso8ze194L1ZRBlLmnUGEBz24vf1Ia3FCLUeThu8hCPjLuzTylF+rkFdIS/AWbVzHnKRpd+zQhJdjL9Z00l80Fi9MEsK0P0k7fb+vVuGanuWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RX/KtF/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RX/KtF/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B717FC4CEEA;
	Mon, 23 Jun 2025 21:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715795;
	bh=YrWCt8B1kBGAjsHMD7jMBVKhnYx7LhxD2VKT5HaG2pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RX/KtF/auNLMUIep2+64xfWG3mZj4O4vHhwwKi8XWcqxkBCCHqnXMgyhM2+T6Y7LJ
	 6Vpo8ZsBac6GvOqCwV/pSHfPrDTlkzaUjrVWz4w4sjSU+3e5GNW9+ApLj0js6oxzxY
	 Xp7zXaKHPI78ADOxrorgnScQqiotneOJKpNZpgio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Houghton <jthoughton@google.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Peter Xu <peterx@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 5.10 297/355] hugetlb: unshare some PMDs when splitting VMAs
Date: Mon, 23 Jun 2025 15:08:18 +0200
Message-ID: <20250623130635.705074833@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Houghton <jthoughton@google.com>

commit b30c14cd61025eeea2f2e8569606cd167ba9ad2d upstream.

PMD sharing can only be done in PUD_SIZE-aligned pieces of VMAs; however,
it is possible that HugeTLB VMAs are split without unsharing the PMDs
first.

Without this fix, it is possible to hit the uffd-wp-related WARN_ON_ONCE
in hugetlb_change_protection [1].  The key there is that
hugetlb_unshare_all_pmds will not attempt to unshare PMDs in
non-PUD_SIZE-aligned sections of the VMA.

It might seem ideal to unshare in hugetlb_vm_op_open, but we need to
unshare in both the new and old VMAs, so unsharing in hugetlb_vm_op_split
seems natural.

[1]: https://lore.kernel.org/linux-mm/CADrL8HVeOkj0QH5VZZbRzybNE8CG-tEGFshnA+bG9nMgcWtBSg@mail.gmail.com/

Link: https://lkml.kernel.org/r/20230104231910.1464197-1-jthoughton@google.com
Fixes: 6dfeaff93be1 ("hugetlb/userfaultfd: unshare all pmds for hugetlbfs when register wp")
Signed-off-by: James Houghton <jthoughton@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[backport notes: I believe the "Fixes" tag is somewhat wrong - kernels
before that commit already had an adjust_range_if_pmd_sharing_possible()
that assumes that shared PMDs can't straddle page table boundaries.
huge_pmd_unshare() takes different parameter type]
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -96,6 +96,8 @@ static inline void ClearPageHugeFreed(st
 
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
+static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
+		unsigned long start, unsigned long end);
 
 static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
 {
@@ -3697,6 +3699,25 @@ static int hugetlb_vm_op_split(struct vm
 {
 	if (addr & ~(huge_page_mask(hstate_vma(vma))))
 		return -EINVAL;
+
+	/*
+	 * PMD sharing is only possible for PUD_SIZE-aligned address ranges
+	 * in HugeTLB VMAs. If we will lose PUD_SIZE alignment due to this
+	 * split, unshare PMDs in the PUD_SIZE interval surrounding addr now.
+	 */
+	if (addr & ~PUD_MASK) {
+		/*
+		 * hugetlb_vm_op_split is called right before we attempt to
+		 * split the VMA. We will need to unshare PMDs in the old and
+		 * new VMAs, so let's unshare before we split.
+		 */
+		unsigned long floor = addr & PUD_MASK;
+		unsigned long ceil = floor + PUD_SIZE;
+
+		if (floor >= vma->vm_start && ceil <= vma->vm_end)
+			hugetlb_unshare_pmds(vma, floor, ceil);
+	}
+
 	return 0;
 }
 
@@ -5706,6 +5727,50 @@ void move_hugetlb_state(struct page *old
 	}
 }
 
+static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
+				   unsigned long start,
+				   unsigned long end)
+{
+	struct hstate *h = hstate_vma(vma);
+	unsigned long sz = huge_page_size(h);
+	struct mm_struct *mm = vma->vm_mm;
+	struct mmu_notifier_range range;
+	unsigned long address;
+	spinlock_t *ptl;
+	pte_t *ptep;
+
+	if (!(vma->vm_flags & VM_MAYSHARE))
+		return;
+
+	if (start >= end)
+		return;
+
+	flush_cache_range(vma, start, end);
+	/*
+	 * No need to call adjust_range_if_pmd_sharing_possible(), because
+	 * we have already done the PUD_SIZE alignment.
+	 */
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, mm,
+				start, end);
+	mmu_notifier_invalidate_range_start(&range);
+	i_mmap_lock_write(vma->vm_file->f_mapping);
+	for (address = start; address < end; address += PUD_SIZE) {
+		ptep = huge_pte_offset(mm, address, sz);
+		if (!ptep)
+			continue;
+		ptl = huge_pte_lock(h, mm, ptep);
+		huge_pmd_unshare(mm, vma, &address, ptep);
+		spin_unlock(ptl);
+	}
+	flush_hugetlb_tlb_range(vma, start, end);
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
+	/*
+	 * No need to call mmu_notifier_invalidate_range(), see
+	 * Documentation/mm/mmu_notifier.rst.
+	 */
+	mmu_notifier_invalidate_range_end(&range);
+}
+
 #ifdef CONFIG_CMA
 static bool cma_reserve_called __initdata;
 


