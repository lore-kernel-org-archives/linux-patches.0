Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F4E18C05
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awjl0iWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751FDC433C7;
	Mon,  9 Oct 2023 13:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857004;
	bh=7GRgdodDZqDn6YqUhws/BKt+MLOkTW56kt29RM8HrRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awjl0iWb04dq6YZvhcibLjh/5RDUsv+hajQJYH1W47cOx9FjqROxF0AvT4+03Za9c
	 XBSUbymzscN1xBDNhc8C1DoKwnUdl0zEt+AkksLeSCcJf6l4IKFRVN+v00Ukr7bVWC
	 Gz+3JcgO4XfMBgmhBQgM0ekgg0sxk2Wf9wI+pDWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.5 037/163] Bluetooth: hci_sync: Fix handling of HCI_QUIRK_STRICT_DUPLICATE_FILTER
Date: Mon,  9 Oct 2023 15:00:01 +0200
Message-ID: <20231009130125.029041020@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

commit 941c998b42f5c90384f49da89a6e11233de567cf upstream.

When HCI_QUIRK_STRICT_DUPLICATE_FILTER is set LE scanning requires
periodic restarts of the scanning procedure as the controller would
consider device previously found as duplicated despite of RSSI changes,
but in order to set the scan timeout properly set le_scan_restart needs
to be synchronous so it shall not use hci_cmd_sync_queue which defers
the command processing to cmd_sync_work.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-bluetooth/578e6d7afd676129decafba846a933f5@agner.ch/#t
Fixes: 27d54b778ad1 ("Bluetooth: Rework le_scan_restart for hci_sync")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -412,11 +412,6 @@ static int hci_le_scan_restart_sync(stru
 					   LE_SCAN_FILTER_DUP_ENABLE);
 }
 
-static int le_scan_restart_sync(struct hci_dev *hdev, void *data)
-{
-	return hci_le_scan_restart_sync(hdev);
-}
-
 static void le_scan_restart(struct work_struct *work)
 {
 	struct hci_dev *hdev = container_of(work, struct hci_dev,
@@ -426,15 +421,15 @@ static void le_scan_restart(struct work_
 
 	bt_dev_dbg(hdev, "");
 
-	hci_dev_lock(hdev);
-
-	status = hci_cmd_sync_queue(hdev, le_scan_restart_sync, NULL, NULL);
+	status = hci_le_scan_restart_sync(hdev);
 	if (status) {
 		bt_dev_err(hdev, "failed to restart LE scan: status %d",
 			   status);
-		goto unlock;
+		return;
 	}
 
+	hci_dev_lock(hdev);
+
 	if (!test_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks) ||
 	    !hdev->discovery.scan_start)
 		goto unlock;


