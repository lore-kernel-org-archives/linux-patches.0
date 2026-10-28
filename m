Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208103;
	b=hziLKZXyeitSBxACzgNVpwNjze2m1Npo48REx3SNCGpaC7ZKger0jYocrVja3CBhs+4g
	 c1DYmSUx/kEV5A7RJBi16y72tpBqAXbRo5MyDwcK5lP5Fzr0xYuODYnCrcNsYBQVvq4BP
	 +39Dug9DcYb4xZx0sxB7dNTnwFZbqFlnw+UV1UXV82Hq/nWD6YnFX6cwTucsThOjp9XKs
	 5g6Ngm8SunTBOgXXbSjhcjMuRHzGk6n7fwZvGot2tUOOauYHPdamatT/LulzmNYs7RdDH
	 rIl3F0M/HHvTACVMRTzpeC0wk6AxdPLzlHIkuRHRuqOcCOSpPCR2pnKsg5jQR7sTCNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O0/50c/aGoV8+M4BiCySUhNWirk2xtS/tgdDYZaU3oY=;
	b=NGXc20h9mT8hnNouS8qQFt3kYUGrTMKH4xCPN/3nqVOXnTv6/w+0TC+sd7FH+BceWOhr
	 iV5hfIvvpHL2hDdcQ8LyQlSZWNOZGW+HaxB1LIWv8bIDp2GPp1JkAGY0V+o2aRavX9w/D
	 oFA+37KtmmPzH/iqqx2nFolUS1Hy3KNSwADcuhYFNMa0QJF2j5bQ4SLpWj7EtB8+E8eHy
	 NFny+5agxq1wG9dAArOMU52IDao/0UZs9pGa2k4rfX7C0x7ks7TS3QE7/DGitDewv1mSX
	 utw71TP75HyN0rNkF4Zqe8/JtWaT/BRn9LH6W+dEQ8yvxmCNPJs5FB4Dzle35N1VhPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wKK6v+6W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB88606A31A;
	Wed, 28 Oct 2026 17:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wKK6v+6W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBD71F01825;
	Wed, 28 Oct 2026 17:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208103;
	bh=O0/50c/aGoV8+M4BiCySUhNWirk2xtS/tgdDYZaU3oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wKK6v+6WVA+nbW+NLqpCp7nEnygcOa8ub4UcLWYQlIdeLZSOv5NE7kppV7h34R9v7
	 ETVR5Wi8LHvoRMmkR9do14/4BsuAu4ns7xzvTdR4mQtrRddhbtwPTuIudO8jUy9hEj
	 gBMHhydEc3mY7MOLoC3Nq2M6ufuXaxeoyF2ilTw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 224/247] io_uring/timeout: dont flush with the sequence behind the last flush
Date: Wed, 28 Oct 2026 18:00:27 +0100
Message-ID: <20261028165952.725765107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit 85f85d573ffa7772e1ad4504d0cec5113a5c5cf1 upstream.

io_flush_timeouts() measures the events since the last flush as the
distance of the current sequence from ->cq_last_tm_flush. A fired
timeout bumps ->cq_timeouts before its CQE is posted, so until it is
the sequence can be behind the last flush, and the distance wraps:

  last flush: seq 100, cq_last_tm_flush = 100
  Y: IORING_OP_TIMEOUT, off 50, target_seq 150
  pure timeout A fires, cq_timeouts = 1
  task_work posts A's CQE, cached_cq_tail = 101
  pure timeout B fires before the flush, cq_timeouts = 2
  io_flush_timeouts(): seq = 99, events_got = 0xffffffff

Y, and every sequence timeout behind it, is ended with -ETIME although
no event happened. Two timeouts expiring close together is all it takes,
a completion with IOSQE_CQE_SKIP_SUCCESS after a single one does it too.

Nothing but those in flight CQEs separates the two, so count from the
last flush when the sequence is behind it, as io_timeout() does.

Fixes: f010505b78a4 ("io_uring: flush timeouts that should already have expired")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -113,6 +113,14 @@ __cold void io_flush_timeouts(struct io_
 	spin_lock_irq(&ctx->timeout_lock);
 	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
 
+	/*
+	 * A fired timeout bumps ->cq_timeouts before its CQE is posted, which
+	 * leaves the sequence behind the last flush until it is. No event has
+	 * happened then, see io_timeout().
+	 */
+	if ((s32)(seq - ctx->cq_last_tm_flush) < 0)
+		seq = ctx->cq_last_tm_flush;
+
 	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
 		u32 events_needed, events_got;


