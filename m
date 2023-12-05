Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C6D6FAF;
	Tue,  5 Dec 2023 03:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cc+02oXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C1BC433C7;
	Tue,  5 Dec 2023 03:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746869;
	bh=Ztna5PF7vMKwBASTux99q+p6Y1WjesMfzjactkT2170=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cc+02oXDlWioEuM5kYYPNVg8EmCQbw2IfaRSAi5Sust2tGUKkME2HwmITZkfFhVvu
	 WTaDrCLiNKMaBURP7z5/u8ICyEXN+QwSXgvaodV1iyh80P5jJP4sGcVwSQL8O6H0Wr
	 1tOrZkUfuWNocaDRc5q/EB65PN9FLeqVmA/CSmBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timothy Pearson <tpearson@raptorengineering.com>,
	Jens Axboe <axboe@kernel.dk>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 42/71] powerpc: Dont clobber f0/vs0 during fp|altivec register save
Date: Tue,  5 Dec 2023 12:16:40 +0900
Message-ID: <20231205031520.272459538@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timothy Pearson <tpearson@raptorengineering.com>

commit 5e1d824f9a283cbf90f25241b66d1f69adb3835b upstream.

During floating point and vector save to thread data f0/vs0 are
clobbered by the FPSCR/VSCR store routine. This has been obvserved to
lead to userspace register corruption and application data corruption
with io-uring.

Fix it by restoring f0/vs0 after FPSCR/VSCR store has completed for
all the FP, altivec, VMX register save paths.

Tested under QEMU in kvm mode, running on a Talos II workstation with
dual POWER9 DD2.2 CPUs.

Additional detail (mpe):

Typically save_fpu() is called from __giveup_fpu() which saves the FP
regs and also *turns off FP* in the tasks MSR, meaning the kernel will
reload the FP regs from the thread struct before letting the task use FP
again. So in that case save_fpu() is free to clobber f0 because the FP
regs no longer hold live values for the task.

There is another case though, which is the path via:
  sys_clone()
    ...
    copy_process()
      dup_task_struct()
        arch_dup_task_struct()
          flush_all_to_thread()
            save_all()

That path saves the FP regs but leaves them live. That's meant as an
optimisation for a process that's using FP/VSX and then calls fork(),
leaving the regs live means the parent process doesn't have to take a
fault after the fork to get its FP regs back. The optimisation was added
in commit 8792468da5e1 ("powerpc: Add the ability to save FPU without
giving it up").

That path does clobber f0, but f0 is volatile across function calls,
and typically programs reach copy_process() from userspace via a syscall
wrapper function. So in normal usage f0 being clobbered across a
syscall doesn't cause visible data corruption.

But there is now a new path, because io-uring can call copy_process()
via create_io_thread() from the signal handling path. That's OK if the
signal is handled as part of syscall return, but it's not OK if the
signal is handled due to some other interrupt.

That path is:

interrupt_return_srr_user()
  interrupt_exit_user_prepare()
    interrupt_exit_user_prepare_main()
      do_notify_resume()
        get_signal()
          task_work_run()
            create_worker_cb()
              create_io_worker()
                copy_process()
                  dup_task_struct()
                    arch_dup_task_struct()
                      flush_all_to_thread()
                        save_all()
                          if (tsk->thread.regs->msr & MSR_FP)
                            save_fpu()
                            # f0 is clobbered and potentially live in userspace

Note the above discussion applies equally to save_altivec().

Fixes: 8792468da5e1 ("powerpc: Add the ability to save FPU without giving it up")
Cc: stable@vger.kernel.org # v4.6+
Closes: https://lore.kernel.org/all/480932026.45576726.1699374859845.JavaMail.zimbra@raptorengineeringinc.com/
Closes: https://lore.kernel.org/linuxppc-dev/480221078.47953493.1700206777956.JavaMail.zimbra@raptorengineeringinc.com/
Tested-by: Timothy Pearson <tpearson@raptorengineering.com>
Tested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
[mpe: Reword change log to describe exact path of corruption & other minor tweaks]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/1921539696.48534988.1700407082933.JavaMail.zimbra@raptorengineeringinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/fpu.S    |   13 +++++++++++++
 arch/powerpc/kernel/vector.S |    2 ++
 2 files changed, 15 insertions(+)

--- a/arch/powerpc/kernel/fpu.S
+++ b/arch/powerpc/kernel/fpu.S
@@ -29,6 +29,15 @@
 #include <asm/feature-fixups.h>
 
 #ifdef CONFIG_VSX
+#define __REST_1FPVSR(n,c,base)						\
+BEGIN_FTR_SECTION							\
+	b	2f;							\
+END_FTR_SECTION_IFSET(CPU_FTR_VSX);					\
+	REST_FPR(n,base);						\
+	b	3f;							\
+2:	REST_VSR(n,c,base);						\
+3:
+
 #define __REST_32FPVSRS(n,c,base)					\
 BEGIN_FTR_SECTION							\
 	b	2f;							\
@@ -47,9 +56,11 @@ END_FTR_SECTION_IFSET(CPU_FTR_VSX);
 2:	SAVE_32VSRS(n,c,base);						\
 3:
 #else
+#define __REST_1FPVSR(n,b,base)		REST_FPR(n, base)
 #define __REST_32FPVSRS(n,b,base)	REST_32FPRS(n, base)
 #define __SAVE_32FPVSRS(n,b,base)	SAVE_32FPRS(n, base)
 #endif
+#define REST_1FPVSR(n,c,base)   __REST_1FPVSR(n,__REG_##c,__REG_##base)
 #define REST_32FPVSRS(n,c,base) __REST_32FPVSRS(n,__REG_##c,__REG_##base)
 #define SAVE_32FPVSRS(n,c,base) __SAVE_32FPVSRS(n,__REG_##c,__REG_##base)
 
@@ -72,6 +83,7 @@ _GLOBAL(store_fp_state)
 	SAVE_32FPVSRS(0, R4, R3)
 	mffs	fr0
 	stfd	fr0,FPSTATE_FPSCR(r3)
+	REST_1FPVSR(0, R4, R3)
 	blr
 EXPORT_SYMBOL(store_fp_state)
 
@@ -136,6 +148,7 @@ _GLOBAL(save_fpu)
 2:	SAVE_32FPVSRS(0, R4, R6)
 	mffs	fr0
 	stfd	fr0,FPSTATE_FPSCR(r6)
+	REST_1FPVSR(0, R4, R6)
 	blr
 
 /*
--- a/arch/powerpc/kernel/vector.S
+++ b/arch/powerpc/kernel/vector.S
@@ -31,6 +31,7 @@ _GLOBAL(store_vr_state)
 	mfvscr	v0
 	li	r4, VRSTATE_VSCR
 	stvx	v0, r4, r3
+	lvx	v0, 0, r3
 	blr
 EXPORT_SYMBOL(store_vr_state)
 
@@ -101,6 +102,7 @@ _GLOBAL(save_altivec)
 	mfvscr	v0
 	li	r4,VRSTATE_VSCR
 	stvx	v0,r4,r7
+	lvx	v0,0,r7
 	blr
 
 #ifdef CONFIG_VSX


