Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061594;
	b=Md+M0PveIWm/I6lwUy9w7sfvMdUNJ8rL5HmQZ4omG3XUT+hjuO5+GSjDUqSa9WSdBIIH
	 zB8LceyXdCqI1i2/pVwCNEjA+VjUOgRJrRjL1ZypbNRXjcKToySW3vrNQIfaGSVgf1IXT
	 R1NEPS/V4+kWVWFEpQS5u/j5RYpkx5BCb874AZhPSWwtZZRy6emVfGxLGzQCs0Gy4YtZz
	 NWhfhJvn4xxIAYT9uP/eIShr9vdgb2o6ng9r3k5iqvQWMrEeIYf934lUW9l2t47EMWTYW
	 796WDS2CqeQ0PZH2zf7mCs/9rRtaRehv09oyuAmoXlAMpwnEV6JI3G2Zw+jo/yBaMEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ffk9wnZ1YQn1vdhOVF/HvPRTnEPlPa0WGky46k+zkdw=;
	b=Wgd5w3DLn8aw8c1CKDdmquSrk1F8UUCN1AFQgQ8NcVb26/ANrVb99+06NxR3onapA59y
	 rcZawny1vvjoOyaSdhsJvNg4pStbnekQ9LZYYayn1Yd9UgzW0t1ZelpZ0PlUyi88qW1LB
	 ybbbGS9dYXv8l2fclbuetTSytI0TLhMmlR94NO3gxhnTgkOr15jrI45pgKgfZiBrkClAA
	 5igLkEuQ7X3DQwtG0ObK4rYb7ItbQSWj0ZdPQ3rJLrecF30v5jjXUx8CdXmFwFcyNdxYb
	 BwX35pd2TPpic7I7mom8BqzSYWQoylluNLqV70UgcF/zOv1TKZrUVG09+1dvCFUts1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Aj4srcI3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62F3606A32D;
	Sat,  7 Nov 2026 14:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Aj4srcI3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4027B1F0089F;
	Sat,  7 Nov 2026 14:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061593;
	bh=Ffk9wnZ1YQn1vdhOVF/HvPRTnEPlPa0WGky46k+zkdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aj4srcI3MIP42ZJYtsprKrZQeAO4knf1Xf43sktnhsKY+fa7VeP6HcnT/tOPRsxJf
	 gY8f3daAcdbOrBcC70nPoA63LhYs6t3pHlOtG33PPdy4fbn1hpZdAUzNy0OWqmcztw
	 SR3yp90SG8TkDLfVrAUHXIS7Mz5xPSubYxYuwF88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 0619/1536] s390/signal: Fix incorrect return address in signal frame
Date: Sat,  7 Nov 2026 08:43:55 -0500
Message-ID: <20261107135014.920122240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -133,6 +133,12 @@ int copy_thread(struct task_struct *p, c
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
@@ -174,12 +180,6 @@ int copy_thread(struct task_struct *p, c
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
@@ -488,7 +488,11 @@ void arch_do_signal_or_restart(struct pt
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


