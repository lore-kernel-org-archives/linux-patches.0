Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827084;
	b=I21vGPDWityPwwfC8f/FcpVB4pkNsW5cCqSiIZj2wwxEF55yJtiYpAUXbOKsh3yHsNZo
	 sJhJcr0MRyxXELWnPNzm/3HD8ciMne72uyAGF3aEMTg0E0iWeUDTBuP/p/JPwZ3Orr1j8
	 p82O54hCsmRCMv4xY/qp+WEIyUfXKdsCnjrSAF+1iOeF9Ts1sDwfoEfMwI0EFA/qRjQa+
	 Nml3B35mc9Q9leknmQ6HjBLl+biKIYjY19OkMDl/R8PsUEl2c7t13/OM5fFwIlhNZQ+2M
	 UllLrOST7JsR39XvrvyFiZ8wool6vKnQWZj5Ffy14sko3gBkAPZ8Y3NXqY5PbQMqOzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UqdNdxS/g/GxjUCDYgrM2QjQHbmSqYytfuSCKgKZcso=;
	b=wr8xuMHEi1e1W/vo3L4Dg4wMFEydYVu1o0MCh48jRWmXnIvURswQZx3tRWjLa9ZS/U2a
	 1jO4b6ZHeAhKLs/o1uDOz4U3RXLZYysN9SggbzeYKGGqLg2jIxxcS9i19/t8+xIo4VrnW
	 qRYSwBYemBBf5P8HPLbci9hAVs1RxDBnClIVp13zdopK3+hh35xbiNeH+Z8iAzsncUeze
	 aOhjwFDyqKjEvEgI7Kaq6A08uSrLa40205Eox6LBCiZ51K4HIQwAVMOMLHexKC2/7FR2Z
	 JSrNeHx0uUtUgpLeienuRgyDT3767G7LLz+x3Y8c+uI0BCyNfyjf2VmU/rCj0CT4FXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ELA1SM9B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4FC606A86D;
	Wed,  4 Nov 2026 21:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ELA1SM9B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026711F000C1;
	Wed,  4 Nov 2026 21:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827084;
	bh=UqdNdxS/g/GxjUCDYgrM2QjQHbmSqYytfuSCKgKZcso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ELA1SM9BEmHkfYPUSUNYGeRZuvf6lJcB7b+Pf3gcckkQhpajc7jeNJfz2sf3vmINY
	 huE2US1fmFDksn9sLA7h3z1ZciH2Bi+uPxG1li5we46tVnKP/WEvq1TW6cC5lYRYoC
	 jo6sqRwbd7magvCoqjFxr/Fbcuv2jzMcnzzM2Q3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.3 178/547] s390/signal: Fix incorrect return address in signal frame
Date: Wed,  4 Nov 2026 16:06:02 -0500
Message-ID: <20261104211043.204014388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -131,6 +131,12 @@ int copy_thread(struct task_struct *p, c
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
 	frame->sf.gprs[11 - 6] = (unsigned long)&frame->childregs;
@@ -168,12 +174,6 @@ int copy_thread(struct task_struct *p, c
 		p->thread.acrs[0] = (unsigned int)(tls >> 32);
 		p->thread.acrs[1] = (unsigned int)tls;
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
@@ -475,7 +475,11 @@ void arch_do_signal_or_restart(struct pt
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
 		handle_signal(&ksig, oldset, regs);
 		return;


