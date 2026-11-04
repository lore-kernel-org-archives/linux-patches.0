Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831888;
	b=P2A/lJimAiNmF+afclPA5NXZSiwE1c3wbbf97c2wfSw1YhZF4za6M0MAJEGlBCBSoq06
	 BBMN8RU1DeXK4GmApDvELqzofy0fEOrLFcd+UpVxhNiqjLGhpkCSlC+exuuEm/YOQMu3T
	 YxA/79zcmT3iUj5W+zlq2DYtZUHTaIVIC2Pnu5XouGnFL8dooc43g8vE6altd+FkIdhV8
	 kYyQeRQpjqb3vAegRptxtbpvKigVqNQkvH6W2xji776nOs0yIvVJHzWoY2JBPKJz70zuJ
	 +7PiZsmONWkLRwxbujs3Vf8ngJFQIY0AI8AvErxjIU+N5PvS9jeRxDeIrRCHc8lTedA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GrJK+UXOInoc+uYPSouWcpH8UnnoDVBSmxqnyMZv1KQ=;
	b=1rp3tIRFmEYtSsePnkQrgVNBFd1S2CwclqNKvzY/U7dJsbGIJ8ZQzQiGnx9uxIoziaCc
	 mO9EhdiAliGpAoDp3XmFpGgbZ7oOh2/xzvqAzDqxbEVNHBEx6jsNxtIkGUSN3ETyjEj8I
	 fi2cJsVdaCd+blja1M3qs7MMwyOc93PGT2w8hJeq5ZXhs4+qqsgcu02oSyisg3wRyCias
	 ikhWboFbsDW7kstYQjFUFkOJiR3098I7XIHZmlm7TDsZQo4bvRl3icki78hMrPijRLJxq
	 2XhgVU0gLSh1XHc6/1lBxbiERGgqfLDdSF1k3vsTAHKX+ixXFSYoEN6SjdMTBEUTfwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a7toYTe+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA4F606A33D;
	Wed,  4 Nov 2026 22:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a7toYTe+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7751F000C1;
	Wed,  4 Nov 2026 22:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831888;
	bh=GrJK+UXOInoc+uYPSouWcpH8UnnoDVBSmxqnyMZv1KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a7toYTe+aLsPtBPHnpu1Yxq22cmi/kRO/eYE2ul6OaavNrJflCC/W6XICDkDJjszN
	 bzGX2uIhAzDxYWVpkxpsmeipdbztyCKlW9o8SZ+8L5iRtRAwTkj0dSmMIbGsb8qlgh
	 hI8r3x2t3RMxrcpkCOpUK8EB58uAPgSJTZqjLp+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 0976/1005] io_uring: charge tctx nodes and personalities
Date: Wed,  4 Nov 2026 16:11:49 -0500
Message-ID: <20261104211110.396166191@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[axboe: 6.18 has kmalloc() for the node, inline in
__io_uring_add_tctx_node()]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 io_uring/tctx.c     |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -332,7 +332,7 @@ static __cold struct io_ring_ctx *io_rin
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
@@ -91,7 +91,7 @@ __cold int io_uring_alloc_task_context(s
 	}
 
 	tctx->task = task;
-	xa_init(&tctx->xa);
+	xa_init_flags(&tctx->xa, XA_FLAGS_ACCOUNT);
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_cancel, 0);
 	atomic_set(&tctx->inflight_tracked, 0);
@@ -131,7 +131,7 @@ int __io_uring_add_tctx_node(struct io_r
 	if (tctx->io_wq)
 		io_wq_set_exit_on_idle(tctx->io_wq, false);
 	if (!xa_load(&tctx->xa, (unsigned long)ctx)) {
-		node = kmalloc(sizeof(*node), GFP_KERNEL);
+		node = kmalloc(sizeof(*node), GFP_KERNEL_ACCOUNT);
 		if (!node)
 			return -ENOMEM;
 		node->ctx = ctx;


