Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26096208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJ46aQAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9335CC433C9;
	Tue, 31 Oct 2023 17:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774548;
	bh=gp19PSaQSop4kM00JnB7rMmQTj1HseEFfkGNp9qG5LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJ46aQADzputGFS2nPRbJo0CXrZV2Xx5Xr9rF+XwUViVoxw5qgs/5d0QBkP/kfX7O
	 SDY7co+Go9OvfZWGnpxULtSRmjcU7ibZ/P2Vwfvd7qfrVLRSFLblrI7rxZ3H2nLoTU
	 n1IBeehmZbI0ELg/dM1qmNG4HnbAwuHvQ6o3xSV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 083/112] io_uring/fdinfo: lock SQ thread while retrieving thread cpu/pid
Date: Tue, 31 Oct 2023 18:01:24 +0100
Message-ID: <20231031165903.925483686@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 7644b1a1c9a7ae8ab99175989bfc8676055edb46 upstream.

We could race with SQ thread exit, and if we do, we'll hit a NULL pointer
dereference when the thread is cleared. Grab the SQPOLL data lock before
attempting to get the task cpu and pid for fdinfo, this ensures we have a
stable view of it.

Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218032
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/fdinfo.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 76c279b13aee4..b603a06f7103d 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -49,7 +49,6 @@ static __cold int io_uring_show_cred(struct seq_file *m, unsigned int id,
 static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 					  struct seq_file *m)
 {
-	struct io_sq_data *sq = NULL;
 	struct io_overflow_cqe *ocqe;
 	struct io_rings *r = ctx->rings;
 	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
@@ -60,6 +59,7 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 	unsigned int cq_shift = 0;
 	unsigned int sq_shift = 0;
 	unsigned int sq_entries, cq_entries;
+	int sq_pid = -1, sq_cpu = -1;
 	bool has_lock;
 	unsigned int i;
 
@@ -137,13 +137,19 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 	has_lock = mutex_trylock(&ctx->uring_lock);
 
 	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
-		sq = ctx->sq_data;
-		if (!sq->thread)
-			sq = NULL;
+		struct io_sq_data *sq = ctx->sq_data;
+
+		if (mutex_trylock(&sq->lock)) {
+			if (sq->thread) {
+				sq_pid = task_pid_nr(sq->thread);
+				sq_cpu = task_cpu(sq->thread);
+			}
+			mutex_unlock(&sq->lock);
+		}
 	}
 
-	seq_printf(m, "SqThread:\t%d\n", sq ? task_pid_nr(sq->thread) : -1);
-	seq_printf(m, "SqThreadCpu:\t%d\n", sq ? task_cpu(sq->thread) : -1);
+	seq_printf(m, "SqThread:\t%d\n", sq_pid);
+	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
 		struct file *f = io_file_from_index(&ctx->file_table, i);
-- 
2.42.0



