Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3DD1E5020;
	Mon, 21 Oct 2024 10:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506572; cv=none; b=qzuTerctn6kRhl/wLSkeOFApvVh8g5nPRJVtTy3VSsDTd0GIFyrJMY8tdZUiQQFSFt3iRA0HJUCqNPufRGB31v8hs1epa3R0Y0PpW75HlHEhKNRIcdN4tmrxSHRQRoy8f+NnH5rAW5wY2A1Js0qIWTRqEzwSHdUiynBzIHiWLb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506572; c=relaxed/simple;
	bh=M8O4PdmL7N6K2gt8uJbYNy/EvDPjH/3lG+LXO4iKtFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5vZjcxg+pyMnv32xwPEL7FGPemaFuLwST5RtutdjJSbt1vOcMOOGehSPTtJAPVrv24+TAQ6Vg+UCvkXH76l9DegjHjQIXpcjsoOv0WCdaP2rbo6Qh5WAl8/d6TUZLLBcegVJ2epNLuEJm3sI/EIulSy6VRvrfBWdMsNbDkzqc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBT3EK79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBT3EK79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A91DC4CEC3;
	Mon, 21 Oct 2024 10:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506572;
	bh=M8O4PdmL7N6K2gt8uJbYNy/EvDPjH/3lG+LXO4iKtFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBT3EK79NU3nQliz1n4KJRo+2rOf6tDbof6Vi8WrUQhcFOJpwMbIt/5FfUvJaPiYr
	 yefclcp4ilZt3bStDJviYXsKlJv+0cqJmx0LCi/GBpWARKGmGI2ZRs+NY4WmKx2Ama
	 zxxZy8x4iYY4AbpFRjq4qGzAOhYQJy/HzDBE4a6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Rick Koch <mr.rickkoch@gmail.com>
Subject: [PATCH 6.11 050/135] blk-mq: setup queue ->tag_set before initializing hctx
Date: Mon, 21 Oct 2024 12:23:26 +0200
Message-ID: <20241021102301.289839871@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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
@@ -4307,6 +4307,12 @@ int blk_mq_init_allocated_queue(struct b
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
 
@@ -4325,8 +4331,6 @@ int blk_mq_init_allocated_queue(struct b
 	INIT_WORK(&q->timeout_work, blk_mq_timeout_work);
 	blk_queue_rq_timeout(q, set->timeout ? set->timeout : 30 * HZ);
 
-	q->tag_set = set;
-
 	q->queue_flags |= QUEUE_FLAG_MQ_DEFAULT;
 
 	INIT_DELAYED_WORK(&q->requeue_work, blk_mq_requeue_work);


