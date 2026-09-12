Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BDC3806AF;
	Sat, 12 Sep 2026 09:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204951; cv=none; b=gcC2GcUYXj/rlcxeIe4vPmgXJtnEo0Zwpn2mupCOWaQpxBtJXpcsdSWhvRfpKblRhJ22VkqJmOTAreelE25eOnex5RxjLF+C3tFf0bdn8xV4DNloRt1Yfn+n8JE4fdVMDXmhYlfc2137FGgZGZ9Ot7Z2xcd1zg6ZS7AhTDCVrjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204951; c=relaxed/simple;
	bh=hGuCTq5nOw8Ddh/TJszLom2vIblLPHHPweOzzdvYy2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXCSciKMn08XU0WdNWfEAfzz4yqtxbn/IMyTMQhdW6NYIhjS6F/Z5taTeKTRTTnc++TqS1sRq8RNwdEPrps/Y4EzAxel2pur1GFL0mYFNqB+IQo+hM49HdWfeTe4KB3OeXMKyjjInaW+pYapGhptlH6SOkw3jRVT9AOd54LVH20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAiE0nx/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAiE0nx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38B21F000FF;
	Sat, 12 Sep 2026 09:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204949;
	bh=tENylGo5QxLnwp5+jIYWq9Yumhb3UJaI0kdn+J5eUrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AAiE0nx/PuzPaUPtvT+baRDewARlipJ4rryRVbo9dFxpW1uzh41d4y/z2p+0W9mx3
	 GWCqw7pAyk0Eb9jWQgabr6zf7ZiUgbVJJ7+Prdq1u7z9YCPEqC0tVfnl7cJsM0Lr6c
	 oRaiNkwQ8d7YM63PYGoCMEp5KejekWbVlzaoTqNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e6382a2f53f5fc7453ac@syzkaller.appspotmail.com,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1718/1815] Bluetooth: L2CAP: fix race l2cap_sock_cleanup_listen() vs. put_chan
Date: Sat, 12 Sep 2026 08:57:48 +0200
Message-ID: <20260912065729.306540488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index ef6ce1c20a4f0..3d9a32094347c 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -699,7 +699,12 @@ struct l2cap_rx_busy {
 
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
index 6de131ac2340c..143654a47989d 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1344,7 +1344,12 @@ static void l2cap_sock_kill(struct sock *sk)
 
 	BT_DBG("sk %p state %s", sk, state_to_string(sk->sk_state));
 
+	/* Take lock to synchronize against access without owning sk->sk_socket,
+	 * eg. in l2cap_sock_cleanup_listen(). proto_ops etc. don't need lock.
+	 */
+	lock_sock(sk);
 	l2cap_sock_put_chan(sk);
+	release_sock(sk);
 
 	/* Kill poor orphan */
 	sock_set_flag(sk, SOCK_DEAD);
@@ -1547,14 +1552,10 @@ static void l2cap_sock_cleanup_listen(struct sock *parent)
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
@@ -1564,10 +1565,12 @@ static void l2cap_sock_cleanup_listen(struct sock *parent)
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



