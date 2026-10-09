Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2ED4E2F1F;
	Fri,  9 Oct 2026 14:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555589; cv=none; b=Q+/RuaFKApdSeRPTgRaFLFuAN2mS1hoLWlKViskgE+h+i/8vgR28Y2ghu7lxz4K5zVOWA2HWrAQdLs3rftpT3BACnzCSnPju1UOtaauDXIKRMQHtoPvDUU6mkffZLpiQsqngo45dNxKe0UBuD12UQx6v+6rn1UN0FHoBAiRroW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555589; c=relaxed/simple;
	bh=bsLyi4A2BD9KqLe2qQ0aivGUWcedr7xBpcdKZIF/UpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UV7+H9s5x3pWygZ6yz2i6llCnb/LWjofRLfuBQ0wscKHXjxU3dAmJ2zArwpOt5VHCjh4VIDmlHpVQYYislQUpMdXFe9O9a6tcAZy3QlD7pwcmoJiNQceF4+BJtiFLzrAFF3pdC9OEsX1fjVtZ6bYUT511OCToM+flyKTiDT865I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7UUMOtE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7UUMOtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF601F00893;
	Fri,  9 Oct 2026 14:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555585;
	bh=1vL/pSeAx3PUBZs7xjpa2mo09tMYtqRS8gwgo4NGjFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d7UUMOtEBUubvxRvdElfVH411lQ7X4wm4ByUE97RmSgMRXUVP4uOVKHZqMlOeBFQR
	 rEVFD0eW3qVkS02k/A4u07+SHPTUgWiI6y522wfCHdq0we5jg4BiNpJ7tl1q4rpfTm
	 2tiNquu2RKvaQU3zd1BRzjTQsh0VNcjJuljgMRs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 083/403] blk-mq: factor out a helper blk_mq_limit_depth()
Date: Fri,  9 Oct 2026 16:07:24 +0200
Message-ID: <20261009140954.033766980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit cf02d7d41b064af3e2c3a3a1ea9042a5b565b0d8 ]

There are no functional changes, just make code cleaner.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: ab6c756f28c7 ("blk-mq: set RQF_USE_SCHED when the operation is known")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 62 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 25 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e050ea631cdac..d9a7e04ad1794 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -493,6 +493,42 @@ __blk_mq_alloc_requests_batch(struct blk_mq_alloc_data *data)
 	return rq_list_pop(data->cached_rqs);
 }
 
+static void blk_mq_limit_depth(struct blk_mq_alloc_data *data)
+{
+	struct elevator_mq_ops *ops;
+
+	/* If no I/O scheduler has been configured, don't limit requests */
+	if (!data->q->elevator) {
+		blk_mq_tag_busy(data->hctx);
+		return;
+	}
+
+	/*
+	 * All requests use scheduler tags when an I/O scheduler is
+	 * enabled for the queue.
+	 */
+	data->rq_flags |= RQF_SCHED_TAGS;
+
+	/*
+	 * Flush/passthrough requests are special and go directly to the
+	 * dispatch list, they are not subject to the async_depth limit.
+	 */
+	if ((data->cmd_flags & REQ_OP_MASK) == REQ_OP_FLUSH ||
+	    blk_op_is_passthrough(data->cmd_flags))
+		return;
+
+	WARN_ON_ONCE(data->flags & BLK_MQ_REQ_RESERVED);
+	data->rq_flags |= RQF_USE_SCHED;
+
+	/*
+	 * By default, sync requests have no limit, and async requests are
+	 * limited to async_depth.
+	 */
+	ops = &data->q->elevator->type->ops;
+	if (ops->limit_depth)
+		ops->limit_depth(data->cmd_flags, data);
+}
+
 static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
 {
 	struct request_queue *q = data->q;
@@ -511,31 +547,7 @@ static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
 	data->ctx = blk_mq_get_ctx(q);
 	data->hctx = blk_mq_map_queue(data->cmd_flags, data->ctx);
 
-	if (q->elevator) {
-		/*
-		 * All requests use scheduler tags when an I/O scheduler is
-		 * enabled for the queue.
-		 */
-		data->rq_flags |= RQF_SCHED_TAGS;
-
-		/*
-		 * Flush/passthrough requests are special and go directly to the
-		 * dispatch list.
-		 */
-		if ((data->cmd_flags & REQ_OP_MASK) != REQ_OP_FLUSH &&
-		    !blk_op_is_passthrough(data->cmd_flags)) {
-			struct elevator_mq_ops *ops = &q->elevator->type->ops;
-
-			WARN_ON_ONCE(data->flags & BLK_MQ_REQ_RESERVED);
-
-			data->rq_flags |= RQF_USE_SCHED;
-			if (ops->limit_depth)
-				ops->limit_depth(data->cmd_flags, data);
-		}
-	} else {
-		blk_mq_tag_busy(data->hctx);
-	}
-
+	blk_mq_limit_depth(data);
 	if (data->flags & BLK_MQ_REQ_RESERVED)
 		data->rq_flags |= RQF_RESV;
 
-- 
2.53.0



