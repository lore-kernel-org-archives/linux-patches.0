Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3634A0F14;
	Thu, 17 Sep 2026 15:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660040; cv=none; b=mwtAgEc/X9yAtTgd9dEs4mRyGaDP4R7n7uhbng97HP++YVAkde2YZwljzc3dxFUxEE/Fb0dBwPz9+H+0QDthV6xQ/tufrM/cgyD/pwXSgcTXZIbQmKiwCO9s4WzyyGUinMxJO1fDaBbH5t2SaqcA3Yi4MpuXlsde/auwM1fzGmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660040; c=relaxed/simple;
	bh=HnZgjOvXAZTe+5ovHrmnv/ZoOflmo5RHJZVDrlOzM1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OV6UpRdkbmn5QQLtVidtNcVHdEvc4cTPEaPjH0AOvjFosML5cq6NqXbSvfxibgomln0ETQp9XSV3zYU22AcfLHMi51JbhIDfNnbiYFgSN2toPmf1YYW0MkzmG5KkUQWsl6ziuyh8IPcqCDDiZtpTxzlbRmEeKlGBgz7IVlz4sa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4c2vOsz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4c2vOsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058311F00893;
	Thu, 17 Sep 2026 15:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660035;
	bh=X9nww6wJQsd8mQ2JFq0AHcGk7dYbgEGTP7wRcduljM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4c2vOszYNujPtewVXuwXm23g44Gqiyz8vyQrFoS5bgG2d/uA92ZHbo1EV00QPsqZ
	 cjVAfNb3jek1ROeXJBG1bK3ccAsrzrIXLiA+sDzPLmc5IsdUT4Bq4KAUI6fCUKVkyM
	 Tj2ttDzGfTFDf8Pnk7UlOp1ncN/gPfwSKtlUwGHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 419/733] sched/core: Call wq_worker_tick() for the execution context
Date: Thu, 17 Sep 2026 16:12:07 +0100
Message-ID: <20260917151402.243506748@linuxfoundation.org>
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
index d0992ecda4c72..35d647c8c3683 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5780,8 +5780,8 @@ void sched_tick(void)
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
@@ -5792,6 +5792,7 @@ void sched_tick(void)
 	sched_clock_tick();
 
 	rq_lock(rq, &rf);
+	curr = rq->curr;
 	donor = rq->donor;
 
 	psi_account_irqtime(rq, donor, NULL);
@@ -5817,8 +5818,8 @@ void sched_tick(void)
 
 	perf_event_task_tick();
 
-	if (donor->flags & PF_WQ_WORKER)
-		wq_worker_tick(donor);
+	if (curr->flags & PF_WQ_WORKER)
+		wq_worker_tick(curr);
 
 	if (!scx_switched_all()) {
 		rq->idle_balance = idle_cpu(cpu);
-- 
2.53.0



