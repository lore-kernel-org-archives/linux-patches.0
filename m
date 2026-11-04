Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831898;
	b=pNskeQlteLbPPHkRSQKSCPYY1+p4SX7cGlb/W7fGPJlUqQdEbb18q8qpKi709SKIEakw
	 j3ZQMov+JLt3BLgVAMf70Z5QMy3SEZFfrmmwTdZnax7+5rA+kgGcCYm6oaBQzvJVpmaC5
	 sK4mU70/WlwJjJt+qLWQXPyh8Wq5yj04lAx/7mXQVgabyCMLbA3S+qXsRx7zhBullRC06
	 X7OshQMzgFGEU5aiakpz99YebrCEmi3u+FoUEdhqnph4DLsPYD/gHeeiYlPDzP7Tl89kJ
	 VZRr8dCOX/RYeBXobgZm3vCqaWbRyX8OvHEdjbgyJuVNQ6brwnEG7Yk43c1PqQlKwug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RKh/cN9XgYHIuu6dv4Gx6Ppo50czScxIwEGg8FHcvOc=;
	b=Kq46tNzv1XAuT+CyuZ/XQA6/A2yR6U2k74R41AJqWzgp/vmW4jyBm8GAVhUE3Kes5d7q
	 XHqzTCo5rb4AqsVKSkkhPtis1+zsbAQO4rpelE/hhYVUj/RKiblLOnaDUFN0q0MO/iVGG
	 6fdPVfDhQv56KN8A3zAxUXTnKqVm0H1tzoPbyhtHfi9ZK5TvIeCn2ikgmIJH5TPCU0Jkb
	 mFn2D3kHL3l2lk/0LjC/BLXZuTI3ulaBsvuw+vf39J4Uat4Oa4AZbcM653BJ1xzfctC7z
	 ms1EpxtNSXa9uU/dTSezk9H030sSeKM/LooRdaxo9CyKAcH45SOMSg0Pp0LmGOe8LfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cx5wSWW5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E5B606A33D;
	Wed,  4 Nov 2026 22:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cx5wSWW5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C481F000C1;
	Wed,  4 Nov 2026 22:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831898;
	bh=RKh/cN9XgYHIuu6dv4Gx6Ppo50czScxIwEGg8FHcvOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cx5wSWW5qO/SzOdjZLjXuh75iXz5IfnsoFRb0ZDrK7JffHlzYxKGEMFsFJvzmUMOi
	 zv8CH3QmfwO+zBHSMolZVk3+5jjHx4w14mIl3TT3ubFZ3SUYw84izo29mD2XRswwDs
	 LjExHUF1juD1Yhsl1MeDQRcyEBolLU7A0wg499F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 0979/1005] io_uring: defer foreign io-wq enqueues to task_work
Date: Wed,  4 Nov 2026 16:11:52 -0500
Message-ID: <20261104211110.470963318@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[axboe: 6.18 lacks 13b0742fd058, which removed io_req_queue_iowq(). Name
the new task_work callback io_queue_iowq_foreign_tw() so it doesn't
clash with the existing io_req_queue_iowq_tw()]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -483,6 +483,19 @@ static __always_inline bool io_assign_fi
 	return !!req->file;
 }
 
+static void io_queue_iowq(struct io_kiocb *req);
+
+static void io_queue_iowq_foreign_tw(struct io_tw_req tw_req, io_tw_token_t tw)
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
 static void io_queue_iowq(struct io_kiocb *req)
 {
 	struct io_uring_task *tctx = req->tctx;
@@ -490,10 +503,17 @@ static void io_queue_iowq(struct io_kioc
 	BUG_ON(!tctx);
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	if ((current->flags & PF_KTHREAD) || !tctx->io_wq) {
-		io_req_task_queue_fail(req, -ECANCELED);
+	if (current->flags & PF_KTHREAD)
+		goto cancel;
+
+	/* Only the submitter can safely access its io-wq during task exit. */
+	if (unlikely(current != tctx->task)) {
+		req->io_task_work.func = io_queue_iowq_foreign_tw;
+		io_req_task_work_add(req);
 		return;
 	}
+	if (!tctx->io_wq)
+		goto cancel;
 
 	/*
 	 * The file is looked up as late as possible, as it may be the result
@@ -522,6 +542,9 @@ static void io_queue_iowq(struct io_kioc
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
 	io_wq_enqueue(tctx->io_wq, &req->work);
+	return;
+cancel:
+	io_req_task_queue_fail(req, -ECANCELED);
 }
 
 static void io_req_queue_iowq_tw(struct io_tw_req tw_req, io_tw_token_t tw)


