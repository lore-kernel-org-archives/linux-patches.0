Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210383;
	b=bgaxVhn7vEY52Uuc2Y4F3VmTms4thUfkCiq326AOdr5yJASwLi+TzUu/cikkikWEJgzy
	 lm8yCSofyEUYt2BanodjyV+fbgTABAq5jRb7m+oqupX6Wsgdt668WZH7g2XZB9rRGKozg
	 8Xekt9TVLH3rsZa4Msw1GBslgdX2PEJN6rbfkRFm4XrSd3zCFP9n6l8vaqpeZnmJZLz5z
	 3azSyFFZ/O5QurHbIkpnTNkEzMzdiqOLulk3grfn55POiEL9UOP0iuWXn9S+WrNk+ob3L
	 Q79hqnmJs0ydRksKN6+ruTeW4mjyr4fjQJOLCLlJhQdrIzf7702Eu2XG/WDLxDSjSVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O6OknoB0OEZkvxmC0Wi3RxKnbmjmFRVgaPQ8pqIQEy8=;
	b=Jb7mGT/0L9qB8C68Hr3W5DFVpvR4zq/kuA9GDq//LM4UYwgcTRN06fv7QAb0EBAbyHte
	 9kb31m+2uzI5gXSqGBO56T95S3ob8O+BuyK83D5MlhSvKqH1IN6OQcRFEjgQD9FahKUrD
	 ildkY6avXrdfzkanMGXrVqNc+t6f5eGPQk5EG/SOXiKWL5mI+E0oCv1VhUUTFtXQLjjvm
	 Tsbe5znEDdfD36Wzo0Pqu30fwKc7Z+fd5c+/RhYjP9BqJe93bfFb6z0d1AA++sw7TgF/Z
	 b98KhPnrMaVOj2ulh7U4+3miQ3AHe0vmqD/HRcHmNARgwsxifjTNSCSKYpqrzwEzkug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g21XNJV9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825B0606A31C;
	Wed, 28 Oct 2026 17:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g21XNJV9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D327E1F01825;
	Wed, 28 Oct 2026 17:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210383;
	bh=O6OknoB0OEZkvxmC0Wi3RxKnbmjmFRVgaPQ8pqIQEy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g21XNJV9FAjhYg7GboUp3cCF5ZW9HrN/rWDN4/Yj4ivhXILjP9mFWL0lnH5zOAZ9F
	 2UKvjp8xDF8Q3MGTxLZVdufsblE7fdr3pjP1ty7uB2dUVJEFNyHtcUrglNqOQt0Nal
	 KY9Qc2sOsCQ1l12HuGkLaRuBuqEoy9ySaRrwh62U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.6 145/168] io_uring: dont pass restart error codes to userspace
Date: Wed, 28 Oct 2026 18:01:21 +0100
Message-ID: <20261028165946.517537545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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

[ 6.6: io_issue_sqe() returns IOU_OK and an error straight away ]
Fixes: 15b71abe7b52 ("io_uring: add support for IORING_OP_OPENAT")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-39-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    8 +++++++-
 io_uring/io_uring.h |   18 ++++++++++++++++++
 io_uring/rw.c       |   18 ------------------
 3 files changed, 25 insertions(+), 19 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1906,6 +1906,9 @@ static int io_issue_sqe(struct io_kiocb
 	}
 
 	if (ret == IOU_OK) {
+		/* not all handlers take care of the internal restart codes */
+		if (unlikely(req->cqe.res <= -ERESTARTSYS))
+			req->cqe.res = io_fixup_restart_res(req->cqe.res);
 		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 			io_req_complete_defer(req);
 		else
@@ -1914,8 +1917,11 @@ static int io_issue_sqe(struct io_kiocb
 		return 0;
 	}
 
-	if (ret != IOU_ISSUE_SKIP_COMPLETE)
+	if (ret != IOU_ISSUE_SKIP_COMPLETE) {
+		if (unlikely(ret <= -ERESTARTSYS))
+			ret = io_fixup_restart_res(ret);
 		return ret;
+	}
 
 	/* If the op doesn't have a file, we're not polling for it */
 	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -193,6 +193,24 @@ static __always_inline bool io_fill_cqe_
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
@@ -140,24 +140,6 @@ void io_readv_writev_cleanup(struct io_k
 	kfree(io->free_iovec);
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


