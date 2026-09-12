Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85D0432304;
	Sat, 12 Sep 2026 08:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202667; cv=none; b=Tyc6OSmOhrx9xIQ8obS/wia8zXyS3iajPgiHifgNLRrHu4yQpdMy9uzprnMvuB6IOXHTH+7Qa42tsGr6jv8uqEJVzVtaaop7lnb0yhMOvpIjUhA25iVVvOBphZB4fMoVl24WpXB41hEgAVrYBmqAwXBAmw3tbDArjFNbqa/ndsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202667; c=relaxed/simple;
	bh=6E4nV42lY3V2Q0WEspxkwVxgPVqj8LF7JP0w15BmwYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVqeaEZ7p8j90ZqVhe+23Z4tkojwBR7biBiRS5lS7Js0tRwwaeapYDgDNCZnw2kd7IuR8Zv0DtQv9Yo5kNvbbqm3xHYIrCPPoZNrfaBI/cGwa/71qrRthN41cklVCKW4inG4ERfBg9f9SAtMR/IbWjAWGhQP4h2pVybsEu805BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhIkLgxm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhIkLgxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2411F000FF;
	Sat, 12 Sep 2026 08:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202666;
	bh=31aqUZzSmIj0iaSol7jVVpV0/nDZLEWqK4GNgMEwB5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhIkLgxm+ZcNl9mZs7Ze97IUz1AWeENFjhg3kiYNduJ+aHckUiCU8dWgjdXNK8+5z
	 LZJsH3b8JSzSR1va/ppYsLC51ue7UR3K9X1+b48R8Iq4cyaJ/BmulM4+U0GP9F+6cz
	 wEIADEBrmZ1jW55oYHprViIW4TlaCtsLHUfd5Oxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1251/1815] Bluetooth: hci_conn: fix the SCO setup context lifetime
Date: Sat, 12 Sep 2026 08:50:01 +0200
Message-ID: <20260912065718.383370169@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 42de40abe25db9211107af8896d0fd741f10648d ]

hci_setup_sync() queues a conn_handle_t with a NULL destroy callback, so
the context is only freed if hci_enhanced_setup_sync() actually runs. An
entry that is cancelled instead is leaked, as
_hci_cmd_sync_cancel_entry() does not release entry->data when there is
no destroy callback, and hci_cmd_sync_clear() cancels every pending entry
when the controller is unregistered.

The context also stores a bare hci_conn pointer, so the connection can be
freed while the work is queued. The dequeue in hci_conn_del() does not
cover it either, as it matches on entry->data == conn and entry->data is
the wrapper here. Same problem as commit 2f5d635ad590 ("Bluetooth:
hci_sync: hold conn in hci_connect_acl/le_sync() callbacks").

Hold the connection and release both from a destroy callback. The
submission failure path drops both, since hci_cmd_sync_submit() does not
call the destroy callback when it fails to queue.

Fixes: e07a06b4eb41 ("Bluetooth: Convert SCO configure_datapath to hci_sync")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 7e4d737a795f9..8de98af2fb581 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -283,8 +283,6 @@ static int hci_enhanced_setup_sync(struct hci_dev *hdev, void *data)
 	struct hci_cp_enhanced_setup_sync_conn cp;
 	const struct sco_param *param;
 
-	kfree(conn_handle);
-
 	if (!hci_conn_valid(hdev, conn))
 		return -ECANCELED;
 
@@ -453,6 +451,15 @@ static bool hci_setup_sync_conn(struct hci_conn *conn, __u16 handle)
 	return true;
 }
 
+static void hci_enhanced_setup_sync_destroy(struct hci_dev *hdev, void *data,
+					    int err)
+{
+	struct conn_handle_t *conn_handle = data;
+
+	hci_conn_put(conn_handle->conn);
+	kfree(conn_handle);
+}
+
 bool hci_setup_sync(struct hci_conn *conn, __u16 handle)
 {
 	int result;
@@ -464,12 +471,15 @@ bool hci_setup_sync(struct hci_conn *conn, __u16 handle)
 		if (!conn_handle)
 			return false;
 
-		conn_handle->conn = conn;
+		conn_handle->conn = hci_conn_get(conn);
 		conn_handle->handle = handle;
 		result = hci_cmd_sync_queue(conn->hdev, hci_enhanced_setup_sync,
-					    conn_handle, NULL);
-		if (result < 0)
+					    conn_handle,
+					    hci_enhanced_setup_sync_destroy);
+		if (result < 0) {
+			hci_conn_put(conn);
 			kfree(conn_handle);
+		}
 
 		return result == 0;
 	}
-- 
2.53.0



