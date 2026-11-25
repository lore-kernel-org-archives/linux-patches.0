Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620801;
	b=z/24biKQALB09JIwDpnPNcFg8esP+1FUHHX0P0MatOXABPKSY1js/X53PYr6M+D1+Me2
	 u7fCVrGjQ6kwXeBl1BElMQmEM+gp2qWd/T+CJ3YVdN/GgsP/5bRjAlXsE59/R7xY62GmU
	 uLPV2/nqO052gCANUJtDEgzKgT519cack8/yigA2UHk6XhIpbvYAsPOD72Cejkcc4PKfl
	 HErasxlLRZ29PfJITa0sAZ5Egw9yDOFJllbZxYdSoWDMFBCiwGaGM71TLcMLkXS6GFa1I
	 tAcREW49Tdf4rgRS0+c5uJPRvFpw2ehJuqjjfKTMZT97ie2Jt9cQNT3JXDBUeimkR7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7y7btWLCb9rewHgFiVBzDtk9gX/BenTNLEWTBkZUzOI=;
	b=rbyw35xl/RlyqCKVOxEmeARE26doWS+ZpjOKgYIQl1FRRxdn/TTI9WT7ndGhfJSk4Wkd
	 KkFIe3w8Fv6MDzLbIiX2KgFweJb+ZR8jpy1CKJj7yQapN43nCIaUJHhsHKPUE6wK7S6/l
	 H3a6yq+Un1LQA3fUNMUixn1hrUwnixYDCZfbehhpNpMvydLP5obvqtMexIXcNr0zGB9VW
	 a3sTm5Ib4cO5GQQA0djk7C81778kcjzBbhJhTwxEYUq1+jWAVg3NHsj3c5M2A/2H9TfKz
	 qMq6l7uX5TWxQxSn6uqNEkSiMQp4zQ/o5gVX0b3JsoC62wyRGd8nno9ZOaiGMNhsLkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DR2Bewyw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A6A606A32D;
	Wed, 25 Nov 2026 15:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DR2Bewyw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8121F000D3;
	Wed, 25 Nov 2026 15:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620801;
	bh=7y7btWLCb9rewHgFiVBzDtk9gX/BenTNLEWTBkZUzOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DR2BewywNL95bvoKPcWCgGyJyPx39UiG9WPLY7BJBI2VMP76Mqmly/RHIGDxCuly2
	 thdgM6Y8SllcpOvtacJ/6bOz1dHECLrRX7ry4ngxdvZodpoosvbEvVgUEOTbZ7AhIK
	 Mq3Ek1diHBzJrYUD7inab8AyIwIS3IuuvJuUcMz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/990] sched/deadline: Fix server stopping with runnable tasks
Date: Wed, 25 Nov 2026 15:23:15 +0100
Message-ID: <20261125143822.748141744@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit ca1e8eede4fc68ce85a9fdce1a6c13ad64933318 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 7064c8985b3db..1c677016115a9 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1434,7 +1434,7 @@ update_stats_dequeue_dl(struct dl_rq *dl_rq, struct sched_dl_entity *dl_se, int
 
 static void update_curr_dl_se(struct rq *rq, struct sched_dl_entity *dl_se, s64 delta_exec)
 {
-	bool idle = rq->curr == rq->idle;
+	bool idle = idle_rq(rq);
 	s64 scaled_delta_exec;
 
 	if (unlikely(delta_exec <= 0)) {
@@ -1617,8 +1617,8 @@ void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec)
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
@@ -1663,8 +1663,11 @@ void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec)
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
@@ -1779,6 +1782,7 @@ void dl_server_update(struct sched_dl_entity *dl_se, s64 delta_exec)
  *   "B:zero_laxity-wait" -> "C:idle-wait"        [label="7:dl_server_update_idle"]
  *   "B:zero_laxity-wait" -> "D:running"          [label="3:dl_server_timer"]
  *   "C:idle-wait" -> "A:init"                    [label="8:dl_server_timer"]
+ *   "C:idle-wait" -> "B:zero_laxity-wait"        [label="1:dl_server_start"]
  *   "C:idle-wait" -> "B:zero_laxity-wait"        [label="2:dl_server_update"]
  *   "C:idle-wait" -> "C:idle-wait"               [label="7:dl_server_update_idle"]
  *   "D:running" -> "A:init"                      [label="4:pick_task_dl"]
@@ -1804,6 +1808,7 @@ void dl_server_start(struct sched_dl_entity *dl_se)
 {
 	struct rq *rq = dl_se->rq;
 
+	dl_se->dl_defer_idle = 0;
 	if (!dl_server(dl_se) || dl_se->dl_server_active)
 		return;
 
-- 
2.53.0



