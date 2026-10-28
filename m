Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207394;
	b=3fzEPOnK3cKpTH8mqmqZ8d7IKgFLlKl7Oi+Xl3Be3u51jlAt0CjInalwySDA5Ylnzxjh
	 LO6MGSqYjTG9yz7XBz4XbSIlzJbDn3Imzajy1VYvx1G1+9Qta79cqBOM97ti+d5EmxY5/
	 Zw06YHViVb0TE7axcP1PoRBNULU6e1gtgAPw4Wq3gEcUHVTi0OvQvWPkXVkDY72vk7ZPR
	 K83PbgoVeb7M88/YLHe+vlcYZnIJ2qvCxsx2DkbYOUE8N0gQOfp5QBMQXxeGSoGQ1wzx4
	 y72v9EATsB7RMMEc4SzCTjdugOhtzqb23rcJLbj2mhKVyunJzUk+MdVAIPN674cPDIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SwrzfX3TNFgmtxPt0wZaCf9imRxTMJpzotC+ORVbGkM=;
	b=pAJ7OBslUBc6Nh/cGRftJidVDQJYYTQKM87tIYz5R1OUCGNUeiA00lH5w6jW7qn/kBSC
	 fVGmAreKJWA0S1QFVHlvvuV071WDslQ4Sv0W9uGTYSq/ue0axEUbAF8jY3pqUX/Mw688N
	 LJttOPjKpUwKkO4qxpLqPqtECioLH1kzCEGWfy6xRXq5zvqU6P7L/3A6LkZDQR8f/y7EM
	 nB508r+GR47WQwbRbQS8rPsyXka0BRDjlz/vZfaQ5pa+SAlomiGBLZrrmeyZciKVHwgkV
	 Oc4LgvY2c/OO/natUyzBcZ3ZiEBs/KoLZlgnaE158LbQWrTqUKQIExhEU8pKxDkmP4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="F0lD/bjg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42025606A31A;
	Wed, 28 Oct 2026 17:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0lD/bjg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AA61F01825;
	Wed, 28 Oct 2026 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207394;
	bh=SwrzfX3TNFgmtxPt0wZaCf9imRxTMJpzotC+ORVbGkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0lD/bjgYdVSRrXCvMt4w++CBgvYyV7lP5NBvmqKlL2rciTfcNa8zw9f6N+rco2EX
	 Tm7jc5HxrSUFADpof6AVNm89WR59Zwl/CyHuSDeo1ZmSjbTVKQK3WccMOlBNUTDpmb
	 I9RNslyZlxl9zkG2kJKWuto+IHUrXfe2MK2ju648=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 69/88] io_uring: keep the drain active when a deferred drain request is started
Date: Wed, 28 Oct 2026 18:00:17 +0100
Message-ID: <20261028165943.740162600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -483,9 +483,9 @@ unsigned io_linked_nr(struct io_kiocb *r
 	return nr;
 }
 
-static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
+static __cold noinline bool io_queue_deferred(struct io_ring_ctx *ctx)
 {
-	bool drain_seen = false, first = true;
+	bool drain_seen = false, first = true, drain_queued = false;
 
 	lockdep_assert_held(&ctx->uring_lock);
 	__io_req_caches_free(ctx);
@@ -499,17 +499,21 @@ static __cold noinline void io_queue_def
 
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
@@ -1234,7 +1238,9 @@ void __io_submit_flush_completions(struc
 	}
 
 	if (unlikely(ctx->int_flags & IO_RING_F_DRAIN_ACTIVE)) {
-		io_queue_deferred(ctx);
+		/* a drain request started from the list keeps the drain going */
+		if (io_queue_deferred(ctx))
+			drain_done = false;
 		if (drain_done && list_empty(&ctx->defer_list))
 			ctx->int_flags &= ~IO_RING_F_DRAIN_ACTIVE;
 	}


