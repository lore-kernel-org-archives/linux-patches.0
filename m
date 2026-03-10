Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD43387574;
	Tue, 10 Mar 2026 11:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141660; cv=none; b=Yp/UZTvNQfjMhg1BbLCKj0UT1QVlL0LWUHmmEw3vKo5zmtQeoCWNBRryEbS5xqIEk0m2MsoB1D6J8zzFkvJy0CbQU3l5Or85DcSHMvBISVodh5bWtL3ZgXsG4CyISAltgZpq1/NL2fJ+DpC9iAaTEDDR1kPHGSLRTN8GQX6j+Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141660; c=relaxed/simple;
	bh=I/wTYYTmCgE70yJML7q7IScm1gyQeGySzxWqadRK/Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=He+wuGmJ1Lwfi7jmbmvmQrrdnOK2D6HPFmXGAiuUZCRxPAfVLbpmoajFaGiiENGYD6P5F3Ek932lRUrLHNCFbeQBFwST8L3Zg4RaDs5mH9MlQEaK9gB/5/J6OIn++/JBT3TtlwikdyVjXGgBBguF4ziXlRQcQ7eiDEsmTcgcYPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTzfF7ej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTzfF7ej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2E3C2BC86;
	Tue, 10 Mar 2026 11:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141660;
	bh=I/wTYYTmCgE70yJML7q7IScm1gyQeGySzxWqadRK/Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTzfF7ej/DNehj+47qkLdNGdrvXzRcW+iUjA20pCqV8+cfT92YpQBHj70gbN+c6HF
	 +GG3tjsVCNQ19D0Ehg1Bc5YT9s8ayP+cHIgO5JsJucVzpQdOJy8R+7rVxty8b5821d
	 1JBcCU9848x7daPF+AlQqXW2BLZDFaNT3q8z4JSOr+m2VdwEbj+57JK6I+10JT7A/9
	 n4HEm5X46QFu3jPN8PaVCKBT7qOmhMjnsqfQK7Qvw8FpMcpNWQt6Ly4mhXZ20uTNa8
	 jtrcoJs4WKX/Ooel+z5RXr6b8P1Z9a9Pk0JK8sZ8VffXfzY9xjRldSZYmlve/Er/vT
	 U/Y29FK3fFa4A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namhyung Kim <namhyung@kernel.org>,
	"Lai, Yi" <yi1.lai@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 027/314] perf/core: Fix invalid wait context in ctx_sched_in()
Date: Tue, 10 Mar 2026 07:14:46 -0400
Message-ID: <e572e2789fdb478d877d766e7e66ad30e5ef15d6.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index 6889a6bd8a395..0255795191cc8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4016,7 +4016,8 @@ static int merge_sched_in(struct perf_event *event, void *data)
 			if (*perf_event_fasync(event))
 				event->pending_kill = POLL_ERR;
 
-			perf_event_wakeup(event);
+			event->pending_wakeup = 1;
+			irq_work_queue(&event->pending_irq);
 		} else {
 			struct perf_cpu_pmu_context *cpc = this_cpc(event->pmu_ctx->pmu);
 
-- 
2.51.0

