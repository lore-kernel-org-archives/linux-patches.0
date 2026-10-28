Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209788;
	b=yWOSBQigbkNNvgsw1krohgS+ARYNCln1ZW2J2qQCQKYsELQwtbd5cdsOGhzRtpPhrwB8
	 rAqEOzuYRaf5Br7gfbfhH5aj9Iv5Iq7cDGQdXN1T43Cd7jUC76bsnBcCMg+GkubwWXJ8y
	 V9WvBrG6uJiBsf9fJCGHB/fKcHzP27bB25nJ6xWEZyMw2nJcGmLvRz7QsAxnUPqurms/2
	 dr23gEhlKZk10N1YUqnsJJUCbNGugO6DJmbXCqoUXG/Dongf072qzyKMEaWFqHjuuWcGe
	 5NskYgwNBjlTMHXW2AJBYM3Y3qdetAc66yxNLqHjqWSwHhzMkO9e89ttfsTYC+r+LyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sadm7/RVKmpxwLwinsJ53MGj5Ke/t4WJOxPdFp7cIeA=;
	b=0jxoh3BNlXAkrSZX6pcXp2Sa2Hp4516Ao30eITxHg0z7kLCR0rJ+6OMhlXZmGLvS5PTK
	 jdYMaCO0KLPK0O/sEW0t2pwkT99ksZUpi1DIp21J/rFDsDx2oGtuKkY1Zd9GIc0VNl6Y+
	 Kc2n4Z9WYjSrOxnpKFKQykqXgYsWHBlrDbZlaW1vMC0qUC05mqgemmoNXBYugZMW/5Kb6
	 jNBpqvji2y0+AyBQ88vE5PQhWNYkVVV6K8n1WiH4z2KLxVtK9c9V0hnywTteMmDkuYcrp
	 4HWGj+LOBi2Ab3wwn6G23g1UpbGK/oc6hrDUHcOkcLFNZSOTK7S9jU1bhsBuEAnHxag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J11dUT5g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26FD606A31A;
	Wed, 28 Oct 2026 17:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J11dUT5g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487091F01825;
	Wed, 28 Oct 2026 17:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209787;
	bh=sadm7/RVKmpxwLwinsJ53MGj5Ke/t4WJOxPdFp7cIeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J11dUT5gUBZlhoB2fbWSXvdeG8ub8saX7GVHdu7hUOfyXYKCwjYOfCDhSPSW0I9ie
	 vBubzLWtVwXRqZqXep04njYQhWM/AvdMRHpUodz+suzqIGqE8kp/m+ADfz0zzMZXfA
	 XsEMAy1d/Nuc/YyopsAiHT4aFWs5HvvAQvY1Hfr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 076/109] io_uring: dont pass restart error codes to userspace
Date: Wed, 28 Oct 2026 18:01:00 +0100
Message-ID: <20261028165944.147101583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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
@@ -1890,6 +1890,9 @@ static int io_issue_sqe(struct io_kiocb
 	ret = __io_issue_sqe(req, issue_flags, def);
 
 	if (ret == IOU_COMPLETE) {
+		/* not all handlers take care of the internal restart codes */
+		if (unlikely(req->cqe.res <= -ERESTARTSYS))
+			req->cqe.res = io_fixup_restart_res(req->cqe.res);
 		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 			io_req_complete_defer(req);
 		else
@@ -1905,6 +1908,8 @@ static int io_issue_sqe(struct io_kiocb
 		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
 			io_iopoll_req_issued(req, issue_flags);
 	}
+	if (unlikely(ret <= -ERESTARTSYS))
+		ret = io_fixup_restart_res(ret);
 	return ret;
 }
 
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -334,6 +334,24 @@ static inline void io_req_set_res32(stru
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
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -625,24 +625,6 @@ static void io_complete_rw_iopoll(struct
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


