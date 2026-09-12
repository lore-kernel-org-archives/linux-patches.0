Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C9C4BEE55;
	Sat, 12 Sep 2026 14:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225105; cv=none; b=ndeVuu1DMa2+4QQtYmVsTUVyoXVN0Ky1ysleTkDmP6IQ5wLNk+1B7sMPEiuJRmF6GZQuxHWht1XmDYUm2tdJUnYoNtKMJqCryDajxM6t9lj3EumnAKshN7Rog7lqsQ5VfmuMFA6E70R1tuOnnuLXDuVTIpQntBS9hYgOmROhPak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225105; c=relaxed/simple;
	bh=mgYwaFF4Gyk/CGdkLzt7FyO3lT/2c7fEWGyBw7wuWd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjo3eBUPSemx+N/Ip55RlyGvMWoY4KjWXPbOiNnxBW5dLb/LoRqoI64lqHmTZQKbXOiSEHoMa8veFNiAC77J6BLo0Vtt2v5yarO6R6kx1i5cMF3tStKdu17xlMDNPnVa5mJoCgX1EegYsPy+lLvAV+0qy7wFR6lP23MQNtTRgMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdyZTMLW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdyZTMLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA181F000FF;
	Sat, 12 Sep 2026 14:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225104;
	bh=QA3oagpNAjJoVbDr438Idmv0bIF/XpAGATUTJMHfV2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qdyZTMLWZ+gmFr0hF/5a2DwZnmX5VPPQvltu8PDaGmuBx+1YqVdt6rXnKW2IKUXmZ
	 UH557NMM3YBqESb4vFN0AdhVIEUuKMtU5xJ7g8Kk4kE7WW5EE7F9jxdzaqe7+RArxD
	 t3cVIUiibZnXXvEWQcRylFMHf6Z0xwUC05Jszq6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1128/1424] Bluetooth: hci_conn: fix the SCO setup context lifetime
Date: Sat, 12 Sep 2026 08:59:20 +0200
Message-ID: <20260912065632.560479852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 9862af567e930..c13c503674086 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -288,8 +288,6 @@ static int hci_enhanced_setup_sync(struct hci_dev *hdev, void *data)
 	struct hci_cp_enhanced_setup_sync_conn cp;
 	const struct sco_param *param;
 
-	kfree(conn_handle);
-
 	if (!hci_conn_valid(hdev, conn))
 		return -ECANCELED;
 
@@ -458,6 +456,15 @@ static bool hci_setup_sync_conn(struct hci_conn *conn, __u16 handle)
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
@@ -469,12 +476,15 @@ bool hci_setup_sync(struct hci_conn *conn, __u16 handle)
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



