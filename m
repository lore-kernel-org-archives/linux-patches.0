Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB51B3126C5;
	Mon, 13 Oct 2025 15:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369198; cv=none; b=I69/1MFN+43jy+x+H0zmOCjLgJOtu2xn7NEdGQEakkS2TmMPziHA+qWX3TK5GBTvwQwdG3HnquhlVqsjX3yS5EU/am/CMtdTvqtLvv4rO5YgHolIgX+z5Q94Dwcy6y1wgRHnNU//lqA4FbV1Fg4FYLkz4CGedxPz9FFIdZiG2HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369198; c=relaxed/simple;
	bh=8ayDkpx1GsifngGwHK+jFZAyLaoEuIC8OresiwSKnLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xm8bpxO1qZloGxB4d6lHHX5FzuoSHOWVANS0d5RUggTEnP4G87lmyX6S0OpGKDMsu/YEMGUpfecgsYUDvrhttnHJCOT5/LqoQl3bEV84ELQRwRBVy4mtae/E2DLlx1HFPAQl815+tjB1YknDnJ67ywlxmg4mcWPe0xBzzP4sSDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcTxdh9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcTxdh9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D1EC16AAE;
	Mon, 13 Oct 2025 15:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369198;
	bh=8ayDkpx1GsifngGwHK+jFZAyLaoEuIC8OresiwSKnLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcTxdh9U9EaXnRYGCOcUPUUr1M1yWXmJMRHAmhBXYhdqXnLOgyjkJgGSJMHpffCkM
	 GyR0gBHd92OxzhUcboRbJxt+yeP0MKpTeeblIdpYeq8VrB5B+pGMPL7Xqd5xOtZHbq
	 Ep81cQ2sJ/N2fhVdgBMY//27lbpeX3LqIp7qV6tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 129/563] blk-mq: split bitmap grow and resize case in blk_mq_update_nr_requests()
Date: Mon, 13 Oct 2025 16:39:50 +0200
Message-ID: <20251013144415.967685628@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit e63200404477456ec60c62dd8b3b1092aba2e211 ]

No functional changes are intended, make code cleaner and prepare to fix
the grow case in following patches.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b86433721f46 ("blk-mq: fix potential deadlock while nr_requests grown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index bcb7495893a09..1bafbdced7bd5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4935,25 +4935,40 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 	blk_mq_quiesce_queue(q);
 
 	if (blk_mq_is_shared_tags(set->flags)) {
+		/*
+		 * Shared tags, for sched tags, we allocate max initially hence
+		 * tags can't grow, see blk_mq_alloc_sched_tags().
+		 */
 		if (q->elevator)
 			blk_mq_tag_update_sched_shared_tags(q);
 		else
 			blk_mq_tag_resize_shared_tags(set, nr);
-	} else {
+	} else if (!q->elevator) {
+		/*
+		 * Non-shared hardware tags, nr is already checked from
+		 * queue_requests_store() and tags can't grow.
+		 */
 		queue_for_each_hw_ctx(q, hctx, i) {
 			if (!hctx->tags)
 				continue;
-			/*
-			 * If we're using an MQ scheduler, just update the
-			 * scheduler queue depth. This is similar to what the
-			 * old code would do.
-			 */
-			if (hctx->sched_tags)
-				ret = blk_mq_tag_update_depth(hctx,
-							&hctx->sched_tags, nr);
-			else
-				ret = blk_mq_tag_update_depth(hctx,
-							&hctx->tags, nr);
+			sbitmap_queue_resize(&hctx->tags->bitmap_tags,
+				nr - hctx->tags->nr_reserved_tags);
+		}
+	} else if (nr <= q->elevator->et->nr_requests) {
+		/* Non-shared sched tags, and tags don't grow. */
+		queue_for_each_hw_ctx(q, hctx, i) {
+			if (!hctx->sched_tags)
+				continue;
+			sbitmap_queue_resize(&hctx->sched_tags->bitmap_tags,
+				nr - hctx->sched_tags->nr_reserved_tags);
+		}
+	} else {
+		/* Non-shared sched tags, and tags grow */
+		queue_for_each_hw_ctx(q, hctx, i) {
+			if (!hctx->sched_tags)
+				continue;
+			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
+						      nr);
 			if (ret)
 				goto out;
 		}
-- 
2.51.0



