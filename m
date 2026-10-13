Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C09E3B6356;
	Tue, 13 Oct 2026 12:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896094; cv=none; b=bAhaTV3XoCaCl2lFjoxOea5Vn3Gsa7DEZU5bg9AJ9q5gjLyERDX4zjxfCK+aIERQj72SpJ6DdWsMejdD1Xu4RmkijQL/Cw7fH+X790mHiCVmLgBKP23xI/Akd16AF53y3TQBe8Uvty2MpaOFtMfyc3bbFuR8yKWMkNc/vQMSf7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896094; c=relaxed/simple;
	bh=P9wOVHU44Fkh/sQt6lke28/YhHh6OXssN/8I24N7w/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITKUVCg3dPmvbUyYO1q9JNz6D898Q0zg/kNyBdmpefJdU/mI0pCg7gt2pjEq/pKE+1i88BFvR1vgofVdVn87rUATXsBH3I7QuGAX65370bIoBuKGVtzs/Mydm1GpeqUMH3X4w2ggtTy2d5GwEb8a2oopw64++7CkIXpKzJ72bm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FS4U0F1o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FS4U0F1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C721F00893;
	Tue, 13 Oct 2026 12:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896093;
	bh=E6uk8IpSjbqH7VXrKcPfOpAsYPjKwJwx1kPVH74ZVo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FS4U0F1oGMgvkA4pLbKKF3nSRwSKOCp2thdrqQsMHdPFmmMOrOei+BlqIwIeUvpWO
	 NMq1AJ0XgSTknqVzGbMKxjCWYag7jJQpInfBp/f5+Hn8M1dUOBknln8BKcuJ/yVxFS
	 gQ4g0wdJ/mBe05V2d0aG4R2kjxUBA97MiElUyb1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 494/497] io_uring/waitid: use io_waitid_remove_wq() consistently
Date: Tue, 13 Oct 2026 13:41:01 +0200
Message-ID: <20261013112919.602411932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit ab673c1bcaf20ac70352eeb6bf5b828462676693 upstream.

Use it everywhere that the wait_queue_entry is removed from the head,
and be a bit more cautious in zeroing out iw->head whenever the entry is
removed from the list.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/waitid.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -225,18 +225,18 @@ bool io_waitid_remove_all(struct io_ring
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
 
@@ -291,6 +291,7 @@ static int io_waitid_wait(struct wait_qu
 		return 0;
 
 	list_del_init(&wait->entry);
+	iw->head = NULL;
 
 	/* cancel is in progress */
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
@@ -311,6 +312,7 @@ int io_waitid_prep(struct io_kiocb *req,
 	iw->which = READ_ONCE(sqe->len);
 	iw->upid = READ_ONCE(sqe->fd);
 	iw->options = READ_ONCE(sqe->file_index);
+	iw->head = NULL;
 	iw->infop = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	memset(&iw->info, 0, sizeof(iw->info));
 	return 0;
@@ -348,11 +350,16 @@ int io_waitid(struct io_kiocb *req, unsi
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
 	iwa->wo.child_wait.private = req->task;
-	iw->head = &current->signal->wait_chldexit;
 	add_wait_queue(iw->head, &iwa->wo.child_wait);
 
 	ret = __do_wait(&iwa->wo);
@@ -375,7 +382,7 @@ int io_waitid(struct io_kiocb *req, unsi
 	}
 
 	hlist_del_init(&req->hash_node);
-	remove_wait_queue(iw->head, &iwa->wo.child_wait);
+	io_waitid_remove_wq(req);
 	ret = io_waitid_finish(req, ret);
 
 	io_ring_submit_unlock(ctx, issue_flags);


