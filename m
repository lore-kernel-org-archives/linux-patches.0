Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B224F4036;
	Tue, 13 Oct 2026 12:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893077; cv=none; b=sUiRpB9V3eT0MbJtGX6hLGmxWXyIRmjGr9T7NaSSRYn2Ax1XDtEYT1lZ3e3GO2cRC2xf/M3ykTkqDOY+qAlrroDgQqVrJrjoczxeYhRmWQ4iDgz9t8HZIK/Nct9I6u+t/Ggh2wI12b+F8RKo3Yo5Uxr6MlIMjIAhoRl+zce/rX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893077; c=relaxed/simple;
	bh=JAq2YddQYVCgG/15i+bj4pWbITKOneV2iqjoXX2jp0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8TZnYe9kpSabJhwpxT84t7gJBbhbRkr9eUny5+2P23Bya3Uew/yGTn32xwlrei6Mh9kXDqR9CjzaAB6IZaAfhMGksXakMUIgPr3VyzKO06lXjvUKiGw+XUzQj3vMvzRvLZbZLfURJBCk4O+kbcCoqc6P9kmC/9BHTsByiiJd+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MDNwEcw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MDNwEcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76761F000FF;
	Tue, 13 Oct 2026 12:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893076;
	bh=C9LhhXR8Ca/Isz/oOCnEkktu6aKzcCT0kyMIkrTPbWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2MDNwEcwUJK7W1iiRSYVokmLFaH1HIYEpjlQyFIFNcoqxootgvcz8Cs5qsiUIwbKh
	 qt/+g2mBppCeRqsZJdjWliNh0820INWCbq+lEu05U77Atr7Ab3KWyzooBlhMmvsGI5
	 4wqikFFtMiHRhRd1BJta3EnEevLDdK1Lzb7Qu7js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 103/621] Bluetooth: hci_sync: Fix command skb lifetime during scan setup
Date: Tue, 13 Oct 2026 13:31:38 +0200
Message-ID: <20261013112923.294133426@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 9af12272061d206af8bc3e40215cb694421ab73a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    4 ++++
 net/bluetooth/hci_sync.c |   10 +++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4152,9 +4152,11 @@ static int hci_send_cmd_sync(struct hci_
 
 	bt_dev_dbg(hdev, "skb %p", skb);
 
+	hci_dev_lock(hdev);
 	kfree_skb(hdev->sent_cmd);
 
 	hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
+	hci_dev_unlock(hdev);
 	if (!hdev->sent_cmd) {
 		skb_queue_head(&hdev->cmd_q, skb);
 		queue_work(hdev->workqueue, &hdev->cmd_work);
@@ -4175,8 +4177,10 @@ static int hci_send_cmd_sync(struct hci_
 
 	if (READ_ONCE(hdev->req_status) == HCI_REQ_PEND &&
 	    !hci_dev_test_and_set_flag(hdev, HCI_CMD_PENDING)) {
+		hci_dev_lock(hdev);
 		kfree_skb(hdev->req_skb);
 		hdev->req_skb = skb_get(hdev->sent_cmd);
+		hci_dev_unlock(hdev);
 	}
 
 	return err;
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -32,8 +32,10 @@ static void hci_cmd_sync_complete(struct
 	WRITE_ONCE(hdev->req_status, HCI_REQ_DONE);
 
 	/* Free the request command so it is not used as response */
+	hci_dev_lock(hdev);
 	kfree_skb(hdev->req_skb);
 	hdev->req_skb = NULL;
+	hci_dev_unlock(hdev);
 
 	if (skb) {
 		struct sock *sk = hci_skb_sk(skb);
@@ -3055,15 +3057,21 @@ static int hci_le_set_ext_scan_param_syn
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
 
 			rcu_read_lock();
 
 			conn = hci_conn_hash_lookup_ba(hdev, PA_LINK,
-						       &sent->bdaddr);
+						       &bdaddr);
 			if (conn) {
 				struct bt_iso_qos *qos = &conn->iso_qos;
 


