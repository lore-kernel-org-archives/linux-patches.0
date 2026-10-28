Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209535;
	b=BRGkdixD/yKmIK/85gDY9Xlgz8+dUEWFs7k7dujPIXALWeL3v+4EYilJdawAP9H4AmQ9
	 cw+OoJIzNACvno0NH/EQPpsGvN7gLDjgsGisvM2bTC9RWE3Cc0Tq4xx9A3dWJOhnHaZLU
	 8jDNjqHcyzMyLLNcse97Sl5nfAn+8xgILbJMgh6REB1iUBwAOsY9JAw7DUhICDMthNXyN
	 WBrV0obyppHP/vs36E4uu9YaUkmehXZFR99khbmwnJZ0wxmj+14TiQj9J8KwtYG5Ldpuy
	 7UTgwJ6wEkdkfnGl5bNI1C2mM+wD9N4jtjvkJyIjNiSCm9UB4ckcLHlR1cGhQVIH2AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k7hu3gBAk27IfhhLyB5tt14MwOZaaB9LJfzbELU+FlQ=;
	b=qbVYrwrcNnXS8rMY3S/dL9ArHNjZzrMVmglFtcPf00CLXoAUNhqLneV4DrLavjVXOhMY
	 4gjLsSS3D6+6lb5U7py+1NBMaKPwEmSmVs2QP/mMsk4v48SK9xhXNKaYAhaYD3KkwOuBQ
	 r2cse5xYKfcJ9LG7AETBNfRK0ZMsA4dQveOTZ67WrKNwZWDCznnKQVqScFxeJ8MGzQti0
	 aZyw8EDzmxJgy6K/MDiEZoHorLfuF6hvXCnCn93YyovlRYeUsO1C71r+tmtE2vOjSRwIc
	 tTtXwqL+CZk1ZMBXYP8mxzZoQQpFox4aK1m/ZmAxHIAlxqqaEzWcspWiI1+Ok34edkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13eounp9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8039606A31D;
	Wed, 28 Oct 2026 17:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13eounp9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E041F031E2;
	Wed, 28 Oct 2026 17:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209534;
	bh=k7hu3gBAk27IfhhLyB5tt14MwOZaaB9LJfzbELU+FlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13eounp9p/SePC/abtQRr75bk82bA9pEXCQaDIAmUiGCp37ZkQMFbLaGRCbHAp8Wm
	 9ymjQC2UqRDuckr8RGNrdeX8Oju+2uUK4ooXl+1yRZWfNTZavULmvC8NzL7ajCibhD
	 W5spF7GOTxlMZ2AuUUVHDEUByLXfv3RgDUFohirY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b106284c2a0b7bc80cf9@syzkaller.appspotmail.com,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 504/516] Bluetooth: L2CAP: access chan->conn safely in get/setsockopt
Date: Wed, 28 Oct 2026 18:00:56 +0100
Message-ID: <20261028170015.417486330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 018b5a0c87ce9..81faa83128a53 100644
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
@@ -836,6 +868,7 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 	}
 
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
 	return err;
 }
 
@@ -899,6 +932,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_BLUETOOTH)
 		return -ENOPROTOOPT;
 
+	l2cap_chan_lock(chan);
 	lock_sock(sk);
 
 	switch (optname) {
@@ -924,11 +958,10 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 
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
@@ -983,7 +1016,8 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 		}
 
 		if (opt == BT_FLUSHABLE_OFF) {
-			conn = chan->conn;
+			conn = l2cap_chan_conn(chan);
+
 			/* proceed further only when we have l2cap_conn and
 			   No Flush support in the LM */
 			if (!conn || !lmp_no_flush_capable(conn->hcon->hdev)) {
@@ -1115,6 +1149,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 	}
 
 	release_sock(sk);
+	l2cap_chan_unlock(chan);
 	return err;
 }
 
-- 
2.53.0



