Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FAA397E80;
	Tue, 21 Jul 2026 20:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666852; cv=none; b=LJ8B74cR24LAMxnSiby6s47e0gr0D79fzfOr/P7Opr+xk6J2Yai7qrPnqft0zWYOYUc3K1H0azOiiYDKFOnu1S9Czn/7krRB3Wt5yKllEsaJn7sLm3Vwm1mfDd3xhEAUXLti7D1EpXiKP2R6kntI6+7C0Yf0H8lnBd8qSqPDVhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666852; c=relaxed/simple;
	bh=pYbCyJ3RjdIRdPs0KJssQ/NPQcthVlr0sfTbxgQzVbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5S3mAYi8Tzc+G8QHrv21ho18nfG1rtfgdqS1bwZW7kJqmjQTgZw7TEBmbpSLu35o5OxuH7zefeTpizEF36JCevfpa/L4pW64RJYDtillid3knnnef4SkpJYwjTM2TwqZbd5rM8yAXdD4ljfEQ3Z7OG9Nqg8vPKUKGZfqxLdJtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhfc6AIA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhfc6AIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92B01F00A3A;
	Tue, 21 Jul 2026 20:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666850;
	bh=yvLCWkdfFldLlh0f+tepPF3SQbsmXux/QOesr8TzkUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lhfc6AIAXXnqZCoWDswO7qqSKV6f5iK/vLBcZeJNLUBKvQz3VM/DsS4jZNDM++fdw
	 VeNARmsncmOqcgocy+q7Cen08wg4TYD7LJ0hTQmm55Q5AxmOc4cXf2KujCBj8nlYAw
	 8Ym2cyuHo46J6FX+jzj8+ZT5BsEDEIrwt4JgPHdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Barry Song <21cnbao@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Morse <james.morse@arm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Yang Shi <shy828301@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0840/1266] arm64/mm: convert set_pte_at() to set_ptes(..., 1)
Date: Tue, 21 Jul 2026 17:21:17 +0200
Message-ID: <20260721152500.652728175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit 659e193027910a5d3083e34b488ab459d2ef5082 ]

Since set_ptes() was introduced, set_pte_at() has been implemented as a
generic macro around set_ptes(..., 1).  So this change should continue to
generate the same code.  However, making this change prepares us for the
transparent contpte support.  It means we can reroute set_ptes() to
__set_ptes().  Since set_pte_at() is a generic macro, there will be no
equivalent __set_pte_at() to reroute to.

Note that a couple of calls to set_pte_at() remain in the arch code.  This
is intentional, since those call sites are acting on behalf of core-mm and
should continue to call into the public set_ptes() rather than the
arch-private __set_ptes().

Link: https://lkml.kernel.org/r/20240215103205.2607016-9-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: ff4c5a0de1f2 ("arm64/mm: Optimize TLB flush in unmap_hotplug_[pmd|pud]_range()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/pgtable.h |  2 +-
 arch/arm64/kernel/mte.c          |  2 +-
 arch/arm64/kvm/guest.c           |  2 +-
 arch/arm64/mm/fault.c            |  2 +-
 arch/arm64/mm/hugetlbpage.c      | 10 +++++-----
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 67a2c9eeede964..3ae4239c88d1ff 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1077,7 +1077,7 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 #endif /* CONFIG_ARM64_MTE */
 
 /*
- * On AArch64, the cache coherency is handled via the set_pte_at() function.
+ * On AArch64, the cache coherency is handled via the set_ptes() function.
  */
 static inline void update_mmu_cache_range(struct vm_fault *vmf,
 		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 84ea9c50c076f0..92e0ab252d6298 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -67,7 +67,7 @@ int memcmp_pages(struct page *page1, struct page *page2)
 	/*
 	 * If the page content is identical but at least one of the pages is
 	 * tagged, return non-zero to avoid KSM merging. If only one of the
-	 * pages is tagged, set_pte_at() may zero or change the tags of the
+	 * pages is tagged, set_ptes() may zero or change the tags of the
 	 * other page via mte_sync_tags().
 	 */
 	if (page_mte_tagged(page1) || page_mte_tagged(page2))
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index efe82cc86bd1f3..ce238ef9e11335 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1073,7 +1073,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 		} else {
 			/*
 			 * Only locking to serialise with a concurrent
-			 * set_pte_at() in the VMM but still overriding the
+			 * set_ptes() in the VMM but still overriding the
 			 * tags, hence ignoring the return value.
 			 */
 			try_page_mte_tagging(page);
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 7bcdc99ed57148..586bcf2a3db1b7 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -205,7 +205,7 @@ static void show_pte(unsigned long addr)
  *
  * It needs to cope with hardware update of the accessed/dirty state by other
  * agents in the system and can safely skip the __sync_icache_dcache() call as,
- * like set_pte_at(), the PTE is never changed from no-exec to exec here.
+ * like set_ptes(), the PTE is never changed from no-exec to exec here.
  *
  * Returns whether or not the PTE actually changed.
  */
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index a5a56e30c254b0..398310ce919614 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -246,12 +246,12 @@ void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 
 	if (!pte_present(pte)) {
 		for (i = 0; i < ncontig; i++, ptep++, addr += pgsize)
-			set_pte_at(mm, addr, ptep, pte);
+			set_ptes(mm, addr, ptep, pte, 1);
 		return;
 	}
 
 	if (!pte_cont(pte)) {
-		set_pte_at(mm, addr, ptep, pte);
+		set_ptes(mm, addr, ptep, pte, 1);
 		return;
 	}
 
@@ -262,7 +262,7 @@ void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 	clear_flush(mm, addr, ptep, pgsize, ncontig);
 
 	for (i = 0; i < ncontig; i++, ptep++, addr += pgsize, pfn += dpfn)
-		set_pte_at(mm, addr, ptep, pfn_pte(pfn, hugeprot));
+		set_ptes(mm, addr, ptep, pfn_pte(pfn, hugeprot), 1);
 }
 
 pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -465,7 +465,7 @@ int huge_ptep_set_access_flags(struct vm_area_struct *vma,
 
 	hugeprot = pte_pgprot(pte);
 	for (i = 0; i < ncontig; i++, ptep++, addr += pgsize, pfn += dpfn)
-		set_pte_at(mm, addr, ptep, pfn_pte(pfn, hugeprot));
+		set_ptes(mm, addr, ptep, pfn_pte(pfn, hugeprot), 1);
 
 	return 1;
 }
@@ -494,7 +494,7 @@ void huge_ptep_set_wrprotect(struct mm_struct *mm,
 	pfn = pte_pfn(pte);
 
 	for (i = 0; i < ncontig; i++, ptep++, addr += pgsize, pfn += dpfn)
-		set_pte_at(mm, addr, ptep, pfn_pte(pfn, hugeprot));
+		set_ptes(mm, addr, ptep, pfn_pte(pfn, hugeprot), 1);
 }
 
 pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
-- 
2.53.0



