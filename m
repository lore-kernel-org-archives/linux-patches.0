Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051708;
	b=FrfmFB+4UrT16zZwxMiG6RlHe/bgEBZ8z7nmnmSEgITSLugwf3SAcYm4ZRf2GfJ/CFJ+
	 cKfH2+7KthSEjfdOMiQViTcuFWU0MFXjYh398pL6NKoV1FQ7zMhMd3Iw1MS7PbyvjBZ/h
	 CRTam4/efWUvUgGWSrwwu3euh4KvyRqaN/W4L6CS78w1u0ylqetygBPK/WCIXPtdSR+9q
	 1na65MliAORbmwnqaEpQb8zJZ1zN5ikjohbwSEazU6oBI1myTNtX4jpDJJM4wsBowfKOo
	 A0tM7dLJwDjV1FNn/HIQPawKZUVMwxEHd1B5sob88njT86c6iwBZBWzqwQj4Ic+7LkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HO9Sgp+EVfIX1TWsre0ETR+eosJ1x4J4jkBYwcMH8gw=;
	b=eI/3QESiv4Ik9/NZoNh2tUV6WWTFa9LVn0mD5sorMw+4MdQEqssmclv1fi2yQnC5UqJH
	 Nyuvl2tdPJ0F8ho8+ellUpsvdRwXU5N9EiORajPvC0TFjXMgdG0tBf6IgIPub+5uwMRRN
	 w7jT/BQ4JsJ5d8d32KKiyqeVvOnHLr+CETHLpgqzBF/loSIxpGTQTm6jgjgYv9ljKbQIg
	 PSGep5Mw4XkzTZeq0BvYII2FMrb2UncNjjyjkrOA1JcQPgF6q43b7YmLD2L6o6sb5bkkK
	 XqwMnTMxkdNkUI6JjpnnfJ0SAOlRZQQ6tkc/dYgJq/6BokUpNh/X1GNcuLhlPKWpQ1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EyI66bcl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FF3606A320;
	Thu, 19 Nov 2026 01:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EyI66bcl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74581F000C5;
	Thu, 19 Nov 2026 01:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051708;
	bh=HO9Sgp+EVfIX1TWsre0ETR+eosJ1x4J4jkBYwcMH8gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EyI66bclmjzdldV48ycaC+eM3XFyZDngbvTBPtgmkB4gbfxKJSgkRVqfLqNBzwCuA
	 QRTpD8klLcRWN5tdK8to6es8g9ZImXrluO3KeskBPf/AOzEDUK27selIkmEZelNtI8
	 5NCn6ia602ccqFJ8TAzpSEWfdWMiMBtymIFsS6cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 0302/2214] s390/signal: Fix incorrect return address in signal frame
Date: Wed, 18 Nov 2026 15:32:58 +0100
Message-ID: <20261118150022.264967618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -132,6 +132,12 @@ int copy_thread(unsigned long clone_flag
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
@@ -176,12 +182,6 @@ int copy_thread(unsigned long clone_flag
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
@@ -492,7 +492,11 @@ void arch_do_signal_or_restart(struct pt
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


