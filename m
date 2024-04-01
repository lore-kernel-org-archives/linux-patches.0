Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2208D1CA8F;
	Mon,  1 Apr 2024 16:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987613; cv=none; b=R1CeBFVvxyxBWET7BQhDlhTqvTy2PpJjx9yZoINKFwm/ioKnG3iePsodwmtBn62t68+qqQ8QcKietZNIoFhterOLoK8OTgCniSctOgEY1c5Kizs2EzcOxHaYDLfuPJkwcUBPIMctGbxBE2xtq19GGDwWAa28/ORvx3eV3Jwb+ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987613; c=relaxed/simple;
	bh=xoysuxUgTmLB3evs2CQ4pufXVMJ9hLumCcDs1HiFUiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxKDx+CG2czeiDNmAmidrUu22O2KZWQHgEO8iPM2ffHAYKmG3WyJPXnoBYqecKP7TIvCjnsOCkFjBWvos3Rdlpqk/TfWnZv/YDBBlxuDHgwQiM4mvYjCbwKc2SZgfaIrDDJ0lHxs87AWfOiPYv/AEfsr61jOHuFVbkY3SBzegY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpdgC9e1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpdgC9e1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89548C433F1;
	Mon,  1 Apr 2024 16:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987613;
	bh=xoysuxUgTmLB3evs2CQ4pufXVMJ9hLumCcDs1HiFUiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpdgC9e1F6esRPDGF9Ax6XdKwsQIIGCdwQ2stpwOO3eIJCMKTvc7JjcQvo52EmTAX
	 jBvhjk+VUjQZSFaQI46ACxPObGOqjLBD2egzrHK7vCvdk+HZpAKsp/aSQ0vdHwXP96
	 X+cIyOlKmukFoTAI7SS2Byl74cMjBmVpz4FehPN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Thorsten Leemhuis <linux@leemhuis.info>
Subject: [PATCH 6.8 340/399] Bluetooth: hci_sync: Fix not checking error on hci_cmd_sync_cancel_sync
Date: Mon,  1 Apr 2024 17:45:06 +0200
Message-ID: <20240401152559.323999025@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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
@@ -611,7 +611,10 @@ void hci_cmd_sync_cancel_sync(struct hci
 	bt_dev_dbg(hdev, "err 0x%2.2x", err);
 
 	if (hdev->req_status == HCI_REQ_PEND) {
-		hdev->req_result = err;
+		/* req_result is __u32 so error must be positive to be properly
+		 * propagated.
+		 */
+		hdev->req_result = err < 0 ? -err : err;
 		hdev->req_status = HCI_REQ_CANCELED;
 
 		wake_up_interruptible(&hdev->req_wait_q);


