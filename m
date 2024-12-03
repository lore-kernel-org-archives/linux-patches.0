Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C461F754A;
	Tue,  3 Dec 2024 15:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240327; cv=none; b=aVGdrhgLXmrXaDH8Lj1Vi8JndZIBs1ySW6mB+rdXZla9W9GW+C/p7keweas6cmOz1aNxjwRfiRQFGl265bXD7issqmT7PznsV9rnhPNIEtL9by+0BZpzVf7ok9DPL+QAYHrYufUuQaFj/i8dg0Q81XiUiBmnFCjf0HuwFwq4DOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240327; c=relaxed/simple;
	bh=mVrY+ksnOlUGkJ0lviqsOKO9VLd+8YP9ZLpIoYDqd70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVcV0KUZK++ZBXVrWmgCgoR99/KTdiFL3XzrYtIDdJrkJrNl+ZcsokINfGkTwD2YzwGZ17OEEohN0sTnWCrAjV+6htEdNQD+NBFJPE/mdK7qDivOwLW6sL1wO8Yi8zTqwiizPOimqmWXCPH224cUT4i5FiR70E2UpsH8fUvzg3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQrFAXN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQrFAXN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED01C4CECF;
	Tue,  3 Dec 2024 15:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240327;
	bh=mVrY+ksnOlUGkJ0lviqsOKO9VLd+8YP9ZLpIoYDqd70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQrFAXN3KzsRm+5tvQTWq59OTSkidrrIiznY2rRQPoxm3CNHqR5Iw4HVczK64Z27h
	 2xpyhbR85dZjd0UhTpMFQm1JWeKfcd2IAxwampSJZqpRwqRiRyXdUMbyqXZGmZ2bvq
	 1K12H92aV2z5tVi+32DXBQ4n95ycHM36VizgDVSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/826] rcu/nocb: Fix missed RCU barrier on deoffloading
Date: Tue,  3 Dec 2024 15:36:37 +0100
Message-ID: <20241203144746.203957774@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang1211@gmail.com>

[ Upstream commit 2996980e20b7a54a1869df15b3445374b850b155 ]

Currently, running rcutorture test with torture_type=rcu fwd_progress=8
n_barrier_cbs=8 nocbs_nthreads=8 nocbs_toggle=100 onoff_interval=60
test_boost=2, will trigger the following warning:

	WARNING: CPU: 19 PID: 100 at kernel/rcu/tree_nocb.h:1061 rcu_nocb_rdp_deoffload+0x292/0x2a0
	RIP: 0010:rcu_nocb_rdp_deoffload+0x292/0x2a0
	 Call Trace:
	  <TASK>
	  ? __warn+0x7e/0x120
	  ? rcu_nocb_rdp_deoffload+0x292/0x2a0
	  ? report_bug+0x18e/0x1a0
	  ? handle_bug+0x3d/0x70
	  ? exc_invalid_op+0x18/0x70
	  ? asm_exc_invalid_op+0x1a/0x20
	  ? rcu_nocb_rdp_deoffload+0x292/0x2a0
	  rcu_nocb_cpu_deoffload+0x70/0xa0
	  rcu_nocb_toggle+0x136/0x1c0
	  ? __pfx_rcu_nocb_toggle+0x10/0x10
	  kthread+0xd1/0x100
	  ? __pfx_kthread+0x10/0x10
	  ret_from_fork+0x2f/0x50
	  ? __pfx_kthread+0x10/0x10
	  ret_from_fork_asm+0x1a/0x30
	  </TASK>

CPU0                               CPU2                          CPU3
//rcu_nocb_toggle             //nocb_cb_wait                   //rcutorture

// deoffload CPU1             // process CPU1's rdp
rcu_barrier()
    rcu_segcblist_entrain()
        rcu_segcblist_add_len(1);
        // len == 2
        // enqueue barrier
        // callback to CPU1's
        // rdp->cblist
                             rcu_do_batch()
                                 // invoke CPU1's rdp->cblist
                                 // callback
                                 rcu_barrier_callback()
                                                             rcu_barrier()
                                                               mutex_lock(&rcu_state.barrier_mutex);
                                                               // still see len == 2
                                                               // enqueue barrier callback
                                                               // to CPU1's rdp->cblist
                                                               rcu_segcblist_entrain()
                                                                   rcu_segcblist_add_len(1);
                                                                   // len == 3
                                 // decrement len
                                 rcu_segcblist_add_len(-2);
                             kthread_parkme()

// CPU1's rdp->cblist len == 1
// Warn because there is
// still a pending barrier
// trigger warning
WARN_ON_ONCE(rcu_segcblist_n_cbs(&rdp->cblist));
cpus_read_unlock();

                                                                // wait CPU1 to comes online and
                                                                // invoke barrier callback on
                                                                // CPU1 rdp's->cblist
                                                                wait_for_completion(&rcu_state.barrier_completion);
// deoffload CPU4
cpus_read_lock()
  rcu_barrier()
    mutex_lock(&rcu_state.barrier_mutex);
    // block on barrier_mutex
    // wait rcu_barrier() on
    // CPU3 to unlock barrier_mutex
    // but CPU3 unlock barrier_mutex
    // need to wait CPU1 comes online
    // when CPU1 going online will block on cpus_write_lock

The above scenario will not only trigger a WARN_ON_ONCE(), but also
trigger a deadlock.

Thanks to nocb locking, a second racing rcu_barrier() on an offline CPU
will either observe the decremented callback counter down to 0 and spare
the callback enqueue, or rcuo will observe the new callback and keep
rdp->nocb_cb_sleep to false.

Therefore check rdp->nocb_cb_sleep before parking to make sure no
further rcu_barrier() is waiting on the rdp.

Fixes: 1fcb932c8b5c ("rcu/nocb: Simplify (de-)offloading state machine")
Suggested-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
Reviewed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_nocb.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index 16865475120ba..2605dd234a13c 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -891,7 +891,18 @@ static void nocb_cb_wait(struct rcu_data *rdp)
 	swait_event_interruptible_exclusive(rdp->nocb_cb_wq,
 					    nocb_cb_wait_cond(rdp));
 	if (kthread_should_park()) {
-		kthread_parkme();
+		/*
+		 * kthread_park() must be preceded by an rcu_barrier().
+		 * But yet another rcu_barrier() might have sneaked in between
+		 * the barrier callback execution and the callbacks counter
+		 * decrement.
+		 */
+		if (rdp->nocb_cb_sleep) {
+			rcu_nocb_lock_irqsave(rdp, flags);
+			WARN_ON_ONCE(rcu_segcblist_n_cbs(&rdp->cblist));
+			rcu_nocb_unlock_irqrestore(rdp, flags);
+			kthread_parkme();
+		}
 	} else if (READ_ONCE(rdp->nocb_cb_sleep)) {
 		WARN_ON(signal_pending(current));
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("WokeEmpty"));
-- 
2.43.0



