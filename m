Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA51231829;
	Tue, 21 Jul 2026 22:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673299; cv=none; b=W/Pf6tLcWA9E2KrdrSs6UOyXXUN8FZP8VEt1FdkN2J8uoRJddVyzD/C0aWwILSuqN5L1RthvU6KS5zwez/E8XhOw6NupDL5GkY1kMkVModI8M6KXl3RGTnTR2wjXIrECF5ukqRNV+JmhnEDPwgUFbGkj63VZ/D4DVsaGgNYn7Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673299; c=relaxed/simple;
	bh=shQPbtl482LUMBuM/ACQyvpIuhTdvKRKMjm9/exyu0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bn6bzTRqiT5hsoW/ldyh0TM1LrZx4PzULlMfIIxyJmljU/BWrk5VJLw7SJNBUAbjZqDSpAN3km5VvXpye6sWYAzxiAMdhmQklH5u1TTvBOLxUXDtz9v0ZVKPj3SqVHQEYbJ6tJigKmR6brnUgCel3c0C1ED7hzvHQ9hrGFgBPAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HD211YUk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HD211YUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3134C1F000E9;
	Tue, 21 Jul 2026 22:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673298;
	bh=hlc/Ucqk2wnsqASV0sMrFIVVTBdSaz+h4yDPUUx0sU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HD211YUk5ueYPWhOk2/6pCUpn7iiMoVvcAjxW7aelHPMS0pbZ4fbmMrgGfIF2tc1w
	 TPwZ0uesgt44xiBFyR2OyLiVjPOtSykP9lo4dOq8IR0JAd9Z2O/VbJZVioRTC94x4f
	 FBHCfCtRJvbCOvC+9mL4anJOmQqGovZUn+H0mhtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fed5dce4553262f3b35c@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 083/699] Bluetooth: bnep: pin L2CAP connection during netdev registration
Date: Tue, 21 Jul 2026 17:17:22 +0200
Message-ID: <20260721152357.576974344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -540,14 +540,18 @@ static int bnep_session(void *arg)
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
@@ -559,6 +563,7 @@ int bnep_add_connection(struct bnep_conn
 	u32 valid_flags = BIT(BNEP_SETUP_RESPONSE);
 	struct net_device *dev;
 	struct bnep_session *s, *ss;
+	struct l2cap_conn *conn = NULL;
 	u8 dst[ETH_ALEN], src[ETH_ALEN];
 	int err;
 
@@ -618,10 +623,18 @@ int bnep_add_connection(struct bnep_conn
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
 
@@ -643,6 +656,8 @@ int bnep_add_connection(struct bnep_conn
 	return 0;
 
 failed:
+	if (conn)
+		l2cap_conn_put(conn);
 	up_write(&bnep_session_sem);
 	free_netdev(dev);
 	return err;


