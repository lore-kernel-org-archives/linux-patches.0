Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A607E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164F6C433EF;
	Sun, 22 Jan 2023 15:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400314;
	bh=QXdRJ5DH6vn4Pju1VHA5nhTBzG9dmmnfFLVDb5DRRtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hS44/7trchBKi5mp9R9F+CZyHpnNBPI0r2aW/I5gW8C83P33w8B4fyIRRpvsdx3kj
	 Upg16j25/VcPkeeQh3V9E5Ob3qtOMDBb6Q98kMQD7x1DmWR80qE/jLlavjua7KnWLw
	 dXXp5gxP10IFZ7FVGDzxSh/5GsyvUGaxTDW4eILw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+6805087452d72929404e@syzkaller.appspotmail.com
Subject: [PATCH 5.10 28/98] io_uring: lock overflowing for IOPOLL
Date: Sun, 22 Jan 2023 16:03:44 +0100
Message-Id: <20230122150230.668195985@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
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

commit 544d163d659d45a206d8929370d5a2984e546cb7 upstream.

syzbot reports an issue with overflow filling for IOPOLL:

WARNING: CPU: 0 PID: 28 at io_uring/io_uring.c:734 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
CPU: 0 PID: 28 Comm: kworker/u4:1 Not tainted 6.2.0-rc3-syzkaller-16369-g358a161a6a9e #0
Workqueue: events_unbound io_ring_exit_work
Call trace:
 io_cqring_event_overflow+0x1c0/0x230 io_uring/io_uring.c:734
 io_req_cqe_overflow+0x5c/0x70 io_uring/io_uring.c:773
 io_fill_cqe_req io_uring/io_uring.h:168 [inline]
 io_do_iopoll+0x474/0x62c io_uring/rw.c:1065
 io_iopoll_try_reap_events+0x6c/0x108 io_uring/io_uring.c:1513
 io_uring_try_cancel_requests+0x13c/0x258 io_uring/io_uring.c:3056
 io_ring_exit_work+0xec/0x390 io_uring/io_uring.c:2869
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863

There is no real problem for normal IOPOLL as flush is also called with
uring_lock taken, but it's getting more complicated for IOPOLL|SQPOLL,
for which __io_cqring_overflow_flush() happens from the CQ waiting path.

Reported-and-tested-by: syzbot+6805087452d72929404e@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f05f033d8496..b7bd5138bdaf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2482,12 +2482,26 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 	io_init_req_batch(&rb);
 	while (!list_empty(done)) {
+		struct io_uring_cqe *cqe;
+		unsigned cflags;
+
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
-
-		io_fill_cqe_req(req, req->result, io_put_rw_kbuf(req));
+		cflags = io_put_rw_kbuf(req);
 		(*nr_events)++;
 
+		cqe = io_get_cqe(ctx);
+		if (cqe) {
+			WRITE_ONCE(cqe->user_data, req->user_data);
+			WRITE_ONCE(cqe->res, req->result);
+			WRITE_ONCE(cqe->flags, cflags);
+		} else {
+			spin_lock(&ctx->completion_lock);
+			io_cqring_event_overflow(ctx, req->user_data,
+							req->result, cflags);
+			spin_unlock(&ctx->completion_lock);
+		}
+
 		if (req_ref_put_and_test(req))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
-- 
2.39.0



