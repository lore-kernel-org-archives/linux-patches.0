Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBC92737EE;
	Fri,  9 Jan 2026 12:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961386; cv=none; b=e65cGHOzzWUBEIZubpVVaoNTV5Kc5dOA937Z5JZVqxfxc+LBLUeuSkDe4PR9bhdVuTAmPMQzlzk+tg2yOiH7cA37WUrJvQnplC3vShTgMnykEf+ZyZS5jrq2xBLLXsZXx+zuFu+gMsUsa5OGBMBXeNPfFcvYQBhLB01BsDH0JwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961386; c=relaxed/simple;
	bh=OUrDelyIiGkrQava8XMS+aNdDv+ukQczoBPhBwwDaA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkWpi2nT5I7qKgylQbchiSYP6p1HHQmVEG0lHzBSEu5zH9d2kpqlNA9LBdVX+N3c0OvoC7IgKgRR+x1bRttJce3vi5J+rM4Qm+WYa6H9onJMmYzPg8aua68JopDs2Lm/gtVLmTtNbivapqzHOAgjaUMEzKtWmnJpfetSxPfIeDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oY8s3QFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oY8s3QFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DE6C4CEF1;
	Fri,  9 Jan 2026 12:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961386;
	bh=OUrDelyIiGkrQava8XMS+aNdDv+ukQczoBPhBwwDaA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oY8s3QFwGuLMiGZATM6wRb6t4uOgjvibSuiDbGdW2bULXAAmuYPSVfGxaHooq9pmq
	 5sESfUm4YWKB+QKrPGdI7/airXzNd0KID9weEJB9KSijfoSj+1F9EVFOnBLQOs2cOt
	 UuMrjriBEBuxveHtBHtMyU3LIrUDSlwbufVANC9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Rick Koch <mr.rickkoch@gmail.com>
Subject: [PATCH 6.6 734/737] blk-mq: setup queue ->tag_set before initializing hctx
Date: Fri,  9 Jan 2026 12:44:33 +0100
Message-ID: <20260109112201.718575279@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

commit c25c0c9035bb8b28c844dfddeda7b8bdbcfcae95 upstream.

Commit 7b815817aa58 ("blk-mq: add helper for checking if one CPU is mapped to specified hctx")
needs to check queue mapping via tag set in hctx's cpuhp handler.

However, q->tag_set may not be setup yet when the cpuhp handler is
enabled, then kernel oops is triggered.

Fix the issue by setup queue tag_set before initializing hctx.

Cc: stable@vger.kernel.org
Reported-and-tested-by: Rick Koch <mr.rickkoch@gmail.com>
Closes: https://lore.kernel.org/linux-block/CANa58eeNDozLaBHKPLxSAhEy__FPfJT_F71W=sEQw49UCrC9PQ@mail.gmail.com
Fixes: 7b815817aa58 ("blk-mq: add helper for checking if one CPU is mapped to specified hctx")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241014005115.2699642-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4453,6 +4453,12 @@ int blk_mq_init_allocated_queue(struct b
 	/* mark the queue as mq asap */
 	q->mq_ops = set->ops;
 
+	/*
+	 * ->tag_set has to be setup before initialize hctx, which cpuphp
+	 * handler needs it for checking queue mapping
+	 */
+	q->tag_set = set;
+
 	if (blk_mq_alloc_ctxs(q))
 		goto err_exit;
 
@@ -4471,8 +4477,6 @@ int blk_mq_init_allocated_queue(struct b
 	INIT_WORK(&q->timeout_work, blk_mq_timeout_work);
 	blk_queue_rq_timeout(q, set->timeout ? set->timeout : 30 * HZ);
 
-	q->tag_set = set;
-
 	q->queue_flags |= QUEUE_FLAG_MQ_DEFAULT;
 	blk_mq_update_poll_flag(q);
 


