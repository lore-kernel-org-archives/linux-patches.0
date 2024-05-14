Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605821D54D;
	Tue, 14 May 2024 11:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686393; cv=none; b=sxTfhVk826vZfKCUacARmd/PeEzGGoZZBni24MGKYG0E2x6QLVogWL4X5wEarLBhAuLYyJgewN3OGh5EDFo8TTRvlB87BIvxLquckYmbzmy0Z594uetA6Q8BKSdc8av1bwyQRK3ISR0SMM+q7WME0uP7KuzMyH7Yzv+LqZE4rqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686393; c=relaxed/simple;
	bh=PFuKsajUHwKWH9Vzwov4c0cqAUmy10qylb5stdOjYhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B814R01/Y5frSINdj58k8NvTp77bgCnh2iE2ukvj32LIhgfhNRKsQ0pUQGoOmbzSOkdJUj2lOvdMq3Rc0omUPY9536lQnooG91UQ15EDlmj0Sxm7K3bOA1j3vtYTZuaOwoTzV262D1Cp3dgFCKk1mcmgvRbrP6UTw/ujmbM5yBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbDVS9md; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbDVS9md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13A6C2BD10;
	Tue, 14 May 2024 11:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686393;
	bh=PFuKsajUHwKWH9Vzwov4c0cqAUmy10qylb5stdOjYhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbDVS9mdS1widEN9VmwgGoVt+ScnZRrjRfR71T+gVsPIgP6Xu/hh8kcMub5u01xoW
	 QE2QoOAU1n0BjPZgd52YWTphjgpqUnAZYtjAHbTDOJ9l1i/uKjWhTV0s5AVEzl86wj
	 kcmMeY5ISDV+0UOzXrFzZASwqoxOrS7LpnXzQZ2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/236] MIPS: scall: Save thread_info.syscall unconditionally on entry
Date: Tue, 14 May 2024 12:18:05 +0200
Message-ID: <20240514101025.041947331@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 4370b673ccf240bf7587b0cb8e6726a5ccaf1f17 ]

thread_info.syscall is used by syscall_get_nr to supply syscall nr
over a thread stack frame.

Previously, thread_info.syscall is only saved at syscall_trace_enter
when syscall tracing is enabled. However rest of the kernel code do
expect syscall_get_nr to be available without syscall tracing. The
previous design breaks collect_syscall.

Move saving process to syscall entry to fix it.

Reported-by: Xi Ruoyao <xry111@xry111.site>
Link: https://github.com/util-linux/util-linux/issues/2867
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/ptrace.h |  2 +-
 arch/mips/kernel/asm-offsets.c |  1 +
 arch/mips/kernel/ptrace.c      | 15 ++++++---------
 arch/mips/kernel/scall32-o32.S | 23 +++++++++++++----------
 arch/mips/kernel/scall64-n32.S |  3 ++-
 arch/mips/kernel/scall64-n64.S |  3 ++-
 arch/mips/kernel/scall64-o32.S | 33 +++++++++++++++++----------------
 7 files changed, 42 insertions(+), 38 deletions(-)

diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
index b3e4dd6be7e20..428b9f1cf1de2 100644
--- a/arch/mips/include/asm/ptrace.h
+++ b/arch/mips/include/asm/ptrace.h
@@ -157,7 +157,7 @@ static inline long regs_return_value(struct pt_regs *regs)
 #define instruction_pointer(regs) ((regs)->cp0_epc)
 #define profile_pc(regs) instruction_pointer(regs)
 
-extern asmlinkage long syscall_trace_enter(struct pt_regs *regs, long syscall);
+extern asmlinkage long syscall_trace_enter(struct pt_regs *regs);
 extern asmlinkage void syscall_trace_leave(struct pt_regs *regs);
 
 extern void die(const char *, struct pt_regs *) __noreturn;
diff --git a/arch/mips/kernel/asm-offsets.c b/arch/mips/kernel/asm-offsets.c
index c4501897b870b..08342b9eccdbd 100644
--- a/arch/mips/kernel/asm-offsets.c
+++ b/arch/mips/kernel/asm-offsets.c
@@ -98,6 +98,7 @@ void output_thread_info_defines(void)
 	OFFSET(TI_CPU, thread_info, cpu);
 	OFFSET(TI_PRE_COUNT, thread_info, preempt_count);
 	OFFSET(TI_REGS, thread_info, regs);
+	OFFSET(TI_SYSCALL, thread_info, syscall);
 	DEFINE(_THREAD_SIZE, THREAD_SIZE);
 	DEFINE(_THREAD_MASK, THREAD_MASK);
 	DEFINE(_IRQ_STACK_SIZE, IRQ_STACK_SIZE);
diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 567aec4abac0f..a8e569830ec8d 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -1309,16 +1309,13 @@ long arch_ptrace(struct task_struct *child, long request,
  * Notification of system call entry/exit
  * - triggered by current->work.syscall_trace
  */
-asmlinkage long syscall_trace_enter(struct pt_regs *regs, long syscall)
+asmlinkage long syscall_trace_enter(struct pt_regs *regs)
 {
 	user_exit();
 
-	current_thread_info()->syscall = syscall;
-
 	if (test_thread_flag(TIF_SYSCALL_TRACE)) {
 		if (ptrace_report_syscall_entry(regs))
 			return -1;
-		syscall = current_thread_info()->syscall;
 	}
 
 #ifdef CONFIG_SECCOMP
@@ -1327,7 +1324,7 @@ asmlinkage long syscall_trace_enter(struct pt_regs *regs, long syscall)
 		struct seccomp_data sd;
 		unsigned long args[6];
 
-		sd.nr = syscall;
+		sd.nr = current_thread_info()->syscall;
 		sd.arch = syscall_get_arch(current);
 		syscall_get_arguments(current, regs, args);
 		for (i = 0; i < 6; i++)
@@ -1337,23 +1334,23 @@ asmlinkage long syscall_trace_enter(struct pt_regs *regs, long syscall)
 		ret = __secure_computing(&sd);
 		if (ret == -1)
 			return ret;
-		syscall = current_thread_info()->syscall;
 	}
 #endif
 
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->regs[2]);
 
-	audit_syscall_entry(syscall, regs->regs[4], regs->regs[5],
+	audit_syscall_entry(current_thread_info()->syscall,
+			    regs->regs[4], regs->regs[5],
 			    regs->regs[6], regs->regs[7]);
 
 	/*
 	 * Negative syscall numbers are mistaken for rejected syscalls, but
 	 * won't have had the return value set appropriately, so we do so now.
 	 */
-	if (syscall < 0)
+	if (current_thread_info()->syscall < 0)
 		syscall_set_return_value(current, regs, -ENOSYS, 0);
-	return syscall;
+	return current_thread_info()->syscall;
 }
 
 /*
diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
index 18dc9b3450561..2c604717e6308 100644
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -77,6 +77,18 @@ loads_done:
 	PTR_WD	load_a7, bad_stack_a7
 	.previous
 
+	/*
+	 * syscall number is in v0 unless we called syscall(__NR_###)
+	 * where the real syscall number is in a0
+	 */
+	subu	t2, v0,  __NR_O32_Linux
+	bnez	t2, 1f /* __NR_syscall at offset 0 */
+	LONG_S	a0, TI_SYSCALL($28)	# Save a0 as syscall number
+	b	2f
+1:
+	LONG_S	v0, TI_SYSCALL($28)	# Save v0 as syscall number
+2:
+
 	lw	t0, TI_FLAGS($28)	# syscall tracing enabled?
 	li	t1, _TIF_WORK_SYSCALL_ENTRY
 	and	t0, t1
@@ -114,16 +126,7 @@ syscall_trace_entry:
 	SAVE_STATIC
 	move	a0, sp
 
-	/*
-	 * syscall number is in v0 unless we called syscall(__NR_###)
-	 * where the real syscall number is in a0
-	 */
-	move	a1, v0
-	subu	t2, v0,  __NR_O32_Linux
-	bnez	t2, 1f /* __NR_syscall at offset 0 */
-	lw	a1, PT_R4(sp)
-
-1:	jal	syscall_trace_enter
+	jal	syscall_trace_enter
 
 	bltz	v0, 1f			# seccomp failed? Skip syscall
 
diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
index 97456b2ca7dc3..97788859238c3 100644
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -44,6 +44,8 @@ NESTED(handle_sysn32, PT_SIZE, sp)
 
 	sd	a3, PT_R26(sp)		# save a3 for syscall restarting
 
+	LONG_S	v0, TI_SYSCALL($28)     # Store syscall number
+
 	li	t1, _TIF_WORK_SYSCALL_ENTRY
 	LONG_L	t0, TI_FLAGS($28)	# syscall tracing enabled?
 	and	t0, t1, t0
@@ -72,7 +74,6 @@ syscall_common:
 n32_syscall_trace_entry:
 	SAVE_STATIC
 	move	a0, sp
-	move	a1, v0
 	jal	syscall_trace_enter
 
 	bltz	v0, 1f			# seccomp failed? Skip syscall
diff --git a/arch/mips/kernel/scall64-n64.S b/arch/mips/kernel/scall64-n64.S
index e6264aa62e457..be11ea5cc67e0 100644
--- a/arch/mips/kernel/scall64-n64.S
+++ b/arch/mips/kernel/scall64-n64.S
@@ -46,6 +46,8 @@ NESTED(handle_sys64, PT_SIZE, sp)
 
 	sd	a3, PT_R26(sp)		# save a3 for syscall restarting
 
+	LONG_S	v0, TI_SYSCALL($28)     # Store syscall number
+
 	li	t1, _TIF_WORK_SYSCALL_ENTRY
 	LONG_L	t0, TI_FLAGS($28)	# syscall tracing enabled?
 	and	t0, t1, t0
@@ -82,7 +84,6 @@ n64_syscall_exit:
 syscall_trace_entry:
 	SAVE_STATIC
 	move	a0, sp
-	move	a1, v0
 	jal	syscall_trace_enter
 
 	bltz	v0, 1f			# seccomp failed? Skip syscall
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index d3c2616cba226..7a5abb73e5312 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -79,6 +79,22 @@ loads_done:
 	PTR_WD	load_a7, bad_stack_a7
 	.previous
 
+	/*
+	 * absolute syscall number is in v0 unless we called syscall(__NR_###)
+	 * where the real syscall number is in a0
+	 * note: NR_syscall is the first O32 syscall but the macro is
+	 * only defined when compiling with -mabi=32 (CONFIG_32BIT)
+	 * therefore __NR_O32_Linux is used (4000)
+	 */
+
+	subu	t2, v0,  __NR_O32_Linux
+	bnez	t2, 1f /* __NR_syscall at offset 0 */
+	LONG_S	a0, TI_SYSCALL($28)	# Save a0 as syscall number
+	b	2f
+1:
+	LONG_S	v0, TI_SYSCALL($28)	# Save v0 as syscall number
+2:
+
 	li	t1, _TIF_WORK_SYSCALL_ENTRY
 	LONG_L	t0, TI_FLAGS($28)	# syscall tracing enabled?
 	and	t0, t1, t0
@@ -113,22 +129,7 @@ trace_a_syscall:
 	sd	a7, PT_R11(sp)		# For indirect syscalls
 
 	move	a0, sp
-	/*
-	 * absolute syscall number is in v0 unless we called syscall(__NR_###)
-	 * where the real syscall number is in a0
-	 * note: NR_syscall is the first O32 syscall but the macro is
-	 * only defined when compiling with -mabi=32 (CONFIG_32BIT)
-	 * therefore __NR_O32_Linux is used (4000)
-	 */
-	.set	push
-	.set	reorder
-	subu	t1, v0,  __NR_O32_Linux
-	move	a1, v0
-	bnez	t1, 1f /* __NR_syscall at offset 0 */
-	ld	a1, PT_R4(sp) /* Arg1 for __NR_syscall case */
-	.set	pop
-
-1:	jal	syscall_trace_enter
+	jal	syscall_trace_enter
 
 	bltz	v0, 1f			# seccomp failed? Skip syscall
 
-- 
2.43.0



