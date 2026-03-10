Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39E53859E3;
	Tue, 10 Mar 2026 11:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140795; cv=none; b=akBiy2Kz8jvLX7z2FdKkHrZZpvLNCdzTBmfYTKcUFiz2ZmrKP7oecoioEvAvzRrWpkPaNge77FpASxuCPVxn4LplI9Jdh59QMVRd75PANIe7zOdQtsOBcEidMLHQXOvB6nWg9px+vL0MV6bzgAZ12usQ1YhZdFJk3Pm37D4jzis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140795; c=relaxed/simple;
	bh=r2FaaUp8UmHONNCh5eelz9969088M6Ty1TG2PFWd9t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6KZyFSmWv+9X8zCmB8TEZYvhK+if9jzhr4lOPl45O0k6u0vTijHr1l7rNCslmm2ws/mzc3lJDbTxBnde7EkYd7UJ2Z4vN7GwlDntSNfhTAGz+VpHNc7om6MPhxAxNSuBeMYIEWT0/pkkSUfinuaeEbpa5TvlanrzfCeJ4lfyKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZhNaHd7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZhNaHd7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2C7C2BC9E;
	Tue, 10 Mar 2026 11:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140794;
	bh=r2FaaUp8UmHONNCh5eelz9969088M6Ty1TG2PFWd9t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhNaHd7ClgrD7EYKideVmm0m2OugCGh5VS2cv0qHzQRM5mtJv1+ZYIHzdMBOAzakE
	 s9cDrsVH1LFI83zlPz5f9MUgIceJt6Ce3btOVxWXEoYjIK1pJ9cTqls4yNtEVI8VAr
	 4MU2fHWmq5dYppvpnQNd60i7T6DA0ubGuoHP2dQFZZd7how0272RiwRMFtZ4MUqSG2
	 K7x89vXTtC/dptl3MU+JHpObX2kDpyEfm8SXq6CnqCd0y0MF+0LcwfnXr01TUKi0YP
	 A/ZO09hCl5BBK24h9lwNCcoyd/SzHysbsPNjHjX5AJ7WNnpf2C4juAHnu2+ebELxiL
	 ogeIpJZX/sloA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namhyung Kim <namhyung@kernel.org>,
	"Lai, Yi" <yi1.lai@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 031/311] perf/core: Fix invalid wait context in ctx_sched_in()
Date: Tue, 10 Mar 2026 07:01:18 -0400
Message-ID: <3487c39bc665c0318c26923de1dad6f78eb80755.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 486ff5ad49bc50315bcaf6d45f04a33ef0a45ced ]

Lockdep found a bug in the event scheduling when a pinned event was
failed and wakes up the threads in the ring buffer like below.

It seems it should not grab a wait-queue lock under perf-context lock.
Let's do it with irq_work.

  [   39.913691] =============================
  [   39.914157] [ BUG: Invalid wait context ]
  [   39.914623] 6.15.0-next-20250530-next-2025053 #1 Not tainted
  [   39.915271] -----------------------------
  [   39.915731] repro/837 is trying to lock:
  [   39.916191] ffff88801acfabd8 (&event->waitq){....}-{3:3}, at: __wake_up+0x26/0x60
  [   39.917182] other info that might help us debug this:
  [   39.917761] context-{5:5}
  [   39.918079] 4 locks held by repro/837:
  [   39.918530]  #0: ffffffff8725cd00 (rcu_read_lock){....}-{1:3}, at: __perf_event_task_sched_in+0xd1/0xbc0
  [   39.919612]  #1: ffff88806ca3c6f8 (&cpuctx_lock){....}-{2:2}, at: __perf_event_task_sched_in+0x1a7/0xbc0
  [   39.920748]  #2: ffff88800d91fc18 (&ctx->lock){....}-{2:2}, at: __perf_event_task_sched_in+0x1f9/0xbc0
  [   39.921819]  #3: ffffffff8725cd00 (rcu_read_lock){....}-{1:3}, at: perf_event_wakeup+0x6c/0x470

Fixes: f4b07fd62d4d ("perf/core: Use POLLHUP for a pinned event in error")
Closes: https://lore.kernel.org/lkml/aD2w50VDvGIH95Pf@ly-workstation
Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: "Lai, Yi" <yi1.lai@linux.intel.com>
Link: https://patch.msgid.link/20250603045105.1731451-1-namhyung@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c0bb657e28e31..4311c33c3381c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4017,7 +4017,8 @@ static int merge_sched_in(struct perf_event *event, void *data)
 			if (*perf_event_fasync(event))
 				event->pending_kill = POLL_ERR;
 
-			perf_event_wakeup(event);
+			event->pending_wakeup = 1;
+			irq_work_queue(&event->pending_irq);
 		} else {
 			struct perf_cpu_pmu_context *cpc = this_cpc(event->pmu_ctx->pmu);
 
-- 
2.51.0

