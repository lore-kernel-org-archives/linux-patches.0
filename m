Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210369;
	b=B0OO19sV/gHyW0BbKJ7n1VunY6YUIo84jxoCpcGbvQdLsbAcYBKYxS8yoKjZnRFiEEcU
	 0Z414y0NEvB0O7CPViUOCfxXzD6HzXxANNceEEn8THplqcVPXWx+sBZZhgzv5QuxiEPkn
	 JGFrTlGc/KtOk9DxZVqf87K0nbjsi1VoEpvuUVYj1vks9TN6tnmXX04eX7OlD2f+qPdB9
	 AW6iTSsE5FkE8VsfDv9QwRsNNUU7HAShH1N9yv+bOOpZR0ZBeOku4Su/e0spzXm6tH9wx
	 icq5GxQE7r8xMkZ8S7vN9ZbiN7AqTv41jCB3SFkD+XenyMo/htPGh+T50pgS+pLBtRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J8O7+9R0Jy+tcszSGR/PYqP1LM+7BQDHemdNMN3oFb4=;
	b=pVqyHYRFSW/E9rIT34jjX0LaAtI0fb5WCgOj8fDO/3U2RxI5+9FgqqiMXkim8YNg+Zj0
	 DQVqqA8zCBv+SUwgrX2OZB4nxG/MDj54PyHnBYupxlAu8x6RSi3i5t+KWZVPSJq5Frv3g
	 /xbMtieGIcQH6P6jHmKFxxPH1Wgk/+rusZFG8UX/dF7CpPuGt84Ul5Rc2vow8NWw9W5Sp
	 cnh8DWYyFFDMHWwde/h0LXD7ymvlFO9R+1bXYjvYvTDW0bW9XcIU6LzJELIuRsWUKNiqT
	 ASIaYm358e1e28apudyD58ygLNcZI/EdVQDopR7oj68NXTBlylendxdrdiMW80qT+MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0DiJpQOQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558B9606A31E;
	Wed, 28 Oct 2026 17:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0DiJpQOQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64CC1F01825;
	Wed, 28 Oct 2026 17:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210369;
	bh=J8O7+9R0Jy+tcszSGR/PYqP1LM+7BQDHemdNMN3oFb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0DiJpQOQpShTWN+yBCQ04+9Kj01zVI9ELDRybxUOMrbYQSILj4/HQ1RGXJaBObPNE
	 aEIjT4xywXyycogr2Ynf5TKEfX2dtcJGMNdxLrkaIqlMpWuHFoplxcV6XfxQouLdjB
	 5CsAbfet7BN5Elrwcb4xE2gUZtTColaEPHDx28PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 150/168] io_uring/timeout: dont flush with the sequence behind the last flush
Date: Wed, 28 Oct 2026 18:01:26 +0100
Message-ID: <20261028165946.635784578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -116,6 +116,14 @@ __cold void io_flush_timeouts(struct io_
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


