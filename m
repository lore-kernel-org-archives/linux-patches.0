Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78251C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F40DC433D6;
	Wed, 23 Nov 2022 09:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197378;
	bh=KPBHeO15Z7Rdm4vdRtOGfY9k/IKu9AIxzSZd2shTLKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tnz/0WAztO6mPKG4rN+WZQoaAE8xCBJeQ/ZnP51RHOjbezbShABeAV2QmjtY4H/y/
	 UT3TuvTGpXqlJ6rcTiFn5nvTVTBCuzZ4nJzaXCRh4tkXwu1jNt2rHix2bbJehyqJ12
	 UO4TTggWpnYKmY+d88ePAr6hLdv/4SEC6RDmO0TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Galbraith <efault@gmx.de>,
	Mel Gorman <mgorman@techsingularity.net>,
	Borislav Petkov <bp@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.0 278/314] x86/fpu: Drop fpregs lock before inheriting FPU permissions
Date: Wed, 23 Nov 2022 09:52:03 +0100
Message-Id: <20221123084638.128273790@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mel Gorman <mgorman@techsingularity.net>

commit 36b038791e1e2baea892e9276588815fd14894b4 upstream.

Mike Galbraith reported the following against an old fork of preempt-rt
but the same issue also applies to the current preempt-rt tree.

   BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:46
   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: systemd
   preempt_count: 1, expected: 0
   RCU nest depth: 0, expected: 0
   Preemption disabled at:
   fpu_clone
   CPU: 6 PID: 1 Comm: systemd Tainted: G            E       (unreleased)
   Call Trace:
    <TASK>
    dump_stack_lvl
    ? fpu_clone
    __might_resched
    rt_spin_lock
    fpu_clone
    ? copy_thread
    ? copy_process
    ? shmem_alloc_inode
    ? kmem_cache_alloc
    ? kernel_clone
    ? __do_sys_clone
    ? do_syscall_64
    ? __x64_sys_rt_sigprocmask
    ? syscall_exit_to_user_mode
    ? do_syscall_64
    ? syscall_exit_to_user_mode
    ? do_syscall_64
    ? syscall_exit_to_user_mode
    ? do_syscall_64
    ? exc_page_fault
    ? entry_SYSCALL_64_after_hwframe
    </TASK>

Mike says:

  The splat comes from fpu_inherit_perms() being called under fpregs_lock(),
  and us reaching the spin_lock_irq() therein due to fpu_state_size_dynamic()
  returning true despite static key __fpu_state_size_dynamic having never
  been enabled.

Mike's assessment looks correct. fpregs_lock on a PREEMPT_RT kernel disables
preemption so calling spin_lock_irq() in fpu_inherit_perms() is unsafe. This
problem exists since commit

  9e798e9aa14c ("x86/fpu: Prepare fpu_clone() for dynamically enabled features").

Even though the original bug report should not have enabled the paths at
all, the bug still exists.

fpregs_lock is necessary when editing the FPU registers or a task's FP
state but it is not necessary for fpu_inherit_perms(). The only write
of any FP state in fpu_inherit_perms() is for the new child which is
not running yet and cannot context switch or be borrowed by a kernel
thread yet. Hence, fpregs_lock is not protecting anything in the new
child until clone() completes and can be dropped earlier. The siglock
still needs to be acquired by fpu_inherit_perms() as the read of the
parent's permissions has to be serialised.

  [ bp: Cleanup splat. ]

Fixes: 9e798e9aa14c ("x86/fpu: Prepare fpu_clone() for dynamically enabled features")
Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221110124400.zgymc2lnwqjukgfh@techsingularity.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 3b28c5b25e12..d00db56a8868 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -605,9 +605,9 @@ int fpu_clone(struct task_struct *dst, unsigned long clone_flags, bool minimal)
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		fpregs_restore_userregs();
 	save_fpregs_to_fpstate(dst_fpu);
+	fpregs_unlock();
 	if (!(clone_flags & CLONE_THREAD))
 		fpu_inherit_perms(dst_fpu);
-	fpregs_unlock();
 
 	/*
 	 * Children never inherit PASID state.
-- 
2.38.1



