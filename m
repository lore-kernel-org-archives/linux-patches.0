Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826931;
	b=OAWLYB/R0XhQZcipIvGtTSjeoEDPvh/3rj7PbJX/ze9y0NPYjWzRTBiUTrPn3P5wkCg3
	 5gBLJGYE75+rwCxlfA1OPdVypGisqU9WUf28er+KxukrYGNDuz/uoy0YdyWR+WUo2xqh+
	 az08OmSCVNg/4yUhnMCnqHWjMfJtprsX48Rzj8MfgM1SaN8qWXujE/MGPi74svj/gMy5o
	 woUShguvBc+zOmIC6ka2zMtFcEXVn6/ao7PD4OSexzKSvREmSCDksGVac9ObWrad/aT5v
	 Qa4m8o+1Ps0R28/zwX6UWtvRTZ9+VRYqCpqi7kcEFZ4l1h4hBytNdvO3cmZ6zibwHng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W52rDQsQRBgbGmyYOm0GBN/qmeSAtna8ZJbCvsvIgWY=;
	b=RcWW8XrtIDabfaF1Xh17Ip24bzVEDntR4OUGZVFW1ZxPWeuK/6cuZks+8YsR8okTeaai
	 kfnJuo2dj+6JaA91I603nyj332DuxKuVw+fQv0aTMSrX7GXhDb6ik83QWcSA/gvrW1nyk
	 QmR95q5JZTElDKQ5UZH0aPpjlbt+XX5QUvRaPS+2huKtvfDFb0r4hhKveSM3v3g2nL7Hx
	 FIaws8sbDD+Dy/KArQlBCRt7WHov6/6yp0UMSbD9d25rqNLklR7DLn8oAqXJPlQdfKWmw
	 txLbMFsuUkgzeD+46tOC32o9Uu5Z2f+59dPsak4TOK9TcdiRB4RmKv+8X8DR6xrvkgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0bl3CSJ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE0C6072FA3;
	Wed,  4 Nov 2026 21:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0bl3CSJ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492481F00919;
	Wed,  4 Nov 2026 21:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826930;
	bh=W52rDQsQRBgbGmyYOm0GBN/qmeSAtna8ZJbCvsvIgWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bl3CSJ0jBg0Nwu2iVcCANLYhwpXrvVB6oy9db1ZWqNFPNiYD68nTY14dZLcsCSJn
	 ijn/ZF+MVMuh1HTTAG9lTNQuY1yl3d4anHMSuAzo8wck5TBkTO5fpdaeuZlMoQ+6ol
	 9H5kbvzq3IexBDQVINFBZRtirw6Qghh9jiBwS3p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 055/547] io_uring: dont pass restart error codes to userspace
Date: Wed,  4 Nov 2026 16:03:59 -0500
Message-ID: <20261104211039.855724338@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit e1a64bc64897f4c2fe460922c345f2ed8f889b5f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c |  5 +++++
 io_uring/io_uring.h | 18 ++++++++++++++++++
 io_uring/rw.c       | 18 ------------------
 3 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9796283508b83..7cade81d332a8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1454,6 +1454,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	ret = __io_issue_sqe(req, issue_flags, def);
 
 	if (ret == IOU_COMPLETE) {
+		/* not all handlers take care of the internal restart codes */
+		if (unlikely(req->cqe.res <= -ERESTARTSYS))
+			req->cqe.res = io_fixup_restart_res(req->cqe.res);
 		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 			io_req_complete_defer(req);
 		else
@@ -1468,6 +1471,8 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		if (req->flags & REQ_F_IOPOLL)
 			io_iopoll_req_issued(req, issue_flags);
 	}
+	if (unlikely(ret <= -ERESTARTSYS))
+		ret = io_fixup_restart_res(ret);
 	return ret;
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 659deb13c6680..22374bf536a04 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -350,6 +350,24 @@ static inline void io_req_set_res32(struct io_kiocb *req, s32 res, u32 cflags,
 	req->big_cqe.extra2 = extra2;
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
 static inline void *io_uring_alloc_async_data(struct io_alloc_cache *cache,
 					      struct io_kiocb *req)
 {
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 432820f862514..b21daa3cfa5c2 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -610,24 +610,6 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
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
 static inline void io_rw_done(struct io_kiocb *req, ssize_t ret)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-- 
2.53.0



