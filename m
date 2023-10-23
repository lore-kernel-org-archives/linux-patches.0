Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FF8168B0
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/jQwgL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A887AC433C7;
	Mon, 23 Oct 2023 11:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061582;
	bh=1ASrwBHySWYAHcWzaxo+lKaPwmNQgsgcSCVqYDsaNqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/jQwgL9gZHqdbHchsdm/zcBYH8SfWEEHmZ9o+020aGvGEcXThcbLq642a3Cjq3Io
	 k5KCAqoDF+dp/4ekhVNXlUlJqyTybU/7MTklrL8ZC5Q8x+ZjdFFLUsVeFs9GqUcU+X
	 LutsmeJ7SplxlFcEhz/Y/d+zVwYGDOaHVgNa3kwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie@huawei.com,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 069/202] arm64: split EL0/EL1 UNDEF handlers
Date: Mon, 23 Oct 2023 12:56:16 +0200
Message-ID: <20231023104828.565450674@linuxfoundation.org>
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

commit 61d64a376ea80f9097e7ea599bcd68671b836dc6 upstream.

In general, exceptions taken from EL1 need to be handled separately from
exceptions taken from EL0, as the logic to handle the two cases can be
significantly divergent, and exceptions taken from EL1 typically have
more stringent requirements on locking and instrumentation.

Subsequent patches will rework the way EL1 UNDEFs are handled in order
to address longstanding soundness issues with instrumentation and RCU.
In preparation for that rework, this patch splits the existing
do_undefinstr() handler into separate do_el0_undef() and do_el1_undef()
handlers.

Prior to this patch, do_undefinstr() was marked with NOKPROBE_SYMBOL(),
preventing instrumentation via kprobes. However, do_undefinstr() invokes
other code which can be instrumented, and:

* For UNDEFINED exceptions taken from EL0, there is no risk of recursion
  within kprobes. Therefore it is safe for do_el0_undef to be
  instrumented with kprobes, and it does not need to be marked with
  NOKPROBE_SYMBOL().

* For UNDEFINED exceptions taken from EL1, either:

  (a) The exception is has been taken when manipulating SSBS; these cases
      are limited and do not occur within code that can be invoked
      recursively via kprobes. Hence, in these cases instrumentation
      with kprobes is benign.

  (b) The exception has been taken for an unknown reason, as other than
      manipulating SSBS we do not expect to take UNDEFINED exceptions
      from EL1. Any handling of these exception is best-effort.

  ... and in either case, marking do_el1_undef() with NOKPROBE_SYMBOL()
  isn't sufficient to prevent recursion via kprobes as functions it
  calls (including die()) are instrumentable via kprobes.

  Hence, it's not worthwhile to mark do_el1_undef() with
  NOKPROBE_SYMBOL(). The same applies to do_el1_bti() and do_el1_fpac(),
  so their NOKPROBE_SYMBOL() annotations are also removed.

Aside from the new instrumentability, there should be no functional
change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221019144123.612388-3-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/exception.h |    3 ++-
 arch/arm64/kernel/entry-common.c   |    4 ++--
 arch/arm64/kernel/traps.c          |   22 ++++++++++++----------
 3 files changed, 16 insertions(+), 13 deletions(-)

--- a/arch/arm64/include/asm/exception.h
+++ b/arch/arm64/include/asm/exception.h
@@ -33,7 +33,8 @@ asmlinkage void exit_to_user_mode(void);
 void arm64_enter_nmi(struct pt_regs *regs);
 void arm64_exit_nmi(struct pt_regs *regs);
 void do_mem_abort(unsigned long addr, unsigned int esr, struct pt_regs *regs);
-void do_undefinstr(struct pt_regs *regs, unsigned long esr);
+void do_el0_undef(struct pt_regs *regs, unsigned long esr);
+void do_el1_undef(struct pt_regs *regs, unsigned long esr);
 void do_el0_bti(struct pt_regs *regs);
 void do_el1_bti(struct pt_regs *regs, unsigned long esr);
 asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr);
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -136,7 +136,7 @@ static void noinstr el1_undef(struct pt_
 {
 	enter_from_kernel_mode(regs);
 	local_daif_inherit(regs);
-	do_undefinstr(regs, esr);
+	do_el1_undef(regs, esr);
 	local_daif_mask();
 	exit_to_kernel_mode(regs);
 }
@@ -332,7 +332,7 @@ static void noinstr el0_undef(struct pt_
 {
 	enter_from_user_mode();
 	local_daif_restore(DAIF_PROCCTX);
-	do_undefinstr(regs, esr);
+	do_el0_undef(regs, esr);
 }
 
 static void noinstr el0_bti(struct pt_regs *regs)
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -395,7 +395,7 @@ void arm64_notify_segfault(unsigned long
 	force_signal_inject(SIGSEGV, code, addr, 0);
 }
 
-void do_undefinstr(struct pt_regs *regs, unsigned long esr)
+void do_el0_undef(struct pt_regs *regs, unsigned long esr)
 {
 	/* check for AArch32 breakpoint instructions */
 	if (!aarch32_break_handler(regs))
@@ -404,12 +404,16 @@ void do_undefinstr(struct pt_regs *regs,
 	if (call_undef_hook(regs) == 0)
 		return;
 
-	if (!user_mode(regs))
-		die("Oops - Undefined instruction", regs, esr);
-
 	force_signal_inject(SIGILL, ILL_ILLOPC, regs->pc, 0);
 }
-NOKPROBE_SYMBOL(do_undefinstr);
+
+void do_el1_undef(struct pt_regs *regs, unsigned long esr)
+{
+	if (call_undef_hook(regs) == 0)
+		return;
+
+	die("Oops - Undefined instruction", regs, esr);
+}
 
 void do_el0_bti(struct pt_regs *regs)
 {
@@ -420,7 +424,6 @@ void do_el1_bti(struct pt_regs *regs, un
 {
 	die("Oops - BTI", regs, esr);
 }
-NOKPROBE_SYMBOL(do_el1_bti);
 
 void do_el0_fpac(struct pt_regs *regs, unsigned long esr)
 {
@@ -435,7 +438,6 @@ void do_el1_fpac(struct pt_regs *regs, u
 	 */
 	die("Oops - FPAC", regs, esr);
 }
-NOKPROBE_SYMBOL(do_el1_fpac);
 
 #define __user_cache_maint(insn, address, res)			\
 	if (address >= user_addr_max()) {			\
@@ -671,7 +673,7 @@ void do_el0_cp15(unsigned long esr, stru
 		hook_base = cp15_64_hooks;
 		break;
 	default:
-		do_undefinstr(regs, esr);
+		do_el0_undef(regs, esr);
 		return;
 	}
 
@@ -686,7 +688,7 @@ void do_el0_cp15(unsigned long esr, stru
 	 * EL0. Fall back to our usual undefined instruction handler
 	 * so that we handle these consistently.
 	 */
-	do_undefinstr(regs, esr);
+	do_el0_undef(regs, esr);
 }
 #endif
 
@@ -705,7 +707,7 @@ void do_el0_sys(unsigned long esr, struc
 	 * back to our usual undefined instruction handler so that we handle
 	 * these consistently.
 	 */
-	do_undefinstr(regs, esr);
+	do_el0_undef(regs, esr);
 }
 
 static const char *esr_class_str[] = {


