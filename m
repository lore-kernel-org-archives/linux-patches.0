Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEA0297B95;
	Mon, 12 May 2025 18:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073167; cv=none; b=ErODJpPBKXHk7njQZu140QRz3bxU1Bco/o9yRuRRBBpwFSwKR4hbn1XHbp5SLH3gWgiHkDExGVgz62YLnqyGN15Sxsz69Vcdogzn4gfaz6DaQXhkfTnq17WrzuEBpbS8UQsAJEtqrV5Jg58PTbCeQ2/XdldaX4qwDctNaPnKsKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073167; c=relaxed/simple;
	bh=smo7jymqNOdM4rwGbc6k2kMkoSm7fNDrFkUjcHuypUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5kFhqsabfghX8GXx9vHzJt7wM+fzp5aUlGsp1cXfuI0QmVGs9LLy46cRdv7g98pxkT5PPvEQsS03bn+FY8eZIUgFpO5zu931KxtZWOYZS+SmtML7MtCxtGpGjWRrXwsAvJXw94svSGYY4293wd1MuryfdLcbMbns2USZpelpcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DlcGmjh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DlcGmjh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E8EC4CEE7;
	Mon, 12 May 2025 18:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073166;
	bh=smo7jymqNOdM4rwGbc6k2kMkoSm7fNDrFkUjcHuypUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DlcGmjh8svjUx+Yvj2xrW8efKulqhBnDVB1RLBiSjMVURPyTDd9v+6EHdRnVlhR1l
	 klJKC+9sgnF6UZgbST/j6e4h9MbsjzcMQZ86iPtSdyUfRxN15Raba+FkOEua1AQagi
	 80TSfTJVsWFkMKBmgrT4vT6hDU+Ytvn95qzQ1v08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.12 176/184] x86/its: Add support for ITS-safe indirect thunk
Date: Mon, 12 May 2025 19:46:17 +0200
Message-ID: <20250512172048.973911437@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 8754e67ad4ac692c67ff1f99c0d07156f04ae40c upstream.

Due to ITS, indirect branches in the lower half of a cacheline may be
vulnerable to branch target injection attack.

Introduce ITS-safe thunks to patch indirect branches in the lower half of
cacheline with the thunk. Also thunk any eBPF generated indirect branches
in emit_indirect_jump().

Below category of indirect branches are not mitigated:

- Indirect branches in the .init section are not mitigated because they are
  discarded after boot.
- Indirect branches that are explicitly marked retpoline-safe.

Note that retpoline also mitigates the indirect branches against ITS. This
is because the retpoline sequence fills an RSB entry before RET, and it
does not suffer from RSB-underflow part of the ITS.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig                     |   11 ++++++++
 arch/x86/include/asm/cpufeatures.h   |    1 
 arch/x86/include/asm/nospec-branch.h |    4 +++
 arch/x86/kernel/alternative.c        |   45 ++++++++++++++++++++++++++++++++---
 arch/x86/kernel/vmlinux.lds.S        |    6 ++++
 arch/x86/lib/retpoline.S             |   28 +++++++++++++++++++++
 arch/x86/net/bpf_jit_comp.c          |    5 +++
 7 files changed, 96 insertions(+), 4 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2747,6 +2747,17 @@ config MITIGATION_SSB
 	  of speculative execution in a similar way to the Meltdown and Spectre
 	  security vulnerabilities.
 
+config MITIGATION_ITS
+	bool "Enable Indirect Target Selection mitigation"
+	depends on CPU_SUP_INTEL && X86_64
+	depends on MITIGATION_RETPOLINE && MITIGATION_RETHUNK
+	default y
+	help
+	  Enable Indirect Target Selection (ITS) mitigation. ITS is a bug in
+	  BPU on some Intel CPUs that may allow Spectre V2 style attacks. If
+	  disabled, mitigation cannot be enabled via cmdline.
+	  See <file:Documentation/admin-guide/hw-vuln/indirect-target-selection.rst>
+
 endif
 
 config ARCH_HAS_ADD_PAGES
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -475,6 +475,7 @@
 #define X86_FEATURE_CLEAR_BHB_HW	(21*32+ 3) /* BHI_DIS_S HW control enabled */
 #define X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT (21*32+ 4) /* Clear branch history at vmexit using SW loop */
 #define X86_FEATURE_FAST_CPPC		(21*32 + 5) /* AMD Fast CPPC */
+#define X86_FEATURE_INDIRECT_THUNK_ITS	(21*32 + 6) /* Use thunk for indirect branches in lower half of cacheline */
 
 /*
  * BUG word(s)
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -355,10 +355,14 @@
 	".long 999b\n\t"					\
 	".popsection\n\t"
 
+#define ITS_THUNK_SIZE	64
+
 typedef u8 retpoline_thunk_t[RETPOLINE_THUNK_SIZE];
+typedef u8 its_thunk_t[ITS_THUNK_SIZE];
 extern retpoline_thunk_t __x86_indirect_thunk_array[];
 extern retpoline_thunk_t __x86_indirect_call_thunk_array[];
 extern retpoline_thunk_t __x86_indirect_jump_thunk_array[];
+extern its_thunk_t	 __x86_indirect_its_thunk_array[];
 
 #ifdef CONFIG_MITIGATION_RETHUNK
 extern void __x86_return_thunk(void);
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -581,7 +581,8 @@ static int emit_indirect(int op, int reg
 	return i;
 }
 
-static int emit_call_track_retpoline(void *addr, struct insn *insn, int reg, u8 *bytes)
+static int __emit_trampoline(void *addr, struct insn *insn, u8 *bytes,
+			     void *call_dest, void *jmp_dest)
 {
 	u8 op = insn->opcode.bytes[0];
 	int i = 0;
@@ -602,7 +603,7 @@ static int emit_call_track_retpoline(voi
 	switch (op) {
 	case CALL_INSN_OPCODE:
 		__text_gen_insn(bytes+i, op, addr+i,
-				__x86_indirect_call_thunk_array[reg],
+				call_dest,
 				CALL_INSN_SIZE);
 		i += CALL_INSN_SIZE;
 		break;
@@ -610,7 +611,7 @@ static int emit_call_track_retpoline(voi
 	case JMP32_INSN_OPCODE:
 clang_jcc:
 		__text_gen_insn(bytes+i, op, addr+i,
-				__x86_indirect_jump_thunk_array[reg],
+				jmp_dest,
 				JMP32_INSN_SIZE);
 		i += JMP32_INSN_SIZE;
 		break;
@@ -625,6 +626,35 @@ clang_jcc:
 	return i;
 }
 
+static int emit_call_track_retpoline(void *addr, struct insn *insn, int reg, u8 *bytes)
+{
+	return __emit_trampoline(addr, insn, bytes,
+				 __x86_indirect_call_thunk_array[reg],
+				 __x86_indirect_jump_thunk_array[reg]);
+}
+
+#ifdef CONFIG_MITIGATION_ITS
+static int emit_its_trampoline(void *addr, struct insn *insn, int reg, u8 *bytes)
+{
+	return __emit_trampoline(addr, insn, bytes,
+				 __x86_indirect_its_thunk_array[reg],
+				 __x86_indirect_its_thunk_array[reg]);
+}
+
+/* Check if an indirect branch is at ITS-unsafe address */
+static bool cpu_wants_indirect_its_thunk_at(unsigned long addr, int reg)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_INDIRECT_THUNK_ITS))
+		return false;
+
+	/* Indirect branch opcode is 2 or 3 bytes depending on reg */
+	addr += 1 + reg / 8;
+
+	/* Lower-half of the cacheline? */
+	return !(addr & 0x20);
+}
+#endif
+
 /*
  * Rewrite the compiler generated retpoline thunk calls.
  *
@@ -699,6 +729,15 @@ static int patch_retpoline(void *addr, s
 		bytes[i++] = 0xe8; /* LFENCE */
 	}
 
+#ifdef CONFIG_MITIGATION_ITS
+	/*
+	 * Check if the address of last byte of emitted-indirect is in
+	 * lower-half of the cacheline. Such branches need ITS mitigation.
+	 */
+	if (cpu_wants_indirect_its_thunk_at((unsigned long)addr + i, reg))
+		return emit_its_trampoline(addr, insn, reg, bytes);
+#endif
+
 	ret = emit_indirect(op, reg, bytes + i);
 	if (ret < 0)
 		return ret;
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -530,4 +530,10 @@ INIT_PER_CPU(irq_stack_backing_store);
 		"SRSO function pair won't alias");
 #endif
 
+#if defined(CONFIG_MITIGATION_ITS) && !defined(CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B)
+. = ASSERT(__x86_indirect_its_thunk_rax & 0x20, "__x86_indirect_thunk_rax not in second half of cacheline");
+. = ASSERT(((__x86_indirect_its_thunk_rcx - __x86_indirect_its_thunk_rax) % 64) == 0, "Indirect thunks are not cacheline apart");
+. = ASSERT(__x86_indirect_its_thunk_array == __x86_indirect_its_thunk_rax, "Gap in ITS thunk array");
+#endif
+
 #endif /* CONFIG_X86_64 */
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -366,6 +366,34 @@ SYM_FUNC_END(call_depth_return_thunk)
 
 #endif /* CONFIG_MITIGATION_CALL_DEPTH_TRACKING */
 
+#ifdef CONFIG_MITIGATION_ITS
+
+.macro ITS_THUNK reg
+
+SYM_INNER_LABEL(__x86_indirect_its_thunk_\reg, SYM_L_GLOBAL)
+	UNWIND_HINT_UNDEFINED
+	ANNOTATE_NOENDBR
+	ANNOTATE_RETPOLINE_SAFE
+	jmp *%\reg
+	int3
+	.align 32, 0xcc		/* fill to the end of the line */
+	.skip  32, 0xcc		/* skip to the next upper half */
+.endm
+
+/* ITS mitigation requires thunks be aligned to upper half of cacheline */
+.align 64, 0xcc
+.skip 32, 0xcc
+SYM_CODE_START(__x86_indirect_its_thunk_array)
+
+#define GEN(reg) ITS_THUNK reg
+#include <asm/GEN-for-each-reg.h>
+#undef GEN
+
+	.align 64, 0xcc
+SYM_CODE_END(__x86_indirect_its_thunk_array)
+
+#endif
+
 /*
  * This function name is magical and is used by -mfunction-return=thunk-extern
  * for the compiler to generate JMPs to it.
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -639,7 +639,10 @@ static void emit_indirect_jump(u8 **ppro
 {
 	u8 *prog = *pprog;
 
-	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE)) {
+	if (cpu_feature_enabled(X86_FEATURE_INDIRECT_THUNK_ITS)) {
+		OPTIMIZER_HIDE_VAR(reg);
+		emit_jump(&prog, &__x86_indirect_its_thunk_array[reg], ip);
+	} else if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE)) {
 		EMIT_LFENCE();
 		EMIT2(0xFF, 0xE0 + reg);
 	} else if (cpu_feature_enabled(X86_FEATURE_RETPOLINE)) {


