Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8DC4D179A;
	Thu, 17 Sep 2026 17:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666091; cv=none; b=XIi+D0yvMLJfFNF+44H5Uho8MIAGMXGX/HmALaTGdZWj7VoGy624y3ewGVLRhGrLkh+nviOsmE+k3WEx1NU+s36PbsUldYbwGKbbcEGXHYyGV2KSJmy3XwjDjCkQxhDw0uyYot5PMVvTgtXuCR3J/gsNlxav5L0iOEQ8soo4vNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666091; c=relaxed/simple;
	bh=zjjEo0dC65XPDCyLjt0VLHXfpEauikZYyxO5cnArIF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEdrdSu4BRfZANmXERoRycH4AJ/VHWtzxqcsMEGyIV2TPOcZ6G9CEZ9crjnrq6VrCqUfZ8MngjOIp3f5m9J5se+PHFl34sdXMLCUF2sJl+WpTTJ9lDGoP6+OvqT3aLszA+L8NPPtnTxmjwefYmpi+yLyIkY9A7rVaPKy+2JaIcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imB66G4t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imB66G4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726001F000FF;
	Thu, 17 Sep 2026 17:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666090;
	bh=1nAchl0QlQ3pwXPYp/1S5GNP209OXikkTbY61SMthN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=imB66G4tUFeCtU7axKzX1MGXrBZXBq7qZ/37RMcjnQBVIfdlv+JB3g+HpOh6OuyXz
	 RRNGCVDmKlUEOK+xV7hftocWzmFPgftU+4rdUMvVgXsFMES59iuf+fldtgpFYDjB1u
	 Qxo7MQychm+FUhE8gO8DwUdWHZze8k5EVu8fRGuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Hui Su <sh_def@163.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0921/1250] sched: Account cgroup CPU time to the execution context
Date: Thu, 17 Sep 2026 16:11:56 +0100
Message-ID: <20260917151616.969385155@linuxfoundation.org>
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

From: Hui Su <sh_def@163.com>

[ Upstream commit c23810313bdf6b02f39a1f2a1464c4b18bd39e31 ]

Proxy execution separates the scheduling context from the execution
context. Commit aa4f74dfd42b ("sched: Fix runtime accounting w/ split
exec & sched contexts") made per-task and thread-group runtime
accounting follow the task that actually executes, while cgroup CPU
usage is charged to the donor.

When the donor and execution task belong to different cgroups, this
makes a task's execution time count against a different cgroup from the
one the task belongs to.

Cgroup CPU usage should follow the execution context, matching the
per-task, thread-group, and cgroup user/system accounting. Keep
scheduling state associated with the donor, but charge cgroup CPU
usage to rq->curr.

A reproducer with the donor and execution task in separate cgroups
showed the execution task accumulating runtime while cgroup CPU usage
was charged to the donor's cgroup. With this change, the execution
task's cgroup accumulates the CPU usage instead. The same behavior was
verified with an RT donor and with legacy cpuacct accounting.

Fixes: aa4f74dfd42b ("sched: Fix runtime accounting w/ split exec & sched contexts")
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: John Stultz <jstultz@google.com>
Link: https://patch.msgid.link/20260904034707.268416-1-sh_def@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 325aedbdb32a7..67e8c2065d827 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1250,7 +1250,6 @@ static s64 update_se(struct rq *rq, struct sched_entity *se)
 
 	se->exec_start = now;
 	if (entity_is_task(se)) {
-		struct task_struct *donor = task_of(se);
 		struct task_struct *running = rq->curr;
 		/*
 		 * If se is a task, we account the time against the running
@@ -1262,8 +1261,7 @@ static s64 update_se(struct rq *rq, struct sched_entity *se)
 		trace_sched_stat_runtime(running, delta_exec);
 		account_group_exec_runtime(running, delta_exec);
 
-		/* cgroup time is always accounted against the donor */
-		cgroup_account_cputime(donor, delta_exec);
+		cgroup_account_cputime(running, delta_exec);
 	} else {
 		/* If not task, account the time against donor se  */
 		se->sum_exec_runtime += delta_exec;
-- 
2.53.0



