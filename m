Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE1D43CEF9;
	Tue, 21 Jul 2026 21:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671089; cv=none; b=YSBYRAN2U4UMelcnc15Q48zY7n4M4CN8S1wNryQNAl+N5bKYGdKGtbsPWZH5mbRLi+3Mhy4g0k1AFxr1I2WQdXAfQvdOmClCwzezvDr0K0DauWSqCd8no3BeW9zGRL+v+KfkT5gKU3pTSIsAfXa+JdVYfE3D5DJf3g/JfIvZYTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671089; c=relaxed/simple;
	bh=U8I+qGFWmkJNQ5SBEe8Dybhfm4d+NXOBNLzXkJsbvus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxeKG+XJ70rPj0aIm0fVvgmzkFFTOtLA9XsuswPL2smHo/vZXT7ft1+91Y5s2p1hPVbVNzEpOQxYJBeVoitdsQNTehwGQ8wtafH7NXX0W9U4L81+cVzqo+0xYtnfFKLW34kXzGWlGQiVK89vLqGQBl5mUwvwGxJQZgRXpMjjuvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4ysHH+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4ysHH+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD291F000E9;
	Tue, 21 Jul 2026 21:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671084;
	bh=FfaExltcBpfNOO+XCYAAyNSqb2gXk5hvl21NVG8hWKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4ysHH+OltUHzy3DmHWlXcsl5TINbvxBVUwSUFVLYHONUJRrOLrrck0dfBx4m/aK+
	 N/rF2dw74iGQDmWVlAR8zv+7K9xnxm95cVMDCw69N1kxnI5JK6u/1hFAI4hcDR768H
	 ToHhPmiG7fdjrB4JoS4WMAoBoGoLyEZ035TqGwwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fed5dce4553262f3b35c@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 112/843] Bluetooth: bnep: pin L2CAP connection during netdev registration
Date: Tue, 21 Jul 2026 17:15:47 +0200
Message-ID: <20260721152408.522276768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


