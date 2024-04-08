Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AE1823AE;
	Mon,  8 Apr 2024 13:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582667; cv=none; b=PGGwOG1LSY6UdzjmCzeMFF9d7Hrok56oIuxCLOg+6BOiQ9BdbSyxCkwGq9dZWKyw7HkBxZsT7TsOBc3xT/oFBkdtJTW+RHbIbRDT3jUqXndRdhZOz/MGlWgoodTTuKweMwcQ5b+okR2NoxiaUT8K5ylRf1ll+nsrk/SFFN2xTcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582667; c=relaxed/simple;
	bh=cAGRjAZO/YAsjdwvwoNlRtUYV+ugwN6iOQn+ijnPbsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jwzvw1nZUVcnE4Cv7V/47qko/lMpdHcSWKCQkcx1XHlPGFUGZqD3bttQy1rnHNAtC4rTWtIH/72z/bRCrSZTul+aABWk2XYYx/Rd2LF+FMwj+GxgdBZ4UnlAPxmHSEnVFZQ3SeCZJ13e8w3Ej5ElqGhHg6swxm5F9flWZtYPrPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bd7OhW4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bd7OhW4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B565BC433F1;
	Mon,  8 Apr 2024 13:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582667;
	bh=cAGRjAZO/YAsjdwvwoNlRtUYV+ugwN6iOQn+ijnPbsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bd7OhW4Bs2awtGaTn9zHxJu0Maghnf1koat5tuWJT5EtG021SBETsES4Qk3toq1Tz
	 cEocL1AbfdSgXyM/TDwcVSb+EKjl8ZFuQHkpyMuhB6GIq8xUnM5a+jtKNfhGDadpW4
	 siHUw/2usgnKGafDaNC7vaTzjGdStj9NQpMA4iK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan ORear <sorear@fastmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 124/138] riscv: process: Fix kernel gp leakage
Date: Mon,  8 Apr 2024 14:58:58 +0200
Message-ID: <20240408125300.090131399@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

From: Stefan O'Rear <sorear@fastmail.com>

commit d14fa1fcf69db9d070e75f1c4425211fa619dfc8 upstream.

childregs represents the registers which are active for the new thread
in user context. For a kernel thread, childregs->gp is never used since
the kernel gp is not touched by switch_to. For a user mode helper, the
gp value can be observed in user space after execve or possibly by other
means.

[From the email thread]

The /* Kernel thread */ comment is somewhat inaccurate in that it is also used
for user_mode_helper threads, which exec a user process, e.g. /sbin/init or
when /proc/sys/kernel/core_pattern is a pipe. Such threads do not have
PF_KTHREAD set and are valid targets for ptrace etc. even before they exec.

childregs is the *user* context during syscall execution and it is observable
from userspace in at least five ways:

1. kernel_execve does not currently clear integer registers, so the starting
   register state for PID 1 and other user processes started by the kernel has
   sp = user stack, gp = kernel __global_pointer$, all other integer registers
   zeroed by the memset in the patch comment.

   This is a bug in its own right, but I'm unwilling to bet that it is the only
   way to exploit the issue addressed by this patch.

2. ptrace(PTRACE_GETREGSET): you can PTRACE_ATTACH to a user_mode_helper thread
   before it execs, but ptrace requires SIGSTOP to be delivered which can only
   happen at user/kernel boundaries.

3. /proc/*/task/*/syscall: this is perfectly happy to read pt_regs for
   user_mode_helpers before the exec completes, but gp is not one of the
   registers it returns.

4. PERF_SAMPLE_REGS_USER: LOCKDOWN_PERF normally prevents access to kernel
   addresses via PERF_SAMPLE_REGS_INTR, but due to this bug kernel addresses
   are also exposed via PERF_SAMPLE_REGS_USER which is permitted under
   LOCKDOWN_PERF. I have not attempted to write exploit code.

5. Much of the tracing infrastructure allows access to user registers. I have
   not attempted to determine which forms of tracing allow access to user
   registers without already allowing access to kernel registers.

Fixes: 7db91e57a0ac ("RISC-V: Task implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Stefan O'Rear <sorear@fastmail.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20240327061258.2370291-1-sorear@fastmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/process.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -25,8 +25,6 @@
 #include <asm/thread_info.h>
 #include <asm/cpuidle.h>
 
-register unsigned long gp_in_global __asm__("gp");
-
 #if defined(CONFIG_STACKPROTECTOR) && !defined(CONFIG_STACKPROTECTOR_PER_TASK)
 #include <linux/stackprotector.h>
 unsigned long __stack_chk_guard __read_mostly;
@@ -170,7 +168,6 @@ int copy_thread(struct task_struct *p, c
 	if (unlikely(args->fn)) {
 		/* Kernel thread */
 		memset(childregs, 0, sizeof(struct pt_regs));
-		childregs->gp = gp_in_global;
 		/* Supervisor/Machine, irqs on: */
 		childregs->status = SR_PP | SR_PIE;
 


