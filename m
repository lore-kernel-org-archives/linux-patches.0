Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7BF208D0;
	Sat, 12 Sep 2026 09:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204941; cv=none; b=VnMnvqBaCqFZsnVnIKf8tcjDJ/HuGIAqoo0EQuyg76L/TMWl7LtKhaqTiOaEGxJeOJLunTg3KSHJvvQHdyXgWQ81eVjDa2+sqPYWnoQO/TC18sitmsPwP/L0qKAygVLSUBmZeE4PPLRmIIXxwk4dFgc0XBfbQwAt+PJYwwxIW/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204941; c=relaxed/simple;
	bh=L8/Mt7kW7LiK5np310ek4vfvnbRRc/E1jAR17feNH+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMHctrvPb4VJS6/AE+FxFWuj/T3GhQnVGaopqSf/Z+kkumt2RxIqNwGUtv59Ghwt9ms+Z4CKFkcSbQP4AxJMt9nps6s7kucGRnYrgXhigGpA9aGJW4vvfaJT8W90BWpHQQ7LxZeN0mQsehf5hQTdyHyS8UcLSKt0++Vr+sEYKu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQm2Q0Af; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQm2Q0Af"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4C21F000FF;
	Sat, 12 Sep 2026 09:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204939;
	bh=vszaRxIq+oWwYHs5BO1H5ncU/MMfdTLAIgl9HX7M1YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQm2Q0Afcg9SYE+FopFh0gXjXU0cc7Dd7BmgBbR5p9p414wYdu7caas80iGmoAYNT
	 LN4/RZ9yB80iwAmwzSyzH1j7TViaQpuKqZatjnX17UmBLHikRbT5syz+Vw1JReUlkl
	 1UsAYWft/m69ADLYzpVQZvU1kOwIxhIM8hpznJsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9265e754091c2d27ea29@syzkaller.appspotmail.com,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1716/1815] Bluetooth: L2CAP: reject accept queue add unless BT_LISTEN
Date: Sat, 12 Sep 2026 08:57:46 +0200
Message-ID: <20260912065729.260188655@linuxfoundation.org>
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

[ Upstream commit d4bfa78fd67929b62b02013c107973e0c5b7aa9a ]

New sk should not be added to parent socket accept queue after last
l2cap_sock_cleanup_listen() has run in l2cap_sock_teardown_cb() and
state set to BT_CLOSED, as that can result to UAF on dereferencing the
dangling parent reference.

l2cap_sock_new_connection_cb() may race with parent l2cap_chan teardown,
due to chan->state accessed without consistent locking:

  [Task 1]                           [Task 2]
  l2cap_sock_release(parent)         l2cap_connect
    l2cap_sock_shutdown                pchan = l2cap_global_chan_by_psm
      l2cap_chan_lock(pchan)
      l2cap_chan_close
        l2cap_sock_teardown_cb
          pchan->state = BT_CLOSED
      l2cap_chan_unlock(pchan) ------> l2cap_chan_lock(pchan)
                                       l2cap_new_connection
                                         l2cap_sock_new_connection_cb
      l2cap_chan_lock(pchan) <-------- l2cap_chan_unlock(pchan)
      l2cap_sock_kill(parent)          /* bt_sk(sk)->parent dangling */

Fix by adding check for sk_state == BT_LISTEN after acquiring sk lock in
l2cap_sock_new_connection_cb().  Add lock_sock() around sk_state writes
where missing, to avoid data races.

Although the data races on pchan->state should be fixed too, this
defensive sk_state check probably makes sense in any case.

Fixes: 2ff1a41a912d ("Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_state_change_cb()")
Reported-by: syzbot+9265e754091c2d27ea29@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9265e754091c2d27ea29
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Reported-by: syzbot+9265e754091c2d27ea29@syzkaller.appspotmail.com
Tested-by: syzbot+9265e754091c2d27ea29@syzkaller.appspotmail.com
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 782c94cd1bc0a..6de131ac2340c 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1599,6 +1599,11 @@ static int l2cap_sock_new_connection_cb(struct l2cap_chan *chan,
 
 	lock_sock(parent);
 
+	if (parent->sk_state != BT_LISTEN) {
+		release_sock(parent);
+		return -EINVAL;
+	}
+
 	/* Check for backlog size */
 	if (sk_acceptq_is_full(parent)) {
 		BT_DBG("backlog full %d", parent->sk_ack_backlog);
@@ -1762,10 +1767,14 @@ static void l2cap_sock_state_change_cb(struct l2cap_chan *chan, int state,
 	if (!sk)
 		return;
 
+	lock_sock(sk);
+
 	sk->sk_state = state;
 
 	if (err)
 		sk->sk_err = err;
+
+	release_sock(sk);
 }
 
 static struct sk_buff *l2cap_sock_alloc_skb_cb(struct l2cap_chan *chan,
@@ -1841,6 +1850,8 @@ static void l2cap_sock_resume_cb(struct l2cap_chan *chan)
 	if (!sk)
 		return;
 
+	lock_sock(sk);
+
 	if (test_and_clear_bit(FLAG_PENDING_SECURITY, &chan->flags)) {
 		sk->sk_state = BT_CONNECTED;
 		chan->state = BT_CONNECTED;
@@ -1848,6 +1859,8 @@ static void l2cap_sock_resume_cb(struct l2cap_chan *chan)
 
 	clear_bit(BT_SK_SUSPEND, &bt_sk(sk)->flags);
 	sk->sk_state_change(sk);
+
+	release_sock(sk);
 }
 
 static void l2cap_sock_set_shutdown_cb(struct l2cap_chan *chan)
-- 
2.53.0



