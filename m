Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208015;
	b=5ZMsU6bbIU8ZjJDCVZc0/MlJ8yvoPEmVOEP2Mms4BlTcAgAndCsHA4panx+xsksnhaEf
	 IKKdNmolQAwLnzoW+bUCjQDR/V03APqyGG76kYzXWj5D8qz9Dc3C4D/hoyyETKRUIMohG
	 w8kHj40kB6iLvJ2tXmD/KArL4sZAyg3fOybKKgiskD5IbxxXVXW8tt4Qqa3DIcRuXDrfC
	 +g6X157NZ0BoXZyNpre6llvaqnogh30YwNNeshgydHrgh2el2BhDXQ/z+hP6wmf1QqYvr
	 1/o9cb4f+lAGc0cD53r1mS5KJRH/TmaHp6rJKypCccJiD+3tU28kYjaNq00ioCcpVWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2OcEIY6g5zNqUvHL0wCpgnfICtkTYSu3ZmZAyuOg3Z0=;
	b=wc5VX5rgNInQfalopccaupIa6Fdwgjx5tVvr6oiPtIPignBPNr0712KrGPqycWVeM1eY
	 eeqWBSPeGLHYPBCuc6960snJXCpPa1rsYv0Mgx/4eovOkWcBlfnG2982UWr1qPnYQS9EU
	 V35Twmee5BtO4oABdt3wwl63mvqisYMCBv3rdMa6TTxyp4k/O+7JUTczOKpL7aBD1gfv+
	 NcAYVx+IcS00M2TKHtDw8miviyHbezxRgnx+XjrbS0GTJ82vHORcMhywZJQrRv4SZUB45
	 Btkj0ah25R3CRoK6KU8w/JntYWm/7iIv/Dj/iyBI1HAHYu5V7smZXJY3fr171n3RnYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=STNACcl0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034FC606A31A;
	Wed, 28 Oct 2026 17:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=STNACcl0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D5A1F01828;
	Wed, 28 Oct 2026 17:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208014;
	bh=2OcEIY6g5zNqUvHL0wCpgnfICtkTYSu3ZmZAyuOg3Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STNACcl0OpeQS2SxLQpz8ZkmWSEPSFepfIGAZqX3mkajFt/NSDskHdkL2hamAR0q6
	 H8qGqPpjyFI64NV/T0HDb8Lys1hbHK2cK1/6rolh4bLkc4qGLrDC1/eCM1xf1Ov3Vz
	 RQ2xWHofac+ctQVXnBqDkgbFexPJPv7sdxK1Pc9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 217/247] io_uring: dont pass restart error codes to userspace
Date: Wed, 28 Oct 2026 18:00:20 +0100
Message-ID: <20261028165952.561663491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit e1a64bc64897f4c2fe460922c345f2ed8f889b5f upstream.

-ERESTARTSYS and friends are instructions for the system call exit code,
which either restarts the call or turns them into -EINTR. They are not
supposed to be seen by applications. A request isn't a system call,
nobody looks at what it returns before that is put into a CQE.

The read/write and the networking opcodes convert these codes to -EINTR
by hand. The others don't. An io-wq worker that is blocked in the open of
a FIFO, a tty or some other device, or in a splice from an empty pipe,
and that gets interrupted because the request is cancelled, completes it
with -512:

  IORING_OP_OPENAT, IOSQE_ASYNC       // FIFO without a writer
  IORING_OP_ASYNC_CANCEL              // -EALREADY, worker is signalled
  CQE of the open: res == -512

There are more candidates, like whatever a file system or driver returns
from ->flush(), ->fsync(), ->fallocate() or ->uring_cmd(), or breaking a
lease or delegation.

Take care of it in io_issue_sqe(), which all of them go through. The
helper is moved from rw.c as is. The cost is a compare and a branch that
is not taken per request.

Fixes: 15b71abe7b52 ("io_uring: add support for IORING_OP_OPENAT")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-39-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    5 +++++
 io_uring/io_uring.h |   18 ++++++++++++++++++
 io_uring/rw.c       |   18 ------------------
 3 files changed, 23 insertions(+), 18 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1773,6 +1773,9 @@ static int io_issue_sqe(struct io_kiocb
 	}
 
 	if (ret == IOU_OK) {
+		/* not all handlers take care of the internal restart codes */
+		if (unlikely(req->cqe.res <= -ERESTARTSYS))
+			req->cqe.res = io_fixup_restart_res(req->cqe.res);
 		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 			io_req_complete_defer(req);
 		else
@@ -1788,6 +1791,8 @@ static int io_issue_sqe(struct io_kiocb
 		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
 			io_iopoll_req_issued(req, issue_flags);
 	}
+	if (unlikely(ret <= -ERESTARTSYS))
+		ret = io_fixup_restart_res(ret);
 	return ret;
 }
 
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -203,6 +203,24 @@ static __always_inline bool io_fill_cqe_
 	return true;
 }
 
+static inline ssize_t io_fixup_restart_res(ssize_t ret)
+{
+	switch (ret) {
+	case -ERESTARTSYS:
+	case -ERESTARTNOINTR:
+	case -ERESTARTNOHAND:
+	case -ERESTART_RESTARTBLOCK:
+		/*
+		 * We can't just restart the syscall, since previously
+		 * submitted sqes may already be in progress. Just fail
+		 * this IO with EINTR.
+		 */
+		return -EINTR;
+	default:
+		return ret;
+	}
+}
+
 static inline void req_set_fail(struct io_kiocb *req)
 {
 	req->flags |= REQ_F_FAIL;
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -560,24 +560,6 @@ static void io_complete_rw_iopoll(struct
 	smp_store_release(&req->iopoll_completed, 1);
 }
 
-static inline ssize_t io_fixup_restart_res(ssize_t ret)
-{
-	switch (ret) {
-	case -ERESTARTSYS:
-	case -ERESTARTNOINTR:
-	case -ERESTARTNOHAND:
-	case -ERESTART_RESTARTBLOCK:
-		/*
-		 * We can't just restart the syscall, since previously
-		 * submitted sqes may already be in progress. Just fail
-		 * this IO with EINTR.
-		 */
-		return -EINTR;
-	default:
-		return ret;
-	}
-}
-
 static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 {
 	/* IO was queued async, completion will happen later */


