Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065460;
	b=2PuAKS76Sp4RxUSCtvZRzEqqIu0VaKdT4Z0Y2vANVpB+6yiG6yEDGwvJhbK8oYg3HVaN
	 hkRfDampgd7Ah8VPSudkOIByHlSopZWMgGuGnNwsJ37ZdWVFQVk9zlTtSRizjvHe8W5f6
	 8T2DeDG+81uYO1gPfV4X9YM07TILU33SzjKiOPwMctycQzVoaCLaMHbNe5iV7Nhk7ikp+
	 0xzs/Pc9xGEoL8a7P0i+HuS2FQsnFidMmqWr4iSEef0ALPF+Qj1GjTl8OQsLwhU9BmdCR
	 aNmmqN+HLQxaDnrtqGVAjqpywstHC43pH98jOH3DaS2axESoKPQ8+UECfN9XJSGlkAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n9FWybeX4D4RI7Iss/3+wxTekuCho5Nji6SsMpTM9bo=;
	b=Q9ZdE8eNp6176oWUieOAK9HsZtpJFjepSetguhQVLmkZggKOD3vYtSl0R/CsMFWCKWg8
	 fY2mZUyzOtBzzXbKKHwIR8PJiMDzw0k6UTDt5hC4XcR0ZZiQ1arnoZ2ldPrToxNPt3jxe
	 XH5gLA7QgnF0lO1jSA+9wWGnG7LS2UiCl/OrPrRH9v00i7RhNEk5JR1jJAYfCDgcIkTPZ
	 BSYd2237O69Y1/wEGt7iyVgxdNJSyjwdH/wt59rbx2Q+m3ROYOrHZwyKMa27o74Wos8EM
	 1pd5fK+9dqU7efGUwJqkz1iwELik+Xp9JHds14wW9eBKKkWKaPJHldMAAqrYLv5rG3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gbn1CK8R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D262606A32C;
	Sat,  7 Nov 2026 15:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gbn1CK8R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1105A1F0089F;
	Sat,  7 Nov 2026 15:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065460;
	bh=n9FWybeX4D4RI7Iss/3+wxTekuCho5Nji6SsMpTM9bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbn1CK8RZ/ddNE+e9Mu/Qz1kjtkODq9WFsb9zTi8c3YmMJsGN3uZB70ka8UPf59sm
	 1xqqS55F/LkMaU2AeA3IBibqV9m9fGfdIJ1m39IYoNT3Xcgxy3RS2Z9qMpWPEitBKA
	 POShsKkuwoJlVEyw9zWZy+N0eyeZVKiO4utSJP5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1158/1257] sched_ext: Fix the stall watchdog testing and blaming the wrong sched under bypass
Date: Sat,  7 Nov 2026 08:57:34 -0500
Message-ID: <20261107135011.183356614@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

[ Upstream commit 93b1512ca69fbe3da66bbd2bab76e9ed74277679 ]

While a sched is bypassing, its tasks are run by its host, the nearest
ancestor that isn't bypassing. check_rq_for_timeouts() tests a runnable task
against its owner's timeout. Since 2c91169377f4 ("sched_ext: Blame the DSQ's
owning scheduler for a runnable stall"), it ejects the sched owning the DSQ
the task waits on. The sched tested, the sched ejected and the sched running
the task can all differ.

- Timeouts are per sched. A bypassing sub-scheduler with a 2s timeout under
  a root with the default 30s has its tasks on the root's bypass DSQ. The
  root, not bypassing itself, consumes that DSQ before calling
  ops.dispatch() only on every other pass, and on the others only after
  ops.dispatch() yields nothing. A task that waits 2s there ejects the root,
  disabling all of sched_ext.

- A bypassing owner's task on the local DSQ is blamed on the owner, which
  places nothing while bypassing. If the owner is already exiting, e.g.
  during its own disable, the exit is a no-op and nothing is ejected. If the
  host isn't running the task, the owner's disable, which waits on it, may
  never finish.

- The wait isn't restarted when bypass moves a task. The time it waited
  under its owner counts against the host once it is on the host's bypass
  DSQ, and its time there against the owner once bypass lifts.

The sched running a task is its owner, or the host while the owner is
bypassing. Test the task against that sched's timeout and blame it. A bypass
requeue can change the sched running a task, so restart the wait of every
task scx_bypass() requeues except the root's own, which the root runs
bypassing or not. Single-scheduler behavior is unchanged.

A task that migrates while scx_bypass() works through the cpus, leaving one
before its requeue and arriving on another after it, is requeued by neither
and keeps its wait, which then counts against the sched now running it. That
is what happened to every task before this patch. This might be worth
addressing in the future, but the race is rare and the real-world
implications should be limited.

Fixes: 2c91169377f4 ("sched_ext: Blame the DSQ's owning scheduler for a runnable stall")
Cc: stable@vger.kernel.org # v7.3+: 30fb2b1e4d41: sched_ext: Fix the running task keeping its protection into bypass
Cc: stable@vger.kernel.org # v7.3+: 5809f749fbdb: sched_ext: Fix a bypassed task stalling on a cpu its scheduler has no caps on
Cc: stable@vger.kernel.org # v7.3+
Reported-by: Andrea Righi <arighi@nvidia.com>
Link: https://lore.kernel.org/all/at4l0yXTk7T_ouk0@gpd4/
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 84774147a1d5b..28e04d1043a28 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -2235,7 +2235,8 @@ static void ops_dequeue(struct rq *rq, struct task_struct *p, u64 deq_flags)
 	/*
 	 * Don't reset runnable_at. If @p is waiting, the wait continues across
 	 * temporary dequeues, e.g. for a migration or an attribute change.
-	 * scx_disable_task() ends it if @p leaves its scheduler.
+	 * scx_disable_task() ends it if @p leaves its scheduler. scx_bypass()
+	 * restarts it when its requeue can change the sched running @p.
 	 */
 	clr_task_runnable(p, false);
 
@@ -3844,24 +3845,17 @@ static bool check_rq_for_timeouts(struct rq *rq)
 		goto out_unlock;
 
 	list_for_each_entry(p, &rq->scx.runnable_list, scx.runnable_node) {
-		struct scx_sched *sch = scx_task_sched(p);
+		/*
+		 * @p's owner schedules @p, or its host while the owner is
+		 * bypassing. Test @p against that sched's timeout and blame it.
+		 */
+		struct scx_sched *sch = scx_exec_sched(scx_task_sched(p), cpu_of(rq));
 		unsigned long last_runnable = p->scx.runnable_at;
 
 		if (unlikely(time_after(jiffies,
 					last_runnable + READ_ONCE(sch->watchdog_timeout)))) {
-			struct scx_dispatch_q *dsq = READ_ONCE(p->scx.dsq);
 			u32 dur_ms = jiffies_to_msecs(jiffies - last_runnable);
 
-			/*
-			 * A task can be stuck on a DSQ that a sched other than
-			 * its owner is responsible for draining, e.g. an
-			 * ancestor's bypass DSQ while the owner is bypassing.
-			 * Blame the drainer. The local DSQ is consumed by the
-			 * cpu itself and keeps blame on the owner.
-			 */
-			if (dsq && dsq->sched && dsq->id != SCX_DSQ_LOCAL)
-				sch = dsq->sched;
-
 			__scx_exit(sch, SCX_EXIT_ERROR_STALL, 0, cpu_of(rq),
 				   "%s[%d] failed to run for %u.%03us",
 				   p->comm, p->pid, dur_ms / 1000,
@@ -6369,7 +6363,9 @@ void scx_bypass(struct scx_sched *sch, bool bypass)
 		 */
 		list_for_each_entry_safe_reverse(p, n, &rq->scx.runnable_list,
 						 scx.runnable_node) {
-			if (!scx_is_descendant(scx_task_sched(p), sch))
+			struct scx_sched *owner = scx_task_sched(p);
+
+			if (!scx_is_descendant(owner, sch))
 				continue;
 
 			/*
@@ -6381,7 +6377,19 @@ void scx_bypass(struct scx_sched *sch, bool bypass)
 
 			/* cycling deq/enq is enough, see the function comment */
 			scoped_guard (sched_change, p, DEQUEUE_SAVE | DEQUEUE_MOVE) {
-				/* nothing */ ;
+				/*
+				 * The requeue can change the sched running @p,
+				 * and the watchdog counts @p's wait against
+				 * that sched. Restart the wait unless @owner is
+				 * the root, which runs its own tasks bypassing
+				 * or not.
+				 *
+				 * A dispatch in flight writes p->scx.flags
+				 * without @p's rq lock. The dequeue waits it
+				 * out, so set the flag after it.
+				 */
+				if (scx_parent(owner))
+					p->scx.flags |= SCX_TASK_RESET_RUNNABLE_AT;
 			}
 		}
 
-- 
2.53.0



