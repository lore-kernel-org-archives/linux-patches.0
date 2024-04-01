Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F3D1E525;
	Mon,  1 Apr 2024 16:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989093; cv=none; b=N6I2tnmsy0XO9Y2sUGsX17fSuIHb7ijeStOS/PpX7T6YW4AUZt1errwOTIh39jJcJp3DFTieCxE8vrrrUsRhSIgHN8kVfM8bqJd2T1Ho/LxoZ2mDzuXRO5CAgQmal5AJZFj1cK67KB3z5aNzS292QbfyNeippOwHUchh0pvQgSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989093; c=relaxed/simple;
	bh=qo60FkVbUFHLVpHxERd/lwDptdEzBuVn46ojPplNs+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=di/i82qcodLBetHXRo8+OSW5kByezsECBIH0X23EM+v+F2oPeAdcGHTMuQlA0FqayjnDvVk9IqDhEQXgfyEnWrkV33mpxlIA1Td1fY6+2KLW0paHwsjWc2Pc85V7QIdupkX2W6pOXS+V6OAXJ+dbPmku5axpm0eZ04Pzk0XwlH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLHHdw7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLHHdw7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8565CC433F1;
	Mon,  1 Apr 2024 16:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989093;
	bh=qo60FkVbUFHLVpHxERd/lwDptdEzBuVn46ojPplNs+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLHHdw7CUmgCSC911ZOgmaLW672aV0ROfaM5+aPXS3To98DdRgxvwkWibfF7/LIFE
	 DEHbywAuq/eKA9f1/kdV78RJSuut7KXDKQaD3m2bJvPaTRTO2oayF3nbJ32Qp5Mx6G
	 npjnT5yYvyHs2iQJhiNYpCv5UMs8rErq33dKSfZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: [PATCH 6.7 378/432] Bluetooth: hci_sync: Fix not checking error on hci_cmd_sync_cancel_sync
Date: Mon,  1 Apr 2024 17:46:05 +0200
Message-ID: <20240401152604.565498206@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 1c3366abdbe884be62e5a7502b4db758aa3974c6 upstream.

hci_cmd_sync_cancel_sync shall check the error passed to it since it
will be propagated using req_result which is __u32 it needs to be
properly set to a positive value if it was passed as negative othertise
IS_ERR will not trigger as -(errno) would be converted to a positive
value.

Fixes: 63298d6e752f ("Bluetooth: hci_core: Cancel request on command timeout")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reported-and-tested-by: Thorsten Leemhuis <linux@leemhuis.info>
Closes: https://lore.kernel.org/all/08275279-7462-4f4a-a0ee-8aa015f829bc@leemhuis.info/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    6 +++---
 net/bluetooth/hci_sync.c |    5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2842,7 +2842,7 @@ static void hci_cancel_cmd_sync(struct h
 	cancel_delayed_work_sync(&hdev->ncmd_timer);
 	atomic_set(&hdev->cmd_cnt, 1);
 
-	hci_cmd_sync_cancel_sync(hdev, -err);
+	hci_cmd_sync_cancel_sync(hdev, err);
 }
 
 /* Suspend HCI device */
@@ -2862,7 +2862,7 @@ int hci_suspend_dev(struct hci_dev *hdev
 		return 0;
 
 	/* Cancel potentially blocking sync operation before suspend */
-	hci_cancel_cmd_sync(hdev, -EHOSTDOWN);
+	hci_cancel_cmd_sync(hdev, EHOSTDOWN);
 
 	hci_req_sync_lock(hdev);
 	ret = hci_suspend_sync(hdev);
@@ -4178,7 +4178,7 @@ static void hci_send_cmd_sync(struct hci
 
 	err = hci_send_frame(hdev, skb);
 	if (err < 0) {
-		hci_cmd_sync_cancel_sync(hdev, err);
+		hci_cmd_sync_cancel_sync(hdev, -err);
 		return;
 	}
 
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -679,7 +679,10 @@ void hci_cmd_sync_cancel_sync(struct hci
 	bt_dev_dbg(hdev, "err 0x%2.2x", err);
 
 	if (hdev->req_status == HCI_REQ_PEND) {
-		hdev->req_result = err;
+		/* req_result is __u32 so error must be positive to be properly
+		 * propagated.
+		 */
+		hdev->req_result = err < 0 ? -err : err;
 		hdev->req_status = HCI_REQ_CANCELED;
 
 		wake_up_interruptible(&hdev->req_wait_q);


