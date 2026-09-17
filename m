Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60140484884;
	Thu, 17 Sep 2026 15:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659313; cv=none; b=eTbCzLZ2OY/C3xxiujDs6dBPDG0WSxcN5yQKXbDeINbsKNiq7GeuiTnRyeV6rlG0Hnq5hEFLEue+X8SPN7F1sPNcNs2iWRfe8xrNyE6U3m/hU2Pbd620qe6x5jqIEVSFbgN+/MBOunyD70/4N+cVY8lNtoZVB3LSnC0HgNq11nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659313; c=relaxed/simple;
	bh=2g+OKpP3APr48s0MEiPjZBpnffym5nUViU8bng/sMAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j91U8GqDYEPS2Q7sd6V9hw3nYFWu+I/m55QoSb8iI1EpNGN38eA7P3uuujdcKx5gQQR9uZfh4HAS4rPODZMcvL2nzV05Awj2Clzau2sUfpr+1Xq/5dhorfC5PQ9UzUy/JLYV1DvYTG+De1qEHbZBmWKO1urnrk2skmMrDQcHeAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STqn+pYK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STqn+pYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2A81F00898;
	Thu, 17 Sep 2026 15:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659303;
	bh=IKtDC0LfXweOcQsizwdS2juAMpiFvpUDN4IF1uRS6sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STqn+pYKuHqI5p6Rq5VTc2001/iYDVeTFOURGdaJn1u2TpIxkIRjnIFpajKy7vEfl
	 KRRth1MM/Y4J0qqnTiGGeqQbFWk2XZQ+MOXFSx3xi24mqkRsU/eUZhdYWunsOlAYq5
	 RKJ/W62w2EajXoNxGAokDZZxaWzMKNgkzrXIvlaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 212/733] net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()
Date: Thu, 17 Sep 2026 16:08:40 +0100
Message-ID: <20260917151356.471927940@linuxfoundation.org>
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

[ Upstream commit 02c5f9dc2efd823e061954d564ce00bacd1bebeb ]

rds_tcp_reset_callbacks() quiesces the transmit path by setting the
path state to RDS_CONN_RESETTING and then waiting for RDS_IN_XMIT to
be sampled clear before swapping the underlying socket and calling
rds_send_path_reset().

Sampling the bit clear is not the same as owning it: rds_send_xmit()
can re-acquire RDS_IN_XMIT right after the wait_event() returns.  Its
state recheck after taking the lock is a store-buffering pattern (the
resetter writes the state and reads the bit, the sender writes the
bit and reads the state) and acquire_in_xmit() is only an acquire
operation, so on weakly ordered architectures both sides can miss
each other's write and the transmit path then runs concurrently with
rds_send_path_reset() rewriting cp_xmit_* state - which is exactly
what the comment above rds_send_path_reset() tells its callers to
prevent.

Take the lock instead, hold it across the socket swap and
rds_send_path_reset(), and release it with a wake-up at the end.  The
lock-ordering constraint documented above the wait still holds: the
lock is acquired before lock_sock(), so a sender inside tcp_sendmsg()
can never be waited on while we hold the socket lock.

Two details of the old code go away with the same change:

 - t_sock is now read only after the lock is acquired.  The old code
   cached it before waiting; the teardown in rds_conn_shutdown()
   releases that socket and clears t_sock, so a pointer cached before
   the wait can be stale by the time the accept path resumes.  Reading
   it under RDS_IN_XMIT is what makes the exclusion complete once the
   teardown owns the same lock, which the next patch arranges; until
   then the teardown still only samples the bit, and the two paths
   remain as exposed to each other as they are today.

 - The old !osock early path called rds_send_path_reset() with no
   serialization at all.  It now runs under the lock like the normal
   path.  The conditional RDS_CONN_RESETTING transition of the
   previous patch happens before the socket check either way: a path
   found without a socket is either still connecting (its reconnect
   worker blocked on t_conn_path_lock) and legitimately goes
   RESETTING -> UP on the new socket, or it has been torn down
   meanwhile and is dropped.

The in-function comment describing the old wait-based quiesce is
rewritten to describe the lock-based one, and the stale block comment
above the function (which still described a return value and an
incomplete list of t_sock writers) is refreshed to name all four
writers - the connect, accept, teardown and swap paths - and what
serializes each of them.

Fixes: 335b48d980f6 ("RDS: TCP: Add/use rds_tcp_reset_callbacks to reset tcp socket safely")
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260828223921.202913-6-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c | 70 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 25 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index ad14217867a4d..f4c83e3683905 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -115,42 +115,48 @@ void rds_tcp_restore_callbacks(struct socket *sock,
 }
 
 /*
- * rds_tcp_reset_callbacks() switches the to the new sock and
- * returns the existing tc->t_sock.
+ * rds_tcp_reset_callbacks() switches a path to a new socket and
+ * releases the old one it finds in tc->t_sock, resolving a duelling
+ * SYN.
  *
- * The only functions that set tc->t_sock are rds_tcp_set_callbacks
- * and rds_tcp_reset_callbacks.  Send and receive trust that
- * it is set.  The absence of RDS_CONN_UP bit protects those paths
- * from being called while it isn't set.
+ * tc->t_sock is set by rds_tcp_set_callbacks() and cleared by
+ * rds_tcp_restore_callbacks().  Four paths write it: the active
+ * connect in rds_tcp_conn_path_connect(), which sets it and clears it
+ * again on failure; the accept path in rds_tcp_accept_one(), which
+ * sets it for a path with no socket yet; the teardown in
+ * rds_tcp_conn_path_shutdown(), which clears it; and the swap done
+ * here, which does both.  The connect and accept paths are serialized
+ * against each other by t_conn_path_lock.  Send and receive trust
+ * that it is set: the absence of RDS_CONN_UP protects those paths
+ * from being called while it isn't, and the swap done here runs under
+ * RDS_IN_XMIT so that it cannot interleave with a sender already
+ * inside rds_send_xmit().
  */
 void rds_tcp_reset_callbacks(struct socket *sock,
 			     struct rds_conn_path *cp)
 {
 	struct rds_tcp_connection *tc = cp->cp_transport_data;
-	struct socket *osock = tc->t_sock;
-
-	if (!osock)
-		goto newsock;
+	struct socket *osock;
 
 	/* Need to resolve a duelling SYN between peers.
 	 * We have an outstanding SYN to this peer, which may
 	 * potentially have transitioned to the RDS_CONN_UP state,
 	 * so we must quiesce any send threads before resetting
-	 * cp_transport_data. We quiesce these threads by setting
-	 * cp_state to something other than RDS_CONN_UP, and then
-	 * waiting for any existing threads in rds_send_xmit to
-	 * complete release_in_xmit(). (Subsequent threads entering
-	 * rds_send_xmit() will bail on !rds_conn_up().
+	 * cp_transport_data.  Setting cp_state to something other
+	 * than RDS_CONN_UP stops new senders, and owning RDS_IN_XMIT
+	 * excludes any thread already inside rds_send_xmit() for the
+	 * whole socket swap and the rds_send_path_reset() below.
 	 *
-	 * However an incoming syn-ack at this point would end up
-	 * marking the conn as RDS_CONN_UP, and would again permit
-	 * rds_send_xmi() threads through, so ideally we would
-	 * synchronize on RDS_CONN_UP after lock_sock(), but cannot
-	 * do that: waiting on !RDS_IN_XMIT after lock_sock() may
-	 * end up deadlocking with tcp_sendmsg(), and the RDS_IN_XMIT
-	 * would not get set. As a result, we set c_state to
-	 * RDS_CONN_RESETTTING, to ensure that rds_tcp_state_change
-	 * cannot mark rds_conn_path_up() in the window before lock_sock().
+	 * An incoming syn-ack at this point would end up marking the
+	 * conn as RDS_CONN_UP, and would again permit rds_send_xmit()
+	 * threads through, so ideally we would synchronize on
+	 * RDS_CONN_UP after lock_sock(), but cannot do that: acquiring
+	 * RDS_IN_XMIT after lock_sock() may end up deadlocking with
+	 * tcp_sendmsg(), which takes the socket lock while holding
+	 * RDS_IN_XMIT.  As a result, we set c_state to
+	 * RDS_CONN_RESETTING, to ensure that rds_tcp_state_change
+	 * cannot mark rds_conn_path_up() in the window before
+	 * lock_sock().
 	 *
 	 * Only make that transition if the path is still connecting
 	 * (or already resetting from an earlier duel).  A path in any
@@ -166,7 +172,18 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 	    !rds_conn_path_transition(cp, RDS_CONN_RESETTING,
 				      RDS_CONN_RESETTING))
 		rds_conn_path_drop(cp, 0);
-	wait_event(cp->cp_waitq, !test_bit(RDS_IN_XMIT, &cp->cp_flags));
+	wait_event(cp->cp_waitq,
+		   !test_and_set_bit_lock(RDS_IN_XMIT, &cp->cp_flags));
+
+	/* Read t_sock only while owning RDS_IN_XMIT, never before the
+	 * wait: the teardown in rds_conn_shutdown() releases the old
+	 * socket and clears t_sock, so a pointer sampled earlier can
+	 * be stale by the time we wake up.
+	 */
+	osock = tc->t_sock;
+	if (!osock)
+		goto newsock;
+
 	/* reset receive side state for rds_tcp_data_recv() for osock  */
 	cancel_delayed_work_sync(&cp->cp_send_w);
 	cancel_delayed_work_sync(&cp->cp_recv_w);
@@ -185,6 +202,9 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 	lock_sock(sock->sk);
 	rds_tcp_set_callbacks(sock, cp);
 	release_sock(sock->sk);
+
+	clear_bit_unlock(RDS_IN_XMIT, &cp->cp_flags);
+	wake_up_all(&cp->cp_waitq);
 }
 
 /* Add tc to rds_tcp_tc_list and set tc->t_sock. See comments
-- 
2.53.0



