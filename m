Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841B0421EF8;
	Thu, 30 Jul 2026 14:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423345; cv=none; b=KUImx14PYH2A6Fi5+slncgkDgqu0cWaOvcc31Y3FEi69odHu1UeIQdkrTlDONa2Fyd//yidKKHeQCLoKvsNjbIOJiLknSIPosTOpTxtJPRMtdcYEfUjDvahwMRE2wmF23SMA7Z6LZclX8HjLCBTvcqyz90h/5R/+Wy4c4JWuXq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423345; c=relaxed/simple;
	bh=wfom998lfOK9DIEH5iI2hBL+IQsktLlY/FAsGbuVU6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLT5tNSN1esYA9Tw2XSVKUGOjEPmypO1ezeZG40m/CStSFsA2957Z6fVQ1EXDaEBZmuEsBMlxLPH7Hm1IClerNcxyS+aLrB1SNkEg1GS7jAV7XoVGpUDOAOguLg+maPmOQWBPOFs9IT1mDwFzV6jDrs4U805ucK6oKVmo5uPkwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmqeDq78; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmqeDq78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFABF1F000E9;
	Thu, 30 Jul 2026 14:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423344;
	bh=7FfyNwP7uLXLaQE39ExyiEQwtBCdzJet3QLlZPUdN3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fmqeDq78C70hIgVCvHraD/g6LPjVvGN2Wf+IgC+M9XzCHfp9o7AUY0GyCqND4WPvU
	 EocxRixcXimR2FwJ/5CTF08Y2IFHq8Pamgaj0mygNT1qfbrR1KThnaWmErae0d1mFl
	 /KuJxjQ7dbBNdfSn3ODsBoFkcNGWnupkNa+dIQms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 741/744] sched_ext: Preserve rq tracking across local DSQ dispatch
Date: Thu, 30 Jul 2026 16:16:54 +0200
Message-ID: <20260730141500.064242479@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit 18d62044cda7a2b40f59d910659c0b0d6accad37 ]

dispatch_to_local_dsq() can run from scx_bpf_dsq_move_to_local() while
ops.dispatch() has recorded the current rq. Moving a task to a local DSQ
may switch to the source or destination rq before synchronously invoking
ops.dequeue() through the following path:

  SCX_CALL_OP(dispatch, rq)
    ops.dispatch()
      scx_bpf_dsq_move_to_local()
        scx_flush_dispatch_buf()
          finish_dispatch()
            dispatch_to_local_dsq()
              scx_dispatch_enqueue()
                local_dsq_post_enq()
                  call_task_dequeue()
                    SCX_CALL_OP_TASK(dequeue, locked_rq, ...)

The nested callback saves the recorded rq and restores it on return. If
the rq tracking does not follow the lock switch, update_locked_rq() can
trigger the following lockdep assertion while restoring an rq which is
no longer held:

  WARNING: kernel/sched/sched.h:1641 at call_task_dequeue+0x160/0x170
  Call Trace:
    scx_dispatch_enqueue+0x2b0/0x460
    dispatch_to_local_dsq+0x138/0x230
    scx_flush_dispatch_buf+0x1af/0x220
    scx_bpf_dsq_move_to_local___v2+0xe2/0x1c0
    bpf__sched_ext_ops_dispatch+0x4b/0xa7
    do_pick_task_scx+0x3b6/0x910
    __pick_next_task+0x105/0x1f0
    __schedule+0x3e7/0x1980

Introduce switch_rq_lock() to update the tracking state together with
each rq lock handoff. Use it in dispatch_to_local_dsq(),
move_remote_task_to_local_dsq() and the in-balance paths of
scx_dsq_move(), ensuring that scx_locked_rq() consistently refers to the
rq whose lock is actually held throughout the lock dance.

Fixes: 7fb39e4eb4c3 ("sched_ext: Save and restore scx_locked_rq across SCX_CALL_OP")
Cc: stable@vger.kernel.org # 7.1+
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -438,6 +438,18 @@ static bool rq_is_open(struct rq *rq, u6
  */
 DEFINE_PER_CPU(struct rq *, scx_locked_rq_state);
 
+static void switch_rq_lock(struct rq *from, struct rq *to)
+{
+	bool tracked = scx_locked_rq() == from;
+
+	if (tracked)
+		update_locked_rq(NULL);
+	raw_spin_rq_unlock(from);
+	raw_spin_rq_lock(to);
+	if (tracked)
+		update_locked_rq(to);
+}
+
 /*
  * SCX ops can recurse via scx_bpf_sub_dispatch() - the inner call must not
  * clobber the outer's scx_locked_rq_state. Save it on entry, restore on exit.
@@ -2262,8 +2274,7 @@ static void move_remote_task_to_local_ds
 	deactivate_task(src_rq, p, 0);
 	set_task_cpu(p, cpu_of(dst_rq));
 
-	raw_spin_rq_unlock(src_rq);
-	raw_spin_rq_lock(dst_rq);
+	switch_rq_lock(src_rq, dst_rq);
 
 	/*
 	 * We want to pass scx-specific enq_flags but activate_task() will
@@ -2594,9 +2605,8 @@ static void dispatch_to_local_dsq(struct
 
 	/* switch to @src_rq lock */
 	if (locked_rq != src_rq) {
-		raw_spin_rq_unlock(locked_rq);
+		switch_rq_lock(locked_rq, src_rq);
 		locked_rq = src_rq;
-		raw_spin_rq_lock(src_rq);
 	}
 
 	/* task_rq couldn't have changed if we're still the holding cpu */
@@ -2624,10 +2634,8 @@ static void dispatch_to_local_dsq(struct
 	}
 
 	/* switch back to @rq lock */
-	if (locked_rq != rq) {
-		raw_spin_rq_unlock(locked_rq);
-		raw_spin_rq_lock(rq);
-	}
+	if (locked_rq != rq)
+		switch_rq_lock(locked_rq, rq);
 }
 
 /**
@@ -8405,10 +8413,8 @@ static bool scx_dsq_move(struct bpf_iter
 	in_balance = this_rq->scx.flags & SCX_RQ_IN_BALANCE;
 
 	if (in_balance) {
-		if (this_rq != src_rq) {
-			raw_spin_rq_unlock(this_rq);
-			raw_spin_rq_lock(src_rq);
-		}
+		if (this_rq != src_rq)
+			switch_rq_lock(this_rq, src_rq);
 	} else {
 		raw_spin_rq_lock(src_rq);
 	}
@@ -8440,10 +8446,8 @@ static bool scx_dsq_move(struct bpf_iter
 	dispatched = true;
 out:
 	if (in_balance) {
-		if (this_rq != locked_rq) {
-			raw_spin_rq_unlock(locked_rq);
-			raw_spin_rq_lock(this_rq);
-		}
+		if (this_rq != locked_rq)
+			switch_rq_lock(locked_rq, this_rq);
 	} else {
 		raw_spin_rq_unlock_irqrestore(locked_rq, flags);
 	}


