Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF6035DA41;
	Sat, 17 Oct 2026 18:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260212; cv=none; b=Lsq+XylqmTB7q2t0QcFkDIuqtxIye2B1e2skRZwcNqkorNB19PCR5Ab7nmmdw1KWtwxFiCL9oQLtLSSVN9AZjn8LFKMlgk9+z/FIBvEtm+yAMgp57yqaQuxAV4yA1MJlg7NpFPoo3fBKDUDJ14LwRCkRvEd7+LTWCoLQczKbLtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260212; c=relaxed/simple;
	bh=UQ+OWFLzlhgYfWY3akfZ0W2WUnvGTJTfLj1kuq8hEs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6q2fG22NErXt9iFNBnLD/7naZUAilymRL/gLu4Qsu8m0IewrW8OLD2jsYo/hTwwIoG4s3S41+S+p+ThEk1TeJPtjvpWORX4nbZMhBmzo3KJp261j453Jg1+pwEKCkOa9wYUCrg0LaaWL/PPnEu0PAYqFKIKLEHV8ncUegbOi14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss/X//i7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss/X//i7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6E51F000C5;
	Sat, 17 Oct 2026 18:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260211;
	bh=TeEFhzdqZluXvtdZbIPViFygvBtaQjRMBe4agj1z7IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ss/X//i77PcLxxcitSxBLVIckkZXcVGwbyJINNYTMZ4BpKG/wlLXEm1yQiGMB4zns
	 j8h7EXzrmUieIS0rRZsJBdoMxq32PI9YJcXptt39Q4B5jBfxvxqtRdqg0KnBk34+lq
	 LfmDoYKNleUpJEUSUjRwUjW7w3M/jTvGV8zvDpUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1453/1674] misc: sgi-gru: remove interrupt-context page-table walks
Date: Sat, 17 Oct 2026 18:02:05 +0200
Message-ID: <20261017160508.473358425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@arm.com>

[ Upstream commit 928a8e9f523df845fc496bcb9811013b67aabec5 ]

The GRU TLB miss handler walks a process's page tables without holding
page-table locks or a reference to the mapped page. It also uses a kernel
page-table accessor on user page tables and supports only PMD-level large
mappings on x86-64.

Remove the direct walker. Send interrupt faults directly to user polling
mode so the existing call-OS fallback retries them in process context.

Remove the mmap-lock failure statistic that can no longer be incremented.

Fixes: 142586409c8b ("GRU Driver: page faults & exceptions")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20260730111316.3672672-2-usama.anjum@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/sgi-gru/grufault.c  | 101 ++++---------------------------
 drivers/misc/sgi-gru/gruprocfs.c |   1 -
 drivers/misc/sgi-gru/grutables.h |   1 -
 3 files changed, 12 insertions(+), 91 deletions(-)

diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
index 3557d78ee47a2..5a87c12f444a3 100644
--- a/drivers/misc/sgi-gru/grufault.c
+++ b/drivers/misc/sgi-gru/grufault.c
@@ -166,13 +166,8 @@ static void get_clear_fault_map(struct gru_state *gru,
 }
 
 /*
- * Atomic (interrupt context) & non-atomic (user context) functions to
- * convert a vaddr into a physical address. The size of the page
- * is returned in pageshift.
- * 	returns:
- * 		  0 - successful
- * 		< 0 - error code
- * 		  1 - (atomic only) try again in non-atomic context
+ * Convert a user virtual address to a physical address in process context.
+ * The size of the page is returned in pageshift.
  */
 static int non_atomic_pte_lookup(struct vm_area_struct *vma,
 				 unsigned long vaddr, int write,
@@ -192,87 +187,25 @@ static int non_atomic_pte_lookup(struct vm_area_struct *vma,
 	return 0;
 }
 
-/*
- * atomic_pte_lookup
- *
- * Convert a user virtual address to a physical address
- * Only supports Intel large pages (2MB only) on x86_64.
- *	ZZZ - hugepage support is incomplete
- *
- * NOTE: mmap_lock is already held on entry to this function. This
- * guarantees existence of the page tables.
- */
-static int atomic_pte_lookup(struct vm_area_struct *vma, unsigned long vaddr,
-	int write, unsigned long *paddr, int *pageshift)
-{
-	pgd_t *pgdp;
-	p4d_t *p4dp;
-	pud_t *pudp;
-	pmd_t *pmdp;
-	pte_t pte;
-
-	pgdp = pgd_offset(vma->vm_mm, vaddr);
-	if (unlikely(pgd_none(*pgdp)))
-		goto err;
-
-	p4dp = p4d_offset(pgdp, vaddr);
-	if (unlikely(p4d_none(*p4dp)))
-		goto err;
-
-	pudp = pud_offset(p4dp, vaddr);
-	if (unlikely(pud_none(*pudp)))
-		goto err;
-
-	pmdp = pmd_offset(pudp, vaddr);
-	if (unlikely(pmd_none(*pmdp)))
-		goto err;
-#ifdef CONFIG_X86_64
-	if (unlikely(pmd_leaf(*pmdp)))
-		pte = ptep_get((pte_t *)pmdp);
-	else
-#endif
-		pte = *pte_offset_kernel(pmdp, vaddr);
-
-	if (unlikely(!pte_present(pte) ||
-		     (write && (!pte_write(pte) || !pte_dirty(pte)))))
-		return 1;
-
-	*paddr = pte_pfn(pte) << PAGE_SHIFT;
-#ifdef CONFIG_HUGETLB_PAGE
-	*pageshift = is_vm_hugetlb_page(vma) ? HPAGE_SHIFT : PAGE_SHIFT;
-#else
-	*pageshift = PAGE_SHIFT;
-#endif
-	return 0;
-
-err:
-	return 1;
-}
-
 static int gru_vtop(struct gru_thread_state *gts, unsigned long vaddr,
 		    int write, int atomic, unsigned long *gpa, int *pageshift)
 {
 	struct mm_struct *mm = gts->ts_mm;
 	struct vm_area_struct *vma;
 	unsigned long paddr;
-	int ret, ps;
+	int ps;
 
 	vma = find_vma(mm, vaddr);
 	if (!vma)
 		goto inval;
 
-	/*
-	 * Atomic lookup is faster & usually works even if called in non-atomic
-	 * context.
-	 */
-	rmb();	/* Must/check ms_range_active before loading PTEs */
-	ret = atomic_pte_lookup(vma, vaddr, write, &paddr, &ps);
-	if (ret) {
-		if (atomic)
-			goto upm;
-		if (non_atomic_pte_lookup(vma, vaddr, write, &paddr, &ps))
-			goto inval;
-	}
+	if (atomic)
+		goto upm;
+
+	/* Order the caller's ms_range_active check before loading PTEs. */
+	rmb();
+	if (non_atomic_pte_lookup(vma, vaddr, write, &paddr, &ps))
+		goto inval;
 	if (is_gru_paddr(paddr))
 		goto inval;
 	paddr = paddr & ~((1UL << ps) - 1);
@@ -569,19 +502,9 @@ static irqreturn_t gru_intr(int chiplet, int blade)
 			continue;
 		}
 
-		/*
-		 * This is running in interrupt context. Trylock the mmap_lock.
-		 * If it fails, retry the fault in user context.
-		 */
+		/* Address translation may sleep, so retry the fault in user context. */
 		gts->ustats.fmm_tlbmiss++;
-		if (!gts->ts_force_cch_reload &&
-					mmap_read_trylock(gts->ts_mm)) {
-			gru_try_dropin(gru, gts, tfh, NULL);
-			mmap_read_unlock(gts->ts_mm);
-		} else {
-			tfh_user_polling_mode(tfh);
-			STAT(intr_mm_lock_failed);
-		}
+		tfh_user_polling_mode(tfh);
 	}
 	return IRQ_HANDLED;
 }
diff --git a/drivers/misc/sgi-gru/gruprocfs.c b/drivers/misc/sgi-gru/gruprocfs.c
index 97b8b38ab47df..b8139c27bc7f8 100644
--- a/drivers/misc/sgi-gru/gruprocfs.c
+++ b/drivers/misc/sgi-gru/gruprocfs.c
@@ -54,7 +54,6 @@ static int statistics_show(struct seq_file *s, void *p)
 	printstat(s, intr_cbr);
 	printstat(s, intr_tfh);
 	printstat(s, intr_spurious);
-	printstat(s, intr_mm_lock_failed);
 	printstat(s, call_os);
 	printstat(s, call_os_wait_queue);
 	printstat(s, user_flush_tlb);
diff --git a/drivers/misc/sgi-gru/grutables.h b/drivers/misc/sgi-gru/grutables.h
index 640daf1994df7..3348552925c61 100644
--- a/drivers/misc/sgi-gru/grutables.h
+++ b/drivers/misc/sgi-gru/grutables.h
@@ -182,7 +182,6 @@ struct gru_stats_s {
 	atomic_long_t intr_cbr;
 	atomic_long_t intr_tfh;
 	atomic_long_t intr_spurious;
-	atomic_long_t intr_mm_lock_failed;
 	atomic_long_t call_os;
 	atomic_long_t call_os_wait_queue;
 	atomic_long_t user_flush_tlb;
-- 
2.53.0



