Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746C81DEFC9;
	Tue,  8 Oct 2024 13:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393316; cv=none; b=Y2Fb08K1DRujF3sbDcqNnVyLDdc5qjGQJCneaaXESPFd7MPpuRZYRAuhwVhT+e08f/NQ0GF3AC0B4Txl0oZIYs/BMEJjqSG0+lt1Kaga1LmttyaECOjOdXW/PFtETZ8gwF/4GHgsBKMbnf42+3zWmMfbPk0U8GJV8P6z3K477zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393316; c=relaxed/simple;
	bh=uWcLAUPKAmR77u6ocVllhriF7pk77POsTBhNPJd28yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHLhfTNp3scKmtG++hYbyS1XSV4k+QxK3p9m6WQ2Ckvptr1iRYHt04RKGGBX4b29mCs2wP4Pk7RpZuJgRmCoYPAfg+yAkCLq+8cjEUZvU9BEfBYbhOA97R8YtK/LyV/1ESs97WHOutDSfjsSDUklyYjuoPdtkuDQ36xWtGdu5mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cj8pJOnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cj8pJOnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABA8C4CEC7;
	Tue,  8 Oct 2024 13:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393316;
	bh=uWcLAUPKAmR77u6ocVllhriF7pk77POsTBhNPJd28yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cj8pJOnt9oPlOxrbWRADgtXHCcA194iMqLfwJFn04WHLqMbTVF6OB12LT+hGOdAMo
	 PqGVsTE6rN/o43ZXZ69vqRnms/0pKX1Zxu171KWHudDy/cj234DQ1PXEx1DoYbnQxv
	 AULq2JIT4yNdd2tY8Q2GWz6cD+uMsZ+7IJkCI4JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/386] x86/pkeys: Add PKRU as a parameter in signal handling functions
Date: Tue,  8 Oct 2024 14:06:00 +0200
Message-ID: <20241008115633.969006747@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>

[ Upstream commit 24cf2bc982ffe02aeffb4a3885c71751a2c7023b ]

Assume there's a multithreaded application that runs untrusted user
code. Each thread has its stack/code protected by a non-zero PKEY, and the
PKRU register is set up such that only that particular non-zero PKEY is
enabled. Each thread also sets up an alternate signal stack to handle
signals, which is protected by PKEY zero. The PKEYs man page documents that
the PKRU will be reset to init_pkru when the signal handler is invoked,
which means that PKEY zero access will be enabled.  But this reset happens
after the kernel attempts to push fpu state to the alternate stack, which
is not (yet) accessible by the kernel, which leads to a new SIGSEGV being
sent to the application, terminating it.

Enabling both the non-zero PKEY (for the thread) and PKEY zero in
userspace will not work for this use case. It cannot have the alt stack
writeable by all - the rationale here is that the code running in that
thread (using a non-zero PKEY) is untrusted and should not have access
to the alternate signal stack (that uses PKEY zero), to prevent the
return address of a function from being changed. The expectation is that
kernel should be able to set up the alternate signal stack and deliver
the signal to the application even if PKEY zero is explicitly disabled
by the application. The signal handler accessibility should not be
dictated by whatever PKRU value the thread sets up.

The PKRU register is managed by XSAVE, which means the sigframe contents
must match the register contents - which is not the case here. It's
required that the signal frame contains the user-defined PKRU value (so
that it is restored correctly from sigcontext) but the actual register must
be reset to init_pkru so that the alt stack is accessible and the signal
can be delivered to the application. It seems that the proper fix here
would be to remove PKRU from the XSAVE framework and manage it separately,
which is quite complicated. As a workaround, do this:

        orig_pkru = rdpkru();
        wrpkru(orig_pkru & init_pkru_value);
        xsave_to_user_sigframe();
        put_user(pkru_sigframe_addr, orig_pkru)

In preparation for writing PKRU to sigframe, pass PKRU as an additional
parameter down the call chain from get_sigframe().

No functional change.

Signed-off-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20240802061318.2140081-2-aruna.ramakrishna@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/fpu/signal.h | 2 +-
 arch/x86/kernel/fpu/signal.c      | 6 +++---
 arch/x86/kernel/signal.c          | 3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/fpu/signal.h b/arch/x86/include/asm/fpu/signal.h
index 611fa41711aff..eccc75bc9c4f3 100644
--- a/arch/x86/include/asm/fpu/signal.h
+++ b/arch/x86/include/asm/fpu/signal.h
@@ -29,7 +29,7 @@ fpu__alloc_mathframe(unsigned long sp, int ia32_frame,
 
 unsigned long fpu__get_fpstate_size(void);
 
-extern bool copy_fpstate_to_sigframe(void __user *buf, void __user *fp, int size);
+extern bool copy_fpstate_to_sigframe(void __user *buf, void __user *fp, int size, u32 pkru);
 extern void fpu__clear_user_states(struct fpu *fpu);
 extern bool fpu__restore_sig(void __user *buf, int ia32_frame);
 
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 247f2225aa9f3..2b3b9e140dd41 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -156,7 +156,7 @@ static inline bool save_xstate_epilog(void __user *buf, int ia32_frame,
 	return !err;
 }
 
-static inline int copy_fpregs_to_sigframe(struct xregs_state __user *buf)
+static inline int copy_fpregs_to_sigframe(struct xregs_state __user *buf, u32 pkru)
 {
 	if (use_xsave())
 		return xsave_to_user_sigframe(buf);
@@ -185,7 +185,7 @@ static inline int copy_fpregs_to_sigframe(struct xregs_state __user *buf)
  * For [f]xsave state, update the SW reserved fields in the [f]xsave frame
  * indicating the absence/presence of the extended state to the user.
  */
-bool copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
+bool copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size, u32 pkru)
 {
 	struct task_struct *tsk = current;
 	struct fpstate *fpstate = tsk->thread.fpu.fpstate;
@@ -228,7 +228,7 @@ bool copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 		fpregs_restore_userregs();
 
 	pagefault_disable();
-	ret = copy_fpregs_to_sigframe(buf_fx);
+	ret = copy_fpregs_to_sigframe(buf_fx, pkru);
 	pagefault_enable();
 	fpregs_unlock();
 
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 65fe2094da59b..876d3b30c2c77 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -83,6 +83,7 @@ get_sigframe(struct ksignal *ksig, struct pt_regs *regs, size_t frame_size,
 	unsigned long math_size = 0;
 	unsigned long sp = regs->sp;
 	unsigned long buf_fx = 0;
+	u32 pkru = read_pkru();
 
 	/* redzone */
 	if (!ia32_frame)
@@ -138,7 +139,7 @@ get_sigframe(struct ksignal *ksig, struct pt_regs *regs, size_t frame_size,
 	}
 
 	/* save i387 and extended state */
-	if (!copy_fpstate_to_sigframe(*fpstate, (void __user *)buf_fx, math_size))
+	if (!copy_fpstate_to_sigframe(*fpstate, (void __user *)buf_fx, math_size, pkru))
 		return (void __user *)-1L;
 
 	return (void __user *)sp;
-- 
2.43.0



