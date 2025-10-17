Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203142F12CF;
	Fri, 17 Oct 2025 15:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714102; cv=none; b=T0O+IG6NfUBhBm9XK0SZLuE7j/M/JC6tjqTy0MmkT487OFM25/3bDOBupK1N9qd3lbwYG+wubowfJ/1wVqeqzamZedo6rZy4aQ+bcYqghMZfMH+gn8APB7NQPepz4Ex6LdsKV5zR0gWaqvWH4SfmyII7FkPtmBnmtsUTqWrZJGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714102; c=relaxed/simple;
	bh=YjTFRXJ2AtzaEw6+9zqQOhIMqvwwlCmL2ciaPjTLp/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EC5TSwZF4SbE1JuECiwRH13EkOvDhLsRE1jExKWKnmHThoPaPy2LUR1lpUatIxuW5jPZUcD9WeBrf2Pdsa1Xdb6Phgy3G4xLxtqwN1srzk//WnAIh9WNBDFLBaFiljZdmyZU1Hi5rbXy/N2QBfSWMMUx5vL20MmSA7NBTPXDW/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVGQIeX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVGQIeX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9057FC4CEE7;
	Fri, 17 Oct 2025 15:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714102;
	bh=YjTFRXJ2AtzaEw6+9zqQOhIMqvwwlCmL2ciaPjTLp/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVGQIeX1gSG4F7hHkyQ0uvUdyZv1xT4/I+S5As2vhwvUtIISwFSsLUnFWPNr6QV3z
	 3bXBMqDKLma0EyAloa1DPB/bHKcgtnicWF5GUcfcECaL5PCzOYcQt4HsLkl/wBhnLH
	 FHC9X47V1grZcVOM1Cow6ImFGCe/tKdz3Qi64TXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Sandoval <osandov@fb.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 003/277] arm64: map [_text, _stext) virtual address range non-executable+read-only
Date: Fri, 17 Oct 2025 16:50:10 +0200
Message-ID: <20251017145147.269871048@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Omar Sandoval <osandov@fb.com>

commit 5973a62efa34c80c9a4e5eac1fca6f6209b902af upstream.

Since the referenced fixes commit, the kernel's .text section is only
mapped starting from _stext; the region [_text, _stext) is omitted. As a
result, other vmalloc/vmap allocations may use the virtual addresses
nominally in the range [_text, _stext). This address reuse confuses
multiple things:

1. crash_prepare_elf64_headers() sets up a segment in /proc/vmcore
   mapping the entire range [_text, _end) to
   [__pa_symbol(_text), __pa_symbol(_end)). Reading an address in
   [_text, _stext) from /proc/vmcore therefore gives the incorrect
   result.
2. Tools doing symbolization (either by reading /proc/kallsyms or based
   on the vmlinux ELF file) will incorrectly identify vmalloc/vmap
   allocations in [_text, _stext) as kernel symbols.

In practice, both of these issues affect the drgn debugger.
Specifically, there were cases where the vmap IRQ stacks for some CPUs
were allocated in [_text, _stext). As a result, drgn could not get the
stack trace for a crash in an IRQ handler because the core dump
contained invalid data for the IRQ stack address. The stack addresses
were also symbolized as being in the _text symbol.

Fix this by bringing back the mapping of [_text, _stext), but now make
it non-executable and read-only. This prevents other allocations from
using it while still achieving the original goal of not mapping
unpredictable data as executable. Other than the changed protection,
this is effectively a revert of the fixes commit.

Fixes: e2a073dde921 ("arm64: omit [_text, _stext) from permanent kernel mapping")
Cc: stable@vger.kernel.org
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/pi/map_kernel.c |    6 ++++++
 arch/arm64/kernel/setup.c         |    4 ++--
 arch/arm64/mm/init.c              |    2 +-
 arch/arm64/mm/mmu.c               |   14 +++++++++-----
 4 files changed, 18 insertions(+), 8 deletions(-)

--- a/arch/arm64/kernel/pi/map_kernel.c
+++ b/arch/arm64/kernel/pi/map_kernel.c
@@ -78,6 +78,12 @@ static void __init map_kernel(u64 kaslr_
 	twopass |= enable_scs;
 	prot = twopass ? data_prot : text_prot;
 
+	/*
+	 * [_stext, _text) isn't executed after boot and contains some
+	 * non-executable, unpredictable data, so map it non-executable.
+	 */
+	map_segment(init_pg_dir, &pgdp, va_offset, _text, _stext, data_prot,
+		    false, root_level);
 	map_segment(init_pg_dir, &pgdp, va_offset, _stext, _etext, prot,
 		    !twopass, root_level);
 	map_segment(init_pg_dir, &pgdp, va_offset, __start_rodata,
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -213,7 +213,7 @@ static void __init request_standard_reso
 	unsigned long i = 0;
 	size_t res_size;
 
-	kernel_code.start   = __pa_symbol(_stext);
+	kernel_code.start   = __pa_symbol(_text);
 	kernel_code.end     = __pa_symbol(__init_begin - 1);
 	kernel_data.start   = __pa_symbol(_sdata);
 	kernel_data.end     = __pa_symbol(_end - 1);
@@ -281,7 +281,7 @@ u64 cpu_logical_map(unsigned int cpu)
 
 void __init __no_sanitize_address setup_arch(char **cmdline_p)
 {
-	setup_initial_init_mm(_stext, _etext, _edata, _end);
+	setup_initial_init_mm(_text, _etext, _edata, _end);
 
 	*cmdline_p = boot_command_line;
 
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -300,7 +300,7 @@ void __init arm64_memblock_init(void)
 	 * Register the kernel text, kernel data, initrd, and initial
 	 * pagetables with memblock.
 	 */
-	memblock_reserve(__pa_symbol(_stext), _end - _stext);
+	memblock_reserve(__pa_symbol(_text), _end - _text);
 	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && phys_initrd_size) {
 		/* the generic initrd code expects virtual addresses */
 		initrd_start = __phys_to_virt(phys_initrd_start);
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -561,8 +561,8 @@ void __init mark_linear_text_alias_ro(vo
 	/*
 	 * Remove the write permissions from the linear alias of .text/.rodata
 	 */
-	update_mapping_prot(__pa_symbol(_stext), (unsigned long)lm_alias(_stext),
-			    (unsigned long)__init_begin - (unsigned long)_stext,
+	update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
+			    (unsigned long)__init_begin - (unsigned long)_text,
 			    PAGE_KERNEL_RO);
 }
 
@@ -623,7 +623,7 @@ static inline void arm64_kfence_map_pool
 static void __init map_mem(pgd_t *pgdp)
 {
 	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
-	phys_addr_t kernel_start = __pa_symbol(_stext);
+	phys_addr_t kernel_start = __pa_symbol(_text);
 	phys_addr_t kernel_end = __pa_symbol(__init_begin);
 	phys_addr_t start, end;
 	phys_addr_t early_kfence_pool;
@@ -670,7 +670,7 @@ static void __init map_mem(pgd_t *pgdp)
 	}
 
 	/*
-	 * Map the linear alias of the [_stext, __init_begin) interval
+	 * Map the linear alias of the [_text, __init_begin) interval
 	 * as non-executable now, and remove the write permission in
 	 * mark_linear_text_alias_ro() below (which will be called after
 	 * alternative patching has completed). This makes the contents
@@ -697,6 +697,10 @@ void mark_rodata_ro(void)
 	WRITE_ONCE(rodata_is_rw, false);
 	update_mapping_prot(__pa_symbol(__start_rodata), (unsigned long)__start_rodata,
 			    section_size, PAGE_KERNEL_RO);
+	/* mark the range between _text and _stext as read only. */
+	update_mapping_prot(__pa_symbol(_text), (unsigned long)_text,
+			    (unsigned long)_stext - (unsigned long)_text,
+			    PAGE_KERNEL_RO);
 }
 
 static void __init declare_vma(struct vm_struct *vma,
@@ -767,7 +771,7 @@ static void __init declare_kernel_vmas(v
 {
 	static struct vm_struct vmlinux_seg[KERNEL_SEGMENT_COUNT];
 
-	declare_vma(&vmlinux_seg[0], _stext, _etext, VM_NO_GUARD);
+	declare_vma(&vmlinux_seg[0], _text, _etext, VM_NO_GUARD);
 	declare_vma(&vmlinux_seg[1], __start_rodata, __inittext_begin, VM_NO_GUARD);
 	declare_vma(&vmlinux_seg[2], __inittext_begin, __inittext_end, VM_NO_GUARD);
 	declare_vma(&vmlinux_seg[3], __initdata_begin, __initdata_end, VM_NO_GUARD);


