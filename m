Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00965359F99;
	Fri,  9 Jan 2026 12:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960073; cv=none; b=OYvLFhyt3m5Pk0lw16eNZ20F5YdJmRV994bZCqyjMt/aDprbrFlj8r4+6UagNs4MjocX8TbCuTqcXj2snzWnNvpETIRm9767DVrfiLn5AIOixmKGtNER2WZyc/6S1s43FmUjWDYBcxnil4NOFZBXznJtcX5VFfYMOW1z6X4S9qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960073; c=relaxed/simple;
	bh=gPmj0HgKDAJyTw8m6JKCgCdQb2rUzVVmLo96HAq8FbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ny6t0QQy7aV9WRXDR4pRaeZKXWX69rvdQ7NV9t0S83tItGLFRTTo7C5jFM9iaaz1GjsWq+33uk3tdYFNeSAveBth09nFdHJ11/BxtdtzsaKuGZcRmq7V+oZJexbF7ZBXU0Ynvsgoc2dDmjiKhdiYaYUERbLLCPsTnWDISML9JHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnZxBBxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnZxBBxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB61C19422;
	Fri,  9 Jan 2026 12:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960072;
	bh=gPmj0HgKDAJyTw8m6JKCgCdQb2rUzVVmLo96HAq8FbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnZxBBxuw7pjpo5o/lASPgCvfgYIuMSZNuoseRHv1B4DNGPA344k6cu1F0Zxrnl+8
	 H0F+Yzkcq0TrhDayU8avi1/pO75dJSXt6sLO7SX1+oh/G4n1N+58SId8IA7JM8rsu9
	 /RkyV/kJ6njs24zgSuqIJ744rR6bLqUx6muLhQ8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 275/737] blk-mq: Abort suspend when wakeup events are pending
Date: Fri,  9 Jan 2026 12:36:54 +0100
Message-ID: <20260109112144.349311055@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index 5da948b07058b..4895c8a33d392 100644
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
@@ -3548,6 +3549,7 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 {
 	struct blk_mq_hw_ctx *hctx = hlist_entry_safe(node,
 			struct blk_mq_hw_ctx, cpuhp_online);
+	int ret = 0;
 
 	if (!cpumask_test_cpu(cpu, hctx->cpumask) ||
 	    !blk_mq_last_cpu_in_hctx(cpu, hctx))
@@ -3569,12 +3571,24 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
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



