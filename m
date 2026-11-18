Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044695;
	b=y9kUXAC4o/pFjxk00Vwjrpj/4bmHrsBAUKGShAwaeeSZdOPiXdslJaT0lTf7GI6AkWJb
	 e8tuICI2YzVJ9+X3e4G3YBxZzomTcBhBIBYeBkArvSrrljpL3O0CiLlGZArGsOdLxKpnF
	 jTBEkXFQxjRaBSaBD++opJ+OpJCunfIoAVHiFKJi9H12eoAD7RbSIz01skTOOdSeJs77I
	 Kf+wFvQjcSw0TVRy+X3cnr4d4a4SJ2dd01YStTVUdkmcyFKH6k24WWMWcMnl/Irhh1x9c
	 25x7SfLTQGgaBKN/7BVrB4c5R0VPZojbTpS9/Z1R6R8mHTYphFGF2KEOYEnlcef4rxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w3ZbylOcZcaPlj/XEjhZ0H1ccnhn5m5VtTOczeVUMMA=;
	b=PAsgR2FQkDHblNIo7N4Kq8fIsD1LtHE7fVK+GV2T35vZPO9LxJAzoWqd84YTKBE54JHa
	 2KwJNIX4YT6WEQh2Hq83R0M3s/5u1HLZTjCxHj0wp+9OZFqTMY5KfIeEx+ZLkqvogRQew
	 vBzembprlqRaZnR9Gtuw2G+/qEKgaHGnVPvdXfqmUythsb/8AWy6Mk8dOGdymRwIYHLpZ
	 pkHjadC9ZHxmGQgZ5lEJ1YMI0RNIcJWP5IboG6X6vanE7yZkgxwuFiLhavw6sGo4w73PP
	 c+W+PqMEg6unIKSy2LIsOk+B7BXcYaCeI3DdW70fOHJdGH3w7LTodPrNi79pifDjapw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1PTn5nez;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D54606A320;
	Wed, 18 Nov 2026 23:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1PTn5nez
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76041F000C4;
	Wed, 18 Nov 2026 23:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044695;
	bh=w3ZbylOcZcaPlj/XEjhZ0H1ccnhn5m5VtTOczeVUMMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1PTn5nezVKRhNOLS3FKzPElUh7PdP+5r+vG1ScyZINeSPS8eBjdyp6CbhmvwELAdR
	 f2uEsh4Yjudvm44ZtlS7hJltHwhibM7GSxCY8VUohEWMetYbXv1iupOqbM4SiG78Ax
	 tW+43QdW9WYLHEQj3Uu0wF3ghnw7fTGmpay5lfc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0658/2857] io_uring: free XArray nodes left by a failed store
Date: Wed, 18 Nov 2026 15:28:12 +0100
Message-ID: <20261118150225.245670421@linuxfoundation.org>
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

Commit 51bab09b7ca1a9a6dd9303a3b7ee346f8128c963 upstream.

A failed xa_store() can leave nodes without entries in the tree, and
erasing every entry doesn't free those. An XArray needs xa_destroy()
before it goes away, even an empty one. That was dropped for tctx->xa in
commit ca6484cd308a ("io_uring: no need to call xa_destroy() on empty
xarray") over a lockdep report from freeing the tctx in softirq context,
and ctx->personalities never had it.

Now that the nodes are charged, a store can fail at memory.max and the
leaked nodes stay charged. Call xa_destroy() in io_uring_clean_tctx(),
which the task runs itself in process context before the tctx is freed,
in the error path of __io_uring_add_tctx_node(), and for
ctx->personalities in io_ring_ctx_free().

Fixes: ca6484cd308a ("io_uring: no need to call xa_destroy() on empty xarray")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[axboe: 6.1 installs the tctx before adding the node and has no error
path that frees it, drop that hunk. There's no ctx->hpage_acct either]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    1 +
 io_uring/tctx.c     |    2 ++
 2 files changed, 3 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2797,6 +2797,7 @@ static __cold void io_ring_ctx_free(stru
 	kfree(ctx->dummy_ubuf);
 	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
+	xa_destroy(&ctx->personalities);
 	kfree(ctx);
 }
 
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -197,6 +197,8 @@ __cold void io_uring_clean_tctx(struct i
 		io_uring_del_tctx_node(index);
 		cond_resched();
 	}
+	/* A failed xa_store() leaves nodes with no entry behind. */
+	xa_destroy(&tctx->xa);
 	if (wq) {
 		/*
 		 * Must be after io_uring_del_tctx_node() (removes nodes under


