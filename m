Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377871ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5433CC433C8;
	Tue, 25 Jul 2023 11:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284035;
	bh=SLksFrqLNw2Z8rdcW16EYZ+LOjQF+3Ty8z8pGOeF7SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KoWz1PP+XyTWnSvJ2Q9djdv7/dzgd4jiYhneLHUJ9fA3vJaTy8BvteY+3sqClSl0u
	 Xyg1ylUsLfTmwCoTJEcE0Dm9mLklh5QKbTupQMvMl4ZY8y5WfQMDVcCAkdyIkEu+r0
	 tkDKmV9bcIx2u7g4UEnsAdmEelCa7XoPBcaxkhVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	dghost david <daviduniverse18@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 211/509] io_uring: ensure IOPOLL locks around deferred work
Date: Tue, 25 Jul 2023 12:42:30 +0200
Message-ID: <20230725104603.394974632@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
@@ -1521,6 +1521,8 @@ static void io_kill_timeout(struct io_ki
 
 static void io_queue_deferred(struct io_ring_ctx *ctx)
 {
+	lockdep_assert_held(&ctx->completion_lock);
+
 	while (!list_empty(&ctx->defer_list)) {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
@@ -1572,14 +1574,24 @@ static void __io_commit_cqring_flush(str
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
@@ -2518,7 +2530,12 @@ static void io_iopoll_complete(struct io
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


