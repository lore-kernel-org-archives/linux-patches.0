Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2BB3A5459;
	Sat, 17 Oct 2026 16:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255034; cv=none; b=Y0AhT75TWxEWyEpCpRZ8RoCIw5BgGGgakJwxkpMdYUxpJbpLVA6Y6LvJi2hqB1Ja9b2mA7MTZ+rIYLmFNbwrvBD8qsWPRF1UB3WkKDdlXt1W5FTXh7BVI96Enxo0AsIUJPvv74UJerQEOuKxAgUEw/V51DN8SaPi19ra9eDhKFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255034; c=relaxed/simple;
	bh=qx4t6hTm0Ykd82DwvqjOjM9DSa699I3UkaMNPEvtcfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5vndti6BP+ouArAjQhmTU7iE49TYg+q6nOqQz3RM0rsFaxF1zJE+VPdeg9PJjHnglBUit3JGO8oJPmIwLFZq5m92mK9060Jq2xv3BDmGiefz9v0W7L3CbLb3i0VUWlFS6kbZoNrjtJCMr9YXjjzsZBppgLGRPPgZuvQY5HV+I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4G67moL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4G67moL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739DA1F000C4;
	Sat, 17 Oct 2026 16:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255033;
	bh=EYyJiueuoKUeHFNkt67lUA3wRZ6vvbQqrqjfV50tAow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y4G67moLq/n7UvAx5oVK2Tp84jwX99lMKkQQ94llcjzPR/z2GnXYXjmfrHXYhwC6m
	 mez2xOzvrR7T3gl0IMl4HSeooCUIQs84wWljeXaffQDgUYwALdArf6HkWn8xc8PAER
	 Q84XYmOvlXM4pQha1NULhV0zjvbhP6HNyniGt2aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c40ad7c6ed7165e46e8@syzkaller.appspotmail.com,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 642/869] Bluetooth: L2CAP: use proto_lock for l2cap_data to fix l2cap_disconn_ind
Date: Sat, 17 Oct 2026 17:58:03 +0200
Message-ID: <20261017160053.475221018@linuxfoundation.org>
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

[ Upstream commit 2b66c83ff1751d6bd3201b3017206262ab46dc05 ]

hci_conn::l2cap_data is accessed without locks in l2cap_disconn_ind via
hci_conn_timeout (disc_work) -> hci_proto_disconn_ind ->
l2cap_disconn_ind.  This is UAF if the l2cap_conn is deleted
concurrently.

disc_work is disabled sync in hci_conn_del(), so we cannot take
hci_dev_lock in disc_work.

Fix by using proto_lock to guard l2cap_data, in addition to hdev->lock
which is held in other access paths.

Fixes: ab4eedb790ca ("Bluetooth: L2CAP: Fix corrupted list in hci_chan_del")
Reported-by: syzbot+9c40ad7c6ed7165e46e8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9c40ad7c6ed7165e46e8
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 12d39f1e822b3..61914f280d6fa 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1843,7 +1843,10 @@ static void l2cap_conn_del(struct hci_conn *hcon, int err)
 	hci_chan_del(conn->hchan);
 	conn->hchan = NULL;
 
+	spin_lock(&hcon->proto_lock);
 	hcon->l2cap_data = NULL;
+	spin_unlock(&hcon->proto_lock);
+
 	mutex_unlock(&conn->lock);
 	l2cap_conn_put(conn);
 }
@@ -7167,8 +7170,6 @@ static struct l2cap_conn *l2cap_conn_add(struct hci_conn *hcon)
 	}
 
 	kref_init(&conn->ref);
-	hcon->l2cap_data = conn;
-	conn->hcon = hci_conn_get(hcon);
 	conn->hchan = hchan;
 
 	BT_DBG("hcon %p conn %p hchan %p", hcon, conn, hchan);
@@ -7197,6 +7198,11 @@ static struct l2cap_conn *l2cap_conn_add(struct hci_conn *hcon)
 
 	conn->disc_reason = HCI_ERROR_REMOTE_USER_TERM;
 
+	spin_lock(&hcon->proto_lock);
+	conn->hcon = hci_conn_get(hcon);
+	hcon->l2cap_data = conn;
+	spin_unlock(&hcon->proto_lock);
+
 	return conn;
 }
 
@@ -7585,13 +7591,18 @@ static void l2cap_connect_cfm(struct hci_conn *hcon, u8 status)
 
 int l2cap_disconn_ind(struct hci_conn *hcon)
 {
-	struct l2cap_conn *conn = hcon->l2cap_data;
+	struct l2cap_conn *conn;
+	int ret = HCI_ERROR_REMOTE_USER_TERM;
 
 	BT_DBG("hcon %p", hcon);
 
-	if (!conn)
-		return HCI_ERROR_REMOTE_USER_TERM;
-	return conn->disc_reason;
+	spin_lock(&hcon->proto_lock);
+	conn = hcon->l2cap_data;
+	if (conn)
+		ret = conn->disc_reason;
+	spin_unlock(&hcon->proto_lock);
+
+	return ret;
 }
 
 static void l2cap_disconn_cfm(struct hci_conn *hcon, u8 reason)
-- 
2.53.0



