Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA24FC12
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752D6C433D2;
	Mon, 15 May 2023 17:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172076;
	bh=mpGZfNNpTVB1GcfiV8cMRKxM2uPd48Abw51BIuSbG80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWX9Rg6fLb7B3FnnN7jZpOA7sbemRCUruq4cFMUE9KWrYEpskTuBmRadtqC/9Ss6j
	 5rLRa/ds/H9VDa9X0XUuzMLK56hr525YrYgbPD6jUhg6ecXfAFSZ5EtU5e8DuGqVd1
	 QnPyiZPoeFIFtSDnOujw3J27yKivfAoldNN/OxoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@suse.de>,
	Can Sun <cansun@arista.com>
Subject: [PATCH 5.10 007/381] x86/fpu: Prevent FPU state corruption
Date: Mon, 15 May 2023 18:24:18 +0200
Message-Id: <20230515161737.089517956@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Gleixner <tglx@linutronix.de>

commit 59f5ede3bc0f00eb856425f636dab0c10feb06d8 upstream.

The FPU usage related to task FPU management is either protected by
disabling interrupts (switch_to, return to user) or via fpregs_lock() which
is a wrapper around local_bh_disable(). When kernel code wants to use the
FPU then it has to check whether it is possible by calling irq_fpu_usable().

But the condition in irq_fpu_usable() is wrong. It allows FPU to be used
when:

   !in_interrupt() || interrupted_user_mode() || interrupted_kernel_fpu_idle()

The latter is checking whether some other context already uses FPU in the
kernel, but if that's not the case then it allows FPU to be used
unconditionally even if the calling context interrupted a fpregs_lock()
critical region. If that happens then the FPU state of the interrupted
context becomes corrupted.

Allow in kernel FPU usage only when no other context has in kernel FPU
usage and either the calling context is not hard interrupt context or the
hard interrupt did not interrupt a local bottomhalf disabled region.

It's hard to find a proper Fixes tag as the condition was broken in one way
or the other for a very long time and the eager/lazy FPU changes caused a
lot of churn. Picked something remotely connected from the history.

This survived undetected for quite some time as FPU usage in interrupt
context is rare, but the recent changes to the random code unearthed it at
least on a kernel which had FPU debugging enabled. There is probably a
higher rate of silent corruption as not all issues can be detected by the
FPU debugging code. This will be addressed in a subsequent change.

Fixes: 5d2bd7009f30 ("x86, fpu: decouple non-lazy/eager fpu restore from xsave")
Reported-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220501193102.588689270@linutronix.de
Signed-off-by: Can Sun <cansun@arista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/fpu/core.c |   67 +++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 41 deletions(-)

--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -25,17 +25,7 @@
  */
 union fpregs_state init_fpstate __read_mostly;
 
-/*
- * Track whether the kernel is using the FPU state
- * currently.
- *
- * This flag is used:
- *
- *   - by IRQ context code to potentially use the FPU
- *     if it's unused.
- *
- *   - to debug kernel_fpu_begin()/end() correctness
- */
+/* Track in-kernel FPU usage */
 static DEFINE_PER_CPU(bool, in_kernel_fpu);
 
 /*
@@ -43,42 +33,37 @@ static DEFINE_PER_CPU(bool, in_kernel_fp
  */
 DEFINE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
 
-static bool kernel_fpu_disabled(void)
-{
-	return this_cpu_read(in_kernel_fpu);
-}
-
-static bool interrupted_kernel_fpu_idle(void)
-{
-	return !kernel_fpu_disabled();
-}
-
-/*
- * Were we in user mode (or vm86 mode) when we were
- * interrupted?
- *
- * Doing kernel_fpu_begin/end() is ok if we are running
- * in an interrupt context from user mode - we'll just
- * save the FPU state as required.
- */
-static bool interrupted_user_mode(void)
-{
-	struct pt_regs *regs = get_irq_regs();
-	return regs && user_mode(regs);
-}
-
 /*
  * Can we use the FPU in kernel mode with the
  * whole "kernel_fpu_begin/end()" sequence?
- *
- * It's always ok in process context (ie "not interrupt")
- * but it is sometimes ok even from an irq.
  */
 bool irq_fpu_usable(void)
 {
-	return !in_interrupt() ||
-		interrupted_user_mode() ||
-		interrupted_kernel_fpu_idle();
+	if (WARN_ON_ONCE(in_nmi()))
+		return false;
+
+	/* In kernel FPU usage already active? */
+	if (this_cpu_read(in_kernel_fpu))
+		return false;
+
+	/*
+	 * When not in NMI or hard interrupt context, FPU can be used in:
+	 *
+	 * - Task context except from within fpregs_lock()'ed critical
+	 *   regions.
+	 *
+	 * - Soft interrupt processing context which cannot happen
+	 *   while in a fpregs_lock()'ed critical region.
+	 */
+	if (!in_irq())
+		return true;
+
+	/*
+	 * In hard interrupt context it's safe when soft interrupts
+	 * are enabled, which means the interrupt did not hit in
+	 * a fpregs_lock()'ed critical region.
+	 */
+	return !softirq_count();
 }
 EXPORT_SYMBOL(irq_fpu_usable);
 


