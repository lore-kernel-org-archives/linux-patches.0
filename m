Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A06171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29227C433EF;
	Mon,  8 May 2023 11:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546217;
	bh=8FKQOqs3o8lmTULLybBmUTLAuZ4LZGYR+71A50+bPEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GD/XWf0nuwK0dhloQnwHy/ALV7Xz0QBIyMxKm/c/XH1PxzX3cEuSyaJiiedDaBGn1
	 CFDlojOqnPYYpmq53uiV9sBuFqdm+AMCfPOm5ePOrCS3azMHzLOiXxtrfTA2D311FT
	 Lqn8379vfTPBU7NgG4HLr5ekExSFI/8VxN3ZTMVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 296/371] workqueue: Fix hung time report of worker pools
Date: Mon,  8 May 2023 11:48:17 +0200
Message-Id: <20230508094823.785044537@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit 335a42ebb0ca8ee9997a1731aaaae6dcd704c113 ]

The workqueue watchdog prints a warning when there is no progress in
a worker pool. Where the progress means that the pool started processing
a pending work item.

Note that it is perfectly fine to process work items much longer.
The progress should be guaranteed by waking up or creating idle
workers.

show_one_worker_pool() prints state of non-idle worker pool. It shows
a delay since the last pool->watchdog_ts.

The timestamp is updated when a first pending work is queued in
__queue_work(). Also it is updated when a work is dequeued for
processing in worker_thread() and rescuer_thread().

The delay is misleading when there is no pending work item. In this
case it shows how long the last work item is being proceed. Show
zero instead. There is no stall if there is no pending work.

Fixes: 82607adcf9cdf40fb7b ("workqueue: implement lockup detector")
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index de6463b931762..2d27bed9881dd 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4857,10 +4857,16 @@ static void show_one_worker_pool(struct worker_pool *pool)
 	struct worker *worker;
 	bool first = true;
 	unsigned long flags;
+	unsigned long hung = 0;
 
 	raw_spin_lock_irqsave(&pool->lock, flags);
 	if (pool->nr_workers == pool->nr_idle)
 		goto next_pool;
+
+	/* How long the first pending work is waiting for a worker. */
+	if (!list_empty(&pool->worklist))
+		hung = jiffies_to_msecs(jiffies - pool->watchdog_ts) / 1000;
+
 	/*
 	 * Defer printing to avoid deadlocks in console drivers that
 	 * queue work while holding locks also taken in their write
@@ -4869,9 +4875,7 @@ static void show_one_worker_pool(struct worker_pool *pool)
 	printk_deferred_enter();
 	pr_info("pool %d:", pool->id);
 	pr_cont_pool_info(pool);
-	pr_cont(" hung=%us workers=%d",
-		jiffies_to_msecs(jiffies - pool->watchdog_ts) / 1000,
-		pool->nr_workers);
+	pr_cont(" hung=%lus workers=%d", hung, pool->nr_workers);
 	if (pool->manager)
 		pr_cont(" manager: %d",
 			task_pid_nr(pool->manager->task));
-- 
2.39.2



