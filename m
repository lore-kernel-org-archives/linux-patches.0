Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C343F44D9;
	Wed, 20 May 2026 17:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299717; cv=none; b=qIReOuVMAQJMegyRzLx7CQm1hiN7nZVGfV3OXf7OdTZ5EVUjGgpugXY8nMpDaYonZjvJqEpcODHEZ0/pk/22iqM0gQs/f7skgogvUUkB1sADkI7ImroxVJMkpboYHWSiAsTyxCioApfGGJPTQmmjotgdkySvuE28MZN2zwhY2LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299717; c=relaxed/simple;
	bh=b41cx7Lncqe4XBmcfHnB2/YRxvGHQ6KjwK236pU92T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2Fyu0bL9Nl5vG8Wf4ackEamZH8aJD20ycYkIKpvuwGeubMEfYAVe52fJJVZ+ERBq7Z2TY7DUrzpVq5olHdpVQQHF7rvxNE7ka+c8mgmTY637QhHkZ6qCiR2RwyxMXwGJJKaWvWup9K1bvb7BscCtIcZ4FOoDv/uWfn9/isPNMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5YIhK3Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5YIhK3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA901F000E9;
	Wed, 20 May 2026 17:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299716;
	bh=JXTye/Eyc5HqnGKcKPYmuof1BUjtxDh7uREfZJY4DO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5YIhK3Ya1ywTV57kXcad7S6Bui6Owmw2MmpiA/6zgsFnKb2xnRG4ApH7UdPwrv1J
	 Z8wbZUtSMksva/iG32iSA9O+jkRNZAYvNlgBTPAcAGu36WzCDr+o3YUhPS1iD/OnKg
	 C/usYyEoxhK7Y3/P8k1P9aLsgvi4mXdzDLE+9P5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 877/957] sched/fair: Fix wakeup_preempt_fair() for not waking up task
Date: Wed, 20 May 2026 18:22:40 +0200
Message-ID: <20260520162153.585074499@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 9f6d929ee2c6f0266edb564bcd2bd47fd6e884a8 ]

Make sure to only call pick_next_entity() on an non-empty cfs_rq.

The assumption that p is always enqueued and not delayed, is only true for
wakeup. If p was moved while delayed, pick_next_entity() will dequeue it and
the cfs might become empty. Test if there are still queued tasks before trying
again to determine if p could be the next one to be picked.

There are at least 2 cases:

When cfs becomes idle, it tries to pull tasks but if those pulled tasks are
delayed, they will be dequeued when attached to cfs. attach_tasks() ->
attach_task() -> wakeup_preempt(rq, p, 0);

A misfit task running on cfs A triggers a load balance to be pulled on a better
cpu, the load balance on cfs B starts an active load balance to pulled the
running misfit task. If there is a delayed dequeue task on cfs A, it can be
pulled instead of the previously running misfit task. attach_one_task() ->
attach_task() -> wakeup_preempt(rq, p, 0);

Fixes: ac8e69e69363 ("sched/fair: Fix wakeup_preempt_fair() vs delayed dequeue")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260503104503.1732682-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 565a96d6811e7..58f535cc64215 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8985,9 +8985,10 @@ static void check_preempt_wakeup_fair(struct rq *rq, struct task_struct *p, int
 
 	/*
 	 * Because p is enqueued, nse being null can only mean that we
-	 * dequeued a delayed task.
+	 * dequeued a delayed task. If there are still entities queued in
+	 * cfs, check if the next one will be p.
 	 */
-	if (!nse)
+	if (!nse && cfs_rq->nr_queued)
 		goto pick;
 
 	if (sched_feat(RUN_TO_PARITY))
-- 
2.53.0



