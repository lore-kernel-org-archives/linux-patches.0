Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620852;
	b=jctejlAhOe3dspJy9kwAUCBUYgTUWj8t5cp+1CE4FutXGs/aO+Vlf7RZ2Eoj/uYHVyun
	 XIbnMBBU08rZKwIhaPsWr3KnOM1v7hYB+gha3J/NL1R0okMfnAa0d2MABV4qqo8Obi8aG
	 VGP24KQGC7QEk6m73urH6DHWaa4jbPOpdi4Pvnppa/JSxju45o+LRSeO7FQOq9dPZnIjK
	 XECsoo5I3sygHAsCRBXC/gwwxXKliYa6an0vaXKYtHgqSRZFrlq2sEcXzTHuwvKZPcQ66
	 KkhQi5ns2Psqr90k9+zxcya244n/2ssl9kwXHLBfW+bKf2s4mWM4aBXxeDNiCWisF2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zzft8QgA/hwDztw3yjetDXc1K/tCIz6HmsrIbHqXpdk=;
	b=BnnQPb2UsFa57fJm3Nnbuq8ax7Fm1COSRvvexQmkUnuWMGJ/bKBbi3spHRSHUN6xrEZn
	 6/iD8ZbhVd/LFDfyjS/0llMyZrf2mNftrDEq/9a+9gUSY32Rm/uBTOegRj04r8eg3NWN+
	 kdWXih7YfWmBKqQRBses5+k9z37MpvdNjJLKNJNWLV3FQHJ9OXsnAMpF7OFb4DT85NMy/
	 P9hcbwO3FtWXCdmBqVdLvvE7KmtBNkT1dbYbSsVbqwNa7cAWcvPyYhblWMDm4TxcZaFki
	 OOT7z6IHY7yPKKtlZjUY0iqEHW5ACAlHtIrI+CPNrjf4H1tk/l9nk/ZoOyJBadZKyrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l9utZPhF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7C3606A31E;
	Wed, 25 Nov 2026 15:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l9utZPhF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23BC1F000CA;
	Wed, 25 Nov 2026 15:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620852;
	bh=zzft8QgA/hwDztw3yjetDXc1K/tCIz6HmsrIbHqXpdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9utZPhFRufS1Caq8STwZj/ku40aDanjhW7Jitx/cnKwREdsf609ey+Lkt6xBAMRR
	 350UezO4WpKufmF5ZAjhUGnnernof5eYPJCndohsdwJls2v/06Le2vpN7r3OHKsW60
	 xxDVTb2J9XhXvpaCbTShtY9GNSQysWvuuUtDyYYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cinq Prairie <notprairie@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/990] io_uring/napi: dont end the single NAPI busy poll early on need_resched()
Date: Wed, 25 Nov 2026 15:23:30 +0100
Message-ID: <20261125143823.100022366@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Cinq Prairie <notprairie@gmail.com>

Commit 39c7210e970200f8b17de3767c73efe64173a95f upstream.

With a single registered NAPI, io_napi_blocking_busy_loop() hands
io_napi_busy_loop_should_end() to napi_busy_loop_rcu() as loop_end and
runs its own loop once, relying on __napi_busy_loop() to spin until
that predicate fires. napi_busy_loop_rcu() sets NAPI_F_END_ON_RESCHED,
so __napi_busy_loop() also returns on the first need_resched(). io_uring
treats the return as the end of the busy poll period and sleeps in
schedule_hrtimeout() for the rest of the wait timeout.

With two or more NAPIs the inner loop is single-shot and io_uring's own
loop runs until its predicate is met, so busy_poll_to is honoured. The
same registration therefore behaves differently for one NAPI than for
several.

Make the busy poll deadline absolute, stored in io_wait_queue, so that
io_napi_busy_loop_should_end() no longer depends on the start_time the
napi loop snapshots on every entry. The single NAPI loop can then be
re-entered after an early need_resched() exit if there is budget left,
and the loop condition drops the "run once" special case. The fast path
that holds the NAPI across polls is kept.

Measured on io_uring-7.4 at 9c207aa58e54, x86-64, HZ=1000,
PREEMPT_DYNAMIC (lazy), no CPU isolation, low RX traffic, r8169 with one
RX queue, prefer_busy_poll, busy_poll_to = wait timeout = 10 ms.
"waker" is a SCHED_FIFO task pinned to the polling CPU waking every 1 ms:

  1 NAPI, waker, before:  busy 0.5-1.5 ms per 10 ms wait, ~0.8M polls/s
  1 NAPI, waker, after:   busy 10 ms per 10 ms wait,      ~16.2M polls/s
  1 NAPI, idle, before:   busy 10 ms per 10 ms wait,      ~15.3M polls/s
  1 NAPI, idle, after:    busy 10 ms per 10 ms wait,      ~16.2M polls/s
  2 NAPIs, waker, before: busy 10 ms per 10 ms wait,      ~7.2M polls/s
  2 NAPIs, waker, after:  busy 10 ms per 10 ms wait,      ~7.1M polls/s

The held-NAPI fast path polls about twice as often as the single-shot
path used for several NAPIs, which is why it is kept.

Fixes: 8d0c12a80cde ("io-uring: add napi busy poll support")
Cc: stable@vger.kernel.org
Signed-off-by: Cinq Prairie <notprairie@gmail.com>
Link: https://patch.msgid.link/20261027204840.7823-1-notprairie@gmail.com
[axboe: trim comments, drop __always_unused]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.h |  1 +
 io_uring/napi.c     | 31 ++++++++++++++-----------------
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 922bdf68aec8c..4f1d20d28f727 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -113,6 +113,7 @@ struct io_wait_queue {
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	ktime_t napi_busy_poll_dt;
+	ktime_t napi_busy_poll_end;
 	bool napi_prefer_busy_poll;
 #endif
 };
diff --git a/io_uring/napi.c b/io_uring/napi.c
index 45180b172bec7..46f5854f05efa 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -128,19 +128,15 @@ static inline void io_napi_remove_stale(struct io_ring_ctx *ctx, bool is_stale)
 		__io_napi_remove_stale(ctx);
 }
 
-static inline bool io_napi_busy_loop_timeout(ktime_t start_time,
-					     ktime_t bp)
+static inline bool io_napi_busy_loop_timeout(struct io_wait_queue *iowq)
 {
-	if (bp) {
-		ktime_t end_time = ktime_add(start_time, bp);
-		ktime_t now = net_to_ktime(busy_loop_current_time());
-
-		return ktime_after(now, end_time);
-	}
-
-	return true;
+	if (!iowq->napi_busy_poll_dt)
+		return true;
+	return ktime_after(net_to_ktime(busy_loop_current_time()),
+			   iowq->napi_busy_poll_end);
 }
 
+/* Uses an absolute deadline, so the napi loop can be re-entered */
 static bool io_napi_busy_loop_should_end(void *data,
 					 unsigned long start_time)
 {
@@ -150,8 +146,7 @@ static bool io_napi_busy_loop_should_end(void *data,
 		return true;
 	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
 		return true;
-	if (io_napi_busy_loop_timeout(net_to_ktime(start_time),
-				      iowq->napi_busy_poll_dt))
+	if (io_napi_busy_loop_timeout(iowq))
 		return true;
 
 	return false;
@@ -204,13 +199,16 @@ __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
 static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
 				       struct io_wait_queue *iowq)
 {
-	unsigned long start_time = busy_loop_current_time();
+	ktime_t now = net_to_ktime(busy_loop_current_time());
 	bool (*loop_end)(void *, unsigned long) = NULL;
 	void *loop_end_arg = NULL;
 	bool is_stale = false;
 
-	/* Singular lists use a different napi loop end check function and are
-	 * only executed once.
+	iowq->napi_busy_poll_end = ktime_add(now, iowq->napi_busy_poll_dt);
+
+	/*
+	 * A single NAPI is held by __napi_busy_loop() for the whole spin. It
+	 * may return early on need_resched(), loop until our own deadline.
 	 */
 	if (list_is_singular(&ctx->napi_list)) {
 		loop_end = io_napi_busy_loop_should_end;
@@ -221,8 +219,7 @@ static void io_napi_blocking_busy_loop(struct io_ring_ctx *ctx,
 		do {
 			is_stale = __io_napi_do_busy_loop(ctx, loop_end,
 							  loop_end_arg);
-		} while (!io_napi_busy_loop_should_end(iowq, start_time) &&
-			 !loop_end_arg);
+		} while (!io_napi_busy_loop_should_end(iowq, 0));
 	}
 
 	io_napi_remove_stale(ctx, is_stale);
-- 
2.53.0



