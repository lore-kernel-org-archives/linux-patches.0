Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D658D2EC09B;
	Sat, 12 Sep 2026 11:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212201; cv=none; b=ENQyOfyARitJBeVmMsURjtBi8kVQM/FQnwy08KEXZXdCvTpvi9GAqyTS+AOu1ldQQZSxjWcqlfn5aQD00vuStGo9R3HQZ35Nr9JXRFemQit75VU8WND7YvjTdmrf+WtjyJnn/RWjbmTyOwjXTOnjLNjs0I9Buvcl9BCrgDUlt60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212201; c=relaxed/simple;
	bh=j+FYjgMPQtKlI+pmAg8pe/9mvPwuLr9kE0oai0ZnOEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUlmEZq0E2es6kUhU/rcfNStTpXT+uRc5GEZQHMmg7MtQhUAUzor1j7/mtQ6l6brzVNGXuhDBqa5j7Ducnk1HgKB+TZMQvm4wUqmjGj651MT9/+9wooYFPaahgpgSo8IB22UJWw1kUbmwtCVw7eE7UKOrT9KYjtv1+Nx64dQrv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qaIQ21V+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qaIQ21V+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896071F000FF;
	Sat, 12 Sep 2026 11:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212199;
	bh=j1UgqdUu7w1JKowxwEkeRWRA+2ZT6jo/CalARC56hgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qaIQ21V+uyV4NOkQDRgeAw/OmUkpAh/69fZDs4iq4gNOIiuVgN4ai5sLUg8rrwErY
	 DOb2Ca5ugZuVQq2Rz8fABPQHw+2hFqKIbaC0OHi/ztip9OU7T7/L+CfUtNABen1Xmx
	 2Ozt0yDs0Hop4AGiJF87FIiwJcOT9mC9QHN9pKwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e6382a2f53f5fc7453ac@syzkaller.appspotmail.com,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1389/1518] Bluetooth: L2CAP: fix race l2cap_sock_cleanup_listen() vs. put_chan
Date: Sat, 12 Sep 2026 08:59:18 +0200
Message-ID: <20260912065654.969130069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 66d6ef18548ae6d7dd452b84115fc82c0a73a4ea ]

For L2CAP sockets without owning sk->sk_socket, reading
l2cap_pi(sk)->chan may race against concurrent l2cap_sock_kill() ->
l2cap_sock_put_chan().  This excludes simultaneous proto_ops callbacks,
but access in l2cap_sock_cleanup_listen() has unsafe lockless read.

 [Task 1]                         [Task 2 (hdev->workqueue)]
 l2cap_sock_release(parent)       l2cap_disconn_cfm
   l2cap_sock_cleanup_listen        l2cap_conn_del
     bt_accept_dequeue                l2cap_chan_del
       lock_sock(sk)                    l2cap_sock_teardown_cb
       bt_accept_unlink
         bt_sk(sk)->parent = NULL
       release_sock(sk) ----------------> lock_sock(sk)
                                          parent = /* NULL */
     lock_sock(sk) <--------------------- release_sock(sk)
                                          sock_set_flag(sk, SOCK_ZAPPED)
                                      l2cap_sock_close_cb
                                        l2cap_sock_kill(sk)
                                          l2cap_sock_put_chan
     chan = READ l2cap_pi(sk)->chan         l2cap_pi(sk)->chan = NULL
     l2cap_chan_hold_unless_zero            l2cap_put_chan(chan)
       kref_get_unless_zero(&chan->ref)

Task 1 may observe NULL which causes null-ptr-deref.

Fix the race by taking lock_sock() in l2cap_sock_kill() to
synchronize with l2cap_sock_cleanup_listen().  hold_unless_zero() is not
needed here, l2cap_pi(sk)->chan owns reference if it is non-NULL.

Clarify code comments vs. locking.

Fixes: 6fef032af009 ("Bluetooth: L2CAP: Fix use-after-free in l2cap_sock_new_connection_cb()")
Reported-by: syzbot+e6382a2f53f5fc7453ac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e6382a2f53f5fc7453ac
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/l2cap.h |  5 +++++
 net/bluetooth/l2cap_sock.c    | 23 +++++++++++++----------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 265afda2e13bc..2f7c367d68ce4 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -702,7 +702,12 @@ struct l2cap_rx_busy {
 
 struct l2cap_pinfo {
 	struct bt_sock		bt;
+
+	/* With owning sk_socket chan may be read without lock, other access
+	 * should hold lock_sock.
+	 */
 	struct l2cap_chan	*chan;
+
 	struct list_head	rx_busy;
 };
 
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 8dd2946297709..d332cd999d8c0 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1284,7 +1284,12 @@ static void l2cap_sock_kill(struct sock *sk)
 
 	BT_DBG("sk %p state %s", sk, state_to_string(sk->sk_state));
 
+	/* Take lock to synchronize against access without owning sk->sk_socket,
+	 * eg. in l2cap_sock_cleanup_listen(). proto_ops etc. don't need lock.
+	 */
+	lock_sock(sk);
 	l2cap_sock_put_chan(sk);
+	release_sock(sk);
 
 	/* Kill poor orphan */
 	sock_set_flag(sk, SOCK_DEAD);
@@ -1487,14 +1492,10 @@ static void l2cap_sock_cleanup_listen(struct sock *parent)
 	 * establish sk_lock -> conn->lock and invert the established
 	 * conn->lock -> chan->lock -> sk_lock order (lockdep deadlock).
 	 *
-	 * Instead, briefly take the child sk lock to fetch and pin its chan.
-	 * l2cap_conn_del() reaches the chan free only via
-	 * l2cap_chan_del() -> l2cap_sock_teardown_cb(), which itself takes
-	 * the child sk lock; holding it across l2cap_chan_hold_unless_zero()
-	 * therefore guarantees the chan cannot be freed while we read and
-	 * pin it (hold_unless_zero() additionally skips a chan already past
-	 * its last reference).  We then drop the sk lock before taking
-	 * chan->lock, so sk and chan locks are never held together.
+	 * Instead, briefly take the child sk lock to synchronize vs.
+	 * l2cap_sock_kill that puts l2cap_pi(sk)->chan. We then drop the sk
+	 * lock before taking chan->lock, so sk and chan locks are never held
+	 * together.
 	 *
 	 * Since we cannot call l2cap_chan_close() without conn->lock,
 	 * schedule l2cap_chan_timeout to close the channel; it already
@@ -1504,10 +1505,12 @@ static void l2cap_sock_cleanup_listen(struct sock *parent)
 		struct l2cap_chan *chan;
 
 		lock_sock_nested(sk, L2CAP_NESTING_NORMAL);
-		chan = l2cap_chan_hold_unless_zero(l2cap_pi(sk)->chan);
+		chan = l2cap_pi(sk)->chan;
+		if (chan)
+			l2cap_chan_hold(chan);
 		release_sock(sk);
 		if (!chan) {
-			/* l2cap_conn_del() already tearing this child down */
+			/* Already torn down */
 			sock_put(sk);
 			continue;
 		}
-- 
2.53.0



