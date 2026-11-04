Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829223;
	b=f11aO3KRJgA5dw3OrJ6eLlyaT6vXiISnCTxTR6z4e89DUlpsN7bQ9323WM0o29z+YRQi
	 /iMfqFs8F0OOQdTxQfIgrjyJZBiDhy+MilhoQsZtwLHdfDJGYzwCDbJz88p1lEPHncgwr
	 nGMNzT9yMKRow5+56L5jU1X3ju1L4LeNG0LgNUKlWULajy6h8dm0o/5eGwZAzSffED74r
	 diI8FlxvBwqBQkLLbpKQuDUOws4Z81XhS8P8vXZI2BYSl4WjY+IKW4HHHIP1rNgyT7C4/
	 fz/IJITxsErIfxsssxCB0bL5gXcP0hGAUj/lR0znsAWkIrQXcjYo2i9If0X95F80ZhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7T3KZ2O2hrOoBiSGn29wtCVrB8FZDG/HTIUcV73uP+4=;
	b=U34NenoSLcd6h5qSlbKCMBLvx/6dtmB+fkWhP5ZKPSd9Y+dnZlH2tAvnEuY7VDTjeAkX
	 hv7Zm/ilNX4QUTbXSXuCt6ouSLxI4Ij0slkKK5DiTG/UES7SQnFYLGFQZMXc9nbCek6bn
	 mmk1lXhHw/P24GVlnb5iYbgm0qsv9q/fauJeqoYnH1R2F/EfgFhSnJ+6wbSTxYEkBtIx7
	 NyGxaEPXUpAozqBEvC53U8QEvOb6HHu4pQWm936W1fBJirz/7BkfXqSXfTl/MkOs9wqQ0
	 WpvJZb/SU94FPH84O8sl0FAVVc0ZH2XTt7CYBkRRSwDyjrMR6HJJYfc0bHfJkAdLGuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qti4v9zj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0C46070A88;
	Wed,  4 Nov 2026 21:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qti4v9zj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F1C1F0093A;
	Wed,  4 Nov 2026 21:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829223;
	bh=7T3KZ2O2hrOoBiSGn29wtCVrB8FZDG/HTIUcV73uP+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qti4v9zjLyTwbmn9lMgc0slfdi0XyybP3MwIQaZN/kOzb//xMf6LRloBIuO21DWE6
	 JboJOMAHnvv8Lb2Z8hWcVABAgvu1M0aD0PICCLT0Aq2Mxk3EU52IZk13izS/DLtzSO
	 kzsS4E2owkuXvmR22Qcrxqhs5mBPNx+wT9aMJu/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 526/547] io_uring: charge tctx nodes and personalities
Date: Wed,  4 Nov 2026 16:11:50 -0500
Message-ID: <20261104211053.337390320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 io_uring/tctx.c     |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -271,7 +271,7 @@ static __cold struct io_ring_ctx *io_rin
 	if (ret)
 		goto free_ref;
 	init_completion(&ctx->ref_comp);
-	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
+	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1 | XA_FLAGS_ACCOUNT);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->cq_wait);
 	init_waitqueue_head(&ctx->poll_wq);
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -104,7 +104,7 @@ __cold struct io_uring_task *io_uring_al
 	}
 
 	tctx->task = task;
-	xa_init(&tctx->xa);
+	xa_init_flags(&tctx->xa, XA_FLAGS_ACCOUNT);
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_cancel, 0);
 	atomic_set(&tctx->inflight_tracked, 0);
@@ -123,7 +123,7 @@ static int io_tctx_install_node(struct i
 	if (xa_load(&tctx->xa, (unsigned long)ctx))
 		return 0;
 
-	node = kmalloc_obj(*node);
+	node = kmalloc_obj(*node, GFP_KERNEL_ACCOUNT);
 	if (!node)
 		return -ENOMEM;
 	node->ctx = ctx;


