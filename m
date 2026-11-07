Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061853;
	b=5eFV6whCBmyon4ZHzgr2OXqf5t91d6J6/oX730kfuwmPQIfAJSB2oHxpAxlvaBJkblsu
	 XB9VWn7SFypWttvhJNPnN2t956wTyD8tFkmPgh1+2zddi/PxLElxk/WCvtch7FyWtenkx
	 30pH8Lw488aqR4eEWqWjEbLzwPYCZzH60DDI54bx09B4GuTOT/T6BLHxXT5Uv5gkDr0R/
	 Zv19c/MzPxhavoWmJkVOmkCYfFPam22+0BJRP1z/f3nwQrJZBZe9+N66coFN3X42Bs7vo
	 1s+bNTZxgqh6ubuWRp/midkjx28lWjDCKbfmWj5OiJ2ENr4F1WVoToZLurz4qH+dRwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BsyVYpBTnARU4e9nM2Kdbv55HRXuiZy2gtqxRzzURiA=;
	b=pOBCmiZYK7OwjTN7s0ikyurxictHkudsnWQD7ydbbelWm88JZGtUJk0mPPTIX8AKPXE3
	 m3qth2id5/wJao4eFC2RLJaNRu9qBeU+ZEziq8m1/CsmYuy/gLBCHPzh1uQxNMSEZLinf
	 G+m8PAkgQtPxnLlEq4Au1HoojyRBIFNQvUCl3WS1T4RQm94XZttOIYlrAirHOGghubR5O
	 VAbeBifCcAtKLNDKCsYG11gNHJXJx1Xc6DUHoCu/8ky0cM/A1CNlQvsN1y3440OQHgcSw
	 ax9jyCY0+otqsL5KBCwl0g+gId85UUf+3oqy6YmhtJTP5TNCqUV8z0xxiHS2r9qYtpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZRXlTg92;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD13A606A32E;
	Sat,  7 Nov 2026 14:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZRXlTg92
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1F71F0089F;
	Sat,  7 Nov 2026 14:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061852;
	bh=BsyVYpBTnARU4e9nM2Kdbv55HRXuiZy2gtqxRzzURiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZRXlTg92TNJcXxiZ2NA3Eex5F2XmcpkqPWHoUuAE6y/0OdyK25Nh8XUsDfLllmQxF
	 UY0SQ90VQsvNm9FWYrUSguWaICgP8Ai6MuSa+DHZ695/pdKHd6SY0ML01y2eafUbnY
	 sHui3kkMqJkWOeb63c70bhbpsayrxVCE6IJC8Vow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 0833/1536] io_uring: charge tctx nodes and personalities
Date: Sat,  7 Nov 2026 08:47:29 -0500
Message-ID: <20261107135020.944640957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[axboe: 6.12 has kmalloc() for the node, inline in
__io_uring_add_tctx_node()]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 io_uring/tctx.c     |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -319,7 +319,7 @@ static __cold struct io_ring_ctx *io_rin
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


