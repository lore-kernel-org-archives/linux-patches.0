Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705D53C1981;
	Thu, 15 Jan 2026 17:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499181; cv=none; b=L+3beccCm0C8LWXrWBDMbG4KSEvdH0nVd5nWX6UiBfVnXNxn1Zws9qXD0qO5mlQQQH1JOFcu/cvnKDtioARZO7fhGS2BTm/Fu8HGRXgAeaqegrR+pN2wM+G+Q8qIet5SmBQgquwMNXjVu2B4Tg/wNqTUAixgoKoUXAnt7cmP/Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499181; c=relaxed/simple;
	bh=Vek8Cy9b4D0qV4ggQmrPUVrvj63FJCUsz43QWgb+FIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0XImsXwDHqGU7nmdEJUIlEs62WYRR0uBNTBe+1MTbA3Xmvs+E9B7Mj++ixHj1eu5IPOQNsaRE2y8JSCsIaLjDpB00XCNQstMsqMBdPhAgK5h8V6mEMOrqD5fkFRb1J4wLaEP8mNig8CdGU3Y94lESeL/71iQzii75fWUHuSnY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BYBgYZKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BYBgYZKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B2DC19422;
	Thu, 15 Jan 2026 17:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499181;
	bh=Vek8Cy9b4D0qV4ggQmrPUVrvj63FJCUsz43QWgb+FIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYBgYZKWmXwyzQ+jpjXl9p1HRWt5IYm0MR1THRYmD/KI+2I3+6rEFz3m4UL56sdMZ
	 YIVLe5yuHUiK92eIIz4bkPnuaHMtwCPbXVfNgAgD/qYY1NW1or9gJ5XPrnWj+wE3eL
	 G9W8VxqALJcRDqd3xqsfBBDtvdGDxfMN5FLfcCxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/451] blk-mq: Abort suspend when wakeup events are pending
Date: Thu, 15 Jan 2026 17:45:38 +0100
Message-ID: <20260115164235.875228261@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 21531aa163cb4..a720097460676 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -23,6 +23,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/sched/topology.h>
 #include <linux/sched/signal.h>
+#include <linux/suspend.h>
 #include <linux/delay.h>
 #include <linux/crash_dump.h>
 #include <linux/prefetch.h>
@@ -2548,6 +2549,7 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 {
 	struct blk_mq_hw_ctx *hctx = hlist_entry_safe(node,
 			struct blk_mq_hw_ctx, cpuhp_online);
+	int ret = 0;
 
 	if (!cpumask_test_cpu(cpu, hctx->cpumask) ||
 	    !blk_mq_last_cpu_in_hctx(cpu, hctx))
@@ -2569,12 +2571,24 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
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



