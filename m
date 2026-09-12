Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B68741D648;
	Sat, 12 Sep 2026 08:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202658; cv=none; b=kacyjhkTnT/0GgKCXa3UCSpfhMIJzhIxpAsWgVvexv4WtwqQtXk1+w+xqxNScgBjcvDTySWpL6YmvgHoTOy/WrkkYBsXO/fz/tUie/4fZasqZq9D0Ld05LsmXmnuV+VypszJs4IpwltrdweTAo8YrzN1nVEeStIxPNQyPQYhsys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202658; c=relaxed/simple;
	bh=N8Er14r0Nn/AzuMRetL3W5tCAk48OOBWoaNUHjllyQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4NxRURsPP9uLiUpOOQnebQ4exEgj6lsYhcjjMjmdvtqGmOwRFYa3L17Fou6O06li35a3h2yv1jPBZU3Uv+5CCcnBmXDEISe8HpD2VLW61qAUhGO7IZU6FMRI2/TJ0ulPZ3C7h5psc1XzGE9qb45/iXNI3L1YAfPYS4EI0AP/2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTm8yYtG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTm8yYtG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EF31F00893;
	Sat, 12 Sep 2026 08:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202657;
	bh=GhHZaivg5mP0QQP+WgZI1Ss6Nja/lD0Eoojy13J3WSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTm8yYtGt9NGFOnA722O6dvqPaLkNpLOn+PpVpm1al3xWerD5W/wwXp5XIpfE8HEs
	 u1Cvf6EuJsqvintxP7HrQc141ASN+UmAo0TLLaBKhWQpGeGS4Hx8RquF8sLtm0jKtI
	 039Nm3bV0tm8V1X05Qh6lQKl9zLPBcoXSQdqUkkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c40ad7c6ed7165e46e8@syzkaller.appspotmail.com,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1249/1815] Bluetooth: L2CAP: use proto_lock for l2cap_data to fix l2cap_disconn_ind
Date: Sat, 12 Sep 2026 08:49:59 +0200
Message-ID: <20260912065718.336053789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 1156aba4e83c4..30d7120d3a150 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1833,7 +1833,10 @@ static void l2cap_conn_del(struct hci_conn *hcon, int err)
 	hci_chan_del(conn->hchan);
 	conn->hchan = NULL;
 
+	spin_lock(&hcon->proto_lock);
 	hcon->l2cap_data = NULL;
+	spin_unlock(&hcon->proto_lock);
+
 	mutex_unlock(&conn->lock);
 	l2cap_conn_put(conn);
 }
@@ -7168,8 +7171,6 @@ static struct l2cap_conn *l2cap_conn_add(struct hci_conn *hcon)
 	}
 
 	kref_init(&conn->ref);
-	hcon->l2cap_data = conn;
-	conn->hcon = hci_conn_get(hcon);
 	conn->hchan = hchan;
 
 	BT_DBG("hcon %p conn %p hchan %p", hcon, conn, hchan);
@@ -7198,6 +7199,11 @@ static struct l2cap_conn *l2cap_conn_add(struct hci_conn *hcon)
 
 	conn->disc_reason = HCI_ERROR_REMOTE_USER_TERM;
 
+	spin_lock(&hcon->proto_lock);
+	conn->hcon = hci_conn_get(hcon);
+	hcon->l2cap_data = conn;
+	spin_unlock(&hcon->proto_lock);
+
 	return conn;
 }
 
@@ -7582,13 +7588,18 @@ static void l2cap_connect_cfm(struct hci_conn *hcon, u8 status)
 
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



