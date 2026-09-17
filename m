Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114F84E9C12;
	Thu, 17 Sep 2026 17:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665441; cv=none; b=WfIJxcL7zmMkBaMBeRH/OO3BZwiO0DOkL8ZRDh7aloy3mTTO4OqN0861DvrCAGFZ+NTNGX7kYBteilEwhFp6YcB3IFNBoQZn5F3cvGzTNFFpS6a5hl4jMomUUVRd9K22UMawj8Kk3zOlJav6/WR2XD8McVsj0oAVWBSu525wt8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665441; c=relaxed/simple;
	bh=KkgshEqizvb2dGRyWbQfzpRmzKjbVnzTl33gzglhhMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5aqfytCGEJmP6DVnU4suttV86K7LHlnkL1rqsmTFvc4vR8MszCXkuI3cQoNwcS7NHMVw62on+XrXr7d0RUZN8eAiUBE4JaplEcLPOMJzjWduYhphpuYjClJ5MEg71FHnb0zNzO6fm+XdFopj90ewH2qBg+AbU+kVodTz4a8BXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BbtkkZS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BbtkkZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE8F1F000FF;
	Thu, 17 Sep 2026 17:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665439;
	bh=Z5ZZ16pcay3a1spT8EyRBCuNi0yj9RpIcpHklgJLmCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1BbtkkZS+YyoAVZu8UfWfoBjVQa3q+c9jXvtsNtL858ygSNny3slTFJPXH/mc4XRP
	 jYu8ArJOWpnW9KXKjVJoCU9aiP9Q6tIS2Afa4HNySVKsQD4aBoNqMngzzD37oc9epm
	 QwAZnqeGi9+Nz1lvQwKoCIvuvA5RfvnRzsUwh4IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seiji Nishikawa <snishika@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0706/1250] sched/rt,dl: Skip migrate-disabled tasks when picking a push candidate
Date: Thu, 17 Sep 2026 16:08:21 +0100
Message-ID: <20260917151611.036812964@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seiji Nishikawa <snishika@redhat.com>

[ Upstream commit dae5c0292080dd7b9c7d784268dcf443f1f3d15e ]

A migrate_disable()'d RT task cannot be moved to another CPU, but the
scheduler still keeps such a task on that CPU's pushable list
(rq->rt.pushable_tasks) and still marks the runqueue RT-overloaded
(rq->rt.overloaded = 1). So the RT balancer keeps treating this CPU as
having a task to move away, and keeps trying to move the task, but the
push can never succeed. When the head is pinned, push_rt_task() does not
give up either. It falls back to pushing rq->curr instead, using the
per-CPU stopper, as added by commit a7c81556ec4d ("sched: Fix
migrate_disable() vs rt/dl balancing").

The CPU spends tens of milliseconds in this retry loop. The core is
isolated for real-time work, but during the loop nearly half of its time
is consumed by pushes that cannot succeed.

An ftrace capture of the affected CPU, with sched_switch enabled and
commit 94894c9c477e ("sched/rt: Skip currently executing CPU in
rto_next_cpu()") applied, shows where the CPU time went. Two SCHED_FIFO
tasks at equal priority shared the CPU, taskA migrate_disable()'d and
queued, taskB as rq->curr. In one 89 ms window, taskB got only 52 ms of
CPU. The other 37 ms went to the stopper thread.

The scheduler kept trying to push taskA, the pinned head of the pushable
list, fell back to pushing taskB instead, and woke the stopper 5204
times. Every one of those pushes failed and no task was moved. taskA
stayed runnable and queued the whole time, and never ran.

Pushing taskB fails on a re-check. find_lock_lowest_rq() drops the rq
lock to take the target rq lock, then checks again with
"task != pick_next_pushable_task(rq)".

The task being pushed is taskB, but the pick returns taskA, the head of
the pushable list. taskB is rq->curr, and set_next_task_rt() removes the
running task from that list, so taskB can never be the head. The check
expects a candidate taken from the pushable list, but the fallback
pushes rq->curr, which is never on that list. So the check fails every
time.

   .--> push-IPI arrives
   |          |
   |          v
   |     pushable head = taskA   ->  pinned, cannot be pushed
   |          |
   |          v
   |     so push taskB instead   ->  wake migration/N, a stop-class
   |          |                      thread, so it preempts taskB
   |          v
   |     re-check compares taskB against the pushable head,
   |     which is still taskA                        ->  give up
   |          |
   |          v
   |     nothing moved, taskA still queued, rq still overloaded
   |          |
   '----------'
         repeats every ~17 us, 5204 times, for 89 ms

   The loop cannot stop itself. Every round leaves the runqueue
   exactly as it was, so the next push-IPI does the same thing. In
   the capture it ended only when taskB went to sleep on its own.
   taskA was then picked locally and left the pushable list.

   CPU time per task in the window, from sched_switch:

     taskB         51.95 ms   real work
     migration/N   37.18 ms   nothing moved
     taskA          0.00 ms   queued the whole time, never picked
     idle           0.01 ms

   Counts over the same window:

      7667  push-IPIs handled on this CPU
     17481  pick_next_pushable_task() returned taskA, still pinned
      5204  find_lock_lowest_rq() gave up on the re-check
         1  push that actually completed
         0  migrations of taskA

   The CPU times and the window length come from the standard
   sched_switch tracepoint. The counts needed tracepoints added inside
   the RT balancer for this investigation.

The self-IPI path is closed by the rto_next_cpu() fix above, and that
part works. But the runqueue is still marked overloaded, because the
pinned task is still advertised as pushable. Other CPUs now send the
push-IPIs during their own RT balancing, and the same loop runs again.
Closing the self-IPI path did not stop a pinned task from triggering
push balancing.

A pinned task should never have been returned as a push candidate in the
first place. A migrate_disable()'d task cannot be migrated, so it
belongs in the same skip that was added for on_cpu tasks by
commit e0ca8991b2de ("sched: Make class_schedulers avoid pushing
current, and get rid of proxy_tag_curr()"). Add is_migration_disabled()
to the skip condition in pick_next_pushable_task() and
pick_next_pushable_dl_task().

With the skip in place, if the pinned task is the only extra runnable
task the helpers return NULL, push_rt_task() and push_dl_task() give up
early, and no stopper is woken. The pinned task then runs locally once
curr yields. If a task that really can be migrated is queued behind the
pinned head, it is now picked and pushed for real.

This makes the fallback that pushes rq->curr unreachable when the
pushable head is migrate-disabled. Nothing is lost, because that path
was always stopped by the re-check described above. In the capture it
ran 5204 times and moved nothing.

Fixes: a7c81556ec4d ("sched: Fix migrate_disable() vs rt/dl balancing")
Signed-off-by: Seiji Nishikawa <snishika@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260830073746.2189355-1-snishika@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 4 ++--
 kernel/sched/rt.c       | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 42160b9d41433..0180758d90af8 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2777,8 +2777,8 @@ static struct task_struct *pick_next_pushable_dl_task(struct rq *rq)
 	next_node = rb_first_cached(&rq->dl.pushable_dl_tasks_root);
 	while (next_node) {
 		i = __node_2_pdl(next_node);
-		/* make sure task isn't on_cpu (possible with proxy-exec) */
-		if (!task_on_cpu(rq, i)) {
+		/* skip tasks that cannot be migrated */
+		if (!task_on_cpu(rq, i) && !is_migration_disabled(i)) {
 			p = i;
 			break;
 		}
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 720da18ade91b..fc9737decfb73 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1860,8 +1860,8 @@ static struct task_struct *pick_next_pushable_task(struct rq *rq)
 		return NULL;
 
 	plist_for_each_entry(i, head, pushable_tasks) {
-		/* make sure task isn't on_cpu (possible with proxy-exec) */
-		if (!task_on_cpu(rq, i)) {
+		/* skip tasks that cannot be migrated */
+		if (!task_on_cpu(rq, i) && !is_migration_disabled(i)) {
 			p = i;
 			break;
 		}
-- 
2.53.0



