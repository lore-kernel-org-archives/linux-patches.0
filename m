Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4AE4F68B6;
	Tue, 13 Oct 2026 12:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893273; cv=none; b=Bp8y/F07RTGmJybLmwuGCd8LUyGrKbyKAIoY7SGPyvsq3NiRCDbGLBXicC/5U+ry/aT7rfq75m9xvXl+ceMcKxkKK1gpAACmUDM5Yi+cqLcNELJtmc/G5Pu+2kfQMP/mndMzUtfn1YGhujsZk239HqAoyDt8c2ZgxJsR5iUB9B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893273; c=relaxed/simple;
	bh=bExqGZ4D/X8Yr4Koef4C/kKnoS6qSLXGyuQ8vx54qbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4f7bA79P9SgKwb/lvBOutcDnv7JUH60uYmumJOr982CpvmWgWKMaftAtvnWQXtsMl7GAMEuldycIHS60vlzRPPaO3mC3xjrSmOJluViPHYARqOf0DrNgxgZCIbidCb1Lf9bVQr2GyRkxiJJdnlD6O/msFH0QuI7ZhHH8TkPh0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8UhAjCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8UhAjCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F5F1F000FF;
	Tue, 13 Oct 2026 12:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893270;
	bh=+xWLkBcbQTQTfoUcGwqDjW9n7NEyUz8iaQZh8PYbTT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8UhAjCC46LMDDJjOrEll6/3b4mhZLFulLOpVLqfQCePS3E0OCqeExFuCcOngMOrH
	 yQ1u04SqLLSNF/e7LmDLzwQBoWET+9CUXokkTkRcza/JLZhg/s5scHrToc+rFrjVG0
	 qnGvaSymR2x3B3+fS9saQjjft1jGwnUJqtVxs2Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 171/621] Bluetooth: hci_sync: hci_cmd_sync_queue_once() return -EEXIST if exists
Date: Tue, 13 Oct 2026 13:32:46 +0200
Message-ID: <20261013112924.922555658@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5abbf3112f848..961c3edb33e67 100644
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
@@ -3390,6 +3390,8 @@ static int update_passive_scan_sync(struct hci_dev *hdev, void *data)
 
 int hci_update_passive_scan(struct hci_dev *hdev)
 {
+	int err;
+
 	/* Only queue if it would have any effect */
 	if (!test_bit(HCI_UP, &hdev->flags) ||
 	    test_bit(HCI_INIT, &hdev->flags) ||
@@ -3399,8 +3401,9 @@ int hci_update_passive_scan(struct hci_dev *hdev)
 	    hci_dev_test_flag(hdev, HCI_UNREGISTER))
 		return 0;
 
-	return hci_cmd_sync_queue_once(hdev, update_passive_scan_sync, NULL,
-				       NULL);
+	err = hci_cmd_sync_queue_once(hdev, update_passive_scan_sync, NULL,
+				      NULL);
+	return (err == -EEXIST) ? 0 : err;
 }
 
 int hci_write_sc_support_sync(struct hci_dev *hdev, u8 val)
@@ -7139,8 +7142,11 @@ static int hci_acl_create_conn_sync(struct hci_dev *hdev, void *data)
 
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
@@ -7176,8 +7182,11 @@ static void create_le_conn_complete(struct hci_dev *hdev, void *data, int err)
 
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
@@ -7410,8 +7419,11 @@ static int hci_le_pa_create_sync(struct hci_dev *hdev, void *data)
 
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
@@ -7474,6 +7486,9 @@ static int hci_le_big_create_sync(struct hci_dev *hdev, void *data)
 
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



