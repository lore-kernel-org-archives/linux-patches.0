Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6512C36214C;
	Tue, 16 Dec 2025 12:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888526; cv=none; b=LgbXXHKkwnxHeP7qZQAfZDqIJOvRv00GwONhS3OIjmqn9+eLK7E/wVPso7MKv+jqtWH4TO9JcIKx3CyYxB8snWfOY2Mh/tFv17BI4YQK1SXfbwNjVHw+Q9MjzotNTk8OZdvayNfnGJjd4jvDZTjkEtfyYOQBDa4ZrXuEtDzNRJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888526; c=relaxed/simple;
	bh=BV2xmtabrf586P8PYiOEVUcQvlLfNznoeJg8iPcevWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StweRcEtGbKVroFtsVrv/ZDq7i6zEfxNA5dvcqg9SryqICKtb8nJiZgtl2ZfMQ/STmqDChwynO+aKi4AO5stJK01vBCxqDOHDnL/QBz35op4WQ41mtD18OgcwoELLBJvIoPr48BzhU7h+TretcTe4xg9862i1D87IyA2BSJESB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0OZiXPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0OZiXPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F62C4CEF1;
	Tue, 16 Dec 2025 12:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888526;
	bh=BV2xmtabrf586P8PYiOEVUcQvlLfNznoeJg8iPcevWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0OZiXPUWTfTZmblHk7t+LUHkJAiIIT4FkWTmScIC68j6JUQZj51M7ylaoV4mh4/L
	 wPD5+ai8qzqkqpDHbAreg3HV1pJZ3rx/eAVtBEdhEMwnrKjSAEyDOsaD4Ecx1Sl6hM
	 T3v63WnPRfhBIKNVeg0RGm5X2ciDkG4/pIBWHjyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 559/614] blk-mq: Abort suspend when wakeup events are pending
Date: Tue, 16 Dec 2025 12:15:26 +0100
Message-ID: <20251216111421.634015562@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index d626d32f6e576..33a0062f9e56d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -23,6 +23,7 @@
 #include <linux/cache.h>
 #include <linux/sched/topology.h>
 #include <linux/sched/signal.h>
+#include <linux/suspend.h>
 #include <linux/delay.h>
 #include <linux/crash_dump.h>
 #include <linux/prefetch.h>
@@ -3707,6 +3708,7 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 {
 	struct blk_mq_hw_ctx *hctx = hlist_entry_safe(node,
 			struct blk_mq_hw_ctx, cpuhp_online);
+	int ret = 0;
 
 	if (blk_mq_hctx_has_online_cpu(hctx, cpu))
 		return 0;
@@ -3727,12 +3729,24 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
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
 
 /*
-- 
2.51.0



