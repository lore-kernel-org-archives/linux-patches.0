Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BEC200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA67CC433C8;
	Fri, 21 Jul 2023 19:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966171;
	bh=umXYw4gLkH7TA2bjSwVSvTB4zbVIwXV9+S+SdAPvkSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oy9ksEWXsh/l5n4d+H/ZTZCIOF1U5Yhm01qm0vrDdb1GJjACFms48n7mf9M8/IxfV
	 OQU78GvXtZJeBCAI5CDkeYbohSWqabc+Q2oJvDOrnOEHTcwKmyBT5LzKWNyyg0Szlt
	 oKMEeVks1WhVbUvachqNRnyeRLdJ9TpWBBxPL2/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	dghost david <daviduniverse18@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 249/532] io_uring: ensure IOPOLL locks around deferred work
Date: Fri, 21 Jul 2023 18:02:33 +0200
Message-ID: <20230721160627.859737820@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

No direct upstream commit exists for this issue. It was fixed in
5.18 as part of a larger rework of the completion side.

io_commit_cqring() writes the CQ ring tail to make it visible, but it
also kicks off any deferred work we have. A ring setup with IOPOLL
does not need any locking around the CQ ring updates, as we're always
under the ctx uring_lock. But if we have deferred work that needs
processing, then io_queue_deferred() assumes that the completion_lock
is held, as it is for !IOPOLL.

Add a lockdep assertion to check and document this fact, and have
io_iopoll_complete() check if we have deferred work and run that
separately with the appropriate lock grabbed.

Cc: stable@vger.kernel.org # 5.10, 5.15
Reported-by: dghost david <daviduniverse18@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1524,6 +1524,8 @@ static void io_kill_timeout(struct io_ki
 
 static void io_queue_deferred(struct io_ring_ctx *ctx)
 {
+	lockdep_assert_held(&ctx->completion_lock);
+
 	while (!list_empty(&ctx->defer_list)) {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
@@ -1575,14 +1577,24 @@ static void __io_commit_cqring_flush(str
 		io_queue_deferred(ctx);
 }
 
-static inline void io_commit_cqring(struct io_ring_ctx *ctx)
+static inline bool io_commit_needs_flush(struct io_ring_ctx *ctx)
+{
+	return ctx->off_timeout_used || ctx->drain_active;
+}
+
+static inline void __io_commit_cqring(struct io_ring_ctx *ctx)
 {
-	if (unlikely(ctx->off_timeout_used || ctx->drain_active))
-		__io_commit_cqring_flush(ctx);
 	/* order cqe stores with ring update */
 	smp_store_release(&ctx->rings->cq.tail, ctx->cached_cq_tail);
 }
 
+static inline void io_commit_cqring(struct io_ring_ctx *ctx)
+{
+	if (unlikely(io_commit_needs_flush(ctx)))
+		__io_commit_cqring_flush(ctx);
+	__io_commit_cqring(ctx);
+}
+
 static inline bool io_sqring_full(struct io_ring_ctx *ctx)
 {
 	struct io_rings *r = ctx->rings;
@@ -2521,7 +2533,12 @@ static void io_iopoll_complete(struct io
 			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
 
-	io_commit_cqring(ctx);
+	if (io_commit_needs_flush(ctx)) {
+		spin_lock(&ctx->completion_lock);
+		__io_commit_cqring_flush(ctx);
+		spin_unlock(&ctx->completion_lock);
+	}
+	__io_commit_cqring(ctx);
 	io_cqring_ev_posted_iopoll(ctx);
 	io_req_free_batch_finish(ctx, &rb);
 }


