Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BAE1AF0BB;
	Tue, 27 May 2025 17:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367598; cv=none; b=jxfIaPLSlapRyGgaX76qNXy7jI4jxf6zsPMp+wgiZb4PWMxca+zTPpsTTxqigUOmBbWtTm4htlnXCUoewPSYz/in7nE1wuGzC8HpvfRkynYyb55cM/6Ms1EsowyqLZJ999LyL0IJhw4hPk3BbSnvm9e5st3q0fDojw5sW/Vijms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367598; c=relaxed/simple;
	bh=9omEmZeqii+PVecTCDDaz60do+CYliHE3aBF9xZpz0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VT/WCahoeaOrq9u6M5appijRHwG0FhzPLAHVEZSo9mzT50w6ii/z1/oAkkngNzCHMjuMd6aWKsvXrGgX2W5F1ih8m2bHNaXF1U0FlVvRf4vTpxfwuXCb/kJuDD84oE5XHoLaAxBW31ytUN8kUMaosM331yezmGYoUYd7hCfI0gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoyMoLDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoyMoLDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8865C4CEE9;
	Tue, 27 May 2025 17:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367598;
	bh=9omEmZeqii+PVecTCDDaz60do+CYliHE3aBF9xZpz0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoyMoLDqALBS3mLGOOa8rh2Z5aQGNKwo46Th2W3gaAG1QzhX3Ei8T0/jSZVv4+sDL
	 S6yKOK6sxyT5twuNachTbaB2jBvUD9ymJRUJJSL6zVLTTy5py8i609nDi/n7eUwdoB
	 E0yQmXvAt6w2LAZ4dMqkYMZiIu2/NV5N0R9VN8CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 438/783] io_uring: sanitise ring params earlier
Date: Tue, 27 May 2025 18:23:55 +0200
Message-ID: <20250527162530.966053536@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 92a3bac9a57c39728226ab191859c85f5e2829c0 ]

Do all struct io_uring_params validation early on before allocating the
context. That makes initialisation easier, especially by having fewer
places where we need to care about partial de-initialisation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/363ba90b83ff78eefdc88b60e1b2c4a39d182247.1738344646.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 77 ++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 33 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 56f10cce8f009..52c9fa6c06450 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3532,6 +3532,44 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 					 O_RDWR | O_CLOEXEC, NULL);
 }
 
+static int io_uring_sanitise_params(struct io_uring_params *p)
+{
+	unsigned flags = p->flags;
+
+	/* There is no way to mmap rings without a real fd */
+	if ((flags & IORING_SETUP_REGISTERED_FD_ONLY) &&
+	    !(flags & IORING_SETUP_NO_MMAP))
+		return -EINVAL;
+
+	if (flags & IORING_SETUP_SQPOLL) {
+		/* IPI related flags don't make sense with SQPOLL */
+		if (flags & (IORING_SETUP_COOP_TASKRUN |
+			     IORING_SETUP_TASKRUN_FLAG |
+			     IORING_SETUP_DEFER_TASKRUN))
+			return -EINVAL;
+	}
+
+	if (flags & IORING_SETUP_TASKRUN_FLAG) {
+		if (!(flags & (IORING_SETUP_COOP_TASKRUN |
+			       IORING_SETUP_DEFER_TASKRUN)))
+			return -EINVAL;
+	}
+
+	/* HYBRID_IOPOLL only valid with IOPOLL */
+	if ((flags & IORING_SETUP_HYBRID_IOPOLL) && !(flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
+	/*
+	 * For DEFER_TASKRUN we require the completion task to be the same as
+	 * the submission task. This implies that there is only one submitter.
+	 */
+	if ((flags & IORING_SETUP_DEFER_TASKRUN) &&
+	    !(flags & IORING_SETUP_SINGLE_ISSUER))
+		return -EINVAL;
+
+	return 0;
+}
+
 int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
 {
 	if (!entries)
@@ -3542,10 +3580,6 @@ int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
 		entries = IORING_MAX_ENTRIES;
 	}
 
-	if ((p->flags & IORING_SETUP_REGISTERED_FD_ONLY)
-	    && !(p->flags & IORING_SETUP_NO_MMAP))
-		return -EINVAL;
-
 	/*
 	 * Use twice as many entries for the CQ ring. It's possible for the
 	 * application to drive a higher depth than the size of the SQ ring,
@@ -3607,6 +3641,10 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	struct file *file;
 	int ret;
 
+	ret = io_uring_sanitise_params(p);
+	if (ret)
+		return ret;
+
 	ret = io_uring_fill_params(entries, p);
 	if (unlikely(ret))
 		return ret;
@@ -3654,37 +3692,10 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	 * For SQPOLL, we just need a wakeup, always. For !SQPOLL, if
 	 * COOP_TASKRUN is set, then IPIs are never needed by the app.
 	 */
-	ret = -EINVAL;
-	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		/* IPI related flags don't make sense with SQPOLL */
-		if (ctx->flags & (IORING_SETUP_COOP_TASKRUN |
-				  IORING_SETUP_TASKRUN_FLAG |
-				  IORING_SETUP_DEFER_TASKRUN))
-			goto err;
+	if (ctx->flags & (IORING_SETUP_SQPOLL|IORING_SETUP_COOP_TASKRUN))
 		ctx->notify_method = TWA_SIGNAL_NO_IPI;
-	} else if (ctx->flags & IORING_SETUP_COOP_TASKRUN) {
-		ctx->notify_method = TWA_SIGNAL_NO_IPI;
-	} else {
-		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG &&
-		    !(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
-			goto err;
+	else
 		ctx->notify_method = TWA_SIGNAL;
-	}
-
-	/* HYBRID_IOPOLL only valid with IOPOLL */
-	if ((ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_HYBRID_IOPOLL)) ==
-			IORING_SETUP_HYBRID_IOPOLL)
-		goto err;
-
-	/*
-	 * For DEFER_TASKRUN we require the completion task to be the same as the
-	 * submission task. This implies that there is only one submitter, so enforce
-	 * that.
-	 */
-	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN &&
-	    !(ctx->flags & IORING_SETUP_SINGLE_ISSUER)) {
-		goto err;
-	}
 
 	/*
 	 * This is just grabbed for accounting purposes. When a process exits,
-- 
2.39.5



