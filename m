Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B57E37F01B;
	Sat, 17 Oct 2026 17:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258230; cv=none; b=lAwBdYihluaMeDMoDX8BdwxBmxVOx92NKTHs90nnmlv8a+VTNddpz3tYGkQCUNtp1/yh6W9bxh8wHxLHuqShoplkmjOQhRXJ+uL6RMaRB5Jj2I1fd9Qp2wQklH19xNtWdnu9ZiLqwSkNszh2fnhyeGjBiSTd+PGW6jH2qWVkTuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258230; c=relaxed/simple;
	bh=P2u+nxKS9qvzZraeCpxaRhsVLbku4RfkFwT1MvwMO80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcUsl8P7MkIz7NVnfXFzPIp5IbbAq2GTOBhnX7gfk9unyO/ca0+jfkSmx91dB/ZkA0J3BSSu8DVznV8I0GO5baNQF99LrdVDxh4gRXoN8vamcoDSX4NB2YqaNK/45GlSKC5A86FUmuWhJRsPtHy11UaJXo8YGFfgbxhxuj8T8QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyUkBFg7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyUkBFg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B5A1F000C4;
	Sat, 17 Oct 2026 17:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258229;
	bh=+Zuh9IC0kZQyl9SJ+13PNBJeELcD6/RTZISWZ+/AA5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyUkBFg7raiBfwp28WfaVQ4ym0Fu58EBuS7FBBP7o3JiGa1cv6QwCw9iJWNh4HXOa
	 7uIuScVpHbtch1I8l3T9f83Q9ZhZiMr7jxvCYsgk+wSvTHU4Xl5RCHPPLfSKZvfauj
	 UQGUv+wbOl8S1CLNvra202vktyNrQE3DidCHJOh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xabier Marquiegui <reibax@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0798/1674] ptp: Replace timestamp event queue with linked list
Date: Sat, 17 Oct 2026 17:51:10 +0200
Message-ID: <20261017160451.592704789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xabier Marquiegui <reibax@gmail.com>

[ Upstream commit d26ab5a35ad9920940a9e07665130d501b2ae1a3 ]

Introduce linked lists to access the timestamp event queue.

Signed-off-by: Xabier Marquiegui <reibax@gmail.com>
Suggested-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e9f35294e18d ("ptp: Add a upper bound on max_vclocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_chardev.c | 12 ++++++++++--
 drivers/ptp/ptp_clock.c   | 26 ++++++++++++++++++++++++--
 drivers/ptp/ptp_private.h |  4 +++-
 drivers/ptp/ptp_sysfs.c   |  6 +++++-
 4 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 1ed12e86ee000..92f9447d41b0c 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -460,10 +460,14 @@ __poll_t ptp_poll(struct posix_clock_context *pccontext, struct file *fp,
 {
 	struct ptp_clock *ptp =
 		container_of(pccontext->clk, struct ptp_clock, clock);
+	struct timestamp_event_queue *queue;
 
 	poll_wait(fp, &ptp->tsev_wq, wait);
 
-	return queue_cnt(&ptp->tsevq) ? EPOLLIN : 0;
+	/* Extract only the first element in the queue list */
+	queue = list_first_entry(&ptp->tsevqs, struct timestamp_event_queue, qlist);
+
+	return queue_cnt(queue) ? EPOLLIN : 0;
 }
 
 #define EXTTS_BUFSIZE (PTP_BUF_TIMESTAMPS * sizeof(struct ptp_extts_event))
@@ -473,12 +477,16 @@ ssize_t ptp_read(struct posix_clock_context *pccontext, uint rdflags,
 {
 	struct ptp_clock *ptp =
 		container_of(pccontext->clk, struct ptp_clock, clock);
-	struct timestamp_event_queue *queue = &ptp->tsevq;
+	struct timestamp_event_queue *queue;
 	struct ptp_extts_event *event;
 	unsigned long flags;
 	size_t qcnt, i;
 	int result;
 
+	/* Extract only the first element in the queue list */
+	queue = list_first_entry(&ptp->tsevqs, struct timestamp_event_queue,
+				 qlist);
+
 	if (cnt % sizeof(struct ptp_extts_event) != 0)
 		return -EINVAL;
 
diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index d252d018bfe77..2eac19e231d5b 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -183,12 +183,21 @@ static struct posix_clock_operations ptp_clock_ops = {
 static void ptp_clock_release(struct device *dev)
 {
 	struct ptp_clock *ptp = container_of(dev, struct ptp_clock, dev);
+	struct timestamp_event_queue *tsevq;
+	unsigned long flags;
 
 	ptp_cleanup_pin_groups(ptp);
 	kfree(ptp->vclock_index);
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
 	mutex_destroy(&ptp->n_vclocks_mux);
+	/* Delete first entry */
+	tsevq = list_first_entry(&ptp->tsevqs, struct timestamp_event_queue,
+				 qlist);
+	spin_lock_irqsave(&tsevq->lock, flags);
+	list_del(&tsevq->qlist);
+	spin_unlock_irqrestore(&tsevq->lock, flags);
+	kfree(tsevq);
 	ida_free(&ptp_clocks_map, ptp->index);
 	kfree(ptp);
 }
@@ -225,6 +234,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 				     struct device *parent)
 {
 	struct ptp_clock *ptp;
+	struct timestamp_event_queue *queue = NULL;
 	int err = 0, index, major = MAJOR(ptp_devt);
 	size_t size;
 
@@ -247,7 +257,12 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	ptp->info = info;
 	ptp->devid = MKDEV(major, index);
 	ptp->index = index;
-	spin_lock_init(&ptp->tsevq.lock);
+	INIT_LIST_HEAD(&ptp->tsevqs);
+	queue = kzalloc(sizeof(*queue), GFP_KERNEL);
+	if (!queue)
+		goto no_memory_queue;
+	spin_lock_init(&queue->lock);
+	list_add_tail(&queue->qlist, &ptp->tsevqs);
 	mutex_init(&ptp->tsevq_mux);
 	mutex_init(&ptp->pincfg_mux);
 	mutex_init(&ptp->n_vclocks_mux);
@@ -355,6 +370,9 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
 	mutex_destroy(&ptp->n_vclocks_mux);
+	list_del(&queue->qlist);
+	kfree(queue);
+no_memory_queue:
 	ida_free(&ptp_clocks_map, index);
 no_slot:
 	kfree(ptp);
@@ -397,6 +415,7 @@ EXPORT_SYMBOL(ptp_clock_unregister);
 
 void ptp_clock_event(struct ptp_clock *ptp, struct ptp_clock_event *event)
 {
+	struct timestamp_event_queue *tsevq;
 	struct pps_event_time evt;
 
 	switch (event->type) {
@@ -405,7 +424,10 @@ void ptp_clock_event(struct ptp_clock *ptp, struct ptp_clock_event *event)
 		break;
 
 	case PTP_CLOCK_EXTTS:
-		enqueue_external_timestamp(&ptp->tsevq, event);
+		/* Enqueue timestamp on all queues */
+		list_for_each_entry(tsevq, &ptp->tsevqs, qlist) {
+			enqueue_external_timestamp(tsevq, event);
+		}
 		wake_up_interruptible(&ptp->tsev_wq);
 		break;
 
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index e25be08fa6ae9..baf05d55376dd 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -15,6 +15,7 @@
 #include <linux/ptp_clock.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/time.h>
+#include <linux/list.h>
 
 #define PTP_MAX_TIMESTAMPS 128
 #define PTP_BUF_TIMESTAMPS 30
@@ -30,6 +31,7 @@ struct timestamp_event_queue {
 	int head;
 	int tail;
 	spinlock_t lock;
+	struct list_head qlist;
 };
 
 struct ptp_clock {
@@ -40,7 +42,7 @@ struct ptp_clock {
 	int index; /* index into clocks.map */
 	struct pps_device *pps_source;
 	long dialed_frequency; /* remembers the frequency adjustment */
-	struct timestamp_event_queue tsevq; /* simple fifo for time stamps */
+	struct list_head tsevqs; /* timestamp fifo list */
 	struct mutex tsevq_mux; /* one process at a time reading the fifo */
 	struct mutex pincfg_mux; /* protect concurrent info->pin_config access */
 	wait_queue_head_t tsev_wq;
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index aefc06ae5d099..952d3e968bdf9 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -75,12 +75,16 @@ static ssize_t extts_fifo_show(struct device *dev,
 			       struct device_attribute *attr, char *page)
 {
 	struct ptp_clock *ptp = dev_get_drvdata(dev);
-	struct timestamp_event_queue *queue = &ptp->tsevq;
+	struct timestamp_event_queue *queue;
 	struct ptp_extts_event event;
 	unsigned long flags;
 	size_t qcnt;
 	int cnt = 0;
 
+	/* The sysfs fifo will always draw from the fist queue */
+	queue = list_first_entry(&ptp->tsevqs, struct timestamp_event_queue,
+				 qlist);
+
 	memset(&event, 0, sizeof(event));
 
 	if (mutex_lock_interruptible(&ptp->tsevq_mux))
-- 
2.53.0



