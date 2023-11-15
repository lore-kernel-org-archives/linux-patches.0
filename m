Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381D13DBBF
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSiGONts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8859C433C9;
	Wed, 15 Nov 2023 19:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076787;
	bh=pZxepE3fd1q/n1SH45fODoWXpDthHJ+kmUITCiXmEt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSiGONtsB71A5xq4GrtWkiLfmNHFocmQ3/SrrcLlIXei8qPAHD6XBeEW6LSexl4k7
	 B3Is4w7YdLCcY0rbV4ilKuKSvgRtF3WPgkPAx7pKSJ0GikqczXu+C1pBNwbXD7D4SS
	 ouhZTQ+UrSwg1NmhB3g/MmLzyyF1j84YhvnWlVBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong He <alexyonghe@tencent.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Neeraj upadhyay <Neeraj.Upadhyay@amd.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/603] srcu: Fix callbacks acceleration mishandling
Date: Wed, 15 Nov 2023 14:09:31 -0500
Message-ID: <20231115191614.987480827@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 4a8e65b0c348e42107c64381e692e282900be361 ]

SRCU callbacks acceleration might fail if the preceding callbacks
advance also fails. This can happen when the following steps are met:

1) The RCU_WAIT_TAIL segment has callbacks (say for gp_num 8) and the
   RCU_NEXT_READY_TAIL also has callbacks (say for gp_num 12).

2) The grace period for RCU_WAIT_TAIL is observed as started but not yet
   completed so rcu_seq_current() returns 4 + SRCU_STATE_SCAN1 = 5.

3) This value is passed to rcu_segcblist_advance() which can't move
   any segment forward and fails.

4) srcu_gp_start_if_needed() still proceeds with callback acceleration.
   But then the call to rcu_seq_snap() observes the grace period for the
   RCU_WAIT_TAIL segment (gp_num 8) as completed and the subsequent one
   for the RCU_NEXT_READY_TAIL segment as started
   (ie: 8 + SRCU_STATE_SCAN1 = 9) so it returns a snapshot of the
   next grace period, which is 16.

5) The value of 16 is passed to rcu_segcblist_accelerate() but the
   freshly enqueued callback in RCU_NEXT_TAIL can't move to
   RCU_NEXT_READY_TAIL which already has callbacks for a previous grace
   period (gp_num = 12). So acceleration fails.

6) Note in all these steps, srcu_invoke_callbacks() hadn't had a chance
   to run srcu_invoke_callbacks().

Then some very bad outcome may happen if the following happens:

7) Some other CPU races and starts the grace period number 16 before the
   CPU handling previous steps had a chance. Therefore srcu_gp_start()
   isn't called on the latter sdp to fix the acceleration leak from
   previous steps with a new pair of call to advance/accelerate.

8) The grace period 16 completes and srcu_invoke_callbacks() is finally
   called. All the callbacks from previous grace periods (8 and 12) are
   correctly advanced and executed but callbacks in RCU_NEXT_READY_TAIL
   still remain. Then rcu_segcblist_accelerate() is called with a
   snaphot of 20.

9) Since nothing started the grace period number 20, callbacks stay
   unhandled.

This has been reported in real load:

	[3144162.608392] INFO: task kworker/136:12:252684 blocked for more
	than 122 seconds.
	[3144162.615986]       Tainted: G           O  K   5.4.203-1-tlinux4-0011.1 #1
	[3144162.623053] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
	disables this message.
	[3144162.631162] kworker/136:12  D    0 252684      2 0x90004000
	[3144162.631189] Workqueue: kvm-irqfd-cleanup irqfd_shutdown [kvm]
	[3144162.631192] Call Trace:
	[3144162.631202]  __schedule+0x2ee/0x660
	[3144162.631206]  schedule+0x33/0xa0
	[3144162.631209]  schedule_timeout+0x1c4/0x340
	[3144162.631214]  ? update_load_avg+0x82/0x660
	[3144162.631217]  ? raw_spin_rq_lock_nested+0x1f/0x30
	[3144162.631218]  wait_for_completion+0x119/0x180
	[3144162.631220]  ? wake_up_q+0x80/0x80
	[3144162.631224]  __synchronize_srcu.part.19+0x81/0xb0
	[3144162.631226]  ? __bpf_trace_rcu_utilization+0x10/0x10
	[3144162.631227]  synchronize_srcu+0x5f/0xc0
	[3144162.631236]  irqfd_shutdown+0x3c/0xb0 [kvm]
	[3144162.631239]  ? __schedule+0x2f6/0x660
	[3144162.631243]  process_one_work+0x19a/0x3a0
	[3144162.631244]  worker_thread+0x37/0x3a0
	[3144162.631247]  kthread+0x117/0x140
	[3144162.631247]  ? process_one_work+0x3a0/0x3a0
	[3144162.631248]  ? __kthread_cancel_work+0x40/0x40
	[3144162.631250]  ret_from_fork+0x1f/0x30

Fix this with taking the snapshot for acceleration _before_ the read
of the current grace period number.

The only side effect of this solution is that callbacks advancing happen
then _after_ the full barrier in rcu_seq_snap(). This is not a problem
because that barrier only cares about:

1) Ordering accesses of the update side before call_srcu() so they don't
   bleed.
2) See all the accesses prior to the grace period of the current gp_num

The only things callbacks advancing need to be ordered against are
carried by snp locking.

Reported-by: Yong He <alexyonghe@tencent.com>
Co-developed-by:: Yong He <alexyonghe@tencent.com>
Signed-off-by: Yong He <alexyonghe@tencent.com>
Co-developed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by:  Joel Fernandes (Google) <joel@joelfernandes.org>
Co-developed-by: Neeraj upadhyay <Neeraj.Upadhyay@amd.com>
Signed-off-by: Neeraj upadhyay <Neeraj.Upadhyay@amd.com>
Link: http://lore.kernel.org/CANZk6aR+CqZaqmMWrC2eRRPY12qAZnDZLwLnHZbNi=xXMB401g@mail.gmail.com
Fixes: da915ad5cf25 ("srcu: Parallelize callback handling")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/srcutree.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
index 20d7a238d675a..253ed509b6abb 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -1242,10 +1242,37 @@ static unsigned long srcu_gp_start_if_needed(struct srcu_struct *ssp,
 	spin_lock_irqsave_sdp_contention(sdp, &flags);
 	if (rhp)
 		rcu_segcblist_enqueue(&sdp->srcu_cblist, rhp);
+	/*
+	 * The snapshot for acceleration must be taken _before_ the read of the
+	 * current gp sequence used for advancing, otherwise advancing may fail
+	 * and acceleration may then fail too.
+	 *
+	 * This could happen if:
+	 *
+	 *  1) The RCU_WAIT_TAIL segment has callbacks (gp_num = X + 4) and the
+	 *     RCU_NEXT_READY_TAIL also has callbacks (gp_num = X + 8).
+	 *
+	 *  2) The grace period for RCU_WAIT_TAIL is seen as started but not
+	 *     completed so rcu_seq_current() returns X + SRCU_STATE_SCAN1.
+	 *
+	 *  3) This value is passed to rcu_segcblist_advance() which can't move
+	 *     any segment forward and fails.
+	 *
+	 *  4) srcu_gp_start_if_needed() still proceeds with callback acceleration.
+	 *     But then the call to rcu_seq_snap() observes the grace period for the
+	 *     RCU_WAIT_TAIL segment as completed and the subsequent one for the
+	 *     RCU_NEXT_READY_TAIL segment as started (ie: X + 4 + SRCU_STATE_SCAN1)
+	 *     so it returns a snapshot of the next grace period, which is X + 12.
+	 *
+	 *  5) The value of X + 12 is passed to rcu_segcblist_accelerate() but the
+	 *     freshly enqueued callback in RCU_NEXT_TAIL can't move to
+	 *     RCU_NEXT_READY_TAIL which already has callbacks for a previous grace
+	 *     period (gp_num = X + 8). So acceleration fails.
+	 */
+	s = rcu_seq_snap(&ssp->srcu_sup->srcu_gp_seq);
 	rcu_segcblist_advance(&sdp->srcu_cblist,
 			      rcu_seq_current(&ssp->srcu_sup->srcu_gp_seq));
-	s = rcu_seq_snap(&ssp->srcu_sup->srcu_gp_seq);
-	(void)rcu_segcblist_accelerate(&sdp->srcu_cblist, s);
+	WARN_ON_ONCE(!rcu_segcblist_accelerate(&sdp->srcu_cblist, s) && rhp);
 	if (ULONG_CMP_LT(sdp->srcu_gp_seq_needed, s)) {
 		sdp->srcu_gp_seq_needed = s;
 		needgp = true;
-- 
2.42.0



