Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044692;
	b=FXmSwMLGuQMYXCe4YPiMy+49SyJ9y2EXRD5ClGySQ5cFkGQb2n4nD8eA+gsBRVLPsY3n
	 zZbTsGGfenXWV7NeToQuFjCbGCsB8CHFugdl60O6j33UXUbE0eWCWDGqFlU7LRsrf9tDf
	 o9UGG97gUpFkrd6YDQhDrS37GzSa08y+NM+HdzVwuSifk1h10wIamVFRqko+95drf63co
	 FIm9eqeOK9ZJJZ/KT3J3AhVSS3gbA7iGVkhevCqgvYPXx/xMtSgdQjG8aRA2jssuTxchJ
	 2p+4ouEmj0Mf1udI1oTO4L3KLOhKcl+HenQilnmv/S1vDTiHrTtMm+/Ttz3rejRbNtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ziOHj64kOLtge4F6B8K0LBr3kTXlT0Oel4tytHglj+k=;
	b=ScHI9mDUAE8CAPZ+/ZQQOMdjkZLCJ2Tk1zr75voHHWgWoqNPwAWXU6NpgxkKMcrmnwXC
	 K9UfcLnLYeoC+2dAcFasRqfxxawRZEZx9xPQpomlQEVQENto+63Nxv3w2v/V/i3HWKsCI
	 SJqvkKbyW4sKYEYfj6DuIfwZfW080UMOsrUce/MpZNIgkL0+2dTj0viieCdL8BhhBVcz6
	 y3zB1bKnumd5w0IDlF+F3kIoWGEzlujHVC4zBPTasqVvSZSqBxODF9qBX2NdNCcoA6PCE
	 6eQTqXXu+buGnqubuSQzS0yD3OqwNLnD9WOZ/01AJaf0/zVvGgHOlW+Jhuo5xm3YxGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfM8gqUt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF72606A325;
	Wed, 18 Nov 2026 23:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfM8gqUt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E93D1F000C4;
	Wed, 18 Nov 2026 23:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044692;
	bh=ziOHj64kOLtge4F6B8K0LBr3kTXlT0Oel4tytHglj+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zfM8gqUts0nDq8MAfgCNZeeMsMp4eLQ6sorMpKlCHB8YvAExPR5wDItMldrxXB59I
	 Qx0dhc27oVYZ9fMSmFFFCPj+Z7FC4vhAZux6lS0HDU/Xpevvi963XNZ8bgj9MTspMc
	 kvEtr6hZDzIaobcg3t1Y8XbbIS88+L8c97WWjwbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0657/2857] io_uring: charge tctx nodes and personalities
Date: Wed, 18 Nov 2026 15:28:11 +0100
Message-ID: <20261118150225.210388318@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[axboe: 6.1 has kmalloc() for the node, inline in
__io_uring_add_tctx_node()]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 io_uring/tctx.c     |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -299,7 +299,7 @@ static __cold struct io_ring_ctx *io_rin
 	io_alloc_cache_init(&ctx->apoll_cache);
 	io_alloc_cache_init(&ctx->netmsg_cache);
 	init_completion(&ctx->ref_comp);
-	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
+	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1 | XA_FLAGS_ACCOUNT);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->cq_wait);
 	spin_lock_init(&ctx->completion_lock);
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -93,7 +93,7 @@ __cold int io_uring_alloc_task_context(s
 		return ret;
 	}
 
-	xa_init(&tctx->xa);
+	xa_init_flags(&tctx->xa, XA_FLAGS_ACCOUNT);
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_idle, 0);
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


