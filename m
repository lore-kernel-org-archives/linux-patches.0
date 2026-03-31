Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D8F3F7867;
	Tue, 31 Mar 2026 16:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976096; cv=none; b=ZOoY02hl+UMgyQBV4Myu2w3p2YS4LRmlulTFXVshs2fM+KMlgcAf0x98Fh+/9d7AGBF7d7ZY0hTVlEHWqmj4hiOW6pTqykfwMXiRO4foDoyWJil/9qNQRrO26iB+5VOeJTMFTMF2N8hxvZvRwC6brDtiY+a+CoVvydrsMmk9hTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976096; c=relaxed/simple;
	bh=AaJC0taeB7rOZ3yr/JIrjRjZxq2szyHWF32yQPnqnP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jo/CjMbV5cIzxPzJUV+iDGUyBePiu5dJOPtWCCaWC7HAorDbhW7NlM9T35xiqlEJIJYNSlr9I+bKJULZhCVPu5tI41kTdQwTsyswa9/5StWvsAbRNt9AeJVxitnx1o55QfaOKnHL3b69rQb4u7tI5KSeeM8YDDv911K9O4YjpA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drI6aNn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drI6aNn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31365C19423;
	Tue, 31 Mar 2026 16:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976096;
	bh=AaJC0taeB7rOZ3yr/JIrjRjZxq2szyHWF32yQPnqnP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drI6aNn3sYdSqJVsseW+cdvoePQcxLHS1rtXKa/k9U+3aKh7BJNCmBvw7UgBdxaAz
	 IYRNMB2/YGaiOqfmnPCcKUOY/Bqu6ZXr8tRPT2Ihfq8TkPGDUlTpKjgJ01ptUMJI9S
	 U+C/+QxyinqE0rN8Jn1h61slM5dfuWr6KhKuCkBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 204/244] LoongArch: vDSO: Emit GNU_EH_FRAME correctly
Date: Tue, 31 Mar 2026 18:22:34 +0200
Message-ID: <20260331161749.285158688@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Xi Ruoyao <xry111@xry111.site>

commit e4878c37f6679fdea91b27a0f4e60a871f0b7bad upstream.

With -fno-asynchronous-unwind-tables and --no-eh-frame-hdr (the default
of the linker), the GNU_EH_FRAME segment (specified by vdso.lds.S) is
empty.  This is not valid, as the current DWARF specification mandates
the first byte of the EH frame to be the version number 1.  It causes
some unwinders to complain, for example the ClickHouse query profiler
spams the log with messages:

    clickhouse-server[365854]: libunwind: unsupported .eh_frame_hdr
    version: 127 at 7ffffffb0000

Here "127" is just the byte located at the p_vaddr (0, i.e. the
beginning of the vDSO) of the empty GNU_EH_FRAME segment. Cross-
checking with /proc/365854/maps has also proven 7ffffffb0000 is the
start of vDSO in the process VM image.

In LoongArch the -fno-asynchronous-unwind-tables option seems just a
MIPS legacy, and MIPS only uses this option to satisfy the MIPS-specific
"genvdso" program, per the commit cfd75c2db17e ("MIPS: VDSO: Explicitly
use -fno-asynchronous-unwind-tables").  IIRC it indicates some inherent
limitation of the MIPS ELF ABI and has nothing to do with LoongArch.  So
we can simply flip it over to -fasynchronous-unwind-tables and pass
--eh-frame-hdr for linking the vDSO, allowing the profilers to unwind the
stack for statistics even if the sample point is taken when the PC is in
the vDSO.

However simply adjusting the options above would exploit an issue: when
the libgcc unwinder saw the invalid GNU_EH_FRAME segment, it silently
falled back to a machine-specific routine to match the code pattern of
rt_sigreturn() and extract the registers saved in the sigframe if the
code pattern is matched.  As unwinding from signal handlers is vital for
libgcc to support pthread cancellation etc., the fall-back routine had
been silently keeping the LoongArch Linux systems functioning since
Linux 5.19.  But when we start to emit GNU_EH_FRAME with the correct
format, fall-back routine will no longer be used and libgcc will fail
to unwind the sigframe, and unwinding from signal handlers will no
longer work, causing dozens of glibc test failures.  To make it possible
to unwind from signal handlers again, it's necessary to code the unwind
info in __vdso_rt_sigreturn via .cfi_* directives.

The offsets in the .cfi_* directives depend on the layout of struct
sigframe, notably the offset of sigcontext in the sigframe.  To use the
offset in the assembly file, factor out struct sigframe into a header to
allow asm-offsets.c to output the offset for assembly.

To work around a long-term issue in the libgcc unwinder (the pc is
unconditionally substracted by 1: doing so is technically incorrect for
a signal frame), a nop instruction is included with the two real
instructions in __vdso_rt_sigreturn in the same FDE PC range.  The same
hack has been used on x86 for a long time.

Cc: stable@vger.kernel.org
Fixes: c6b99bed6b8f ("LoongArch: Add VDSO and VSYSCALL support")
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/linkage.h  |   36 ++++++++++++++++++++++++++++++++++
 arch/loongarch/include/asm/sigframe.h |    9 ++++++++
 arch/loongarch/kernel/asm-offsets.c   |    2 +
 arch/loongarch/kernel/signal.c        |    6 -----
 arch/loongarch/vdso/Makefile          |    4 +--
 arch/loongarch/vdso/sigreturn.S       |    6 ++---
 6 files changed, 53 insertions(+), 10 deletions(-)
 create mode 100644 arch/loongarch/include/asm/sigframe.h

--- a/arch/loongarch/include/asm/linkage.h
+++ b/arch/loongarch/include/asm/linkage.h
@@ -41,4 +41,40 @@
 	.cfi_endproc;					\
 	SYM_END(name, SYM_T_NONE)
 
+/*
+ * This is for the signal handler trampoline, which is used as the return
+ * address of the signal handlers in userspace instead of called normally.
+ * The long standing libgcc bug https://gcc.gnu.org/PR124050 requires a
+ * nop between .cfi_startproc and the actual address of the trampoline, so
+ * we cannot simply use SYM_FUNC_START.
+ *
+ * This wrapper also contains all the .cfi_* directives for recovering
+ * the content of the GPRs and the "return address" (where the rt_sigreturn
+ * syscall will jump to), assuming there is a struct rt_sigframe (where
+ * a struct sigcontext containing those information we need to recover) at
+ * $sp.  The "DWARF for the LoongArch(TM) Architecture" manual states
+ * column 0 is for $zero, but it does not make too much sense to
+ * save/restore the hardware zero register.  Repurpose this column here
+ * for the return address (here it's not the content of $ra we cannot use
+ * the default column 3).
+ */
+#define SYM_SIGFUNC_START(name)				\
+	.cfi_startproc;					\
+	.cfi_signal_frame;				\
+	.cfi_def_cfa 3, RT_SIGFRAME_SC;			\
+	.cfi_return_column 0;				\
+	.cfi_offset 0, SC_PC;				\
+							\
+	.irp num, 1,  2,  3,  4,  5,  6,  7,  8, 	\
+		  9,  10, 11, 12, 13, 14, 15, 16,	\
+		  17, 18, 19, 20, 21, 22, 23, 24,	\
+		  25, 26, 27, 28, 29, 30, 31;		\
+	.cfi_offset \num, SC_REGS + \num * SZREG;	\
+	.endr;						\
+							\
+	nop;						\
+	SYM_START(name, SYM_L_GLOBAL, SYM_A_ALIGN)
+
+#define SYM_SIGFUNC_END(name) SYM_FUNC_END(name)
+
 #endif
--- /dev/null
+++ b/arch/loongarch/include/asm/sigframe.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#include <asm/siginfo.h>
+#include <asm/ucontext.h>
+
+struct rt_sigframe {
+	struct siginfo rs_info;
+	struct ucontext rs_uctx;
+};
--- a/arch/loongarch/kernel/asm-offsets.c
+++ b/arch/loongarch/kernel/asm-offsets.c
@@ -16,6 +16,7 @@
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 #include <asm/ftrace.h>
+#include <asm/sigframe.h>
 
 static void __used output_ptreg_defines(void)
 {
@@ -219,6 +220,7 @@ static void __used output_sc_defines(voi
 	COMMENT("Linux sigcontext offsets.");
 	OFFSET(SC_REGS, sigcontext, sc_regs);
 	OFFSET(SC_PC, sigcontext, sc_pc);
+	OFFSET(RT_SIGFRAME_SC, rt_sigframe, rs_uctx.uc_mcontext);
 	BLANK();
 }
 
--- a/arch/loongarch/kernel/signal.c
+++ b/arch/loongarch/kernel/signal.c
@@ -35,6 +35,7 @@
 #include <asm/cpu-features.h>
 #include <asm/fpu.h>
 #include <asm/lbt.h>
+#include <asm/sigframe.h>
 #include <asm/ucontext.h>
 #include <asm/vdso.h>
 
@@ -51,11 +52,6 @@
 #define lock_lbt_owner()	({ preempt_disable(); pagefault_disable(); })
 #define unlock_lbt_owner()	({ pagefault_enable(); preempt_enable(); })
 
-struct rt_sigframe {
-	struct siginfo rs_info;
-	struct ucontext rs_uctx;
-};
-
 struct _ctx_layout {
 	struct sctx_info *addr;
 	unsigned int size;
--- a/arch/loongarch/vdso/Makefile
+++ b/arch/loongarch/vdso/Makefile
@@ -21,7 +21,7 @@ cflags-vdso := $(ccflags-vdso) \
 	$(filter -W%,$(filter-out -Wa$(comma)%,$(KBUILD_CFLAGS))) \
 	-std=gnu11 -O2 -g -fno-strict-aliasing -fno-common -fno-builtin \
 	-fno-stack-protector -fno-jump-tables -DDISABLE_BRANCH_PROFILING \
-	$(call cc-option, -fno-asynchronous-unwind-tables) \
+	$(call cc-option, -fasynchronous-unwind-tables) \
 	$(call cc-option, -fno-stack-protector)
 aflags-vdso := $(ccflags-vdso) \
 	-D__ASSEMBLY__ -Wa,-gdwarf-2
@@ -36,7 +36,7 @@ endif
 
 # VDSO linker flags.
 ldflags-y := -Bsymbolic --no-undefined -soname=linux-vdso.so.1 \
-	$(filter -E%,$(KBUILD_CFLAGS)) -shared --build-id -T
+	$(filter -E%,$(KBUILD_CFLAGS)) -shared --build-id --eh-frame-hdr -T
 
 #
 # Shared build commands.
--- a/arch/loongarch/vdso/sigreturn.S
+++ b/arch/loongarch/vdso/sigreturn.S
@@ -12,13 +12,13 @@
 
 #include <asm/regdef.h>
 #include <asm/asm.h>
+#include <asm/asm-offsets.h>
 
 	.section	.text
-	.cfi_sections	.debug_frame
 
-SYM_FUNC_START(__vdso_rt_sigreturn)
+SYM_SIGFUNC_START(__vdso_rt_sigreturn)
 
 	li.w	a7, __NR_rt_sigreturn
 	syscall	0
 
-SYM_FUNC_END(__vdso_rt_sigreturn)
+SYM_SIGFUNC_END(__vdso_rt_sigreturn)


