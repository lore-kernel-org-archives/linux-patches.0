Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA064BEE52;
	Sat, 12 Sep 2026 16:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231902; cv=none; b=VwHdT4sjGcKet+MdtqO/7a/zt8wP9d+9blr3lzwSIMAYorqjLjGMdGBOiWw5MuByoFha0GtrhX7mICGAsykqoPulfzRgCg9A3CdrSwqfV+4Z/06ITtJQFBbyW2iRx143NZqNolwUHswjtOBAdPrHHEmI73zkEVn3fZD8U/gCV7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231902; c=relaxed/simple;
	bh=x0nBikO7bD0nAUGB4hLdAXpZrTlPopJuyhunh2jNT7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2DKc+rUmQCioAXGaI+vDGr51F7NGIkToAPCCQmkHDJLA1AdejpzjwvcXWZN/qmMhBkovZxH18ccAIECIGJHDPvl4EiKCz8ypDXDrZ2EBP7JBK6W0sDMo6lP/q0L/FSRocm5HttqZnH8YdFyv2fTfmq7wp6vgSbTvG8t75lArVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1pdYR5y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1pdYR5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBBB1F000FF;
	Sat, 12 Sep 2026 16:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231900;
	bh=VvENcAY9YuLt7sKS2RkLMteMkP7e800i2tB6zf8Yj+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a1pdYR5y1rxIePwe1FIGx31Vtl3K1gu//T785rDEcpvdzVDe+mL6t8iXe1XaW3N76
	 /GKzH1m7rNVpAn7UQX5bnharKI3FfGMKJXRPlwiX0WODRwdrHVzGHUVeBHuhjK3Jeo
	 VrHsHk6FqM4BFULX8TjBzcOB3nHVfKiq8ufLtcX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9265e754091c2d27ea29@syzkaller.appspotmail.com,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1092/1191] Bluetooth: L2CAP: reject accept queue add unless BT_LISTEN
Date: Sat, 12 Sep 2026 09:03:40 +0200
Message-ID: <20260912065612.690382507@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8b0cae90a6afc..66f72970600f8 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1524,6 +1524,11 @@ static int l2cap_sock_new_connection_cb(struct l2cap_chan *chan,
 
 	lock_sock(parent);
 
+	if (parent->sk_state != BT_LISTEN) {
+		release_sock(parent);
+		return -EINVAL;
+	}
+
 	/* Check for backlog size */
 	if (sk_acceptq_is_full(parent)) {
 		BT_DBG("backlog full %d", parent->sk_ack_backlog);
@@ -1688,10 +1693,14 @@ static void l2cap_sock_state_change_cb(struct l2cap_chan *chan, int state,
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
@@ -1767,6 +1776,8 @@ static void l2cap_sock_resume_cb(struct l2cap_chan *chan)
 	if (!sk)
 		return;
 
+	lock_sock(sk);
+
 	if (test_and_clear_bit(FLAG_PENDING_SECURITY, &chan->flags)) {
 		sk->sk_state = BT_CONNECTED;
 		chan->state = BT_CONNECTED;
@@ -1774,6 +1785,8 @@ static void l2cap_sock_resume_cb(struct l2cap_chan *chan)
 
 	clear_bit(BT_SK_SUSPEND, &bt_sk(sk)->flags);
 	sk->sk_state_change(sk);
+
+	release_sock(sk);
 }
 
 static void l2cap_sock_set_shutdown_cb(struct l2cap_chan *chan)
-- 
2.53.0



