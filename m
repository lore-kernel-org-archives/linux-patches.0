Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D9B13AE7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8D2C433C8;
	Mon, 26 Jun 2023 18:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804206;
	bh=XkCv8m+SwglEKpH2hgINfBZTfuigdB5mMl/5EvINsKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsVu8bTXSQbKP3ecYJVt1pGD833vJw3z4adETwpzdOW6tzQa6q9ghq8ScYJ+h0idy
	 gYWm+oe0tnHx5hXpouxYsyNkEipqgchRSyuEse6oLps6JTzX+tgZx+kOVX3kIHLXWm
	 sagj09emDjHXR188zHl0xumtxQRDX1hOxPuwwzdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Querijn Voet <querijnqyn@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 076/170] io_uring/poll: serialize poll linked timer start with poll removal
Date: Mon, 26 Jun 2023 20:10:45 +0200
Message-ID: <20230626180804.026649747@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

Commit ef7dfac51d8ed961b742218f526bd589f3900a59 upstream.

We selectively grab the ctx->uring_lock for poll update/removal, but
we really should grab it from the start to fully synchronize with
linked timeouts. Normally this is indeed the case, but if requests
are forced async by the application, we don't fully cover removal
and timer disarm within the uring_lock.

Make this simpler by having consistent locking state for poll removal.

Cc: stable@vger.kernel.org # 6.1+
Reported-by: Querijn Voet <querijnqyn@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -993,8 +993,9 @@ int io_poll_remove(struct io_kiocb *req,
 	struct io_hash_bucket *bucket;
 	struct io_kiocb *preq;
 	int ret2, ret = 0;
-	bool locked;
+	bool locked = true;
 
+	io_ring_submit_lock(ctx, issue_flags);
 	preq = io_poll_find(ctx, true, &cd, &ctx->cancel_table, &bucket);
 	ret2 = io_poll_disarm(preq);
 	if (bucket)
@@ -1006,12 +1007,10 @@ int io_poll_remove(struct io_kiocb *req,
 		goto out;
 	}
 
-	io_ring_submit_lock(ctx, issue_flags);
 	preq = io_poll_find(ctx, true, &cd, &ctx->cancel_table_locked, &bucket);
 	ret2 = io_poll_disarm(preq);
 	if (bucket)
 		spin_unlock(&bucket->lock);
-	io_ring_submit_unlock(ctx, issue_flags);
 	if (ret2) {
 		ret = ret2;
 		goto out;
@@ -1035,7 +1034,7 @@ found:
 		if (poll_update->update_user_data)
 			preq->cqe.user_data = poll_update->new_user_data;
 
-		ret2 = io_poll_add(preq, issue_flags);
+		ret2 = io_poll_add(preq, issue_flags & ~IO_URING_F_UNLOCKED);
 		/* successfully updated, don't complete poll request */
 		if (!ret2 || ret2 == -EIOCBQUEUED)
 			goto out;
@@ -1043,9 +1042,9 @@ found:
 
 	req_set_fail(preq);
 	io_req_set_res(preq, -ECANCELED, 0);
-	locked = !(issue_flags & IO_URING_F_UNLOCKED);
 	io_req_task_complete(preq, &locked);
 out:
+	io_ring_submit_unlock(ctx, issue_flags);
 	if (ret < 0) {
 		req_set_fail(req);
 		return ret;


