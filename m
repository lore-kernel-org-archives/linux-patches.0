Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829231;
	b=TEMN2Fkk9XFRv8CLQ/bLGEeQvm6b/cKp8yFlkMWsIqBAwWkm2SN6t14k/PJLIYTQYKsJ
	 yVVO8ZCKP3VDd1dy38J7GkLJiA7ub7Ufi/uCKGUwj0kDVOsSCWQq+wSUfuW/2+uKE08yM
	 x1rWEupozYDJkSDUpqnHHxce8Xd7InubZqIzpmx6yimA19XgvGv4SMoVzAg85taqqFHQO
	 nA+VmT6z0ojAmWP4TtCub5bCPqxDuEypYt8FpMbq567DKN1G9crR1PxMwXCpbc5KzZo8W
	 ogmw+zp/zE9gw0Rb5g5+H0PEQDVu/9l4qWaO7hzYft6R1bguW35BMu8JjE/bZRilGsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rw6WvSefj4sRWjEWr3EvvxIzeqIZrtvDwXhVzCGrnMM=;
	b=nUSRtFGnWSmP/XMbhvc/PuI534yfsLeBMaoxtR5k/xTmJf5urdCOajyGfoDeSnj0/uz5
	 PRcN5jGCsIlXjM5Pg2viYwoQERE7Tu7U77pFpHV8jO6i/SGmthh7NVXX7d6B0JL5ChQLY
	 rt6Zuuqzg5FVEZg9MWo2PH2E6cDmJUyN9YS79YdlciVymyCZrHR6AxSBjMoC75KE3KI7d
	 oBWHjsWo6lFr4GUvzx/Qf4e+mkHZQ9TFCwkkRjfomBjw0JzqoEi/uPh/pisClpBiNy3UM
	 dCYO4Pk2HLHGJOtfxVqDXUxOhCb9AmyY6wV72mLJvohMOMtTIJNBJYYeAD4OotpHbuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MDHjhMN2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBF060A2637;
	Wed,  4 Nov 2026 21:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MDHjhMN2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684161F00A02;
	Wed,  4 Nov 2026 21:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829230;
	bh=Rw6WvSefj4sRWjEWr3EvvxIzeqIZrtvDwXhVzCGrnMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MDHjhMN2MwX9eHRByNGA8pDGBZ3l5jrqGjNv/E9GPBl+MrsPxtnBTZhhwKcaYq1Sl
	 /hBaDcJSehjxOz+mFzo9tbvNOuQiY4mXeO36FDwDl6gaE4nL6rHtz+IZh6NOr/q48T
	 MGtIv2O5FMHbifyNVubL5KIkXCuQQ8uVWFE3569g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 531/547] io_uring: defer foreign io-wq enqueues to task_work
Date: Wed,  4 Nov 2026 16:11:55 -0500
Message-ID: <20261104211053.479893530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

Commit 3de16279b43dc285ed2222aba06cebdc82fdb28b upstream.

An IOPOLL ring without DEFER_TASKRUN can be reaped by a task other than
the one that submitted the I/O. If a polled request is marked
REQ_F_REISSUE, io_free_batch_list() calls io_queue_iowq() with the
original tctx. Ordinary task exit can tear down tctx->io_wq after
draining only the tracked requests. The live request pins the task, but
not its io-wq, so the foreign task can race io_wq_put_and_exit() and
enqueue through a freed or NULL queue.

Forward foreign userspace enqueues to the owning task before accessing
tctx->io_wq. Use a dedicated task_work callback so reissues still go
straight to io-wq, and fail them if task_work is running in cancellation
mode. Preserve the existing PF_KTHREAD cancellation path. This also
covers the other callers of io_queue_iowq() without changing the
worker-owned enqueue path.

Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -423,6 +423,17 @@ static __always_inline bool io_assign_fi
 	return !!req->file;
 }
 
+static void io_req_queue_iowq_tw(struct io_tw_req tw_req, io_tw_token_t tw)
+{
+	struct io_kiocb *req = tw_req.req;
+
+	io_tw_lock(req->ctx, tw);
+	if (unlikely(tw.cancel))
+		io_req_defer_failed(req, -ECANCELED);
+	else
+		io_queue_iowq(req);
+}
+
 void io_queue_iowq(struct io_kiocb *req)
 {
 	struct io_uring_task *tctx = req->tctx;
@@ -430,10 +441,17 @@ void io_queue_iowq(struct io_kiocb *req)
 	BUG_ON(!tctx);
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	if ((current->flags & PF_KTHREAD) || !tctx->io_wq) {
-		io_req_task_queue_fail(req, -ECANCELED);
+	if (current->flags & PF_KTHREAD)
+		goto cancel;
+
+	/* Only the submitter can safely access its io-wq during task exit. */
+	if (unlikely(current != tctx->task)) {
+		req->io_task_work.func = io_req_queue_iowq_tw;
+		io_req_task_work_add(req);
 		return;
 	}
+	if (!tctx->io_wq)
+		goto cancel;
 
 	/*
 	 * The file is looked up as late as possible, as it may be the result
@@ -462,6 +480,9 @@ void io_queue_iowq(struct io_kiocb *req)
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
 	io_wq_enqueue(tctx->io_wq, &req->work);
+	return;
+cancel:
+	io_req_task_queue_fail(req, -ECANCELED);
 }
 
 unsigned io_linked_nr(struct io_kiocb *req)


