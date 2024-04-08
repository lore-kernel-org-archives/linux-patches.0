Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC4C82D7F;
	Mon,  8 Apr 2024 13:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582416; cv=none; b=kv0+aTwrgJfcwulIBzOooUWbwikqLYta8Lhs2l0HDI8vk8Qp54K6UTE1MD6LWH0IyyMPduezjFo+69yYsMtKGTHLRMGdPyMZpicOdqSSOoogStDOae84dHflWrB7/d6GuwuOxGrij5m21LVpd4KeaChOl//H+puH80cYUle84iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582416; c=relaxed/simple;
	bh=Bq64CYr4mhcnQZ9DdlN4HE3eOmsYmGvetxG5S45GFkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzWuegjwcwMGFdh5C8GL66CTZt0x1CWD5ybovr6Y/U5quP/caHJ5bPFx4+BmhdzhYrrL+QaQcW4j3+mG6EbUiQ5a1evIaYR7BZPVVUOzvv1D+t01aCNG24GzJ9muSqdKEWwpFsTHW8xJyJQJHJCHRPLkmtmsR0MpAraWW6BNtLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2M3EgEe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2M3EgEe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFCDC433C7;
	Mon,  8 Apr 2024 13:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582416;
	bh=Bq64CYr4mhcnQZ9DdlN4HE3eOmsYmGvetxG5S45GFkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2M3EgEe5ufEHCEC+9BcVp4StpimumYbQL9+ywcxhQ+x7ZqgPutlSWqixbWuJaWZLi
	 30gKJikOITVHRT+kvnYw2LxQIRrvVE0CURcVUu8PsQSzh2fXmKVNxxVcD1l36fzu6+
	 GFeSkhIf+yFLMaG/+XUD5fLdXj/UGfIbtweK2DYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 091/252] x86/srso: Disentangle rethunk-dependent options
Date: Mon,  8 Apr 2024 14:56:30 +0200
Message-ID: <20240408125309.479400550@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

Commit 34a3cae7474c6e6f4a85aad4a7b8191b8b35cdcd upstream.

CONFIG_RETHUNK, CONFIG_CPU_UNRET_ENTRY and CONFIG_CPU_SRSO are all
tangled up.  De-spaghettify the code a bit.

Some of the rethunk-related code has been shuffled around within the
'.text..__x86.return_thunk' section, but otherwise there are no
functional changes.  srso_alias_untrain_ret() and srso_alias_safe_ret()
((which are very address-sensitive) haven't moved.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/2845084ed303d8384905db3b87b77693945302b4.1693889988.git.jpoimboe@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   25 +++--
 arch/x86/kernel/cpu/bugs.c           |    5 -
 arch/x86/kernel/vmlinux.lds.S        |    7 -
 arch/x86/lib/retpoline.S             |  158 +++++++++++++++++++----------------
 4 files changed, 109 insertions(+), 86 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -289,19 +289,17 @@
  * where we have a stack but before any RET instruction.
  */
 .macro UNTRAIN_RET
-#if defined(CONFIG_CPU_UNRET_ENTRY) || defined(CONFIG_CPU_IBPB_ENTRY) || \
-	defined(CONFIG_CALL_DEPTH_TRACKING) || defined(CONFIG_CPU_SRSO)
+#if defined(CONFIG_RETHUNK) || defined(CONFIG_CPU_IBPB_ENTRY)
 	VALIDATE_UNRET_END
 	ALTERNATIVE_3 "",						\
 		      CALL_UNTRAIN_RET, X86_FEATURE_UNRET,		\
 		      "call entry_ibpb", X86_FEATURE_ENTRY_IBPB,	\
-		      __stringify(RESET_CALL_DEPTH), X86_FEATURE_CALL_DEPTH
+		     __stringify(RESET_CALL_DEPTH), X86_FEATURE_CALL_DEPTH
 #endif
 .endm
 
 .macro UNTRAIN_RET_VM
-#if defined(CONFIG_CPU_UNRET_ENTRY) || defined(CONFIG_CPU_IBPB_ENTRY) || \
-	defined(CONFIG_CALL_DEPTH_TRACKING) || defined(CONFIG_CPU_SRSO)
+#if defined(CONFIG_RETHUNK) || defined(CONFIG_CPU_IBPB_ENTRY)
 	VALIDATE_UNRET_END
 	ALTERNATIVE_3 "",						\
 		      CALL_UNTRAIN_RET, X86_FEATURE_UNRET,		\
@@ -311,8 +309,7 @@
 .endm
 
 .macro UNTRAIN_RET_FROM_CALL
-#if defined(CONFIG_CPU_UNRET_ENTRY) || defined(CONFIG_CPU_IBPB_ENTRY) || \
-	defined(CONFIG_CALL_DEPTH_TRACKING) || defined(CONFIG_CPU_SRSO)
+#if defined(CONFIG_RETHUNK) || defined(CONFIG_CPU_IBPB_ENTRY)
 	VALIDATE_UNRET_END
 	ALTERNATIVE_3 "",						\
 		      CALL_UNTRAIN_RET, X86_FEATURE_UNRET,		\
@@ -359,6 +356,20 @@ extern void __x86_return_thunk(void);
 static inline void __x86_return_thunk(void) {}
 #endif
 
+#ifdef CONFIG_CPU_UNRET_ENTRY
+extern void retbleed_return_thunk(void);
+#else
+static inline void retbleed_return_thunk(void) {}
+#endif
+
+#ifdef CONFIG_CPU_SRSO
+extern void srso_return_thunk(void);
+extern void srso_alias_return_thunk(void);
+#else
+static inline void srso_return_thunk(void) {}
+static inline void srso_alias_return_thunk(void) {}
+#endif
+
 extern void retbleed_return_thunk(void);
 extern void srso_return_thunk(void);
 extern void srso_alias_return_thunk(void);
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -63,7 +63,7 @@ EXPORT_SYMBOL_GPL(x86_pred_cmd);
 
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
-void (*x86_return_thunk)(void) __ro_after_init = &__x86_return_thunk;
+void (*x86_return_thunk)(void) __ro_after_init = __x86_return_thunk;
 
 /* Update SPEC_CTRL MSR and its cached copy unconditionally */
 static void update_spec_ctrl(u64 val)
@@ -1108,8 +1108,7 @@ do_cmd_auto:
 		setup_force_cpu_cap(X86_FEATURE_RETHUNK);
 		setup_force_cpu_cap(X86_FEATURE_UNRET);
 
-		if (IS_ENABLED(CONFIG_RETHUNK))
-			x86_return_thunk = retbleed_return_thunk;
+		x86_return_thunk = retbleed_return_thunk;
 
 		if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
 		    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -139,10 +139,7 @@ SECTIONS
 		STATIC_CALL_TEXT
 
 		ALIGN_ENTRY_TEXT_BEGIN
-#ifdef CONFIG_CPU_SRSO
 		*(.text..__x86.rethunk_untrain)
-#endif
-
 		ENTRY_TEXT
 
 #ifdef CONFIG_CPU_SRSO
@@ -520,12 +517,12 @@ INIT_PER_CPU(irq_stack_backing_store);
            "fixed_percpu_data is not at start of per-cpu area");
 #endif
 
-#ifdef CONFIG_RETHUNK
+#ifdef CONFIG_CPU_UNRET_ENTRY
 . = ASSERT((retbleed_return_thunk & 0x3f) == 0, "retbleed_return_thunk not cacheline-aligned");
-. = ASSERT((srso_safe_ret & 0x3f) == 0, "srso_safe_ret not cacheline-aligned");
 #endif
 
 #ifdef CONFIG_CPU_SRSO
+. = ASSERT((srso_safe_ret & 0x3f) == 0, "srso_safe_ret not cacheline-aligned");
 /*
  * GNU ld cannot do XOR until 2.41.
  * https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=f6f78318fca803c4907fb8d7f6ded8295f1947b1
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -126,12 +126,13 @@ SYM_CODE_END(__x86_indirect_jump_thunk_a
 #include <asm/GEN-for-each-reg.h>
 #undef GEN
 #endif
-/*
- * This function name is magical and is used by -mfunction-return=thunk-extern
- * for the compiler to generate JMPs to it.
- */
+
 #ifdef CONFIG_RETHUNK
 
+	.section .text..__x86.return_thunk
+
+#ifdef CONFIG_CPU_SRSO
+
 /*
  * srso_alias_untrain_ret() and srso_alias_safe_ret() are placed at
  * special addresses:
@@ -147,9 +148,7 @@ SYM_CODE_END(__x86_indirect_jump_thunk_a
  *
  * As a result, srso_alias_safe_ret() becomes a safe return.
  */
-#ifdef CONFIG_CPU_SRSO
-	.section .text..__x86.rethunk_untrain
-
+	.pushsection .text..__x86.rethunk_untrain
 SYM_START(srso_alias_untrain_ret, SYM_L_GLOBAL, SYM_A_NONE)
 	UNWIND_HINT_FUNC
 	ANNOTATE_NOENDBR
@@ -158,17 +157,9 @@ SYM_START(srso_alias_untrain_ret, SYM_L_
 	jmp srso_alias_return_thunk
 SYM_FUNC_END(srso_alias_untrain_ret)
 __EXPORT_THUNK(srso_alias_untrain_ret)
+	.popsection
 
-	.section .text..__x86.rethunk_safe
-#else
-/* dummy definition for alternatives */
-SYM_START(srso_alias_untrain_ret, SYM_L_GLOBAL, SYM_A_NONE)
-	ANNOTATE_UNRET_SAFE
-	ret
-	int3
-SYM_FUNC_END(srso_alias_untrain_ret)
-#endif
-
+	.pushsection .text..__x86.rethunk_safe
 SYM_START(srso_alias_safe_ret, SYM_L_GLOBAL, SYM_A_NONE)
 	lea 8(%_ASM_SP), %_ASM_SP
 	UNWIND_HINT_FUNC
@@ -183,8 +174,58 @@ SYM_CODE_START_NOALIGN(srso_alias_return
 	call srso_alias_safe_ret
 	ud2
 SYM_CODE_END(srso_alias_return_thunk)
+	.popsection
+
+/*
+ * SRSO untraining sequence for Zen1/2, similar to retbleed_untrain_ret()
+ * above. On kernel entry, srso_untrain_ret() is executed which is a
+ *
+ * movabs $0xccccc30824648d48,%rax
+ *
+ * and when the return thunk executes the inner label srso_safe_ret()
+ * later, it is a stack manipulation and a RET which is mispredicted and
+ * thus a "safe" one to use.
+ */
+	.align 64
+	.skip 64 - (srso_safe_ret - srso_untrain_ret), 0xcc
+SYM_START(srso_untrain_ret, SYM_L_LOCAL, SYM_A_NONE)
+	ANNOTATE_NOENDBR
+	.byte 0x48, 0xb8
+
+/*
+ * This forces the function return instruction to speculate into a trap
+ * (UD2 in srso_return_thunk() below).  This RET will then mispredict
+ * and execution will continue at the return site read from the top of
+ * the stack.
+ */
+SYM_INNER_LABEL(srso_safe_ret, SYM_L_GLOBAL)
+	lea 8(%_ASM_SP), %_ASM_SP
+	ret
+	int3
+	int3
+	/* end of movabs */
+	lfence
+	call srso_safe_ret
+	ud2
+SYM_CODE_END(srso_safe_ret)
+SYM_FUNC_END(srso_untrain_ret)
+
+SYM_CODE_START(srso_return_thunk)
+	UNWIND_HINT_FUNC
+	ANNOTATE_NOENDBR
+	call srso_safe_ret
+	ud2
+SYM_CODE_END(srso_return_thunk)
+
+#define JMP_SRSO_UNTRAIN_RET "jmp srso_untrain_ret"
+#define JMP_SRSO_ALIAS_UNTRAIN_RET "jmp srso_alias_untrain_ret"
+#else /* !CONFIG_CPU_SRSO */
+#define JMP_SRSO_UNTRAIN_RET "ud2"
+#define JMP_SRSO_ALIAS_UNTRAIN_RET "ud2"
+#endif /* CONFIG_CPU_SRSO */
+
+#ifdef CONFIG_CPU_UNRET_ENTRY
 
-	.section .text..__x86.return_thunk
 /*
  * Some generic notes on the untraining sequences:
  *
@@ -265,65 +306,21 @@ SYM_CODE_END(retbleed_return_thunk)
 SYM_FUNC_END(retbleed_untrain_ret)
 __EXPORT_THUNK(retbleed_untrain_ret)
 
-/*
- * SRSO untraining sequence for Zen1/2, similar to retbleed_untrain_ret()
- * above. On kernel entry, srso_untrain_ret() is executed which is a
- *
- * movabs $0xccccc30824648d48,%rax
- *
- * and when the return thunk executes the inner label srso_safe_ret()
- * later, it is a stack manipulation and a RET which is mispredicted and
- * thus a "safe" one to use.
- */
-	.align 64
-	.skip 64 - (srso_safe_ret - srso_untrain_ret), 0xcc
-SYM_START(srso_untrain_ret, SYM_L_GLOBAL, SYM_A_NONE)
-	ANNOTATE_NOENDBR
-	.byte 0x48, 0xb8
+#define JMP_RETBLEED_UNTRAIN_RET "jmp retbleed_untrain_ret"
+#else /* !CONFIG_CPU_UNRET_ENTRY */
+#define JMP_RETBLEED_UNTRAIN_RET "ud2"
+#endif /* CONFIG_CPU_UNRET_ENTRY */
 
-/*
- * This forces the function return instruction to speculate into a trap
- * (UD2 in srso_return_thunk() below).  This RET will then mispredict
- * and execution will continue at the return site read from the top of
- * the stack.
- */
-SYM_INNER_LABEL(srso_safe_ret, SYM_L_GLOBAL)
-	lea 8(%_ASM_SP), %_ASM_SP
-	ret
-	int3
-	int3
-	/* end of movabs */
-	lfence
-	call srso_safe_ret
-	ud2
-SYM_CODE_END(srso_safe_ret)
-SYM_FUNC_END(srso_untrain_ret)
-__EXPORT_THUNK(srso_untrain_ret)
-
-SYM_CODE_START(srso_return_thunk)
-	UNWIND_HINT_FUNC
-	ANNOTATE_NOENDBR
-	call srso_safe_ret
-	ud2
-SYM_CODE_END(srso_return_thunk)
+#if defined(CONFIG_CPU_UNRET_ENTRY) || defined(CONFIG_CPU_SRSO)
 
 SYM_FUNC_START(entry_untrain_ret)
-	ALTERNATIVE_2 "jmp retbleed_untrain_ret", \
-		      "jmp srso_untrain_ret", X86_FEATURE_SRSO, \
-		      "jmp srso_alias_untrain_ret", X86_FEATURE_SRSO_ALIAS
+	ALTERNATIVE_2 JMP_RETBLEED_UNTRAIN_RET,				\
+		      JMP_SRSO_UNTRAIN_RET, X86_FEATURE_SRSO,		\
+		      JMP_SRSO_ALIAS_UNTRAIN_RET, X86_FEATURE_SRSO_ALIAS
 SYM_FUNC_END(entry_untrain_ret)
 __EXPORT_THUNK(entry_untrain_ret)
 
-SYM_CODE_START(__x86_return_thunk)
-	UNWIND_HINT_FUNC
-	ANNOTATE_NOENDBR
-	ANNOTATE_UNRET_SAFE
-	ret
-	int3
-SYM_CODE_END(__x86_return_thunk)
-EXPORT_SYMBOL(__x86_return_thunk)
-
-#endif /* CONFIG_RETHUNK */
+#endif /* CONFIG_CPU_UNRET_ENTRY || CONFIG_CPU_SRSO */
 
 #ifdef CONFIG_CALL_DEPTH_TRACKING
 
@@ -358,3 +355,22 @@ SYM_FUNC_START(__x86_return_skl)
 SYM_FUNC_END(__x86_return_skl)
 
 #endif /* CONFIG_CALL_DEPTH_TRACKING */
+
+/*
+ * This function name is magical and is used by -mfunction-return=thunk-extern
+ * for the compiler to generate JMPs to it.
+ *
+ * This code is only used during kernel boot or module init.  All
+ * 'JMP __x86_return_thunk' sites are changed to something else by
+ * apply_returns().
+ */
+SYM_CODE_START(__x86_return_thunk)
+	UNWIND_HINT_FUNC
+	ANNOTATE_NOENDBR
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
+SYM_CODE_END(__x86_return_thunk)
+EXPORT_SYMBOL(__x86_return_thunk)
+
+#endif /* CONFIG_RETHUNK */


