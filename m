Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC951865EB;
	Mon, 23 Dec 2024 16:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970827; cv=none; b=W6VvoZCRkBRHTcthgLZPHw1IZoZxVN7xnweNRSOXj4Jnn+L2jCyhDlM9cRhAFcr1wv79SYdAxW6NtHv+Zn63HXxGtis1BP/ttQhNXJCDAi9P5Qgtyz1fueI3KsoztBz8yPqD3LG/nNkUcykgo0cWA8L+6SdkLZ8kFDvqwHG1b+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970827; c=relaxed/simple;
	bh=/e0Dk4FKyKn6/h9ROZEhTzHpteKN/54mBaqyGnRFPvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWQQht6ca3GZebaXRiUovoGD1VJBvaBgO6dxvXKEFjR/viuGpRT9L6UArKNnyWNHj/VLI2BCrLIQd/Q78+J+7dw0SLXQjbqQrhZfjpnMtBoXFUiz09x8xZJ8m22xfmXefEB3NE4H7y/2k4VTo+YkYDXwF2CoEpZkxJygjhrZUWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss8KNk2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss8KNk2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F544C4CED6;
	Mon, 23 Dec 2024 16:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970826;
	bh=/e0Dk4FKyKn6/h9ROZEhTzHpteKN/54mBaqyGnRFPvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ss8KNk2p5rEZFpePhvLQ8H8tck74z0SEYokIl6VMd5BcDe+Rvfbu2kQSVzyYHhXbR
	 WBtkN7SONMafDe6MFEeBESry5i+XqQwbT7o+7b9llCEmNPVXi0zoTzGouVgU9H55Tq
	 WqMFRb3+DnkQWvKROySC7YZzL3gfJrb5+sJJAgzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 81/83] io_uring/rw: avoid punting to io-wq directly
Date: Mon, 23 Dec 2024 17:00:00 +0100
Message-ID: <20241223155356.783018009@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

Commit 6e6b8c62120a22acd8cb759304e4cd2e3215d488 upstream.

kiocb_done() should care to specifically redirecting requests to io-wq.
Remove the hopping to tw to then queue an io-wq, return -EAGAIN and let
the core code io_uring handle offloading.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Tested-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/413564e550fe23744a970e1783dfa566291b0e6f.1710799188.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit 6e6b8c62120a22acd8cb759304e4cd2e3215d488)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    6 +++---
 io_uring/io_uring.h |    1 -
 io_uring/rw.c       |    8 +-------
 3 files changed, 4 insertions(+), 11 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -434,7 +434,7 @@ static void io_prep_async_link(struct io
 	}
 }
 
-void io_queue_iowq(struct io_kiocb *req, bool *dont_use)
+static void io_queue_iowq(struct io_kiocb *req)
 {
 	struct io_kiocb *link = io_prep_linked_timeout(req);
 	struct io_uring_task *tctx = req->task->io_uring;
@@ -1913,7 +1913,7 @@ static void io_queue_async(struct io_kio
 		break;
 	case IO_APOLL_ABORTED:
 		io_kbuf_recycle(req, 0);
-		io_queue_iowq(req, NULL);
+		io_queue_iowq(req);
 		break;
 	case IO_APOLL_OK:
 		break;
@@ -1962,7 +1962,7 @@ static void io_queue_sqe_fallback(struct
 		if (unlikely(req->ctx->drain_active))
 			io_drain_req(req);
 		else
-			io_queue_iowq(req, NULL);
+			io_queue_iowq(req);
 	}
 }
 
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -54,7 +54,6 @@ static inline bool io_req_ffs_set(struct
 void __io_req_task_work_add(struct io_kiocb *req, bool allow_local);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
-void io_queue_iowq(struct io_kiocb *req, bool *dont_use);
 void io_req_task_complete(struct io_kiocb *req, bool *locked);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
 void io_req_task_submit(struct io_kiocb *req, bool *locked);
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -167,12 +167,6 @@ static inline loff_t *io_kiocb_update_po
 	return NULL;
 }
 
-static void io_req_task_queue_reissue(struct io_kiocb *req)
-{
-	req->io_task_work.func = io_queue_iowq;
-	io_req_task_work_add(req);
-}
-
 #ifdef CONFIG_BLOCK
 static bool io_resubmit_prep(struct io_kiocb *req)
 {
@@ -341,7 +335,7 @@ static int kiocb_done(struct io_kiocb *r
 	if (req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
 		if (io_resubmit_prep(req))
-			io_req_task_queue_reissue(req);
+			return -EAGAIN;
 		else
 			io_req_task_queue_fail(req, final_ret);
 	}


