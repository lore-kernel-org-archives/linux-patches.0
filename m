Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD2611C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D205C433C7;
	Thu, 24 Aug 2023 14:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889031;
	bh=MkTE1Fp5OAsO4XUEniFfVFKwObvnXMT8B6HVmtZl0UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3KbqxhatGmxlXTKKQES005cdTzmZ8Cn0hTv/nXo/h+aj9C1sOF0OwH+v8O0yzzZ3
	 EyciMytcdW8RSFWnHVfTg3dKNyJaSgRHe1V/0+iDXVWdDWVsx7J+LcqZO6rHeQ8f14
	 KPYDIs9uEwZxWb4XD/D5fKG2Uqkn0A2N02MyOi7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.15 129/139] x86/cpu: Rename original retbleed methods
Date: Thu, 24 Aug 2023 16:50:52 +0200
Message-ID: <20230824145029.065547436@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

commit d025b7bac07a6e90b6b98b487f88854ad9247c39 upstream.

Rename the original retbleed return thunk and untrain_ret to
retbleed_return_thunk() and retbleed_untrain_ret().

No functional changes.

Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230814121148.909378169@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    8 ++++----
 arch/x86/kernel/cpu/bugs.c           |    2 +-
 arch/x86/kernel/vmlinux.lds.S        |    2 +-
 arch/x86/lib/retpoline.S             |   30 +++++++++++++++---------------
 tools/objtool/arch/x86/decode.c      |    2 +-
 tools/objtool/check.c                |    2 +-
 6 files changed, 23 insertions(+), 23 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -156,7 +156,7 @@
 .endm
 
 #ifdef CONFIG_CPU_UNRET_ENTRY
-#define CALL_ZEN_UNTRAIN_RET	"call zen_untrain_ret"
+#define CALL_ZEN_UNTRAIN_RET	"call retbleed_untrain_ret"
 #else
 #define CALL_ZEN_UNTRAIN_RET	""
 #endif
@@ -166,7 +166,7 @@
  * return thunk isn't mapped into the userspace tables (then again, AMD
  * typically has NO_MELTDOWN).
  *
- * While zen_untrain_ret() doesn't clobber anything but requires stack,
+ * While retbleed_untrain_ret() doesn't clobber anything but requires stack,
  * entry_ibpb() will clobber AX, CX, DX.
  *
  * As such, this must be placed after every *SWITCH_TO_KERNEL_CR3 at a point
@@ -201,11 +201,11 @@ extern void __x86_return_thunk(void);
 static inline void __x86_return_thunk(void) {}
 #endif
 
-extern void zen_return_thunk(void);
+extern void retbleed_return_thunk(void);
 extern void srso_return_thunk(void);
 extern void srso_alias_return_thunk(void);
 
-extern void zen_untrain_ret(void);
+extern void retbleed_untrain_ret(void);
 extern void srso_untrain_ret(void);
 extern void srso_untrain_ret_alias(void);
 
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1021,7 +1021,7 @@ do_cmd_auto:
 		setup_force_cpu_cap(X86_FEATURE_UNRET);
 
 		if (IS_ENABLED(CONFIG_RETHUNK))
-			x86_return_thunk = zen_return_thunk;
+			x86_return_thunk = retbleed_return_thunk;
 
 		if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
 		    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -512,7 +512,7 @@ INIT_PER_CPU(irq_stack_backing_store);
 #endif
 
 #ifdef CONFIG_RETHUNK
-. = ASSERT((zen_return_thunk & 0x3f) == 0, "zen_return_thunk not cacheline-aligned");
+. = ASSERT((retbleed_return_thunk & 0x3f) == 0, "retbleed_return_thunk not cacheline-aligned");
 . = ASSERT((srso_safe_ret & 0x3f) == 0, "srso_safe_ret not cacheline-aligned");
 #endif
 
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -129,32 +129,32 @@ SYM_CODE_END(srso_alias_return_thunk)
 
 /*
  * Safety details here pertain to the AMD Zen{1,2} microarchitecture:
- * 1) The RET at zen_return_thunk must be on a 64 byte boundary, for
+ * 1) The RET at retbleed_return_thunk must be on a 64 byte boundary, for
  *    alignment within the BTB.
- * 2) The instruction at zen_untrain_ret must contain, and not
+ * 2) The instruction at retbleed_untrain_ret must contain, and not
  *    end with, the 0xc3 byte of the RET.
  * 3) STIBP must be enabled, or SMT disabled, to prevent the sibling thread
  *    from re-poisioning the BTB prediction.
  */
 	.align 64
-	.skip 64 - (zen_return_thunk - zen_untrain_ret), 0xcc
-SYM_FUNC_START_NOALIGN(zen_untrain_ret);
+	.skip 64 - (retbleed_return_thunk - retbleed_untrain_ret), 0xcc
+SYM_FUNC_START_NOALIGN(retbleed_untrain_ret);
 
 	/*
-	 * As executed from zen_untrain_ret, this is:
+	 * As executed from retbleed_untrain_ret, this is:
 	 *
 	 *   TEST $0xcc, %bl
 	 *   LFENCE
-	 *   JMP zen_return_thunk
+	 *   JMP retbleed_return_thunk
 	 *
 	 * Executing the TEST instruction has a side effect of evicting any BTB
 	 * prediction (potentially attacker controlled) attached to the RET, as
-	 * zen_return_thunk + 1 isn't an instruction boundary at the moment.
+	 * retbleed_return_thunk + 1 isn't an instruction boundary at the moment.
 	 */
 	.byte	0xf6
 
 	/*
-	 * As executed from zen_return_thunk, this is a plain RET.
+	 * As executed from retbleed_return_thunk, this is a plain RET.
 	 *
 	 * As part of the TEST above, RET is the ModRM byte, and INT3 the imm8.
 	 *
@@ -166,13 +166,13 @@ SYM_FUNC_START_NOALIGN(zen_untrain_ret);
 	 * With SMT enabled and STIBP active, a sibling thread cannot poison
 	 * RET's prediction to a type of its choice, but can evict the
 	 * prediction due to competitive sharing. If the prediction is
-	 * evicted, zen_return_thunk will suffer Straight Line Speculation
+	 * evicted, retbleed_return_thunk will suffer Straight Line Speculation
 	 * which will be contained safely by the INT3.
 	 */
-SYM_INNER_LABEL(zen_return_thunk, SYM_L_GLOBAL)
+SYM_INNER_LABEL(retbleed_return_thunk, SYM_L_GLOBAL)
 	ret
 	int3
-SYM_CODE_END(zen_return_thunk)
+SYM_CODE_END(retbleed_return_thunk)
 
 	/*
 	 * Ensure the TEST decoding / BTB invalidation is complete.
@@ -183,13 +183,13 @@ SYM_CODE_END(zen_return_thunk)
 	 * Jump back and execute the RET in the middle of the TEST instruction.
 	 * INT3 is for SLS protection.
 	 */
-	jmp zen_return_thunk
+	jmp retbleed_return_thunk
 	int3
-SYM_FUNC_END(zen_untrain_ret)
-__EXPORT_THUNK(zen_untrain_ret)
+SYM_FUNC_END(retbleed_untrain_ret)
+__EXPORT_THUNK(retbleed_untrain_ret)
 
 /*
- * SRSO untraining sequence for Zen1/2, similar to zen_untrain_ret()
+ * SRSO untraining sequence for Zen1/2, similar to retbleed_untrain_ret()
  * above. On kernel entry, srso_untrain_ret() is executed which is a
  *
  * movabs $0xccccccc308c48348,%rax
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -728,5 +728,5 @@ bool arch_is_rethunk(struct symbol *sym)
 	return !strcmp(sym->name, "__x86_return_thunk") ||
 	       !strcmp(sym->name, "srso_untrain_ret") ||
 	       !strcmp(sym->name, "srso_safe_ret") ||
-	       !strcmp(sym->name, "zen_return_thunk");
+	       !strcmp(sym->name, "retbleed_return_thunk");
 }
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1228,7 +1228,7 @@ static int add_jump_destinations(struct
 				continue;
 
 			/*
-			 * This is a special case for zen_untrain_ret().
+			 * This is a special case for retbleed_untrain_ret().
 			 * It jumps to __x86_return_thunk(), but objtool
 			 * can't find the thunk's starting RET
 			 * instruction, because the RET is also in the


