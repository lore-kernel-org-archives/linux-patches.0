Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347242F0C5C;
	Mon, 22 Sep 2025 19:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570213; cv=none; b=G8lg5PvaDuPFp6nvnSrMTovFMeMBrdj3OwUf9//0nK0gpsmfpOeAiW/ylKKxjrQB7N0cDcpUorxPOEVMhQLK8AXiXfLhQ/dgqek0YJh5GtrJoTBsz4MNgJlNYwGOl87ARuDn9MtoQICxjNUB9/0YMiplQrvi9+7Vvc1EZKj+wqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570213; c=relaxed/simple;
	bh=jivfD8tEK48UZWPfq94v42/n3FoVQaF5BqsrugQvuCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y/VwjE9njDINaW9NCyw2AUSSub/rB20zdCscKCUIT7b73I4knGyeeN5zD1U8QIh2Lhm7wA/NSngMbRDc+5+sJIaCNmnwfPJAJ9gy/1Ex900YmRuKtRabk7vnd1iaaZYIVtKcMEZks//HjYQy3GZQcywVzNZ4XwY5b7Ut4Cu555U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rskKq3wd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rskKq3wd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18E0C4CEF0;
	Mon, 22 Sep 2025 19:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570213;
	bh=jivfD8tEK48UZWPfq94v42/n3FoVQaF5BqsrugQvuCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rskKq3wdGySozUnIYJeboA0vk6UeDCHqxRzOypRfdcHcZcyxzzy9DOLlRkvEnOUF1
	 vl86P1aZPJWvPMX0rrFdmTcTMMWuX789zz2WyyUpEo41pBcsH2UAYsyWM+eDWeLsDF
	 zVi+UXK+BqYUJ+e0EfddWP7QsiCxVYnrt/ey1xAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.16 054/149] Revert "sched_ext: Skip per-CPU tasks in scx_bpf_reenqueue_local()"
Date: Mon, 22 Sep 2025 21:29:14 +0200
Message-ID: <20250922192414.221600309@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

commit 0b47b6c3543efd65f2e620e359b05f4938314fbd upstream.

scx_bpf_reenqueue_local() can be called from ops.cpu_release() when a
CPU is taken by a higher scheduling class to give tasks queued to the
CPU's local DSQ a chance to be migrated somewhere else, instead of
waiting indefinitely for that CPU to become available again.

In doing so, we decided to skip migration-disabled tasks, under the
assumption that they cannot be migrated anyway.

However, when a higher scheduling class preempts a CPU, the running task
is always inserted at the head of the local DSQ as a migration-disabled
task. This means it is always skipped by scx_bpf_reenqueue_local(), and
ends up being confined to the same CPU even if that CPU is heavily
contended by other higher scheduling class tasks.

As an example, let's consider the following scenario:

 $ schedtool -a 0,1, -e yes > /dev/null
 $ sudo schedtool -F -p 99 -a 0, -e \
   stress-ng -c 1 --cpu-load 99 --cpu-load-slice 1000

The first task (SCHED_EXT) can run on CPU0 or CPU1. The second task
(SCHED_FIFO) is pinned to CPU0 and consumes ~99% of it. If the SCHED_EXT
task initially runs on CPU0, it will remain there because it always sees
CPU0 as "idle" in the short gaps left by the RT task, resulting in ~1%
utilization while CPU1 stays idle:

    0[||||||||||||||||||||||100.0%]   8[                        0.0%]
    1[                        0.0%]   9[                        0.0%]
    2[                        0.0%]  10[                        0.0%]
    3[                        0.0%]  11[                        0.0%]
    4[                        0.0%]  12[                        0.0%]
    5[                        0.0%]  13[                        0.0%]
    6[                        0.0%]  14[                        0.0%]
    7[                        0.0%]  15[                        0.0%]
  PID USER       PRI  NI  S CPU  CPU%▽MEM%   TIME+  Command
 1067 root        RT   0  R   0  99.0  0.2  0:31.16 stress-ng-cpu [run]
  975 arighi      20   0  R   0   1.0  0.0  0:26.32 yes

By allowing scx_bpf_reenqueue_local() to re-enqueue migration-disabled
tasks, the scheduler can choose to migrate them to other CPUs (CPU1 in
this case) via ops.enqueue(), leading to better CPU utilization:

    0[||||||||||||||||||||||100.0%]   8[                        0.0%]
    1[||||||||||||||||||||||100.0%]   9[                        0.0%]
    2[                        0.0%]  10[                        0.0%]
    3[                        0.0%]  11[                        0.0%]
    4[                        0.0%]  12[                        0.0%]
    5[                        0.0%]  13[                        0.0%]
    6[                        0.0%]  14[                        0.0%]
    7[                        0.0%]  15[                        0.0%]
  PID USER       PRI  NI  S CPU  CPU%▽MEM%   TIME+  Command
  577 root        RT   0  R   0 100.0  0.2  0:23.17 stress-ng-cpu [run]
  555 arighi      20   0  R   1 100.0  0.0  0:28.67 yes

It's debatable whether per-CPU tasks should be re-enqueued as well, but
doing so is probably safer: the scheduler can recognize re-enqueued
tasks through the %SCX_ENQ_REENQ flag, reassess their placement, and
either put them back at the head of the local DSQ or let another task
attempt to take the CPU.

This also prevents giving per-CPU tasks an implicit priority boost,
which would otherwise make them more likely to reclaim CPUs preempted by
higher scheduling classes.

Fixes: 97e13ecb02668 ("sched_ext: Skip per-CPU tasks in scx_bpf_reenqueue_local()")
Cc: stable@vger.kernel.org # v6.15+
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Acked-by: Changwoo Min <changwoo@igalia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -6794,12 +6794,8 @@ __bpf_kfunc u32 scx_bpf_reenqueue_local(
 		 * CPUs disagree, they use %ENQUEUE_RESTORE which is bypassed to
 		 * the current local DSQ for running tasks and thus are not
 		 * visible to the BPF scheduler.
-		 *
-		 * Also skip re-enqueueing tasks that can only run on this
-		 * CPU, as they would just be re-added to the same local
-		 * DSQ without any benefit.
 		 */
-		if (p->migration_pending || is_migration_disabled(p) || p->nr_cpus_allowed == 1)
+		if (p->migration_pending)
 			continue;
 
 		dispatch_dequeue(rq, p);


