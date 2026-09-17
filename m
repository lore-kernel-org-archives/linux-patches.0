Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245E94FD283;
	Thu, 17 Sep 2026 17:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666094; cv=none; b=N9f3ZxqLfNBKRzsvlfBTWIR612Xdpk773MF/mGNaRzk1Z973KNGQccLbsBOTzGNOFEzeMYp3Na9ftCgFHVHr79BbvyRjLXAwqMRyyIYqy+ysJfOBMtCaErlnO8zlM2fft+5nckJN+eOYIGnBZEkGn4gr6VNof8owdk0JYW6EBQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666094; c=relaxed/simple;
	bh=TPogbWQ8nb+76d+/vIpfQkjiH0VPp/bgIOrGiU803E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVnPkQAdruReYbc4N0Ee0VvxfvM93prkSnCcrb87NkvrTp6jr8IT/q1AcVhX8C9kj+eODvww4+2BYHzcBHwx5YGPZcPiClRMkCsxmuMQCVzqiwem0F9UpPsdgEUkb1qNVwweU29bCnpy5WLbjLMyukFf9ypa2oFWIUst+C0saZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uny2Hjel; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uny2Hjel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD981F000FF;
	Thu, 17 Sep 2026 17:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666093;
	bh=jZcNuBnDZPvnfJmDC7J9WTYOwWyWb8qTnxInjb5uw/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uny2Hjel0OdNYdVyVpWaov6gd/QNP1wqFmDAWtNvfnhL34I2XwY7QFLojbXuDQ+0e
	 EKaY0XnyHaVL/MD+xLLqERvYryDvFskhBQGWxona1qQ+80EydmQ22LIS38+nJFuuIy
	 dSEK+IFmUv/G7MvFG5hMa3VYTQJhvBHvxdpKgntI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0922/1250] sched/core: Call wq_worker_tick() for the execution context
Date: Thu, 17 Sep 2026 16:11:57 +0100
Message-ID: <20260917151616.997082532@linuxfoundation.org>
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

[ Upstream commit f5741d2b34519d387edf6e9798fc7030c20a35f3 ]

wq_worker_tick() accounts CPU time and detects CPU-intensive work for
the kworker that is actually running. With proxy execution, rq->donor
is the scheduling context while rq->curr is the execution context.

Calling the hook with rq->donor can skip workqueue accounting when a
kworker is executing on behalf of a donor task. It can also account a
blocked kworker when the donor is a worker but rq->curr is the task
actually executing. The former can delay WORKER_CPU_INTENSIVE handling
and pool concurrency management, which can delay pending kernel work
and userspace operations depending on it.

Use rq->curr for the workqueue tick hook while retaining rq->donor for
scheduler accounting.

Fixes: af0c8b2bf67b ("sched: Split scheduler and execution contexts")
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20260902150208.1209922-2-sh_def@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a46716a8afc7a..43f3ac16b0e8a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5598,8 +5598,8 @@ void sched_tick(void)
 {
 	int cpu = smp_processor_id();
 	struct rq *rq = cpu_rq(cpu);
-	/* accounting goes to the donor task */
-	struct task_struct *donor;
+	/* scheduler accounting goes to the donor task */
+	struct task_struct *curr, *donor;
 	struct rq_flags rf;
 	unsigned long hw_pressure;
 	u64 resched_latency;
@@ -5610,6 +5610,7 @@ void sched_tick(void)
 	sched_clock_tick();
 
 	rq_lock(rq, &rf);
+	curr = rq->curr;
 	donor = rq->donor;
 
 	psi_account_irqtime(rq, donor, NULL);
@@ -5636,8 +5637,8 @@ void sched_tick(void)
 
 	perf_event_task_tick();
 
-	if (donor->flags & PF_WQ_WORKER)
-		wq_worker_tick(donor);
+	if (curr->flags & PF_WQ_WORKER)
+		wq_worker_tick(curr);
 
 	if (!scx_switched_all()) {
 		rq->idle_balance = idle_cpu(cpu);
-- 
2.53.0



