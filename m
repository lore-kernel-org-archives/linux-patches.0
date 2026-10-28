Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212118;
	b=mZ3WMLSua2mV+uCMuMk/5Er8in8HLZc+p/dBi9B1HrJ45ONfsfcOYcbwtXfrC9GXCiS8
	 xrTACyMBDFVP12qXYhHgEMJ1vfjN/z0JFd+e91+x917ttMM1fI162GnZcqEA6KhkT/8lg
	 1LapkDaKRpKvRdUM1UhbpYon/7NZlPmEIm35Yh4qAy5iYwfPZrkhp+FRqHmfNv6sLI1Im
	 qZFnCeAktmu7GSdCFShPPEBgmtHs0PmU/ZiiCckTh+qsYjBq6l798QYRSGDBON4XN7ftH
	 4/fClqi6u38tn5CA4DxeC3sy72HTRCoo1Cykm3LKTpHWT/Q+Vy8s1EdU73aHFhDqqXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q5Jc9y2nKGr0Q1v2PhEX0iX9T4azYC+pl79EgJy5Jz4=;
	b=k+JDqyopbS7AtihcD2b5on6UmHiiIPLFgH+o5GkHS++g/n/CSA+FQHY1z31vqmIohPTX
	 /XvbwD4COpqW7L6YpFbjXDekyzq6yJc5mn3iAMQI7pmbIY/lXPCoOJslzRqy9y0FMmL8Y
	 78Qnxni24gkPW3KHBimjDrbAq86gd/5dBU1W356s5rPFnEOOf4fB46ezKfjgETVL51ewU
	 6ICsLsuM4H2O8e7XSpuDo0/diWA/iZxYFs57gTcBwlk2RkFVugK/sR03X5e7akG1DFIqn
	 K68myrK7zUNaqeDs32kwSFZKAW0NybUlz56zID/V3hyxodRezfM5WAwV4qWqXKRwfQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oIfuGV2Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F58606A31D;
	Wed, 28 Oct 2026 18:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oIfuGV2Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10791F01829;
	Wed, 28 Oct 2026 18:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212118;
	bh=Q5Jc9y2nKGr0Q1v2PhEX0iX9T4azYC+pl79EgJy5Jz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oIfuGV2QMLC/6pzKksNwiSfESeWQmU5nUumFY91r4b2c9j6LPf/eb1gDJvBrAwJNQ
	 5XHD/3B7xAz65ev378iP+O2JDo88R0qvTzo91P/GBEoJlleeVvyUnHHkLYpQ54y7Zb
	 nIUlUOl/d4ZiunqcBdZsWVwkumBA6bjeTvQ2Fpx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.1 0017/1887] io_uring: look up the file before queueing to io-wq
Date: Wed, 28 Oct 2026 17:35:13 +0100
Message-ID: <20261028170459.614317947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit 98bc044d5a5374f8d3605fe55a8e2df6d6fc3f82 upstream.

io_prep_async_work() decides by the file of a request what kind of work
it is for io-wq. I/O on regular files and block devices is bounded work,
limited to min(SQ entries, 4 * CPUs) workers, for anything else that may
block indefinitely the limit is RLIMIT_NPROC. Writes to a regular file
are hashed by the inode, so that they are run one after the other instead
of having a bunch of workers fight for the inode lock.

Since the file is only assigned when a request is issued, a request that
is queued without an attempt to issue it, REQ_F_FORCE_ASYNC, doesn't have
one at that point. io_prep_async_work() takes that for "not a regular
file or block device":

- Reads and writes end up as unbound work. 32 reads with IOSQE_ASYNC from
  a slow block device on a ring with 4 SQ entries get 32 workers, not 4.
- Writes aren't hashed. Four buffered writes to one file get four
  workers, three of which do nothing but wait for the lock.

The late assignment is for the benefit of links, where a request may use
a fixed file that one of its predecessors installs. By the time a request
gets to io_queue_iowq() these are done, it is as good as issued. Assign
the file there.

io_assign_file() moves up and is forced inline. With a third caller the
compiler may stop inlining it, and every request that is issued would
pay for a call.

IORING_OP_SPLICE is left as it is, unbound and not hashed. The file of
the request is where it writes to, which says nothing about how long it
takes: a splice from an empty pipe or a socket into a regular file waits
for its input. As bounded work, four of these on a ring with 4 SQ entries
keep all other bounded work of the task from running, and as hashed work
one of them blocks all writes to that file.

REQ_F_FORCE_ASYNC is not only set for IOSQE_ASYNC. What changes, and
brings back what was the case before the file assignment was deferred:

- Requests with IOSQE_ASYNC or IOSQE_IO_DRAIN, and all requests that are
  submitted while a drain is active: reads and writes on regular files
  and block devices count against the limit for bounded workers, including
  the one set with IORING_REGISTER_IOWQ_MAX_WORKERS, so fewer of them run
  at the same time.
- Of these, writes to one regular file are run one at a time, unless they
  are O_DIRECT and the filesystem has FOP_DIO_PARALLEL_WRITE.
- IORING_OP_FALLOCATE and IORING_OP_FTRUNCATE, which always go to io-wq,
  are run one at a time per file, and in turn with these writes.
- The descriptor or the fixed file slot is looked up when the request is
  queued, not when a worker gets around to it, so closing or replacing it
  in between no longer has an effect on the request.

[ 6.1: io_assign_file() takes no def argument here ]
Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-43-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -417,17 +417,45 @@ static void io_prep_async_link(struct io
 	}
 }
 
+/* Called for every request that is issued: keep it inline */
+static __always_inline bool io_assign_file(struct io_kiocb *req,
+					   unsigned int issue_flags)
+{
+	if (req->file || !io_op_defs[req->opcode].needs_file)
+		return true;
+
+	if (req->flags & REQ_F_FIXED_FILE)
+		req->file = io_file_get_fixed(req, req->cqe.fd, issue_flags);
+	else
+		req->file = io_file_get_normal(req, req->cqe.fd);
+
+	return !!req->file;
+}
+
 static void io_queue_iowq(struct io_kiocb *req)
 {
 	struct io_uring_task *tctx = req->task->io_uring;
 
 	BUG_ON(!tctx);
+	lockdep_assert_held(&req->ctx->uring_lock);
 
 	if ((current->flags & PF_KTHREAD) || !tctx->io_wq) {
 		io_req_task_queue_fail(req, -ECANCELED);
 		return;
 	}
 
+	/*
+	 * The file is looked up as late as possible, as it may be the result
+	 * of an earlier request of the link. This one is up now, and what kind
+	 * of work it is depends on the file. If that fails, leave the error
+	 * handling to the worker.
+	 *
+	 * Not for a splice: whatever it writes to, it may wait for its input
+	 * for ever. It has to remain unbound work that isn't hashed.
+	 */
+	if (req->opcode != IORING_OP_SPLICE)
+		io_assign_file(req, 0);
+
 	/* init ->work of the whole link before punting */
 	io_prep_async_link(req);
 
@@ -1693,19 +1721,6 @@ static void io_clean_op(struct io_kiocb
 	req->flags &= ~IO_REQ_CLEAN_FLAGS;
 }
 
-static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
-{
-	if (req->file || !io_op_defs[req->opcode].needs_file)
-		return true;
-
-	if (req->flags & REQ_F_FIXED_FILE)
-		req->file = io_file_get_fixed(req, req->cqe.fd, issue_flags);
-	else
-		req->file = io_file_get_normal(req, req->cqe.fd);
-
-	return !!req->file;
-}
-
 #define REQ_ISSUE_SLOW_FLAGS	(REQ_F_CREDS | REQ_F_ARM_LTIMEOUT)
 
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)


