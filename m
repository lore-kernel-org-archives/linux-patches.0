Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB0A4E4C4F;
	Thu, 17 Sep 2026 15:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659317; cv=none; b=SW6ompb9SlTKN0zmDZBnNX6oQfekWWEunxjYt4xnVug7hVe8uF0el3WT64NuMTcC2zWsJK3mWYofedBHXiAH6uI7h5viIxUmCmaS7S3+176Teau53bPVaAQICLxS14dM3qm1hc8t6qCivsVLjNyOAZRw9SA8K2hWhyhbaI+TjyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659317; c=relaxed/simple;
	bh=xsAlgo6iviRktR49IKSLA/HbWePARbhuV2grGFbFY24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBQ/D4FPEGjzSjSE8Wv1Pr0jKpv483b9slE4LZ8grNXe1v67zSz/2OKgugNW3irAN8yc3O74FoWA5mcc+f+vXCCPA4eUkPCxuP/weWCK6sNy35gY2Hq/JMzxH89/+Zbr+XUgjAKKxuUj8A6Nk2ibjeq+AFnxjCbS8opbdo2IaPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGk/lAK9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGk/lAK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6931F00899;
	Thu, 17 Sep 2026 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659309;
	bh=ZEaWhcK+hxHORQDmByCJnkvKGw8VLzcz6ZdTjf93drw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HGk/lAK985XYR6rchwswwSe2DhVvctCHR49anTcmfQply9YnpNAVfl+HDh+a/d2mk
	 swcTFlsztOnNBvzWtiJEtspSp5iY/bhWxieoyvljGWgUrn788nEzSIWUCGdRgIio6+
	 TnoAGdKpNY1UeHTW3PY1OOz9g9fiVOxBtOK/fiYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 214/733] net/rds: dont let rds_conn_shutdown() consume a concurrent drop
Date: Thu, 17 Sep 2026 16:08:42 +0100
Message-ID: <20260917151356.528280848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allison Henderson <achender@kernel.org>

[ Upstream commit 260c6308fe2e19ad519389d44d582e292aecc3af ]

rds_conn_shutdown() finishes by moving the path from
RDS_CONN_DISCONNECTING to RDS_CONN_DOWN, and also accepts
RDS_CONN_ERROR as the starting state of that final transition, so that
a FIN processed in softirq context during the teardown does not derail
the shutdown into a noisy error path.

But consuming that RDS_CONN_ERROR also consumes the shutdown pass that
came with it: rds_conn_path_drop() sets RDS_CONN_ERROR and then queues
cp_down_w, and a pass that starts on a path already in RDS_CONN_DOWN
is a no-op.  For the FIN case that is harmless - the socket the FIN
arrived on is the very socket the teardown just released.  It is not
harmless for a dropper that attached something to the path first.

rds_tcp_accept_one() is such a dropper.  Its path claim in
rds_tcp_accept_one_path() transitions RDS_CONN_DOWN ->
RDS_CONN_CONNECTING, and a concurrent drop - a FIN on a previous
socket in softirq context, an administrative reset - can put the path
into RDS_CONN_ERROR between that claim and the state check that
follows, which accepts RDS_CONN_ERROR.  The accept then installs the
freshly accepted socket with rds_tcp_set_callbacks() while the queued
teardown - which sampled tc->t_sock before this socket existed - is
still running.  rds_connect_path_complete() fails its transition to
RDS_CONN_UP and drops the path again, queueing the pass that should
reap the socket it just installed.  If the in-flight shutdown's final
transition consumes that drop's RDS_CONN_ERROR, the queued pass finds
the path in RDS_CONN_DOWN and does nothing.  The installed socket is
never torn down: it sits established with its callbacks armed and its
rds_tcp_connection on rds_tcp_tc_list, the peer sees a connection that
nothing ever reads, and the path is wedged in RDS_CONN_DOWN until some
later event drops it again.  Reproduced with widened race windows as
an ever-growing receive queue on a socket owned by a path stuck in
RDS_CONN_DOWN, with the peer's send path wedged behind it.

Make the final transition only DISCONNECTING -> DOWN.  If it fails
because the path is in RDS_CONN_ERROR, a drop raced the teardown:
cancel the reconnect timer and clear RDS_RECONNECT_PENDING - the one
piece of the skipped tail that must not be left behind - and return,
letting the pass the drop queued finish the job: it tears down
whatever attached to the path in the meantime, completes the
transition to RDS_CONN_DOWN, and re-arms the reconnect from its own
tail.

The timer quiesce in that branch matters because the racing drop does
not always queue that pass: rds_conn_path_drop() returns without
queueing when a destroy is pending - exactly the situation during a
netns teardown or module unload, when a FIN on the dying socket is
processed while rds_conn_path_destroy() flushes cp_down_w.  If the
flushed pass is the one that takes this return, no later pass exists,
and rds_conn_path_destroy() would find cp_conn_w still armed
(WARN_ON) and then free a path whose reconnect timer can still fire.
With the cancel in the branch, every exit of a shutdown pass leaves
the timer quiesced no matter which pass completes the transition.

The FIN case keeps making progress, one pass later and still without
noisy logging.  Any other state keeps today's rds_conn_path_error()
handling; no current cp_state writer can leave a DISCONNECTING path
in anything but RDS_CONN_ERROR (every other writer is a cmpxchg from
a non-DISCONNECTING state), so that branch is defensive.

On kernels without the preceding patches the same hazard exists with
the sample-based quiesce; the fix applies there equally.

Fixes: e97656d03ca0 ("rds: tcp: allow progress of rds_conn_shutdown if the rds_connection is marked ERROR by an intervening FIN")
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260828223921.202913-8-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/connection.c | 43 ++++++++++++++++++++++++++++++++-----------
 net/rds/tcp.c        |  9 ++++++---
 2 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index fbbac55a0e818..b6c4beb50eaf0 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -447,19 +447,40 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
 		wake_up_all(&cp->cp_waitq);
 
 		if (!rds_conn_path_transition(cp, RDS_CONN_DISCONNECTING,
-					      RDS_CONN_DOWN) &&
-		    !rds_conn_path_transition(cp, RDS_CONN_ERROR,
 					      RDS_CONN_DOWN)) {
-			/* This can happen - eg when we're in the middle of tearing
-			 * down the connection, and someone unloads the rds module.
-			 * Quite reproducible with loopback connections.
-			 * Mostly harmless.
+			/* The path was dropped again while we tore it
+			 * down: by a socket state-change callback in
+			 * irq context on receipt of a FIN, or by an
+			 * accept that claimed the path just before a
+			 * drop put it back to RDS_CONN_ERROR and then
+			 * installed a fresh socket on it.  Unless a
+			 * pending destroy suppressed it, the drop also
+			 * queued another shutdown pass, and that pass
+			 * must run, because it is what tears down
+			 * whatever attached to the path after the
+			 * transport shutdown above sampled its state.
+			 * Consuming the RDS_CONN_ERROR here would turn
+			 * that pass into a no-op: leave the state
+			 * alone, and let the pass finish the job.
 			 *
-			 * Note that this also happens with rds-tcp because
-			 * we could have triggered rds_conn_path_drop in irq
-			 * mode from rds_tcp_state change on the receipt of
-			 * a FIN, thus we need to recheck for RDS_CONN_ERROR
-			 * here.
+			 * Quiesce the reconnect timer before bailing
+			 * out, though.  When a pending destroy did
+			 * suppress the queue, no later pass runs, and
+			 * rds_conn_path_destroy() is about to flush
+			 * cp_down_w and free the path: it must not
+			 * find cp_conn_w still armed.  A successor
+			 * pass, when there is one, re-arms the
+			 * reconnect from its own tail.
+			 */
+			cancel_delayed_work_sync(&cp->cp_conn_w);
+			clear_bit(RDS_RECONNECT_PENDING, &cp->cp_flags);
+
+			if (rds_conn_path_state(cp) == RDS_CONN_ERROR)
+				return;
+			/* No current cp_state writer leaves a
+			 * DISCONNECTING path in any state but
+			 * RDS_CONN_ERROR; report loudly if one ever
+			 * does.
 			 */
 			rds_conn_path_error(cp, "%s: failed to transition "
 					    "to state DOWN, current state "
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 69c6d3145b5ab..774a71f88d375 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -165,9 +165,12 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 	 * other state - typically RDS_CONN_DISCONNECTING or
 	 * RDS_CONN_ERROR with a shutdown in flight - is dropped
 	 * instead.  That still replaces its state, with RDS_CONN_ERROR,
-	 * and queues one more shutdown pass, but rds_conn_shutdown()
-	 * accepts RDS_CONN_ERROR in its final transition to
-	 * RDS_CONN_DOWN, so the shutdown in flight completes normally.
+	 * and, unless a pending destroy is about to reap the whole
+	 * connection anyway, queues one more shutdown pass.  A shutdown
+	 * already in flight leaves that RDS_CONN_ERROR alone when it
+	 * finishes; the queued pass then completes the transition to
+	 * RDS_CONN_DOWN and tears down anything that attached to the
+	 * path in the meantime.
 	 */
 	if (!rds_conn_path_transition(cp, RDS_CONN_CONNECTING,
 				      RDS_CONN_RESETTING) &&
-- 
2.53.0



