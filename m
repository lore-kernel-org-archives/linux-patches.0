Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F2979C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5A5C433D7;
	Wed, 30 Nov 2022 18:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834280;
	bh=f469Eyl9iTgGdzilUrmfkK6gyjtcEXnM/7qfFyjJtCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2LGn5QEBXoUzTtqtAGj8mfpGy1SG5Ycscw+IiT3gwJ0oC5EED9p+xFYpg2cJJgzN
	 Q73QxZ3dsEReLrRKarJ6Yqk3/UKJVSQgE3+QlGX39wj2+f70by9DORwF3LYrsZDHVi
	 CdFT/nNUsUxuU7HXGwxTj98eiVcgiYFD59ymo2DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 195/289] io_uring: cmpxchg for poll arm refs release
Date: Wed, 30 Nov 2022 19:23:00 +0100
Message-Id: <20221130180548.542665171@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

commit 2f3893437a4ebf2e892ca172e9e122841319d675 upstream.

Replace atomically substracting the ownership reference at the end of
arming a poll with a cmpxchg. We try to release ownership by setting 0
assuming that poll_refs didn't change while we were arming. If it did
change, we keep the ownership and use it to queue a tw, which is fully
capable to process all events and (even tolerates spurious wake ups).

It's a bit more elegant as we reduce races b/w setting the cancellation
flag and getting refs with this release, and with that we don't have to
worry about any kinds of underflows. It's not the fastest path for
polling. The performance difference b/w cmpxchg and atomic dec is
usually negligible and it's not the fastest path.

Cc: stable@vger.kernel.org
Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0c95251624397ea6def568ff040cad2d7926fd51.1668963050.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -519,7 +519,6 @@ static int __io_arm_poll_handler(struct
 				 unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	int v;
 
 	INIT_HLIST_NODE(&req->hash_node);
 	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
@@ -587,11 +586,10 @@ static int __io_arm_poll_handler(struct
 
 	if (ipt->owning) {
 		/*
-		 * Release ownership. If someone tried to queue a tw while it was
-		 * locked, kick it off for them.
+		 * Try to release ownership. If we see a change of state, e.g.
+		 * poll was waken up, queue up a tw, it'll deal with it.
 		 */
-		v = atomic_dec_return(&req->poll_refs);
-		if (unlikely(v & IO_POLL_REF_MASK))
+		if (atomic_cmpxchg(&req->poll_refs, 1, 0) != 1)
 			__io_poll_execute(req, 0);
 	}
 	return 0;


