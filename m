Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209808;
	b=OfVs/s0MLYUDTH9mRiP/UGalY4AfqtJCszz/rSTwgKoc0wK1EzncHwqlfRhW5HugA7Hf
	 yf5cvj3Vys8ELxDt6qIDYGyc8AVjQmfVktsKM3Y9cnOLTtxcsM6H2DzBh3bqILDVaGTOJ
	 e/l7EoXv4ahp2eBC3EgWt5D/ueMOxNMNb9tIpBj0zmOmdLA6S2qJclBunj85iD3+08m7n
	 EygQTo9I29lRc/iBRp7+4NpdtqKMtlRxWuZJ9ik2la7DOQJMpKsXP+tV7c/byS8tyFZN8
	 a8kloB042lsULbQfgsfUo+sqtDnyDO7aAQbXN30J88b3mWAqCRBDq0Rtb69kNd5aNoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m8IGKJQQaZlfqG3Op8qWrMhezYJN3og5T5fl6QT3Ei4=;
	b=v1fzuJko84uULLMH27s1oPPxLtD/bVHANQ7wgI96Sa91CITnSnzemlqeLw6F3U4rRIwi
	 c/emGodCw04uFsaVJXmxqeeM6V/0LZemTMxlg7FqkEPmGAqXU0QUOzwg1p826GCWaFUFr
	 K2+S7WfsWYjvcWsUdNhAHm3d0iyY+p3RvFM4HgP9OqhhebMs/UXeLfBqhZyPHHFyNPtDn
	 qPCQ6Q9Te4SOxcRJ7eY8ZIsTxeENYBPmeZssGWAsPWrWEqAScoNC5lMLQRsHywIkn3NAK
	 KnAREB1PX36DlJbIS1ocMI4XS8eFcAGNEfL+CrSTviPJi2FRq5jBLuvgTmOx/SsmpGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gGzxZQJD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D781606A31A;
	Wed, 28 Oct 2026 17:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gGzxZQJD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3EC1F01825;
	Wed, 28 Oct 2026 17:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209808;
	bh=m8IGKJQQaZlfqG3Op8qWrMhezYJN3og5T5fl6QT3Ei4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGzxZQJDkFu6ROqXni3TVZPVc+koOwo3LlMb3/mhxRKSkj9H/rhfZ7DEmi8zd0wfA
	 j0Va9Mk8ZR4dixex02HWYKZHa5iLcXsiWD09JEPRCm5U/M9n4+PxNkOCdb63YLOz9h
	 6XOpNxqyb4vA3BqPt6pCcFueZcyEVX4kDPKbYdNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 082/109] io_uring/timeout: dont put a sequence target behind the last flush
Date: Wed, 28 Oct 2026 18:01:06 +0100
Message-ID: <20261028165944.288441646@linuxfoundation.org>
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
@@ -637,7 +637,6 @@ int io_timeout(struct io_kiocb *req, uns
 	}
 
 	tail = data_race(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
-	timeout->target_seq = tail + off;
 
 	/*
 	 * Update the last seq here in case io_flush_timeouts() hasn't, it only
@@ -652,6 +651,15 @@ int io_timeout(struct io_kiocb *req, uns
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


