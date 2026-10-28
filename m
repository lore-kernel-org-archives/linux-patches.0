Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207318;
	b=09TuiDj6593MzKjHjs+NOrIRL1b+xokHjUO0l7410vLiVhzC3rExxrNrguwJYk75SAtD
	 8CR4c5+zBWisf4xfHDu2FPozynxhL0Srv8mqlJj0Kpb9UWlCg7AchMA9bcu/c0VuxkhQw
	 2aUJNhBLLtbiCMuY445z+aCLHRpP4YosgMYmxMwxRwMrFCrFRxCgg5A40Ei78C7jiN/9x
	 tJMdMGDSYN3QKXm6lb1ZyYPd3cuGDYsIAUQjUB5WgPwnLDcypylOcwhxvJX+gvfsp+VjM
	 CFlEthuBvfoXfX3lTr9snVwwz7UMvklZdaGK40S2/r9KnPgjtJtaHjwFSNjFrwPiHyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=elpP2pnVRdzq4d7vYuikkrccT1+EXiJJFmmamzozhLs=;
	b=n/iInnbZ4myRIm/kahrmECqteBYB7+4NHw3aNwnMia4MATZaAKPRma9iiZNyzviEqMCD
	 pPtYob8OMUkEteMlyFeV107Qf59QEvSY0FXmkRj1pKA7/KAWSCYZqMSJFCMmn/mTls5fK
	 MYvBJF2oJNpG0jSOJI8FilM5UM23emrh/ZghThBIv/mm7H33ylwnp3kebFRGsSt9IC3hH
	 Iiba5hxB0c1yTkb/qeXS90iH8B8+xBkrzw4GEa8hnC5EqsKLgFs+3VVj0fGZmWnVzObQi
	 Fq28at3AgZTDTbr3IeYuD4xwMipgnNtUig4aT8XxO1vjVAyV5be8GV2Ykdq9oK0Cs/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="liMDNm/h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02199606A31C;
	Wed, 28 Oct 2026 17:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=liMDNm/h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196361F01825;
	Wed, 28 Oct 2026 17:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207317;
	bh=elpP2pnVRdzq4d7vYuikkrccT1+EXiJJFmmamzozhLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=liMDNm/hF2nd61iN82G0dX65Q4tuJYGOHzke3bTMNWVed+i5s9YZ6KjIsetAwdpmC
	 KiSdrWKft5svlRV8rBfVSGw+vtUlXsn4hN3bFtK/CDy8yl7Egvqlmk/N76R3VBb9vY
	 PPSYsTJsNBl6NsSLDzqWvlx4b3uUIIm6apKN8J7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 61/88] io_uring/timeout: dont put a sequence target behind the last flush
Date: Wed, 28 Oct 2026 18:00:09 +0100
Message-ID: <20261028165943.550062337@linuxfoundation.org>
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

Commit fdfce905a58edea053ee7b68b5bd4348dd1b36e0 upstream.

io_timeout_fn() and io_kill_timeout() bump ->cq_timeouts when a timeout
fires, but its CQE is only posted later from task_work. Until then the
sequence io_timeout() computes is one below the last flush per fired
timeout. Now that ->cq_last_tm_flush is kept while sequence timeouts are
pending, a timeout armed in that window with a small offset gets a target
behind the base. Its distance from the base wraps, and it's never
completed by events, only by its timer. With DEFER_TASKRUN that window
is as wide as the application makes it, as submission runs before the
local task_work.

Nothing but those in flight CQEs separates the two, so use the last
flush as the base for the target when the sequence is behind it.

Fixes: c6c0b3eba88c ("io_uring/timeout: don't skip over reached sequences")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -690,7 +690,6 @@ int io_timeout(struct io_kiocb *req, uns
 	}
 
 	tail = data_race(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
-	timeout->target_seq = tail + off;
 
 	/*
 	 * Update the last seq here in case io_flush_timeouts() hasn't, it only
@@ -705,6 +704,15 @@ int io_timeout(struct io_kiocb *req, uns
 	base = ctx->cq_last_tm_flush;
 
 	/*
+	 * A fired timeout bumps ->cq_timeouts before its CQE is posted, which
+	 * leaves the sequence behind the last flush until it is. Nothing else
+	 * separates the two then, so count from the flush.
+	 */
+	if ((s32)(tail - base) < 0)
+		tail = base;
+	timeout->target_seq = tail + off;
+
+	/*
 	 * Insertion sort, ensuring the first entry in the list is always
 	 * the one we need first.
 	 */


