Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEAD22F767;
	Sat, 17 Oct 2026 16:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253285; cv=none; b=RnuUIVzGjiiW3v0xNY0tYDIQoCDq9OHMYTvb6U2dd4M+MJo5MKY0p8xGeRHdUjPHXFMO/d6AMHQdQL2DYChrkcESE8P54OqYMxk+zf5Gld06MgKU4ekTQHyny72iei96dycZgjyqraPJlgKYwWtlPdSdok/XQbV9woMJkjwAENQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253285; c=relaxed/simple;
	bh=Su9TTtUq0m4DHM61ml2Q5q/aTSKwu9kickqYYr+kGCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apK3z+6VBam8pZi2SeOG6nYLJTM+q2IbJ57yqLR8hegJDIBNclgIbAPj5qL+bSg6vIAuVzu+bNfbs8SV6QkDS9u90E6xBNEGJqN1RvhYRGv4zW8mvntu2wj5EUBO/NXtW12lPv3iiWyrt3W6CgVgKApfUlC1FZMFfysXiBLyU/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6GM9vx+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6GM9vx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B77F1F000C4;
	Sat, 17 Oct 2026 16:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253284;
	bh=4/9eZYfaJZ/iXfb6XWLQrigY4EUvzK6OV/Oxog+MYwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z6GM9vx+ZbZiFgzXf3jHRx9qmXGyq4UpIA6moJ5S7lwdgj+BRh7AfF8SbjOR3Eo3j
	 inZ/OEvjzYKRAlcpPeZ+PEAqL9jq0pV2yPhEEClfH65HpSw//cDB5YXq80cTmxtlaT
	 mBdX1s74jHzyYhbYMYZJpRUUZ2gnptCTY4vDRoso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/869] Bluetooth: hci_sync: Fix command skb lifetime during scan setup
Date: Sat, 17 Oct 2026 17:47:46 +0200
Message-ID: <20261017160037.656043919@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit 9af12272061d206af8bc3e40215cb694421ab73a ]

During PA sync scan setup, hci_le_set_ext_scan_param_sync() gets the
address used for the PA_LINK lookup from hci_sent_cmd_data(). The
returned pointer borrows storage from sent_cmd or req_skb, without
holding a reference to either skb.

The scan worker runs on req_workqueue while hci_cmd_work() runs on the
separate device workqueue. After the scan worker loads sent_cmd, the
command worker can free and replace it before hci_sent_cmd_data()
dereferences the skb. The command payload can also be freed between
returning from the helper and comparing the address. The connection
lookup's RCU critical section does not protect the command skb.

KASAN reported:

  BUG: KASAN: slab-use-after-free in hci_sent_cmd_data+0x27c/0x2f0
  Workqueue: hci0 hci_cmd_sync_work
  Call Trace:
   hci_sent_cmd_data+0x27c/0x2f0
   hci_le_set_scan_param_sync+0x43a/0x850
   hci_passive_scan_sync+0xb09/0x1460
   hci_update_passive_scan_sync+0x47c/0x6e0
   hci_le_pa_create_sync+0x200/0xa70
   hci_cmd_sync_work+0x13c/0x290

  Allocated by task 95:
   skb_clone+0x13f/0x340
   hci_cmd_work+0x2a9/0x7e0

  Freed by task 95:
   kmem_cache_free+0xba/0x3a0
   hci_cmd_work+0x29c/0x7e0

Use hdev->lock to serialize the address snapshot with sent_cmd
replacement. Protect req_skb replacement and completion cleanup with
the same lock because the helper falls back to that skb. Copy the
address before releasing the lock and use the copy for the existing
RCU-protected connection lookup. Release the mutex before sending or
waiting for commands, preserving the lookup and completion ordering.

Fixes: 22cbf4f84c00 ("Bluetooth: hci_sync: Use QoS to determine which PHY to scan")
Cc: stable@vger.kernel.org
Assisted-by: GPT-6 Astra
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c |  4 ++++
 net/bluetooth/hci_sync.c | 10 +++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 95900c2325631..ff3ccb33da0c7 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4155,9 +4155,11 @@ static int hci_send_cmd_sync(struct hci_dev *hdev, struct sk_buff *skb)
 
 	bt_dev_dbg(hdev, "skb %p", skb);
 
+	hci_dev_lock(hdev);
 	kfree_skb(hdev->sent_cmd);
 
 	hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
+	hci_dev_unlock(hdev);
 	if (!hdev->sent_cmd) {
 		skb_queue_head(&hdev->cmd_q, skb);
 		queue_work(hdev->workqueue, &hdev->cmd_work);
@@ -4178,8 +4180,10 @@ static int hci_send_cmd_sync(struct hci_dev *hdev, struct sk_buff *skb)
 
 	if (READ_ONCE(hdev->req_status) == HCI_REQ_PEND &&
 	    !hci_dev_test_and_set_flag(hdev, HCI_CMD_PENDING)) {
+		hci_dev_lock(hdev);
 		kfree_skb(hdev->req_skb);
 		hdev->req_skb = skb_get(hdev->sent_cmd);
+		hci_dev_unlock(hdev);
 	}
 
 	return err;
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index f4dea6fffa727..6d7caf00fc897 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -32,8 +32,10 @@ static void hci_cmd_sync_complete(struct hci_dev *hdev, u8 result, u16 opcode,
 	WRITE_ONCE(hdev->req_status, HCI_REQ_DONE);
 
 	/* Free the request command so it is not used as response */
+	hci_dev_lock(hdev);
 	kfree_skb(hdev->req_skb);
 	hdev->req_skb = NULL;
+	hci_dev_unlock(hdev);
 
 	if (skb) {
 		struct sock *sk = hci_skb_sk(skb);
@@ -3058,13 +3060,19 @@ static int hci_le_set_ext_scan_param_sync(struct hci_dev *hdev, u8 type,
 	 */
 	if (hci_dev_test_flag(hdev, HCI_PA_SYNC)) {
 		struct hci_cp_le_add_to_accept_list *sent;
+		bdaddr_t bdaddr;
 
+		hci_dev_lock(hdev);
 		sent = hci_sent_cmd_data(hdev, HCI_OP_LE_ADD_TO_ACCEPT_LIST);
+		if (sent)
+			bacpy(&bdaddr, &sent->bdaddr);
+		hci_dev_unlock(hdev);
+
 		if (sent) {
 			struct hci_conn *conn;
 
 			conn = hci_conn_hash_lookup_ba(hdev, PA_LINK,
-						       &sent->bdaddr);
+						       &bdaddr);
 			if (conn) {
 				struct bt_iso_qos *qos = &conn->iso_qos;
 
-- 
2.53.0



