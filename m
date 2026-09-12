Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901453CDBB5;
	Sat, 12 Sep 2026 15:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226145; cv=none; b=kMUMEa7cwx8W/ovuSWrFDsakLRFMjreoPFhmH5Xr0wMi85zkNozB4ccSYTEsYysQrV4JHSdyCIEX5sVPBn8Ckj8al4M2R4izbcymflIsIDqO0XzMkKSFI/NxMx8Kwln7+rF6na6ZxG7QjrLo03uHoGQx2c1mThgc7IK1uBms+Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226145; c=relaxed/simple;
	bh=jphTW7rwfsSOAu+Fxd7eM8EQu/ISoxjuHLgqVKbjQag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1ZZee2btHmD/zZ8HWpOL4wJXFig5UTNoHHQspLrIZjDU0VqKvohKegn4vz7SStMQ7XhHvG87wsS7e7uDsrAAv3l4MpFQDmqJKd8wRvqlsQ6kVyr4/t1INrF44fKnKkwno/PPcDqBOQN3i9D5/0E8VMH6t6dOZl0R4G4Sg0z2T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KH81GfX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KH81GfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F91D1F000FF;
	Sat, 12 Sep 2026 15:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226142;
	bh=1fAVQDJRWXJf8RNtk8N/Yf8rYUM6XB/e6QRFsJmi1Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1KH81GfXiaHv3m6YAIXFptz8A74Q2GdDPREQXmJtf5LsW1w8iq0IG95+O4y0f9JHi
	 1DkgvDKhjvgkbojvmUPQc7E+cgcgage8MFpEBmklhNkISApuYuiFKBn240t5zMi9TD
	 baeg1+TFnSzLM+D4c9JCw/BISWiseZdYSv/u4YGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9265e754091c2d27ea29@syzkaller.appspotmail.com,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1342/1424] Bluetooth: L2CAP: reject accept queue add unless BT_LISTEN
Date: Sat, 12 Sep 2026 09:02:54 +0200
Message-ID: <20260912065637.311894934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 89f881be9712b..5cbd50889b7c6 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1523,6 +1523,11 @@ static int l2cap_sock_new_connection_cb(struct l2cap_chan *chan,
 
 	lock_sock(parent);
 
+	if (parent->sk_state != BT_LISTEN) {
+		release_sock(parent);
+		return -EINVAL;
+	}
+
 	/* Check for backlog size */
 	if (sk_acceptq_is_full(parent)) {
 		BT_DBG("backlog full %d", parent->sk_ack_backlog);
@@ -1687,10 +1692,14 @@ static void l2cap_sock_state_change_cb(struct l2cap_chan *chan, int state,
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
@@ -1766,6 +1775,8 @@ static void l2cap_sock_resume_cb(struct l2cap_chan *chan)
 	if (!sk)
 		return;
 
+	lock_sock(sk);
+
 	if (test_and_clear_bit(FLAG_PENDING_SECURITY, &chan->flags)) {
 		sk->sk_state = BT_CONNECTED;
 		chan->state = BT_CONNECTED;
@@ -1773,6 +1784,8 @@ static void l2cap_sock_resume_cb(struct l2cap_chan *chan)
 
 	clear_bit(BT_SK_SUSPEND, &bt_sk(sk)->flags);
 	sk->sk_state_change(sk);
+
+	release_sock(sk);
 }
 
 static void l2cap_sock_set_shutdown_cb(struct l2cap_chan *chan)
-- 
2.53.0



