Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831409;
	b=Fl6R3Er4pQg9gzXSxndbjbP+Af0mfh2gtG34i3qsCX6wWsfurKXdVmfN41UqSGUS8lxb
	 U9rMApqouFmIXJxnfmG383eJ1odw77V7fUecXeYw0ARRLxe1MPosICWhpovcq9/Go83hw
	 w303Al036kGPdUAkA17GzebRYH8noAu6j3C7j6CwEeIniuDSP4iJ1Tzmrj8Wr2M8DOvKc
	 k6ITXvYbMLZuzUKNePtOx9Wk92uoG54Nel1MxmS+v0lPRfbmiToZ57gTKUNuGvfETkK1v
	 671QMeKiHPfYCq5zB5mEOZgzQ8VPxxO6RAszPKtK70vCmS+jrdPmbAn8yZVbqlwJiQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eSFvcr40OXL6doj4QipvJMXoK3Nc23D6gmo36IwOAPo=;
	b=leBzb0T+gBGZhfXijjAyyQLNr99tQsKZy0nctsj9rE+KArP8hv2gwTnQ1KumPb2CKt1H
	 e/A3LbqDSBSFfJYoEhVbgA+4WP8IM0eumD5TdIGd8RY1SXDgydG+T8a++oJoMY+66SNB2
	 OSS1CcOKn64buaPXkbDT45K+oizmR7rbFoGDCNW0pbhLgXFl5xS0B0rPIP8dAOsm9SlEG
	 MQ7El0ESZqQ5JMHS0mfHAGrUG19b7nsUon4nz4IGpGaRaOw8QxsjDJVq2sO/f6HQsuhLN
	 9dtqCLY36xk0CanJ5UPKIFt52SEAxHzONEvDPsryX1pl1Cm82m7Y3HQ1p5j7nBdE2eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xltLbKLy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D7D606AB29;
	Wed,  4 Nov 2026 22:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xltLbKLy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D434E1F00919;
	Wed,  4 Nov 2026 22:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831409;
	bh=eSFvcr40OXL6doj4QipvJMXoK3Nc23D6gmo36IwOAPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xltLbKLyh5lbB2WhmZ93QmKL6iC9UNRZGByHMnlOXZ7bYN4dC2GMp3Uc/4KAK+B+M
	 cXfFhF+NFlslJDQPIzGOSOWmPiDdPC/8MrQqJPlX+RqUy2wCz6/oVkgplSNzqP7Rh6
	 r+fJskRLKaZ6CQ6opnU9LVCvH/ZJXy8cWqTtLW6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.18 0688/1005] s390/signal: Fix incorrect return address in signal frame
Date: Wed,  4 Nov 2026 16:07:01 -0500
Message-ID: <20261104211102.888241985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -132,6 +132,12 @@ int copy_thread(struct task_struct *p, c
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
@@ -173,12 +179,6 @@ int copy_thread(struct task_struct *p, c
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


