Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2C619BD9
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sL4CYTP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3757C433BB;
	Mon, 16 Oct 2023 08:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446179;
	bh=Lk1/ElLZNDQJ9YVE7ttJqPou7L4aBrnwsQFpCcP4fuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sL4CYTP+LP7sPzbPxoNCEnPwRwyifdBDcSSWInTtPZyg0+sZTZphrc9xIIv7ds3d/
	 9h6QjOZP0tTDQKBZ+f9XAGYshxJa4HnoxYHh6EJn9RDG+D153u/wYZRZJNOjRPeZlo
	 +5jmpKQsw826cHPeG+q4M/FPId5g86bg9SvIFbD4=
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
Subject: [PATCH 5.15 087/102] arm64: consistently pass ESR_ELx to die()
Date: Mon, 16 Oct 2023 10:41:26 +0200
Message-ID: <20231016083956.013270018@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -58,7 +58,7 @@ asmlinkage void call_on_irq_stack(struct
 asmlinkage void asm_exit_to_user_mode(struct pt_regs *regs);
 
 void do_mem_abort(unsigned long far, unsigned long esr, struct pt_regs *regs);
-void do_undefinstr(struct pt_regs *regs);
+void do_undefinstr(struct pt_regs *regs, unsigned long esr);
 void do_bti(struct pt_regs *regs);
 void do_debug_exception(unsigned long addr_if_watchpoint, unsigned long esr,
 			struct pt_regs *regs);
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -371,11 +371,11 @@ static void noinstr el1_pc(struct pt_reg
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
@@ -417,7 +417,7 @@ asmlinkage void noinstr el1h_64_sync_han
 		break;
 	case ESR_ELx_EC_SYS64:
 	case ESR_ELx_EC_UNKNOWN:
-		el1_undef(regs);
+		el1_undef(regs, esr);
 		break;
 	case ESR_ELx_EC_BREAKPT_CUR:
 	case ESR_ELx_EC_SOFTSTP_CUR:
@@ -554,11 +554,11 @@ static void noinstr el0_sp(struct pt_reg
 	exit_to_user_mode(regs);
 }
 
-static void noinstr el0_undef(struct pt_regs *regs)
+static void noinstr el0_undef(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
 	local_daif_restore(DAIF_PROCCTX);
-	do_undefinstr(regs);
+	do_undefinstr(regs, esr);
 	exit_to_user_mode(regs);
 }
 
@@ -639,7 +639,7 @@ asmlinkage void noinstr el0t_64_sync_han
 		el0_pc(regs, esr);
 		break;
 	case ESR_ELx_EC_UNKNOWN:
-		el0_undef(regs);
+		el0_undef(regs, esr);
 		break;
 	case ESR_ELx_EC_BTI:
 		el0_bti(regs);
@@ -755,7 +755,7 @@ asmlinkage void noinstr el0t_32_sync_han
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
@@ -486,7 +486,7 @@ void arm64_notify_segfault(unsigned long
 	force_signal_inject(SIGSEGV, code, addr, 0);
 }
 
-void do_undefinstr(struct pt_regs *regs)
+void do_undefinstr(struct pt_regs *regs, unsigned long esr)
 {
 	/* check for AArch32 breakpoint instructions */
 	if (!aarch32_break_handler(regs))
@@ -496,7 +496,7 @@ void do_undefinstr(struct pt_regs *regs)
 		return;
 
 	if (!user_mode(regs))
-		die("Oops - Undefined instruction", regs, 0);
+		die("Oops - Undefined instruction", regs, esr);
 
 	force_signal_inject(SIGILL, ILL_ILLOPC, regs->pc, 0);
 }
@@ -755,7 +755,7 @@ void do_cp15instr(unsigned long esr, str
 		hook_base = cp15_64_hooks;
 		break;
 	default:
-		do_undefinstr(regs);
+		do_undefinstr(regs, esr);
 		return;
 	}
 
@@ -770,7 +770,7 @@ void do_cp15instr(unsigned long esr, str
 	 * EL0. Fall back to our usual undefined instruction handler
 	 * so that we handle these consistently.
 	 */
-	do_undefinstr(regs);
+	do_undefinstr(regs, esr);
 }
 NOKPROBE_SYMBOL(do_cp15instr);
 #endif
@@ -790,7 +790,7 @@ void do_sysinstr(unsigned long esr, stru
 	 * back to our usual undefined instruction handler so that we handle
 	 * these consistently.
 	 */
-	do_undefinstr(regs);
+	do_undefinstr(regs, esr);
 }
 NOKPROBE_SYMBOL(do_sysinstr);
 
@@ -966,7 +966,7 @@ static int bug_handler(struct pt_regs *r
 {
 	switch (report_bug(regs->pc, regs)) {
 	case BUG_TRAP_TYPE_BUG:
-		die("Oops - BUG", regs, 0);
+		die("Oops - BUG", regs, esr);
 		break;
 
 	case BUG_TRAP_TYPE_WARN:
@@ -1034,7 +1034,7 @@ static int kasan_handler(struct pt_regs
 	 * This is something that might be fixed at some point in the future.
 	 */
 	if (!recover)
-		die("Oops - KASAN", regs, 0);
+		die("Oops - KASAN", regs, esr);
 
 	/* If thread survives, skip over the brk instruction and continue: */
 	arm64_skip_faulting_instruction(regs, AARCH64_INSN_SIZE);


