Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EB23B3C12;
	Mon, 20 Apr 2026 13:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691406; cv=none; b=qV3VmV+4HkAxINJnlb1oZnBl7No0n5zze0ozK7euDZz0VzPbuRdUxD2ml+A1xvaeQkMGa0w3y9exYuYKuwlV6uYH3YWDfQqv1kl+91OnU5Be5FST6fAWtq1btE/kkbZJSqB9vHq+tD8q10jBs+CHdqeTA5s/ls1IGRUpKSetp/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691406; c=relaxed/simple;
	bh=E9cH7PuQ2b5BSKlFNo0n1LqxRO0ZWNDze2FOxEKZVDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFsHyEVG0eHIl3bgG4sm7Kvhf3uB2P76/1EiT/qKR385H180Y2C/KDFRNtuRYxYzyP83FctmIF/mtStamHMAYwVUD2VFy83o4yERw86He7HeKqyEnQ0XzJ8tANrpiqw8F8KfF/YpH1w8OhTrCpq+ikx4y5cKlMI+AOal/g+qQik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/1PwRKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/1PwRKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C23C19425;
	Mon, 20 Apr 2026 13:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691406;
	bh=E9cH7PuQ2b5BSKlFNo0n1LqxRO0ZWNDze2FOxEKZVDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/1PwRKYhLhrnse7bJw/5N30tNRBt91xG5XTHS+VbX9DssUT14s5lVCmh2ajY7QYP
	 hh/qJItPEZ/OHl3iXUxEl4rVqF4M4GY/LxAC0/oMZ3KuH+zNXKDYcPHS/OcuJ8IKk+
	 WFDVLu6sD++Drvb0MjBxwknwnT+gHBKhZLCBu5P+6uGcdvlY1O2+fndNGunK/G+p6r
	 VGDmRQ2whQVpzV9SObIODQrS2GK5DtkVDMLec9Oxf4s/fGYKtyoIkeE4Yvl1r6bHOU
	 N7L/VTfnDb/ufUHQEukMoI8b3yH1P8im0/5jfXsuUozxZYldNVfYirV+wOL3Y4LFoE
	 ieQu/HeoejPCw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] Bluetooth: hci_sync: annotate data-races around hdev->req_status
Date: Mon, 20 Apr 2026 09:16:41 -0400
Message-ID: <20260420132314.1023554-7-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit b6807cfc195ef99e1ac37b2e1e60df40295daa8c ]

__hci_cmd_sync_sk() sets hdev->req_status under hdev->req_lock:

    hdev->req_status = HCI_REQ_PEND;

However, several other functions read or write hdev->req_status without
holding any lock:

  - hci_send_cmd_sync() reads req_status in hci_cmd_work (workqueue)
  - hci_cmd_sync_complete() reads/writes from HCI event completion
  - hci_cmd_sync_cancel() / hci_cmd_sync_cancel_sync() read/write
  - hci_abort_conn() reads in connection abort path

Since __hci_cmd_sync_sk() runs on hdev->req_workqueue while
hci_send_cmd_sync() runs on hdev->workqueue, these are different
workqueues that can execute concurrently on different CPUs. The plain
C accesses constitute a data race.

Add READ_ONCE()/WRITE_ONCE() annotations on all concurrent accesses
to hdev->req_status to prevent potential compiler optimizations that
could affect correctness (e.g., load fusing in the wait_event
condition or store reordering).

Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/bluetooth/hci_conn.c |  2 +-
 net/bluetooth/hci_core.c |  2 +-
 net/bluetooth/hci_sync.c | 20 ++++++++++----------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 24b71ec8897ff..71a24be2a6d67 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2967,7 +2967,7 @@ int hci_abort_conn(struct hci_conn *conn, u8 reason)
 	 * hci_connect_le serializes the connection attempts so only one
 	 * connection can be in BT_CONNECT at time.
 	 */
-	if (conn->state == BT_CONNECT && hdev->req_status == HCI_REQ_PEND) {
+	if (conn->state == BT_CONNECT && READ_ONCE(hdev->req_status) == HCI_REQ_PEND) {
 		switch (hci_skb_event(hdev->sent_cmd)) {
 		case HCI_EV_CONN_COMPLETE:
 		case HCI_EV_LE_CONN_COMPLETE:
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 8ccec73dce45c..0f86b81b39730 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4125,7 +4125,7 @@ static int hci_send_cmd_sync(struct hci_dev *hdev, struct sk_buff *skb)
 		kfree_skb(skb);
 	}
 
-	if (hdev->req_status == HCI_REQ_PEND &&
+	if (READ_ONCE(hdev->req_status) == HCI_REQ_PEND &&
 	    !hci_dev_test_and_set_flag(hdev, HCI_CMD_PENDING)) {
 		kfree_skb(hdev->req_skb);
 		hdev->req_skb = skb_clone(hdev->sent_cmd, GFP_KERNEL);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 9a7bd4a4b14c4..f498ab28f1aa0 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -25,11 +25,11 @@ static void hci_cmd_sync_complete(struct hci_dev *hdev, u8 result, u16 opcode,
 {
 	bt_dev_dbg(hdev, "result 0x%2.2x", result);
 
-	if (hdev->req_status != HCI_REQ_PEND)
+	if (READ_ONCE(hdev->req_status) != HCI_REQ_PEND)
 		return;
 
 	hdev->req_result = result;
-	hdev->req_status = HCI_REQ_DONE;
+	WRITE_ONCE(hdev->req_status, HCI_REQ_DONE);
 
 	/* Free the request command so it is not used as response */
 	kfree_skb(hdev->req_skb);
@@ -167,20 +167,20 @@ struct sk_buff *__hci_cmd_sync_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 
 	hci_cmd_sync_add(&req, opcode, plen, param, event, sk);
 
-	hdev->req_status = HCI_REQ_PEND;
+	WRITE_ONCE(hdev->req_status, HCI_REQ_PEND);
 
 	err = hci_req_sync_run(&req);
 	if (err < 0)
 		return ERR_PTR(err);
 
 	err = wait_event_interruptible_timeout(hdev->req_wait_q,
-					       hdev->req_status != HCI_REQ_PEND,
+					       READ_ONCE(hdev->req_status) != HCI_REQ_PEND,
 					       timeout);
 
 	if (err == -ERESTARTSYS)
 		return ERR_PTR(-EINTR);
 
-	switch (hdev->req_status) {
+	switch (READ_ONCE(hdev->req_status)) {
 	case HCI_REQ_DONE:
 		err = -bt_to_errno(hdev->req_result);
 		break;
@@ -194,7 +194,7 @@ struct sk_buff *__hci_cmd_sync_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 		break;
 	}
 
-	hdev->req_status = 0;
+	WRITE_ONCE(hdev->req_status, 0);
 	hdev->req_result = 0;
 	skb = hdev->req_rsp;
 	hdev->req_rsp = NULL;
@@ -665,9 +665,9 @@ void hci_cmd_sync_cancel(struct hci_dev *hdev, int err)
 {
 	bt_dev_dbg(hdev, "err 0x%2.2x", err);
 
-	if (hdev->req_status == HCI_REQ_PEND) {
+	if (READ_ONCE(hdev->req_status) == HCI_REQ_PEND) {
 		hdev->req_result = err;
-		hdev->req_status = HCI_REQ_CANCELED;
+		WRITE_ONCE(hdev->req_status, HCI_REQ_CANCELED);
 
 		queue_work(hdev->workqueue, &hdev->cmd_sync_cancel_work);
 	}
@@ -683,12 +683,12 @@ void hci_cmd_sync_cancel_sync(struct hci_dev *hdev, int err)
 {
 	bt_dev_dbg(hdev, "err 0x%2.2x", err);
 
-	if (hdev->req_status == HCI_REQ_PEND) {
+	if (READ_ONCE(hdev->req_status) == HCI_REQ_PEND) {
 		/* req_result is __u32 so error must be positive to be properly
 		 * propagated.
 		 */
 		hdev->req_result = err < 0 ? -err : err;
-		hdev->req_status = HCI_REQ_CANCELED;
+		WRITE_ONCE(hdev->req_status, HCI_REQ_CANCELED);
 
 		wake_up_interruptible(&hdev->req_wait_q);
 	}
-- 
2.53.0

