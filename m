Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F3820F078;
	Wed, 30 Jul 2025 09:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868319; cv=none; b=onBTUVr5gyxo+LQv77TxgoOsqIJYd2NIZOfpDGBc3zzvaJLs+Q+Cx+bu/bA/lNnTDov9qA/T8S43FA9TtnRfV8BKv4553gPIwCghMhcQ18GL9otmiEMTbYv9ANTestR6Z9iI2xoq0jkB8OKMoYI9oWKiBP2P9YCSwG5kBnEJ4+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868319; c=relaxed/simple;
	bh=N55/4h1LVLW7aFEi0i3/O6NTz5SSZwp6ifR7k1LFpSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niHXtTtahksmel+tm6RG0eSla9J8e+XC3PrOvKlw8wmhC3hApFDuOZ9pvJrXMaDxnHjDMI3l36VbhWK9tIEbGPPX+LM2MXiUz3zkaEPJmP1OUzS3TEavb4TyeRnEKsTPzfjuGv7BwK7rfiA8qVOGnl79+kAd2OPLBFPlvKqQTAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQ3FGo1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQ3FGo1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EC3C4CEE7;
	Wed, 30 Jul 2025 09:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868319;
	bh=N55/4h1LVLW7aFEi0i3/O6NTz5SSZwp6ifR7k1LFpSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQ3FGo1PEU9YFcTV/LHocUOvPSL+o9jhrQwayBtArmnHkIOsea4PIfHxZ/cFvNQLN
	 s1YK5dhwVEEk7oACtcSk82rVdNYz3yX0Z/mlQlYASn3gjqK7BA/v8yVrOJz+7CxNU9
	 k6ETbP7njPP7HaUol4sFFzm/ZoAe4hqd72qilvbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Cristian Prundeanu <cpru@amazon.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 35/76] arm64/entry: Mask DAIF in cpu_switch_to(), call_on_irq_stack()
Date: Wed, 30 Jul 2025 11:35:28 +0200
Message-ID: <20250730093228.200132064@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ada Couprie Diaz <ada.coupriediaz@arm.com>

commit d42e6c20de6192f8e4ab4cf10be8c694ef27e8cb upstream.

`cpu_switch_to()` and `call_on_irq_stack()` manipulate SP to change
to different stacks along with the Shadow Call Stack if it is enabled.
Those two stack changes cannot be done atomically and both functions
can be interrupted by SErrors or Debug Exceptions which, though unlikely,
is very much broken : if interrupted, we can end up with mismatched stacks
and Shadow Call Stack leading to clobbered stacks.

In `cpu_switch_to()`, it can happen when SP_EL0 points to the new task,
but x18 stills points to the old task's SCS. When the interrupt handler
tries to save the task's SCS pointer, it will save the old task
SCS pointer (x18) into the new task struct (pointed to by SP_EL0),
clobbering it.

In `call_on_irq_stack()`, it can happen when switching from the task stack
to the IRQ stack and when switching back. In both cases, we can be
interrupted when the SCS pointer points to the IRQ SCS, but SP points to
the task stack. The nested interrupt handler pushes its return addresses
on the IRQ SCS. It then detects that SP points to the task stack,
calls `call_on_irq_stack()` and clobbers the task SCS pointer with
the IRQ SCS pointer, which it will also use !

This leads to tasks returning to addresses on the wrong SCS,
or even on the IRQ SCS, triggering kernel panics via CONFIG_VMAP_STACK
or FPAC if enabled.

This is possible on a default config, but unlikely.
However, when enabling CONFIG_ARM64_PSEUDO_NMI, DAIF is unmasked and
instead the GIC is responsible for filtering what interrupts the CPU
should receive based on priority.
Given the goal of emulating NMIs, pseudo-NMIs can be received by the CPU
even in `cpu_switch_to()` and `call_on_irq_stack()`, possibly *very*
frequently depending on the system configuration and workload, leading
to unpredictable kernel panics.

Completely mask DAIF in `cpu_switch_to()` and restore it when returning.
Do the same in `call_on_irq_stack()`, but restore and mask around
the branch.
Mask DAIF even if CONFIG_SHADOW_CALL_STACK is not enabled for consistency
of behaviour between all configurations.

Introduce and use an assembly macro for saving and masking DAIF,
as the existing one saves but only masks IF.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Reported-by: Cristian Prundeanu <cpru@amazon.com>
Fixes: 59b37fe52f49 ("arm64: Stash shadow stack pointer in the task struct on interrupt")
Tested-by: Cristian Prundeanu <cpru@amazon.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20250718142814.133329-1-ada.coupriediaz@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/assembler.h |    5 +++++
 arch/arm64/kernel/entry.S          |    6 ++++++
 2 files changed, 11 insertions(+)

--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -45,6 +45,11 @@
 /*
  * Save/restore interrupts.
  */
+	.macro save_and_disable_daif, flags
+	mrs	\flags, daif
+	msr	daifset, #0xf
+	.endm
+
 	.macro	save_and_disable_irq, flags
 	mrs	\flags, daif
 	msr	daifset, #3
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -824,6 +824,7 @@ SYM_CODE_END(__bp_harden_el1_vectors)
  *
  */
 SYM_FUNC_START(cpu_switch_to)
+	save_and_disable_daif x11
 	mov	x10, #THREAD_CPU_CONTEXT
 	add	x8, x0, x10
 	mov	x9, sp
@@ -847,6 +848,7 @@ SYM_FUNC_START(cpu_switch_to)
 	ptrauth_keys_install_kernel x1, x8, x9, x10
 	scs_save x0
 	scs_load_current
+	restore_irq x11
 	ret
 SYM_FUNC_END(cpu_switch_to)
 NOKPROBE(cpu_switch_to)
@@ -873,6 +875,7 @@ NOKPROBE(ret_from_fork)
  * Calls func(regs) using this CPU's irq stack and shadow irq stack.
  */
 SYM_FUNC_START(call_on_irq_stack)
+	save_and_disable_daif x9
 #ifdef CONFIG_SHADOW_CALL_STACK
 	get_current_task x16
 	scs_save x16
@@ -887,8 +890,10 @@ SYM_FUNC_START(call_on_irq_stack)
 
 	/* Move to the new stack and call the function there */
 	add	sp, x16, #IRQ_STACK_SIZE
+	restore_irq x9
 	blr	x1
 
+	save_and_disable_daif x9
 	/*
 	 * Restore the SP from the FP, and restore the FP and LR from the frame
 	 * record.
@@ -896,6 +901,7 @@ SYM_FUNC_START(call_on_irq_stack)
 	mov	sp, x29
 	ldp	x29, x30, [sp], #16
 	scs_load_current
+	restore_irq x9
 	ret
 SYM_FUNC_END(call_on_irq_stack)
 NOKPROBE(call_on_irq_stack)


