Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211952;
	b=qtzvFDXkHnII0nUZ/UshCctb/7hgL2sIXELfTHD8dBw4RrXVFle84byTD4QFUutDcwe+
	 ZX5YvDvKkbtU9oo01KhLi3D/qS3te/OCBlev1TdoBWX5Ywkal4kntRR3WERAuhRsdsZiz
	 hngj8cRhBKUgcqoqz9dcA9qtpWgE7GjtZ211bypPUvwJZodpPwTS/zeHDUspRG86yczo4
	 yf6b1eCJVZ4taE6kO5iFOi78wGnR2I8IixsWz8bSg10043kbS7FLKZZLgxvTp1UURKywg
	 dlfAu1qiz48aRuhP1pLpVzmhRmuyTFTG6yUbrpw3VcPKWckBgQxBE7v+O3lMlcrTlGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fbcy2gCRiXidh7mahhMz/Cpfukwu3wLE8ZNcc0YTh2Y=;
	b=uqZTX7bP1JDCiaAA9JhWq0Kv/3+kMrqeUXcAwWT/KRqJJlchJ6v0ebV6mhuqdpjJ3kEx
	 3SYjMTowicKsa7dR4XGv7zQlr3+b/J+WQtwU8HkUHexVWLE6mbW97z+Npqjo4pU9xggDI
	 ZwqsAFphN5m5qKrPELgwAY5kzlgvAcJpmFy1hhwdFmGB27U77tRy/vTc3kca9pOyD9R81
	 1WPIAksJW0f4Ez3W1CplUkCHC2Lahi7Zuv58mBxoBx/d/IP7aMIBHSSpJmje0JuAa2F38
	 TjI+1Q3za4UO8rOGdnJwFnPSXBXTsIbAM50PyyBPy/FGXO3/D+hrVL3ABBNHNliwhxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZoLRvIv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10C0606A31A;
	Wed, 28 Oct 2026 18:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZoLRvIv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1AE1F01825;
	Wed, 28 Oct 2026 18:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211951;
	bh=fbcy2gCRiXidh7mahhMz/Cpfukwu3wLE8ZNcc0YTh2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZoLRvIvuupZbBpX3pGSdXP4ERBPQEj9JNs92+vbigKkoTi3txFBR3i2Me9pbg5qn
	 O3YfT7cREWWhEIXqiQU5tbN++9v2sVtBipxIKE2e9CsvHeoGDcycF2OuEEiWBcJ9uz
	 VjoiSVv6QWW80FLDN/TwGdCMo67PXwg9pTcIeU2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b106284c2a0b7bc80cf9@syzkaller.appspotmail.com,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 556/571] Bluetooth: L2CAP: access chan->conn safely in get/setsockopt
Date: Wed, 28 Oct 2026 18:01:43 +0100
Message-ID: <20261028170021.229781483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[Lee: Omit sockopt_t conversion from commit bf01627cc04b ("Bluetooth: L2CAP: convert to getsockopt_iter")]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 57 ++++++++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index bef6a948d7d51..046f3e6555f00 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -435,11 +435,26 @@ static int l2cap_get_mode(struct l2cap_chan *chan)
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
 				     char __user *optval, int __user *optlen)
 {
 	struct sock *sk = sock->sk;
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
+	struct l2cap_conn *conn;
 	struct l2cap_options opts;
 	struct l2cap_conninfo cinfo;
 	int err = 0;
@@ -451,6 +466,7 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 	if (get_user(len, optlen))
 		return -EFAULT;
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	switch (optname) {
@@ -536,9 +552,15 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
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
 		if (copy_to_user(optval, (char *) &cinfo, len))
@@ -552,6 +574,8 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 	}
 
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
+
 	return err;
 }
 
@@ -560,6 +584,7 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
+	struct l2cap_conn *conn;
 	struct bt_security sec;
 	struct bt_power pwr;
 	u32 phys;
@@ -576,6 +601,7 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 	if (get_user(len, optlen))
 		return -EFAULT;
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	switch (optname) {
@@ -587,12 +613,14 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
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
@@ -668,12 +696,14 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case BT_PHY:
-		if (sk->sk_state != BT_CONNECTED) {
+		conn = l2cap_chan_conn(chan);
+
+		if (sk->sk_state != BT_CONNECTED || !conn) {
 			err = -ENOTCONN;
 			break;
 		}
 
-		phys = hci_conn_get_phy(chan->conn->hcon);
+		phys = hci_conn_get_phy(conn->hcon);
 
 		if (put_user(phys, (u32 __user *) optval))
 			err = -EFAULT;
@@ -706,6 +736,7 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 	}
 
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
 	return err;
 }
 
@@ -736,6 +767,7 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 
 	BT_DBG("sk %p", sk);
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	switch (optname) {
@@ -839,6 +871,7 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 	}
 
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
 	return err;
 }
 
@@ -902,6 +935,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_BLUETOOTH)
 		return -ENOPROTOOPT;
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	switch (optname) {
@@ -929,11 +963,10 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 
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
@@ -990,7 +1023,8 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 		}
 
 		if (opt == BT_FLUSHABLE_OFF) {
-			conn = chan->conn;
+			conn = l2cap_chan_conn(chan);
+
 			/* proceed further only when we have l2cap_conn and
 			   No Flush support in the LM */
 			if (!conn || !lmp_no_flush_capable(conn->hcon->hdev)) {
@@ -1127,6 +1161,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 	}
 
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
 	return err;
 }
 
-- 
2.53.0



