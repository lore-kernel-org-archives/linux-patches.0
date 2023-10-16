Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1458D1A27D
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKGPgPni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55720C433CA;
	Mon, 16 Oct 2023 08:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446188;
	bh=CX7zY9SZYR5TopR0lmk05R0tB+Hwz3PA27hGSp+v8WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKGPgPniw9z9NKKAGWpi7HVg5Kx5bfrr7yQyaCeqDB4T8p5EylIp6hyf+bdI9GAsE
	 QW2VP9rfPBgokQk+b8ce60uhLaiF0s3fegj9lyqQwnD/w5vC87bP3ooLX7G6+YpSa1
	 XEmjU3kMhlEdHUomUHGLiIrIW1yyxIrwSac7crg0=
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
Subject: [PATCH 5.15 090/102] arm64: allow kprobes on EL0 handlers
Date: Mon, 16 Oct 2023 10:41:29 +0200
Message-ID: <20231016083956.093703018@linuxfoundation.org>
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

commit b3a0c010e900a9f89dcd99f10bd8f7538d21b0a9 upstream.

Currently do_sysinstr() and do_cp15instr() are marked with
NOKPROBE_SYMBOL(). However, these are only called for exceptions taken
from EL0, and there is no risk of recursion in kprobes, so this is not
necessary.

Remove the NOKPROBE_SYMBOL() annotation, and rename the two functions to
more clearly indicate that these are solely for exceptions taken from
EL0, better matching the names used by the lower level entry points in
entry-common.c.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221019144123.612388-2-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/exception.h |    4 ++--
 arch/arm64/kernel/entry-common.c   |    4 ++--
 arch/arm64/kernel/traps.c          |    6 ++----
 3 files changed, 6 insertions(+), 8 deletions(-)

--- a/arch/arm64/include/asm/exception.h
+++ b/arch/arm64/include/asm/exception.h
@@ -66,10 +66,10 @@ void do_debug_exception(unsigned long ad
 void do_fpsimd_acc(unsigned long esr, struct pt_regs *regs);
 void do_sve_acc(unsigned long esr, struct pt_regs *regs);
 void do_fpsimd_exc(unsigned long esr, struct pt_regs *regs);
-void do_sysinstr(unsigned long esr, struct pt_regs *regs);
+void do_el0_sys(unsigned long esr, struct pt_regs *regs);
 void do_sp_pc_abort(unsigned long addr, unsigned long esr, struct pt_regs *regs);
 void bad_el0_sync(struct pt_regs *regs, int reason, unsigned long esr);
-void do_cp15instr(unsigned long esr, struct pt_regs *regs);
+void do_el0_cp15(unsigned long esr, struct pt_regs *regs);
 void do_el0_svc(struct pt_regs *regs);
 void do_el0_svc_compat(struct pt_regs *regs);
 void do_el0_fpac(struct pt_regs *regs, unsigned long esr);
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -541,7 +541,7 @@ static void noinstr el0_sys(struct pt_re
 {
 	enter_from_user_mode(regs);
 	local_daif_restore(DAIF_PROCCTX);
-	do_sysinstr(esr, regs);
+	do_el0_sys(esr, regs);
 	exit_to_user_mode(regs);
 }
 
@@ -728,7 +728,7 @@ static void noinstr el0_cp15(struct pt_r
 {
 	enter_from_user_mode(regs);
 	local_daif_restore(DAIF_PROCCTX);
-	do_cp15instr(esr, regs);
+	do_el0_cp15(esr, regs);
 	exit_to_user_mode(regs);
 }
 
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -742,7 +742,7 @@ static const struct sys64_hook cp15_64_h
 	{},
 };
 
-void do_cp15instr(unsigned long esr, struct pt_regs *regs)
+void do_el0_cp15(unsigned long esr, struct pt_regs *regs)
 {
 	const struct sys64_hook *hook, *hook_base;
 
@@ -780,10 +780,9 @@ void do_cp15instr(unsigned long esr, str
 	 */
 	do_undefinstr(regs, esr);
 }
-NOKPROBE_SYMBOL(do_cp15instr);
 #endif
 
-void do_sysinstr(unsigned long esr, struct pt_regs *regs)
+void do_el0_sys(unsigned long esr, struct pt_regs *regs)
 {
 	const struct sys64_hook *hook;
 
@@ -800,7 +799,6 @@ void do_sysinstr(unsigned long esr, stru
 	 */
 	do_undefinstr(regs, esr);
 }
-NOKPROBE_SYMBOL(do_sysinstr);
 
 static const char *esr_class_str[] = {
 	[0 ... ESR_ELx_EC_MAX]		= "UNRECOGNIZED EC",


