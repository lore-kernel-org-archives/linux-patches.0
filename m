Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8864FC06;
	Mon, 11 Dec 2023 18:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1QNNHg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31227C433C9;
	Mon, 11 Dec 2023 18:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320272;
	bh=uoNjS8QDAfixy5pyBv+vt8P8cdcfhyFn1jP5gCmWB24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1QNNHg1EM741tkI73nBf0ByYYwqPZ75HUczHy/KluGa6DyZxsF3+vn1E8WTVSVIE
	 29vR6edi+LZtH3708kh4A0a7i0QPA37PPdD6aN77V1Gy087zSJAyqCqkCws2ZgQS9Y
	 EsRvhLnRrU0TLUbMAVtZe/+cw9HKjOIf7AX7QqOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 5.4 57/67] io_uring/af_unix: disable sending io_uring over sockets
Date: Mon, 11 Dec 2023 19:22:41 +0100
Message-ID: <20231211182017.420293556@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182015.049134368@linuxfoundation.org>
References: <20231211182015.049134368@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 705318a99a138c29a512a72c3e0043b3cd7f55f4 upstream.

File reference cycles have caused lots of problems for io_uring
in the past, and it still doesn't work exactly right and races with
unix_stream_read_generic(). The safest fix would be to completely
disallow sending io_uring files via sockets via SCM_RIGHT, so there
are no possible cycles invloving registered files and thus rendering
SCM accounting on the io_uring side unnecessary.

Cc:  <stable@vger.kernel.org>
Fixes: 0091bfc81741b ("io_uring/af_unix: defer registered files gc to io_uring release")
Reported-and-suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c  |  101 ---------------------------------------------------------
 net/core/scm.c |    6 +++
 2 files changed, 7 insertions(+), 100 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3137,101 +3137,6 @@ static void io_finish_async(struct io_ri
 	}
 }
 
-#if defined(CONFIG_UNIX)
-static void io_destruct_skb(struct sk_buff *skb)
-{
-	struct io_ring_ctx *ctx = skb->sk->sk_user_data;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(ctx->sqo_wq); i++)
-		if (ctx->sqo_wq[i])
-			flush_workqueue(ctx->sqo_wq[i]);
-
-	unix_destruct_scm(skb);
-}
-
-/*
- * Ensure the UNIX gc is aware of our file set, so we are certain that
- * the io_uring can be safely unregistered on process exit, even if we have
- * loops in the file referencing.
- */
-static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
-{
-	struct sock *sk = ctx->ring_sock->sk;
-	struct scm_fp_list *fpl;
-	struct sk_buff *skb;
-	int i;
-
-	fpl = kzalloc(sizeof(*fpl), GFP_KERNEL);
-	if (!fpl)
-		return -ENOMEM;
-
-	skb = alloc_skb(0, GFP_KERNEL);
-	if (!skb) {
-		kfree(fpl);
-		return -ENOMEM;
-	}
-
-	skb->sk = sk;
-	skb->scm_io_uring = 1;
-	skb->destructor = io_destruct_skb;
-
-	fpl->user = get_uid(ctx->user);
-	for (i = 0; i < nr; i++) {
-		fpl->fp[i] = get_file(ctx->user_files[i + offset]);
-		unix_inflight(fpl->user, fpl->fp[i]);
-	}
-
-	fpl->max = fpl->count = nr;
-	UNIXCB(skb).fp = fpl;
-	refcount_add(skb->truesize, &sk->sk_wmem_alloc);
-	skb_queue_head(&sk->sk_receive_queue, skb);
-
-	for (i = 0; i < nr; i++)
-		fput(fpl->fp[i]);
-
-	return 0;
-}
-
-/*
- * If UNIX sockets are enabled, fd passing can cause a reference cycle which
- * causes regular reference counting to break down. We rely on the UNIX
- * garbage collection to take care of this problem for us.
- */
-static int io_sqe_files_scm(struct io_ring_ctx *ctx)
-{
-	unsigned left, total;
-	int ret = 0;
-
-	total = 0;
-	left = ctx->nr_user_files;
-	while (left) {
-		unsigned this_files = min_t(unsigned, left, SCM_MAX_FD);
-
-		ret = __io_sqe_files_scm(ctx, this_files, total);
-		if (ret)
-			break;
-		left -= this_files;
-		total += this_files;
-	}
-
-	if (!ret)
-		return 0;
-
-	while (total < ctx->nr_user_files) {
-		fput(ctx->user_files[total]);
-		total++;
-	}
-
-	return ret;
-}
-#else
-static int io_sqe_files_scm(struct io_ring_ctx *ctx)
-{
-	return 0;
-}
-#endif
-
 static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 				 unsigned nr_args)
 {
@@ -3285,11 +3190,7 @@ static int io_sqe_files_register(struct
 		return ret;
 	}
 
-	ret = io_sqe_files_scm(ctx);
-	if (ret)
-		io_sqe_files_unregister(ctx);
-
-	return ret;
+	return 0;
 }
 
 static int io_sq_offload_start(struct io_ring_ctx *ctx,
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -26,6 +26,7 @@
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 #include <linux/errqueue.h>
+#include <linux/io_uring.h>
 
 #include <linux/uaccess.h>
 
@@ -103,6 +104,11 @@ static int scm_fp_copy(struct cmsghdr *c
 
 		if (fd < 0 || !(file = fget_raw(fd)))
 			return -EBADF;
+		/* don't allow io_uring files */
+		if (io_uring_get_socket(file)) {
+			fput(file);
+			return -EINVAL;
+		}
 		*fpp++ = file;
 		fpl->count++;
 	}


