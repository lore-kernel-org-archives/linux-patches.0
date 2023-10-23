Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C091B14263
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vzXeGRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBDAC433CC;
	Mon, 23 Oct 2023 11:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059363;
	bh=l2Ke88IK5zoub5QncbR8AK8z5fy+V8/XiklX61Ix9AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vzXeGRnw+7eNaVxFhvGE8lWeP55fO1W1a3GwmirERn1DDmnVBpNUMuGdUBV8P+3P
	 2e1vF0Gv0Fs+9AksB07Dm4jv56sufVfOI4DvHeNkvY83MNXMYBKzsGoCNQOt45c90U
	 RL4Jcvmy54LwZbFgICusTvdreQ8yPAusmhnbEdOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 145/241] Bluetooth: hci_sync: Introduce PTR_UINT/UINT_PTR macros
Date: Mon, 23 Oct 2023 12:55:31 +0200
Message-ID: <20231023104837.406502947@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit a1f6c3aef13c9e7f8d459bd464e9e34da1342c0c ]

This introduces PTR_UINT/UINT_PTR macros and replace the use of
PTR_ERR/ERR_PTR.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: acab8ff29a2a ("Bluetooth: ISO: Fix invalid context error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_sync.h |  3 +++
 net/bluetooth/hci_conn.c         | 19 ++++++++++---------
 net/bluetooth/hci_sync.c         |  4 ++--
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index b516a0f4a55b8..57eeb07aeb251 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -5,6 +5,9 @@
  * Copyright (C) 2021 Intel Corporation
  */
 
+#define UINT_PTR(_handle)		((void *)((uintptr_t)_handle))
+#define PTR_UINT(_ptr)			((uintptr_t)((void *)_ptr))
+
 typedef int (*hci_cmd_sync_work_func_t)(struct hci_dev *hdev, void *data);
 typedef void (*hci_cmd_sync_work_destroy_t)(struct hci_dev *hdev, void *data,
 					    int err);
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 4e9654fe89c9e..6d6192f514d0f 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -874,7 +874,7 @@ static void bis_cleanup(struct hci_conn *conn)
 
 static int remove_cig_sync(struct hci_dev *hdev, void *data)
 {
-	u8 handle = PTR_ERR(data);
+	u8 handle = PTR_UINT(data);
 
 	return hci_le_remove_cig_sync(hdev, handle);
 }
@@ -883,7 +883,8 @@ static int hci_le_remove_cig(struct hci_dev *hdev, u8 handle)
 {
 	bt_dev_dbg(hdev, "handle 0x%2.2x", handle);
 
-	return hci_cmd_sync_queue(hdev, remove_cig_sync, ERR_PTR(handle), NULL);
+	return hci_cmd_sync_queue(hdev, remove_cig_sync, UINT_PTR(handle),
+				  NULL);
 }
 
 static void find_cis(struct hci_conn *conn, void *data)
@@ -1278,7 +1279,7 @@ u8 hci_conn_set_handle(struct hci_conn *conn, u16 handle)
 static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 {
 	struct hci_conn *conn;
-	u16 handle = PTR_ERR(data);
+	u16 handle = PTR_UINT(data);
 
 	conn = hci_conn_hash_lookup_handle(hdev, handle);
 	if (!conn)
@@ -1308,7 +1309,7 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 static int hci_connect_le_sync(struct hci_dev *hdev, void *data)
 {
 	struct hci_conn *conn;
-	u16 handle = PTR_ERR(data);
+	u16 handle = PTR_UINT(data);
 
 	conn = hci_conn_hash_lookup_handle(hdev, handle);
 	if (!conn)
@@ -1390,7 +1391,7 @@ struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
 	clear_bit(HCI_CONN_SCANNING, &conn->flags);
 
 	err = hci_cmd_sync_queue(hdev, hci_connect_le_sync,
-				 ERR_PTR(conn->handle),
+				 UINT_PTR(conn->handle),
 				 create_le_conn_complete);
 	if (err) {
 		hci_conn_del(conn);
@@ -1767,7 +1768,7 @@ static int hci_le_create_big(struct hci_conn *conn, struct bt_iso_qos *qos)
 
 static int set_cig_params_sync(struct hci_dev *hdev, void *data)
 {
-	u8 cig_id = PTR_ERR(data);
+	u8 cig_id = PTR_UINT(data);
 	struct hci_conn *conn;
 	struct bt_iso_qos *qos;
 	struct iso_cig_params pdu;
@@ -1877,7 +1878,7 @@ static bool hci_le_set_cig_params(struct hci_conn *conn, struct bt_iso_qos *qos)
 
 done:
 	if (hci_cmd_sync_queue(hdev, set_cig_params_sync,
-			       ERR_PTR(qos->ucast.cig), NULL) < 0)
+			       UINT_PTR(qos->ucast.cig), NULL) < 0)
 		return false;
 
 	return true;
@@ -2891,7 +2892,7 @@ u32 hci_conn_get_phy(struct hci_conn *conn)
 static int abort_conn_sync(struct hci_dev *hdev, void *data)
 {
 	struct hci_conn *conn;
-	u16 handle = PTR_ERR(data);
+	u16 handle = PTR_UINT(data);
 
 	conn = hci_conn_hash_lookup_handle(hdev, handle);
 	if (!conn)
@@ -2931,6 +2932,6 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
 		}
 	}
 
-	return hci_cmd_sync_queue(hdev, abort_conn_sync, ERR_PTR(conn->handle),
+	return hci_cmd_sync_queue(hdev, abort_conn_sync, UINT_PTR(conn->handle),
 				  NULL);
 }
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index caf4263ef9b77..73cdd051dd464 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6545,7 +6545,7 @@ int hci_get_random_address(struct hci_dev *hdev, bool require_privacy,
 
 static int _update_adv_data_sync(struct hci_dev *hdev, void *data)
 {
-	u8 instance = PTR_ERR(data);
+	u8 instance = PTR_UINT(data);
 
 	return hci_update_adv_data_sync(hdev, instance);
 }
@@ -6553,5 +6553,5 @@ static int _update_adv_data_sync(struct hci_dev *hdev, void *data)
 int hci_update_adv_data(struct hci_dev *hdev, u8 instance)
 {
 	return hci_cmd_sync_queue(hdev, _update_adv_data_sync,
-				  ERR_PTR(instance), NULL);
+				  UINT_PTR(instance), NULL);
 }
-- 
2.40.1



