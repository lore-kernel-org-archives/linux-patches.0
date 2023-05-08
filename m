Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2A8168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BB6C433EF;
	Mon,  8 May 2023 10:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542525;
	bh=9LJbx+ELuwApZUsSfMPBiPMGyel/4ljM8YpTP5ivLhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXWh4zFJg4dXJQgRszJ03UKH38vuJ3n7e6FkLDiPI4dFrIkCCyDAekjA09/U8A9DK
	 NAFEGrny1HS8kaxxExnMx4OHcLfZ8bT5spMp46kJcdfx1CAnMpoaWn1J+x7uR8o5ho
	 iG47y6oz7byXICVixq3HxzKwapu68jyO/rRaFhpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dae R. Jeong" <threeearcat@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 464/663] vmci_host: fix a race condition in vmci_host_poll() causing GPF
Date: Mon,  8 May 2023 11:44:50 +0200
Message-Id: <20230508094443.238307211@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dae R. Jeong <threeearcat@gmail.com>

[ Upstream commit ae13381da5ff0e8e084c0323c3cc0a945e43e9c7 ]

During fuzzing, a general protection fault is observed in
vmci_host_poll().

general protection fault, probably for non-canonical address 0xdffffc0000000019: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000c8-0x00000000000000cf]
RIP: 0010:__lock_acquire+0xf3/0x5e00 kernel/locking/lockdep.c:4926
<- omitting registers ->
Call Trace:
 <TASK>
 lock_acquire+0x1a4/0x4a0 kernel/locking/lockdep.c:5672
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0xb3/0x100 kernel/locking/spinlock.c:162
 add_wait_queue+0x3d/0x260 kernel/sched/wait.c:22
 poll_wait include/linux/poll.h:49 [inline]
 vmci_host_poll+0xf8/0x2b0 drivers/misc/vmw_vmci/vmci_host.c:174
 vfs_poll include/linux/poll.h:88 [inline]
 do_pollfd fs/select.c:873 [inline]
 do_poll fs/select.c:921 [inline]
 do_sys_poll+0xc7c/0x1aa0 fs/select.c:1015
 __do_sys_ppoll fs/select.c:1121 [inline]
 __se_sys_ppoll+0x2cc/0x330 fs/select.c:1101
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Example thread interleaving that causes the general protection fault
is as follows:

CPU1 (vmci_host_poll)               CPU2 (vmci_host_do_init_context)
-----                               -----
// Read uninitialized context
context = vmci_host_dev->context;
                                    // Initialize context
                                    vmci_host_dev->context = vmci_ctx_create();
                                    vmci_host_dev->ct_type = VMCIOBJ_CONTEXT;

if (vmci_host_dev->ct_type == VMCIOBJ_CONTEXT) {
    // Dereferencing the wrong pointer
    poll_wait(..., &context->host_context);
}

In this scenario, vmci_host_poll() reads vmci_host_dev->context first,
and then reads vmci_host_dev->ct_type to check that
vmci_host_dev->context is initialized. However, since these two reads
are not atomically executed, there is a chance of a race condition as
described above.

To fix this race condition, read vmci_host_dev->context after checking
the value of vmci_host_dev->ct_type so that vmci_host_poll() always
reads an initialized context.

Reported-by: Dae R. Jeong <threeearcat@gmail.com>
Fixes: 8bf503991f87 ("VMCI: host side driver implementation.")
Signed-off-by: Dae R. Jeong <threeearcat@gmail.com>
Link: https://lore.kernel.org/r/ZCGFsdBAU4cYww5l@dragonet
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/vmw_vmci/vmci_host.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/vmw_vmci/vmci_host.c b/drivers/misc/vmw_vmci/vmci_host.c
index 857b9851402a6..abe79f6fd2a79 100644
--- a/drivers/misc/vmw_vmci/vmci_host.c
+++ b/drivers/misc/vmw_vmci/vmci_host.c
@@ -165,10 +165,16 @@ static int vmci_host_close(struct inode *inode, struct file *filp)
 static __poll_t vmci_host_poll(struct file *filp, poll_table *wait)
 {
 	struct vmci_host_dev *vmci_host_dev = filp->private_data;
-	struct vmci_ctx *context = vmci_host_dev->context;
+	struct vmci_ctx *context;
 	__poll_t mask = 0;
 
 	if (vmci_host_dev->ct_type == VMCIOBJ_CONTEXT) {
+		/*
+		 * Read context only if ct_type == VMCIOBJ_CONTEXT to make
+		 * sure that context is initialized
+		 */
+		context = vmci_host_dev->context;
+
 		/* Check for VMCI calls to this VM context. */
 		if (wait)
 			poll_wait(filp, &context->host_context.wait_queue,
-- 
2.39.2



