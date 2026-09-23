Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6D044CAD7;
	Wed, 23 Sep 2026 14:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173209; cv=none; b=dwg7od3FA5krZmIfZV1T/b2B48NjiR4Toi7zPayQMBfCmQmfY0UYj3yfK1T8Wq4P5Ofk/hpM8SfzQs/kxudS8RCKr+3CoRaVheeC2FjqV4jEC68cJv3RYj8u8qEj0jv7jgEhsQc1Kpt9YmQUyjeVxklT0zGWd48ZYG3PqrIY6Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173209; c=relaxed/simple;
	bh=Gg+qOA3heZhRyAvXvFX4WLgR60ZK+qniaNRRnJ3G3XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tm2u8TDot+eeLJIX6EF4PYz8aEsBgfsvWS9A3284RakRnriGsjy3FVwlqy+nf8H60QEfIsJgzQwAAN6HAE/3ETmqrWSPuopQYNbaucykvBI+cpwWxP2X6FWTgK4eV09RPUkwYdeARr9TcmZW4d3j+TAtLb+m/KVylAHh8MvQd+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjwasChU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjwasChU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1676B1F000FF;
	Wed, 23 Sep 2026 14:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173207;
	bh=N0Lptacweudu9CPZR7U3pOr5fRfSsGmBlVwXQpV7n90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjwasChUeCrYnCb1VPOaKHMqrXGDmlmeoAFbnmU3P7G1/iJ7arblp0CRioz6uhBFl
	 yHpvV9M7k0sCRGK564GI0LgYt+Cd9lv63PGOXlnN8pdqC2PXLnozkBcF2JhXHjT65u
	 FLC26+lyvALs35M6ZRcoj01dkr0JI9N1Pk1twwxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 174/438] Bluetooth: ISO: set BT_LISTEN before requesting a BIG sync
Date: Wed, 23 Sep 2026 16:03:15 +0200
Message-ID: <20260923140649.278966348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
index 4de332b8901f2..eb99653f33f91 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -819,19 +819,24 @@ static void iso_sock_destruct(struct sock *sk)
 	skb_queue_purge(&sk->sk_error_queue);
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
@@ -1737,6 +1742,13 @@ static int iso_sock_recvmsg(struct socket *sock, struct msghdr *msg,
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
@@ -1745,12 +1757,20 @@ static int iso_sock_recvmsg(struct socket *sock, struct msghdr *msg,
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
@@ -1760,12 +1780,22 @@ static int iso_sock_recvmsg(struct socket *sock, struct msghdr *msg,
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



