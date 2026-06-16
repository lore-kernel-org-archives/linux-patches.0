Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D909B4657F8;
	Tue, 16 Jun 2026 16:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629028; cv=none; b=dym/0ENq5hXloKTXMYJz4Q7ZIWmuxoLMkb2g/xEvwTcQVt/toCJWISQvfJVgohUTSHLEhe8SOSYA6jjJkOs5f64JcG8W6Cid2NQvHCp4EAXP4Z+LZ/8/FcnSsWQ9bbe/dhvwG0XAcdKE66TRRVairvrKW3CG84nUCL0ExGqvSA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629028; c=relaxed/simple;
	bh=xyC9uyiT17wGR8i+kEun5s/iRi2B8WAobwUDbkJ6dm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufHlaYIrfXyuo6Jz0DXBkL+6fMbpyRui/Hsene32HqsPqNWsvxCvmogKOaXgaCs+CGrl/ZAKJvG7Qi2QfOCGm+HZTk+KecF9FuFwDkDTOppH4k3eXlyRe9cCw5WYK8qefWCUv+AWdvqjrY89dCpHHFKhNc7ou+SdUJ7dkZA1oAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06/oPpli; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06/oPpli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CABF1F000E9;
	Tue, 16 Jun 2026 16:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629026;
	bh=FBMgxnFzK+bps7q8akdQm41Yd52rlk2uHFSnmFN7ed8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06/oPplijURRFIwTb3gZ2vdKLFB4Blwuz20rqwTQPdaBorcqCev3YQR0YAmCsOlgf
	 5VQo3uKmKmLAri3oZa/jYzYJSNOHQm1S8A1CjouTZGNNXEipekoxPnVRf6q6YXhg5o
	 5jQ10zSht0K68Izfa/iW5wShjvLUmgTqVOgS/ZvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4edb496c3cad6e953a31@syzkaller.appspotmail.com,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Vladislav Nikolaev <vlad102nikolaev@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 207/452] RDMA/rxe: Fix "trying to register non-static key in rxe_qp_do_cleanup" bug
Date: Tue, 16 Jun 2026 20:27:14 +0530
Message-ID: <20260616145128.676665244@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Zhu Yanjun <yanjun.zhu@linux.dev>

commit 1c7eec4d5f3b39cdea2153abaebf1b7229a47072 upstream.

Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 assign_lock_key kernel/locking/lockdep.c:986 [inline]
 register_lock_class+0x4a3/0x4c0 kernel/locking/lockdep.c:1300
 __lock_acquire+0x99/0x1ba0 kernel/locking/lockdep.c:5110
 lock_acquire kernel/locking/lockdep.c:5866 [inline]
 lock_acquire+0x179/0x350 kernel/locking/lockdep.c:5823
 __timer_delete_sync+0x152/0x1b0 kernel/time/timer.c:1644
 rxe_qp_do_cleanup+0x5c3/0x7e0 drivers/infiniband/sw/rxe/rxe_qp.c:815
 execute_in_process_context+0x3a/0x160 kernel/workqueue.c:4596
 __rxe_cleanup+0x267/0x3c0 drivers/infiniband/sw/rxe/rxe_pool.c:232
 rxe_create_qp+0x3f7/0x5f0 drivers/infiniband/sw/rxe/rxe_verbs.c:604
 create_qp+0x62d/0xa80 drivers/infiniband/core/verbs.c:1250
 ib_create_qp_kernel+0x9f/0x310 drivers/infiniband/core/verbs.c:1361
 ib_create_qp include/rdma/ib_verbs.h:3803 [inline]
 rdma_create_qp+0x10c/0x340 drivers/infiniband/core/cma.c:1144
 rds_ib_setup_qp+0xc86/0x19a0 net/rds/ib_cm.c:600
 rds_ib_cm_initiate_connect+0x1e8/0x3d0 net/rds/ib_cm.c:944
 rds_rdma_cm_event_handler_cmn+0x61f/0x8c0 net/rds/rdma_transport.c:109
 cma_cm_event_handler+0x94/0x300 drivers/infiniband/core/cma.c:2184
 cma_work_handler+0x15b/0x230 drivers/infiniband/core/cma.c:3042
 process_one_work+0x9cc/0x1b70 kernel/workqueue.c:3238
 process_scheduled_works kernel/workqueue.c:3319 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
 kthread+0x3c2/0x780 kernel/kthread.c:464
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

The root cause is as below:

In the function rxe_create_qp, the function rxe_qp_from_init is called
to create qp, if this function rxe_qp_from_init fails, rxe_cleanup will
be called to handle all the allocated resources, including the timers:
retrans_timer and rnr_nak_timer.

The function rxe_qp_from_init calls the function rxe_qp_init_req to
initialize the timers: retrans_timer and rnr_nak_timer.

But these timers are initialized in the end of rxe_qp_init_req.
If some errors occur before the initialization of these timers, this
problem will occur.

The solution is to check whether these timers are initialized or not.
If these timers are not initialized, ignore these timers.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Reported-by: syzbot+4edb496c3cad6e953a31@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4edb496c3cad6e953a31
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/20250419080741.1515231-1-yanjun.zhu@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[ Vladislav: keep del_timer_sync() because linux-6.6.y has not renamed it
  to timer_delete_sync() yet. The actual fix is unchanged: check the timer
  .function fields before deleting the timers. ]
Signed-off-by: Vladislav Nikolaev <vlad102nikolaev@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_qp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 287fc8b8f5bafe..8426c261c263a9 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -817,7 +817,12 @@ static void rxe_qp_do_cleanup(struct work_struct *work)
 	spin_unlock_irqrestore(&qp->state_lock, flags);
 	qp->qp_timeout_jiffies = 0;
 
-	if (qp_type(qp) == IB_QPT_RC) {
+	/* In the function timer_setup, .function is initialized. If .function
+	 * is NULL, it indicates the function timer_setup is not called, the
+	 * timer is not initialized. Or else, the timer is initialized.
+	 */
+	if (qp_type(qp) == IB_QPT_RC && qp->retrans_timer.function &&
+		qp->rnr_nak_timer.function) {
 		del_timer_sync(&qp->retrans_timer);
 		del_timer_sync(&qp->rnr_nak_timer);
 	}
-- 
2.53.0



