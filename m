Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829277;
	b=1ZSNfsCdosL3qy0gdcSe2M61fMQdDucl/WsEbU06KCK51N+20FovJhaFIraAZ3527P3G
	 k+pW3HRtO7U0Gwv6HUknaBTlb6IBg/HtW35aJqSOkfGjTBw4jyRKMA19tVbisKCgECl5/
	 Ah1uGnhLa/wxdLleCRMzy566BGxmiDN1JoBL+7kX3BZajFvNfYx1XZ6s2TADIQql73oEn
	 Dm1jluavfnX4MVqPHDKaV+koov2QcChjUTiTlLZl/2ZeQiJRclTPpRTMqoPkZXRczVjto
	 KFjD6jffgYjHMjk03Hz45nLFN4iT+vg7SxqrP7R+367eujFBm8bJbe1Dqa3qSz35Osw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RSNGp9/yjMXL7amfdjr+lO8V9JPJGUSiMPZzxkn7XB0=;
	b=AQpQMabn+HNkrT7hImAcZDXGGm1uJ7kEoPbzAUuJw6/Q5XRSL04z4dxdVBWAYFli9s3r
	 ndS1a8Y/IyVXZLgQEHm5ri5LtlXm0xsmHKuNYDa7czUEH9AENI0l01jFknuHw/vQjp2Ed
	 31RNH25H0SOGO1vQU3j23SBBNdR/lQ6e/vn8SWJZZnU8cwfD+UILl+zXQjGulLex6T9Vr
	 kLL4leNcGjHQOYRCimzgNlZrR4KFxzK5LvCmVHvCUDT6CWcrHP9bca7hwhrnH6qxbjazw
	 /2XdKGr44h9olvnDSEnilUohUNNBT9U25bTt3bMBgkJ/B/rjtM/bRaRPe8JUjQkW/AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fY7+0B/3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A822A6070AA2;
	Wed,  4 Nov 2026 21:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fY7+0B/3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EA41F000C1;
	Wed,  4 Nov 2026 21:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829276;
	bh=RSNGp9/yjMXL7amfdjr+lO8V9JPJGUSiMPZzxkn7XB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fY7+0B/3ksqQTlFXR/rWUM/5l64HZ9mY9a1gDeVKrPEETf2z1AjOXBq8PuZxl/T2R
	 Xe/gvWttG42nV+Z1Z+CLuSyUIwIuBqmQ9BtaNvMxVMCViuZl0GwzedIy7M6WN/y1Iw
	 wn1joA5MYIjawF/I9jTPMkPJ/Uw/upqm+15afDF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 523/547] io_uring: keep the drain active when a deferred drain request is started
Date: Wed,  4 Nov 2026 16:11:47 -0500
Message-ID: <20261104211053.254291466@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit 2295613cd3713beffc8665e956135a5d48dfc208 upstream.

ecb6817b769f ends the drain when the dispatched drain request has posted
its CQE and nothing else is deferred. But the deferred list is processed
in between, and if the request it starts is itself a drain request, the
drain is over before that one has even run. A request submitted after
that point then runs ahead of it:

  1. P0 in flight, D1 and D2 (both IOSQE_IO_DRAIN) deferred behind it
  2. P0 completes, D1 is started
  3. D1 completes, drain_done is set, D2 is started, the list is empty
  4. IO_RING_F_DRAIN_ACTIVE is cleared with D2 still in flight

Anything submitted now bypasses the drain. The same happens with D2 as
the head of a link, as those aren't tracked in ->drain_req at all.

Have io_queue_deferred() report whether it started a drain request, and
don't end the drain if it did. Starting non-drain requests and ending it
is still fine, they were only waiting on the drain request that just
completed.

Fixes: ecb6817b769f ("io_uring: end the drain when the drain request completes")
Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/io-uring/20261027043323.98916-1-kmehltretter@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -474,9 +474,9 @@ unsigned io_linked_nr(struct io_kiocb *r
 	return nr;
 }
 
-static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
+static __cold noinline bool io_queue_deferred(struct io_ring_ctx *ctx)
 {
-	bool drain_seen = false, first = true;
+	bool drain_seen = false, first = true, drain_queued = false;
 
 	lockdep_assert_held(&ctx->uring_lock);
 	__io_req_caches_free(ctx);
@@ -490,17 +490,21 @@ static __cold noinline void io_queue_def
 
 		drain_seen |= de->req->flags & REQ_F_IO_DRAIN;
 		if ((drain_seen || first) && ctx->nr_req_allocated != ctx->nr_drained)
-			return;
+			return drain_queued;
 
 		list_del_init(&de->list);
 		ctx->nr_drained -= io_linked_nr(de->req);
-		/* it runs alone, track its completion unless it's a link */
-		if ((de->req->flags & REQ_F_IO_DRAIN) && !de->req->link)
-			ctx->drain_req = de->req;
+		if (de->req->flags & REQ_F_IO_DRAIN) {
+			drain_queued = true;
+			/* it runs alone, track its completion unless it's a link */
+			if (!de->req->link)
+				ctx->drain_req = de->req;
+		}
 		io_req_task_queue(de->req);
 		kfree(de);
 		first = false;
 	}
+	return drain_queued;
 }
 
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
@@ -1227,7 +1231,9 @@ void __io_submit_flush_completions(struc
 	}
 
 	if (unlikely(ctx->int_flags & IO_RING_F_DRAIN_ACTIVE)) {
-		io_queue_deferred(ctx);
+		/* a drain request started from the list keeps the drain going */
+		if (io_queue_deferred(ctx))
+			drain_done = false;
 		if (drain_done && list_empty(&ctx->defer_list))
 			ctx->int_flags &= ~IO_RING_F_DRAIN_ACTIVE;
 	}


