Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80725483831;
	Mon, 31 Aug 2026 14:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184844; cv=none; b=FglowkIqD8D/J5TghnSEXuqqY6f0wVJjhJhCVcC3LZgaP7mxXVMyht7v2t1jPYVs6UcDwjKSWy/uzD2Cw2+Mf29Qt+twvCjpbgUD9GfLEeSRTK6w2lcvS5M1mvZNCxDfk7mHtybRw4MIWom01eQbAa7phOy5hXuHOOMCvCmk/iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184844; c=relaxed/simple;
	bh=1dknV0SduY7jVKQE3Zz7e45o1/ArJxwVkOXGjRDi2+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elRpXPQ+ChF7IkkRm/nDuTQ1+bTuvr3w/omoh+1Ar5aoedvt56D623LHHhXeFH+Lr6AbNDIInM0MbnaKnoD+OPSGrLAR1+d1IoUeCIvS8/lfrIJzjkMkSxCpJikW3j9wdLIRmNXo3a3s6RlN7pY5FjzhOjY3iZWo/mj90sx6VMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5idmGC7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5idmGC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E371F000E9;
	Mon, 31 Aug 2026 14:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184843;
	bh=10Y9Bb7UeL2DlYJLmj3S9PKDSLvF0LN8r9vxtvq3phM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5idmGC7x88J57mRUStA9tlMxMVk1az7s25ww3Y+Kq8A+ajxEK41LGDNrQ6rhKEX/
	 KHFW8EIFsIB+zn0x7DXtgvwKnfu1kn6eeyHPqLfy1zy57YR1lWcwkA3xdfCK0ZME+C
	 2+mLk2hMYQYXOg+Xseg0NZ+OyHlNy/TfqIDLl1JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 56/92] Bluetooth: hci_sync: Fix accept list UAF during suspend
Date: Mon, 31 Aug 2026 15:34:54 +0200
Message-ID: <20260831133402.622156418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit f57b399c4fa1501b2d5451f52d861ece86bcf3db ]

hci_update_event_filter_sync() walks hdev->accept_list while sending a
synchronous HCI command for each remote-wakeup device.  The suspend path
holds hdev->req_lock, but accept-list updates are serialized by hdev->lock.
Consequently, remove_device() can free the current list entry during the
controller wait.

The following interleaving causes the use-after-free:

  hci_update_event_filter_sync()    remove_device()
  fetch accept-list entry
  hci_set_event_filter_sync()
    wait for controller response    hci_dev_lock()
                                    list_del()
                                    kfree()
                                    hci_dev_unlock()
  read the freed list.next

KASAN reported:

  BUG: KASAN: slab-use-after-free in hci_suspend_sync+0x835/0x910
  Read of size 8 at addr ffff88810bec8440 by task kworker/0:1/10
  Workqueue: events vhci_suspend_work
  Call Trace:
   hci_suspend_sync+0x835/0x910
   hci_suspend_dev+0x182/0x450
   process_one_work+0x661/0x1090
   worker_thread+0x45b/0xd10

  Allocated by task 86:
   hci_bdaddr_list_add_with_flags+0x1a8/0x400
   add_device+0x381/0x820
   hci_sock_sendmsg+0x1033/0x1ea0

  Freed by task 91:
   kfree+0x131/0x3c0
   remove_device+0x429/0xb70
   hci_sock_sendmsg+0x1033/0x1ea0

Snapshot the remote-wakeup addresses under hdev->lock.  Release the lock
before sending HCI commands.  Clear the controller event filter before
building the snapshot, and skip allocation and the second list traversal
when there are no matching entries.  This preserves the original filter
and scan-state updates without retaining an accept-list node across a
controller wait.

Fixes: 182ee45da083 ("Bluetooth: hci_sync: Rework hci_suspend_notifier")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-bluetooth/20260730092331.2069741-1-nicoyip.dev@gmail.com/
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |   50 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 11 deletions(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6011,6 +6011,8 @@ static int hci_pause_discovery_sync(stru
 static int hci_update_event_filter_sync(struct hci_dev *hdev)
 {
 	struct bdaddr_list_with_flags *b;
+	bdaddr_t *accept_list;
+	size_t i, num_entries = 0;
 	u8 scan = SCAN_DISABLED;
 	bool scanning = test_bit(HCI_PSCAN, &hdev->flags);
 	int err;
@@ -6027,23 +6029,49 @@ static int hci_update_event_filter_sync(
 	/* Always clear event filter when starting */
 	hci_clear_event_filter_sync(hdev);
 
-	list_for_each_entry(b, &hdev->accept_list, list) {
-		if (!(b->flags & HCI_CONN_FLAG_REMOTE_WAKEUP))
-			continue;
-
-		bt_dev_dbg(hdev, "Adding event filters for %pMR", &b->bdaddr);
-
-		err =  hci_set_event_filter_sync(hdev, HCI_FLT_CONN_SETUP,
-						 HCI_CONN_SETUP_ALLOW_BDADDR,
-						 &b->bdaddr,
-						 HCI_CONN_SETUP_AUTO_ON);
+	hci_dev_lock(hdev);
+
+	list_for_each_entry(b, &hdev->accept_list, list)
+		if (b->flags & HCI_CONN_FLAG_REMOTE_WAKEUP)
+			num_entries++;
+
+	if (!num_entries) {
+		hci_dev_unlock(hdev);
+		goto update_scan;
+	}
+
+	accept_list = kmalloc_array(num_entries, sizeof(*accept_list),
+				    GFP_KERNEL);
+	if (!accept_list) {
+		hci_dev_unlock(hdev);
+		return -ENOMEM;
+	}
+
+	i = 0;
+	list_for_each_entry(b, &hdev->accept_list, list)
+		if (b->flags & HCI_CONN_FLAG_REMOTE_WAKEUP)
+			bacpy(&accept_list[i++], &b->bdaddr);
+
+	hci_dev_unlock(hdev);
+
+	for (i = 0; i < num_entries; i++) {
+		bt_dev_dbg(hdev, "Adding event filters for %pMR",
+			   &accept_list[i]);
+
+		err = hci_set_event_filter_sync(hdev, HCI_FLT_CONN_SETUP,
+						HCI_CONN_SETUP_ALLOW_BDADDR,
+					 &accept_list[i],
+					 HCI_CONN_SETUP_AUTO_ON);
 		if (err)
 			bt_dev_err(hdev, "Failed to set event filter for %pMR",
-				   &b->bdaddr);
+				   &accept_list[i]);
 		else
 			scan = SCAN_PAGE;
 	}
 
+	kfree(accept_list);
+
+update_scan:
 	if (scan && !scanning)
 		hci_write_scan_enable_sync(hdev, scan);
 	else if (!scan && scanning)


