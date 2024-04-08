Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1C08061A;
	Mon,  8 Apr 2024 14:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585191; cv=none; b=nhUzp65Qz7/9O7H+Vztq0udEKgbHFeCdyBE4bMLFv+rj5w4ClNe+DNdb7T6Yml9DrqeEn91tAo0DHN/dFrxUcQhYybbIxWGlwfswTIzfCj7gBtBrIhPD/OUk9YPz0/LQXl1v0dKfGndoS4j5Jd+pOkQdfvhImoBcqp6ODFXmp7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585191; c=relaxed/simple;
	bh=e06D7KgB3lXKN19lTnK83AGVZ6wojk0HPC3aSnDrMDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRNlUb6cQRLqK0l2PiwKlON/eXFYMd1X1YzivgHyH8kv6jcC9TWRcXmSqIFVFrtvmrMJNjKN4ghUNKyJvdTBeqPZKHLTLMto2t2ZwoeWKH/ERry8iLsBd+84DKTGgRO8z7c8hP1kikCVc8t0yi0MRhbPiEXlOxfVXqlCyYpDWNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL+mgmfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL+mgmfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592CEC433C7;
	Mon,  8 Apr 2024 14:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585191;
	bh=e06D7KgB3lXKN19lTnK83AGVZ6wojk0HPC3aSnDrMDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eL+mgmfCpVHAC/FrbSCpPbjfRVWkQY5kX7xHfr95yvi0HI1M7d2dHTsS3kUpLu7Pk
	 G1JhnSNQtASIKaKfezkX95GHYhkqgx1aE0TBprFjx/t+zxp1X5PeElmUIvFwpjl67v
	 Er4VJDacgqUR6z0qozS5lE5saVw0ZSfqeY+QBios=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan ORear <sorear@fastmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 684/690] riscv: process: Fix kernel gp leakage
Date: Mon,  8 Apr 2024 14:59:10 +0200
Message-ID: <20240408125424.501448953@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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
@@ -24,8 +24,6 @@
 #include <asm/switch_to.h>
 #include <asm/thread_info.h>
 
-register unsigned long gp_in_global __asm__("gp");
-
 #if defined(CONFIG_STACKPROTECTOR) && !defined(CONFIG_STACKPROTECTOR_PER_TASK)
 #include <linux/stackprotector.h>
 unsigned long __stack_chk_guard __read_mostly;
@@ -130,7 +128,6 @@ int copy_thread(unsigned long clone_flag
 	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		/* Kernel thread */
 		memset(childregs, 0, sizeof(struct pt_regs));
-		childregs->gp = gp_in_global;
 		/* Supervisor/Machine, irqs on: */
 		childregs->status = SR_PP | SR_PIE;
 


