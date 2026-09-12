Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145BD2D0C94;
	Sat, 12 Sep 2026 11:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212774; cv=none; b=SsHlhOe9B3ni9m8Bf+XLfvao8xJ4fnd37GxKrxyGgqh7hjf7FPucBuntlQOeGPEQLZa6fmsAnvXiRPFhCLy5JC9Tmfi0KKLmaDxt5ungypflQ9isVdeIGRlmxs3gOtVD3oYBG8b8I59DMMhH0ioRL5RecWuLGWbpyTDF3JE7X/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212774; c=relaxed/simple;
	bh=+BbHapoSuX4/TAxuSIKC9TCsCPp1n5KzJEQ0jJJr6So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOFlqmsLUzuu06sTxjMzRaLVocNhRVDT+xJT8o0TUiKEz4m8NWnCzMQT+12VnC3skX5b5l5KDW76/77EC6Z/fTNMXXBF17xaI+pc2r9T8ALP5fevUkCwcAGmZWZmuKo0xLm5m9sQJfbnNTrQvQ2rqWdcWxM8+KpIZLM1ApoEsO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCBHm6CQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCBHm6CQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13001F000FF;
	Sat, 12 Sep 2026 11:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212773;
	bh=lw08+do9hquy8a19Qny7zNspZqaAHHi8TBkTJv9+e2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCBHm6CQ6bMFeplpHiSwM/8pYVvUf6CeAxzTJrBbrYpVuouoD8atXxca9+ylmIKnU
	 Z+5P5THZqFWXJcVbZ/sHI20d/UfK+TSD5oub/rov48auhvrxgr3eBvkt9qBYbmsjOm
	 EpAIFZcnB2vObcbz1h2a/BH6fsCaKzMJNrpsfgEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1504/1518] io_uring/waitid: use io_waitid_remove_wq() consistently
Date: Sat, 12 Sep 2026 09:01:13 +0200
Message-ID: <20260912065657.588169135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit ab673c1bcaf20ac70352eeb6bf5b828462676693 ]

Use it everywhere that the wait_queue_entry is removed from the head,
and be a bit more cautious in zeroing out iw->head whenever the entry is
removed from the list.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b994ace83a2b ("io_uring/waitid: fix KCSAN warning on io_waitid->head")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/waitid.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 41d5eed6c5723..1137e3a166d12 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -193,18 +193,18 @@ bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 static inline bool io_waitid_drop_issue_ref(struct io_kiocb *req)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
-	struct io_waitid_async *iwa = req->async_data;
 
 	if (!atomic_sub_return(1, &iw->refs))
 		return false;
 
+	io_waitid_remove_wq(req);
+
 	/*
 	 * Wakeup triggered, racing with us. It was prevented from
 	 * completing because of that, queue up the tw to do that.
 	 */
 	req->io_task_work.func = io_waitid_cb;
 	io_req_task_work_add(req);
-	remove_wait_queue(iw->head, &iwa->wo.child_wait);
 	return true;
 }
 
@@ -265,6 +265,7 @@ static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
 		return 0;
 
 	list_del_init(&wait->entry);
+	iw->head = NULL;
 
 	/* cancel is in progress */
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
@@ -291,6 +292,7 @@ int io_waitid_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	iw->which = READ_ONCE(sqe->len);
 	iw->upid = READ_ONCE(sqe->fd);
 	iw->options = READ_ONCE(sqe->file_index);
+	iw->head = NULL;
 	iw->infop = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	memset(&iw->info, 0, sizeof(iw->info));
 	return 0;
@@ -322,11 +324,16 @@ int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
 	 * callback.
 	 */
 	io_ring_submit_lock(ctx, issue_flags);
+
+	/*
+	 * iw->head is valid under the ring lock, and as long as the request
+	 * is on the waitid_list where cancelations may find it.
+	 */
+	iw->head = &current->signal->wait_chldexit;
 	hlist_add_head(&req->hash_node, &ctx->waitid_list);
 
 	init_waitqueue_func_entry(&iwa->wo.child_wait, io_waitid_wait);
 	iwa->wo.child_wait.private = req->tctx->task;
-	iw->head = &current->signal->wait_chldexit;
 	add_wait_queue(iw->head, &iwa->wo.child_wait);
 
 	ret = __do_wait(&iwa->wo);
@@ -349,7 +356,7 @@ int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	hlist_del_init(&req->hash_node);
-	remove_wait_queue(iw->head, &iwa->wo.child_wait);
+	io_waitid_remove_wq(req);
 	ret = io_waitid_finish(req, ret);
 
 	io_ring_submit_unlock(ctx, issue_flags);
-- 
2.53.0



