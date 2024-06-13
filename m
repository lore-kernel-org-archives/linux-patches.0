Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE05144317;
	Thu, 13 Jun 2024 12:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282878; cv=none; b=Dkqzzk+WavESVHHPoocR7rbMBwlGOOngOnXTN05RgFrxmyd9bIK7FAagWKlEHZKMuvuEsNJEETyWBTeYqih0xeH6tSMX4677Zix7kVAIxpWJgz2X2T4JEGwkqXiVJNbEFRWRB0QAooCuqvMbTlZYFSTISvQ1LDbgkFt4IKMJNb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282878; c=relaxed/simple;
	bh=Gvq2R7aifBJsV9mZhzM8tSmja08iRFxYE7IAFb8lEF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aw9s2sF8qLiGWtM/k4iy4ipmnAugwQnOIqhMNjnI8SbEKE/VxVBK5bHtJjB481gVg9XkSo+s5xx7ZO3e4Y227X3oQlrCTMsCOgQn7yDbk1kE6x0emCybo0cZLz6Inxy81GkEye990M0TBzmJ411KDaYH5sq3/Nh8AK2Bu5oC+R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0aWA4YD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0aWA4YD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED943C4AF1A;
	Thu, 13 Jun 2024 12:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282878;
	bh=Gvq2R7aifBJsV9mZhzM8tSmja08iRFxYE7IAFb8lEF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0aWA4YD79AYyuoUGZ4/2bnvCIp/7AMj60r0s6L3icH5geQkpoGd/yHasF8S2ivDHr
	 mAszelHf2Ow38dGuPO6Q8Knh2E+slloeWh3gDXjjH2XhtDDYx8LgR1vBAlzdmzUMjf
	 9+IkY+x+DMeMflDIpd6t0P0O3oCfrLjLwOWCEXfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haorong Lu <ancientmodern4@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Conor Dooley <conor@kernel.org>
Subject: [PATCH 6.1 08/85] riscv: signal: handle syscall restart before get_signal
Date: Thu, 13 Jun 2024 13:35:06 +0200
Message-ID: <20240613113214.460101693@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

From: Haorong Lu <ancientmodern4@gmail.com>

commit ce4f78f1b53d3327fbd32764aa333bf05fb68818 upstream.

In the current riscv implementation, blocking syscalls like read() may
not correctly restart after being interrupted by ptrace. This problem
arises when the syscall restart process in arch_do_signal_or_restart()
is bypassed due to changes to the regs->cause register, such as an
ebreak instruction.

Steps to reproduce:
1. Interrupt the tracee process with PTRACE_SEIZE & PTRACE_INTERRUPT.
2. Backup original registers and instruction at new_pc.
3. Change pc to new_pc, and inject an instruction (like ebreak) to this
   address.
4. Resume with PTRACE_CONT and wait for the process to stop again after
   executing ebreak.
5. Restore original registers and instructions, and detach from the
   tracee process.
6. Now the read() syscall in tracee will return -1 with errno set to
   ERESTARTSYS.

Specifically, during an interrupt, the regs->cause changes from
EXC_SYSCALL to EXC_BREAKPOINT due to the injected ebreak, which is
inaccessible via ptrace so we cannot restore it. This alteration breaks
the syscall restart condition and ends the read() syscall with an
ERESTARTSYS error. According to include/linux/errno.h, it should never
be seen by user programs. X86 can avoid this issue as it checks the
syscall condition using a register (orig_ax) exposed to user space.
Arm64 handles syscall restart before calling get_signal, where it could
be paused and inspected by ptrace/debugger.

This patch adjusts the riscv implementation to arm64 style, which also
checks syscall using a kernel register (syscallno). It ensures the
syscall restart process is not bypassed when changes to the cause
register occur, providing more consistent behavior across various
architectures.

For a simplified reproduction program, feel free to visit:
https://github.com/ancientmodern/riscv-ptrace-bug-demo.

Signed-off-by: Haorong Lu <ancientmodern4@gmail.com>
Link: https://lore.kernel.org/r/20230803224458.4156006-1-ancientmodern4@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Conor Dooley <conor@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/signal.c |   85 ++++++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 39 deletions(-)

--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -246,30 +246,6 @@ static void handle_signal(struct ksignal
 	sigset_t *oldset = sigmask_to_save();
 	int ret;
 
-	/* Are we from a system call? */
-	if (regs->cause == EXC_SYSCALL) {
-		/* Avoid additional syscall restarting via ret_from_exception */
-		regs->cause = -1UL;
-		/* If so, check system call restarting.. */
-		switch (regs->a0) {
-		case -ERESTART_RESTARTBLOCK:
-		case -ERESTARTNOHAND:
-			regs->a0 = -EINTR;
-			break;
-
-		case -ERESTARTSYS:
-			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
-				regs->a0 = -EINTR;
-				break;
-			}
-			fallthrough;
-		case -ERESTARTNOINTR:
-                        regs->a0 = regs->orig_a0;
-			regs->epc -= 0x4;
-			break;
-		}
-	}
-
 	rseq_signal_deliver(ksig, regs);
 
 	/* Set up the stack frame */
@@ -283,36 +259,67 @@ static void handle_signal(struct ksignal
 
 static void do_signal(struct pt_regs *regs)
 {
+	unsigned long continue_addr = 0, restart_addr = 0;
+	int retval = 0;
 	struct ksignal ksig;
+	bool syscall = (regs->cause == EXC_SYSCALL);
 
-	if (get_signal(&ksig)) {
-		/* Actually deliver the signal */
-		handle_signal(&ksig, regs);
-		return;
-	}
+	/* If we were from a system call, check for system call restarting */
+	if (syscall) {
+		continue_addr = regs->epc;
+		restart_addr = continue_addr - 4;
+		retval = regs->a0;
 
-	/* Did we come from a system call? */
-	if (regs->cause == EXC_SYSCALL) {
 		/* Avoid additional syscall restarting via ret_from_exception */
 		regs->cause = -1UL;
 
-		/* Restart the system call - no handlers present */
-		switch (regs->a0) {
+		/*
+		 * Prepare for system call restart. We do this here so that a
+		 * debugger will see the already changed PC.
+		 */
+		switch (retval) {
 		case -ERESTARTNOHAND:
 		case -ERESTARTSYS:
 		case -ERESTARTNOINTR:
-                        regs->a0 = regs->orig_a0;
-			regs->epc -= 0x4;
-			break;
 		case -ERESTART_RESTARTBLOCK:
-                        regs->a0 = regs->orig_a0;
-			regs->a7 = __NR_restart_syscall;
-			regs->epc -= 0x4;
+			regs->a0 = regs->orig_a0;
+			regs->epc = restart_addr;
 			break;
 		}
 	}
 
 	/*
+	 * Get the signal to deliver. When running under ptrace, at this point
+	 * the debugger may change all of our registers.
+	 */
+	if (get_signal(&ksig)) {
+		/*
+		 * Depending on the signal settings, we may need to revert the
+		 * decision to restart the system call, but skip this if a
+		 * debugger has chosen to restart at a different PC.
+		 */
+		if (regs->epc == restart_addr &&
+		    (retval == -ERESTARTNOHAND ||
+		     retval == -ERESTART_RESTARTBLOCK ||
+		     (retval == -ERESTARTSYS &&
+		      !(ksig.ka.sa.sa_flags & SA_RESTART)))) {
+			regs->a0 = -EINTR;
+			regs->epc = continue_addr;
+		}
+
+		/* Actually deliver the signal */
+		handle_signal(&ksig, regs);
+		return;
+	}
+
+	/*
+	 * Handle restarting a different system call. As above, if a debugger
+	 * has chosen to restart at a different PC, ignore the restart.
+	 */
+	if (syscall && regs->epc == restart_addr && retval == -ERESTART_RESTARTBLOCK)
+		regs->a7 = __NR_restart_syscall;
+
+	/*
 	 * If there is no signal to deliver, we just put the saved
 	 * sigmask back.
 	 */


