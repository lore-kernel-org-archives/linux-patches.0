Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158C94ABBB4;
	Thu, 17 Sep 2026 15:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660037; cv=none; b=PQnB5WAyvj/L1VMh4DuGR7Lu2wH8s3WZ+4ddmqoACPpEpcgGl4TWu69yp8uOhhBHM3al0EQ/yqEOn7yhi5QH0kvVdT3X4/fZvDvKutPVZ+gwlIH/u04aQQtqHsWEpOvVTGlQhewBs/0XdmvJzq72b8FbrnqDRSE648Bm+UoZtKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660037; c=relaxed/simple;
	bh=fQeF0lGoBnFoeVzkjhO8tTbqF/Y5hzFJWKApolqi6R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQ58Sk33/KZHD0ov/Pst0tbuq5lYoltVy/YK83vkPb67/BAo8aZ9k/em0kis/6WiFds4jq8gHJzgBOYG5YEPuse792cljvG0L1+Wuz+f633Lgcrv8WF/3/0v/hMLfSBruIh1nkRrKiOz6aVkJWLjDliy1GO9BRmjoc1FNCfwPKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9gXdCNr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9gXdCNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195481F000FF;
	Thu, 17 Sep 2026 15:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660032;
	bh=Cp7/OseNZVxqLG/YnwHAgN8y4A9sBiGiPZoKIAtIDyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9gXdCNrJ1ErUeWOEKPIKYqLGDOhpsEgsQiTT4h0CtxIVB4iSjwWlszsMBtv5Dg+P
	 Gyw9shsa0/jGZUm7s4gpcsaNIz96Pbi0Mtlgsy2h6+W+AqbHHvRVSbMI3Cyk0FrDAu
	 JBywO6VYJOVPxHURNFaANQLM5uvmHZMkwgWSCjzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Hui Su <sh_def@163.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 418/733] sched: Account cgroup CPU time to the execution context
Date: Thu, 17 Sep 2026 16:12:06 +0100
Message-ID: <20260917151402.214550830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index a30d539a3f054..bb8a5f358ee19 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1373,7 +1373,6 @@ static s64 update_se(struct rq *rq, struct sched_entity *se)
 
 	se->exec_start = now;
 	if (entity_is_task(se)) {
-		struct task_struct *donor = task_of(se);
 		struct task_struct *running = rq->curr;
 		/*
 		 * If se is a task, we account the time against the running
@@ -1386,8 +1385,7 @@ static s64 update_se(struct rq *rq, struct sched_entity *se)
 		account_group_exec_runtime(running, delta_exec);
 		account_mm_sched(rq, running, delta_exec);
 
-		/* cgroup time is always accounted against the donor */
-		cgroup_account_cputime(donor, delta_exec);
+		cgroup_account_cputime(running, delta_exec);
 	} else {
 		/* If not task, account the time against donor se  */
 		se->sum_exec_runtime += delta_exec;
-- 
2.53.0



