Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531D27474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA289C433D2;
	Tue, 10 Jan 2023 18:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374874;
	bh=uGACMhsOpM7hfjg2xI4r2v2groQOxRMt8vRjIuOUL1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1GLlUL/+UnluxyeVgO7r+TwNOMSSnhYl2MompPUAOmKOpLGm+3mei3kNLoZLF3Hr8
	 6vEcZJPbZn0ukHeYHhJUpy9vIuoIgP1/lTcHCisLxR8N/oo5xNxZlHNxfYzWOvuZvW
	 JF1degPcJYdBMx/94Ne1O4gfmTd6K70QbrkXw6oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 136/159] io_uring: pin context while queueing deferred tw
Date: Tue, 10 Jan 2023 19:04:44 +0100
Message-Id: <20230110180022.727454346@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

commit 9ffa13ff78a0a55df968a72d6f0ebffccee5c9f4 upstream.

Unlike normal tw, nothing prevents deferred tw to be executed right
after an tw item added to ->work_llist in io_req_local_work_add(). For
instance, the waiting task may get waken up by CQ posting or a normal
tw. Thus we need to pin the ring for the rest of io_req_local_work_add()

Cc: stable@vger.kernel.org
Fixes: c0e0d6ba25f18 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1a79362b9c10b8523ef70b061d96523650a23344.1672795998.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1109,13 +1109,18 @@ static void io_req_local_work_add(struct
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!llist_add(&req->io_task_work.node, &ctx->work_llist))
+	percpu_ref_get(&ctx->refs);
+
+	if (!llist_add(&req->io_task_work.node, &ctx->work_llist)) {
+		percpu_ref_put(&ctx->refs);
 		return;
+	}
 	/* need it for the following io_cqring_wake() */
 	smp_mb__after_atomic();
 
 	if (unlikely(atomic_read(&req->task->io_uring->in_idle))) {
 		io_move_task_work_from_local(ctx);
+		percpu_ref_put(&ctx->refs);
 		return;
 	}
 
@@ -1125,6 +1130,7 @@ static void io_req_local_work_add(struct
 	if (ctx->has_evfd)
 		io_eventfd_signal(ctx);
 	__io_cqring_wake(ctx);
+	percpu_ref_put(&ctx->refs);
 }
 
 static inline void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)


