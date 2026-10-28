Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212181;
	b=Io7qKppd5u9QorP3Vak7eJFNtL2BOB/puTtG/nRdfX619uKCm4P5SC0StSmlrSjcu6N9
	 uwGpZhkMivV6/1U5nM6W+BcIUCts8RoWRdM5M2w+lcD5To7hPxY167nvnWjwBjBjyGIsU
	 p7p2tX2jJF2S3c4XLn6bxziD496EYJm+nbrK8oNhpt7KNsmt9watstA5v2MgJXEqzVGU+
	 d+pS6h3G4496kgcUVKC89SlPMhP7w/vyMd5B1oovZ4AqaiA0DLaTq6Vky+w6ad3nS6d46
	 n5SFDB5Ma9BCWYLksZTapmQy0VfAaitfYzBaZpsK4lVVk7qVV466cikdGi+M/eLuE7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bKC34CS+xFbMcX8uYLw5RA6B2CABgjPrKBkjoBuALKc=;
	b=MFM6J4AbFUm+3kJlu9K61i7KswqFgHtQPKOQib56AEUHE335z9bSOq3ygZx4lBpjOiod
	 VuRLZZEEDspHJ+mTmd/6nnNjm2guDDuErJVMHMnz4LqY59OC+xFoPPJxTx8kSSEyXFBTm
	 kPG+1I8m8nXaafo/Ib6tOqhHbkr724IXbBekZo3WPfn/t4P2lETZIcEAjIpwtfajTjkqp
	 DGzfSaZKwI1Ip43m/wvc9BcUBh860dr7/ArWr3A+YZzPtQfvWPfDOU7WAX0w9swwgly5d
	 QRNghL+dH6Wp5S86QZaYp8tU2W0butnQw9MHa3THlHH3a4WTXB8LXC+6D1pIme5a52A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0YZd6OAJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B0C606A31D;
	Wed, 28 Oct 2026 18:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0YZd6OAJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9BE1F01825;
	Wed, 28 Oct 2026 18:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212180;
	bh=bKC34CS+xFbMcX8uYLw5RA6B2CABgjPrKBkjoBuALKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0YZd6OAJoeZ4D/NHOR74C/RjPpcORI4KJb5YA4lqFjZuUNTbkQYjvQXJc9YoxXQDV
	 nGHRiE+YYDF+tTvGZrVr49BeQhPaac5jGS6iyNSi+ipxIoq1tWhV8zg/rJROdSgJRg
	 zZ5j8vdoAwuXE/tY3PGhwUaTA8nJbMt8IiXAVCoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.1 0022/1887] io_uring/poll: dont loop on HUP with multiple references
Date: Wed, 28 Oct 2026 17:35:18 +0100
Message-ID: <20261028170459.727163029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit cf1d5c9d335e2c673811da641531da82cb01393a upstream.

io_poll_check_events() drops down to one reference when a multishot
request sees HUP with more than one, so that the loop goes around once
more. It did so by subtracting one less than it had. With the cmpxchg
that only takes the local count down: the exchange fails, the next pass
reads the unchanged count, and goes through the same motions again. The
loop then only ends once io_poll_issue() stops the request.

Drop the extra references from the counter instead, and loop once more
without trying the exchange. The next pass sees one reference, like it
did before, and ends unless a wake up came in.

[ 6.1: v still carries the flag bits here, mask it for the subtraction ]
Fixes: 937d38dcacd6 ("io_uring/poll: avoid retry wakeup loss when dropping ownership")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -239,12 +239,14 @@ enum {
 static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	bool again;
 	int v;
 
 	if (unlikely(io_should_terminate_tw(ctx)))
 		return -ECANCELED;
 
 	do {
+		again = false;
 		v = atomic_read(&req->poll_refs);
 
 		/* tw handler should be the owner, and so have some references */
@@ -305,10 +307,17 @@ static int io_poll_check_events(struct i
 		} else {
 			int ret;
 
-			/* multiple refs and HUP, ensure we loop once more */
+			/*
+			 * Multiple refs and HUP, ensure we loop once more. Drop
+			 * down to one ref now, so the next pass ends unless a
+			 * wake up came in.
+			 */
 			if ((req->cqe.res & (POLLHUP | POLLRDHUP)) &&
-			    (v & IO_POLL_REF_MASK) != 1)
-				v--;
+			    (v & IO_POLL_REF_MASK) != 1) {
+				atomic_sub((v & IO_POLL_REF_MASK) - 1,
+					   &req->poll_refs);
+				again = true;
+			}
 			ret = io_poll_issue(req, locked);
 			io_kbuf_recycle(req, 0);
 
@@ -326,7 +335,7 @@ static int io_poll_check_events(struct i
 		 * task_work while we were executing it.
 		 */
 		v &= IO_POLL_REF_MASK;
-	} while (atomic_cmpxchg(&req->poll_refs, v, 0) != v);
+	} while (again || atomic_cmpxchg(&req->poll_refs, v, 0) != v);
 
 	return IOU_POLL_NO_ACTION;
 }


