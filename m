Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA1D152196;
	Wed,  5 Feb 2025 14:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764001; cv=none; b=a1q131r1E+0uuIcMF+/rQQKyXB1Af1UaNYpOWAJhPFOKC0CPz84G30F7pINYzNd/UebxNvCQ8qAke0aGM+S+rqzS566/Iajta3kEdSyKOFFCCaUrguiMnVEkejAQEF12a1lbfBYCWk43b6t5LCrSC4vCv34LukdvGd+12ywKd4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764001; c=relaxed/simple;
	bh=e4o4DrZj2R4JmmjpxVBKbxbrYJSfkEM1jM45Tb7CqFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckC6KJQFL3vnTLckSTrQOQ7IKZPp0hjU0Mo4tdjM8aqf1cZgO4xIvMQtrgwpwgy4xAuXK6I3A6kAICc7RyRZZS8WStxkx3ik83aDuD1/5jjWxlIlIN2WvekrwJk0aaXkKmbMdQObrBYkf6DSW70fRFsx6Y339rFNkDJaXC9dgMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNXatzOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNXatzOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25CFC4CED1;
	Wed,  5 Feb 2025 14:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764001;
	bh=e4o4DrZj2R4JmmjpxVBKbxbrYJSfkEM1jM45Tb7CqFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNXatzOMQAKWwsC0ZL0a2g0SKuHhBsOcVY5Ea/88UkVrkMvyCkX7DIs96wlRRmuRI
	 i0pJ89T+f1bR+c3AlmGVuGBiObiJtIVSyTZeyZAu+6Y4rnomccL21UplHoMgY/+R9w
	 Sq66Ufxr92ZBE9f1ebUguLSJ65bAtSErp4OeRpdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <chengming.zhou@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 037/623] psi: Fix race when task wakes up before psi_sched_switch() adjusts flags
Date: Wed,  5 Feb 2025 14:36:19 +0100
Message-ID: <20250205134457.648205541@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengming Zhou <chengming.zhou@linux.dev>

[ Upstream commit 7d9da040575b343085287686fa902a5b2d43c7ca ]

When running hackbench in a cgroup with bandwidth throttling enabled,
following PSI splat was observed:

    psi: inconsistent task state! task=1831:hackbench cpu=8 psi_flags=14 clear=0 set=4

When investigating the series of events leading up to the splat,
following sequence was observed:

    [008] d..2.: sched_switch: ... ==> next_comm=hackbench next_pid=1831 next_prio=120
        ...
    [008] dN.2.: dequeue_entity(task delayed): task=hackbench pid=1831 cfs_rq->throttled=0
    [008] dN.2.: pick_task_fair: check_cfs_rq_runtime() throttled cfs_rq on CPU8
    # CPU8 goes into newidle balance and releases the rq lock
        ...
    # CPU15 on same LLC Domain is trying to wakeup hackbench(pid=1831)
    [015] d..4.: psi_flags_change: psi: task state: task=1831:hackbench cpu=8 psi_flags=14 clear=0 set=4 final=14 # Splat (cfs_rq->throttled=1)
    [015] d..4.: sched_wakeup: comm=hackbench pid=1831 prio=120 target_cpu=008 # Task has woken on a throttled hierarchy
    [008] d..2.: sched_switch: prev_comm=hackbench prev_pid=1831 prev_prio=120 prev_state=S ==> ...

psi_dequeue() relies on psi_sched_switch() to set the correct PSI flags
for the blocked entity, however, with the introduction of DELAY_DEQUEUE,
the block task can wakeup when newidle balance drops the runqueue lock
during __schedule().

If a task wakes before psi_sched_switch() adjusts the PSI flags, skip
any modifications in psi_enqueue() which would still see the flags of a
running task and not a blocked one. Instead, rely on psi_sched_switch()
to do the right thing.

Since the status returned by try_to_block_task() may no longer be true
by the time schedule reaches psi_sched_switch(), check if the task is
blocked or not using a combination of task_on_rq_queued() and
p->se.sched_delayed checks.

[ prateek: Commit message, testing, early bailout in psi_enqueue() ]

Fixes: 152e11f6df29 ("sched/fair: Implement delayed dequeue") # 1a6151017ee5
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Link: https://lore.kernel.org/r/20241227061941.2315-1-kprateek.nayak@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c  | 6 +++---
 kernel/sched/stats.h | 4 ++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3e5a6bf587f91..e0fd8069c60e6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6641,7 +6641,6 @@ static void __sched notrace __schedule(int sched_mode)
 	 * as a preemption by schedule_debug() and RCU.
 	 */
 	bool preempt = sched_mode > SM_NONE;
-	bool block = false;
 	unsigned long *switch_count;
 	unsigned long prev_state;
 	struct rq_flags rf;
@@ -6702,7 +6701,7 @@ static void __sched notrace __schedule(int sched_mode)
 			goto picked;
 		}
 	} else if (!preempt && prev_state) {
-		block = try_to_block_task(rq, prev, prev_state);
+		try_to_block_task(rq, prev, prev_state);
 		switch_count = &prev->nvcsw;
 	}
 
@@ -6748,7 +6747,8 @@ static void __sched notrace __schedule(int sched_mode)
 
 		migrate_disable_switch(rq, prev);
 		psi_account_irqtime(rq, prev, next);
-		psi_sched_switch(prev, next, block);
+		psi_sched_switch(prev, next, !task_on_rq_queued(prev) ||
+					     prev->se.sched_delayed);
 
 		trace_sched_switch(preempt, prev, next, prev_state);
 
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 8ee0add5a48a8..6ade91bce63ee 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -138,6 +138,10 @@ static inline void psi_enqueue(struct task_struct *p, int flags)
 	if (flags & ENQUEUE_RESTORE)
 		return;
 
+	/* psi_sched_switch() will handle the flags */
+	if (task_on_cpu(task_rq(p), p))
+		return;
+
 	if (p->se.sched_delayed) {
 		/* CPU migration of "sleeping" task */
 		SCHED_WARN_ON(!(flags & ENQUEUE_MIGRATED));
-- 
2.39.5



