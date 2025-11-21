Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3843A350A2A;
	Fri, 21 Nov 2025 13:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733050; cv=none; b=q5Xxm938s93DjD6Q1n9G0sDpnsnGoyXf33c+RCpgOINq5afhTcRfof/3sD/ElbeQpJGxAvb/OLfCGMSPLRroVuMmXMogwZRS85YKMdPN7I5Qm+SJiPok+nqWZ9C1hxdwP8QZNYxEA2BXzuIAKYl3b1ENp0dQpBLnJY2LNfSRZHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733050; c=relaxed/simple;
	bh=CjpervJYtaw+iiH4WoYI8PBzoIMSEZ5UE0YxD5UsBYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ary/xPCmv6ZcKoXr01lP1+UXZQ4jPs94Sl/01r7HgROQoAHZv2atFNmOHG332oNvD74cKWjfH6KiufcXRNXSRY+zakygOm2UHMRiEcNeWtYKbWNRTQ0gDzUFeJ4P/J6sM5WuGANTkLKwMVEMsGklB0RYs3oA9WcR1XqyMxgi9vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwdidWIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwdidWIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6E1C116C6;
	Fri, 21 Nov 2025 13:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733049;
	bh=CjpervJYtaw+iiH4WoYI8PBzoIMSEZ5UE0YxD5UsBYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwdidWIsQ0AB4T0yS0jRkCGKQHI0uALGoDekAbWv1XcGn2jb3myXY7KQrRTHreJyq
	 lwzELQY7898n5qSqXWHvYs9rQ/Y9GJ043KG7iDVk5+TflvEfrMsFK4FFltClp+u+yD
	 UJ5FOPW37PsPy3PisAPGaxyV68KZ+UnPkftQaoGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Blanchard <antonb@tenstorrent.com>,
	Cyril Bur <cyrilbur@tenstorrent.com>,
	Jisheng Zhang <jszhang@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 333/529] riscv: Improve exception and system call latency
Date: Fri, 21 Nov 2025 14:10:32 +0100
Message-ID: <20251121130242.877245835@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Anton Blanchard <antonb@tenstorrent.com>

[ Upstream commit 5d5fc33ce58e81e8738816f5ee59f8e85fd3b404 ]

Many CPUs implement return address branch prediction as a stack. The
RISCV architecture refers to this as a return address stack (RAS). If
this gets corrupted then the CPU will mispredict at least one but
potentally many function returns.

There are two issues with the current RISCV exception code:

- We are using the alternate link stack (x5/t0) for the indirect branch
  which makes the hardware think this is a function return. This will
  corrupt the RAS.

- We modify the return address of handle_exception to point to
  ret_from_exception. This will also corrupt the RAS.

Testing the null system call latency before and after the patch:

Visionfive2 (StarFive JH7110 / U74)
baseline: 189.87 ns
patched:  176.76 ns

Lichee pi 4a (T-Head TH1520 / C910)
baseline: 666.58 ns
patched:  636.90 ns

Just over 7% on the U74 and just over 4% on the C910.

Signed-off-by: Anton Blanchard <antonb@tenstorrent.com>
Signed-off-by: Cyril Bur <cyrilbur@tenstorrent.com>
Tested-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://lore.kernel.org/r/20240607061335.2197383-1-cyrilbur@tenstorrent.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: 060ea84a484e ("riscv: stacktrace: Disable KASAN checks for non-current tasks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/entry.S      | 17 ++++++++++-------
 arch/riscv/kernel/stacktrace.c |  4 ++--
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 1f90fee24a8ba..56c101e381270 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -82,7 +82,6 @@ _save_context:
 	la gp, __global_pointer$
 .option pop
 	move a0, sp /* pt_regs */
-	la ra, ret_from_exception
 
 	/*
 	 * MSB of cause differentiates between
@@ -91,7 +90,8 @@ _save_context:
 	bge s4, zero, 1f
 
 	/* Handle interrupts */
-	tail do_irq
+	call do_irq
+	j ret_from_exception
 1:
 	/* Handle other exceptions */
 	slli t0, s4, RISCV_LGPTR
@@ -99,11 +99,14 @@ _save_context:
 	la t2, excp_vect_table_end
 	add t0, t1, t0
 	/* Check if exception code lies within bounds */
-	bgeu t0, t2, 1f
-	REG_L t0, 0(t0)
-	jr t0
-1:
-	tail do_trap_unknown
+	bgeu t0, t2, 3f
+	REG_L t1, 0(t0)
+2:	jalr t1
+	j ret_from_exception
+3:
+
+	la t1, do_trap_unknown
+	j 2b
 SYM_CODE_END(handle_exception)
 ASM_NOKPROBE(handle_exception)
 
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 10e311b2759d3..c6d5de22463f9 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -16,7 +16,7 @@
 
 #ifdef CONFIG_FRAME_POINTER
 
-extern asmlinkage void ret_from_exception(void);
+extern asmlinkage void handle_exception(void);
 
 static inline int fp_is_valid(unsigned long fp, unsigned long sp)
 {
@@ -71,7 +71,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 			fp = frame->fp;
 			pc = ftrace_graph_ret_addr(current, &graph_idx, frame->ra,
 						   &frame->ra);
-			if (pc == (unsigned long)ret_from_exception) {
+			if (pc == (unsigned long)handle_exception) {
 				if (unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
 					break;
 
-- 
2.51.0



