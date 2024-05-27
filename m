Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF5C17727;
	Mon, 27 May 2024 19:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838300; cv=none; b=HkuV4UsQppy6HyfapFaCBIBEFFayK1X4GAe7JRqcjssnYlpZl4xx0jmB/0/hSrkNS7aDlpv6I76Pntf2t6Iu8cl7GLXReHLRUkbfr5AiXl+ekTosWEZCdX2YX9lBuADDqpkfuHNRCHbdl0cBjCQY1jWsyYz8tl6q6wO+7D+bK0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838300; c=relaxed/simple;
	bh=+k9AcAwmM43PqOZrRz0rEqlgM5Jken0OZ8IbSXnse4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etWEY4ghgzrN8pZK7sFAbyY9wcfPw726e2aMhfCjaP/VAYJRULfoDsVK9KZFkGpoyEjosTneQebwzeMk0A9AwZZ9bfVmo3GpxB0uHaFxxByCE7J5DulMy4axokp25QLWnOnKp/QXVNtIBCmvifVuVzyDquuupPAmvUlskyUcIUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6Msecj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6Msecj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52ECC2BBFC;
	Mon, 27 May 2024 19:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838300;
	bh=+k9AcAwmM43PqOZrRz0rEqlgM5Jken0OZ8IbSXnse4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6Msecj009mBGgZ6iMhYOa1ogtutT1kWr5fV6PG9Z0RJOGGzZ5HmNH5AtMBS3J3kO
	 b+5jjlcxZtOKdyRVGdAZQNNtttYlwD0kFLJIi57YH/RUuMLB0uQP8ZYhOz0l1LpUPu
	 MdUzc56NpM17mVh0FFJg+GFLiy1i18ZrDr44CcVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 339/493] Bluetooth: ISO: Add hcon for listening bis sk
Date: Mon, 27 May 2024 20:55:41 +0200
Message-ID: <20240527185641.367991929@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iulia Tanasescu <iulia.tanasescu@nxp.com>

[ Upstream commit 02171da6e86a73e1b343b36722f5d9d5c04b3539 ]

This creates a hcon instance at bis listen, before the PA sync
procedure is started.

Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: a5b862c6a221 ("Bluetooth: L2CAP: Fix div-by-zero in l2cap_le_flowctl_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  6 ++---
 net/bluetooth/hci_conn.c         | 32 ++++++++++++++++++++-----
 net/bluetooth/iso.c              | 41 ++++++++++++++++++++++++--------
 3 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 8504e10f51700..b1c8489ff93e4 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1,7 +1,7 @@
 /*
    BlueZ - Bluetooth protocol stack for Linux
    Copyright (c) 2000-2001, 2010, Code Aurora Forum. All rights reserved.
-   Copyright 2023 NXP
+   Copyright 2023-2024 NXP
 
    Written 2000,2001 by Maxim Krasnyansky <maxk@qualcomm.com>
 
@@ -1533,8 +1533,8 @@ struct hci_conn *hci_connect_cis(struct hci_dev *hdev, bdaddr_t *dst,
 struct hci_conn *hci_connect_bis(struct hci_dev *hdev, bdaddr_t *dst,
 				 __u8 dst_type, struct bt_iso_qos *qos,
 				 __u8 data_len, __u8 *data);
-int hci_pa_create_sync(struct hci_dev *hdev, bdaddr_t *dst, __u8 dst_type,
-		       __u8 sid, struct bt_iso_qos *qos);
+struct hci_conn *hci_pa_create_sync(struct hci_dev *hdev, bdaddr_t *dst,
+		       __u8 dst_type, __u8 sid, struct bt_iso_qos *qos);
 int hci_le_big_create_sync(struct hci_dev *hdev, struct hci_conn *hcon,
 			   struct bt_iso_qos *qos,
 			   __u16 sync_handle, __u8 num_bis, __u8 bis[]);
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 9a369bc14fd57..0a80fd6257c65 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1,7 +1,7 @@
 /*
    BlueZ - Bluetooth protocol stack for Linux
    Copyright (c) 2000-2001, 2010, Code Aurora Forum. All rights reserved.
-   Copyright 2023 NXP
+   Copyright 2023-2024 NXP
 
    Written 2000,2001 by Maxim Krasnyansky <maxk@qualcomm.com>
 
@@ -2086,18 +2086,31 @@ static int create_pa_sync(struct hci_dev *hdev, void *data)
 	return hci_update_passive_scan_sync(hdev);
 }
 
-int hci_pa_create_sync(struct hci_dev *hdev, bdaddr_t *dst, __u8 dst_type,
-		       __u8 sid, struct bt_iso_qos *qos)
+struct hci_conn *hci_pa_create_sync(struct hci_dev *hdev, bdaddr_t *dst,
+				    __u8 dst_type, __u8 sid,
+				    struct bt_iso_qos *qos)
 {
 	struct hci_cp_le_pa_create_sync *cp;
+	struct hci_conn *conn;
+	int err;
 
 	if (hci_dev_test_and_set_flag(hdev, HCI_PA_SYNC))
-		return -EBUSY;
+		return ERR_PTR(-EBUSY);
+
+	conn = hci_conn_add_unset(hdev, ISO_LINK, dst, HCI_ROLE_SLAVE);
+	if (!conn)
+		return ERR_PTR(-ENOMEM);
+
+	conn->iso_qos = *qos;
+	conn->state = BT_LISTEN;
+
+	hci_conn_hold(conn);
 
 	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
 	if (!cp) {
 		hci_dev_clear_flag(hdev, HCI_PA_SYNC);
-		return -ENOMEM;
+		hci_conn_drop(conn);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	cp->options = qos->bcast.options;
@@ -2109,7 +2122,14 @@ int hci_pa_create_sync(struct hci_dev *hdev, bdaddr_t *dst, __u8 dst_type,
 	cp->sync_cte_type = qos->bcast.sync_cte_type;
 
 	/* Queue start pa_create_sync and scan */
-	return hci_cmd_sync_queue(hdev, create_pa_sync, cp, create_pa_complete);
+	err = hci_cmd_sync_queue(hdev, create_pa_sync, cp, create_pa_complete);
+	if (err < 0) {
+		hci_conn_drop(conn);
+		kfree(cp);
+		return ERR_PTR(err);
+	}
+
+	return conn;
 }
 
 int hci_le_big_create_sync(struct hci_dev *hdev, struct hci_conn *hcon,
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 6d217df75c62c..71a484269fc4f 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -3,7 +3,7 @@
  * BlueZ - Bluetooth protocol stack for Linux
  *
  * Copyright (C) 2022 Intel Corporation
- * Copyright 2023 NXP
+ * Copyright 2023-2024 NXP
  */
 
 #include <linux/module.h>
@@ -690,11 +690,8 @@ static void iso_sock_cleanup_listen(struct sock *parent)
 		iso_sock_kill(sk);
 	}
 
-	/* If listening socket stands for a PA sync connection,
-	 * properly disconnect the hcon and socket.
-	 */
-	if (iso_pi(parent)->conn && iso_pi(parent)->conn->hcon &&
-	    test_bit(HCI_CONN_PA_SYNC, &iso_pi(parent)->conn->hcon->flags)) {
+	/* If listening socket has a hcon, properly disconnect it */
+	if (iso_pi(parent)->conn && iso_pi(parent)->conn->hcon) {
 		iso_sock_disconn(parent);
 		return;
 	}
@@ -1076,6 +1073,8 @@ static int iso_listen_bis(struct sock *sk)
 {
 	struct hci_dev *hdev;
 	int err = 0;
+	struct iso_conn *conn;
+	struct hci_conn *hcon;
 
 	BT_DBG("%pMR -> %pMR (SID 0x%2.2x)", &iso_pi(sk)->src,
 	       &iso_pi(sk)->dst, iso_pi(sk)->bc_sid);
@@ -1096,18 +1095,40 @@ static int iso_listen_bis(struct sock *sk)
 	if (!hdev)
 		return -EHOSTUNREACH;
 
+	hci_dev_lock(hdev);
+
 	/* Fail if user set invalid QoS */
 	if (iso_pi(sk)->qos_user_set && !check_bcast_qos(&iso_pi(sk)->qos)) {
 		iso_pi(sk)->qos = default_qos;
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock;
 	}
 
-	err = hci_pa_create_sync(hdev, &iso_pi(sk)->dst,
-				 le_addr_type(iso_pi(sk)->dst_type),
-				 iso_pi(sk)->bc_sid, &iso_pi(sk)->qos);
+	hcon = hci_pa_create_sync(hdev, &iso_pi(sk)->dst,
+				  le_addr_type(iso_pi(sk)->dst_type),
+				  iso_pi(sk)->bc_sid, &iso_pi(sk)->qos);
+	if (IS_ERR(hcon)) {
+		err = PTR_ERR(hcon);
+		goto unlock;
+	}
+
+	conn = iso_conn_add(hcon);
+	if (!conn) {
+		hci_conn_drop(hcon);
+		err = -ENOMEM;
+		goto unlock;
+	}
+
+	err = iso_chan_add(conn, sk, NULL);
+	if (err) {
+		hci_conn_drop(hcon);
+		goto unlock;
+	}
 
 	hci_dev_put(hdev);
 
+unlock:
+	hci_dev_unlock(hdev);
 	return err;
 }
 
-- 
2.43.0



