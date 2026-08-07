Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7B029C328;
	Fri,  7 Aug 2026 15:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115993; cv=none; b=r6jJKSjz2Bx7gTGjSX/mdNlnAukihPofSW5FvFgst5E+iZnJD4SDPL2S5PgxIuV3qelzoWcJGI2oc5oKU6KxT7mNgF0Wz7Z5xg2rXfmrzoVFHWcx1qxjdNDF7goozAgglSvCdlTEIrx1bv67VER5wHHaAErKbUyHFdP2DrMtgT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115993; c=relaxed/simple;
	bh=Let03FqsPB6S7aIWkfDx9WFURqE9aw9qdWx6qdA9Ot4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9rR+1aR0PVu4sBiiaLPJmZVUCce5YmM19Gxe3jKcaDaXoNG3hcc2Qq8OT/S6uK1w41/XI52zfIPpSdQIkJ4e7ioUVlQdJ87dc6J7wRTp4LewAdNiQ3obalvD+73MA6xOR1AnBEwdjxGwvZbwzJ2ziHpxgZ/FH5fyp0vgrZKrEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCne6NdG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCne6NdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB221F000E9;
	Fri,  7 Aug 2026 15:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115991;
	bh=zhMjeGIHWIOmtyw1eJSbxUFmL6dcUl3LagMXI1t4xuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FCne6NdGZeDlMhIEWw9OCLpPAfZoK6Q7N2iqpn5Bg+T7wJKb4AUczsjMYcW7QO0ho
	 fH1atGy5mhyx+cOxqtjp3W3X9Orqiqfvvm+ztoQpBsVLMUrZ1a4NkOeNu6q8ttgUeQ
	 AiQZJxkcePeKeDJChNxaVN4Ao2d/TcDeeBZIfC0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/261] Bluetooth: hci_sync: make hci_cmd_sync_run_once return -EEXIST if exists
Date: Fri,  7 Aug 2026 16:37:04 +0200
Message-ID: <20260807143416.828536933@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

[ Upstream commit d288f4db0909c22342eb50cd1632b4d850517281 ]

hci_cmd_sync_run_once() needs to indicate whether a queue item was
added, so caller can know if callbacks are called, so it can avoid
leaking resources.

Change the function to return -EEXIST if queue item already exists.

Modify all callsites vs. the changes.  The only callsite is
hci_abort_conn().

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 5761d003daa9 ("Bluetooth: hci_conn: hold conn reference in abort_conn_sync()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 4 +++-
 net/bluetooth/hci_sync.c | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 19ca5016372ac..7625461dff7ae 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2899,6 +2899,7 @@ static int abort_conn_sync(struct hci_dev *hdev, void *data)
 int hci_abort_conn(struct hci_conn *conn, u8 reason)
 {
 	struct hci_dev *hdev = conn->hdev;
+	int err;
 
 	/* If abort_reason has already been set it means the connection is
 	 * already being aborted so don't attempt to overwrite it.
@@ -2920,5 +2921,6 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
 	 * as a result to MGMT_OP_DISCONNECT/MGMT_OP_UNPAIR which does
 	 * already queue its callback on cmd_sync_work.
 	 */
-	return hci_cmd_sync_run_once(hdev, abort_conn_sync, conn, NULL);
+	err = hci_cmd_sync_run_once(hdev, abort_conn_sync, conn, NULL);
+	return (err == -EEXIST) ? 0 : err;
 }
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 4b1fcea37941f..df207c3f1c5c3 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -849,7 +849,7 @@ int hci_cmd_sync_run_once(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 			  void *data, hci_cmd_sync_work_destroy_t destroy)
 {
 	if (hci_cmd_sync_lookup_entry(hdev, func, data, destroy))
-		return 0;
+		return -EEXIST;
 
 	return hci_cmd_sync_run(hdev, func, data, destroy);
 }
-- 
2.53.0



