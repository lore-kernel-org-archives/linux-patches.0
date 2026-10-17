Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6210A391E51;
	Sat, 17 Oct 2026 18:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260050; cv=none; b=RCF3qMjznB/AUaA3DsPwwGJ1bJoNcZPlRwIF4ACSmfFhutMsU+Wobioeae1MxmkUkkkeAzi2TQHtDYaSzXHUVXbcU1/8+0A70iI5uLLYI12F4PSFj5tGqUiyGNS9wC0fBiPiBW6R6z40PEeIAy+5a/EIv4Pg78jLu6bWXdhZOXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260050; c=relaxed/simple;
	bh=AadJd2+LVKHYXpYofiyBeCWJ8XArfHsEymV9InF9BXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDUAE93zLL+n2mJ09vRcB5wIuV0nSbArly8BWit4zSQKles2d9RxlpCjrp0/VcrghHrypXS6QCr7q5kInA4BDqW8V4A/2KXGgq4oMNBOwL7C3TqlGRoJG24y0sRuWLMmtVLgpVdAP7cTb+Pyfb2XDTmMPPAfXkCwQjUaOMsI5QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0Dn8PN0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0Dn8PN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9741F000C4;
	Sat, 17 Oct 2026 18:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260049;
	bh=FiWX7VaA1NLP4fXIjyByC2DUIbnjgs1HrPP5fcmLiqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0Dn8PN07lZCxbd6VdYIfCdUknnQB/uGfChUDwgzCM7OlMd/ucNAiu0FAobIMIq8p
	 ym6wlwh6dfcYKFX+eLgLbHrgNTbLtZc76E1s/0FJyt7ecdTU7/K0hsVpz5OtOWV95m
	 6qk54W4w6IwarHe3OlDyDGdC38GoOi/HQjwMims0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c40ad7c6ed7165e46e8@syzkaller.appspotmail.com,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1417/1674] Bluetooth: L2CAP: use proto_lock for l2cap_data to fix l2cap_disconn_ind
Date: Sat, 17 Oct 2026 18:01:29 +0200
Message-ID: <20261017160507.552826790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 0b4b7fcca9879..260031e59d646 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1824,7 +1824,10 @@ static void l2cap_conn_del(struct hci_conn *hcon, int err)
 	hci_chan_del(conn->hchan);
 	conn->hchan = NULL;
 
+	spin_lock(&hcon->proto_lock);
 	hcon->l2cap_data = NULL;
+	spin_unlock(&hcon->proto_lock);
+
 	mutex_unlock(&conn->lock);
 	l2cap_conn_put(conn);
 }
@@ -7105,8 +7108,6 @@ static struct l2cap_conn *l2cap_conn_add(struct hci_conn *hcon)
 	}
 
 	kref_init(&conn->ref);
-	hcon->l2cap_data = conn;
-	conn->hcon = hci_conn_get(hcon);
 	conn->hchan = hchan;
 
 	BT_DBG("hcon %p conn %p hchan %p", hcon, conn, hchan);
@@ -7135,6 +7136,11 @@ static struct l2cap_conn *l2cap_conn_add(struct hci_conn *hcon)
 
 	conn->disc_reason = HCI_ERROR_REMOTE_USER_TERM;
 
+	spin_lock(&hcon->proto_lock);
+	conn->hcon = hci_conn_get(hcon);
+	hcon->l2cap_data = conn;
+	spin_unlock(&hcon->proto_lock);
+
 	return conn;
 }
 
@@ -7524,13 +7530,18 @@ static void l2cap_connect_cfm(struct hci_conn *hcon, u8 status)
 
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



