Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970EA35F04;
	Fri, 24 Nov 2023 19:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2nrMGtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A58C433C8;
	Fri, 24 Nov 2023 19:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852952;
	bh=D6mAYZneYMA5QejgN4mgqe1l6DNaOsYjVd/RoETVmHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2nrMGtQqK2tQO2MhUKOpur4ivb0TEFpRA82MYiXF1u5Zau9XEMlRYlCkqHwTxR5b
	 DcnDv//5VPfGWKt/QB24QiO0rPwc7sojKtmPqm6t+lK+lG1879jE+ckb2SNWA6mfb6
	 UnMPjEMvGaN6AIvj6m46qU3EYKYXgwW3LWvqXXHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	He Gao <hegao@google.com>
Subject: [PATCH 5.10 188/193] io_uring/fdinfo: lock SQ thread while retrieving thread cpu/pid
Date: Fri, 24 Nov 2023 17:55:15 +0000
Message-ID: <20231124171954.709375244@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: He Gao <hegao@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -10238,7 +10238,7 @@ static int io_uring_show_cred(struct seq
 
 static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 {
-	struct io_sq_data *sq = NULL;
+	int sq_pid = -1, sq_cpu = -1;
 	bool has_lock;
 	int i;
 
@@ -10251,13 +10251,19 @@ static void __io_uring_show_fdinfo(struc
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
 		struct file *f = io_file_from_index(ctx, i);


