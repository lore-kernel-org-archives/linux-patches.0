Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4328B391E6D;
	Sat, 17 Oct 2026 16:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255004; cv=none; b=dL09HBVH/EVkvnJQ9i/zBAL7fgjzdQnqjHrtM7Dx/vOdYR2N7IV5Oohs/yWLlaIc0foMenc2TKGej2g75CKLp98uxCjd4ePNpsqdre1wzFpJbeRmjREbqoSFcGiBa2k2SK8G64pytSBaEhnC1j1YKQblhu0gdOgllA5zk9I9y+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255004; c=relaxed/simple;
	bh=y/gEe0hNNMdEIV9QgkFW2qIrUUO3yyvmbbQR/KOQTJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iS49k7cdJtUVxzWrIAnS4hsXVIpOwdmQ657Y+0hPi+QVps2b/GcJRqxIrC/aNbRgnMdHjvCL8DutM96xjFPXuMTtpD3hwzR2hB7HvGW4QFMAjAhWKSrd9zG6egQHj4PcpvlI9oJAv2fStf/gnOBGr70gy/u80QFgaycDP5nyt70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hy11InEG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hy11InEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91ACE1F000C4;
	Sat, 17 Oct 2026 16:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255003;
	bh=XBo41shGg6pSaT44jeVElhI3uWl3GfYtB7S8I4/d0DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hy11InEGCbfBru3MzA+zbIMl6hLdrVEuI2NNycLL2DUqvFyvZZqzByhvoDgyN1nBJ
	 4yC4dBrapzCW4niFEzS1MXBwtIXWYwu6K6kLQGYNkqUMNZLu6DBVVnC/fHT6WdGz3C
	 4fcyiAoDnswImY5ot8tnGBbuOQxWdSMa5U764pG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b106284c2a0b7bc80cf9@syzkaller.appspotmail.com,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 606/869] Bluetooth: L2CAP: access chan->conn safely in get/setsockopt
Date: Sat, 17 Oct 2026 17:57:27 +0200
Message-ID: <20261017160052.578443126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit ca2c4c26498643f421d35ffe258fafbd3ed461c3 ]

Since commit b66774b48dd9 ("Bluetooth: L2CAP: Fix UAF in channel timeout by holding conn ref")
l2cap_chan::conn has held reference and remains non-NULL also after the
corresponding hci_conn is deleted.  In this state accessing various
fields eg. hci_conn::hdev is invalid, which leads to KASAN crash in
l2cap_sock_setsockopt() access of conn->hcon->hdev.

Check l2cap_chan::conn.hcon corresponds to an alive hci_conn before
trying to use it in l2cap_sock.c.  Hold l2cap_chan_lock() in
getsockopt/setsockopt to ensure it stays alive, and to avoid data races
in l2cap_chan fields.

Fixes: b66774b48dd9 ("Bluetooth: L2CAP: Fix UAF in channel timeout by holding conn ref")
Reported-by: syzbot+b106284c2a0b7bc80cf9@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=b106284c2a0b7bc80cf9
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 57 ++++++++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index a44a49c70b2f3..ef3af57e4637f 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -439,11 +439,26 @@ static int l2cap_get_mode(struct l2cap_chan *chan)
 	return -EINVAL;
 }
 
+static struct l2cap_conn *l2cap_chan_conn(struct l2cap_chan *chan)
+{
+	lockdep_assert_held(&chan->lock);
+
+	/* l2cap_conn_del() sets FLAG_DEL while holding chan->lock before
+	 * conn->hcon is deleted. If not set and conn is non-NULL, conn->hcon
+	 * remains alive during this chan->lock critical section.
+	 */
+	if (test_bit(FLAG_DEL, &chan->flags))
+		return NULL;
+
+	return chan->conn;
+}
+
 static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 				     sockopt_t *sopt)
 {
 	struct sock *sk = sock->sk;
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
+	struct l2cap_conn *conn;
 	struct l2cap_options opts;
 	struct l2cap_conninfo cinfo;
 	int err = 0;
@@ -454,6 +469,7 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 
 	len = sopt->optlen;
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	switch (optname) {
@@ -540,9 +556,15 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 			break;
 		}
 
+		conn = l2cap_chan_conn(chan);
+		if (!conn) {
+			err = -ENOTCONN;
+			break;
+		}
+
 		memset(&cinfo, 0, sizeof(cinfo));
-		cinfo.hci_handle = chan->conn->hcon->handle;
-		memcpy(cinfo.dev_class, chan->conn->hcon->dev_class, 3);
+		cinfo.hci_handle = conn->hcon->handle;
+		memcpy(cinfo.dev_class, conn->hcon->dev_class, 3);
 
 		len = min(len, sizeof(cinfo));
 		if (copy_to_iter(&cinfo, len, &sopt->iter_out) != len)
@@ -556,6 +578,8 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 	}
 
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
+
 	return err;
 }
 
@@ -564,6 +588,7 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
+	struct l2cap_conn *conn;
 	struct bt_security sec;
 	struct bt_power pwr;
 	int len, mode, err = 0;
@@ -581,6 +606,7 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 
 	len = sopt->optlen;
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	switch (optname) {
@@ -592,12 +618,14 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
+		conn = l2cap_chan_conn(chan);
+
 		memset(&sec, 0, sizeof(sec));
-		if (chan->conn) {
-			sec.level = chan->conn->hcon->sec_level;
+		if (conn) {
+			sec.level = conn->hcon->sec_level;
 
 			if (sk->sk_state == BT_CONNECTED)
-				sec.key_size = chan->conn->hcon->enc_key_size;
+				sec.key_size = conn->hcon->enc_key_size;
 		} else {
 			sec.level = chan->sec_level;
 		}
@@ -681,12 +709,14 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case BT_PHY:
-		if (sk->sk_state != BT_CONNECTED) {
+		conn = l2cap_chan_conn(chan);
+
+		if (sk->sk_state != BT_CONNECTED || !conn) {
 			err = -ENOTCONN;
 			break;
 		}
 
-		opt = hci_conn_get_phy(chan->conn->hcon);
+		opt = hci_conn_get_phy(conn->hcon);
 
 		if (copy_to_iter(&opt, sizeof(opt), &sopt->iter_out) !=
 		    sizeof(opt))
@@ -722,6 +752,7 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 	}
 
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
 	return err;
 }
 
@@ -752,6 +783,7 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 
 	BT_DBG("sk %p", sk);
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	switch (optname) {
@@ -853,6 +885,7 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 	}
 
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
 	return err;
 }
 
@@ -916,6 +949,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_BLUETOOTH)
 		return -ENOPROTOOPT;
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	switch (optname) {
@@ -941,11 +975,10 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 
 		chan->sec_level = sec.level;
 
-		if (!chan->conn)
+		conn = l2cap_chan_conn(chan);
+		if (!conn)
 			break;
 
-		conn = chan->conn;
-
 		/* change security for LE channels */
 		if (chan->scid == L2CAP_CID_ATT) {
 			if (smp_conn_security(conn->hcon, sec.level)) {
@@ -1000,7 +1033,8 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 		}
 
 		if (opt == BT_FLUSHABLE_OFF) {
-			conn = chan->conn;
+			conn = l2cap_chan_conn(chan);
+
 			/* proceed further only when we have l2cap_conn and
 			   No Flush support in the LM */
 			if (!conn || !lmp_no_flush_capable(conn->hcon->hdev)) {
@@ -1124,6 +1158,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 	}
 
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
 	return err;
 }
 
-- 
2.53.0



