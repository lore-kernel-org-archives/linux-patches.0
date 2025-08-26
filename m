Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77F13451AA;
	Tue, 26 Aug 2025 13:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215024; cv=none; b=CUD5oBtiWXHbFQT5U4L2zj1Bd8xo0RMTTNFYcCqIaC+8wAhjNbn8Lnfi4TsrSR+H2fQMu8efFjtKI0l+m8xL/z+aM16ot3OYNy21YUMH+5g5ac0qZTrcVyqZZKObVrP0GGbAALp30qAS4ErpTP8kMJFucRZiBRYRPreCqWgF6vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215024; c=relaxed/simple;
	bh=8ykNdPX8Et02rA71+nPrpINz62Qydx6OzNP+XPrJZB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebnX9Yp5kn3H9lbgOZyzxxzEa/PqyZdvohgHBuCIoi6dLVwS+On6wNQyBESOwpw4/INZkQDMehQlDUzhKHBxPXHzWHweVu6aRdnLinsIndzLGKcLl1DqFh6B6pE/ePNDAf92GvRIhpqlNHzpSfG7Es6BXB3ZtfZaoZKh4P5Im/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQqR6ADx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQqR6ADx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A53C4CEF1;
	Tue, 26 Aug 2025 13:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215024;
	bh=8ykNdPX8Et02rA71+nPrpINz62Qydx6OzNP+XPrJZB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQqR6ADx1EJMno0UgfXZVTchZpofxknvZ5S+N4u/2+JjJkeODT0DDhPrpqCTFNvVD
	 Jisfo5ILu4bCZjQ8GVw/z5zmjrhMSJb1h2vfKyJ2vsUTxfXx8Fas4fUZSbZiIp/q7/
	 ENArm1MmOAHlweAAurznI8+bPdQF2peTde4WlOgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Cristian Prundeanu <cpru@amazon.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 351/482] arm64/entry: Mask DAIF in cpu_switch_to(), call_on_irq_stack()
Date: Tue, 26 Aug 2025 13:10:04 +0200
Message-ID: <20250826110939.506914710@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ada Couprie Diaz <ada.coupriediaz@arm.com>

[ Upstream commit d42e6c20de6192f8e4ab4cf10be8c694ef27e8cb ]

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
[ removed duplicate save_and_disable_daif macro ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -827,6 +827,7 @@ SYM_CODE_END(__bp_harden_el1_vectors)
  *
  */
 SYM_FUNC_START(cpu_switch_to)
+	save_and_disable_daif x11
 	mov	x10, #THREAD_CPU_CONTEXT
 	add	x8, x0, x10
 	mov	x9, sp
@@ -850,6 +851,7 @@ SYM_FUNC_START(cpu_switch_to)
 	ptrauth_keys_install_kernel x1, x8, x9, x10
 	scs_save x0
 	scs_load_current
+	restore_irq x11
 	ret
 SYM_FUNC_END(cpu_switch_to)
 NOKPROBE(cpu_switch_to)
@@ -876,6 +878,7 @@ NOKPROBE(ret_from_fork)
  * Calls func(regs) using this CPU's irq stack and shadow irq stack.
  */
 SYM_FUNC_START(call_on_irq_stack)
+	save_and_disable_daif x9
 #ifdef CONFIG_SHADOW_CALL_STACK
 	get_current_task x16
 	scs_save x16
@@ -890,8 +893,10 @@ SYM_FUNC_START(call_on_irq_stack)
 
 	/* Move to the new stack and call the function there */
 	add	sp, x16, #IRQ_STACK_SIZE
+	restore_irq x9
 	blr	x1
 
+	save_and_disable_daif x9
 	/*
 	 * Restore the SP from the FP, and restore the FP and LR from the frame
 	 * record.
@@ -899,6 +904,7 @@ SYM_FUNC_START(call_on_irq_stack)
 	mov	sp, x29
 	ldp	x29, x30, [sp], #16
 	scs_load_current
+	restore_irq x9
 	ret
 SYM_FUNC_END(call_on_irq_stack)
 NOKPROBE(call_on_irq_stack)


