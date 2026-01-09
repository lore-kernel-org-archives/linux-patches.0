Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC3935A955;
	Fri,  9 Jan 2026 12:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962651; cv=none; b=YicIaN3XwZDcT5F6AbFQRHCNKtYVTxNvd+t5+YHKT9NHxJFc40V6A339SJ+pGCHKrLo72m5DlwYTEH0YzBUmV83teCSa+0EYjehOOMEpiD/dP75wM7fNSEnVBC2wQMqHfbLvjco4sNfiBPU8HGUOex+s2412UZtHWZ8+ug+bIpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962651; c=relaxed/simple;
	bh=SfpvyjfKohfGCA/nRI4zdHR/eRRYEmTmeO/x4JMPN2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWNstzvBhRRYpkVsMTALE59IUbDkQM0eeQzpTWBLRK9Aa2IpeDEQtdM8BNEtg7M7E02DRjIQBFd4Sqa0pXoyNokI5dizq5607lASDJOyHVRJQqA+v8f7eTlbpgEF+ZuvLKDZTXVN0SXXliiW5Sg86MKp3v1tCXMnVuaRoOwo+YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8qIYMUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8qIYMUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C34C4CEF1;
	Fri,  9 Jan 2026 12:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962651;
	bh=SfpvyjfKohfGCA/nRI4zdHR/eRRYEmTmeO/x4JMPN2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8qIYMUecXNil4zN0ND5RWwtfeejcl8tLIYdAWP84n02aqrEsZiUdIU4K1Cu+Bog4
	 4dg4wuVvhy8YKifO0NCQaD3j/jCTVb6rjU/R2kq8MzK7fvRpmnOBL34yZzvPg2vPlG
	 uD1aIQAKRfd9aJO5eJfZTUXR+34wTnsfYQeGBIxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Andrew Theurer <atheurer@redhat.com>,
	Joe Mario <jmario@redhat.com>,
	Sebastian Jug <sejug@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Tejun Heo <tj@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 440/634] blk-mq: dont schedule block kworker on isolated CPUs
Date: Fri,  9 Jan 2026 12:41:58 +0100
Message-ID: <20260109112134.097561298@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit a46c27026da10a126dd870f7b65380010bd20db5 ]

Kernel parameter of `isolcpus=` or 'nohz_full=' are used to isolate CPUs
for specific task, and it isn't expected to let block IO disturb these CPUs.
blk-mq kworker shouldn't be scheduled on isolated CPUs. Also if isolated
CPUs is run for blk-mq kworker, long block IO latency can be caused.

Kernel workqueue only respects CPU isolation for WQ_UNBOUND, for bound
WQ, the responsibility is on user because CPU is specified as WQ API
parameter, such as mod_delayed_work_on(cpu), queue_delayed_work_on(cpu)
and queue_work_on(cpu).

So not run blk-mq kworker on isolated CPUs by removing isolated CPUs
from hctx->cpumask. Meantime use queue map to check if all CPUs in this
hw queue are offline instead of hctx->cpumask, this way can avoid any
cost in fast IO code path, and is safe since hctx->cpumask are only
used in the two cases.

Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Andrew Theurer <atheurer@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
Cc: Sebastian Jug <sejug@redhat.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>
Tesed-by: Joe Mario <jmario@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Link: https://lore.kernel.org/r/20240322021244.1056223-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 10845a105bbc ("blk-mq: skip CPU offline notify on unmapped hctx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 57 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d3ced0cff916..6cfbbe0d7792 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -30,6 +30,7 @@
 #include <linux/prefetch.h>
 #include <linux/blk-crypto.h>
 #include <linux/part_stat.h>
+#include <linux/sched/isolation.h>
 
 #include <trace/events/block.h>
 
@@ -2216,6 +2217,15 @@ static inline int blk_mq_first_mapped_cpu(struct blk_mq_hw_ctx *hctx)
 	return cpu;
 }
 
+/*
+ * ->next_cpu is always calculated from hctx->cpumask, so simply use
+ * it for speeding up the check
+ */
+static bool blk_mq_hctx_empty_cpumask(struct blk_mq_hw_ctx *hctx)
+{
+        return hctx->next_cpu >= nr_cpu_ids;
+}
+
 /*
  * It'd be great if the workqueue API had a way to pass
  * in a mask and had some smarts for more clever placement.
@@ -2227,7 +2237,8 @@ static int blk_mq_hctx_next_cpu(struct blk_mq_hw_ctx *hctx)
 	bool tried = false;
 	int next_cpu = hctx->next_cpu;
 
-	if (hctx->queue->nr_hw_queues == 1)
+	/* Switch to unbound if no allowable CPUs in this hctx */
+	if (hctx->queue->nr_hw_queues == 1 || blk_mq_hctx_empty_cpumask(hctx))
 		return WORK_CPU_UNBOUND;
 
 	if (--hctx->next_cpu_batch <= 0) {
@@ -3497,14 +3508,30 @@ static bool blk_mq_hctx_has_requests(struct blk_mq_hw_ctx *hctx)
 	return data.has_rq;
 }
 
-static inline bool blk_mq_last_cpu_in_hctx(unsigned int cpu,
-		struct blk_mq_hw_ctx *hctx)
+static bool blk_mq_hctx_has_online_cpu(struct blk_mq_hw_ctx *hctx,
+		unsigned int this_cpu)
 {
-	if (cpumask_first_and(hctx->cpumask, cpu_online_mask) != cpu)
-		return false;
-	if (cpumask_next_and(cpu, hctx->cpumask, cpu_online_mask) < nr_cpu_ids)
-		return false;
-	return true;
+	enum hctx_type type = hctx->type;
+	int cpu;
+
+	/*
+	 * hctx->cpumask has to rule out isolated CPUs, but userspace still
+	 * might submit IOs on these isolated CPUs, so use the queue map to
+	 * check if all CPUs mapped to this hctx are offline
+	 */
+	for_each_online_cpu(cpu) {
+		struct blk_mq_hw_ctx *h = blk_mq_map_queue_type(hctx->queue,
+				type, cpu);
+
+		if (h != hctx)
+			continue;
+
+		/* this hctx has at least one online CPU */
+		if (this_cpu != cpu)
+			return true;
+	}
+
+	return false;
 }
 
 static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
@@ -3513,8 +3540,7 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 			struct blk_mq_hw_ctx, cpuhp_online);
 	int ret = 0;
 
-	if (!cpumask_test_cpu(cpu, hctx->cpumask) ||
-	    !blk_mq_last_cpu_in_hctx(cpu, hctx))
+	if (blk_mq_hctx_has_online_cpu(hctx, cpu))
 		return 0;
 
 	/*
@@ -3933,6 +3959,8 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 	}
 
 	queue_for_each_hw_ctx(q, hctx, i) {
+		int cpu;
+
 		/*
 		 * If no software queues are mapped to this hardware queue,
 		 * disable it and free the request entries.
@@ -3959,6 +3987,15 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 		 */
 		sbitmap_resize(&hctx->ctx_map, hctx->nr_ctx);
 
+		/*
+		 * Rule out isolated CPUs from hctx->cpumask to avoid
+		 * running block kworker on isolated CPUs
+		 */
+		for_each_cpu(cpu, hctx->cpumask) {
+			if (cpu_is_isolated(cpu))
+				cpumask_clear_cpu(cpu, hctx->cpumask);
+		}
+
 		/*
 		 * Initialize batch roundrobin counts
 		 */
-- 
2.51.0



