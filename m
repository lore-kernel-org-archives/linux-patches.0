Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5199831E107;
	Fri,  9 Jan 2026 12:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961984; cv=none; b=YML991eBPffxfLKlk4hj7jf6o87y/gRgtehoYL2PfWjqIt3xMlcA5HnQ/UNEXns6bMLQXjdTjb+RQfL2rmjg22Exb642DHOAKU6zCKK7s0xW4pELaDweHEBL3OBEFWmatXt4HrhRYzddKre+ivUpa7NdQWH0/wuSPPLgsQg/VKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961984; c=relaxed/simple;
	bh=GZCKIyKMFyDNdEkISuodvbmFjM8kY6yjU+cUCiIwB0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmfTu5kGd0Qo3YUeJfD/Xb2oP8uRzCcieThDM/80kuw2CrmONnRIZmkpF5UQ/lk11r3/4q8HnL9vvY0X+Y8IzfiSnIy3l0RKauUdOKnyRjw+IS12BvjRcHU8QEtXkSVckRMV+FQyYgdRWDjtSSrUmPCQFfKxNKOzwyMvIkAmKz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zc2+Oi2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zc2+Oi2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6CDC16AAE;
	Fri,  9 Jan 2026 12:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961983;
	bh=GZCKIyKMFyDNdEkISuodvbmFjM8kY6yjU+cUCiIwB0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zc2+Oi2P/+EOvaFg1AsuK5jc7Z3JiH3QPOmK0p5hBpYcKV1xp3DRxOaNvWlNaQCYt
	 iqrgFvNDqRytRcswybEmH70KySMVuUnBuK06xVpoHMSpKUJZmfAZF1zc43Cy4h6mO0
	 wWqaQzDEQmMvzBDPuStQvNAx7SfD3cvvsSO/e6P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 204/634] blk-mq: Abort suspend when wakeup events are pending
Date: Fri,  9 Jan 2026 12:38:02 +0100
Message-ID: <20260109112125.115923241@linuxfoundation.org>
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

From: Cong Zhang <cong.zhang@oss.qualcomm.com>

[ Upstream commit c196bf43d706592d8801a7513603765080e495fb ]

During system suspend, wakeup capable IRQs for block device can be
delayed, which can cause blk_mq_hctx_notify_offline() to hang
indefinitely while waiting for pending request to complete.
Skip the request waiting loop and abort suspend when wakeup events are
pending to prevent the deadlock.

Fixes: bf0beec0607d ("blk-mq: drain I/O when all CPUs in a hctx are offline")
Signed-off-by: Cong Zhang <cong.zhang@oss.qualcomm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 373a67a630f3b..d3ced0cff9161 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -24,6 +24,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/sched/topology.h>
 #include <linux/sched/signal.h>
+#include <linux/suspend.h>
 #include <linux/delay.h>
 #include <linux/crash_dump.h>
 #include <linux/prefetch.h>
@@ -3510,6 +3511,7 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 {
 	struct blk_mq_hw_ctx *hctx = hlist_entry_safe(node,
 			struct blk_mq_hw_ctx, cpuhp_online);
+	int ret = 0;
 
 	if (!cpumask_test_cpu(cpu, hctx->cpumask) ||
 	    !blk_mq_last_cpu_in_hctx(cpu, hctx))
@@ -3531,12 +3533,24 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 	 * frozen and there are no requests.
 	 */
 	if (percpu_ref_tryget(&hctx->queue->q_usage_counter)) {
-		while (blk_mq_hctx_has_requests(hctx))
+		while (blk_mq_hctx_has_requests(hctx)) {
+			/*
+			 * The wakeup capable IRQ handler of block device is
+			 * not called during suspend. Skip the loop by checking
+			 * pm_wakeup_pending to prevent the deadlock and improve
+			 * suspend latency.
+			 */
+			if (pm_wakeup_pending()) {
+				clear_bit(BLK_MQ_S_INACTIVE, &hctx->state);
+				ret = -EBUSY;
+				break;
+			}
 			msleep(5);
+		}
 		percpu_ref_put(&hctx->queue->q_usage_counter);
 	}
 
-	return 0;
+	return ret;
 }
 
 static int blk_mq_hctx_notify_online(unsigned int cpu, struct hlist_node *node)
-- 
2.51.0



