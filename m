Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D1F311C20;
	Mon, 13 Oct 2025 15:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369195; cv=none; b=LosLA6N2qt6i1qt9wq1lR0sncSCEYY3EF5ocomf0ndszCUhp+qysHJqgGHy8R0ItgPWQYehT7HcGYMXlHLrFvK8DTlSvI2xLPW9cejhzkNs/SgnyoQxXKpgm2259OWPm7Mf6eisMfRrq6G/6tWuTGLhAze/yXoZhuim52RM3QSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369195; c=relaxed/simple;
	bh=UJDip82Sj9PmZd7ejpS8KwfYWPtZ/A+12lUeDpDSfpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bel5uKME0obs7s1v7OwXeUZGwajnXPvtz/9qv0ZDZ1LeDvgCNN3YaxhFOaS7F9NN5Z2a25t0JitSuc12xG7EE6K0RZGYwYOJZ19z2BSKo9TzRcRaw69GUArArCsrAMtdX+Qn/Mt35lZJUNpb5RzCgCCf4QEibNszgOI9l5rMS7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtQ9iY7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtQ9iY7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F74C116C6;
	Mon, 13 Oct 2025 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369195;
	bh=UJDip82Sj9PmZd7ejpS8KwfYWPtZ/A+12lUeDpDSfpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtQ9iY7h/VDsrxdaIT4AWJeYvK3pl3CYh8fBu5exllrX5r+j+XlSeIeCrsrRfvk93
	 p929b+CEl03xPSUUKamJoMHRpee5ORtWW7rItsARVWJvpQXHVE/UHYVrVxT7IpBovh
	 1rXV92IwNz70lXasR2Df7Xt/mI/AsnNJBFNBZQeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 128/563] blk-mq: cleanup shared tags case in blk_mq_update_nr_requests()
Date: Mon, 13 Oct 2025 16:39:49 +0200
Message-ID: <20251013144415.931894826@linuxfoundation.org>
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

[ Upstream commit 7f2799c546dba9e12f9ff4d07936601e416c640d ]

For shared tags case, all hctx->sched_tags/tags are the same, it doesn't
make sense to call into blk_mq_tag_update_depth() multiple times for the
same tags.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b86433721f46 ("blk-mq: fix potential deadlock while nr_requests grown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-tag.c |  7 -------
 block/blk-mq.c     | 43 ++++++++++++++++++++++---------------------
 2 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 725210f27471c..aed84c5d5c2b2 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -596,13 +596,6 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
 		struct blk_mq_tag_set *set = hctx->queue->tag_set;
 		struct blk_mq_tags *new;
 
-		/*
-		 * Only the sbitmap needs resizing since we allocated the max
-		 * initially.
-		 */
-		if (blk_mq_is_shared_tags(set->flags))
-			return 0;
-
 		new = blk_mq_alloc_map_and_rqs(set, hctx->queue_num, tdepth);
 		if (!new)
 			return -ENOMEM;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a81ef562014d6..bcb7495893a09 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4934,34 +4934,35 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 
 	blk_mq_quiesce_queue(q);
 
-	queue_for_each_hw_ctx(q, hctx, i) {
-		if (!hctx->tags)
-			continue;
-		/*
-		 * If we're using an MQ scheduler, just update the scheduler
-		 * queue depth. This is similar to what the old code would do.
-		 */
-		if (hctx->sched_tags) {
-			ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
-						      nr);
-		} else {
-			ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr);
-		}
-		if (ret)
-			goto out;
-	}
-
-	q->nr_requests = nr;
-	if (q->elevator && q->elevator->type->ops.depth_updated)
-		q->elevator->type->ops.depth_updated(q);
-
 	if (blk_mq_is_shared_tags(set->flags)) {
 		if (q->elevator)
 			blk_mq_tag_update_sched_shared_tags(q);
 		else
 			blk_mq_tag_resize_shared_tags(set, nr);
+	} else {
+		queue_for_each_hw_ctx(q, hctx, i) {
+			if (!hctx->tags)
+				continue;
+			/*
+			 * If we're using an MQ scheduler, just update the
+			 * scheduler queue depth. This is similar to what the
+			 * old code would do.
+			 */
+			if (hctx->sched_tags)
+				ret = blk_mq_tag_update_depth(hctx,
+							&hctx->sched_tags, nr);
+			else
+				ret = blk_mq_tag_update_depth(hctx,
+							&hctx->tags, nr);
+			if (ret)
+				goto out;
+		}
 	}
 
+	q->nr_requests = nr;
+	if (q->elevator && q->elevator->type->ops.depth_updated)
+		q->elevator->type->ops.depth_updated(q);
+
 out:
 	blk_mq_unquiesce_queue(q);
 
-- 
2.51.0



