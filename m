Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3154C18021
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8554xd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3815C433C7;
	Mon, 23 Oct 2023 11:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061543;
	bh=lMeJFyXNYwRSmEKYYbmX7on8598YOzw6FYLFeOHspXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8554xd+XhTojGiZAKF3pHKHzKG2URcWaBypA8ba0JjbtxqnpYm5gFICrP0iTDG+z
	 pqbbqeEsDSlluiVpcFvjygPL1iJ2BRLn963DWaXAINigFw8gJpFgxeyQIkNeif0BWD
	 4JYEnzEhR6SPCUvyAL+CFRiz7A596u0OdaQeGz8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie@huawei.com,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Amit Daniel Kachhap <amit.kachhap@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.10 065/202] arm64: consistently pass ESR_ELx to die()
Date: Mon, 23 Oct 2023 12:56:12 +0200
Message-ID: <20231023104828.453724297@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

From: Mark Rutland <mark.rutland@arm.com>

commit 0f2cb928a1547ae8f89e80a4b8df2c6c02ae5f96 upstream.

Currently, bug_handler() and kasan_handler() call die() with '0' as the
'err' value, whereas die_kernel_fault() passes the ESR_ELx value.

For consistency, this patch ensures we always pass the ESR_ELx value to
die(). As this is only called for exceptions taken from kernel mode,
there should be no user-visible change as a result of this patch.

For UNDEFINED exceptions, I've had to modify do_undefinstr() and its
callers to pass the ESR_ELx value. In all cases the ESR_ELx value had
already been read and was available.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220913101732.3925290-4-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/exception.h |    2 +-
 arch/arm64/kernel/entry-common.c   |   14 +++++++-------
 arch/arm64/kernel/traps.c          |   14 +++++++-------
 3 files changed, 15 insertions(+), 15 deletions(-)

--- a/arch/arm64/include/asm/exception.h
+++ b/arch/arm64/include/asm/exception.h
@@ -33,7 +33,7 @@ asmlinkage void exit_to_user_mode(void);
 void arm64_enter_nmi(struct pt_regs *regs);
 void arm64_exit_nmi(struct pt_regs *regs);
 void do_mem_abort(unsigned long addr, unsigned int esr, struct pt_regs *regs);
-void do_undefinstr(struct pt_regs *regs);
+void do_undefinstr(struct pt_regs *regs, unsigned long esr);
 void do_bti(struct pt_regs *regs);
 asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr);
 void do_debug_exception(unsigned long addr_if_watchpoint, unsigned int esr,
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -132,11 +132,11 @@ static void noinstr el1_pc(struct pt_reg
 	exit_to_kernel_mode(regs);
 }
 
-static void noinstr el1_undef(struct pt_regs *regs)
+static void noinstr el1_undef(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_kernel_mode(regs);
 	local_daif_inherit(regs);
-	do_undefinstr(regs);
+	do_undefinstr(regs, esr);
 	local_daif_mask();
 	exit_to_kernel_mode(regs);
 }
@@ -210,7 +210,7 @@ asmlinkage void noinstr el1_sync_handler
 		break;
 	case ESR_ELx_EC_SYS64:
 	case ESR_ELx_EC_UNKNOWN:
-		el1_undef(regs);
+		el1_undef(regs, esr);
 		break;
 	case ESR_ELx_EC_BREAKPT_CUR:
 	case ESR_ELx_EC_SOFTSTP_CUR:
@@ -316,11 +316,11 @@ static void noinstr el0_sp(struct pt_reg
 	do_sp_pc_abort(regs->sp, esr, regs);
 }
 
-static void noinstr el0_undef(struct pt_regs *regs)
+static void noinstr el0_undef(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode();
 	local_daif_restore(DAIF_PROCCTX);
-	do_undefinstr(regs);
+	do_undefinstr(regs, esr);
 }
 
 static void noinstr el0_bti(struct pt_regs *regs)
@@ -394,7 +394,7 @@ asmlinkage void noinstr el0_sync_handler
 		el0_pc(regs, esr);
 		break;
 	case ESR_ELx_EC_UNKNOWN:
-		el0_undef(regs);
+		el0_undef(regs, esr);
 		break;
 	case ESR_ELx_EC_BTI:
 		el0_bti(regs);
@@ -454,7 +454,7 @@ asmlinkage void noinstr el0_sync_compat_
 	case ESR_ELx_EC_CP14_MR:
 	case ESR_ELx_EC_CP14_LS:
 	case ESR_ELx_EC_CP14_64:
-		el0_undef(regs);
+		el0_undef(regs, esr);
 		break;
 	case ESR_ELx_EC_CP15_32:
 	case ESR_ELx_EC_CP15_64:
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -395,7 +395,7 @@ void arm64_notify_segfault(unsigned long
 	force_signal_inject(SIGSEGV, code, addr, 0);
 }
 
-void do_undefinstr(struct pt_regs *regs)
+void do_undefinstr(struct pt_regs *regs, unsigned long esr)
 {
 	/* check for AArch32 breakpoint instructions */
 	if (!aarch32_break_handler(regs))
@@ -405,7 +405,7 @@ void do_undefinstr(struct pt_regs *regs)
 		return;
 
 	if (!user_mode(regs))
-		die("Oops - Undefined instruction", regs, 0);
+		die("Oops - Undefined instruction", regs, esr);
 
 	force_signal_inject(SIGILL, ILL_ILLOPC, regs->pc, 0);
 }
@@ -663,7 +663,7 @@ void do_cp15instr(unsigned int esr, stru
 		hook_base = cp15_64_hooks;
 		break;
 	default:
-		do_undefinstr(regs);
+		do_undefinstr(regs, esr);
 		return;
 	}
 
@@ -678,7 +678,7 @@ void do_cp15instr(unsigned int esr, stru
 	 * EL0. Fall back to our usual undefined instruction handler
 	 * so that we handle these consistently.
 	 */
-	do_undefinstr(regs);
+	do_undefinstr(regs, esr);
 }
 NOKPROBE_SYMBOL(do_cp15instr);
 #endif
@@ -698,7 +698,7 @@ void do_sysinstr(unsigned int esr, struc
 	 * back to our usual undefined instruction handler so that we handle
 	 * these consistently.
 	 */
-	do_undefinstr(regs);
+	do_undefinstr(regs, esr);
 }
 NOKPROBE_SYMBOL(do_sysinstr);
 
@@ -901,7 +901,7 @@ static int bug_handler(struct pt_regs *r
 {
 	switch (report_bug(regs->pc, regs)) {
 	case BUG_TRAP_TYPE_BUG:
-		die("Oops - BUG", regs, 0);
+		die("Oops - BUG", regs, esr);
 		break;
 
 	case BUG_TRAP_TYPE_WARN:
@@ -969,7 +969,7 @@ static int kasan_handler(struct pt_regs
 	 * This is something that might be fixed at some point in the future.
 	 */
 	if (!recover)
-		die("Oops - KASAN", regs, 0);
+		die("Oops - KASAN", regs, esr);
 
 	/* If thread survives, skip over the brk instruction and continue: */
 	arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);


