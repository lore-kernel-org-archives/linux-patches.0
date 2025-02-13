Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EEA1422D8;
	Thu, 13 Feb 2025 15:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460204; cv=none; b=LQMQS863vpxOgEoh0I64c/NSHoVdyYpC7/fE30e3l5qqHdotn63ctDZ4JLKRXCMR/gBKws8gcJz85MfRvyni4nsZU/njMFjFgwe3PXoqm8t4v7QapZN/QPKce6BLxc8Qv55UboR1bhBYS4OAvzRG+6S8Q0tndrDHOVh2MRW8yiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460204; c=relaxed/simple;
	bh=GiDBqh9DmKdNXYY8tUPZzY4OLcAl6F8T5CtwuA4M2Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgLkdkPsbAXqA851pQU7aJEqKOt8OT+x3GvVPmqpVLGawgegpL/wYhgtWZymyYX32mnMbURheSFoDpiOpC1Yb4SR1ZLPLFJ9zaCqlXTc9Sdf36LarxHUqreOPFmwfQc1jPzEFufuZETJ9cuVAjZvBeOT2Xwvx9QzGn562NTz8AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2Xx7WkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2Xx7WkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15ABFC4CED1;
	Thu, 13 Feb 2025 15:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460204;
	bh=GiDBqh9DmKdNXYY8tUPZzY4OLcAl6F8T5CtwuA4M2Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2Xx7WkZy9Qo6gaRoyl1xIqmpPde3n9g9S62/WgkMcV1P3gMSMnUOjO8c2kPlvhQw
	 1bcLSZdxb+cTtDLNdVAgkOS2TWnP8ahoFN/5Urpdd949FpICuWvYxapMXl5+I7ibkW
	 NW2PgqQoiu89Sk++n6KY7yn3oQI0gGnw87rtviXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Ingo Molnar <mingo@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/273] x86/kexec: Allocate PGD for x86_64 transition page tables separately
Date: Thu, 13 Feb 2025 15:26:58 +0100
Message-ID: <20250213142409.170368385@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

From: David Woodhouse <dwmw@amazon.co.uk>

[ Upstream commit 4b5bc2ec9a239bce261ffeafdd63571134102323 ]

Now that the following fix:

  d0ceea662d45 ("x86/mm: Add _PAGE_NOPTISHADOW bit to avoid updating userspace page tables")

stops kernel_ident_mapping_init() from scribbling over the end of a
4KiB PGD by assuming the following 4KiB will be a userspace PGD,
there's no good reason for the kexec PGD to be part of a single
8KiB allocation with the control_code_page.

( It's not clear that that was the reason for x86_64 kexec doing it that
  way in the first place either; there were no comments to that effect and
  it seems to have been the case even before PTI came along. It looks like
  it was just a happy accident which prevented memory corruption on kexec. )

Either way, it definitely isn't needed now. Just allocate the PGD
separately on x86_64, like i386 already does.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: https://lore.kernel.org/r/20241205153343.3275139-6-dwmw2@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kexec.h       | 18 +++++++++---
 arch/x86/kernel/machine_kexec_64.c | 45 ++++++++++++++++--------------
 2 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index c9f6a6c5de3cf..d54dd7084a3e1 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -16,6 +16,7 @@
 # define PAGES_NR		4
 #endif
 
+# define KEXEC_CONTROL_PAGE_SIZE	4096
 # define KEXEC_CONTROL_CODE_MAX_SIZE	2048
 
 #ifndef __ASSEMBLY__
@@ -44,7 +45,6 @@ struct kimage;
 /* Maximum address we can use for the control code buffer */
 # define KEXEC_CONTROL_MEMORY_LIMIT TASK_SIZE
 
-# define KEXEC_CONTROL_PAGE_SIZE	4096
 
 /* The native architecture */
 # define KEXEC_ARCH KEXEC_ARCH_386
@@ -59,9 +59,6 @@ struct kimage;
 /* Maximum address we can use for the control pages */
 # define KEXEC_CONTROL_MEMORY_LIMIT     (MAXMEM-1)
 
-/* Allocate one page for the pdp and the second for the code */
-# define KEXEC_CONTROL_PAGE_SIZE  (4096UL + 4096UL)
-
 /* The native architecture */
 # define KEXEC_ARCH KEXEC_ARCH_X86_64
 #endif
@@ -146,6 +143,19 @@ struct kimage_arch {
 };
 #else
 struct kimage_arch {
+	/*
+	 * This is a kimage control page, as it must not overlap with either
+	 * source or destination address ranges.
+	 */
+	pgd_t *pgd;
+	/*
+	 * The virtual mapping of the control code page itself is used only
+	 * during the transition, while the current kernel's pages are all
+	 * in place. Thus the intermediate page table pages used to map it
+	 * are not control pages, but instead just normal pages obtained
+	 * with get_zeroed_page(). And have to be tracked (below) so that
+	 * they can be freed.
+	 */
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 2fa12d1dc6760..8509d809a9f1b 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -149,7 +149,8 @@ static void free_transition_pgtable(struct kimage *image)
 	image->arch.pte = NULL;
 }
 
-static int init_transition_pgtable(struct kimage *image, pgd_t *pgd)
+static int init_transition_pgtable(struct kimage *image, pgd_t *pgd,
+				   unsigned long control_page)
 {
 	pgprot_t prot = PAGE_KERNEL_EXEC_NOENC;
 	unsigned long vaddr, paddr;
@@ -160,7 +161,7 @@ static int init_transition_pgtable(struct kimage *image, pgd_t *pgd)
 	pte_t *pte;
 
 	vaddr = (unsigned long)relocate_kernel;
-	paddr = __pa(page_address(image->control_code_page)+PAGE_SIZE);
+	paddr = control_page;
 	pgd += pgd_index(vaddr);
 	if (!pgd_present(*pgd)) {
 		p4d = (p4d_t *)get_zeroed_page(GFP_KERNEL);
@@ -219,7 +220,7 @@ static void *alloc_pgt_page(void *data)
 	return p;
 }
 
-static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
+static int init_pgtable(struct kimage *image, unsigned long control_page)
 {
 	struct x86_mapping_info info = {
 		.alloc_pgt_page	= alloc_pgt_page,
@@ -228,12 +229,12 @@ static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 		.kernpg_flag	= _KERNPG_TABLE_NOENC,
 	};
 	unsigned long mstart, mend;
-	pgd_t *level4p;
 	int result;
 	int i;
 
-	level4p = (pgd_t *)__va(start_pgtable);
-	clear_page(level4p);
+	image->arch.pgd = alloc_pgt_page(image);
+	if (!image->arch.pgd)
+		return -ENOMEM;
 
 	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
 		info.page_flag   |= _PAGE_ENC;
@@ -247,8 +248,8 @@ static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 		mstart = pfn_mapped[i].start << PAGE_SHIFT;
 		mend   = pfn_mapped[i].end << PAGE_SHIFT;
 
-		result = kernel_ident_mapping_init(&info,
-						 level4p, mstart, mend);
+		result = kernel_ident_mapping_init(&info, image->arch.pgd,
+						   mstart, mend);
 		if (result)
 			return result;
 	}
@@ -263,8 +264,8 @@ static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 		mstart = image->segment[i].mem;
 		mend   = mstart + image->segment[i].memsz;
 
-		result = kernel_ident_mapping_init(&info,
-						 level4p, mstart, mend);
+		result = kernel_ident_mapping_init(&info, image->arch.pgd,
+						   mstart, mend);
 
 		if (result)
 			return result;
@@ -274,15 +275,19 @@ static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 	 * Prepare EFI systab and ACPI tables for kexec kernel since they are
 	 * not covered by pfn_mapped.
 	 */
-	result = map_efi_systab(&info, level4p);
+	result = map_efi_systab(&info, image->arch.pgd);
 	if (result)
 		return result;
 
-	result = map_acpi_tables(&info, level4p);
+	result = map_acpi_tables(&info, image->arch.pgd);
 	if (result)
 		return result;
 
-	return init_transition_pgtable(image, level4p);
+	/*
+	 * This must be last because the intermediate page table pages it
+	 * allocates will not be control pages and may overlap the image.
+	 */
+	return init_transition_pgtable(image, image->arch.pgd, control_page);
 }
 
 static void load_segments(void)
@@ -299,14 +304,14 @@ static void load_segments(void)
 
 int machine_kexec_prepare(struct kimage *image)
 {
-	unsigned long start_pgtable;
+	unsigned long control_page;
 	int result;
 
 	/* Calculate the offsets */
-	start_pgtable = page_to_pfn(image->control_code_page) << PAGE_SHIFT;
+	control_page = page_to_pfn(image->control_code_page) << PAGE_SHIFT;
 
 	/* Setup the identity mapped 64bit page table */
-	result = init_pgtable(image, start_pgtable);
+	result = init_pgtable(image, control_page);
 	if (result)
 		return result;
 
@@ -360,13 +365,12 @@ void machine_kexec(struct kimage *image)
 #endif
 	}
 
-	control_page = page_address(image->control_code_page) + PAGE_SIZE;
+	control_page = page_address(image->control_code_page);
 	__memcpy(control_page, relocate_kernel, KEXEC_CONTROL_CODE_MAX_SIZE);
 
 	page_list[PA_CONTROL_PAGE] = virt_to_phys(control_page);
 	page_list[VA_CONTROL_PAGE] = (unsigned long)control_page;
-	page_list[PA_TABLE_PAGE] =
-	  (unsigned long)__pa(page_address(image->control_code_page));
+	page_list[PA_TABLE_PAGE] = (unsigned long)__pa(image->arch.pgd);
 
 	if (image->type == KEXEC_TYPE_DEFAULT)
 		page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page)
@@ -574,8 +578,7 @@ static void kexec_mark_crashkres(bool protect)
 
 	/* Don't touch the control code page used in crash_kexec().*/
 	control = PFN_PHYS(page_to_pfn(kexec_crash_image->control_code_page));
-	/* Control code page is located in the 2nd page. */
-	kexec_mark_range(crashk_res.start, control + PAGE_SIZE - 1, protect);
+	kexec_mark_range(crashk_res.start, control - 1, protect);
 	control += KEXEC_CONTROL_PAGE_SIZE;
 	kexec_mark_range(control, crashk_res.end, protect);
 }
-- 
2.39.5



