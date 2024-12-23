Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3671917A597;
	Mon, 23 Dec 2024 16:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970539; cv=none; b=Hi8pSOly3jf5xVm6i6fAzA4xUMkVuh/Qxtpl+PHqF4jxFJGUSFiUvNL1+LO01995aDBp7yvQJQciyBoX9Ws5QIb/rR2CvOW+ebLwv3+q9OU7Ylqd7Zth29OGmSeg/ucg2C02Kiw4DPe1DqG1X8htI+5M5g6bAqz/Vjl/8oLVoSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970539; c=relaxed/simple;
	bh=qt3tqmsbToMmp6J+ObtYB27KZgBJwSXaS0GcUQwzMW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dmy+to3MT13CswmdfIBEMHtMC5fgAFDCX/OaKo5DfLD2kY1naBuaTBD/fK2HrAQeAjLiwRx8/62SEIsCl7TnLHW+GZ92TDIguBNi3Ov5XM7nNYaGFyanHwITh7MYHFt7y98xB1tpuMhr4GK38hdyJmt2N8XhNK39aZemka03drk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSyhNSFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSyhNSFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BDAC4CED3;
	Mon, 23 Dec 2024 16:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970538;
	bh=qt3tqmsbToMmp6J+ObtYB27KZgBJwSXaS0GcUQwzMW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSyhNSFpZ+2SujoKfZTnQ61FXHEztkgEu0fjEtaofqtH6zZl12P8qgm/Cw2DMvcYB
	 DKhNM2hMSWQ5FSw14u4Ba8ttcRou+xF7Mg8/Df02YuWiqZb1brDF1PYNy03Lsdr5V0
	 tEwdXzORCFQFk+X5uYvw02vUbwYVU8tRDOJMhQwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 113/116] io_uring/rw: avoid punting to io-wq directly
Date: Mon, 23 Dec 2024 16:59:43 +0100
Message-ID: <20241223155403.945367852@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 io_uring/io_uring.c |    8 ++++----
 io_uring/io_uring.h |    1 -
 io_uring/rw.c       |    8 +-------
 3 files changed, 5 insertions(+), 12 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -492,7 +492,7 @@ static void io_prep_async_link(struct io
 	}
 }
 
-void io_queue_iowq(struct io_kiocb *req, struct io_tw_state *ts_dont_use)
+static void io_queue_iowq(struct io_kiocb *req)
 {
 	struct io_kiocb *link = io_prep_linked_timeout(req);
 	struct io_uring_task *tctx = req->task->io_uring;
@@ -1479,7 +1479,7 @@ void io_req_task_submit(struct io_kiocb
 	if (unlikely(req->task->flags & PF_EXITING))
 		io_req_defer_failed(req, -EFAULT);
 	else if (req->flags & REQ_F_FORCE_ASYNC)
-		io_queue_iowq(req, ts);
+		io_queue_iowq(req);
 	else
 		io_queue_sqe(req);
 }
@@ -2044,7 +2044,7 @@ static void io_queue_async(struct io_kio
 		break;
 	case IO_APOLL_ABORTED:
 		io_kbuf_recycle(req, 0);
-		io_queue_iowq(req, NULL);
+		io_queue_iowq(req);
 		break;
 	case IO_APOLL_OK:
 		break;
@@ -2093,7 +2093,7 @@ static void io_queue_sqe_fallback(struct
 		if (unlikely(req->ctx->drain_active))
 			io_drain_req(req);
 		else
-			io_queue_iowq(req, NULL);
+			io_queue_iowq(req);
 	}
 }
 
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -63,7 +63,6 @@ struct file *io_file_get_fixed(struct io
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
-void io_queue_iowq(struct io_kiocb *req, struct io_tw_state *ts_dont_use);
 void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
 void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts);
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -168,12 +168,6 @@ static inline loff_t *io_kiocb_update_po
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
@@ -359,7 +353,7 @@ static int kiocb_done(struct io_kiocb *r
 	if (req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
 		if (io_resubmit_prep(req))
-			io_req_task_queue_reissue(req);
+			return -EAGAIN;
 		else
 			io_req_task_queue_fail(req, final_ret);
 	}


