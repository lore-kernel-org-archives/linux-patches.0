Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B70C1A27D
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUa3V9FV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83513C433CB;
	Mon, 16 Oct 2023 08:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446200;
	bh=qX/39sT6SvF83ttSO3KJFgayr6c4gEhXxeCJb3sJH30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUa3V9FVSHs+cgsgr3kyShCMa5L5dLszaHMWFoUxXKV8f40nSPEhjQ6H7aixhaAyt
	 UlzQ/LkmiRx2jSCOFsfELLFaWAxozsScnkUolbrFvALpMuIPxf3RTcYwTspd9zijhN
	 JztBw9HIT681jSBC2RyFUJglrlogEjpx5F4/YZVw=
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
Subject: [PATCH 5.15 092/102] arm64: factor out EL1 SSBS emulation hook
Date: Mon, 16 Oct 2023 10:41:31 +0200
Message-ID: <20231016083956.147420644@linuxfoundation.org>
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

commit bff8f413c71ffc3cb679dbd9a5632b33af563f9f upstream.

Currently call_undef_hook() is used to handle UNDEFINED exceptions from
EL0 and EL1. As support for deprecated instructions may be enabled
independently, the handlers for individual instructions are organised as
a linked list of struct undef_hook which can be manipulated dynamically.
As this can be manipulated dynamically, the list is protected with a
raw_spinlock which must be acquired when handling UNDEFINED exceptions
or when manipulating the list of handlers.

This locking is unfortunate as it serialises handling of UNDEFINED
exceptions, and requires RCU to be enabled for lockdep, requiring the
use of RCU_NONIDLE() in resume path of cpu_suspend() since commit:

  a2c42bbabbe260b7 ("arm64: spectre: Prevent lockdep splat on v4 mitigation enable path")

The list of UNDEFINED handlers largely consist of handlers for
exceptions taken from EL0, and the only handler for exceptions taken
from EL1 handles `MSR SSBS, #imm` on CPUs which feature PSTATE.SSBS but
lack the corresponding MSR (Immediate) instruction. Other than this we
never expect to take an UNDEFINED exception from EL1 in normal
operation.

This patch reworks do_el0_undef() to invoke the EL1 SSBS handler
directly, relegating call_undef_hook() to only handle EL0 UNDEFs. This
removes redundant work to iterate the list for EL1 UNDEFs, and removes
the need for locking, permitting EL1 UNDEFs to be handled in parallel
without contention.

The RCU_NONIDLE() call in cpu_suspend() will be removed in a subsequent
patch, as there are other potential issues with the use of
instrumentable code and RCU in the CPU suspend code.

I've tested this by forcing the detection of SSBS on a CPU that doesn't
have it, and verifying that the try_emulate_el1_ssbs() callback is
invoked.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221019144123.612388-4-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/spectre.h |    2 ++
 arch/arm64/kernel/proton-pack.c  |   26 +++++++-------------------
 arch/arm64/kernel/traps.c        |   15 ++++++++-------
 3 files changed, 17 insertions(+), 26 deletions(-)

--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -26,6 +26,7 @@ enum mitigation_state {
 	SPECTRE_VULNERABLE,
 };
 
+struct pt_regs;
 struct task_struct;
 
 /*
@@ -98,5 +99,6 @@ enum mitigation_state arm64_get_spectre_
 bool is_spectre_bhb_affected(const struct arm64_cpu_capabilities *entry, int scope);
 u8 spectre_bhb_loop_affected(int scope);
 void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
+bool try_emulate_el1_ssbs(struct pt_regs *regs, u32 instr);
 #endif	/* __ASSEMBLY__ */
 #endif	/* __ASM_SPECTRE_H */
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -521,10 +521,13 @@ bool has_spectre_v4(const struct arm64_c
 	return state != SPECTRE_UNAFFECTED;
 }
 
-static int ssbs_emulation_handler(struct pt_regs *regs, u32 instr)
+bool try_emulate_el1_ssbs(struct pt_regs *regs, u32 instr)
 {
-	if (user_mode(regs))
-		return 1;
+	const u32 instr_mask = ~(1U << PSTATE_Imm_shift);
+	const u32 instr_val = 0xd500401f | PSTATE_SSBS;
+
+	if ((instr & instr_mask) != instr_val)
+		return false;
 
 	if (instr & BIT(PSTATE_Imm_shift))
 		regs->pstate |= PSR_SSBS_BIT;
@@ -532,19 +535,11 @@ static int ssbs_emulation_handler(struct
 		regs->pstate &= ~PSR_SSBS_BIT;
 
 	arm64_skip_faulting_instruction(regs, 4);
-	return 0;
+	return true;
 }
 
-static struct undef_hook ssbs_emulation_hook = {
-	.instr_mask	= ~(1U << PSTATE_Imm_shift),
-	.instr_val	= 0xd500401f | PSTATE_SSBS,
-	.fn		= ssbs_emulation_handler,
-};
-
 static enum mitigation_state spectre_v4_enable_hw_mitigation(void)
 {
-	static bool undef_hook_registered = false;
-	static DEFINE_RAW_SPINLOCK(hook_lock);
 	enum mitigation_state state;
 
 	/*
@@ -555,13 +550,6 @@ static enum mitigation_state spectre_v4_
 	if (state != SPECTRE_MITIGATED || !this_cpu_has_cap(ARM64_SSBS))
 		return state;
 
-	raw_spin_lock(&hook_lock);
-	if (!undef_hook_registered) {
-		register_undef_hook(&ssbs_emulation_hook);
-		undef_hook_registered = true;
-	}
-	raw_spin_unlock(&hook_lock);
-
 	if (spectre_v4_mitigations_off()) {
 		sysreg_clear_set(sctlr_el1, 0, SCTLR_ELx_DSSBS);
 		set_pstate_ssbs(1);
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -402,12 +402,7 @@ static int call_undef_hook(struct pt_reg
 	int (*fn)(struct pt_regs *regs, u32 instr) = NULL;
 	void __user *pc = (void __user *)instruction_pointer(regs);
 
-	if (!user_mode(regs)) {
-		__le32 instr_le;
-		if (get_kernel_nofault(instr_le, (__force __le32 *)pc))
-			goto exit;
-		instr = le32_to_cpu(instr_le);
-	} else if (compat_thumb_mode(regs)) {
+	if (compat_thumb_mode(regs)) {
 		/* 16-bit Thumb instruction */
 		__le16 instr_le;
 		if (get_user(instr_le, (__le16 __user *)pc))
@@ -500,9 +495,15 @@ void do_el0_undef(struct pt_regs *regs,
 
 void do_el1_undef(struct pt_regs *regs, unsigned long esr)
 {
-	if (call_undef_hook(regs) == 0)
+	u32 insn;
+
+	if (aarch64_insn_read((void *)regs->pc, &insn))
+		goto out_err;
+
+	if (try_emulate_el1_ssbs(regs, insn))
 		return;
 
+out_err:
 	die("Oops - Undefined instruction", regs, esr);
 }
 


