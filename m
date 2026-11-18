Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021933;
	b=YUWk/+d+VBbeC7Fk5pZvdW2CGNY8XEzpkXrPNq+eScl7kRSaJMf0KfQtm9wHtvLZiujo
	 0kR8VtJUABKcg8oQvKQHUA2E2IHYvywD5jpvH27wLDmNT8EfagTytfVaQqKU2M1ZCCcld
	 YlkA2gX58ZOAz0ZU5xEyp9S8yppR5P8uEjE/Q5raPmezIEUIVMW60rb78szLOoYeeCBzo
	 szMuK/2cQdazIpUPAMsomhe3bP9tcdhjIN2TGVxYzESx8xBDMK1BpYrOxukAJBZF9XIxd
	 k0XmtnuXQ5Y42jnjcUpUJSsPqmG0jFOOnXk60TCyIfAK8fMWC7blAxMiihmmH4vuEvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021933;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QYrZ7KGzglSFnrfNbtrpK3k9UKjJ99d9usq05ur8CVc=;
	b=F2D/8C0tRO8of3/FHIHLyvmzOhlgqCPwoEcZQCDRmVm8efDtEsC/5BaZtcWWveeWEtW5
	 wf1QDslWikh12vbutyyNELyRyHRQ+XqqoL+CY9rFYNMHG4Iwmm1teOy7lV8zNJIxbNZhs
	 swKZl2M/k2NVorefIvFXkBGiS4Beweasc8vv8Vsm3giTSmfS0sSWVoJyoNHw6lf40Px4l
	 6RraWQ/cYY9mfG6vjH/Cx7TMGEXQb21CTT0mHInExVffPeKnyJ3G31u7XDYUfJ3bh1UKO
	 2GlO1OuyWtNH+9uYmQd1HOaiXPNymuvxQjzuTxDihn94GzKaCM0GponmqSxVet1x4mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l/RRf3cF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48546606A31C;
	Wed, 18 Nov 2026 17:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l/RRf3cF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35D91F000C4;
	Wed, 18 Nov 2026 17:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021933;
	bh=QYrZ7KGzglSFnrfNbtrpK3k9UKjJ99d9usq05ur8CVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/RRf3cFYbnpFF6StB98+j669/hrcraC4L+WT6o96P9XxsxGYHcyhrxcvtHRZNMtl
	 rPxQbjxe0ejw+yOIXzb3Eir0zY9ssQFU95RmOKet2EYRLAAu19tzYq8mpMFQ0iV5Ks
	 9FLWST21dytw78OjCtzERNtnhL0b9HPLX6pZXNZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2482/2651] sched_ext: Fix rescue served time disagreeing with the slice under proxy execution
Date: Wed, 18 Nov 2026 16:02:02 +0100
Message-ID: <20261118150414.270573012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 006e9e9336b96964aafa4bb045e75077ee38f50b ]

Rescue measures served time as the rescuee's sum_exec_runtime minus a
snapshot taken at admission. Under proxy execution that measure follows the
wrong task. update_se() credits sum_exec_runtime to rq->curr, the mutex
owner that executes, while update_curr_scx() drains the slice of rq->donor
and charges its rescue. A rescuee can be either, so its served time and its
slice disagree in both directions.

As the owner running for another donor, the rescuee accrues served time that
drained no slice and charged no budget, and its rescue ends early. As the
donor, its rescue runs long:

 1. the rescuee blocks on a mutex and the owner runs in its place
 2. the owner's run drains the rescuee's slice and the budget, but not the
    served time
 3. the slice runs out with the rescue still open, and scx_rescue_keep()
    restores a remainder that the owner's run didn't reduce
 4. the owner keeps running on the rescue until it releases the mutex, past
    the admitted slice and overdrawing the budget

Count served time in scx_rescue_charge() from the delta that drains the
slice. Charging the owner's run to the donor's rescue matches proxy
execution, which drains the donor's slice and accounts the cgroup time to
the donor for the owner's run.

scx_rescue_keep() also ignored the return of scx_set_task_slice(). The call
refuses the restore on a rescuee that escalation marked SCX_TASK_PROTECTED,
and the rescuee was kept with a zero slice and its protection set.

That refusal is now unreachable. Escalation sets the slice to the unserved
remainder before it protects the task. From then on every slice write a
scheduler can reach is refused. Only a sub-scheduler's task is rescued, and
sub-schedulers are cid-form, which rejects direct slice writes.

The slice then moves only by what update_curr_scx() drains, and that drain
charges the rescue by the same amount, so the slice runs out exactly when
the charge ends the rescue. WARN and end the rescue if the restore is
refused anyway.

Fixes: 5fd501744b10 ("sched_ext: Add bandwidth-limited rescue execution for stranded tasks")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/sub.c | 25 ++++++++++++++++---------
 kernel/sched/sched.h   |  2 +-
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/ext/sub.c b/kernel/sched/ext/sub.c
index f1707d93bc004..dd467f217efe1 100644
--- a/kernel/sched/ext/sub.c
+++ b/kernel/sched/ext/sub.c
@@ -239,9 +239,7 @@ void scx_init_root_caps(struct scx_sched *sch)
 /* unserved remainder of @rq's rescuee's admitted slice, 0 once fully served */
 static s64 scx_rescue_slice_remaining(struct rq *rq)
 {
-	s64 served = rq->scx.rescue.curr->se.sum_exec_runtime - rq->scx.rescue.exec_snap;
-
-	return max(rq->scx.rescue.slice - served, 0);
+	return max(rq->scx.rescue.slice - rq->scx.rescue.served, 0);
 }
 
 /*
@@ -276,6 +274,14 @@ void scx_rescue_charge(struct rq *rq, s64 delta_exec)
 
 	lockdep_assert_rq_held(rq);
 
+	/*
+	 * Count @delta_exec as served before the clamp below, which bounds only
+	 * the budget charge. update_curr_scx() took the same delta off the
+	 * slice, so a slice set to the unserved remainder, as escalation does,
+	 * reaches zero when the remainder does, see scx_rescue_keep().
+	 */
+	rq->scx.rescue.served += delta_exec;
+
 	/*
 	 * A rescue slice is bounded by one quantum and tick-driven expiry can
 	 * overshoot by up to a tick. Clamp to avoid wild over-charges on VMs.
@@ -335,7 +341,9 @@ bool scx_rescue_keep(struct rq *rq, struct task_struct *p)
 	    scx_bypassing(scx_task_sched(p), cpu_of(rq)))
 		return false;
 
-	scx_set_task_slice(p, remaining);
+	/* never called on a protected rescuee, so the write can't be refused */
+	if (WARN_ON_ONCE(!scx_set_task_slice(p, remaining)))
+		return false;
 	return true;
 }
 
@@ -418,10 +426,9 @@ static void scx_rescue_timer_arm(struct rq *rq)
  * @slice: CPU time to grant
  *
  * The schedulers keep their normal control over @p and may preempt or reslice
- * it. @slice is measured on served CPU time against the snapshot taken here, so
- * neither shortens the rescue, see scx_rescue_charge() and scx_rescue_keep().
- * Prolonged denial escalates into protected execution, see
- * scx_rescue_timerfn().
+ * it. @slice is measured on served CPU time, so neither shortens the rescue,
+ * see scx_rescue_charge() and scx_rescue_keep(). Prolonged denial escalates
+ * into protected execution, see scx_rescue_timerfn().
  */
 static void scx_rescue_admit(struct rq *rq, struct task_struct *p, s64 slice)
 {
@@ -430,7 +437,7 @@ static void scx_rescue_admit(struct rq *rq, struct task_struct *p, s64 slice)
 
 	rq->scx.rescue.curr = p;
 	rq->scx.rescue.slice = slice;
-	rq->scx.rescue.exec_snap = p->se.sum_exec_runtime;
+	rq->scx.rescue.served = 0;
 	scx_set_task_slice(p, slice);
 	scx_rescue_timer_arm(rq);
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4c25fbe84fb54..a248c1c3bd92a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -803,7 +803,7 @@ struct scx_rq_rescue {
 	u64			clock;			/* last budget accrual timestamp */
 	struct task_struct	*curr;			/* task being rescued, one at a time */
 	s64			slice;			/* curr's admitted slice */
-	u64			exec_snap;		/* sum_exec_runtime at admission */
+	s64			served;			/* curr's served time */
 	struct timer_list	timer;			/* paces admission and escalation */
 	u64			kill_at;		/* last ejection, init before any */
 };
-- 
2.53.0



