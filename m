Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AF428EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2887CC433D2;
	Mon, 30 Jan 2023 14:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087548;
	bh=olP8qaEoHY4JxM9omDC91K4yhdjk4v7OkoiIzzGVBoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLJwyfdxvVupaKrV0TAWG+8LDkitAX1uX/takptFKyAGW/Pt/M25kkUWqbEtrZMvX
	 eYoPzGmdwsi+egF/rKQPWn5P+ebOunX8JlgNpALiRugtZZGBsQMdxjMk3gGIx7SyoM
	 9VOhL5U3G9d4tRHX7V6pusseDR3qfAXUQb7hUkRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 245/313] io_uring: inline __io_req_complete_put()
Date: Mon, 30 Jan 2023 14:51:20 +0100
Message-Id: <20230130134348.110369907@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

[ Upstream commit fa18fa2272c7469e470dcb7bf838ea50a25494ca ]

Inline __io_req_complete_put() into io_req_complete_post(), there are no
other users.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1923a4dfe80fa877f859a22ed3df2d5fc8ecf02b.1669203009.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: ef5c600adb1d ("io_uring: always prep_async for drain requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 50f959ffb55c..13a60f51b283 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -823,15 +823,19 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx,
 	return filled;
 }
 
-static void __io_req_complete_put(struct io_kiocb *req)
+void io_req_complete_post(struct io_kiocb *req)
 {
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_cq_lock(ctx);
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		__io_fill_cqe_req(ctx, req);
+
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
 	 */
 	if (req_ref_put_and_test(req)) {
-		struct io_ring_ctx *ctx = req->ctx;
-
 		if (req->flags & IO_REQ_LINK_FLAGS) {
 			if (req->flags & IO_DISARM_MASK)
 				io_disarm_next(req);
@@ -852,16 +856,6 @@ static void __io_req_complete_put(struct io_kiocb *req)
 		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
 	}
-}
-
-void io_req_complete_post(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	io_cq_lock(ctx);
-	if (!(req->flags & REQ_F_CQE_SKIP))
-		__io_fill_cqe_req(ctx, req);
-	__io_req_complete_put(req);
 	io_cq_unlock_post(ctx);
 }
 
-- 
2.39.0



