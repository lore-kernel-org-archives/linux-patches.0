Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020216;
	b=DXBcMDDKIlTIzsrvDIjn1zkQQOUn7K2pvU2MJkEIYAhcXieYzBhRZWP69CnD+tns7/Fk
	 U+C5uT5ZhccYf5N2LjniGHEEWhJdOtmjS4hd1mz/wmyk0EFs6NGjxt5YVHDyEUcFsqgDm
	 dh0uYt04hOnYwqo84mNr3VE5NuwXAn5KSadxiC2FARdZJ1mmtKhapfmQ/6iPArc9KFE1l
	 9hbBWyIC+Lqs7p79vYWv4DItA+y/ktI9XCQuiShYjc9+truXVh3WX99jkwowBSRZWiKDg
	 ReTtwNApusVe3W5RaKu6XecNbelY/qjmgV+ohv1kQqDC888utqKVrYcm1xq6NShkhtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WfSq6CONseL7oR1zIS9Ai5Ac24v5wJw+hz3zyduIUB4=;
	b=nwOxq1c5jIGenzK6KcKXUXF9qbMEbXcVmwtNoZhc8KS+OCVUzsUEZ9WrvnE8erVXli9H
	 TsSnUaYrXJKh1kn4LqQUq8+/d1H86Ctb1GZnsc+t2PaACPDOoXjWfBHbUKK6U+uHcp5gb
	 ifulwIixsZIrWlwWRR83T7UY+JAr56ilWz8HeYzrdb19DDijVKN4zi5WNMH7G93iwdaPj
	 xiyjT3tCGc7wnwnsZx60Yyl99HmgMOk4W0Lrwns/iuXn9hkFJS+XC3tJNt+XDjvrTRmWe
	 HzoRK1eOVo//YXij335RLkc4pEmDkwqqyglmm+QR8BH8wJi6ZYP3jmdH7i4ZFLdPBlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IlU66Yyr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23375606A320;
	Wed, 18 Nov 2026 16:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IlU66Yyr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725551F000C6;
	Wed, 18 Nov 2026 16:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020216;
	bh=WfSq6CONseL7oR1zIS9Ai5Ac24v5wJw+hz3zyduIUB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IlU66Yyrd3HcivY9YEC4xYzZlWvA+mdzpY+aON4GSl21JCvKRAC6antIjZc809B6S
	 Pfb3Te296tbYEUkvfJ5gR1QxAIGxVNXtFlxPVNN5pux7DawNWGMxve4z8AAIFecjY+
	 glj5n1TVk94/qZHyh8+WHNJFReTAqrH/agcuV47I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1871/2651] Bluetooth: L2CAP: add l2cap_chan_close_unlocked() and locking helpers
Date: Wed, 18 Nov 2026 15:51:51 +0100
Message-ID: <20261118150354.320233794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 608e0b7a675b2affbbf38167cad0fa63d8e064f7 ]

l2cap_chan_close() requires holding chan->lock and chan->conn->lock if
associated chan->conn exists, to guard eg. conn->chan_l. Taking the
locks with right ordering requires handling a race condition.

Add helper function l2cap_chan_(un)lock_conn that do the locking right.

Add l2cap_chan_close_unlocked() that does not require locks to be held,
as all callsites do this lock -> close -> unlock pattern.

Link: https://syzkaller.appspot.com/bug?extid=0e4ebcc970728e056324
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 79ff49a72c06 ("Bluetooth: L2CAP: fix race condition in l2cap_sock_shutdown()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/l2cap.h | 17 ++++++++++
 net/bluetooth/l2cap_core.c    | 61 ++++++++++++++++++++++++++++++++---
 2 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index f64568cb51169..2ec820c0f94f7 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -960,6 +960,8 @@ int l2cap_add_scid(struct l2cap_chan *chan,  __u16 scid);
 
 struct l2cap_chan *l2cap_chan_create(void);
 void l2cap_chan_close(struct l2cap_chan *chan, int reason);
+void l2cap_chan_close_unlocked(struct l2cap_chan *chan, int reason)
+	__must_not_hold(&chan->lock);
 int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 		       bdaddr_t *dst, u8 dst_type, u16 timeout);
 int l2cap_chan_reconfigure(struct l2cap_chan *chan, __u16 mtu);
@@ -986,4 +988,19 @@ void l2cap_conn_put(struct l2cap_conn *conn);
 int l2cap_register_user(struct l2cap_conn *conn, struct l2cap_user *user);
 void l2cap_unregister_user(struct l2cap_conn *conn, struct l2cap_user *user);
 
+bool l2cap_chan_lock_conn(struct l2cap_chan *chan)
+	__acquires(&chan->lock) __cond_acquires(true, &chan->conn->lock);
+
+/* Release macro for l2cap_chan_lock_conn, so context analysis understands it */
+#define l2cap_chan_unlock_conn(chan, conn_locked)			\
+	({								\
+		struct l2cap_chan *__chan = (chan);			\
+		struct l2cap_conn *__conn = __chan->conn;		\
+		l2cap_chan_unlock(__chan);				\
+		if (conn_locked) {					\
+			mutex_unlock(&__conn->lock);			\
+			l2cap_conn_put(__conn);				\
+		}							\
+	})
+
 #endif /* __L2CAP_H */
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 60720a8cce826..de7397e53c2a3 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -59,6 +59,7 @@ static void l2cap_tx(struct l2cap_chan *chan, struct l2cap_ctrl *control,
 static void l2cap_retrans_timeout(struct work_struct *work);
 static void l2cap_monitor_timeout(struct work_struct *work);
 static void l2cap_ack_timeout(struct work_struct *work);
+static void __l2cap_chan_close(struct l2cap_chan *chan, int reason);
 
 static inline u8 bdaddr_type(u8 link_type, u8 bdaddr_type)
 {
@@ -456,7 +457,7 @@ static void l2cap_chan_timeout(struct work_struct *work)
 	else
 		reason = ETIMEDOUT;
 
-	l2cap_chan_close(chan, reason);
+	__l2cap_chan_close(chan, reason);
 
 	chan->ops->close(chan);
 
@@ -867,7 +868,7 @@ static void l2cap_chan_connect_reject(struct l2cap_chan *chan)
 	l2cap_send_cmd(conn, chan->ident, L2CAP_CONN_RSP, sizeof(rsp), &rsp);
 }
 
-void l2cap_chan_close(struct l2cap_chan *chan, int reason)
+static void __l2cap_chan_close(struct l2cap_chan *chan, int reason)
 {
 	struct l2cap_conn *conn = chan->conn;
 
@@ -916,8 +917,58 @@ void l2cap_chan_close(struct l2cap_chan *chan, int reason)
 		break;
 	}
 }
+
+void l2cap_chan_close(struct l2cap_chan *chan, int reason)
+{
+	__l2cap_chan_close(chan, reason);
+}
 EXPORT_SYMBOL(l2cap_chan_close);
 
+/* Take chan->lock. If chan->conn is non-NULL, take new reference on it, take
+ * chan->conn->lock, and return true. Otherwise return false.
+ */
+bool l2cap_chan_lock_conn(struct l2cap_chan *chan)
+	__context_unsafe(/* conditional locking */)
+{
+	/* Handle conn->lock > chan->lock ordering + race on chan->conn */
+	for (;;) {
+		struct l2cap_conn *conn;
+
+		l2cap_chan_lock(chan);
+		conn = chan->conn;
+		if (conn)
+			l2cap_conn_get(conn);
+		l2cap_chan_unlock(chan);
+
+		if (conn)
+			mutex_lock(&conn->lock);
+
+		l2cap_chan_lock(chan);
+
+		if (chan->conn != conn) {
+			l2cap_chan_unlock(chan);
+			if (conn) {
+				mutex_unlock(&conn->lock);
+				l2cap_conn_put(conn);
+			}
+			schedule();
+			continue;
+		}
+
+		return chan->conn;
+	}
+}
+
+void l2cap_chan_close_unlocked(struct l2cap_chan *chan, int reason)
+{
+	bool have_conn;
+
+	have_conn = l2cap_chan_lock_conn(chan);
+	__l2cap_chan_close(chan, reason);
+	l2cap_chan_unlock_conn(chan, have_conn);
+}
+EXPORT_SYMBOL(l2cap_chan_close_unlocked);
+
 static inline u8 l2cap_get_auth_type(struct l2cap_chan *chan)
 {
 	switch (chan->chan_type) {
@@ -1608,7 +1659,7 @@ static void l2cap_conn_start(struct l2cap_conn *conn)
 			if (!l2cap_mode_supported(chan->mode, conn->feat_mask)
 			    && test_bit(CONF_STATE2_DEVICE,
 					&chan->conf_state)) {
-				l2cap_chan_close(chan, ECONNRESET);
+				__l2cap_chan_close(chan, ECONNRESET);
 				l2cap_chan_unlock(chan);
 				continue;
 			}
@@ -1616,7 +1667,7 @@ static void l2cap_conn_start(struct l2cap_conn *conn)
 			if (l2cap_check_enc_key_size(conn->hcon, chan))
 				l2cap_start_connection(chan);
 			else
-				l2cap_chan_close(chan, ECONNREFUSED);
+				__l2cap_chan_close(chan, ECONNREFUSED);
 
 		} else if (chan->state == BT_CONNECT2) {
 			struct l2cap_conn_rsp rsp;
@@ -7741,7 +7792,7 @@ static inline void l2cap_check_encryption(struct l2cap_chan *chan, u8 encrypt)
 			__set_chan_timer(chan, L2CAP_ENC_TIMEOUT);
 		} else if (chan->sec_level == BT_SECURITY_HIGH ||
 			   chan->sec_level == BT_SECURITY_FIPS)
-			l2cap_chan_close(chan, ECONNREFUSED);
+			__l2cap_chan_close(chan, ECONNREFUSED);
 	} else {
 		if (chan->sec_level == BT_SECURITY_MEDIUM)
 			__clear_chan_timer(chan);
-- 
2.53.0



