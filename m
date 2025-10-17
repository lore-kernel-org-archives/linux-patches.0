Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA8D332901;
	Fri, 17 Oct 2025 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715264; cv=none; b=G1bpYXklY2iqhIIydAeGFeMToQ1Wcda3E8Pxf7C+O12l6p0OJrdW3kG/AQ1tWvzZ0O5UHTIII0LWOeHqWfb0tpNP94sfh6xqvA+WpN3TFYqrDrVNtGzNT9oMfQS+I2GTnB5i7b02Q+bv8GoBaeG33uT1b+guYWshNpRpW5NALwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715264; c=relaxed/simple;
	bh=syvNtO14LZlepNDIWbNpuCI/LvGXnV8yhzBuG0ANzxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXj2cRPPRy3ZOz196nICvn7u5Rl/9vrBROTAK9CmfrZr0t0A+9bfHpqihM6Yux53R5M/cTMJaE1pmd4e65ziWyidLyyBbpywB1nkEUuxNdpxJ0b+OMknSXzPDtAvc8yKGHLm8YbCINnt+nhBs7hKmHDpExXtB+8rjWK7v4p+JD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNk8D7M4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNk8D7M4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE47BC113D0;
	Fri, 17 Oct 2025 15:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715264;
	bh=syvNtO14LZlepNDIWbNpuCI/LvGXnV8yhzBuG0ANzxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kNk8D7M4eLKr+AIh56e1l9PZKrJmeNDsWSftAwPZIsm14VxzldGAWqhBX9x9Dl0cH
	 ZVB8+NS6y7wZEIkPdlQa8AVLuk03bePrR0L9/7e7XyuRtbGP7JFoxp+2SYVMTBe3fk
	 a7MqmkcI1qJAlPF8Zo5eW64MKmH1Xre2fkLFRwuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Gautam Gala <ggala@linux.ibm.com>
Subject: [PATCH 6.17 154/371] KVM: s390: Fix to clear PTE when discarding a swapped page
Date: Fri, 17 Oct 2025 16:52:09 +0200
Message-ID: <20251017145207.505105066@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautam Gala <ggala@linux.ibm.com>

commit 5deafa27d9ae040b75d392f60b12e300b42b4792 upstream.

KVM run fails when guests with 'cmm' cpu feature and host are
under memory pressure and use swap heavily. This is because
npages becomes ENOMEN (out of memory) in hva_to_pfn_slow()
which inturn propagates as EFAULT to qemu. Clearing the page
table entry when discarding an address that maps to a swap
entry resolves the issue.

Fixes: 200197908dc4 ("KVM: s390: Refactor and split some gmap helpers")
Cc: stable@vger.kernel.org
Suggested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Gautam Gala <ggala@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/pgtable.h |   22 ++++++++++++++++++++++
 arch/s390/mm/gmap_helpers.c     |   12 +++++++++++-
 arch/s390/mm/pgtable.c          |   23 +----------------------
 3 files changed, 34 insertions(+), 23 deletions(-)

--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -2055,4 +2055,26 @@ static inline unsigned long gmap_pgste_g
 	return res;
 }
 
+static inline pgste_t pgste_get_lock(pte_t *ptep)
+{
+	unsigned long value = 0;
+#ifdef CONFIG_PGSTE
+	unsigned long *ptr = (unsigned long *)(ptep + PTRS_PER_PTE);
+
+	do {
+		value = __atomic64_or_barrier(PGSTE_PCL_BIT, ptr);
+	} while (value & PGSTE_PCL_BIT);
+	value |= PGSTE_PCL_BIT;
+#endif
+	return __pgste(value);
+}
+
+static inline void pgste_set_unlock(pte_t *ptep, pgste_t pgste)
+{
+#ifdef CONFIG_PGSTE
+	barrier();
+	WRITE_ONCE(*(unsigned long *)(ptep + PTRS_PER_PTE), pgste_val(pgste) & ~PGSTE_PCL_BIT);
+#endif
+}
+
 #endif /* _S390_PAGE_H */
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -15,6 +15,7 @@
 #include <linux/pagewalk.h>
 #include <linux/ksm.h>
 #include <asm/gmap_helpers.h>
+#include <asm/pgtable.h>
 
 /**
  * ptep_zap_swap_entry() - discard a swap entry.
@@ -47,6 +48,7 @@ void gmap_helper_zap_one_page(struct mm_
 {
 	struct vm_area_struct *vma;
 	spinlock_t *ptl;
+	pgste_t pgste;
 	pte_t *ptep;
 
 	mmap_assert_locked(mm);
@@ -60,8 +62,16 @@ void gmap_helper_zap_one_page(struct mm_
 	ptep = get_locked_pte(mm, vmaddr, &ptl);
 	if (unlikely(!ptep))
 		return;
-	if (pte_swap(*ptep))
+	if (pte_swap(*ptep)) {
+		preempt_disable();
+		pgste = pgste_get_lock(ptep);
+
 		ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
+		pte_clear(mm, vmaddr, ptep);
+
+		pgste_set_unlock(ptep, pgste);
+		preempt_enable();
+	}
 	pte_unmap_unlock(ptep, ptl);
 }
 EXPORT_SYMBOL_GPL(gmap_helper_zap_one_page);
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -24,6 +24,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/page-states.h>
+#include <asm/pgtable.h>
 #include <asm/machine.h>
 
 pgprot_t pgprot_writecombine(pgprot_t prot)
@@ -115,28 +116,6 @@ static inline pte_t ptep_flush_lazy(stru
 	return old;
 }
 
-static inline pgste_t pgste_get_lock(pte_t *ptep)
-{
-	unsigned long value = 0;
-#ifdef CONFIG_PGSTE
-	unsigned long *ptr = (unsigned long *)(ptep + PTRS_PER_PTE);
-
-	do {
-		value = __atomic64_or_barrier(PGSTE_PCL_BIT, ptr);
-	} while (value & PGSTE_PCL_BIT);
-	value |= PGSTE_PCL_BIT;
-#endif
-	return __pgste(value);
-}
-
-static inline void pgste_set_unlock(pte_t *ptep, pgste_t pgste)
-{
-#ifdef CONFIG_PGSTE
-	barrier();
-	WRITE_ONCE(*(unsigned long *)(ptep + PTRS_PER_PTE), pgste_val(pgste) & ~PGSTE_PCL_BIT);
-#endif
-}
-
 static inline pgste_t pgste_get(pte_t *ptep)
 {
 	unsigned long pgste = 0;


