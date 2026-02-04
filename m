Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677712D5A14;
	Wed,  4 Feb 2026 15:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218691; cv=none; b=IxiGeTwwHZ93mHT75AvgUq4aQtBgU6oKBVYypCpnVb1TGbi3InMCJzZdMMHK+HF8gg9AsjY17k/VVbF4T8SbfxV5If/5vp707uM4Bko15ZMLTTTybbf/irPyRTKsbjLMA1gyj6On6otS4/XXE1cxmqbJwUpokc6wfYYFRzAzpJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218691; c=relaxed/simple;
	bh=nhE0nCeExAqjVXQNBX/Mh2nfqkmw0qFaN5UNmBXryXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1F0+fXc7dWb02Jj2u40ie5fuNRVBbknLV3269MV4ged3N7GF81/VVn6PJyxUqTnXOrnAbtlAx0ObkBsV827RVI+wWvL1Xyk8EtxjDYZ3S1WijrVomtZkSkZJ3cXzLkFnew7Q03uGKgWkN/R4F4O6aj6H2VJzf/jNWZtorifMps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROOULLKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROOULLKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66F4C4CEF7;
	Wed,  4 Feb 2026 15:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218691;
	bh=nhE0nCeExAqjVXQNBX/Mh2nfqkmw0qFaN5UNmBXryXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROOULLKURMlMzoPO1LnT8w2VXFlugeZW9s8gJniWYclG3Xf1OUHhmUx8pt/96fU5P
	 Ya4TYztIKRP4akWsBPGanXRhdkpCsQe+Rr/SN5zx6WaRrkx8379smGNBAJB+rc10DD
	 25zE8cIqQVLAAsDOgWl6iK/LkJY9rQhKdHcR4YTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 32/87] sched/deadline: Document dl_server
Date: Wed,  4 Feb 2026 15:40:30 +0100
Message-ID: <20260204143848.068025999@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 2614069c5912e9d6f1f57c262face1b368fb8c93 ]

Place the notes that resulted from going through the dl_server code in a
comment.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Stable-dep-of: 115135422562 ("sched/deadline: Fix 'stuck' dl_server")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 194 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 194 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index abd0fb2d839c1..a860d77062395 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1624,6 +1624,200 @@ void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec)
 		update_curr_dl_se(dl_se->rq, dl_se, delta_exec);
 }
 
+/*
+ * dl_server && dl_defer:
+ *
+ *                                        6
+ *                            +--------------------+
+ *                            v                    |
+ *     +-------------+  4   +-----------+  5     +------------------+
+ * +-> |   A:init    | <--- | D:running | -----> | E:replenish-wait |
+ * |   +-------------+      +-----------+        +------------------+
+ * |     |         |    1     ^    ^               |
+ * |     | 1       +----------+    | 3             |
+ * |     v                         |               |
+ * |   +--------------------------------+   2      |
+ * |   |                                | ----+    |
+ * | 8 |       B:zero_laxity-wait       |     |    |
+ * |   |                                | <---+    |
+ * |   +--------------------------------+          |
+ * |     |              ^     ^           2        |
+ * |     | 7            | 2   +--------------------+
+ * |     v              |
+ * |   +-------------+  |
+ * +-- | C:idle-wait | -+
+ *     +-------------+
+ *       ^ 7       |
+ *       +---------+
+ *
+ *
+ * [A] - init
+ *   dl_server_active = 0
+ *   dl_throttled = 0
+ *   dl_defer_armed = 0
+ *   dl_defer_running = 0/1
+ *   dl_defer_idle = 0
+ *
+ * [B] - zero_laxity-wait
+ *   dl_server_active = 1
+ *   dl_throttled = 1
+ *   dl_defer_armed = 1
+ *   dl_defer_running = 0
+ *   dl_defer_idle = 0
+ *
+ * [C] - idle-wait
+ *   dl_server_active = 1
+ *   dl_throttled = 1
+ *   dl_defer_armed = 1
+ *   dl_defer_running = 0
+ *   dl_defer_idle = 1
+ *
+ * [D] - running
+ *   dl_server_active = 1
+ *   dl_throttled = 0
+ *   dl_defer_armed = 0
+ *   dl_defer_running = 1
+ *   dl_defer_idle = 0
+ *
+ * [E] - replenish-wait
+ *   dl_server_active = 1
+ *   dl_throttled = 1
+ *   dl_defer_armed = 0
+ *   dl_defer_running = 1
+ *   dl_defer_idle = 0
+ *
+ *
+ * [1] A->B, A->D
+ * dl_server_start()
+ *   dl_server_active = 1;
+ *   enqueue_dl_entity()
+ *     update_dl_entity(WAKEUP)
+ *       if (!dl_defer_running)
+ *         dl_defer_armed = 1;
+ *         dl_throttled = 1;
+ *     if (dl_throttled && start_dl_timer())
+ *       return; // [B]
+ *     __enqueue_dl_entity();
+ *     // [D]
+ *
+ * // deplete server runtime from client-class
+ * [2] B->B, C->B, E->B
+ * dl_server_update()
+ *   update_curr_dl_se() // idle = false
+ *     if (dl_defer_idle)
+ *       dl_defer_idle = 0;
+ *     if (dl_defer && dl_throttled && dl_runtime_exceeded())
+ *       dl_defer_running = 0;
+ *       hrtimer_try_to_cancel();   // stop timer
+ *       replenish_dl_new_period()
+ *         // fwd period
+ *         dl_throttled = 1;
+ *         dl_defer_armed = 1;
+ *       start_dl_timer();        // restart timer
+ *       // [B]
+ *
+ * // timer actually fires means we have runtime
+ * [3] B->D
+ * dl_server_timer()
+ *   if (dl_defer_armed)
+ *     dl_defer_running = 1;
+ *   enqueue_dl_entity(REPLENISH)
+ *     replenish_dl_entity()
+ *       // fwd period
+ *       if (dl_throttled)
+ *         dl_throttled = 0;
+ *       if (dl_defer_armed)
+ *         dl_defer_armed = 0;
+ *     __enqueue_dl_entity();
+ *     // [D]
+ *
+ * // schedule server
+ * [4] D->A
+ * pick_task_dl()
+ *   p = server_pick_task();
+ *   if (!p)
+ *     dl_server_stop()
+ *       dequeue_dl_entity();
+ *       hrtimer_try_to_cancel();
+ *       dl_defer_armed = 0;
+ *       dl_throttled = 0;
+ *       dl_server_active = 0;
+ *       // [A]
+ *   return p;
+ *
+ * // server running
+ * [5] D->E
+ * update_curr_dl_se()
+ *   if (dl_runtime_exceeded())
+ *     dl_throttled = 1;
+ *     dequeue_dl_entity();
+ *     start_dl_timer();
+ *     // [E]
+ *
+ * // server replenished
+ * [6] E->D
+ * dl_server_timer()
+ *   enqueue_dl_entity(REPLENISH)
+ *     replenish_dl_entity()
+ *       fwd-period
+ *       if (dl_throttled)
+ *         dl_throttled = 0;
+ *     __enqueue_dl_entity();
+ *     // [D]
+ *
+ * // deplete server runtime from idle
+ * [7] B->C, C->C
+ * dl_server_update_idle()
+ *   update_curr_dl_se() // idle = true
+ *     if (dl_defer && dl_throttled && dl_runtime_exceeded())
+ *       if (dl_defer_idle)
+ *         return;
+ *       dl_defer_running = 0;
+ *       hrtimer_try_to_cancel();
+ *       replenish_dl_new_period()
+ *         // fwd period
+ *         dl_throttled = 1;
+ *         dl_defer_armed = 1;
+ *       dl_defer_idle = 1;
+ *       start_dl_timer();        // restart timer
+ *       // [C]
+ *
+ * // stop idle server
+ * [8] C->A
+ * dl_server_timer()
+ *   if (dl_defer_idle)
+ *     dl_server_stop();
+ *     // [A]
+ *
+ *
+ * digraph dl_server {
+ *   "A:init" -> "B:zero_laxity-wait"             [label="1:dl_server_start"]
+ *   "A:init" -> "D:running"                      [label="1:dl_server_start"]
+ *   "B:zero_laxity-wait" -> "B:zero_laxity-wait" [label="2:dl_server_update"]
+ *   "B:zero_laxity-wait" -> "C:idle-wait"        [label="7:dl_server_update_idle"]
+ *   "B:zero_laxity-wait" -> "D:running"          [label="3:dl_server_timer"]
+ *   "C:idle-wait" -> "A:init"                    [label="8:dl_server_timer"]
+ *   "C:idle-wait" -> "B:zero_laxity-wait"        [label="2:dl_server_update"]
+ *   "C:idle-wait" -> "C:idle-wait"               [label="7:dl_server_update_idle"]
+ *   "D:running" -> "A:init"                      [label="4:pick_task_dl"]
+ *   "D:running" -> "E:replenish-wait"            [label="5:update_curr_dl_se"]
+ *   "E:replenish-wait" -> "B:zero_laxity-wait"   [label="2:dl_server_update"]
+ *   "E:replenish-wait" -> "D:running"            [label="6:dl_server_timer"]
+ * }
+ *
+ *
+ * Notes:
+ *
+ *  - When there are fair tasks running the most likely loop is [2]->[2].
+ *    the dl_server never actually runs, the timer never fires.
+ *
+ *  - When there is actual fair starvation; the timer fires and starts the
+ *    dl_server. This will then throttle and replenish like a normal DL
+ *    task. Notably it will not 'defer' again.
+ *
+ *  - When idle it will push the actication forward once, and then wait
+ *    for the timer to hit or a non-idle update to restart things.
+ */
 void dl_server_start(struct sched_dl_entity *dl_se)
 {
 	struct rq *rq = dl_se->rq;
-- 
2.51.0



