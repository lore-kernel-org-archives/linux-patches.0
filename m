Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E284F3C1D64;
	Sat, 17 Oct 2026 17:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258485; cv=none; b=UMu6Vg/L6w69uEa6ruWlXz84s829fYfAmaps16sbrBr+7Hchca0dMLX+8nesN0ds7r1fkRJ1oBQjwDlNOtyZj5nZFwm4jIMpimzy3YFx9PKIhlSiytUO8IVZfY5BY4zBx58JsgJ9faGugSIx9gt4h59d3O/cEoyqU4A0wtXrW/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258485; c=relaxed/simple;
	bh=2Q+BsSUyegxNXr05B4BA0aiS8KGyGeAjZQNDXRWAjGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/MRPNjFInH48hjizxtoR/cdUro5eu91WLchzWQ+KHRLCzTZyBtwfRoTVIzm/U2b2GNjnLHfAfbU4212tpgGgBdq+Q8bectpgMZWn+wCjyKnkeU6oVZMqTnu9o7GwBete3MrlF1e0xAGIVN28+uM3i+sGA9x0e9AgMUUiARIz20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sm3YTaCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sm3YTaCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4501A1F000C4;
	Sat, 17 Oct 2026 17:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258484;
	bh=MOy6IrlhDBPyjjSii2IU0lPPmzG5jKk2+L7QanpO8IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sm3YTaCqocyorUDCduyJP9hge6XjyCEZgsXc08b0XpCKNqBvVAwtov5q3jP2duvGI
	 ztTifDfyXfVeqtBVgLLWTtHtqnVZOvb1PSd2eFvbqOhgrs74hUte3pI8GlhTYmfk5w
	 u2fWeFKbviLwwWjHdxzzPq+S8BSDF+WKZoWGGeG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0901/1674] Bluetooth: hci_sync: hci_cmd_sync_queue_once() return -EEXIST if exists
Date: Sat, 17 Oct 2026 17:52:53 +0200
Message-ID: <20261017160454.255145583@linuxfoundation.org>
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

[ Upstream commit 2969554bcfccb5c609f6b6cd4a014933f3a66dd0 ]

hci_cmd_sync_queue_once() needs to indicate whether a queue item was
added, so caller can know if callbacks are called, so it can avoid
leaking resources.

Change the function to return -EEXIST if queue item already exists.

Modify all callsites to handle that.

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 5ad66eb7f6c38..0648da9761258 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -818,7 +818,7 @@ int hci_cmd_sync_queue_once(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 			    void *data, hci_cmd_sync_work_destroy_t destroy)
 {
 	if (hci_cmd_sync_lookup_entry(hdev, func, data, destroy))
-		return 0;
+		return -EEXIST;
 
 	return hci_cmd_sync_queue(hdev, func, data, destroy);
 }
@@ -3376,6 +3376,8 @@ static int update_passive_scan_sync(struct hci_dev *hdev, void *data)
 
 int hci_update_passive_scan(struct hci_dev *hdev)
 {
+	int err;
+
 	/* Only queue if it would have any effect */
 	if (!test_bit(HCI_UP, &hdev->flags) ||
 	    test_bit(HCI_INIT, &hdev->flags) ||
@@ -3385,8 +3387,9 @@ int hci_update_passive_scan(struct hci_dev *hdev)
 	    hci_dev_test_flag(hdev, HCI_UNREGISTER))
 		return 0;
 
-	return hci_cmd_sync_queue_once(hdev, update_passive_scan_sync, NULL,
-				       NULL);
+	err = hci_cmd_sync_queue_once(hdev, update_passive_scan_sync, NULL,
+				      NULL);
+	return (err == -EEXIST) ? 0 : err;
 }
 
 int hci_write_sc_support_sync(struct hci_dev *hdev, u8 val)
@@ -7106,8 +7109,11 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 
 int hci_connect_acl_sync(struct hci_dev *hdev, struct hci_conn *conn)
 {
-	return hci_cmd_sync_queue_once(hdev, hci_acl_create_conn_sync, conn,
-				       NULL);
+	int err;
+
+	err = hci_cmd_sync_queue_once(hdev, hci_acl_create_conn_sync, conn,
+				      NULL);
+	return (err == -EEXIST) ? 0 : err;
 }
 
 static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
@@ -7143,8 +7149,11 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 
 int hci_connect_le_sync(struct hci_dev *hdev, struct hci_conn *conn)
 {
-	return hci_cmd_sync_queue_once(hdev, hci_le_create_conn_sync, conn,
-				       create_le_conn_complete);
+	int err;
+
+	err = hci_cmd_sync_queue_once(hdev, hci_le_create_conn_sync, conn,
+				      create_le_conn_complete);
+	return (err == -EEXIST) ? 0 : err;
 }
 
 static int hci_acl_cancel_create_conn_sync(struct hci_dev *hdev,
-- 
2.53.0



