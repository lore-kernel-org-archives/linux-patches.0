Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E8C436342;
	Tue, 21 Jul 2026 20:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665090; cv=none; b=sQ3tjle1i4v9HSBpxdloB9yXpMGT51lPh0IfBSkVILgzNzANBTvzBvUkHFDIEdjcOWxdkm9g7n9Xe8KOoFWYgLPgT1sD5DWrOVvfgqw2m94KKJXhIbH5bJ8+FHZYTKEKoYPuQMY+FXI4XIsDtJYzChRxQ+hsY8Kz5qncgDpV7GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665090; c=relaxed/simple;
	bh=qQDOkEyU9iWjhG8ysQGK4dyDw0G7MF+ANDGR61E5dSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGVyi93Ak44AxiD3vTDVYhFCBKO2UtDquo6BLNgrDtvWiCb5OOJU2YTpxd3dc1axTPuXGwB6CE7TwPhM0PTGv2vjbB636DLxmJCsLC5fEryzgTJJF+RKYY83IWph0HkYQafa6JHljVcETG3XOMYg5jlmXP1smnOFwyNOF/ylLCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mq6Lh96p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mq6Lh96p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413851F000E9;
	Tue, 21 Jul 2026 20:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665087;
	bh=fa3teA7HBjL9qp9S2M6VYE3kZtS0qHJhoPPvpWggr98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mq6Lh96pRL9ecjV74Q4ARv/blrnso/xa1RyQ9CqRki791lKgGYqS68PcWNV/TJkcG
	 lyzP7ak5hCNKSG9AlRBfv470Z7xEx3Gwnn2gYGaGy1GVPkBdJRtFPYsOqfo46/R3AE
	 WJHou+9ZsT8m6oIR7sSWXnhqv7B59zE/OIEmX3tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fed5dce4553262f3b35c@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0171/1266] Bluetooth: bnep: pin L2CAP connection during netdev registration
Date: Tue, 21 Jul 2026 17:10:08 +0200
Message-ID: <20260721152445.633026095@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

commit bb067a99a0356196c0b89a95721985485ebce5a5 upstream.

bnep_add_connection() reads the L2CAP connection without holding the
channel lock, then passes its HCI device to register_netdev(). Controller
teardown can clear and release that connection concurrently, leaving the
network device registration path to dereference a freed parent device.

Take a reference to the L2CAP connection while holding the channel lock.
Retain it until register_netdev() has taken the parent device reference.

Fixes: 65f53e9802db ("Bluetooth: Access BNEP session addresses through L2CAP channel")
Reported-by: syzbot+fed5dce4553262f3b35c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fed5dce4553262f3b35c
Cc: stable@vger.kernel.org
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/bnep/core.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -562,14 +562,18 @@ static int bnep_session(void *arg)
 	return 0;
 }
 
-static struct device *bnep_get_device(struct bnep_session *session)
+static struct l2cap_conn *bnep_get_conn(struct bnep_session *session)
 {
-	struct l2cap_conn *conn = l2cap_pi(session->sock->sk)->chan->conn;
+	struct l2cap_chan *chan = l2cap_pi(session->sock->sk)->chan;
+	struct l2cap_conn *conn;
 
-	if (!conn || !conn->hcon)
-		return NULL;
+	l2cap_chan_lock(chan);
+	conn = chan->conn;
+	if (conn)
+		l2cap_conn_get(conn);
+	l2cap_chan_unlock(chan);
 
-	return &conn->hcon->dev;
+	return conn;
 }
 
 static struct device_type bnep_type = {
@@ -581,6 +585,7 @@ int bnep_add_connection(struct bnep_conn
 	u32 valid_flags = BIT(BNEP_SETUP_RESPONSE);
 	struct net_device *dev;
 	struct bnep_session *s, *ss;
+	struct l2cap_conn *conn = NULL;
 	u8 dst[ETH_ALEN], src[ETH_ALEN];
 	int err;
 
@@ -640,10 +645,18 @@ int bnep_add_connection(struct bnep_conn
 	bnep_set_default_proto_filter(s);
 #endif
 
-	SET_NETDEV_DEV(dev, bnep_get_device(s));
+	conn = bnep_get_conn(s);
+	if (!conn) {
+		err = -ENOTCONN;
+		goto failed;
+	}
+
+	SET_NETDEV_DEV(dev, &conn->hcon->dev);
 	SET_NETDEV_DEVTYPE(dev, &bnep_type);
 
 	err = register_netdev(dev);
+	l2cap_conn_put(conn);
+	conn = NULL;
 	if (err)
 		goto failed;
 
@@ -665,6 +678,8 @@ int bnep_add_connection(struct bnep_conn
 	return 0;
 
 failed:
+	if (conn)
+		l2cap_conn_put(conn);
 	up_write(&bnep_session_sem);
 	free_netdev(dev);
 	return err;


