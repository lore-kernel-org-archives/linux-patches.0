Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DAF1C6881;
	Tue, 27 Aug 2024 15:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771545; cv=none; b=AzeQnb0OCJqrcf87C5YCJCxYcWvvZN4eFW12wayTTIF1RsycrhRhZFIwu5dJIaxcQbDFTRmRxTit1C21mcyuy7eENl0u1Nl43nE939kJb2YU1I1jc0tIE0xTtWBK47GICRtj9v8GWLyQQ0oMbovVfgqxqafmyAXgkX3ZG4WjqYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771545; c=relaxed/simple;
	bh=BXhJWf1IyYlPwpY+EE5CK3PNVDcgF/jRKZ0G9ZxqB4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYx3MozO+PEuxl3/668hRX7NyjUXUcNxc1zLWfSGR/kABOgUfUtqe6yfv6dHsl5XTwngqShqxAVuORAOwiFttBPxbdtDIxv5DBEBy5Y3lngStkScS9yhWI8hbFLlw1xo7ubXj6xRrGXxOzrdvP23HqXpBtb64zeW0suuqBMFWp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XILdgDyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XILdgDyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CABC6104A;
	Tue, 27 Aug 2024 15:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771544;
	bh=BXhJWf1IyYlPwpY+EE5CK3PNVDcgF/jRKZ0G9ZxqB4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XILdgDyMURmFcYlligtZyGCmFHtXb4kHyaLl7gWl2StxxFo2aV80lwKpXsVfonMjB
	 gjqZ9jTwBQ3EtXFBi1xMdSVQrPKoDUeQNmPzedp4SoWkPjd5cQ39fk+P1l/5RjBMma
	 z+LGZHx3rXVpwMwBAKjuC1akf00djwWU+Ybwh9JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Sandoval <osandov@osandov.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 220/273] s390/boot: Fix KASLR base offset off by __START_KERNEL bytes
Date: Tue, 27 Aug 2024 16:39:04 +0200
Message-ID: <20240827143841.779199698@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 1642285e511c2a40b14e87a41aa8feace6123036 ]

Symbol offsets to the KASLR base do not match symbol address in
the vmlinux image. That is the result of setting the KASLR base
to the beginning of .text section as result of an optimization.

Revert that optimization and allocate virtual memory for the
whole kernel image including __START_KERNEL bytes as per the
linker script. That allows keeping the semantics of the KASLR
base offset in sync with other architectures.

Rename __START_KERNEL to TEXT_OFFSET, since it represents the
offset of the .text section within the kernel image, rather than
a virtual address.

Still skip mapping TEXT_OFFSET bytes to save memory on pgtables
and provoke exceptions in case an attempt to access this area is
made, as no kernel symbol may reside there.

In case CONFIG_KASAN is enabled the location counter might exceed
the value of TEXT_OFFSET, while the decompressor linker script
forcefully resets it to TEXT_OFFSET, which leads to a sections
overlap link failure. Use MAX() expression to avoid that.

Reported-by: Omar Sandoval <osandov@osandov.com>
Closes: https://lore.kernel.org/linux-s390/ZnS8dycxhtXBZVky@telecaster.dhcp.thefacebook.com/
Fixes: 56b1069c40c7 ("s390/boot: Rework deployment of the kernel image")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Acked-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/startup.c       | 55 ++++++++++++++++++----------------
 arch/s390/boot/vmem.c          | 14 +++++++--
 arch/s390/boot/vmlinux.lds.S   |  7 ++++-
 arch/s390/include/asm/page.h   |  3 +-
 arch/s390/kernel/vmlinux.lds.S |  2 +-
 arch/s390/tools/relocs.c       |  2 +-
 6 files changed, 52 insertions(+), 31 deletions(-)

diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index 7797446620b64..6d88f241dd43a 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -161,7 +161,7 @@ static void kaslr_adjust_relocs(unsigned long min_addr, unsigned long max_addr,
 		loc = (long)*reloc + phys_offset;
 		if (loc < min_addr || loc > max_addr)
 			error("64-bit relocation outside of kernel!\n");
-		*(u64 *)loc += offset - __START_KERNEL;
+		*(u64 *)loc += offset;
 	}
 }
 
@@ -176,7 +176,7 @@ static void kaslr_adjust_got(unsigned long offset)
 	 */
 	for (entry = (u64 *)vmlinux.got_start; entry < (u64 *)vmlinux.got_end; entry++) {
 		if (*entry)
-			*entry += offset - __START_KERNEL;
+			*entry += offset;
 	}
 }
 
@@ -251,7 +251,7 @@ static unsigned long setup_kernel_memory_layout(unsigned long kernel_size)
 	vmemmap_size = SECTION_ALIGN_UP(pages) * sizeof(struct page);
 
 	/* choose kernel address space layout: 4 or 3 levels. */
-	BUILD_BUG_ON(!IS_ALIGNED(__START_KERNEL, THREAD_SIZE));
+	BUILD_BUG_ON(!IS_ALIGNED(TEXT_OFFSET, THREAD_SIZE));
 	BUILD_BUG_ON(!IS_ALIGNED(__NO_KASLR_START_KERNEL, THREAD_SIZE));
 	BUILD_BUG_ON(__NO_KASLR_END_KERNEL > _REGION1_SIZE);
 	vsize = get_vmem_size(ident_map_size, vmemmap_size, vmalloc_size, _REGION3_SIZE);
@@ -378,31 +378,25 @@ static void kaslr_adjust_vmlinux_info(long offset)
 #endif
 }
 
-static void fixup_vmlinux_info(void)
-{
-	vmlinux.entry -= __START_KERNEL;
-	kaslr_adjust_vmlinux_info(-__START_KERNEL);
-}
-
 void startup_kernel(void)
 {
-	unsigned long kernel_size = vmlinux.image_size + vmlinux.bss_size;
-	unsigned long nokaslr_offset_phys, kaslr_large_page_offset;
-	unsigned long amode31_lma = 0;
+	unsigned long vmlinux_size = vmlinux.image_size + vmlinux.bss_size;
+	unsigned long nokaslr_text_lma, text_lma = 0, amode31_lma = 0;
+	unsigned long kernel_size = TEXT_OFFSET + vmlinux_size;
+	unsigned long kaslr_large_page_offset;
 	unsigned long max_physmem_end;
 	unsigned long asce_limit;
 	unsigned long safe_addr;
 	psw_t psw;
 
-	fixup_vmlinux_info();
 	setup_lpp();
 
 	/*
 	 * Non-randomized kernel physical start address must be _SEGMENT_SIZE
 	 * aligned (see blow).
 	 */
-	nokaslr_offset_phys = ALIGN(mem_safe_offset(), _SEGMENT_SIZE);
-	safe_addr = PAGE_ALIGN(nokaslr_offset_phys + kernel_size);
+	nokaslr_text_lma = ALIGN(mem_safe_offset(), _SEGMENT_SIZE);
+	safe_addr = PAGE_ALIGN(nokaslr_text_lma + vmlinux_size);
 
 	/*
 	 * Reserve decompressor memory together with decompression heap,
@@ -446,16 +440,27 @@ void startup_kernel(void)
 	 */
 	kaslr_large_page_offset = __kaslr_offset & ~_SEGMENT_MASK;
 	if (kaslr_enabled()) {
-		unsigned long size = kernel_size + kaslr_large_page_offset;
+		unsigned long size = vmlinux_size + kaslr_large_page_offset;
 
-		__kaslr_offset_phys = randomize_within_range(size, _SEGMENT_SIZE, 0, ident_map_size);
+		text_lma = randomize_within_range(size, _SEGMENT_SIZE, TEXT_OFFSET, ident_map_size);
 	}
-	if (!__kaslr_offset_phys)
-		__kaslr_offset_phys = nokaslr_offset_phys;
-	__kaslr_offset_phys |= kaslr_large_page_offset;
+	if (!text_lma)
+		text_lma = nokaslr_text_lma;
+	text_lma |= kaslr_large_page_offset;
+
+	/*
+	 * [__kaslr_offset_phys..__kaslr_offset_phys + TEXT_OFFSET] region is
+	 * never accessed via the kernel image mapping as per the linker script:
+	 *
+	 *	. = TEXT_OFFSET;
+	 *
+	 * Therefore, this region could be used for something else and does
+	 * not need to be reserved. See how it is skipped in setup_vmem().
+	 */
+	__kaslr_offset_phys = text_lma - TEXT_OFFSET;
 	kaslr_adjust_vmlinux_info(__kaslr_offset_phys);
-	physmem_reserve(RR_VMLINUX, __kaslr_offset_phys, kernel_size);
-	deploy_kernel((void *)__kaslr_offset_phys);
+	physmem_reserve(RR_VMLINUX, text_lma, vmlinux_size);
+	deploy_kernel((void *)text_lma);
 
 	/* vmlinux decompression is done, shrink reserved low memory */
 	physmem_reserve(RR_DECOMPRESSOR, 0, (unsigned long)_decompressor_end);
@@ -474,7 +479,7 @@ void startup_kernel(void)
 	if (kaslr_enabled())
 		amode31_lma = randomize_within_range(vmlinux.amode31_size, PAGE_SIZE, 0, SZ_2G);
 	if (!amode31_lma)
-		amode31_lma = __kaslr_offset_phys - vmlinux.amode31_size;
+		amode31_lma = text_lma - vmlinux.amode31_size;
 	physmem_reserve(RR_AMODE31, amode31_lma, vmlinux.amode31_size);
 
 	/*
@@ -490,8 +495,8 @@ void startup_kernel(void)
 	 * - copy_bootdata() must follow setup_vmem() to propagate changes
 	 *   to bootdata made by setup_vmem()
 	 */
-	clear_bss_section(__kaslr_offset_phys);
-	kaslr_adjust_relocs(__kaslr_offset_phys, __kaslr_offset_phys + vmlinux.image_size,
+	clear_bss_section(text_lma);
+	kaslr_adjust_relocs(text_lma, text_lma + vmlinux.image_size,
 			    __kaslr_offset, __kaslr_offset_phys);
 	kaslr_adjust_got(__kaslr_offset);
 	setup_vmem(__kaslr_offset, __kaslr_offset + kernel_size, asce_limit);
diff --git a/arch/s390/boot/vmem.c b/arch/s390/boot/vmem.c
index 40cfce2687c43..3d4dae9905cd8 100644
--- a/arch/s390/boot/vmem.c
+++ b/arch/s390/boot/vmem.c
@@ -89,7 +89,7 @@ static void kasan_populate_shadow(unsigned long kernel_start, unsigned long kern
 		}
 		memgap_start = end;
 	}
-	kasan_populate(kernel_start, kernel_end, POPULATE_KASAN_MAP_SHADOW);
+	kasan_populate(kernel_start + TEXT_OFFSET, kernel_end, POPULATE_KASAN_MAP_SHADOW);
 	kasan_populate(0, (unsigned long)__identity_va(0), POPULATE_KASAN_ZERO_SHADOW);
 	kasan_populate(AMODE31_START, AMODE31_END, POPULATE_KASAN_ZERO_SHADOW);
 	if (IS_ENABLED(CONFIG_KASAN_VMALLOC)) {
@@ -466,7 +466,17 @@ void setup_vmem(unsigned long kernel_start, unsigned long kernel_end, unsigned l
 				 (unsigned long)__identity_va(end),
 				 POPULATE_IDENTITY);
 	}
-	pgtable_populate(kernel_start, kernel_end, POPULATE_KERNEL);
+
+	/*
+	 * [kernel_start..kernel_start + TEXT_OFFSET] region is never
+	 * accessed as per the linker script:
+	 *
+	 *	. = TEXT_OFFSET;
+	 *
+	 * Therefore, skip mapping TEXT_OFFSET bytes to prevent access to
+	 * [__kaslr_offset_phys..__kaslr_offset_phys + TEXT_OFFSET] region.
+	 */
+	pgtable_populate(kernel_start + TEXT_OFFSET, kernel_end, POPULATE_KERNEL);
 	pgtable_populate(AMODE31_START, AMODE31_END, POPULATE_DIRECT);
 	pgtable_populate(__abs_lowcore, __abs_lowcore + sizeof(struct lowcore),
 			 POPULATE_ABS_LOWCORE);
diff --git a/arch/s390/boot/vmlinux.lds.S b/arch/s390/boot/vmlinux.lds.S
index a750711d44c86..66670212a3611 100644
--- a/arch/s390/boot/vmlinux.lds.S
+++ b/arch/s390/boot/vmlinux.lds.S
@@ -109,7 +109,12 @@ SECTIONS
 #ifdef CONFIG_KERNEL_UNCOMPRESSED
 	. = ALIGN(PAGE_SIZE);
 	. += AMODE31_SIZE;		/* .amode31 section */
-	. = ALIGN(1 << 20);		/* _SEGMENT_SIZE */
+
+	/*
+	 * Make sure the location counter is not less than TEXT_OFFSET.
+	 * _SEGMENT_SIZE is not available, use ALIGN(1 << 20) instead.
+	 */
+	. = MAX(TEXT_OFFSET, ALIGN(1 << 20));
 #else
 	. = ALIGN(8);
 #endif
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 224ff9d433ead..8cac1a737424d 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -276,8 +276,9 @@ static inline unsigned long virt_to_pfn(const void *kaddr)
 #define AMODE31_SIZE		(3 * PAGE_SIZE)
 
 #define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
-#define __START_KERNEL		0x100000
 #define __NO_KASLR_START_KERNEL	CONFIG_KERNEL_IMAGE_BASE
 #define __NO_KASLR_END_KERNEL	(__NO_KASLR_START_KERNEL + KERNEL_IMAGE_SIZE)
 
+#define TEXT_OFFSET		0x100000
+
 #endif /* _S390_PAGE_H */
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index a1ce3925ec719..52bd969b28283 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -39,7 +39,7 @@ PHDRS {
 
 SECTIONS
 {
-	. = __START_KERNEL;
+	. = TEXT_OFFSET;
 	.text : {
 		_stext = .;		/* Start of text section */
 		_text = .;		/* Text and read-only data */
diff --git a/arch/s390/tools/relocs.c b/arch/s390/tools/relocs.c
index a74dbd5c9896a..30a732c808f35 100644
--- a/arch/s390/tools/relocs.c
+++ b/arch/s390/tools/relocs.c
@@ -280,7 +280,7 @@ static int do_reloc(struct section *sec, Elf_Rel *rel)
 	case R_390_GOTOFF64:
 		break;
 	case R_390_64:
-		add_reloc(&relocs64, offset - ehdr.e_entry);
+		add_reloc(&relocs64, offset);
 		break;
 	default:
 		die("Unsupported relocation type: %d\n", r_type);
-- 
2.43.0



