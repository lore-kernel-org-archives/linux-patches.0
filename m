Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBE07E110;
	Tue, 29 Apr 2025 17:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946099; cv=none; b=gOfaVjvPAUf+ttKkFUxloSVnVOiaVggSbCuL3V6j4t2nx135wz0lHzLDj8d/adWEEuR/FhfxjpP/7D6OrmwdCX98RHdl7Q8IxJH1EfaEZToFru1dm7BhAX/X/oA9X1vYlVypqzw51+cfdEYYoq86EKyS3uiLY0czmE1QSbhS/po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946099; c=relaxed/simple;
	bh=PCeomyGnWVXdqEQjITpM1qECmpaCOCOz3utQttZqg2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kFrAyxSmk9lPcUyE86247sAcXYYHxBkH/7HI7fuUhINXeUUDwR4ThIhbGkCrXcJmzhIYIbh1RXV40l3zRJAeUsMGc3+M90X8gfTRHWN+GiNNWrd5xXr3d1hAXsyyLbkYxm+Tcty//497Gs3I7rHgxfw/XBka1tBjY4WrtmDxn2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhNF12gg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhNF12gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44981C4CEE9;
	Tue, 29 Apr 2025 17:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946099;
	bh=PCeomyGnWVXdqEQjITpM1qECmpaCOCOz3utQttZqg2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhNF12gg6XSFs0L1qNXVL1nX8Ks1Zs2aaS2aUxBlwZtXfYcYfnorZuzZMzLuDvmpA
	 O+IgIk266ZW1jeAiJUfdUNLawN4MBSdQdUzFhfAHmOpv2BqngfHC5vYPbyiCdKcfHW
	 VpaHlRrxzmNhOvL1EoQXNVVzTK1hiyoUVWHs6GRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Petr=20Van=C4=9Bk?= <arkamar@atlas.cz>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.14 124/311] x86/mm: Fix _pgd_alloc() for Xen PV mode
Date: Tue, 29 Apr 2025 18:39:21 +0200
Message-ID: <20250429161126.116304451@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit 4ce385f56434f3810ef103e1baea357ddcc6667e upstream.

Recently _pgd_alloc() was switched from using __get_free_pages() to
pagetable_alloc_noprof(), which might return a compound page in case
the allocation order is larger than 0.

On x86 this will be the case if CONFIG_MITIGATION_PAGE_TABLE_ISOLATION
is set, even if PTI has been disabled at runtime.

When running as a Xen PV guest (this will always disable PTI), using
a compound page for a PGD will result in VM_BUG_ON_PGFLAGS being
triggered when the Xen code tries to pin the PGD.

Fix the Xen issue together with the not needed 8k allocation for a
PGD with PTI disabled by replacing PGD_ALLOCATION_ORDER with an
inline helper returning the needed order for PGD allocations.

Fixes: a9b3c355c2e6 ("asm-generic: pgalloc: provide generic __pgd_{alloc,free}")
Reported-by: Petr Vaněk <arkamar@atlas.cz>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Tested-by: Petr Vaněk <arkamar@atlas.cz>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250422131717.25724-1-jgross%40suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/pgalloc.h     |   19 +++++++++++--------
 arch/x86/kernel/machine_kexec_32.c |    4 ++--
 arch/x86/mm/pgtable.c              |    4 ++--
 arch/x86/platform/efi/efi_64.c     |    4 ++--
 4 files changed, 17 insertions(+), 14 deletions(-)

--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -6,6 +6,8 @@
 #include <linux/mm.h>		/* for struct page */
 #include <linux/pagemap.h>
 
+#include <asm/cpufeature.h>
+
 #define __HAVE_ARCH_PTE_ALLOC_ONE
 #define __HAVE_ARCH_PGD_FREE
 #include <asm-generic/pgalloc.h>
@@ -34,16 +36,17 @@ static inline void paravirt_release_p4d(
  */
 extern gfp_t __userpte_alloc_gfp;
 
-#ifdef CONFIG_MITIGATION_PAGE_TABLE_ISOLATION
 /*
- * Instead of one PGD, we acquire two PGDs.  Being order-1, it is
- * both 8k in size and 8k-aligned.  That lets us just flip bit 12
- * in a pointer to swap between the two 4k halves.
+ * In case of Page Table Isolation active, we acquire two PGDs instead of one.
+ * Being order-1, it is both 8k in size and 8k-aligned.  That lets us just
+ * flip bit 12 in a pointer to swap between the two 4k halves.
  */
-#define PGD_ALLOCATION_ORDER 1
-#else
-#define PGD_ALLOCATION_ORDER 0
-#endif
+static inline unsigned int pgd_allocation_order(void)
+{
+	if (cpu_feature_enabled(X86_FEATURE_PTI))
+		return 1;
+	return 0;
+}
 
 /*
  * Allocate and free page tables.
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -42,7 +42,7 @@ static void load_segments(void)
 
 static void machine_kexec_free_page_tables(struct kimage *image)
 {
-	free_pages((unsigned long)image->arch.pgd, PGD_ALLOCATION_ORDER);
+	free_pages((unsigned long)image->arch.pgd, pgd_allocation_order());
 	image->arch.pgd = NULL;
 #ifdef CONFIG_X86_PAE
 	free_page((unsigned long)image->arch.pmd0);
@@ -59,7 +59,7 @@ static void machine_kexec_free_page_tabl
 static int machine_kexec_alloc_page_tables(struct kimage *image)
 {
 	image->arch.pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
-						    PGD_ALLOCATION_ORDER);
+						    pgd_allocation_order());
 #ifdef CONFIG_X86_PAE
 	image->arch.pmd0 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
 	image->arch.pmd1 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -404,7 +404,7 @@ static inline pgd_t *_pgd_alloc(struct m
 	 * We allocate one page for pgd.
 	 */
 	if (!SHARED_KERNEL_PMD)
-		return __pgd_alloc(mm, PGD_ALLOCATION_ORDER);
+		return __pgd_alloc(mm, pgd_allocation_order());
 
 	/*
 	 * Now PAE kernel is not running as a Xen domain. We can allocate
@@ -424,7 +424,7 @@ static inline void _pgd_free(struct mm_s
 
 static inline pgd_t *_pgd_alloc(struct mm_struct *mm)
 {
-	return __pgd_alloc(mm, PGD_ALLOCATION_ORDER);
+	return __pgd_alloc(mm, pgd_allocation_order());
 }
 
 static inline void _pgd_free(struct mm_struct *mm, pgd_t *pgd)
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -73,7 +73,7 @@ int __init efi_alloc_page_tables(void)
 	gfp_t gfp_mask;
 
 	gfp_mask = GFP_KERNEL | __GFP_ZERO;
-	efi_pgd = (pgd_t *)__get_free_pages(gfp_mask, PGD_ALLOCATION_ORDER);
+	efi_pgd = (pgd_t *)__get_free_pages(gfp_mask, pgd_allocation_order());
 	if (!efi_pgd)
 		goto fail;
 
@@ -96,7 +96,7 @@ free_p4d:
 	if (pgtable_l5_enabled())
 		free_page((unsigned long)pgd_page_vaddr(*pgd));
 free_pgd:
-	free_pages((unsigned long)efi_pgd, PGD_ALLOCATION_ORDER);
+	free_pages((unsigned long)efi_pgd, pgd_allocation_order());
 fail:
 	return -ENOMEM;
 }


