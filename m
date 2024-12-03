Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857FC1F8AD4;
	Tue,  3 Dec 2024 15:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240021; cv=none; b=EqXJXAR9z45q9iZWosdaGaezW1ybKoFovBmOTrQo0ajDcJERrbT7GmbHA4tiGjNpmZKD5Gx0QPGWsmoWX7amU362Ytme1HZZtrVnmq6Bnp81U1eeUct1BUCnXSL8Kx2zppR4uJQSRDYgXMchtWVY8ITi7KX5SozSMx82eXI6Fco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240021; c=relaxed/simple;
	bh=onRpMcZy+mDkyZ1n03iCyqcFaNrK8DzZbOa8MpcDO3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3xCVE2pBrVs2kwwufeS/ZCxNQpNJL9mf/x/W5RphHi01lr1oYu3fuw4avZ4EfPtDmloQh4Y0tsqvZJ0sdpVQZaRC4eC/m3HByY7jSt24tRx/BJe/DYqPeFuwroL4PsIpn9gOi+01fe6NYbrgBLDzjXIdjd++7j9hp0Ge2uIp+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ps5J915Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ps5J915Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0234DC4CECF;
	Tue,  3 Dec 2024 15:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240021;
	bh=onRpMcZy+mDkyZ1n03iCyqcFaNrK8DzZbOa8MpcDO3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ps5J915QE+8HvgFWsOP9rS6LZ8JrBqResFR26wON+E3eZL1xPBTd+rf/wlUJDL78q
	 f3Lbd0o3QM1+3wgPFXJRt0eQmAhXtgUFom42x0DDxQEzsvZbDAwtvwdPk7GhrlOq+E
	 2T22wHtxhr5WQz52S88VBt9+HsAAVFH5XFkMjRuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 783/817] blk-mq: add non_owner variant of start_freeze/unfreeze queue APIs
Date: Tue,  3 Dec 2024 15:45:55 +0100
Message-ID: <20241203144026.576555277@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 8acdd0e7bfadda6b5103f2960d293581954454ed ]

Add non_owner variant of start_freeze/unfreeze queue APIs, so that the
caller knows that what they are doing, and we can skip lockdep support
for non_owner variant in per-call level.

Prepare for supporting lockdep for freezing/unfreezing queue.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241025003722.3630252-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 3802f73bd807 ("block: fix uaf for flush rq while iterating tags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c         | 20 ++++++++++++++++++++
 include/linux/blk-mq.h |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f2c7fe2dc7aac..a2c40a97328b6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -196,6 +196,26 @@ void blk_mq_unfreeze_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue);
 
+/*
+ * non_owner variant of blk_freeze_queue_start
+ *
+ * Unlike blk_freeze_queue_start, the queue doesn't need to be unfrozen
+ * by the same task.  This is fragile and should not be used if at all
+ * possible.
+ */
+void blk_freeze_queue_start_non_owner(struct request_queue *q)
+{
+	blk_freeze_queue_start(q);
+}
+EXPORT_SYMBOL_GPL(blk_freeze_queue_start_non_owner);
+
+/* non_owner variant of blk_mq_unfreeze_queue */
+void blk_mq_unfreeze_queue_non_owner(struct request_queue *q)
+{
+	__blk_mq_unfreeze_queue(q, false);
+}
+EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue_non_owner);
+
 /*
  * FIXME: replace the scsi_internal_device_*block_nowait() calls in the
  * mpt3sas driver such that this function can be removed.
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 8d304b1d16b15..a2d27a4d7b6c7 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -928,6 +928,8 @@ void blk_freeze_queue_start(struct request_queue *q);
 void blk_mq_freeze_queue_wait(struct request_queue *q);
 int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
 				     unsigned long timeout);
+void blk_mq_unfreeze_queue_non_owner(struct request_queue *q);
+void blk_freeze_queue_start_non_owner(struct request_queue *q);
 
 void blk_mq_map_queues(struct blk_mq_queue_map *qmap);
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues);
-- 
2.43.0



