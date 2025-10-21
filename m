Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E712D27587D;
	Tue, 21 Oct 2025 20:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077522; cv=none; b=r1EqQ4ONqetkDuy/B+gSx3VyDhFaW20Laif5yAGxByEzugIyT/47FbI4MWYZKQSYsImzYvrDJcVIDQAGsn1IIcJgyJWL1ycrqpK87V9A3xB/qFeOAoNdr6yUz7xP3YQHDigWnyHFmfYEHbTGwtm3A6TB8UbxGeSHCsIolNveUrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077522; c=relaxed/simple;
	bh=jYM53U8sdsA5Uofovq5AIWDWh/umPhjxzXbb1rWMyF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qPiTMfoj23+n5swkqDi/gFijdGhZaUyTCr+7GCpj1XRTOrCaTbLoIlm6n5PJYWS8cLFBcQ1fstVqIoDHl/jUMUJnhXjmKvh01TCa3iYgaeeZkVpe11wAGGWnngyVRUG59Vpn0dtMs3c+nRsSRdho25TpsHQoKOd7SnyHwe/f30I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pNgLxhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pNgLxhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CDDC4CEF1;
	Tue, 21 Oct 2025 20:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077519;
	bh=jYM53U8sdsA5Uofovq5AIWDWh/umPhjxzXbb1rWMyF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1pNgLxhXSjl3v31O8eeDeobEhgRdrl4M6kzOx3utNSMulu026ZL9523W6DgW7D/0U
	 WowAEIp1leiGWsy55HWWQkB+Eh4DqFnR4q/7778dcwG/2NO6RCmH19IBwb67JnSVqG
	 fKm4Dmmd5mP3TjcoYW1al8DaqCDieLDdm7V9o8pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 129/159] block: Remove elevator_lock usage from blkg_conf frozen operations
Date: Tue, 21 Oct 2025 21:51:46 +0200
Message-ID: <20251021195046.252364262@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 08823e89e3e269bf4c4a20b4c24a8119920cc7a4 ]

Remove the acquisition and release of q->elevator_lock in the
blkg_conf_open_bdev_frozen() and blkg_conf_exit_frozen() functions. The
elevator lock is no longer needed in these code paths since commit
78c271344b6f ("block: move wbt_enable_default() out of queue freezing
from sched ->exit()") which introduces `disk->rqos_state_mutex` for
protecting wbt state change, and not necessary to abuse elevator_lock
for this purpose.

This change helps to solve the lockdep warning reported from Yu Kuai[1].

Pass blktests/throtl with lockdep enabled.

Links: https://lore.kernel.org/linux-block/e5e7ac3f-2063-473a-aafb-4d8d43e5576e@yukuai.org.cn/ [1]
Fixes: commit 78c271344b6f ("block: move wbt_enable_default() out of queue freezing from sched ->exit()")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 7246fc2563152..091e9623bc294 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -812,8 +812,7 @@ int blkg_conf_open_bdev(struct blkg_conf_ctx *ctx)
 }
 /*
  * Similar to blkg_conf_open_bdev, but additionally freezes the queue,
- * acquires q->elevator_lock, and ensures the correct locking order
- * between q->elevator_lock and q->rq_qos_mutex.
+ * ensures the correct locking order between freeze queue and q->rq_qos_mutex.
  *
  * This function returns negative error on failure. On success it returns
  * memflags which must be saved and later passed to blkg_conf_exit_frozen
@@ -834,13 +833,11 @@ unsigned long __must_check blkg_conf_open_bdev_frozen(struct blkg_conf_ctx *ctx)
 	 * At this point, we haven’t started protecting anything related to QoS,
 	 * so we release q->rq_qos_mutex here, which was first acquired in blkg_
 	 * conf_open_bdev. Later, we re-acquire q->rq_qos_mutex after freezing
-	 * the queue and acquiring q->elevator_lock to maintain the correct
-	 * locking order.
+	 * the queue to maintain the correct locking order.
 	 */
 	mutex_unlock(&ctx->bdev->bd_queue->rq_qos_mutex);
 
 	memflags = blk_mq_freeze_queue(ctx->bdev->bd_queue);
-	mutex_lock(&ctx->bdev->bd_queue->elevator_lock);
 	mutex_lock(&ctx->bdev->bd_queue->rq_qos_mutex);
 
 	return memflags;
@@ -1002,9 +999,8 @@ void blkg_conf_exit(struct blkg_conf_ctx *ctx)
 EXPORT_SYMBOL_GPL(blkg_conf_exit);
 
 /*
- * Similar to blkg_conf_exit, but also unfreezes the queue and releases
- * q->elevator_lock. Should be used when blkg_conf_open_bdev_frozen
- * is used to open the bdev.
+ * Similar to blkg_conf_exit, but also unfreezes the queue. Should be used
+ * when blkg_conf_open_bdev_frozen is used to open the bdev.
  */
 void blkg_conf_exit_frozen(struct blkg_conf_ctx *ctx, unsigned long memflags)
 {
@@ -1012,7 +1008,6 @@ void blkg_conf_exit_frozen(struct blkg_conf_ctx *ctx, unsigned long memflags)
 		struct request_queue *q = ctx->bdev->bd_queue;
 
 		blkg_conf_exit(ctx);
-		mutex_unlock(&q->elevator_lock);
 		blk_mq_unfreeze_queue(q, memflags);
 	}
 }
-- 
2.51.0



