Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A41537C118;
	Sat, 12 Sep 2026 09:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204936; cv=none; b=TT2Jofw/o6gtpGaayQ/PjfkBcFpx6eqZAjJeLh1RcUhIcZ7wOvPXkv6rYt9ym/4/vfaZ06NKtPBQ44ZLtU8Vc21Z4jDCTvNodvZyQ2lMERhRVcTDipZyuoVwSMdVkntHsl1fJmh3spHhtAKMbt+PKhYRsffBfboHosbjr0nkzwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204936; c=relaxed/simple;
	bh=mItR3haGMbXvB02JLblrwlbBes0cgWPU+nQ8xDMkpUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYLGtAm/r8gp/Oy5CufTPBzGRgnmMWTZDNtqLj2wOhKhlUtYO2dHtCHQu5krw2YcdJoa7IJrkcSGQ4balr/a8yfBvfsULpzMXIIwZZCAzPuQgfS3WNxSQl7Fu7Y0ce1n1EtX0FXaPz//DJkErMHWur8cAHiCjrv+2huVIc6YG8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8dAITrq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8dAITrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08751F000FF;
	Sat, 12 Sep 2026 09:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204934;
	bh=qgMIL6Jk3Hg3t8XQAbTtzw5wwXkrlRVzOWH/pwKVNPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8dAITrqUla7MfHq6CWEVbxyPShn8tqGjVzK1uVtUDby4NFL37l1xo/TmthSSOmiZ
	 WAuBWwpsiB8lTiaY5nGhTJEE8lWTsNn/6ZRkBCVc52Mtjoz1lkeiBzGZ1jgUitOOFR
	 JfzdSoMFUCn5vmcEcx2e1+JOxk6YMSLqPP0SN4Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b106284c2a0b7bc80cf9@syzkaller.appspotmail.com,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1715/1815] Bluetooth: L2CAP: access chan->conn safely in get/setsockopt
Date: Sat, 12 Sep 2026 08:57:45 +0200
Message-ID: <20260912065729.236070154@linuxfoundation.org>
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
 net/bluetooth/l2cap_sock.c | 64 ++++++++++++++++++++++++++++----------
 1 file changed, 48 insertions(+), 16 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 4058ff50cc27a..782c94cd1bc0a 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -436,11 +436,26 @@ static int l2cap_get_mode(struct l2cap_chan *chan)
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
@@ -451,6 +466,7 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 
 	len = sopt->optlen;
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	switch (optname) {
@@ -537,9 +553,15 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
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
@@ -553,6 +575,8 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 	}
 
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
+
 	return err;
 }
 
@@ -561,6 +585,7 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
+	struct l2cap_conn *conn;
 	struct bt_security sec;
 	struct bt_power pwr;
 	int len, mode, err = 0;
@@ -578,6 +603,7 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 
 	len = sopt->optlen;
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	switch (optname) {
@@ -589,12 +615,14 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
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
@@ -678,12 +706,14 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
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
@@ -719,6 +749,7 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 	}
 
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
 	return err;
 }
 
@@ -749,6 +780,7 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 
 	BT_DBG("sk %p", sk);
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	switch (optname) {
@@ -850,6 +882,7 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 	}
 
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
 	return err;
 }
 
@@ -913,6 +946,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_BLUETOOTH)
 		return -ENOPROTOOPT;
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	switch (optname) {
@@ -938,11 +972,10 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 
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
@@ -997,7 +1030,8 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 		}
 
 		if (opt == BT_FLUSHABLE_OFF) {
-			conn = chan->conn;
+			conn = l2cap_chan_conn(chan);
+
 			/* proceed further only when we have l2cap_conn and
 			   No Flush support in the LM */
 			if (!conn || !lmp_no_flush_capable(conn->hcon->hdev)) {
@@ -1083,7 +1117,8 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case BT_PHY:
-		if (sk->sk_state != BT_CONNECTED) {
+		conn = l2cap_chan_conn(chan);
+		if (sk->sk_state != BT_CONNECTED || !conn) {
 			err = -ENOTCONN;
 			break;
 		}
@@ -1093,10 +1128,6 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 		if (err)
 			break;
 
-		if (!chan->conn)
-			break;
-
-		conn = chan->conn;
 		err = hci_conn_set_phy(conn->hcon, phys);
 		break;
 
@@ -1139,6 +1170,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 	}
 
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
 	return err;
 }
 
-- 
2.53.0



