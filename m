Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826941;
	b=VC74mTPW54ZVPEJQGRRdvDTg6AGgwwbUhonOKfRib3KGA+fPCWz+s8VcWxEu5UrWKuIM
	 dnMVboL8qpygmwLye9obWQBq6H4qA1aKMY+gf2YUyKBUoml8CwYzyYw0S7U0WOxjIYrGx
	 zUTbQkS5srrYDvwjlTFDN5EBT+89HrjFJKlrKtz28bmCpHm0Nv1ZDp1VPztSZ7VTBlnFU
	 e51IDM1pefi5ub8pdA1+SshNBOL7gb6TdE2OlBYrH9oPJe/cEZvGLzIZo6nl31z2R1zbX
	 YcqXbwxvf8wQ19UG2s1szcOnnUR5cCpw+r8YD3PnD47bsg5WeYXu08jEYHmdWwdBfxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gjndR5SQFI+nrYkugqnA7JhKBuaKOPZAUuau+2CpyXE=;
	b=JtmbKTWcYUfL3AivsSYQXeXFcr5fz+hvEvepEJOcRnSn4U8Zel+LCCzacjeMQblHSRWV
	 9u0iHPwxoiShaC8irO6Kp+29EuQMIZhaXQktFBtVNqgxYTgdyBv73vUXLlIYz44Jd1V+R
	 MREzmXPgBEJFY+aWLkR9ejkeDozUkvdaMzW43fkVzC2DuqBPW39z4QiaVINHeX2CUGDQ2
	 9WonlLzttfLYJGzw6bcPzYbiTTiUdPEB43t5QCSA1EOfeMm0cm6HQPDgPaImXASHliVzr
	 rngIG8lHAR4p+BkUnSYLg6eqYg0igF1BcD3TCeOaJkVgCYvbntxNNQdzhh8eBFvMy9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJHTuJUG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18876073504;
	Wed,  4 Nov 2026 21:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJHTuJUG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0E31F000C1;
	Wed,  4 Nov 2026 21:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826940;
	bh=gjndR5SQFI+nrYkugqnA7JhKBuaKOPZAUuau+2CpyXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJHTuJUGEsc35/IuJ/+urbWx4E7gJDecjfl24TPWjsHB8arKvuRysrDe9FPNxYrfy
	 ROK7FCfnQ5c91Qp+8ll8esIWE2MJdXsFUq4PSk7CrJNUc+I50fH6/aBwnvhmP0n47z
	 kB/mnf1ia8b2hAjFKIEKP07dTg/68j0e59uK+IEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 059/547] io_uring: look up the file before queueing to io-wq
Date: Wed,  4 Nov 2026 16:04:03 -0500
Message-ID: <20261104211039.959040029@linuxfoundation.org>
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

[ Upstream commit 98bc044d5a5374f8d3605fe55a8e2df6d6fc3f82 ]

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

Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-43-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7cade81d332a8..3d715536df72e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -407,17 +407,46 @@ static void io_prep_async_link(struct io_kiocb *req)
 	}
 }
 
+/* Called for every request that is issued: keep it inline */
+static __always_inline bool io_assign_file(struct io_kiocb *req,
+					   const struct io_issue_def *def,
+					   unsigned int issue_flags)
+{
+	if (req->file || !def->needs_file)
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
 void io_queue_iowq(struct io_kiocb *req)
 {
 	struct io_uring_task *tctx = req->tctx;
 
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
+		io_assign_file(req, &io_issue_defs[req->opcode], 0);
+
 	/* init ->work of the whole link before punting */
 	io_prep_async_link(req);
 
@@ -1394,20 +1423,6 @@ static __cold void io_drain_req(struct io_kiocb *req)
 		ctx->int_flags &= ~IO_RING_F_DRAIN_ACTIVE;
 }
 
-static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
-			   unsigned int issue_flags)
-{
-	if (req->file || !def->needs_file)
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
 
 static inline int __io_issue_sqe(struct io_kiocb *req,
-- 
2.53.0



