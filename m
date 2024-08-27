Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A2B1C3F19;
	Tue, 27 Aug 2024 15:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771268; cv=none; b=di0BR4eEQUsALyYdHkcEPF2qPFTu+kv6zkxnhP6VAM91F9wghUpthQsl/kR2e94XS5SOsgzWq6XzEfRL/mqIXWJyUMge9uVd8ZFt1YmarfYnqJCAXZSE+qderdq3sBMnq+WGjz7PNecnTXBEsObsXlH/x3788ims4nup7UzfEWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771268; c=relaxed/simple;
	bh=1AcCSkoqcEoCTai19wym34tZaTbWSToEenJUCtVM7oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+My4/tmh1zd+on9Asm2dzjJx+y6RU/pn9nFxKXHESGzcrreN5Jsq3nNXlh6WSf/TQ0YuCZg4NQt6dlap5jzylKUSzq8O1AumAC2rEB667GeMGu9rm2t1txN8KluyoxADDj3gekJdNig3SbBgCuG26YniDjbwnPsv1Dauy2A1NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUm00k4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUm00k4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0E2C61040;
	Tue, 27 Aug 2024 15:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771268;
	bh=1AcCSkoqcEoCTai19wym34tZaTbWSToEenJUCtVM7oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUm00k4agOxr7BpLaPnx9oUn7jPZcIo28yr+LjWIT96i8mzfPIOveR95gTo/5hJ1j
	 Is0lUmx8gJBwQ9h3RRof9Oa2rJWO8tKL96lh49UN/CtgPQPVdheoW7+RcAhG4dFVlA
	 0WVwtXFE49uXHpIfj0AbyVBsCsQzF/fCRHkKANeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 130/273] io_uring/napi: use ktime in busy polling
Date: Tue, 27 Aug 2024 16:37:34 +0200
Message-ID: <20240827143838.351271328@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 342b2e395d5f34c9f111a818556e617939f83a8c ]

It's more natural to use ktime/ns instead of keeping around usec,
especially since we're comparing it against user provided timers,
so convert napi busy poll internal handling to ktime. It's also nicer
since the type (ktime_t vs unsigned long) now tells the unit of measure.

Keep everything as ktime, which we convert to/from micro seconds for
IORING_[UN]REGISTER_NAPI. The net/ busy polling works seems to work with
usec, however it's not real usec as shift by 10 is used to get it from
nsecs, see busy_loop_current_time(), so it's easy to get truncated nsec
back and we get back better precision.

Note, we can further improve it later by removing the truncation and
maybe convincing net/ to use ktime/ns instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/95e7ec8d095069a3ed5d40a4bc6f8b586698bc7e.1722003776.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 84f2eecf9501 ("io_uring/napi: check napi_enabled in io_napi_add() before proceeding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.h            |  2 +-
 io_uring/napi.c                | 48 +++++++++++++++++++---------------
 io_uring/napi.h                |  2 +-
 4 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 7abdc09271245..b18e998c8b887 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -410,7 +410,7 @@ struct io_ring_ctx {
 	spinlock_t		napi_lock;	/* napi_list lock */
 
 	/* napi busy poll default timeout */
-	unsigned int		napi_busy_poll_to;
+	ktime_t			napi_busy_poll_dt;
 	bool			napi_prefer_busy_poll;
 	bool			napi_enabled;
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 726e6367af4d3..af46d03d58847 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -43,7 +43,7 @@ struct io_wait_queue {
 	ktime_t timeout;
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
-	unsigned int napi_busy_poll_to;
+	ktime_t napi_busy_poll_dt;
 	bool napi_prefer_busy_poll;
 #endif
 };
diff --git a/io_uring/napi.c b/io_uring/napi.c
index 327e5f3a8abe0..6bdb267e9c33c 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -33,6 +33,12 @@ static struct io_napi_entry *io_napi_hash_find(struct hlist_head *hash_list,
 	return NULL;
 }
 
+static inline ktime_t net_to_ktime(unsigned long t)
+{
+	/* napi approximating usecs, reverse busy_loop_current_time */
+	return ns_to_ktime(t << 10);
+}
+
 void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 {
 	struct hlist_head *hash_list;
@@ -102,14 +108,14 @@ static inline void io_napi_remove_stale(struct io_ring_ctx *ctx, bool is_stale)
 		__io_napi_remove_stale(ctx);
 }
 
-static inline bool io_napi_busy_loop_timeout(unsigned long start_time,
-					     unsigned long bp_usec)
+static inline bool io_napi_busy_loop_timeout(ktime_t start_time,
+					     ktime_t bp)
 {
-	if (bp_usec) {
-		unsigned long end_time = start_time + bp_usec;
-		unsigned long now = busy_loop_current_time();
+	if (bp) {
+		ktime_t end_time = ktime_add(start_time, bp);
+		ktime_t now = net_to_ktime(busy_loop_current_time());
 
-		return time_after(now, end_time);
+		return ktime_after(now, end_time);
 	}
 
 	return true;
@@ -124,7 +130,8 @@ static bool io_napi_busy_loop_should_end(void *data,
 		return true;
 	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
 		return true;
-	if (io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to))
+	if (io_napi_busy_loop_timeout(net_to_ktime(start_time),
+				      iowq->napi_busy_poll_dt))
 		return true;
 
 	return false;
@@ -181,10 +188,12 @@ static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
  */
 void io_napi_init(struct io_ring_ctx *ctx)
 {
+	u64 sys_dt = READ_ONCE(sysctl_net_busy_poll) * NSEC_PER_USEC;
+
 	INIT_LIST_HEAD(&ctx->napi_list);
 	spin_lock_init(&ctx->napi_lock);
 	ctx->napi_prefer_busy_poll = false;
-	ctx->napi_busy_poll_to = READ_ONCE(sysctl_net_busy_poll);
+	ctx->napi_busy_poll_dt = ns_to_ktime(sys_dt);
 }
 
 /*
@@ -217,7 +226,7 @@ void io_napi_free(struct io_ring_ctx *ctx)
 int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 {
 	const struct io_uring_napi curr = {
-		.busy_poll_to 	  = ctx->napi_busy_poll_to,
+		.busy_poll_to 	  = ktime_to_us(ctx->napi_busy_poll_dt),
 		.prefer_busy_poll = ctx->napi_prefer_busy_poll
 	};
 	struct io_uring_napi napi;
@@ -232,7 +241,7 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 	if (copy_to_user(arg, &curr, sizeof(curr)))
 		return -EFAULT;
 
-	WRITE_ONCE(ctx->napi_busy_poll_to, napi.busy_poll_to);
+	WRITE_ONCE(ctx->napi_busy_poll_dt, napi.busy_poll_to * NSEC_PER_USEC);
 	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi.prefer_busy_poll);
 	WRITE_ONCE(ctx->napi_enabled, true);
 	return 0;
@@ -249,14 +258,14 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 {
 	const struct io_uring_napi curr = {
-		.busy_poll_to 	  = ctx->napi_busy_poll_to,
+		.busy_poll_to 	  = ktime_to_us(ctx->napi_busy_poll_dt),
 		.prefer_busy_poll = ctx->napi_prefer_busy_poll
 	};
 
 	if (arg && copy_to_user(arg, &curr, sizeof(curr)))
 		return -EFAULT;
 
-	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
+	WRITE_ONCE(ctx->napi_busy_poll_dt, 0);
 	WRITE_ONCE(ctx->napi_prefer_busy_poll, false);
 	WRITE_ONCE(ctx->napi_enabled, false);
 	return 0;
@@ -275,23 +284,20 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
 void __io_napi_adjust_timeout(struct io_ring_ctx *ctx, struct io_wait_queue *iowq,
 			      struct timespec64 *ts)
 {
-	unsigned int poll_to = READ_ONCE(ctx->napi_busy_poll_to);
+	ktime_t poll_dt = READ_ONCE(ctx->napi_busy_poll_dt);
 
 	if (ts) {
 		struct timespec64 poll_to_ts;
 
-		poll_to_ts = ns_to_timespec64(1000 * (s64)poll_to);
+		poll_to_ts = ns_to_timespec64(ktime_to_ns(poll_dt));
 		if (timespec64_compare(ts, &poll_to_ts) < 0) {
 			s64 poll_to_ns = timespec64_to_ns(ts);
-			if (poll_to_ns > 0) {
-				u64 val = poll_to_ns + 999;
-				do_div(val, 1000);
-				poll_to = val;
-			}
+			if (poll_to_ns > 0)
+				poll_dt = ns_to_ktime(poll_to_ns);
 		}
 	}
 
-	iowq->napi_busy_poll_to = poll_to;
+	iowq->napi_busy_poll_dt = poll_dt;
 }
 
 /*
@@ -320,7 +326,7 @@ int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
 	LIST_HEAD(napi_list);
 	bool is_stale = false;
 
-	if (!READ_ONCE(ctx->napi_busy_poll_to))
+	if (!READ_ONCE(ctx->napi_busy_poll_dt))
 		return 0;
 	if (list_empty_careful(&ctx->napi_list))
 		return 0;
diff --git a/io_uring/napi.h b/io_uring/napi.h
index 6fc0393d0dbef..babbee36cd3eb 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -55,7 +55,7 @@ static inline void io_napi_add(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct socket *sock;
 
-	if (!READ_ONCE(ctx->napi_busy_poll_to))
+	if (!READ_ONCE(ctx->napi_busy_poll_dt))
 		return;
 
 	sock = sock_from_file(req->file);
-- 
2.43.0



