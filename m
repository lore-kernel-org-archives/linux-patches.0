Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689C412B72;
	Tue, 16 Jul 2024 15:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144806; cv=none; b=gQ0U2VXlPLLGx62EFAitMfab7WAnUaCf0VxQCOk94iBCWPS/8r6bg+AXX65BiCa9IVZEzHi/yHNZkP0TETYoKsjonU1rpBlBBKpvqnNnYiy7YqG4CMS6qlWMXNgVXUMitqdVbw73m2TASFw60EaJ18DssWGjoz10VOfM/fZIGac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144806; c=relaxed/simple;
	bh=tsFrQN7rwfn7fqv7qapKsIXr3AFRyXGHeA2pQC8wI2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3HeiNRiwCDaulT+YBg15qm3QTvf41Ev6EW2Ovhobn4+BhHyY67PjCevMh0lTWPLg8PtE6Xwg8Eqzrji0ZfevtD3CkOC/O8QOupAAmJfzYDar1fbe+p1pGGzxLx0cwfYz85wJGpiA6GU3pBYqi8UWrpSAdSElfE03ULhNHL1uzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fiwy5TBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fiwy5TBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E386FC116B1;
	Tue, 16 Jul 2024 15:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144806;
	bh=tsFrQN7rwfn7fqv7qapKsIXr3AFRyXGHeA2pQC8wI2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fiwy5TBtrJtqX5tkiHhjOJt8sbyg480t8sjW/J0sAFo9pO6AHjwLVmITY0xQQGTQH
	 U1vxHmmiFC0MapfrrkEosdcTyl5UNHkUNQD9uWXOfEpBCkjyR81cxUdRgYQ+agp3Vu
	 4+s4cI5uLNwiG35+E3SaLaCNvHPiY9WvFwtF/ZdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Russell King <russell.king@oracle.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alan Maguire <alan.maguire@oracle.com>,
	Puranjay Mohan <pjy@amazon.com>
Subject: [PATCH 5.10 100/108] arm64/bpf: Remove 128MB limit for BPF JIT programs
Date: Tue, 16 Jul 2024 17:31:55 +0200
Message-ID: <20240716152749.834677594@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <russell.king@oracle.com>

commit b89ddf4cca43f1269093942cf5c4e457fd45c335 upstream.

Commit 91fc957c9b1d ("arm64/bpf: don't allocate BPF JIT programs in module
memory") restricts BPF JIT program allocation to a 128MB region to ensure
BPF programs are still in branching range of each other. However this
restriction should not apply to the aarch64 JIT, since BPF_JMP | BPF_CALL
are implemented as a 64-bit move into a register and then a BLR instruction -
which has the effect of being able to call anything without proximity
limitation.

The practical reason to relax this restriction on JIT memory is that 128MB of
JIT memory can be quickly exhausted, especially where PAGE_SIZE is 64KB - one
page is needed per program. In cases where seccomp filters are applied to
multiple VMs on VM launch - such filters are classic BPF but converted to
BPF - this can severely limit the number of VMs that can be launched. In a
world where we support BPF JIT always on, turning off the JIT isn't always an
option either.

Fixes: 91fc957c9b1d ("arm64/bpf: don't allocate BPF JIT programs in module memory")
Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Russell King <russell.king@oracle.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/bpf/1636131046-5982-2-git-send-email-alan.maguire@oracle.com
[Replace usage of in_bpf_jit() with is_bpf_text_address()]
Signed-off-by: Puranjay Mohan <pjy@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/extable.h |    9 ---------
 arch/arm64/include/asm/memory.h  |    5 +----
 arch/arm64/kernel/traps.c        |    2 +-
 arch/arm64/mm/extable.c          |    3 ++-
 arch/arm64/mm/ptdump.c           |    2 --
 arch/arm64/net/bpf_jit_comp.c    |    7 ++-----
 6 files changed, 6 insertions(+), 22 deletions(-)

--- a/arch/arm64/include/asm/extable.h
+++ b/arch/arm64/include/asm/extable.h
@@ -22,15 +22,6 @@ struct exception_table_entry
 
 #define ARCH_HAS_RELATIVE_EXTABLE
 
-static inline bool in_bpf_jit(struct pt_regs *regs)
-{
-	if (!IS_ENABLED(CONFIG_BPF_JIT))
-		return false;
-
-	return regs->pc >= BPF_JIT_REGION_START &&
-	       regs->pc < BPF_JIT_REGION_END;
-}
-
 #ifdef CONFIG_BPF_JIT
 int arm64_bpf_fixup_exception(const struct exception_table_entry *ex,
 			      struct pt_regs *regs);
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -44,11 +44,8 @@
 #define _PAGE_OFFSET(va)	(-(UL(1) << (va)))
 #define PAGE_OFFSET		(_PAGE_OFFSET(VA_BITS))
 #define KIMAGE_VADDR		(MODULES_END)
-#define BPF_JIT_REGION_START	(KASAN_SHADOW_END)
-#define BPF_JIT_REGION_SIZE	(SZ_128M)
-#define BPF_JIT_REGION_END	(BPF_JIT_REGION_START + BPF_JIT_REGION_SIZE)
 #define MODULES_END		(MODULES_VADDR + MODULES_VSIZE)
-#define MODULES_VADDR		(BPF_JIT_REGION_END)
+#define MODULES_VADDR		(_PAGE_END(VA_BITS_MIN))
 #define MODULES_VSIZE		(SZ_128M)
 #define VMEMMAP_START		(-VMEMMAP_SIZE - SZ_2M)
 #define VMEMMAP_END		(VMEMMAP_START + VMEMMAP_SIZE)
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -912,7 +912,7 @@ static struct break_hook bug_break_hook
 static int reserved_fault_handler(struct pt_regs *regs, unsigned int esr)
 {
 	pr_err("%s generated an invalid instruction at %pS!\n",
-		in_bpf_jit(regs) ? "BPF JIT" : "Kernel text patching",
+		"Kernel text patching",
 		(void *)instruction_pointer(regs));
 
 	/* We cannot handle this */
--- a/arch/arm64/mm/extable.c
+++ b/arch/arm64/mm/extable.c
@@ -5,6 +5,7 @@
 
 #include <linux/extable.h>
 #include <linux/uaccess.h>
+#include <linux/filter.h>
 
 int fixup_exception(struct pt_regs *regs)
 {
@@ -14,7 +15,7 @@ int fixup_exception(struct pt_regs *regs
 	if (!fixup)
 		return 0;
 
-	if (in_bpf_jit(regs))
+	if (is_bpf_text_address(regs->pc))
 		return arm64_bpf_fixup_exception(fixup, regs);
 
 	regs->pc = (unsigned long)&fixup->fixup + fixup->fixup;
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -41,8 +41,6 @@ static struct addr_marker address_marker
 	{ 0 /* KASAN_SHADOW_START */,	"Kasan shadow start" },
 	{ KASAN_SHADOW_END,		"Kasan shadow end" },
 #endif
-	{ BPF_JIT_REGION_START,		"BPF start" },
-	{ BPF_JIT_REGION_END,		"BPF end" },
 	{ MODULES_VADDR,		"Modules start" },
 	{ MODULES_END,			"Modules end" },
 	{ VMALLOC_START,		"vmalloc() area" },
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1145,15 +1145,12 @@ out:
 
 u64 bpf_jit_alloc_exec_limit(void)
 {
-	return BPF_JIT_REGION_SIZE;
+	return VMALLOC_END - VMALLOC_START;
 }
 
 void *bpf_jit_alloc_exec(unsigned long size)
 {
-	return __vmalloc_node_range(size, PAGE_SIZE, BPF_JIT_REGION_START,
-				    BPF_JIT_REGION_END, GFP_KERNEL,
-				    PAGE_KERNEL, 0, NUMA_NO_NODE,
-				    __builtin_return_address(0));
+	return vmalloc(size);
 }
 
 void bpf_jit_free_exec(void *addr)


