Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044370;
	b=uZfb/fumdNUXDrTA5h3g01Ky5IpzqAWwpKWbKSrWKtI7yYxl1bOTVa8OFt7yFFyICXvp
	 SWkUlQtH4zLnxKcTT76KxCBjrphCrBasRO+cQ3Zm6tTcP86x+lOj6LUs2EBd1RXQvH7ta
	 qyTXjtTOArsXGBxTiiOQ76P+O5YI2MFNFhE4Gb7ny0TkEwEXNbvj4SrqpD7QBqUnriY1j
	 KIO1/R2Jb7NQtUIROgBLJWYuCk5YBrf5w/evt5L18DUXBaaI0psQOI3WQ1IYeMFBaJTDj
	 2zETQWrohV6mA+ZG1sv4mvjJ7L/wuzjOiH+f5eIHooTFrhvEEXcCMAgMCCMVvXJARMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FOigbaOW9nT8iD8pupsznI4I5n886oEoqqED3d/9iu4=;
	b=ijN18O1vp7JIWmN3eYMzWiw0Qbf4hNehKRPwllEG+oifyEMBG6ohe2QqkmZaxL33wT3z
	 Ya9XJzWlVUWclXW4gMdd/p+sns+e+uq+HsG0fQbKO/xdP8D36ltUH8wi5vZS+YROiI+vL
	 U5i/9dieAwFBFrxnhsRMbkbVWzdECxBOrU8znR7T2QWwyXLoc16+YPpWm4RBEJHFNDPLP
	 KOvyw1GzS5E3T6P9oRikqEenBG9aw2siEo1BdYPnCOLB6FMX1BRc5O8Z8KvXlfuLgb/7Y
	 83DPsFe1EKCwmuTx/cd5dF83MxlgWVPwj31D0/ImWLknaXdwZJ150pOfQpYwHJylsag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TScT7Oen;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894EB606A31C;
	Wed, 18 Nov 2026 23:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TScT7Oen
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DEC1F000C4;
	Wed, 18 Nov 2026 23:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044370;
	bh=FOigbaOW9nT8iD8pupsznI4I5n886oEoqqED3d/9iu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TScT7OentyR2uGyZx06daZazz4IauS9+twCMc8PNs0bg53MPB/qxVc3n491KI884i
	 L32w1ZQggj1hCtCL5nYLaKkj54S40nqrHUj+8pgtXp0Wr3F3/gmlIr1LhdZC8lNoo7
	 4oAmVYj+QCfiO57K6KdvQQzfxkzrsHSLb+BzPuJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.1 0543/2857] s390/signal: Fix incorrect return address in signal frame
Date: Wed, 18 Nov 2026 15:26:17 +0100
Message-ID: <20261118150221.037548965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit adc9e872f7350e3ac29c1818d8c68b0760b4ba23 upstream.

exit_to_user_mode_loop() can call arch_do_signal_or_restart() multiple
times when signals are pending.

If the first call set up a vDSO system call restart by saving the real
user return address and adjusting psw.addr so it points to the vDSO stub,
a second call builds the signal frame with the wrong return address.

Restore psw.addr from arch_data, and set the return code to -EINTR before
building the signal frame.

This requires restart_block.arch_data to be properly initialized for all
tasks. Move the initialization in copy_thread() in front of the kernel
thread check, so that it also covers kernel threads and their children
(PID 1, usermode helpers). Only PID 0 is left uninitialized, since it
never returns to user space.

Fixes: df29a7440c4b ("s390/signal: switch to using vdso for sigreturn and syscall restart")
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/process.c |   12 ++++++------
 arch/s390/kernel/signal.c  |    6 +++++-
 2 files changed, 11 insertions(+), 7 deletions(-)

--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -134,6 +134,12 @@ int copy_thread(struct task_struct *p, c
 	p->thread.hardirq_timer = 0;
 	p->thread.softirq_timer = 0;
 	p->thread.last_break = 1;
+	/*
+	 * s390 stores the svc return address in arch_data when calling
+	 * sigreturn()/restart_syscall() via vdso. 1 means no valid address
+	 * stored.
+	 */
+	p->restart_block.arch_data = 1;
 
 	frame->sf.back_chain = 0;
 	frame->sf.gprs[5] = (unsigned long)frame + sizeof(struct stack_frame);
@@ -177,12 +183,6 @@ int copy_thread(struct task_struct *p, c
 			p->thread.acrs[1] = (unsigned int)tls;
 		}
 	}
-	/*
-	 * s390 stores the svc return address in arch_data when calling
-	 * sigreturn()/restart_syscall() via vdso. 1 means no valid address
-	 * stored.
-	 */
-	p->restart_block.arch_data = 1;
 	return 0;
 }
 
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -491,7 +491,11 @@ void arch_do_signal_or_restart(struct pt
 		}
 		/* No longer in a system call */
 		clear_pt_regs_flag(regs, PIF_SYSCALL);
-
+		if (!(current->restart_block.arch_data & 1)) {
+			regs->psw.addr = current->restart_block.arch_data;
+			current->restart_block.arch_data = 1;
+			regs->gprs[2] = -EINTR;
+		}
 		rseq_signal_deliver(&ksig, regs);
 		if (is_compat_task())
 			handle_signal32(&ksig, oldset, regs);


