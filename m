Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207502;
	b=yP2oNjFI7I0T89uf7IODz52skXw8YrtAsT2PuwT+1bojSvw4pm+WFbqasQCxrgBYsbi8
	 CIqzEExgVlmm8pBZe3qSWbvIu9C8VLk6ASFz5VdJhs7EsyOZSuWzXfEdVcqx6ZsrR1ewI
	 YWYqdqawQxPJFpZN8WdpoCHvQ4c+9kP2gHk0wotu+HTieHEOG9vHQFocTvfF9XC8yJDmr
	 V8mKmXCMooI5I13COxLe9GXkFtlRZ3Bo/Q1LTVLyzv+5sj6NiLU/mCxBWAz1TDEcG3GSY
	 PPnwsuloNXOOtJ/AbW9aVOf4bDSFv5MtDdyoHuxXs/txvLw1ga6/hWwqPiXODOlif1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LqjpYdIzXV9S97ELHaItYS3QBUCxAL5DJy+TTK2tQaQ=;
	b=mpM79B2/MVs6KOKJffxXF4p4kAAL0GeYweeknlm35Jml926QheMLnoUbcHEvbku91aXg
	 Q3j0KhuoQKtHWawuTycHHjH0c3oYWBsiGIU+L+pGeYSQc9uwY1gas06TZ3ISo+m2tSATQ
	 nQOcKb4rA+rbI8BUyR1EOk77Ia7G1PNpOUaBCBO0x2kJp9XQrK5TMAA+9VBR/woTU1j9E
	 go9G7Z6LErZoSO3hpVuR1hf90RN8+uOFr9sxX460JXWZfH0kCbdgbyro74cdvEXMZksC1
	 MCAAmjYqlIJu0PT5A5G/r67X1Ly4phCEo+d+KtGm7QJNv3F9Lis3XdcXqpQXDCgO5Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JOmGxphU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C445606A31C;
	Wed, 28 Oct 2026 17:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JOmGxphU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0131F01828;
	Wed, 28 Oct 2026 17:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207502;
	bh=LqjpYdIzXV9S97ELHaItYS3QBUCxAL5DJy+TTK2tQaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOmGxphUAW+FxNp8/5+5fkmVJbEDdytJA9plIz8isLD9ntu/y16xM01KNIGavCPyF
	 xH/MgROeJVZlb4UF/3d6A4oaU78l4Q9RxRcOBMH+9Q7NGDAidh0JMd/nz+j6W91R7e
	 Zi9lJRn/TYRi1oaD6NAQaai55PhDdi4Ovyi59HHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+caa052a0958a9146870d@syzkaller.appspotmail.com,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/247] rose: use timer_shutdown_sync() for t0timer teardown
Date: Wed, 28 Oct 2026 17:56:51 +0100
Message-ID: <20261028165947.555107910@linuxfoundation.org>
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
(cherry picked from commit 1cc5d2ead3cc0fc370f27728360bf8def008ee18)
[ Adjusted context: 6.12 still calls del_timer_sync() in
  rose_remove_neigh(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rose.h    | 28 ++++++++++++++++++----------
 net/rose/rose_route.c | 10 ++++++++--
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/include/net/rose.h b/include/net/rose.h
index 95d1f9c582dcc..0d957b8dd0ba3 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -161,17 +161,25 @@ static inline void rose_neigh_put(struct rose_neigh *rose_neigh)
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
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 000d7a8bf7535..fd196f2e2fd64 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -229,8 +229,14 @@ static void rose_remove_neigh(struct rose_neigh *rose_neigh)
 {
 	struct rose_neigh *s;
 
-	del_timer_sync(&rose_neigh->ftimer);
-	del_timer_sync(&rose_neigh->t0timer);
+	/* Being removed from the list is final teardown for this neighbour:
+	 * shut the timers down rather than just deleting them, so a t0timer
+	 * self-rearm losing the race with this removal can't bring it back to
+	 * life later.  See the comment in rose_neigh_put() (include/net/rose.h)
+	 * for the full story.
+	 */
+	timer_shutdown_sync(&rose_neigh->ftimer);
+	timer_shutdown_sync(&rose_neigh->t0timer);
 
 	skb_queue_purge(&rose_neigh->queue);
 
-- 
2.53.0



