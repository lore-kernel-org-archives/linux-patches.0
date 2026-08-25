Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFAE1F2B88;
	Tue, 25 Aug 2026 13:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665065; cv=none; b=AeeFgMQpM8B6E2g5XzfVc/f8lu8y4ya9rqNYFflvefvfHu5gtUWXoNqiLIobgQMCJOYVz4RPv6YXHVY6YUW6smz19OSfcUd0e9HjSF22XiqHLN6Szzj3L7NegOpTm3CqRpWYEoPHbSDwo14rcJ+d6pTApeb44yUJnox00v8cTho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665065; c=relaxed/simple;
	bh=jdRe/6SbmoSb5DdgvsJVNBmTc2Lc68JOrK46m8ayPzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFdFmxL2d56gpYSXzKSIuWSRx8B2VCIF3ueZ4vP2yEHp+4uOMZscFM8ROqhdGkdYh/qUwoiZXocgnZ1voTM9ZcxymzJHNQve9qbHS0FR77nn/gkSBcUBAkp/OXzb1HkQ73D7fau9qwLTK2qiReODt+gLkNHK+0z7ZI8XCMG4a/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOo6G1dw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOo6G1dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A551F000E9;
	Tue, 25 Aug 2026 13:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665064;
	bh=Nj8jQ2iA/2+++ZxO79qqA75WTFQ9fbRUoqO6qgS803U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gOo6G1dwC8q6pWocQ1GdArtWUUli0gk7OV7mnBLRZ7YVaG0lN3GZLX3IbbAxYkqjy
	 yyEE4C+6yMp4WkQr5B7uzQjXpyMMCDiftbj4dJ4IBkCp/1J1a4lxOYw6H7J0XOc7/T
	 k90WMruGZTAr2KhmTCCfTpijxJolXRxyiQCFmouk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.1 098/101] Bluetooth: ISO: do not force BT_LISTEN after a failed BIG sync
Date: Tue, 25 Aug 2026 15:26:16 +0200
Message-ID: <20260825132545.614667715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

commit 9838a80096ba472d5e03057136a112631aabae6e upstream.

iso_sock_recvmsg() handles the deferred setup of a broadcast sink by
dropping the socket lock, calling iso_conn_big_sync() and taking the
lock again:

	release_sock(sk);
	iso_conn_big_sync(sk);
	lock_sock(sk);

	sk->sk_state = BT_LISTEN;

The state is written unconditionally, but iso_conn_big_sync() returns
void and has paths that do nothing at all: hci_get_route() may fail, and
after re-acquiring the socket lock the connection may already be gone,
in which case it bails out without ever issuing an LE BIG Create Sync.

While the lock is dropped the connection can be torn down, for example
when the controller reports HCI_EV_LE_PA_SYNC_LOST:

	hci_le_pa_sync_lost_evt()
	  hci_disconn_cfm() -> iso_disconn_cfm() -> iso_conn_del()
	    iso_chan_del()
	      iso_pi(sk)->conn = NULL
	      sk->sk_state = BT_CLOSED
	      sock_set_flag(sk, SOCK_ZAPPED)

iso_conn_big_sync() then finds conn == NULL and returns, but the caller
still overwrites the BT_CLOSED that iso_chan_del() has just set. The
socket ends up marked BT_LISTEN with no connection, so recvmsg() reports
success for a setup that never happened and a later accept() waits for
BIS connections that can never arrive instead of failing.

A concurrent shutdown() reaches the same write by another route:
__iso_sock_close() takes the BT_CONNECT2 PA sync path to
iso_sock_disconn(), which sets BT_DISCONN but leaves conn and
conn->hcon in place, so iso_conn_big_sync() succeeds and BT_LISTEN is
written over BT_DISCONN. Both the BT_CONNECT2 and the BT_CONNECTED case
write the state the same way.

Let iso_conn_big_sync() report whether the BIG sync was started, and
only move the socket to BT_LISTEN when it was and when the state has not
changed while the lock was dropped, mirroring what the BT_CONNECT case
of the same switch already does with iso_connect_cis(). Both conditions
are needed, the error alone does not cover the shutdown() race.

This corrupts the socket state machine only, it is not a memory safety
issue. KASAN and lockdep stayed quiet in all of the runs below.

Reproduced with an emulated controller over /dev/vhci on a KASAN +
PROVE_LOCKING kernel. A PA sync broadcast sink socket is driven to
BT_CONNECT2 and recvmsg() on it is raced against teardown, with a debug
delay inside the lock-dropped section to widen the window:

 - HCI_EV_LE_PA_SYNC_LOST injected: 64 of 64 rounds left the socket in
   BT_LISTEN with the connection gone, recvmsg() returned 0 and accept()
   on that fd returned EAGAIN, which iso_sock_accept() can only do while
   the socket is BT_LISTEN. With this patch, 0 of 64, recvmsg() returns
   an error and accept() returns EBADFD.

 - shutdown() instead of a controller event: 24 of 32 rounds wedged in
   BT_LISTEN, 0 of 32 with this patch. With only the error check in
   place and a short window, one round still wedged while recvmsg()
   returned 0, which is the case the state re-check covers.

An unraced control round behaves the same before and after: recvmsg()
returns 0, the socket reaches BT_LISTEN and an LE BIG Create Sync is
issued.

Fixes: 7a17308c1788 ("Bluetooth: iso: Fix circular lock in iso_conn_big_sync")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/iso.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1657,9 +1657,9 @@ static void iso_conn_defer_accept(struct
 	hci_send_cmd(hdev, HCI_OP_LE_ACCEPT_CIS, sizeof(cp), &cp);
 }
 
-static void iso_conn_big_sync(struct sock *sk)
+static int iso_conn_big_sync(struct sock *sk)
 {
-	int err;
+	int err = 0;
 	struct hci_dev *hdev;
 	struct iso_conn *conn;
 	bdaddr_t src, dst;
@@ -1674,7 +1674,7 @@ static void iso_conn_big_sync(struct soc
 	hdev = hci_get_route(&dst, &src, src_type);
 
 	if (!hdev)
-		return;
+		return -EHOSTUNREACH;
 
 	/* hci_le_big_create_sync requires hdev lock to be held, since
 	 * it enqueues the HCI LE BIG Create Sync command via
@@ -1690,8 +1690,10 @@ static void iso_conn_big_sync(struct soc
 	 * both before dereferencing conn->hcon.
 	 */
 	conn = iso_pi(sk)->conn;
-	if (!conn || !conn->hcon)
+	if (!conn || !conn->hcon) {
+		err = -ENOTCONN;
 		goto unlock;
+	}
 
 	if (!test_and_set_bit(BT_SK_BIG_SYNC, &iso_pi(sk)->flags)) {
 		err = hci_conn_big_create_sync(hdev, conn->hcon,
@@ -1707,6 +1709,8 @@ unlock:
 	release_sock(sk);
 	hci_dev_unlock(hdev);
 	hci_dev_put(hdev);
+
+	return err;
 }
 
 static int iso_sock_recvmsg(struct socket *sock, struct msghdr *msg,
@@ -1731,10 +1735,19 @@ static int iso_sock_recvmsg(struct socke
 		case BT_CONNECT2:
 			if (test_bit(BT_SK_PA_SYNC, &pi->flags)) {
 				release_sock(sk);
-				iso_conn_big_sync(sk);
+				err = iso_conn_big_sync(sk);
 				lock_sock(sk);
 
-				sk->sk_state = BT_LISTEN;
+				/* The socket lock was dropped, so the
+				 * connection may have been torn down
+				 * meanwhile and iso_chan_del() may have
+				 * already moved the socket to BT_CLOSED.
+				 * Only move on to BT_LISTEN if the BIG sync
+				 * was actually started and nothing else has
+				 * changed the state.
+				 */
+				if (!err && sk->sk_state == BT_CONNECT2)
+					sk->sk_state = BT_LISTEN;
 			} else {
 				iso_conn_defer_accept(pi->conn->hcon);
 				sk->sk_state = BT_CONFIG;
@@ -1745,10 +1758,11 @@ static int iso_sock_recvmsg(struct socke
 		case BT_CONNECTED:
 			if (test_bit(BT_SK_PA_SYNC, &iso_pi(sk)->flags)) {
 				release_sock(sk);
-				iso_conn_big_sync(sk);
+				err = iso_conn_big_sync(sk);
 				lock_sock(sk);
 
-				sk->sk_state = BT_LISTEN;
+				if (!err && sk->sk_state == BT_CONNECTED)
+					sk->sk_state = BT_LISTEN;
 				early_ret = true;
 			}
 


