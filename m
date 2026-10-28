Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209883;
	b=IfEsYx1Tw5V/2ltuXfQMitUymifm87k4Gbu4SR2w/kLIBr3D8H3NGDransf77YATQ1Wi
	 uV3COIV+2L6QCdVHjolPWTGwzmY0veKiLFByr4lWEEEDzHdel7sOiG1BrQxMv3d7nyAtI
	 O0eOyfaBS2I9mWwctLRmnv2TTY7AOxnC8fdPG+Mlczz/qPMjeiDD/evaZ0blqPcZS9cec
	 +1tMyGEv2JeY9eriVS3AO3+FqZ5T+tC3rrihlGw3wN6FCIKvy+7kHeYq0lkvrjxHwns1i
	 mDG4QkDecLUtEnwKL0uq+w0CcxNEnpMWYN+cS/UuBt5vvxK+TW4zBNSy/bm2OzTCtng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BcfONCM9hWl1LBC87D1VVeKx0EmVpaA2PKAPxw+63Nc=;
	b=WGmSOC3Kf9HIXMpVGkvsJS2vcBE5QjGo4WAiESFTpkds4b98SQONdz7v8VyFBKdHoOoT
	 Ff3l+ztsnn0FUaTGoudS1QErgtln8W8wC54fYhJfZ5EIYB75kO4Q1VWBh7inrzNcuaDZ4
	 YJRBPpzUsnKSSra7rqj1ZTvrxY1fMq0BLoRHxTUTeqxMOyMx1X8cVYjW0faq0c4xl5uXz
	 tqREYfAMtmJRKWwKZO7OlZWJnnDwbhrDBQWOp0idQFtqzIpMnB9rq4ZANzZesMQUYo0BG
	 fi5lFOu5sOmSKYIsAwvnWAMcFyMqrduYiCZ3A49yHrVK44cMtHMzvr3xZW28kwtVvoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RtHMxNPt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A1A606A31C;
	Wed, 28 Oct 2026 17:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RtHMxNPt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB45A1F01825;
	Wed, 28 Oct 2026 17:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209882;
	bh=BcfONCM9hWl1LBC87D1VVeKx0EmVpaA2PKAPxw+63Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RtHMxNPtQ0wdcqdx9U4hrDeKThdzJUWgmk+FD4wQEstklkzdJqvcnJ3FpGoJ0oDYM
	 /aN8Kbl/edmuCGTRw///6nlogA095+pbxWAyIsY3cKV9EddXhU+21HpEyRTVrjvMcS
	 YZCTVnjSs3nBC2dEI/6i7Apv1v8QtaTPauNXUH0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 090/109] io_uring: keep the drain active when a deferred drain request is started
Date: Wed, 28 Oct 2026 18:01:14 +0100
Message-ID: <20261028165944.473785036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

[ 6.18: ->drain_active is a bool here ]
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
@@ -545,9 +545,9 @@ unsigned io_linked_nr(struct io_kiocb *r
 	return nr;
 }
 
-static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
+static __cold noinline bool io_queue_deferred(struct io_ring_ctx *ctx)
 {
-	bool drain_seen = false, first = true;
+	bool drain_seen = false, first = true, drain_queued = false;
 
 	lockdep_assert_held(&ctx->uring_lock);
 	__io_req_caches_free(ctx);
@@ -561,17 +561,21 @@ static __cold noinline void io_queue_def
 
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
@@ -1677,7 +1681,9 @@ void __io_submit_flush_completions(struc
 	}
 
 	if (unlikely(ctx->drain_active)) {
-		io_queue_deferred(ctx);
+		/* a drain request started from the list keeps the drain going */
+		if (io_queue_deferred(ctx))
+			drain_done = false;
 		if (drain_done && list_empty(&ctx->defer_list))
 			ctx->drain_active = false;
 	}


