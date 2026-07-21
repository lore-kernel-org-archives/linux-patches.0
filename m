Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B2443F4AF;
	Tue, 21 Jul 2026 21:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667998; cv=none; b=DbcIcp7H/zNJRK1do3Fij96iWyL4BbjDI7RM1hXjS1xPKaj4am3/ZfwER4As46qwdTjrN6UlMLhWN/N7WjiVlqctvHlU4XWdtV+Rcqq7W9y5Rpl6O7zcuSrcvs6YE+AIFrtEEoR34vl88QkV7MU3kWhhE0ZKtRtuJMW3f992re0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667998; c=relaxed/simple;
	bh=Zn7/jTii605lDhkTchCsOOLfQmbj85SYBwT2/eDeKjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYQkx36AmEcJGDsbiukdxl/OXKFqB+v0/xEEgwcYrLwRH5x1VevxGxp8hnDp6TcYGwojCiXEZ6tElNzTy7sNzFra/fyRp47AyqSrwzy8URdgzRLaOoMJHzv5k7EqQSNT2AAc25d0mVsKt6FoFsg+XB8wNvnVQNz+zKTfZcfrwl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDF66LCP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDF66LCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D551F00A3D;
	Tue, 21 Jul 2026 21:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667996;
	bh=Zq+dOOEO33EPQglbWE9LRyaClbWtqIL4tx+nouuk3yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDF66LCPzG8AQc9UMPcw2/YT+F4I9T6P0vqm11asbS+dDgMicIKB3Ac5rWoSzImHH
	 DuEb68ExnsBPuGA/VPWD8kKhyFZWVb1d+wV3EuTBG7sSJHRcG8xZ1B+E5yxB8CFHBp
	 kKXiUBRK28nqkrLdYC1XCT2CQs+sr25xMm3jXNks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1249/1266] Bluetooth: hci_sync: annotate data-races around hdev->req_status
Date: Tue, 21 Jul 2026 17:28:06 +0200
Message-ID: <20260721152509.770577416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Stable-dep-of: 12917f591cea ("Bluetooth: hci_conn: Fix null ptr deref in hci_abort_conn()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_core.c |    2 +-
 net/bluetooth/hci_sync.c |   20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4060,7 +4060,7 @@ static void hci_send_cmd_sync(struct hci
 		return;
 	}
 
-	if (hci_req_status_pend(hdev) &&
+	if (READ_ONCE(hdev->req_status) == HCI_REQ_PEND &&
 	    !hci_dev_test_and_set_flag(hdev, HCI_CMD_PENDING)) {
 		kfree_skb(hdev->req_skb);
 		hdev->req_skb = skb_clone(hdev->sent_cmd, GFP_KERNEL);
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -25,11 +25,11 @@ static void hci_cmd_sync_complete(struct
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
@@ -168,20 +168,20 @@ struct sk_buff *__hci_cmd_sync_sk(struct
 
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
@@ -195,7 +195,7 @@ struct sk_buff *__hci_cmd_sync_sk(struct
 		break;
 	}
 
-	hdev->req_status = 0;
+	WRITE_ONCE(hdev->req_status, 0);
 	hdev->req_result = 0;
 	skb = hdev->req_rsp;
 	hdev->req_rsp = NULL;
@@ -689,9 +689,9 @@ void hci_cmd_sync_cancel(struct hci_dev
 {
 	bt_dev_dbg(hdev, "err 0x%2.2x", err);
 
-	if (hdev->req_status == HCI_REQ_PEND) {
+	if (READ_ONCE(hdev->req_status) == HCI_REQ_PEND) {
 		hdev->req_result = err;
-		hdev->req_status = HCI_REQ_CANCELED;
+		WRITE_ONCE(hdev->req_status, HCI_REQ_CANCELED);
 
 		queue_work(hdev->workqueue, &hdev->cmd_sync_cancel_work);
 	}
@@ -707,12 +707,12 @@ void hci_cmd_sync_cancel_sync(struct hci
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


