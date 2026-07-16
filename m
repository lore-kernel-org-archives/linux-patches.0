Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C2542466A;
	Thu, 16 Jul 2026 13:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209498; cv=none; b=lDRhRoqgZ9Xgl9/AcTqk/pZ7nSDLIq69aGcmGXXEWHQKf8YnqxD7FJyTkYpjQ8gvCnUPYUvKLRq81dgCVUd3Frlf8jgHk893//UB9BWctmT/9ycpgDH0PNE7l7BRziYLn0qF4zoWdQ1Ey2ZLeHSuFY0vBT0RCdmP3n+KAeSwkyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209498; c=relaxed/simple;
	bh=0eqMQkScGYVcbHNZHehqLbSh7F6Td34y+mxLfnb050I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtxNv5ePfX9sTeoT2gBe2lsrbeRp/SJjAnkNVNXXqPTIaVOkZe1V2hwTfCpDpzREzChk0kb3ONtkdiwn8Rw0xy9JyBgPcfMny5rvLcOxGKJMq2ICM/TDsGfz+UtryR3MKuMeGomZGnwYR48gCC2Hp9dH2nIPyj7EDO5QDsxLvpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgDGcDC/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgDGcDC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2FE1F00ADB;
	Thu, 16 Jul 2026 13:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209494;
	bh=P4Rfe1uB459G0k/SB8kw0O0YR9a/DsLLGQw9jIf4DY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgDGcDC/1v99AEwJCP+NHtu8Gx+tS5MF2ldWr+FpntRaMt4fMIuqMCLOYpIrs18BA
	 VZG7ryqoNN42SZtL63VfeYLDTjidfNmA7931JCy7eJSkazDi7RxVasZMVZ8GhbU+u9
	 DW5SkB+b2TeqMZ0htrqAzDJeWdX4JUfUtlNf8QFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fed5dce4553262f3b35c@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.1 205/518] Bluetooth: bnep: pin L2CAP connection during netdev registration
Date: Thu, 16 Jul 2026 15:27:53 +0200
Message-ID: <20260716133052.305769626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 
 static const struct device_type bnep_type = {
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


