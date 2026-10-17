Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AAC7404E;
	Sat, 17 Oct 2026 16:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254737; cv=none; b=F03Bi4/4dCNi7K7ioU8kwkAhXIp0sBFdHVCmsrDbhixe2zaW3WmhgVcOxDZnC5z8biNsJbn2dhvuHnDwECX7Vf0PJItAFnZk3/VKF8NtZ23m1g6tprDGsOre2L7z9uFd5i/EBk5CFqQME+G4tQOK9MswcYDXC44wsT+xJ3ktsc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254737; c=relaxed/simple;
	bh=ydz7NwwS+xSUP3+fuCH/FFvayvE2kMQAZMzR8Q/1JMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXEZonH8Ke5G/5aYobcljH0rOMU/vEpKa/5sYoae3VuFtPLwfc8Zub/33GcjKKXp9Biz47vgdAl/euMLy9fBp7E90zjHVpOvCFTS7neKrHTkcxCvlMX/rcry3teTBk0zxBrgZ5VzFqDGOnWfqgd4HcONwFx3E99ZEp+y9Q0ivpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nwpo6KAt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nwpo6KAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027931F000C4;
	Sat, 17 Oct 2026 16:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254736;
	bh=ZGzQ3o9g5DW4vy/MJxm0M8oaLcXhJ9I5HlS8JW7vKHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nwpo6KAt45YdmC5Ljb8a0a/EzT9YXnXuwI90MEecKv4GYFkj5P869fPZB6IJUstEe
	 Mk22xwcET0Jm38k0r+afpmPx1CLXe90Wc6x2spJ2/zI7R8HR6ONWGLH+GPCsPhnhpt
	 N4oCapzk7RQ6RCkXtgsntnVTbzskSGfIhW3oOFrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 544/869] Bluetooth: hci_sync: hold conn in hci_connect_acl/le_sync() callbacks
Date: Sat, 17 Oct 2026 17:56:25 +0200
Message-ID: <20261017160051.040790890@linuxfoundation.org>
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

[ Upstream commit 2f5d635ad5906b0235bc0c870e8beba3116e1e98 ]

There is theoretical UAF if the conn is freed while the hci_sync task
is running.

Hold refcount to avoid that.

Fixes: 881559af5f5c ("Bluetooth: hci_sync: Attempt to dequeue connection attempt")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 92ef7d88f8e3c..dfa0150669551 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -7149,12 +7149,23 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 	return err;
 }
 
+static void hci_acl_create_conn_sync_complete(struct hci_dev *hdev, void *data,
+					      int err)
+{
+	struct hci_conn *conn = data;
+
+	hci_conn_put(conn);
+}
+
 int hci_connect_acl_sync(struct hci_dev *hdev, struct hci_conn *conn)
 {
 	int err;
 
-	err = hci_cmd_sync_queue_once(hdev, hci_acl_create_conn_sync, conn,
-				      NULL);
+	err = hci_cmd_sync_queue_once(hdev, hci_acl_create_conn_sync,
+				      hci_conn_get(conn),
+				      hci_acl_create_conn_sync_complete);
+	if (err)
+		hci_conn_put(conn);
 	return (err == -EEXIST) ? 0 : err;
 }
 
@@ -7165,36 +7176,41 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 	bt_dev_dbg(hdev, "err %d", err);
 
 	if (err == -ECANCELED)
-		return;
+		goto done;
 
 	hci_dev_lock(hdev);
 
 	if (!hci_conn_valid(hdev, conn))
-		goto done;
+		goto unlock;
 
 	if (!err) {
 		hci_connect_le_scan_cleanup(conn, 0x00);
-		goto done;
+		goto unlock;
 	}
 
 	/* Check if connection is still pending */
 	if (conn != hci_lookup_le_connect(hdev))
-		goto done;
+		goto unlock;
 
 	/* Flush to make sure we send create conn cancel command if needed */
 	flush_delayed_work(&conn->le_conn_timeout);
 	hci_conn_failed(conn, bt_status(err));
 
-done:
+unlock:
 	hci_dev_unlock(hdev);
+done:
+	hci_conn_put(conn);
 }
 
 int hci_connect_le_sync(struct hci_dev *hdev, struct hci_conn *conn)
 {
 	int err;
 
-	err = hci_cmd_sync_queue_once(hdev, hci_le_create_conn_sync, conn,
+	err = hci_cmd_sync_queue_once(hdev, hci_le_create_conn_sync,
+				      hci_conn_get(conn),
 				      create_le_conn_complete);
+	if (err)
+		hci_conn_put(conn);
 	return (err == -EEXIST) ? 0 : err;
 }
 
-- 
2.53.0



