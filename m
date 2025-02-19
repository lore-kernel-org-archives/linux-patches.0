Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E72F1E2606;
	Wed, 19 Feb 2025 08:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954654; cv=none; b=WVnCU7gDP+PzI1K7YGB6cJ99uJQJtaF+Im6hxpPv9FMHLCeocIhHanOZGPfj29h3xqMKUqZ5uZitrvRsN+PrUhKxRmxRjRorFrfpI5eqDA5H8vZ5EFBFQjsokx51IHxWUhzw2KEoan2s6vxLqFgl/lQwii3OvnHamq8mmQGvN1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954654; c=relaxed/simple;
	bh=7yLay5thbhndgqYGfLEgTQuO+SncTkvmZ7IsaI1sYT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtTc3sE51U9pVrKbJwUzNbeVHC898E9HnT7OWSdcNQ4JgeOn4gqGD+wGPtNsfOX7+++C3tRqMHvr7IamnbIzDKcoJcz3T6fLX8gHT0RksmPOklBbeLxlkHYonpFhDEE6P23fVs8WQQQoV7AZAc+RRdabxQ0/Te5saj3FHKBkesM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvK5lTrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvK5lTrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88153C4CED1;
	Wed, 19 Feb 2025 08:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954653;
	bh=7yLay5thbhndgqYGfLEgTQuO+SncTkvmZ7IsaI1sYT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvK5lTrVUrZcyjm5fCfxHZJMzd8H0cP8gNJkYGyooBqTDPsPRU4dRQJjUY27zBSm1
	 vtXLj5gf8IEWGdvUh1GZWT/Uq57TtsOB5n0+iOi25IaqDfvIxcRY6vpAzS9avL2uIO
	 KTGtx5DrP+bSTpppRPuyQ+gESA+i2nKiO60dDyeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Jake Hillion <jakehillion@meta.com>
Subject: [PATCH 6.13 270/274] sched_ext: Fix incorrect assumption about migration disabled tasks in task_can_run_on_remote_rq()
Date: Wed, 19 Feb 2025 09:28:44 +0100
Message-ID: <20250219082620.153419420@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

commit f3f08c3acfb8860e07a22814a344e83c99ad7398 upstream.

While fixing migration disabled task handling, 32966821574c ("sched_ext: Fix
migration disabled handling in targeted dispatches") assumed that a
migration disabled task's ->cpus_ptr would only have the pinned CPU. While
this is eventually true for migration disabled tasks that are switched out,
->cpus_ptr update is performed by migrate_disable_switch() which is called
right before context_switch() in __scheduler(). However, the task is
enqueued earlier during pick_next_task() via put_prev_task_scx(), so there
is a race window where another CPU can see the task on a DSQ.

If the CPU tries to dispatch the migration disabled task while in that
window, task_allowed_on_cpu() will succeed and task_can_run_on_remote_rq()
will subsequently trigger SCHED_WARN(is_migration_disabled()).

  WARNING: CPU: 8 PID: 1837 at kernel/sched/ext.c:2466 task_can_run_on_remote_rq+0x12e/0x140
  Sched_ext: layered (enabled+all), task: runnable_at=-10ms
  RIP: 0010:task_can_run_on_remote_rq+0x12e/0x140
  ...
   <TASK>
   consume_dispatch_q+0xab/0x220
   scx_bpf_dsq_move_to_local+0x58/0xd0
   bpf_prog_84dd17b0654b6cf0_layered_dispatch+0x290/0x1cfa
   bpf__sched_ext_ops_dispatch+0x4b/0xab
   balance_one+0x1fe/0x3b0
   balance_scx+0x61/0x1d0
   prev_balance+0x46/0xc0
   __pick_next_task+0x73/0x1c0
   __schedule+0x206/0x1730
   schedule+0x3a/0x160
   __do_sys_sched_yield+0xe/0x20
   do_syscall_64+0xbb/0x1e0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fix it by converting the SCHED_WARN() back to a regular failure path. Also,
perform the migration disabled test before task_allowed_on_cpu() test so
that BPF schedulers which fail to handle migration disabled tasks can be
noticed easily.

While at it, adjust scx_ops_error() message for !task_allowed_on_cpu() case
for brevity and consistency.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 32966821574c ("sched_ext: Fix migration disabled handling in targeted dispatches")
Acked-by: Andrea Righi <arighi@nvidia.com>
Reported-by: Jake Hillion <jakehillion@meta.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2324,6 +2324,25 @@ static bool task_can_run_on_remote_rq(st
 	SCHED_WARN_ON(task_cpu(p) == cpu);
 
 	/*
+	 * If @p has migration disabled, @p->cpus_ptr is updated to contain only
+	 * the pinned CPU in migrate_disable_switch() while @p is being switched
+	 * out. However, put_prev_task_scx() is called before @p->cpus_ptr is
+	 * updated and thus another CPU may see @p on a DSQ inbetween leading to
+	 * @p passing the below task_allowed_on_cpu() check while migration is
+	 * disabled.
+	 *
+	 * Test the migration disabled state first as the race window is narrow
+	 * and the BPF scheduler failing to check migration disabled state can
+	 * easily be masked if task_allowed_on_cpu() is done first.
+	 */
+	if (unlikely(is_migration_disabled(p))) {
+		if (trigger_error)
+			scx_ops_error("SCX_DSQ_LOCAL[_ON] cannot move migration disabled %s[%d] from CPU %d to %d",
+				      p->comm, p->pid, task_cpu(p), cpu);
+		return false;
+	}
+
+	/*
 	 * We don't require the BPF scheduler to avoid dispatching to offline
 	 * CPUs mostly for convenience but also because CPUs can go offline
 	 * between scx_bpf_dsq_insert() calls and here. Trigger error iff the
@@ -2331,17 +2350,11 @@ static bool task_can_run_on_remote_rq(st
 	 */
 	if (!task_allowed_on_cpu(p, cpu)) {
 		if (trigger_error)
-			scx_ops_error("SCX_DSQ_LOCAL[_ON] verdict target cpu %d not allowed for %s[%d]",
-				      cpu_of(rq), p->comm, p->pid);
+			scx_ops_error("SCX_DSQ_LOCAL[_ON] target CPU %d not allowed for %s[%d]",
+				      cpu, p->comm, p->pid);
 		return false;
 	}
 
-	/*
-	 * If @p has migration disabled, @p->cpus_ptr only contains its current
-	 * CPU and the above task_allowed_on_cpu() test should have failed.
-	 */
-	SCHED_WARN_ON(is_migration_disabled(p));
-
 	if (!scx_rq_online(rq))
 		return false;
 


