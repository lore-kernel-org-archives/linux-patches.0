Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172492475E3;
	Tue, 20 May 2025 14:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750655; cv=none; b=Gf5a3f9eSIcfVXKq4ufeOTV5nWjI3n4MEv9jeKy17UQaQwRpvr0FiEsabUAEzR/wCF33ueCeJ/nuuHKLk4ZgDkRPD/TkoZjP/KZXs5VzfYFr/i8avwztnv/ghZEZLBat61ZSPI891LuI5KKFlf2JZ/gQwviZSc0L/iqbyRQnYBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750655; c=relaxed/simple;
	bh=6Ni4qYguYLEi6BmvmX3X07eD3nQTqNptwfNMVxLFbtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJnnAIkf3YqVFZuFv0p0I8QjdeZsxnyHs9hAgIu23+m/ZXEKtD4RyFGfCGN1GolvZ9qw2K1DAcMz7axXjwgK+1H9IRa8u6BHW67ll7aEJxmrInbm1B+25coZywhn0IvSeagc8O5J62RGh4H5p38AmpzRkm2N6MP8z72g57KwgQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPtmH5tx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPtmH5tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72904C4CEE9;
	Tue, 20 May 2025 14:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750654;
	bh=6Ni4qYguYLEi6BmvmX3X07eD3nQTqNptwfNMVxLFbtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPtmH5txKzrpo/je6/61c/NtJ38dDY0pb22gcqS9u2MQnnqYNmvtzcA4xXVJPrZlJ
	 HAVTAOOi0zzsnZEsqJ0ZiVbe2w/+XAuIs5RS4IL9ips+0ySSh2WBIWJRGc5l8A6LKR
	 LmGNgT/2mq+ThMLPKhYd09f6XjaIsCf7K206WKjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 048/145] io_uring/fdinfo: grab ctx->uring_lock around io_uring_show_fdinfo()
Date: Tue, 20 May 2025 15:50:18 +0200
Message-ID: <20250520125812.460995541@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit d871198ee431d90f5308d53998c1ba1d5db5619a ]

Not everything requires locking in there, which is why the 'has_lock'
variable exists. But enough does that it's a bit unwieldy to manage.
Wrap the whole thing in a ->uring_lock trylock, and just return
with no output if we fail to grab it. The existing trylock() will
already have greatly diminished utility/output for the failure case.

This fixes an issue with reading the SQE fields, if the ring is being
actively resized at the same time.

Reported-by: Jann Horn <jannh@google.com>
Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/fdinfo.c | 48 ++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index f60d0a9d505e2..336aec7ea8c29 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -86,13 +86,8 @@ static inline void napi_show_fdinfo(struct io_ring_ctx *ctx,
 }
 #endif
 
-/*
- * Caller holds a reference to the file already, we don't need to do
- * anything else to get an extra reference.
- */
-__cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
+static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 {
-	struct io_ring_ctx *ctx = file->private_data;
 	struct io_overflow_cqe *ocqe;
 	struct io_rings *r = ctx->rings;
 	struct rusage sq_usage;
@@ -106,7 +101,6 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	unsigned int sq_entries, cq_entries;
 	int sq_pid = -1, sq_cpu = -1;
 	u64 sq_total_time = 0, sq_work_time = 0;
-	bool has_lock;
 	unsigned int i;
 
 	if (ctx->flags & IORING_SETUP_CQE32)
@@ -176,15 +170,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 		seq_printf(m, "\n");
 	}
 
-	/*
-	 * Avoid ABBA deadlock between the seq lock and the io_uring mutex,
-	 * since fdinfo case grabs it in the opposite direction of normal use
-	 * cases. If we fail to get the lock, we just don't iterate any
-	 * structures that could be going away outside the io_uring mutex.
-	 */
-	has_lock = mutex_trylock(&ctx->uring_lock);
-
-	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		struct io_sq_data *sq = ctx->sq_data;
 
 		/*
@@ -206,7 +192,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
 	seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
 	seq_printf(m, "UserFiles:\t%u\n", ctx->file_table.data.nr);
-	for (i = 0; has_lock && i < ctx->file_table.data.nr; i++) {
+	for (i = 0; i < ctx->file_table.data.nr; i++) {
 		struct file *f = NULL;
 
 		if (ctx->file_table.data.nodes[i])
@@ -218,7 +204,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 		}
 	}
 	seq_printf(m, "UserBufs:\t%u\n", ctx->buf_table.nr);
-	for (i = 0; has_lock && i < ctx->buf_table.nr; i++) {
+	for (i = 0; i < ctx->buf_table.nr; i++) {
 		struct io_mapped_ubuf *buf = NULL;
 
 		if (ctx->buf_table.nodes[i])
@@ -228,7 +214,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 		else
 			seq_printf(m, "%5u: <none>\n", i);
 	}
-	if (has_lock && !xa_empty(&ctx->personalities)) {
+	if (!xa_empty(&ctx->personalities)) {
 		unsigned long index;
 		const struct cred *cred;
 
@@ -238,7 +224,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	}
 
 	seq_puts(m, "PollList:\n");
-	for (i = 0; has_lock && i < (1U << ctx->cancel_table.hash_bits); i++) {
+	for (i = 0; i < (1U << ctx->cancel_table.hash_bits); i++) {
 		struct io_hash_bucket *hb = &ctx->cancel_table.hbs[i];
 		struct io_kiocb *req;
 
@@ -247,9 +233,6 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 					task_work_pending(req->tctx->task));
 	}
 
-	if (has_lock)
-		mutex_unlock(&ctx->uring_lock);
-
 	seq_puts(m, "CqOverflowList:\n");
 	spin_lock(&ctx->completion_lock);
 	list_for_each_entry(ocqe, &ctx->cq_overflow_list, list) {
@@ -262,4 +245,23 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	spin_unlock(&ctx->completion_lock);
 	napi_show_fdinfo(ctx, m);
 }
+
+/*
+ * Caller holds a reference to the file already, we don't need to do
+ * anything else to get an extra reference.
+ */
+__cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
+{
+	struct io_ring_ctx *ctx = file->private_data;
+
+	/*
+	 * Avoid ABBA deadlock between the seq lock and the io_uring mutex,
+	 * since fdinfo case grabs it in the opposite direction of normal use
+	 * cases.
+	 */
+	if (mutex_trylock(&ctx->uring_lock)) {
+		__io_uring_show_fdinfo(ctx, m);
+		mutex_unlock(&ctx->uring_lock);
+	}
+}
 #endif
-- 
2.39.5



