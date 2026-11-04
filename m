Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831894;
	b=UjxOKc8xzfuNx393D1VnMprbsTguNRItjP1cFg+lGcE5JP72PzsiKk1YP4RYefzvdPLA
	 F6sSlJM71tKq4DS4b6CLgGuW9AJqaYTIE7n8LCcuSrezRlqIgSp+vBnM6F3QyinkgfcLQ
	 yBzQvs3AUI4lMY9efMum4Kf5Kn2vqRTmKRE0U3j1sRlG4T/JvNlsHjz012O6SnTv+4Bxb
	 0ID6Xrq7juOQjt/LPxSlWqDqQwJ7GOWPU33pUAEYIXVOJ4l6+M50ePjrHWu8QyOngKSf+
	 8rdPUdl6RHbbVP/pMLZszsnT2eAE0Z3DZ7qD/PD5Qfahy2UH1+/F9qycwECdR3J3APw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nF6F+CLAYXepSes8nOzv08Mugfvicsxe5fjbGeIVMzo=;
	b=x/S0VORtEzcBaLDyl1CcXD042XBJbFpQ6IpPUCYDLeiBMdnC3gc9ECeX1T0fUARu9Qgc
	 NllXEA2wL5lslP4zXXrOlcUPfaUjzvsnIt4yppDZT8sSC6QoNJF6vWvGLic8xeFtYuOSO
	 /RVwuurDbIAfWGHvliT2t4AofEnoZy9LGSHJC+BO0VHnfdGkLWZv80wAnvrNH0vj3xi8T
	 bQcx9aSy0gaDaAwf63agNZaowCC1k+2ZfIYZjFTMNKoXgjsP36n+pVsXHfl53OjrUERtV
	 wdCAlGoje/YF2uCydDYL50KHYu/wvJ+AAHGyUP8u9UgEIiPEwF3kAMTXZ126XvpVa8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EF4cAw78;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DF3606A858;
	Wed,  4 Nov 2026 22:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EF4cAw78
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C2F1F000C1;
	Wed,  4 Nov 2026 22:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831893;
	bh=nF6F+CLAYXepSes8nOzv08Mugfvicsxe5fjbGeIVMzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EF4cAw78BFnMP0tGadTdwaOUgKWeZpWLSYmtuVuEPGXAW6DcQ8puwN9xX1cJL53Ll
	 vKFlzSZ9jMVem0yXZ44baVQYrPOmhr+ObP6+VyVTYnTUJvp80bwN7TvgslhcXP7eps
	 azueXcQ6/trkYOjRrAinh7LDZ302CqGotah+yP2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 0977/1005] io_uring: free XArray nodes left by a failed store
Date: Wed,  4 Nov 2026 16:11:50 -0500
Message-ID: <20261104211110.420677798@linuxfoundation.org>
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
[axboe: 6.18 installs the tctx before adding the node and has no error
path that frees it, drop that hunk. There's no ctx->hpage_acct either]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    1 +
 io_uring/tctx.c     |    2 ++
 2 files changed, 3 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3039,6 +3039,7 @@ static __cold void io_ring_ctx_free(stru
 	io_napi_free(ctx);
 	kvfree(ctx->cancel_table.hbs);
 	xa_destroy(&ctx->io_bl_xa);
+	xa_destroy(&ctx->personalities);
 	kfree(ctx);
 }
 
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -206,6 +206,8 @@ __cold void io_uring_clean_tctx(struct i
 		io_uring_del_tctx_node(index);
 		cond_resched();
 	}
+	/* A failed xa_store() leaves nodes with no entry behind. */
+	xa_destroy(&tctx->xa);
 	if (wq) {
 		/*
 		 * Must be after io_uring_del_tctx_node() (removes nodes under


