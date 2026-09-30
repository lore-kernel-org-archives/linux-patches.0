Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79024FD27C;
	Wed, 30 Sep 2026 18:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793834; cv=none; b=nFfFLxCfbhFt1M9f2WGDGRZZPAfYrxjcf84Y0N+z4tNjrg3wcNrWwT3yiiMIG81vePZlMd07HjF6Oxhq9aCrnDqBfzkAThaLcTwrpl8gYvPrVZybjbO1VEc8+EwdpZScC9AtxSSerurara/KDbAWFRuvtYSbBKarQOJKPTtvF8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793834; c=relaxed/simple;
	bh=QblnRzuvMVMTxny2K8VWwnDXMAsTJjz1Ei5hY9/RTpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxTKV9ITUPXrsvuWPxSpxEvz88IbNQzXfBvrA4qYpSc0ymHq+Vf/Jj2imc+0bTqKFwo/g0Nn799oSCbisjmJqDQtVjZt6tPin02IAl5HqM5IxO5W7LtNAi2+SF/C9dI4pSJUcVNinR88wMt9/Vdvs3S9ojVijsgRD2VyzUSxEbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zawqQ9jZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zawqQ9jZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F28D1F000FF;
	Wed, 30 Sep 2026 18:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793832;
	bh=uI3lAUsLzf0okTkUoWIWUW6SnM+O2rcPYg7Vpp72iSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zawqQ9jZtuPMtKuEitrcK+LISxfdbvxoBQ5YkQ21SXnb05KIgKM3GaVwIeG4thpEF
	 G4+sHguTAE3N8LOG0+4TRAd9yPsJOAeMXyPZDdCjHPJYDzYFXMKQyY2bbZ8xE5yO3r
	 bW7ljwDKhAz1B+CfgcYaXRHNPJ2rO+6NwszA7XHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+caa052a0958a9146870d@syzkaller.appspotmail.com,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 393/395] rose: use timer_shutdown_sync() for t0timer teardown
Date: Wed, 30 Sep 2026 17:30:55 +0200
Message-ID: <20260930152349.227869494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

rose_t0timer_expiry() re-arms itself via rose_start_t0timer() at its
own tail. rose_neigh_put() and rose_remove_neigh() stop it with
timer_delete_sync() before freeing (or unlinking) the neighbour, but
that only guarantees the callback is not running *at the moment the
call returns* -- it does nothing to stop the very invocation that was
just waited out from re-arming the timer on its way out. That re-arm
races the kfree() in rose_neigh_put(): the timer can fire again on
freed memory, and rose_t0timer_expiry() -> rose_transmit_restart_request()
-> rose_send_frame() -> ax25_send_frame() dereferences the freed
neigh->digipeat, use-after-free.

This matches a syzbot report (KASAN slab-use-after-free read in
ax25_find_cb()) that stayed open with both cause and fix bisection
failing -- consistent with a hole that timer_delete_sync() alone
cannot close for a self-rearming timer, a case documented in its own
kerneldoc ("there is no way to get this correct with
timer_delete_sync()").

Use timer_shutdown_sync() instead in both call sites. Unlike
timer_delete_sync(), it also marks the timer so that any further
add_timer()/mod_timer() on it is silently ignored, which closes the
window regardless of how the self-rearm and the free are interleaved.
ftimer's handler is a no-op and never re-arms, but it is switched the
same way for consistency: both timers are being torn down for good in
both of these call sites.

Reported-by: syzbot+caa052a0958a9146870d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=caa052a0958a9146870d
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/rose.h    |   28 ++++++++++++++++++----------
 net/rose/rose_route.c |   10 ++++++++--
 2 files changed, 26 insertions(+), 12 deletions(-)

--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -161,17 +161,25 @@ static inline void rose_neigh_put(struct
 {
 	if (refcount_dec_and_test(&rose_neigh->use)) {
 		/* We are dropping the last reference, so we are about to free the
-		 * neighbour.  Its timers may still be armed -- t0timer in particular
-		 * re-arms itself in rose_t0timer_expiry().  rose_remove_neigh()
-		 * cancels them before its own put, but callers that drop the final
-		 * reference without first calling rose_remove_neigh() (the socket
-		 * heartbeat reaping path) would otherwise kfree() a neighbour with a
-		 * live timer -> use-after-free.  timer_delete_sync() (not the async
-		 * variant) is required: it waits out a concurrently running handler
-		 * and loops until the self-rearming timer stays stopped.
+		 * neighbour.  t0timer is self-rearming: rose_t0timer_expiry() calls
+		 * rose_start_t0timer() at its own tail, so a plain timer_delete_sync()
+		 * is not enough here.  It only guarantees that the callback is not
+		 * running *at the moment it returns* -- it does nothing to stop the
+		 * very invocation we just waited out from re-arming the timer on its
+		 * way out, which races the kfree() below (syzbot: use-after-free read
+		 * in ax25_find_cb(), reached via rose_t0timer_expiry() ->
+		 * rose_transmit_restart_request() -> rose_send_frame() ->
+		 * ax25_send_frame(), dereferencing the freed neigh->digipeat).
+		 * timer_shutdown_sync() closes that hole: once it returns, any
+		 * further add_timer()/mod_timer() on this timer is silently ignored,
+		 * so a self-rearm racing the free can no longer bring the timer back
+		 * to life on freed memory.  ftimer's handler is a no-op and never
+		 * re-arms, but it is shut down the same way here for consistency --
+		 * this is final teardown, neither timer has any business firing
+		 * again.
 		 */
-		timer_delete_sync(&rose_neigh->ftimer);
-		timer_delete_sync(&rose_neigh->t0timer);
+		timer_shutdown_sync(&rose_neigh->ftimer);
+		timer_shutdown_sync(&rose_neigh->t0timer);
 		if (rose_neigh->ax25)
 			ax25_cb_put(rose_neigh->ax25);
 		kfree(rose_neigh->digipeat);
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -229,8 +229,14 @@ static void rose_remove_neigh(struct ros
 {
 	struct rose_neigh *s;
 
-	timer_delete_sync(&rose_neigh->ftimer);
-	timer_delete_sync(&rose_neigh->t0timer);
+	/* Being removed from the list is final teardown for this neighbour:
+	 * shut the timers down rather than just deleting them, so a t0timer
+	 * self-rearm losing the race with this removal can't bring it back to
+	 * life later.  See the comment in rose_neigh_put() (include/net/rose.h)
+	 * for the full story.
+	 */
+	timer_shutdown_sync(&rose_neigh->ftimer);
+	timer_shutdown_sync(&rose_neigh->t0timer);
 
 	skb_queue_purge(&rose_neigh->queue);
 


