Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483E12E92BA;
	Thu, 28 May 2026 20:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000486; cv=none; b=E2ein/5B5GVq+llrj+JLLNzEKP7Y8wDpU6arH55eWnLitMdmiE9NHANWmhcWHCfx+lxT5xQgSyH9YX79NGuylUZKo9bk53PgStkigI5eoS5oXw/my55rDxI3DonLq+gfP5bfojMJIsIR2Ij4ud1H33Pbb6rGaIHNZRCeFom+ccU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000486; c=relaxed/simple;
	bh=1Zw0wNL3XDboAhPYXo5CQ6oAMEWsS/pXHFgqCYG/LGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KI+vhUfKk/BoQZoEW5K14eySlEu4MT/fUJ9Z7E+OxAVEeKwHgW6klAfO/Ba9m7lTOXPVctqy3nNFR3EgqlhyGc8vaHcrOVwiGvYWXFcmZkDAAob12ym4d1qPUaBVPtt0a+X21gfrROSZVBzN7ASK2Fk5AGbF5n13QC+Bu3Ik4Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0Y88NyJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0Y88NyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6219F1F000E9;
	Thu, 28 May 2026 20:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000484;
	bh=TvIxX9NksvHEPLViH5ehRPXYzEgR3UsH+JChw+a+020=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0Y88NyJFDSZfeyZJnyR5E6Jv6/MWx2LtrEuUUM51/2UETHxYFQtnZb2bchWFHHGp
	 RI2x/kfpLrTKrQMmcUFJh2k43Ts0ygRSI8Sb0iG/xKPDl50BlcYuf2oJYIWc0vNTxY
	 rqMVQ6xFTD+tiluzvW9OxHlinFL4RkIWgA3KoqBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	=?UTF-8?q?Safa=20Karaku=C5=9F?= <safa.karakus@secunnix.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 062/272] Bluetooth: fix UAF in l2cap_sock_cleanup_listen() vs l2cap_conn_del()
Date: Thu, 28 May 2026 21:47:16 +0200
Message-ID: <20260528194631.114673588@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Safa Karakuş <safa.karakus@secunnix.com>

commit ab1513597c6cf17cd1ad2a21e3b045421b48e022 upstream.

bt_accept_dequeue() unlinks a not-yet-accepted child from the parent
accept queue and release_sock()s it before returning, so the returned
sk has no caller reference and is unlocked.

l2cap_sock_cleanup_listen() walks these children on listening-socket
close.  A concurrent HCI disconnect drives hci_rx_work ->
l2cap_conn_del() which runs l2cap_chan_del() + l2cap_sock_kill() and
frees the child sk and its l2cap_chan; cleanup_listen() then uses both:

  BUG: KASAN: slab-use-after-free in l2cap_sock_kill
    l2cap_sock_kill / l2cap_sock_cleanup_listen / __x64_sys_close
  Freed by: l2cap_conn_del -> l2cap_sock_close_cb -> l2cap_sock_kill

This is distinct from the two fixes already in this area: commit
e83f5e24da741 ("Bluetooth: serialize accept_q access") serialises the
accept_q list/poll and takes temporary refs inside bt_accept_dequeue(),
and CVE-2025-39860 serialises the userspace close()/accept() race by
calling cleanup_listen() under lock_sock() in l2cap_sock_release().
Neither covers l2cap_conn_del() running from hci_rx_work, so this UAF
still reproduces on current bluetooth/master.

Take the reference at the source: bt_accept_dequeue() does sock_hold()
while sk is still locked, before release_sock(); callers sock_put().
cleanup_listen() pins the chan with l2cap_chan_hold_unless_zero() under
a brief child sk lock (serialising vs l2cap_sock_teardown_cb()), drops
it before l2cap_chan_lock(), and skips a duplicate l2cap_sock_kill() on
SOCK_DEAD.  conn->lock is not taken here: cleanup_listen() runs under
the parent sk lock and that would invert
conn->lock -> chan->lock -> sk_lock (lockdep).

KASAN/SMP: an unprivileged listen/close vs HCI-disconnect race produced
12 use-after-free reports per run before this change; 0, and no lockdep
report, over 1600+ raced iterations after it on bluetooth/master.

Fixes: 15f02b910562 ("Bluetooth: L2CAP: Add initial code for Enhanced Credit Based Mode")
Cc: stable@vger.kernel.org
Reported-by: Siwei Zhang <oss@fourdim.xyz>
Reviewed-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Safa Karakuş <safa.karakus@secunnix.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/af_bluetooth.c |   10 ++++++++
 net/bluetooth/iso.c          |    9 ++++++-
 net/bluetooth/l2cap_sock.c   |   51 +++++++++++++++++++++++++++++++++++++------
 net/bluetooth/rfcomm/sock.c  |    9 ++++++-
 net/bluetooth/sco.c          |    9 ++++++-
 5 files changed, 78 insertions(+), 10 deletions(-)

--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -306,6 +306,16 @@ restart:
 			if (newsock)
 				sock_graft(sk, newsock);
 
+			/* Hand the caller a reference taken while sk is
+			 * still locked.  bt_accept_unlink() just dropped
+			 * the accept-queue reference; without this hold a
+			 * concurrent teardown (e.g. l2cap_conn_del() ->
+			 * l2cap_sock_kill()) could free sk between
+			 * release_sock() and the caller using it.  Every
+			 * caller drops this with sock_put() when done.
+			 */
+			sock_hold(sk);
+
 			release_sock(sk);
 			return sk;
 		}
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -722,6 +722,8 @@ static void iso_sock_cleanup_listen(stru
 	while ((sk = bt_accept_dequeue(parent, NULL))) {
 		iso_sock_close(sk);
 		iso_sock_kill(sk);
+		/* Drop the reference handed back by bt_accept_dequeue(). */
+		sock_put(sk);
 	}
 
 	/* If listening socket has a hcon, properly disconnect it */
@@ -1263,8 +1265,13 @@ static int iso_sock_accept(struct socket
 		}
 
 		ch = bt_accept_dequeue(sk, newsock);
-		if (ch)
+		if (ch) {
+			/* Drop the bridging ref from bt_accept_dequeue();
+			 * the grafted socket keeps ch alive from here.
+			 */
+			sock_put(ch);
 			break;
+		}
 
 		if (!timeo) {
 			err = -EAGAIN;
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -349,8 +349,13 @@ static int l2cap_sock_accept(struct sock
 		}
 
 		nsk = bt_accept_dequeue(sk, newsock);
-		if (nsk)
+		if (nsk) {
+			/* Drop the bridging ref from bt_accept_dequeue();
+			 * the grafted socket keeps nsk alive from here.
+			 */
+			sock_put(nsk);
 			break;
+		}
 
 		if (!timeo) {
 			err = -EAGAIN;
@@ -1444,22 +1449,54 @@ static void l2cap_sock_cleanup_listen(st
 	BT_DBG("parent %p state %s", parent,
 	       state_to_string(parent->sk_state));
 
-	/* Close not yet accepted channels */
+	/* Close not yet accepted channels.
+	 *
+	 * bt_accept_dequeue() now returns sk with an extra reference held
+	 * (taken while sk was still locked) so a concurrent l2cap_conn_del()
+	 * -> l2cap_sock_kill() cannot free sk under us.
+	 *
+	 * cleanup_listen() runs under the parent sk lock, so unlike
+	 * l2cap_sock_shutdown() we must NOT take conn->lock here: that would
+	 * establish sk_lock -> conn->lock and invert the established
+	 * conn->lock -> chan->lock -> sk_lock order (lockdep deadlock).
+	 *
+	 * Instead, briefly take the child sk lock to fetch and pin its chan.
+	 * l2cap_conn_del() reaches the chan free only via
+	 * l2cap_chan_del() -> l2cap_sock_teardown_cb(), which itself takes
+	 * the child sk lock; holding it across l2cap_chan_hold_unless_zero()
+	 * therefore guarantees the chan cannot be freed while we read and
+	 * pin it (hold_unless_zero() additionally skips a chan already past
+	 * its last reference).  We then drop the sk lock before taking
+	 * chan->lock, so sk and chan locks are never held together.
+	 */
 	while ((sk = bt_accept_dequeue(parent, NULL))) {
-		struct l2cap_chan *chan = l2cap_pi(sk)->chan;
+		struct l2cap_chan *chan;
+
+		lock_sock_nested(sk, L2CAP_NESTING_NORMAL);
+		chan = l2cap_chan_hold_unless_zero(l2cap_pi(sk)->chan);
+		release_sock(sk);
+		if (!chan) {
+			/* l2cap_conn_del() already tearing this child down */
+			sock_put(sk);
+			continue;
+		}
 
 		BT_DBG("child chan %p state %s", chan,
 		       state_to_string(chan->state));
 
-		l2cap_chan_hold(chan);
 		l2cap_chan_lock(chan);
-
 		__clear_chan_timer(chan);
 		l2cap_chan_close(chan, ECONNRESET);
-		l2cap_sock_kill(sk);
-
+		/* l2cap_conn_del() may already have killed this socket
+		 * (it sets SOCK_DEAD); skip the duplicate to avoid a
+		 * double sock_put()/l2cap_chan_put().
+		 */
+		if (!sock_flag(sk, SOCK_DEAD))
+			l2cap_sock_kill(sk);
 		l2cap_chan_unlock(chan);
+
 		l2cap_chan_put(chan);
+		sock_put(sk);
 	}
 }
 
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -180,6 +180,8 @@ static void rfcomm_sock_cleanup_listen(s
 	while ((sk = bt_accept_dequeue(parent, NULL))) {
 		rfcomm_sock_close(sk);
 		rfcomm_sock_kill(sk);
+		/* Drop the reference handed back by bt_accept_dequeue(). */
+		sock_put(sk);
 	}
 
 	parent->sk_state  = BT_CLOSED;
@@ -496,8 +498,13 @@ static int rfcomm_sock_accept(struct soc
 		}
 
 		nsk = bt_accept_dequeue(sk, newsock);
-		if (nsk)
+		if (nsk) {
+			/* Drop the bridging ref from bt_accept_dequeue();
+			 * the grafted socket keeps nsk alive from here.
+			 */
+			sock_put(nsk);
 			break;
+		}
 
 		if (!timeo) {
 			err = -EAGAIN;
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -433,6 +433,8 @@ static void sco_sock_cleanup_listen(stru
 	while ((sk = bt_accept_dequeue(parent, NULL))) {
 		sco_sock_close(sk);
 		sco_sock_kill(sk);
+		/* Drop the reference handed back by bt_accept_dequeue(). */
+		sock_put(sk);
 	}
 
 	parent->sk_state  = BT_CLOSED;
@@ -705,8 +707,13 @@ static int sco_sock_accept(struct socket
 		}
 
 		ch = bt_accept_dequeue(sk, newsock);
-		if (ch)
+		if (ch) {
+			/* Drop the bridging ref from bt_accept_dequeue();
+			 * the grafted socket keeps ch alive from here.
+			 */
+			sock_put(ch);
 			break;
+		}
 
 		if (!timeo) {
 			err = -EAGAIN;


