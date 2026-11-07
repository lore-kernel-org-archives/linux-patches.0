Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061807;
	b=f+wGjFsOej6T0YOCMdcifPXz6b7wtgxiavRCtA7xAzSlpmBIvhoaJlQBcqcjrxlympaX
	 LqH3wmkcilIeHiNOh6YwoB3lEtThr9Kb32mJ6UakyNrkOG7VS4tG9XOrjr1/P+C5l1GLH
	 mG5LNhzLlttzEFad0wsq+rqEn/cpm7lpymMbXAv9cXxfpnULHMTODhdmXPbtTUjzCLvsm
	 BffLedG+GV0S2w+O/hENsdvUtZqvNBDyx5YoC+j9ip2D5CDHzRbuhNLXx+bTXd31Nh019
	 BzAj59m2hxCl1nzYBP0GHdxGCnPe+9lp8pYvRaoeDhw7TDmASG8fQwl9YwNGiiXZR9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y9KEedD3QxTjTeilx2ceTFL2sGW3eq38RhWviusFcxA=;
	b=aLSZEDC1uC9sW9x7Brv2XSnuKWDIc57cHXuke8Nudco3OAff1DjYq60VjtQwil9chem+
	 eQsmLxHaZI3Qlu/tk+ql+6RsDHmDTCMlhJwpltZ5cH3yjq0URoGW1jvpwYlRh0GTS/sZu
	 p1yu/WLyX0yIMfKrOVkkFFW92oZEuUnF/lQNVCcAk10hyYVZvNJK8DXChTTfDl1Imd0+I
	 YMTsX1tWDa95Wf0fwN6/WcA4RvkIpMK3U4hEuQIyJ5EH1gYa+DaPYe5VQdVNn2aIsB/7v
	 1xXoZIGAXuzkKItCi9AHE9Dmt5TpDZDQuxLH0cgmrcrB5lNyMJ9XfWbQ7fwRNgnAGIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SCcqWbe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AA5606A333;
	Sat,  7 Nov 2026 14:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2SCcqWbe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C391F0089F;
	Sat,  7 Nov 2026 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061806;
	bh=Y9KEedD3QxTjTeilx2ceTFL2sGW3eq38RhWviusFcxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SCcqWbeEaeFT3zdPvi2UEsZWU/FGAaEXea7K2O9jERLvNVVcpsfqyGc1pETGX4Ez
	 TV9n7ealKYv01SviHLppdzf473Lje62G6VrvJUud/9FDrJr9YPkzRTZDEJ3Q1i37mD
	 y8aXPyE1AyDIk+gsu9oVdP4bRpD9NFtebVd9BBdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 0834/1536] io_uring: free XArray nodes left by a failed store
Date: Sat,  7 Nov 2026 08:47:30 -0500
Message-ID: <20261107135020.972586728@linuxfoundation.org>
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
[axboe: 6.12 installs the tctx before adding the node and has no error
path that frees it, drop that hunk. There's no ctx->hpage_acct either]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    1 +
 io_uring/tctx.c     |    2 ++
 2 files changed, 3 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2856,6 +2856,7 @@ static __cold void io_ring_ctx_free(stru
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
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


