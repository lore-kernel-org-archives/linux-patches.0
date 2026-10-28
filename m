Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209811;
	b=VwAE2MrLuyfCHy/HOSqLQJLTFZXK9w5AypiLqgiSBjjm3iKk8gsLw5OjgZge1fZ0pNU4
	 i5banATkLltWVJtuej+JhpkyhtUhdS7fJmFbrIxKs3U1RGZwyW++o4dUbJZZpKj989CG5
	 VD/kUbP778RMLHqln+1VeW1V4P2GP3nuT6GKHbq1H1L6tMQkNvIzS7vZLyN1I+fyy7Ce7
	 cycfMRyXtjtyeCmIcHvSbMIgEyemvurUvPck+nv9RydfxLpG+vgMh92geduH8qPFzKPyW
	 27Te21NQzUtYgibIM5IPXyjuoWHWsOR8cHkr6F5/s67yQepVdWsP4q0KPaL7Kad54fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/gDftI/4NaAnL1lwLXNLj4zsGZXkQhwMloHX2aJI7AM=;
	b=jLlQ9o2djV0aF3X3isI45euL/IDifAEJuIKSTwVowXYKlNHjRiibPnRJNzxuZvSaEjKe
	 OuKGvYi9NXLNEzgtKSPMtQLTQbN0yyXQ9VbG2epB4kETp4wMS9Z7jLs5wGpg9VdU5GImB
	 xR631ArdV0fJSFH4/ZSCUDhoNmTwbHeVZGmCA50tJ2rKee/NqVr6mC8NJJl5OndLZWAZP
	 Ld6sjZGgEaEEqL1KlkxbZFMe0N85nWgQRk5RXbAB8GB/E9Tl9bzz2yzK1KWQxTnD+zW3q
	 uM6krL64iOYxOgkP+1YDCOmdDEB1TgVP0frhHGFBbqQUuZFn2x2DuSlrrhomdXfa+zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3UE8aTu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227AA606A31A;
	Wed, 28 Oct 2026 17:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3UE8aTu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717F71F01825;
	Wed, 28 Oct 2026 17:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209811;
	bh=/gDftI/4NaAnL1lwLXNLj4zsGZXkQhwMloHX2aJI7AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3UE8aTuT/vgKHYodgNiJNn+yWQvWyQ0/el3RgT2RKD/dIu1D3o/kUWshB9OnLEPT
	 cNW0TbdWz0jWdAwks6/9vxsqQEjpK/3SDI9lnudp2rzLIAYxoWYslNxtp5JiiYl0em
	 lJNEY1C04aybbzmzOYOP8qgSK6SOxhvy+dtHrKMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 083/109] io_uring/timeout: dont flush with the sequence behind the last flush
Date: Wed, 28 Oct 2026 18:01:07 +0100
Message-ID: <20261028165944.311883630@linuxfoundation.org>
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
@@ -132,6 +132,14 @@ __cold void io_flush_timeouts(struct io_
 	raw_spin_lock_irq(&ctx->timeout_lock);
 	seq = READ_ONCE(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
 
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


