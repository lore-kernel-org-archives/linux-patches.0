Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F123A51993C;
	Wed, 30 Sep 2026 17:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788466; cv=none; b=oywHxJealXd1QVSdaV5TazVSz8QbynovMLu2y65in0sQtFjytTYxenK3+Mo1dWJAIfCqf0VCejg5/GMWcEW5XX6n2Y4ERBcaknGs38wEMVKG+tA2XBg+C+R7GqQ+7E8QT0v+qEz4jfpZSiLWpRp+p37BkrFJ03IvNlttmmU7Psk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788466; c=relaxed/simple;
	bh=x1+Ltcbc8z77S6r2mKcPcL+PMuI0qI581kZlcGee4BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9wpFTW06f+cxlOPjOuuJGZewVDSlmhFdowKy1TFMeiDlpmjGvwQP7Z7TuAhN0fFN7NqCOTotNpsSROix72FoDBH7e+SSE6gbNojO8rkIqzZy6sLSgRo4mrugGHjFxODU9Gp4Pv6Y0Fn/0Hj3l8BdW1oVFhw0uJLOqVhu1F0Luc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCzNM8Kw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCzNM8Kw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB0B1F000FF;
	Wed, 30 Sep 2026 17:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788464;
	bh=YLnVOZ91U7zI03SQqqpkcarXYDXy2wwe5/FVlII4D3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jCzNM8KwTHkjwC+HfVStaAkyoiYO1Dv081dH0zv+YJ54nQSjs92vFewydY585yKWQ
	 NxGjRN7hwhyy0YSXvhVh83IxL7e5Jzdax9+WffXZXIbtjrem8rZm/gQlULLgfswNQx
	 +rOPtyVE7DhpPlnCG28L2kYGEF23NjSPEfde6QkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/877] Bluetooth: ISO: set BT_LISTEN before requesting a BIG sync
Date: Wed, 30 Sep 2026 17:17:25 +0200
Message-ID: <20260930152417.623047675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 296e7f3c5071cc02dc22e1566e759179fa1792ae ]

A BIS connection is matched to its parent socket by looking for a
socket in BT_LISTEN state with the same BIG handle:

  iso_conn_ready()
    if (test_bit(HCI_CONN_BIG_SYNC, &hcon->flags))
            parent = iso_get_sock(hdev, &hcon->src, &hcon->dst,
                                  BT_LISTEN, iso_match_big_hcon, hcon);

The socket was only moved to BT_LISTEN after iso_conn_big_sync()
returned, while the LE BIG Create Sync command has already been queued
by then. If the BIG sync is established before the state is updated,
which is easy to hit with an emulated controller as the command may
complete in a few hundred microseconds, no parent is found and the BIS
connections are never notified to the listening socket.

The user space is then left waiting for connections that never arrive,
e.g. bluetoothd never completes a MediaTransport1.Acquire of a
Broadcast Sink transport.

Move the socket to BT_LISTEN before requesting the BIG sync, so the
state is visible by the time the command is queued, and restore the
previous state if the request could not be started. Since the socket is
briefly visible as a listening socket, child sockets may have been
queued in the meantime, so drain the accept queue before restoring the
state: the cleanup paths of BT_CONNECT2/BT_CONNECTED don't do it and the
children would be left with a dangling parent pointer.

Fixes: fbdc4bc47268 ("Bluetooth: ISO: Use defer setup to separate PA sync and BIG sync")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 52 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 11 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 8cdfe3b6e1235..3cf4ef291bf54 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -738,19 +738,24 @@ static void iso_sock_destruct(struct sock *sk)
 	skb_queue_purge(&sk->sk_write_queue);
 }
 
-static void iso_sock_cleanup_listen(struct sock *parent)
+/* Close not yet accepted channels */
+static void iso_sock_flush_accept_q(struct sock *parent)
 {
 	struct sock *sk;
 
-	BT_DBG("parent %p", parent);
-
-	/* Close not yet accepted channels */
 	while ((sk = bt_accept_dequeue(parent, NULL))) {
 		iso_sock_close(sk);
 		iso_sock_kill(sk);
 		/* Drop the reference handed back by bt_accept_dequeue(). */
 		sock_put(sk);
 	}
+}
+
+static void iso_sock_cleanup_listen(struct sock *parent)
+{
+	BT_DBG("parent %p", parent);
+
+	iso_sock_flush_accept_q(parent);
 
 	/* If listening socket has a hcon, properly disconnect it */
 	if (iso_pi(parent)->conn && iso_pi(parent)->conn->hcon) {
@@ -1524,6 +1529,13 @@ static int iso_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 		switch (sk->sk_state) {
 		case BT_CONNECT2:
 			if (test_bit(BT_SK_PA_SYNC, &pi->flags)) {
+				/* Move to BT_LISTEN before requesting the BIG
+				 * sync: the BIS connections are matched to a
+				 * parent socket in BT_LISTEN state, and they
+				 * may be notified before the request returns.
+				 */
+				sk->sk_state = BT_LISTEN;
+
 				release_sock(sk);
 				err = iso_conn_big_sync(sk);
 				lock_sock(sk);
@@ -1532,12 +1544,20 @@ static int iso_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 				 * connection may have been torn down
 				 * meanwhile and iso_chan_del() may have
 				 * already moved the socket to BT_CLOSED.
-				 * Only move on to BT_LISTEN if the BIG sync
-				 * was actually started and nothing else has
-				 * changed the state.
+				 * Only move back if the BIG sync could not be
+				 * started and nothing else has changed the
+				 * state.
 				 */
-				if (!err && sk->sk_state == BT_CONNECT2)
-					sk->sk_state = BT_LISTEN;
+				if (err && sk->sk_state == BT_LISTEN) {
+					/* Discard any child socket that may
+					 * have been queued while the socket
+					 * was in BT_LISTEN, as the cleanup of
+					 * BT_CONNECT2 doesn't drain the
+					 * accept queue.
+					 */
+					iso_sock_flush_accept_q(sk);
+					sk->sk_state = BT_CONNECT2;
+				}
 			} else {
 				iso_conn_defer_accept(pi->conn->hcon);
 				sk->sk_state = BT_CONFIG;
@@ -1547,12 +1567,22 @@ static int iso_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 			break;
 		case BT_CONNECTED:
 			if (test_bit(BT_SK_PA_SYNC, &iso_pi(sk)->flags)) {
+				/* As above, the BIS connections may be
+				 * notified before the request returns.
+				 */
+				sk->sk_state = BT_LISTEN;
+
 				release_sock(sk);
 				err = iso_conn_big_sync(sk);
 				lock_sock(sk);
 
-				if (!err && sk->sk_state == BT_CONNECTED)
-					sk->sk_state = BT_LISTEN;
+				if (err && sk->sk_state == BT_LISTEN) {
+					/* As above, don't leave any child
+					 * socket behind in the accept queue.
+					 */
+					iso_sock_flush_accept_q(sk);
+					sk->sk_state = BT_CONNECTED;
+				}
 				early_ret = true;
 			}
 
-- 
2.53.0



