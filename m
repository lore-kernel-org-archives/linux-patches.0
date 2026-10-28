Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207320;
	b=IKafa3W6sa9gTy3+PULv8fl1NJ7vmqI8rN2xku84B65FjrCV6KEA1j6NFm/LNOnrNmk7
	 oNMzReknMWbeerZpT8oFQxnlIj4icN8m0kjin3BFqcUFI31xxv50awpZ8tUGIUTABSVNX
	 EI95JyeVHk3C4nYeKdelEWOXoie7w6wc7eOyjZAZw8AuBxnJ/SWMxnPofFzZtg44d0AI3
	 dbToJ3kH8A9IXv5JxlyRtXhf5KTcQnDrymL2wEvUxSTW8g6cQUEZMXrll6MJvM/4xt+Yb
	 /Yq8KS4Kuc8kIAMtd8jS7FMKe2CC+l6GMD1tHRusDOIR2hgkSGrrcSVhRb24tfkt91Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3F/C8dO2RenRDg5XtH10zrsIONG0fEtWRgA7v51s2hA=;
	b=klQZXJgvvUlHD2iqK7V9kzgqqwWbbzGZN2hYdFWWC8bLVrzqWCuzTVxQidgPglLESc7a
	 SsCgSvH/ZAVweFpFoqwFHGPBGCpVpVVeX1w869kOFjd6o1ov4cLrzygesxkZgIghc/ezx
	 ZN26ITLvenU2K+ZMQ6pYtrAHW9SPiS4R7XIT/sRXgHimeCPMDlxR3Gj/urytjDEQaT+J0
	 /N+VUNUrtYJzsu4UtTu8MzZAcGCxBjOaTcmDJBf4H6DbFP2lG+09/hKQWgdX1NIRifnh8
	 gXNDz8KT4SbEsZ0u/YK3KbVgljYrAXP8k0uZELiHUi3kuO5D40KhzkHsr88rgU3/HTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0SLdj68/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A368B606A31A;
	Wed, 28 Oct 2026 17:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0SLdj68/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99921F01828;
	Wed, 28 Oct 2026 17:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207320;
	bh=3F/C8dO2RenRDg5XtH10zrsIONG0fEtWRgA7v51s2hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0SLdj68/WCBwusr+0OvtVT2kCTExfVZAiK8aIt0BBxnBgeKYmZ7mA49ZKNk0N+Hj8
	 PDWoI5CxA6IKoPtOJo4rO4hO0D1QYyktXo1CzYeQAiwe2lteT+ZM5h6QNS8UHkjw6d
	 Q2LhHUZq73js2VuuXT/GODLbShoTau1EHfw+pSnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 62/88] io_uring/timeout: dont flush with the sequence behind the last flush
Date: Wed, 28 Oct 2026 18:00:10 +0100
Message-ID: <20261028165943.572538021@linuxfoundation.org>
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
@@ -171,6 +171,14 @@ __cold void io_flush_timeouts(struct io_
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


