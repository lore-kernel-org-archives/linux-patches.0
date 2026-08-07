Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3486A35CB60;
	Fri,  7 Aug 2026 15:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117371; cv=none; b=JgFbbdAGU0MrBsTH4Pw3ysgFBWF78JBvlu1jPwA5ztMeicLRHrCSk68vvx70d+FItoH2wLuhzg9KMFUZVagzli3Nbd0Ip0yCSzV1V7X/s0dlJWzaDnrnJWwk6Nr5yN7uTy7ZOQktZwT3/ybimiB0tJpHU1G98DOPQDQq1wunG4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117371; c=relaxed/simple;
	bh=KcqZtHL4rBv4f2Pea9WU4xv+zkfoGiqAxynmL1+hvq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9VcoOKolBUpMEfsGRNuleQb33DyVXgf6jqaeVz9mEPE5pm7baYP9SxcKIhOS5vV8o7CHeo3nxiaXs8x2qWe4KS3rVfl2BJTHncyxBMX16rusMJehyn8ooUk0rHHKll2+mIH5QGKjJdBZti7/Y2+kIV5as2BKRnlHMvG7q3QuCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/VOTajC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/VOTajC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD581F000E9;
	Fri,  7 Aug 2026 15:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117370;
	bh=5FqfGmvYwiKWozxmSZZrNp27mhpU8MqQqIJummdhng8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/VOTajC+OtbAUv8Tatfh+1zXFSEGpRlHHF9uD8qFG3zk/Z4FzuSAJmOMPq21PbN6
	 /ys+O4zxip5jx0130iNRg8lpjXFtMfNykqQ8bTCwexGd+uQ0iMu8jFp9aBpwZBFxoA
	 skOW70fqC0tsDf2vlOToYkTvgu9sVgdGDtuj1IwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyumin Lee <fyonglkm@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 294/438] io_uring: preserve task restrictions across exec
Date: Fri,  7 Aug 2026 16:38:10 +0200
Message-ID: <20260807143434.241840054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyumin Lee <fyonglkm@gmail.com>

commit bc0e8faf90e776a2f1f3967a04e8091e6bdb4977 upstream.

Per-task restrictions apply to all rings created by a task. Once
installed, they should not be dropped across exec.

For a task that has used io_uring, the exec cancellation path calls
__io_uring_free(). This frees both the task context and the per-task
restriction, so a ring created after exec is unrestricted.

Split task context cleanup into io_uring_free_tctx(), and use it from
the exec cancellation path. Keep __io_uring_free() for final task
cleanup, where both the context and restriction are released.

Fixes: ed82f35b926b ("io_uring: allow registration of per-task restrictions")
Cc: stable@vger.kernel.org # 7.1+
Signed-off-by: Kyumin Lee <fyonglkm@gmail.com>
Link: https://patch.msgid.link/20260730192734.459247-1-fyonglkm@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/cancel.c |    2 +-
 io_uring/tctx.c   |    7 ++++++-
 io_uring/tctx.h   |    1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -662,6 +662,6 @@ end_wait:
 		 */
 		atomic_dec(&tctx->in_cancel);
 		/* for exec all current's requests should be gone, kill tctx */
-		__io_uring_free(current);
+		io_uring_free_tctx(current);
 	}
 }
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -43,7 +43,7 @@ static struct io_wq *io_init_wq_offload(
 	return io_wq_create(concurrency, &data);
 }
 
-void __io_uring_free(struct task_struct *tsk)
+void io_uring_free_tctx(struct task_struct *tsk)
 {
 	struct io_uring_task *tctx = tsk->io_uring;
 	struct io_tctx_node *node;
@@ -67,6 +67,11 @@ void __io_uring_free(struct task_struct
 		kfree(tctx);
 		tsk->io_uring = NULL;
 	}
+}
+
+void __io_uring_free(struct task_struct *tsk)
+{
+	io_uring_free_tctx(tsk);
 	if (tsk->io_uring_restrict) {
 		io_put_bpf_filters(tsk->io_uring_restrict);
 		kfree(tsk->io_uring_restrict);
--- a/io_uring/tctx.h
+++ b/io_uring/tctx.h
@@ -12,6 +12,7 @@ void io_uring_del_tctx_node(unsigned lon
 int __io_uring_add_tctx_node(struct io_ring_ctx *ctx);
 int __io_uring_add_tctx_node_from_submit(struct io_ring_ctx *ctx);
 void io_uring_clean_tctx(struct io_uring_task *tctx);
+void io_uring_free_tctx(struct task_struct *tsk);
 
 void io_uring_unreg_ringfd(void);
 int io_ringfd_register(struct io_ring_ctx *ctx, void __user *__arg,


