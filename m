Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0911849;
	Thu, 13 Jun 2024 12:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282495; cv=none; b=PIcEe8tgw1DdzXcjz//DqJb2moisOfv9LHlUrQDbvQQmLoIdTikAOWslpl5eGGmvO1Mj2DzV8C9PiJd88WNxZ0z0AgozKhshHdwZ/2pR8xqo9wrxJgsFonB7S7QeLnL2GdGdc3Z01zUqab68sjuz40rD14NlQ4kaHVz9lITJmAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282495; c=relaxed/simple;
	bh=lwFEgXCHdI0X13JQIfzedF6Hj2UEWuFppZPUsiDtatA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUW1z6lFGSnZX6ZVhvZcp8crRRhDIjQO6f1Ob1C0Mp9sMrX1lWxvbhTMjRlTn6xrNZuCkKvjooyfEv8fVcAmR9sH2u2dU/QJxpBlo8PABDBYoYTGDCgpRLsktyAicIXfHJclv5bfAC904HH0xvv5cikQ/gOTF8onZLKJOHcML8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdZpkscH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdZpkscH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06537C2BBFC;
	Thu, 13 Jun 2024 12:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282495;
	bh=lwFEgXCHdI0X13JQIfzedF6Hj2UEWuFppZPUsiDtatA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdZpkscHQSbc/t4Po1G76RUcy47y7vEfrEvwGw/82DFafJtS0lZhxISK+Ke368fs2
	 hvdzM50Tis1o7ecEUOzVqXYdbdFUa021vj8wOhkehejJ9a6hwx9YUlGWV+pxWYnf53
	 P4XwdpCvvSzQeAZLIbQRlfW8QpCNPqdjWU2boob8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@linux.alibaba.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 297/402] riscv: stacktrace: Make walk_stackframe cross pt_regs frame
Date: Thu, 13 Jun 2024 13:34:14 +0200
Message-ID: <20240613113313.730874215@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
index 5ca2860cc06cd..851c967c49ccd 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -231,7 +231,7 @@ ret_from_syscall_rejected:
 	andi t0, t0, _TIF_SYSCALL_WORK
 	bnez t0, handle_syscall_trace_exit
 
-ret_from_exception:
+SYM_CODE_START_NOALIGN(ret_from_exception)
 	REG_L s0, PT_STATUS(sp)
 	csrc CSR_STATUS, SR_IE
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -245,6 +245,7 @@ ret_from_exception:
 	andi s0, s0, SR_SPP
 #endif
 	bnez s0, resume_kernel
+SYM_CODE_END(ret_from_exception)
 
 resume_userspace:
 	/* Interrupts must be disabled here so flags are checked atomically */
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 894ae66421a76..26f3916eea47c 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -18,6 +18,8 @@ register unsigned long sp_in_global __asm__("sp");
 
 #ifdef CONFIG_FRAME_POINTER
 
+extern asmlinkage void ret_from_exception(void);
+
 void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 			     bool (*fn)(void *, unsigned long), void *arg)
 {
@@ -62,6 +64,13 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
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



