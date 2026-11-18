Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035680;
	b=5VvBea8DKlDQ4VmsK+RnxScWCDq0T/kOUmuOzblZ6JdtiTIpNvzFdcskMAQM4cEDC0C0
	 kvNkeRCfXqwZNS3jqNqjXXUvhPIbNK4JWC50+N0A+3cWTXaM0fIubVhMtAqdaHlguiP8r
	 9nCBilM6OcTk8gJ5I6jbWc3HYXjSA5sEWdr5X1TNxRnGk4reZi1HT4+MQ/gCR9YkjnjwX
	 fUqP+6WXorRjcGcbWX0RlgQ5Z0IIR+3FbO00GU7vNXbYJz7zwuMgludBEdFcpuZA+SQLk
	 Cvb4GdwaVIL2Ve1Zi54rucNCbGW3HWO0+QTR/sySo7D9PeAKLrNBrr8ncj04jb4wuDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E0hpFCWJKCQiC9nH2fNb2edDH4S2WPbfN9uXZEqqGDE=;
	b=k0LZUtrx1tMPW80QNMppnX8uENWc6e6j8l8mjgbqiVi+prR1OBKNSHQvev9aDdG/dY9S
	 hskaKStm+MVe8c6yAlWgqvllPucu9RJk4RQmJ3+4ni1Wm1TxnV8WnXU+oaeP7/sQz8ovk
	 lt9rDJAAJ3/Ia/N93DERJON6AouF7SQgUmlBTCryZEb5H6cznZEz895qx1S8kY3jvplby
	 PWi5wajVVWcHzoDIhHqQhZIx5Jp/sibIubpTxyA3x9ydgHHZcrGKEOx17KSQB4EVuHYb4
	 wgRld5TvSzmLWx8jMzFZshSB01uN7aTYyeJaaVG1bWajgHJMHprDWAy+5VgNjgz210g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0j9wOfl7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB7160A2612;
	Wed, 18 Nov 2026 21:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0j9wOfl7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8378D1F000C4;
	Wed, 18 Nov 2026 21:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035680;
	bh=E0hpFCWJKCQiC9nH2fNb2edDH4S2WPbfN9uXZEqqGDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0j9wOfl740AI0jJSjazu7xN2yZVURgWhsaxNb7zQNC8BY8EXNnlBDiL/e3M4NX2eC
	 zq7I2vZe9cOWyK68KezGyH7gkjhagfXUfzR1MMwyd8vcqatIpFohBAk9oee7AdWjec
	 /voAowhATl2zggqyNMGOHTCxoC9Ktcgmm3uFZOKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 0749/3318] io_uring: charge tctx nodes and personalities
Date: Wed, 18 Nov 2026 15:22:51 +0100
Message-ID: <20261118150341.104723106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

Commit 0b34e7b20a48710b6f53716bf7030920b69fdbdd upstream.

The io_tctx_node allocated the first time a task touches a ring, and
the XArray nodes behind tctx->xa and ctx->personalities, are plain
GFP_KERNEL. tctx->xa is indexed by the ring pointer, so nearly every
entry needs nodes of its own, and a task gets one entry per ring it has
used. 642 threads on 4000 rings held 2.3GB with 59MB charged against a
64MB memory.max.

Allocate the node with GFP_KERNEL_ACCOUNT and set XA_FLAGS_ACCOUNT on
both XArrays.

Fixes: 0f2122045b94 ("io_uring: don't rely on weak ->files references")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[axboe: 6.6 has kmalloc() for the node, inline in
__io_uring_add_tctx_node()]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 io_uring/tctx.c     |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -319,7 +319,7 @@ static __cold struct io_ring_ctx *io_rin
 	io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_async_msghdr));
 	init_completion(&ctx->ref_comp);
-	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
+	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1 | XA_FLAGS_ACCOUNT);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->cq_wait);
 	init_waitqueue_head(&ctx->poll_wq);
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -93,7 +93,7 @@ __cold int io_uring_alloc_task_context(s
 		return ret;
 	}
 
-	xa_init(&tctx->xa);
+	xa_init_flags(&tctx->xa, XA_FLAGS_ACCOUNT);
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_cancel, 0);
 	atomic_set(&tctx->inflight_tracked, 0);
@@ -125,7 +125,7 @@ int __io_uring_add_tctx_node(struct io_r
 		}
 	}
 	if (!xa_load(&tctx->xa, (unsigned long)ctx)) {
-		node = kmalloc(sizeof(*node), GFP_KERNEL);
+		node = kmalloc(sizeof(*node), GFP_KERNEL_ACCOUNT);
 		if (!node)
 			return -ENOMEM;
 		node->ctx = ctx;


