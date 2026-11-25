Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623894;
	b=cByVV03jopCZX6RJxCyeUqTnIVs8AWyBU72PNQSOMWa2Qr351bMu0KUinSyaAa5YmGak
	 0n4YU1KWcxw8/9mwEEfzAOKKuNF0E2XgIQOeSOGuieUo/lrfOJjuWELGwOhmgc5a+EtWc
	 X3yJlGrKRcJ8T555xu3PUCk2+hWRLrQCXTp9N1j+//1I/LQ0Y1irR4BvvDVCrU2ZNgntq
	 ebsjs+E7onhQWFJPVmhRMChy2uF+5FqQ9j7geE4Lfgw36A1rtXj2WIt1zRvrVOHHMVZ4G
	 9EqxBArZBz59r8DOY8+KYpFDTrZY5qVabZWLlX9JjoD/EkM22nTQdp8ENJcHpR3ZxAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=trW7B/UXv3Vs3+GfZ5z2HVLLToxIMiTJNSDlNwIYwaU=;
	b=cIfhPpGhREvqr1jPWGSJb6svzAzv+wasUyYYm0RQMs5kl0OeTetRFrPN8ZaxCWQKo1No
	 pXvLTxXiycfq/PTS4k1oUE2YTwknjdkdjcMLmyjSb7+oZSpK13F544QT3FYoSvShsUCpF
	 i09vrbSg50E5+1tuiOlwc4ZkVQkLCRHneGXXLbHi1iI8rPDYTfMwxsgedki72CoYv+4jU
	 T/8w1y7MhEo6pNBJ97zA31L7EzKiYvm2jndauJLFKuSDTlXf0j+WuS2cyy5NJNfAAduCj
	 2UVUynFoTSoE/h8rkAvGutRGAtIiUBfaI9QOIIQuA/XjNJVn+kdTFNfjWHEpVQCSfiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RohcGuTr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CDB606A321;
	Wed, 25 Nov 2026 16:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RohcGuTr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1447B1F000CA;
	Wed, 25 Nov 2026 16:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623893;
	bh=trW7B/UXv3Vs3+GfZ5z2HVLLToxIMiTJNSDlNwIYwaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RohcGuTrvXKuhPQow3tOlAEWQiAASLMgZMzX/WGeKLJ7bwA0FB8Dbs1KAAWrUQKgU
	 OU+734DXWgqb/CUbNggkey4Gs6wFq0lQW4z40Y20+zL9Zhx8OXP7IqbH1NyFZ6OYU9
	 aWJJEID5Ih6v+VB3+BU1S3QQzWJJpSBrG5L3Ndjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Florent Carli <fcarli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/816] sched/deadline: Fix server stopping with runnable tasks
Date: Wed, 25 Nov 2026 15:26:07 +0100
Message-ID: <20261125143849.660780255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

commit ca1e8eede4fc68ce85a9fdce1a6c13ad64933318 upstream.

The deadline server can currently stop due to idle although fair tasks
are runnable. This happens essentially when:

 * the server is set to idle, a task wakes up, the server stops
 * a task wakes up, the server sets itself to idle and stops right away

Address both cases by clearing the server idle flag whenever a fair task
wakes up and accounting also for pending tasks in the definition of idle.

Fixes: f5a538c07df2 ("sched/deadline: Fix dl_server stop condition")
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260113085159.114226-3-gmonaco@redhat.com
[ Florent: context conflict in dl_server_start(), which still
  initializes the fair server in 6.12 ]
Signed-off-by: Florent Carli <fcarli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ea64ab4364f77..2da68de709135 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1482,7 +1482,7 @@ update_stats_dequeue_dl(struct dl_rq *dl_rq, struct sched_dl_entity *dl_se, int
 
 static void update_curr_dl_se(struct rq *rq, struct sched_dl_entity *dl_se, s64 delta_exec)
 {
-	bool idle = rq->curr == rq->idle;
+	bool idle = idle_rq(rq);
 	s64 scaled_delta_exec;
 
 	if (unlikely(delta_exec <= 0)) {
@@ -1663,8 +1663,8 @@ void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec)
  * | 8 |       B:zero_laxity-wait       |     |    |
  * |   |                                | <---+    |
  * |   +--------------------------------+          |
- * |     |              ^     ^           2        |
- * |     | 7            | 2   +--------------------+
+ * |     |              ^         ^       2        |
+ * |     | 7            | 2, 1    +----------------+
  * |     v              |
  * |   +-------------+  |
  * +-- | C:idle-wait | -+
@@ -1709,8 +1709,11 @@ void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec)
  *   dl_defer_idle = 0
  *
  *
- * [1] A->B, A->D
+ * [1] A->B, A->D, C->B
  * dl_server_start()
+ *   dl_defer_idle = 0;
+ *   if (dl_server_active)
+ *     return; // [B]
  *   dl_server_active = 1;
  *   enqueue_dl_entity()
  *     update_dl_entity(WAKEUP)
@@ -1825,6 +1828,7 @@ void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec)
  *   "B:zero_laxity-wait" -> "C:idle-wait"        [label="7:dl_server_update_idle"]
  *   "B:zero_laxity-wait" -> "D:running"          [label="3:dl_server_timer"]
  *   "C:idle-wait" -> "A:init"                    [label="8:dl_server_timer"]
+ *   "C:idle-wait" -> "B:zero_laxity-wait"        [label="1:dl_server_start"]
  *   "C:idle-wait" -> "B:zero_laxity-wait"        [label="2:dl_server_update"]
  *   "C:idle-wait" -> "C:idle-wait"               [label="7:dl_server_update_idle"]
  *   "D:running" -> "A:init"                      [label="4:pick_task_dl"]
@@ -1850,6 +1854,7 @@ void dl_server_start(struct sched_dl_entity *dl_se)
 {
 	struct rq *rq = dl_se->rq;
 
+	dl_se->dl_defer_idle = 0;
 	/*
 	 * XXX: the apply do not work fine at the init phase for the
 	 * fair server because things are not yet set. We need to improve
-- 
2.53.0



