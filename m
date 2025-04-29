Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C152AE96;
	Tue, 29 Apr 2025 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949324; cv=none; b=YjjCWfhYifjSkCxcLJR1iNWPiSiiLsEn+h0ItltxZ4YQDobe0/Okmp6vCRjReOyn90LIya5yOs1Q4uOBoUoRfRFQggvSaQJbt6X5GGu4Nv7ckpTqK7KSkB9+N+4AqJSlVgKVSoi85HiWUaVGBgscsgcx1Oo3jnOytgyfIi3jC9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949324; c=relaxed/simple;
	bh=S67zhca20bTyhPJ1KYi1iAl93DbhzZm7ObNj5+DKyjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emSwSJ09YkrVjjDr2d2z9qRA5U31hXVK6ihQYO1GygDbI99JFzm3WbFmZMVoOODIQrpHR7OtZIbmyzVgUO0RU37toInZTvNaNKyP1nr7onSgz2qgWBRP3YfkaCmxCTr5kZNTT7sF7wsh6Xxw0IWfE/qC8ykWKpvbMVGU4Gwzt8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9MHM4g4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9MHM4g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4A2C4CEE3;
	Tue, 29 Apr 2025 17:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949324;
	bh=S67zhca20bTyhPJ1KYi1iAl93DbhzZm7ObNj5+DKyjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9MHM4g4soStTqvzgxcLaZ2euF9UecoWvMfei39kpiJKOX+kWbLSr7laPRckABkTz
	 O/r5SmjUJbJXTchi2T4AKIuV7s42rlf1H9sCcOZI6KhQolWWdQMcfuMeRY+yWFivUq
	 wKye/OZeJMnWnYWPNih7h5Ku16APM4Jt5B0NeJsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4c0d0c4cde787116d465@syzkaller.appspotmail.com,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 253/373] Bluetooth: SCO: Fix UAF on sco_sock_timeout
Date: Tue, 29 Apr 2025 18:42:10 +0200
Message-ID: <20250429161133.532037966@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 1bf4470a3939c678fb822073e9ea77a0560bc6bb upstream.

conn->sk maybe have been unlinked/freed while waiting for sco_conn_lock
so this checks if the conn->sk is still valid by checking if it part of
sco_sk_list.

Reported-by: syzbot+4c0d0c4cde787116d465@syzkaller.appspotmail.com
Tested-by: syzbot+4c0d0c4cde787116d465@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4c0d0c4cde787116d465
Fixes: ba316be1b6a0 ("Bluetooth: schedule SCO timeouts with delayed_work")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/bluetooth.h |    1 +
 net/bluetooth/af_bluetooth.c      |   22 ++++++++++++++++++++++
 net/bluetooth/sco.c               |   18 ++++++++++++------
 3 files changed, 35 insertions(+), 6 deletions(-)

--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -314,6 +314,7 @@ int  bt_sock_register(int proto, const s
 void bt_sock_unregister(int proto);
 void bt_sock_link(struct bt_sock_list *l, struct sock *s);
 void bt_sock_unlink(struct bt_sock_list *l, struct sock *s);
+bool bt_sock_linked(struct bt_sock_list *l, struct sock *s);
 int  bt_sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		     int flags);
 int  bt_sock_stream_recvmsg(struct socket *sock, struct msghdr *msg,
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -154,6 +154,28 @@ void bt_sock_unlink(struct bt_sock_list
 }
 EXPORT_SYMBOL(bt_sock_unlink);
 
+bool bt_sock_linked(struct bt_sock_list *l, struct sock *s)
+{
+	struct sock *sk;
+
+	if (!l || !s)
+		return false;
+
+	read_lock(&l->lock);
+
+	sk_for_each(sk, &l->head) {
+		if (s == sk) {
+			read_unlock(&l->lock);
+			return true;
+		}
+	}
+
+	read_unlock(&l->lock);
+
+	return false;
+}
+EXPORT_SYMBOL(bt_sock_linked);
+
 void bt_accept_enqueue(struct sock *parent, struct sock *sk, bool bh)
 {
 	BT_DBG("parent %p, sk %p", parent, sk);
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -76,6 +76,16 @@ struct sco_pinfo {
 #define SCO_CONN_TIMEOUT	(HZ * 40)
 #define SCO_DISCONN_TIMEOUT	(HZ * 2)
 
+static struct sock *sco_sock_hold(struct sco_conn *conn)
+{
+	if (!conn || !bt_sock_linked(&sco_sk_list, conn->sk))
+		return NULL;
+
+	sock_hold(conn->sk);
+
+	return conn->sk;
+}
+
 static void sco_sock_timeout(struct work_struct *work)
 {
 	struct sco_conn *conn = container_of(work, struct sco_conn,
@@ -87,9 +97,7 @@ static void sco_sock_timeout(struct work
 		sco_conn_unlock(conn);
 		return;
 	}
-	sk = conn->sk;
-	if (sk)
-		sock_hold(sk);
+	sk = sco_sock_hold(conn);
 	sco_conn_unlock(conn);
 
 	if (!sk)
@@ -191,9 +199,7 @@ static void sco_conn_del(struct hci_conn
 
 	/* Kill socket */
 	sco_conn_lock(conn);
-	sk = conn->sk;
-	if (sk)
-		sock_hold(sk);
+	sk = sco_sock_hold(conn);
 	sco_conn_unlock(conn);
 
 	if (sk) {


