Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFF625A640;
	Mon,  1 Dec 2025 11:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588857; cv=none; b=TjwujSBDLzwpFxGiZBKu8LGjAVAux3oO0/PFbdnnxwgDrRzBtZItmTifJI+HO//iLkS1Rc4/4vXPIkSyeJ2Qk625zLGBmVASYsM3l4APwEf9DVq8J2YWWFgTQJSiTwOLwtb9MB6tFtb4c0OveaPO/YfWa54iBaWi3HsdJzTw7h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588857; c=relaxed/simple;
	bh=GeQvJ9vQO1qap6HY2VOiBIYzkoKHI323CdMoRVrAH70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q6uCIjytYqyyQeMnKyt3l4cZd4F9Ly9lkqyGDigUaXcrdIE7QN7LzlixZQkQZVftVr4vJ2S/A2IOjkEWWNxIE5MeeapS1G+3cfuYn9V9y/GZb4Vy8pYyWLCp1VQ/bY9LadFPV1QnXzdkWa/MsfWqMsZWlSFk+gSzhLPPFRkNieI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcgQKcfJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcgQKcfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EAAC113D0;
	Mon,  1 Dec 2025 11:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588857;
	bh=GeQvJ9vQO1qap6HY2VOiBIYzkoKHI323CdMoRVrAH70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UcgQKcfJTOtpkVbq9Hp7+gNs2deKgtKfGCHZ6QZQrn/7DGIzrfAshKY+mdzIYw63e
	 c7cIiFUBCAPJJpfY84eFKtBblF1QJzL7QOLIThNolYlMQcuos53uI/WmRsaOOwriMv
	 Fe4vVwZ3jCmax5J9OOCzFZrwFb3iSoQjrbAvN1UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Alistair Popple <apopple@nvidia.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Christoph Hellwig <hch@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Pavel Tatashin <pasha.tatashin@soleen.com>,
	Peter Xu <peterx@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	SeongJae Park <sj@kernel.org>,
	Song Liu <song@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Will Deacon <will@kernel.org>,
	Yang Shi <shy828301@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Zack Rusin <zackr@vmware.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 187/187] mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()
Date: Mon,  1 Dec 2025 12:24:55 +0100
Message-ID: <20251201112247.969043480@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 670ddd8cdcbd1d07a4571266ae3517f821728c3a upstream.

change_pmd_range() had special pmd_none_or_clear_bad_unless_trans_huge(),
required to avoid "bad" choices when setting automatic NUMA hinting under
mmap_read_lock(); but most of that is already covered in pte_offset_map()
now.  change_pmd_range() just wants a pmd_none() check before wasting time
on MMU notifiers, then checks on the read-once _pmd value to work out
what's needed for huge cases.  If change_pte_range() returns -EAGAIN to
retry if pte_offset_map_lock() fails, nothing more special is needed.

Link: https://lkml.kernel.org/r/725a42a9-91e9-c868-925-e3a5fd40bb4f@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zack Rusin <zackr@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Background:

    It was reported that a bad pmd is seen when automatic NUMA balancing
    is marking page table entries as prot_numa:

      [2437548.196018] mm/pgtable-generic.c:50: bad pmd 00000000af22fc02(dffffffe71fbfe02)
      [2437548.235022] Call Trace:
      [2437548.238234]  <TASK>
      [2437548.241060]  dump_stack_lvl+0x46/0x61
      [2437548.245689]  panic+0x106/0x2e5
      [2437548.249497]  pmd_clear_bad+0x3c/0x3c
      [2437548.253967]  change_pmd_range.isra.0+0x34d/0x3a7
      [2437548.259537]  change_p4d_range+0x156/0x20e
      [2437548.264392]  change_protection_range+0x116/0x1a9
      [2437548.269976]  change_prot_numa+0x15/0x37
      [2437548.274774]  task_numa_work+0x1b8/0x302
      [2437548.279512]  task_work_run+0x62/0x95
      [2437548.283882]  exit_to_user_mode_loop+0x1a4/0x1a9
      [2437548.289277]  exit_to_user_mode_prepare+0xf4/0xfc
      [2437548.294751]  ? sysvec_apic_timer_interrupt+0x34/0x81
      [2437548.300677]  irqentry_exit_to_user_mode+0x5/0x25
      [2437548.306153]  asm_sysvec_apic_timer_interrupt+0x16/0x1b

    This is due to a race condition between change_prot_numa() and
    THP migration because the kernel doesn't check is_swap_pmd() and
    pmd_trans_huge() atomically:

    change_prot_numa()                      THP migration
    ======================================================================
    - change_pmd_range()
    -> is_swap_pmd() returns false,
    meaning it's not a PMD migration
    entry.
                                      - do_huge_pmd_numa_page()
                                      -> migrate_misplaced_page() sets
                                         migration entries for the THP.
    - change_pmd_range()
    -> pmd_none_or_clear_bad_unless_trans_huge()
    -> pmd_none() and pmd_trans_huge() returns false
    - pmd_none_or_clear_bad_unless_trans_huge()
    -> pmd_bad() returns true for the migration entry!

  The upstream commit 670ddd8cdcbd ("mm/mprotect: delete
  pmd_none_or_clear_bad_unless_trans_huge()") closes this race condition
  by checking is_swap_pmd() and pmd_trans_huge() atomically.

  Backporting note:
    Unlike mainline, pte_offset_map_lock() does not check if the pmd
    entry is a migration entry or a hugepage; acquires PTL unconditionally
    instead of returning failure. Therefore, it is necessary to keep the
    !is_swap_pmd() && !pmd_trans_huge() && !pmd_devmap() check before
    acquiring the PTL.

    After acquiring it, open-code the mainline semantics of
    pte_offset_map_lock() so that change_pte_range() fails if the pmd value
    has changed (under the PTL). This requires adding one more parameter
    (for passing pmd value that is read before calling the function) to
    change_pte_range(). ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mprotect.c |  100 ++++++++++++++++++++++++----------------------------------
 1 file changed, 42 insertions(+), 58 deletions(-)

--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -36,29 +36,24 @@
 #include "internal.h"
 
 static long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long addr, unsigned long end, pgprot_t newprot,
-		int dirty_accountable, int prot_numa)
+		pmd_t pmd_old, unsigned long addr, unsigned long end,
+		pgprot_t newprot, int dirty_accountable, int prot_numa)
 {
 	pte_t *pte, oldpte;
+	pmd_t pmd_val;
 	spinlock_t *ptl;
 	long pages = 0;
 	int target_node = NUMA_NO_NODE;
 
-	/*
-	 * Can be called with only the mmap_sem for reading by
-	 * prot_numa so we must check the pmd isn't constantly
-	 * changing from under us from pmd_none to pmd_trans_huge
-	 * and/or the other way around.
-	 */
-	if (pmd_trans_unstable(pmd))
-		return 0;
-
-	/*
-	 * The pmd points to a regular pte so the pmd can't change
-	 * from under us even if the mmap_sem is only hold for
-	 * reading.
-	 */
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	/* Make sure pmd didn't change after acquiring ptl */
+	pmd_val = pmd_read_atomic(pmd);
+	/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
+	barrier();
+	if (!pmd_same(pmd_old, pmd_val)) {
+		pte_unmap_unlock(pte, ptl);
+		return -EAGAIN;
+	}
 
 	/* Get target node for single threaded private VMAs */
 	if (prot_numa && !(vma->vm_flags & VM_SHARED) &&
@@ -161,31 +156,6 @@ static long change_pte_range(struct vm_a
 	return pages;
 }
 
-/*
- * Used when setting automatic NUMA hinting protection where it is
- * critical that a numa hinting PMD is not confused with a bad PMD.
- */
-static inline int pmd_none_or_clear_bad_unless_trans_huge(pmd_t *pmd)
-{
-	pmd_t pmdval = pmd_read_atomic(pmd);
-
-	/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	barrier();
-#endif
-
-	if (pmd_none(pmdval))
-		return 1;
-	if (pmd_trans_huge(pmdval))
-		return 0;
-	if (unlikely(pmd_bad(pmdval))) {
-		pmd_clear_bad(pmd);
-		return 1;
-	}
-
-	return 0;
-}
-
 static inline long change_pmd_range(struct vm_area_struct *vma,
 		pud_t *pud, unsigned long addr, unsigned long end,
 		pgprot_t newprot, int dirty_accountable, int prot_numa)
@@ -200,21 +170,33 @@ static inline long change_pmd_range(stru
 
 	pmd = pmd_offset(pud, addr);
 	do {
-		long this_pages;
-
+		long ret;
+		pmd_t _pmd;
+again:
 		next = pmd_addr_end(addr, end);
+		_pmd = pmd_read_atomic(pmd);
+		/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		barrier();
+#endif
 
 		/*
 		 * Automatic NUMA balancing walks the tables with mmap_sem
 		 * held for read. It's possible a parallel update to occur
-		 * between pmd_trans_huge() and a pmd_none_or_clear_bad()
-		 * check leading to a false positive and clearing.
-		 * Hence, it's necessary to atomically read the PMD value
-		 * for all the checks.
+		 * between pmd_trans_huge(), is_swap_pmd(), and
+		 * a pmd_none_or_clear_bad() check leading to a false positive
+		 * and clearing. Hence, it's necessary to atomically read
+		 * the PMD value for all the checks.
 		 */
-		if (!is_swap_pmd(*pmd) && !pmd_devmap(*pmd) &&
-		     pmd_none_or_clear_bad_unless_trans_huge(pmd))
-			goto next;
+		if (!is_swap_pmd(_pmd) && !pmd_devmap(_pmd) && !pmd_trans_huge(_pmd)) {
+			if (pmd_none(_pmd))
+				goto next;
+
+			if (pmd_bad(_pmd)) {
+				pmd_clear_bad(pmd);
+				goto next;
+			}
+		}
 
 		/* invoke the mmu notifier if the pmd is populated */
 		if (!range.start) {
@@ -224,15 +206,15 @@ static inline long change_pmd_range(stru
 			mmu_notifier_invalidate_range_start(&range);
 		}
 
-		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
+		if (is_swap_pmd(_pmd) || pmd_trans_huge(_pmd) || pmd_devmap(_pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
 			} else {
-				int nr_ptes = change_huge_pmd(vma, pmd, addr,
-						newprot, prot_numa);
+				ret = change_huge_pmd(vma, pmd, addr, newprot,
+						      prot_numa);
 
-				if (nr_ptes) {
-					if (nr_ptes == HPAGE_PMD_NR) {
+				if (ret) {
+					if (ret == HPAGE_PMD_NR) {
 						pages += HPAGE_PMD_NR;
 						nr_huge_updates++;
 					}
@@ -243,9 +225,11 @@ static inline long change_pmd_range(stru
 			}
 			/* fall through, the trans huge pmd just split */
 		}
-		this_pages = change_pte_range(vma, pmd, addr, next, newprot,
-				 dirty_accountable, prot_numa);
-		pages += this_pages;
+		ret = change_pte_range(vma, pmd, _pmd, addr, next,
+				       newprot, dirty_accountable, prot_numa);
+		if (ret < 0)
+			goto again;
+		pages += ret;
 next:
 		cond_resched();
 	} while (pmd++, addr = next, addr != end);


