Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17A13A48E2;
	Sat, 17 Oct 2026 16:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253719; cv=none; b=Rn47zxklqDQc5vd0e/g2GFI90lZz4KiFdzRuxxkfbUoun9xQz51Kb0yse2p0uF5GjhKq6oxgl0NXouoZYWe4rMGp3O8ni7lfCQ2N2r3AEEbEbB1qwOpp1neeVTP3E1spEza4LhD44hlSepytNlFFsvwoFHQMLLOF8kZBc0lZ0Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253719; c=relaxed/simple;
	bh=wnckeSAKHaQler8K7wAm+axuUz8l7BF64Frbo4q4daQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ay8pyejHn/HJiXqRnS9EXvmYPC4BTup6x8PULg1Tim7EWrKkTWadmiaGbtxEJ9K/6nqdujym859VjzChGnwk1Atn5fgHDJdVqPWdEOnRvK8xA6wgJ4SpDBSIXIpOuFXfS9G4zT3+XpLrTxmSdPL6YlLBjgEadhgLQuLRkdKfaPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vi5xSAhg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vi5xSAhg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF9B1F000C6;
	Sat, 17 Oct 2026 16:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253717;
	bh=BTuqf3WYGH9Xgn1XD6E4dBpJzbOnMINswKgi2UXErDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vi5xSAhgktgyK1z1/Z8tAYkYDYaH1sw4zGZTf3KxR+fcOPKAr5Gy3Hr4p1fl9SuTs
	 FBXUuwK6E4jmayL6lYlsEjfOsT2i5XV0oziaNBgeb8oQmSSq9uoq4IPJ/yLRzppQ9O
	 UvHGCIAHDJvOiVYQV/+VFSsmiFYeD+BW11ESg4/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 211/869] Bluetooth: hci_sync: hci_cmd_sync_queue_once() return -EEXIST if exists
Date: Sat, 17 Oct 2026 17:50:52 +0200
Message-ID: <20261017160042.463397518@linuxfoundation.org>
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
 net/bluetooth/hci_sync.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 6d7caf00fc897..b0ab43145e47f 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -794,7 +794,7 @@ int hci_cmd_sync_queue_once(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 			    void *data, hci_cmd_sync_work_destroy_t destroy)
 {
 	if (hci_cmd_sync_lookup_entry(hdev, func, data, destroy))
-		return 0;
+		return -EEXIST;
 
 	return hci_cmd_sync_queue(hdev, func, data, destroy);
 }
@@ -3383,6 +3383,8 @@ static int update_passive_scan_sync(struct hci_dev *hdev, void *data)
 
 int hci_update_passive_scan(struct hci_dev *hdev)
 {
+	int err;
+
 	/* Only queue if it would have any effect */
 	if (!test_bit(HCI_UP, &hdev->flags) ||
 	    test_bit(HCI_INIT, &hdev->flags) ||
@@ -3392,8 +3394,9 @@ int hci_update_passive_scan(struct hci_dev *hdev)
 	    hci_dev_test_flag(hdev, HCI_UNREGISTER))
 		return 0;
 
-	return hci_cmd_sync_queue_once(hdev, update_passive_scan_sync, NULL,
-				       NULL);
+	err = hci_cmd_sync_queue_once(hdev, update_passive_scan_sync, NULL,
+				      NULL);
+	return (err == -EEXIST) ? 0 : err;
 }
 
 int hci_write_sc_support_sync(struct hci_dev *hdev, u8 val)
@@ -7112,8 +7115,11 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 
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
@@ -7149,8 +7155,11 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 
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
@@ -7383,8 +7392,11 @@ static int hci_le_pa_create_sync(struct hci_dev *hdev, void *data)
 
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
@@ -7447,6 +7459,9 @@ static int hci_le_big_create_sync(struct hci_dev *hdev, void *data)
 
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
-- 
2.53.0



