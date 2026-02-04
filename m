Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B137C22E3F0;
	Wed,  4 Feb 2026 15:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218251; cv=none; b=u6AvbgF2P9XoCCLU8DUMrWit8QGd2BcCa8opezUxQgevD5xD8gxSeJbPZUgb7dNlz36oIgbWrlQ7nS4jzaiHU9iBfUpp/XkaZRTfhjccI7RXPk/HDAWMTrGlGrXKXn4gKeRaL6GWJOcALPJiZRHHxaSkv7iX6cZ38APrHyrB2Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218251; c=relaxed/simple;
	bh=chFRESFH5kfA+VJwIGMwNdh6G8RM4zcp159MemJAkYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4aTCBgLe8xoEPGE/ksuoZk7Gcq7h6Fh6l1NixGc3zlH4cCj1CoCr1rbBGUM+pEOggSGdm2wcvJckS9+0L3ywt5rZ0Afeh22rmUl/Q4hGoFWjNEzQvJweaAtfJ1XV4B61Ke57mzyskYH6ufkFwxJuxxP7zlHeat/KodKbd94XGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXbz0g/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXbz0g/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C222AC4CEF7;
	Wed,  4 Feb 2026 15:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218251;
	bh=chFRESFH5kfA+VJwIGMwNdh6G8RM4zcp159MemJAkYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXbz0g/waMZqy6Q3h+O+97WAUInP9XunnJil1KPPWuin65d7MPSVCpqcBIYft0CAR
	 QlWahPBf0xC/EZswGH6kneb4RPu8HdcJt00KUTGZhza7rBhtLYvd9KdW+aIVAMEjNJ
	 txT971A4qgqREkGqT+B23UlVW/OqwIR9rUyvwcAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, hughd@google.com, jannh@google.com, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, pfalcato@suse.de, vbabka@suse.cz, Harry Yoo" <harry.yoo@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH 6.1 256/280] Revert "mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()"
Date: Wed,  4 Feb 2026 15:40:30 +0100
Message-ID: <20260204143918.906487854@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Yoo <harry.yoo@oracle.com>

This reverts commit 91750c8a4be42d73b6810a1c35d73c8a3cd0b481 which is
commit 670ddd8cdcbd1d07a4571266ae3517f821728c3a upstream.

While the commit fixes a race condition between NUMA balancing and THP
migration, it causes a NULL-pointer-deref when the pmd temporarily
transitions from pmd_trans_huge() to pmd_none(). Verifying whether the
pmd value has changed under page table lock does not prevent the crash,
as it occurs when acquiring the lock.

Since the original issue addressed by the commit is quite rare and
non-fatal, revert the commit. A better backport solution that more
closely matches the upstream semantics will be provided as a follow-up.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mprotect.c |  101 +++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 58 insertions(+), 43 deletions(-)

--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -73,12 +73,10 @@ static inline bool can_change_pte_writab
 }
 
 static long change_pte_range(struct mmu_gather *tlb,
-		struct vm_area_struct *vma, pmd_t *pmd, pmd_t pmd_old,
-		unsigned long addr, unsigned long end, pgprot_t newprot,
-		unsigned long cp_flags)
+		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
+		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
 	pte_t *pte, oldpte;
-	pmd_t _pmd;
 	spinlock_t *ptl;
 	long pages = 0;
 	int target_node = NUMA_NO_NODE;
@@ -88,15 +86,21 @@ static long change_pte_range(struct mmu_
 
 	tlb_change_page_size(tlb, PAGE_SIZE);
 
+	/*
+	 * Can be called with only the mmap_lock for reading by
+	 * prot_numa so we must check the pmd isn't constantly
+	 * changing from under us from pmd_none to pmd_trans_huge
+	 * and/or the other way around.
+	 */
+	if (pmd_trans_unstable(pmd))
+		return 0;
+
+	/*
+	 * The pmd points to a regular pte so the pmd can't change
+	 * from under us even if the mmap_lock is only hold for
+	 * reading.
+	 */
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	/* Make sure pmd didn't change after acquiring ptl */
-	_pmd = pmd_read_atomic(pmd);
-	/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
-	barrier();
-	if (!pmd_same(pmd_old, _pmd)) {
-		pte_unmap_unlock(pte, ptl);
-		return -EAGAIN;
-	}
 
 	/* Get target node for single threaded private VMAs */
 	if (prot_numa && !(vma->vm_flags & VM_SHARED) &&
@@ -284,6 +288,31 @@ static long change_pte_range(struct mmu_
 	return pages;
 }
 
+/*
+ * Used when setting automatic NUMA hinting protection where it is
+ * critical that a numa hinting PMD is not confused with a bad PMD.
+ */
+static inline int pmd_none_or_clear_bad_unless_trans_huge(pmd_t *pmd)
+{
+	pmd_t pmdval = pmd_read_atomic(pmd);
+
+	/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	barrier();
+#endif
+
+	if (pmd_none(pmdval))
+		return 1;
+	if (pmd_trans_huge(pmdval))
+		return 0;
+	if (unlikely(pmd_bad(pmdval))) {
+		pmd_clear_bad(pmd);
+		return 1;
+	}
+
+	return 0;
+}
+
 /* Return true if we're uffd wr-protecting file-backed memory, or false */
 static inline bool
 uffd_wp_protect_file(struct vm_area_struct *vma, unsigned long cp_flags)
@@ -331,34 +360,22 @@ static inline long change_pmd_range(stru
 
 	pmd = pmd_offset(pud, addr);
 	do {
-		long ret;
-		pmd_t _pmd;
-again:
+		long this_pages;
+
 		next = pmd_addr_end(addr, end);
-		_pmd = pmd_read_atomic(pmd);
-		/* See pmd_none_or_trans_huge_or_clear_bad for info on barrier */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		barrier();
-#endif
 
 		change_pmd_prepare(vma, pmd, cp_flags);
 		/*
 		 * Automatic NUMA balancing walks the tables with mmap_lock
 		 * held for read. It's possible a parallel update to occur
-		 * between pmd_trans_huge(), is_swap_pmd(), and
-		 * a pmd_none_or_clear_bad() check leading to a false positive
-		 * and clearing. Hence, it's necessary to atomically read
-		 * the PMD value for all the checks.
+		 * between pmd_trans_huge() and a pmd_none_or_clear_bad()
+		 * check leading to a false positive and clearing.
+		 * Hence, it's necessary to atomically read the PMD value
+		 * for all the checks.
 		 */
-		if (!is_swap_pmd(_pmd) && !pmd_devmap(_pmd) && !pmd_trans_huge(_pmd)) {
-			if (pmd_none(_pmd))
-				goto next;
-
-			if (pmd_bad(_pmd)) {
-				pmd_clear_bad(pmd);
-				goto next;
-			}
-		}
+		if (!is_swap_pmd(*pmd) && !pmd_devmap(*pmd) &&
+		     pmd_none_or_clear_bad_unless_trans_huge(pmd))
+			goto next;
 
 		/* invoke the mmu notifier if the pmd is populated */
 		if (!range.start) {
@@ -368,7 +385,7 @@ again:
 			mmu_notifier_invalidate_range_start(&range);
 		}
 
-		if (is_swap_pmd(_pmd) || pmd_trans_huge(_pmd) || pmd_devmap(_pmd)) {
+		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
 			if ((next - addr != HPAGE_PMD_SIZE) ||
 			    uffd_wp_protect_file(vma, cp_flags)) {
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
@@ -383,11 +400,11 @@ again:
 				 * change_huge_pmd() does not defer TLB flushes,
 				 * so no need to propagate the tlb argument.
 				 */
-				ret = change_huge_pmd(tlb, vma, pmd,
-						      addr, newprot, cp_flags);
+				int nr_ptes = change_huge_pmd(tlb, vma, pmd,
+						addr, newprot, cp_flags);
 
-				if (ret) {
-					if (ret == HPAGE_PMD_NR) {
+				if (nr_ptes) {
+					if (nr_ptes == HPAGE_PMD_NR) {
 						pages += HPAGE_PMD_NR;
 						nr_huge_updates++;
 					}
@@ -398,11 +415,9 @@ again:
 			}
 			/* fall through, the trans huge pmd just split */
 		}
-		ret = change_pte_range(tlb, vma, pmd, _pmd, addr, next,
-				       newprot, cp_flags);
-		if (ret < 0)
-			goto again;
-		pages += ret;
+		this_pages = change_pte_range(tlb, vma, pmd, addr, next,
+					      newprot, cp_flags);
+		pages += this_pages;
 next:
 		cond_resched();
 	} while (pmd++, addr = next, addr != end);


