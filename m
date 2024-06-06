Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC9319E7EA;
	Thu,  6 Jun 2024 14:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683528; cv=none; b=K5gCp0Eu1EV4Jq2vRBcDK3Q2CydcWoNksSv/uoAUO2jOLr2KY/9a7d1yRb06xvzBn7SXxKRTwjd9h7RDBXFRgjqyTj4/nm9Co13MxDaQjVNjzMr1e/tklDTJyiK6tEke2tyOeJeaPL3zgrZzvNQgnA3vClPYt3BJvezrgMxImww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683528; c=relaxed/simple;
	bh=dTnFzYoV5KRanRgc7RdF0e/HZF5qWP7iEfoi1Ku7wfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxKZqYx8C5O47OG2alvZJjG+NIZAQXV+1/BpjM/D7k0smpRlY4gsWc9+gwOlD5sT5pdK8xgfSk0O7LowMTV2jkuI/GS2uaomxvTjvBz0PKHMz+uK8jyha5TeFEUYcsbKDfmHMj211OT+vXpamXe99U/0Hel5p6CCG0myib/ot7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ibw9FUzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ibw9FUzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFED0C2BD10;
	Thu,  6 Jun 2024 14:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683528;
	bh=dTnFzYoV5KRanRgc7RdF0e/HZF5qWP7iEfoi1Ku7wfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ibw9FUzCIWoZmU32uWZo6rPoAu+sjM6rSOj5RqQqxjxxLm1Ci0WKh80wOEWX0lflD
	 YSq/WT8Tn0KaknGhjkFeOehvYc3fquCvsuoIj3PkUyWtIK5tHm1RbzeXCd/keqbH6o
	 BccKmLYRfvuRQ5B7bl4TNdpmfxyQvl8IOBUPF4wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@linux.alibaba.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 419/473] riscv: stacktrace: Make walk_stackframe cross pt_regs frame
Date: Thu,  6 Jun 2024 16:05:48 +0200
Message-ID: <20240606131713.630756461@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit 7ecdadf7f8c659524f6b2aebf6be7bf619764d90 ]

The current walk_stackframe with FRAME_POINTER would stop unwinding at
ret_from_exception:
  BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1518
  in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 1, name: init
  CPU: 0 PID: 1 Comm: init Not tainted 5.10.113-00021-g15c15974895c-dirty #192
  Call Trace:
  [<ffffffe0002038c8>] walk_stackframe+0x0/0xee
  [<ffffffe000aecf48>] show_stack+0x32/0x4a
  [<ffffffe000af1618>] dump_stack_lvl+0x72/0x8e
  [<ffffffe000af1648>] dump_stack+0x14/0x1c
  [<ffffffe000239ad2>] ___might_sleep+0x12e/0x138
  [<ffffffe000239aec>] __might_sleep+0x10/0x18
  [<ffffffe000afe3fe>] down_read+0x22/0xa4
  [<ffffffe000207588>] do_page_fault+0xb0/0x2fe
  [<ffffffe000201b80>] ret_from_exception+0x0/0xc

The optimization would help walk_stackframe cross the pt_regs frame and
get more backtrace of debug info:
  BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1518
  in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 1, name: init
  CPU: 0 PID: 1 Comm: init Not tainted 5.10.113-00021-g15c15974895c-dirty #192
  Call Trace:
  [<ffffffe0002038c8>] walk_stackframe+0x0/0xee
  [<ffffffe000aecf48>] show_stack+0x32/0x4a
  [<ffffffe000af1618>] dump_stack_lvl+0x72/0x8e
  [<ffffffe000af1648>] dump_stack+0x14/0x1c
  [<ffffffe000239ad2>] ___might_sleep+0x12e/0x138
  [<ffffffe000239aec>] __might_sleep+0x10/0x18
  [<ffffffe000afe3fe>] down_read+0x22/0xa4
  [<ffffffe000207588>] do_page_fault+0xb0/0x2fe
  [<ffffffe000201b80>] ret_from_exception+0x0/0xc
  [<ffffffe000613c06>] riscv_intc_irq+0x1a/0x72
  [<ffffffe000201b80>] ret_from_exception+0x0/0xc
  [<ffffffe00033f44a>] vma_link+0x54/0x160
  [<ffffffe000341d7a>] mmap_region+0x2cc/0x4d0
  [<ffffffe000342256>] do_mmap+0x2d8/0x3ac
  [<ffffffe000326318>] vm_mmap_pgoff+0x70/0xb8
  [<ffffffe00032638a>] vm_mmap+0x2a/0x36
  [<ffffffe0003cfdde>] elf_map+0x72/0x84
  [<ffffffe0003d05f8>] load_elf_binary+0x69a/0xec8
  [<ffffffe000376240>] bprm_execve+0x246/0x53a
  [<ffffffe00037786c>] kernel_execve+0xe8/0x124
  [<ffffffe000aecdf2>] run_init_process+0xfa/0x10c
  [<ffffffe000aece16>] try_to_run_init_process+0x12/0x3c
  [<ffffffe000afa920>] kernel_init+0xb4/0xf8
  [<ffffffe000201b80>] ret_from_exception+0x0/0xc

Here is the error injection test code for the above output:
 drivers/irqchip/irq-riscv-intc.c:
 static asmlinkage void riscv_intc_irq(struct pt_regs *regs)
 {
        unsigned long cause = regs->cause & ~CAUSE_IRQ_FLAG;
+       u32 tmp; __get_user(tmp, (u32 *)0);

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20221109064937.3643993-3-guoren@kernel.org
[Palmer: use SYM_CODE_*]
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: a2a4d4a6a0bf ("riscv: stacktrace: fixed walk_stackframe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/entry.S      | 3 ++-
 arch/riscv/kernel/stacktrace.c | 9 +++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 3221a9e5f3724..99d38fdf8b18f 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -248,7 +248,7 @@ ret_from_syscall_rejected:
 	andi t0, t0, _TIF_SYSCALL_WORK
 	bnez t0, handle_syscall_trace_exit
 
-ret_from_exception:
+SYM_CODE_START_NOALIGN(ret_from_exception)
 	REG_L s0, PT_STATUS(sp)
 	csrc CSR_STATUS, SR_IE
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -262,6 +262,7 @@ ret_from_exception:
 	andi s0, s0, SR_SPP
 #endif
 	bnez s0, resume_kernel
+SYM_CODE_END(ret_from_exception)
 
 	/* Interrupts must be disabled here so flags are checked atomically */
 	REG_L s0, TASK_TI_FLAGS(tp) /* current_thread_info->flags */
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 17d7383f201a5..64a9c093aef93 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -16,6 +16,8 @@
 
 #ifdef CONFIG_FRAME_POINTER
 
+extern asmlinkage void ret_from_exception(void);
+
 void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 			     bool (*fn)(void *, unsigned long), void *arg)
 {
@@ -60,6 +62,13 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 			fp = frame->fp;
 			pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
 						   &frame->ra);
+			if (pc == (unsigned long)ret_from_exception) {
+				if (unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
+					break;
+
+				pc = ((struct pt_regs *)sp)->epc;
+				fp = ((struct pt_regs *)sp)->s0;
+			}
 		}
 
 	}
-- 
2.43.0



