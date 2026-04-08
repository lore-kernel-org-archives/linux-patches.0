Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9A33D9054;
	Wed,  8 Apr 2026 18:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674443; cv=none; b=GXirwXuxGOVpM2jWG4ukuzdzl/ZjvAvN0dOB+kOJ5S3wTIkf6qHuq0V5m698G9inYs1W7Prhjapl2X6A83ThjiRY6ZZF/tIst4RrerhQDG7fsU8/JXTMRv+F388nGJUEMOt+clds9OU18sydW0LWfW0WseL6mQHg7acrgd2+Rv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674443; c=relaxed/simple;
	bh=HFe7nCFAPOlbAvOwqUxU6L4XuGD6C31K7FV+Nie6qUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esdUQuINPt1G1dVPZsDWNkoZI28pZB75Tu++LXrghM8R+FaMyuwI+AcsQfG8JP8l5VyQmHflUdSqzdBQ380EZ0G3wOlzTH2mzbz3oqAcDx3auLKB/bUp/kJXDOOpmTAMCxbHAyHrm2H+EcGm7VxJSRjPz0m+trvTI7Bo8VAP5fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyfTLfuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyfTLfuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE34C19421;
	Wed,  8 Apr 2026 18:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674443;
	bh=HFe7nCFAPOlbAvOwqUxU6L4XuGD6C31K7FV+Nie6qUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyfTLfuGdkOLK6ls1QPtKkIoLAhsRm7y02+Pfeut88igcC28h8FBmgSUOXtGn34is
	 l53E2P/w97TG/ZpjH/oSFfs7ZRkxMYA23y6iwJ3hsKCDZH/XP9fgEOBjs/5gt9Zkpa
	 yIMJ5zENA1QfLK3x3GaroFh9cvodZWZoIRL6Aj5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 098/311] Bluetooth: hci_sync: hci_cmd_sync_queue_once() return -EEXIST if exists
Date: Wed,  8 Apr 2026 20:01:38 +0200
Message-ID: <20260408175943.074261748@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 035c25007c9e ("Bluetooth: hci_sync: Fix UAF in le_read_features_complete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 53 +++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 17 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index b4b5789ef3ab0..b501f89caf619 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -780,7 +780,7 @@ int hci_cmd_sync_queue_once(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 			    void *data, hci_cmd_sync_work_destroy_t destroy)
 {
 	if (hci_cmd_sync_lookup_entry(hdev, func, data, destroy))
-		return 0;
+		return -EEXIST;
 
 	return hci_cmd_sync_queue(hdev, func, data, destroy);
 }
@@ -3262,6 +3262,8 @@ static int update_passive_scan_sync(struct hci_dev *hdev, void *data)
 
 int hci_update_passive_scan(struct hci_dev *hdev)
 {
+	int err;
+
 	/* Only queue if it would have any effect */
 	if (!test_bit(HCI_UP, &hdev->flags) ||
 	    test_bit(HCI_INIT, &hdev->flags) ||
@@ -3271,8 +3273,9 @@ int hci_update_passive_scan(struct hci_dev *hdev)
 	    hci_dev_test_flag(hdev, HCI_UNREGISTER))
 		return 0;
 
-	return hci_cmd_sync_queue_once(hdev, update_passive_scan_sync, NULL,
-				       NULL);
+	err = hci_cmd_sync_queue_once(hdev, update_passive_scan_sync, NULL,
+				      NULL);
+	return (err == -EEXIST) ? 0 : err;
 }
 
 int hci_write_sc_support_sync(struct hci_dev *hdev, u8 val)
@@ -6934,8 +6937,11 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 
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
@@ -6971,8 +6977,11 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 
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
 
 int hci_cancel_connect_sync(struct hci_dev *hdev, struct hci_conn *conn)
@@ -7179,8 +7188,11 @@ static int hci_le_pa_create_sync(struct hci_dev *hdev, void *data)
 
 int hci_connect_pa_sync(struct hci_dev *hdev, struct hci_conn *conn)
 {
-	return hci_cmd_sync_queue_once(hdev, hci_le_pa_create_sync, conn,
-				       create_pa_complete);
+	int err;
+
+	err = hci_cmd_sync_queue_once(hdev, hci_le_pa_create_sync, conn,
+				      create_pa_complete);
+	return (err == -EEXIST) ? 0 : err;
 }
 
 static void create_big_complete(struct hci_dev *hdev, void *data, int err)
@@ -7242,8 +7254,11 @@ static int hci_le_big_create_sync(struct hci_dev *hdev, void *data)
 
 int hci_connect_big_sync(struct hci_dev *hdev, struct hci_conn *conn)
 {
-	return hci_cmd_sync_queue_once(hdev, hci_le_big_create_sync, conn,
-				       create_big_complete);
+	int err;
+
+	err = hci_cmd_sync_queue_once(hdev, hci_le_big_create_sync, conn,
+				      create_big_complete);
+	return (err == -EEXIST) ? 0 : err;
 }
 
 struct past_data {
@@ -7335,7 +7350,7 @@ int hci_past_sync(struct hci_conn *conn, struct hci_conn *le)
 	if (err)
 		kfree(data);
 
-	return err;
+	return (err == -EEXIST) ? 0 : err;
 }
 
 static void le_read_features_complete(struct hci_dev *hdev, void *data, int err)
@@ -7422,7 +7437,7 @@ int hci_le_read_remote_features(struct hci_conn *conn)
 	else
 		err = -EOPNOTSUPP;
 
-	return err;
+	return (err == -EEXIST) ? 0 : err;
 }
 
 static void pkt_type_changed(struct hci_dev *hdev, void *data, int err)
@@ -7448,6 +7463,7 @@ int hci_acl_change_pkt_type(struct hci_conn *conn, u16 pkt_type)
 {
 	struct hci_dev *hdev = conn->hdev;
 	struct hci_cp_change_conn_ptype *cp;
+	int err;
 
 	cp = kmalloc(sizeof(*cp), GFP_KERNEL);
 	if (!cp)
@@ -7456,8 +7472,9 @@ int hci_acl_change_pkt_type(struct hci_conn *conn, u16 pkt_type)
 	cp->handle = cpu_to_le16(conn->handle);
 	cp->pkt_type = cpu_to_le16(pkt_type);
 
-	return hci_cmd_sync_queue_once(hdev, hci_change_conn_ptype_sync, cp,
-				       pkt_type_changed);
+	err = hci_cmd_sync_queue_once(hdev, hci_change_conn_ptype_sync, cp,
+				      pkt_type_changed);
+	return (err == -EEXIST) ? 0 : err;
 }
 
 static void le_phy_update_complete(struct hci_dev *hdev, void *data, int err)
@@ -7483,6 +7500,7 @@ int hci_le_set_phy(struct hci_conn *conn, u8 tx_phys, u8 rx_phys)
 {
 	struct hci_dev *hdev = conn->hdev;
 	struct hci_cp_le_set_phy *cp;
+	int err;
 
 	cp = kmalloc(sizeof(*cp), GFP_KERNEL);
 	if (!cp)
@@ -7493,6 +7511,7 @@ int hci_le_set_phy(struct hci_conn *conn, u8 tx_phys, u8 rx_phys)
 	cp->tx_phys = tx_phys;
 	cp->rx_phys = rx_phys;
 
-	return hci_cmd_sync_queue_once(hdev, hci_le_set_phy_sync, cp,
-				       le_phy_update_complete);
+	err = hci_cmd_sync_queue_once(hdev, hci_le_set_phy_sync, cp,
+				      le_phy_update_complete);
+	return (err == -EEXIST) ? 0 : err;
 }
-- 
2.53.0



