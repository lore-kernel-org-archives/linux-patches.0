Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13E713AD2
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312F7C433CA;
	Mon, 26 Jun 2023 18:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803625;
	bh=gPolrfdBPnL3mLsoNRkQ39dUXLqo9Hm6fob8gOjGjo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUDiGMI0m23kCpS81gEwhd0ahrHTfkRjGOsDJ2jpCuRun1nr/p3xG77b0u/FumN3v
	 0REsC2PIMklgWrF9w8KCSuBEmiEvxLB8qM+0Ubi1/ynDJWVNsgyziwL2QKEiGg7yYO
	 OQctcC21v09EwJupQmojBtKnBapEc9S5+Vj9yNVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Querijn Voet <querijnqyn@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.3 097/199] io_uring/poll: serialize poll linked timer start with poll removal
Date: Mon, 26 Jun 2023 20:10:03 +0200
Message-ID: <20230626180809.884844269@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
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
@@ -977,8 +977,9 @@ int io_poll_remove(struct io_kiocb *req,
 	struct io_hash_bucket *bucket;
 	struct io_kiocb *preq;
 	int ret2, ret = 0;
-	bool locked;
+	bool locked = true;
 
+	io_ring_submit_lock(ctx, issue_flags);
 	preq = io_poll_find(ctx, true, &cd, &ctx->cancel_table, &bucket);
 	ret2 = io_poll_disarm(preq);
 	if (bucket)
@@ -990,12 +991,10 @@ int io_poll_remove(struct io_kiocb *req,
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
@@ -1019,7 +1018,7 @@ found:
 		if (poll_update->update_user_data)
 			preq->cqe.user_data = poll_update->new_user_data;
 
-		ret2 = io_poll_add(preq, issue_flags);
+		ret2 = io_poll_add(preq, issue_flags & ~IO_URING_F_UNLOCKED);
 		/* successfully updated, don't complete poll request */
 		if (!ret2 || ret2 == -EIOCBQUEUED)
 			goto out;
@@ -1027,9 +1026,9 @@ found:
 
 	req_set_fail(preq);
 	io_req_set_res(preq, -ECANCELED, 0);
-	locked = !(issue_flags & IO_URING_F_UNLOCKED);
 	io_req_task_complete(preq, &locked);
 out:
+	io_ring_submit_unlock(ctx, issue_flags);
 	if (ret < 0) {
 		req_set_fail(req);
 		return ret;


