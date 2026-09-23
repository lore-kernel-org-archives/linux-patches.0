Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87A1426D2E;
	Wed, 23 Sep 2026 14:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174611; cv=none; b=tl3oCFzrR4icgrgKXzLnsIty0Kme4x7RI7m6xMgy7Va8nu9QJ08WjmQGTdJ/FrgwcXZIQuR4cB5ilfLPUiF0DVxXVM7dkFJ3hQwt5QaGiEwSsGwJSev6e9g3gd7zCRRb8yxnWnX59o+HIXfTbHeeZlp7ELTOoiXrVKo6qk07PFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174611; c=relaxed/simple;
	bh=TgP7Q1saVvGXZRsyyix6ZUm+fFc8+3tk775Q7lImb/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGO+m1ZrPCR+6YSYE0keGbsb+WzgeQJWv0du11UklxTz3VzAe8oOOGKxJgupfJ27Dase3yU9U7d2klwyUSR1gQQLpEaJdfjauV/2MljQZnyisLtwBPTWglltt+tB+NUe+ZTeMBL6y0OE/aLCMTVImWr5B9EHZXJpnt6dfhnKhok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VvPTxe+f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VvPTxe+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF8A1F000FF;
	Wed, 23 Sep 2026 14:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174610;
	bh=yYOsC3BLRpy1eDIvLaeeLImBGVGTIRSvBMiXD0YB0yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VvPTxe+f78Gp4zykycGLNly4jDE64S777ZuJ5gQErO0dK42GS1PiG7VmXcMq98Rj0
	 q2BtO8Gx8EDcuJDwN3abT/tscoghbntEWLVrL33bzl/CgXgnPDi69j15ayaJaXmcak
	 NjM/P6u6SZUAbOGiJitsiAsyGmo8Tyfwe/I7yCFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b6919040d9958e2fc1ae@syzkaller.appspotmail.com,
	ThangNN99 <ngocthang2710.1999@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 141/398] Bluetooth: hci_core: Fix queuing tx_work after workqueue is drained
Date: Wed, 23 Sep 2026 16:03:35 +0200
Message-ID: <20260923140647.087312837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: ThangNN99 <ngocthang2710.1999@gmail.com>

[ Upstream commit 6610c6fe4b8936c232048e6049bf77c70a6f759c ]

hci_send_acl(), hci_send_sco() and hci_send_iso() queue hdev->tx_work
unconditionally. They can run from the L2CAP/SCO/ISO socket send path
while hci_dev_close_sync() is draining hdev->workqueue (HCIDEVDOWN
racing with a socket write). Since that queue_work() is not chained
work from the tx_work worker itself, __queue_work() sees the queue
marked __WQ_DRAINING, warns "cannot queue %ps on wq %s", and drops
the work:

  WARNING: CPU: 1 PID: 5985 at kernel/workqueue.c:2352 __queue_work
  Call Trace:
   queue_work_on
   l2cap_chan_send
   l2cap_sock_sendmsg
   ...

hci_dev_close_sync() already sets HCI_CMD_DRAIN_WORKQUEUE before
draining, but only hci_cmd_work() and handle_cmd_cnt_and_timer()
check it before queuing. Route the tx_work producers through the
same guard via a shared hci_sched_tx() helper.

Fixes: 525daaea459f ("Bluetooth: hci_sync: Set HCI_CMD_DRAIN_WORKQUEUE during device close")
Reported-by: syzbot+b6919040d9958e2fc1ae@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b6919040d9958e2fc1ae
Signed-off-by: ThangNN99 <ngocthang2710.1999@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 447a7ebcdf62f..31c668ad99366 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3273,6 +3273,17 @@ static void hci_queue_acl(struct hci_chan *chan, struct sk_buff_head *queue,
 	bt_dev_dbg(hdev, "chan %p queued %d", chan, skb_queue_len(queue));
 }
 
+/* Queue hdev->tx_work, unless hdev->workqueue is being drained by
+ * hci_dev_close_sync(), which would otherwise WARN and drop the work.
+ */
+static void hci_sched_tx(struct hci_dev *hdev)
+{
+	rcu_read_lock();
+	if (!hci_dev_test_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE))
+		queue_work(hdev->workqueue, &hdev->tx_work);
+	rcu_read_unlock();
+}
+
 void hci_send_acl(struct hci_chan *chan, struct sk_buff *skb, __u16 flags)
 {
 	struct hci_dev *hdev = chan->conn->hdev;
@@ -3281,7 +3292,7 @@ void hci_send_acl(struct hci_chan *chan, struct sk_buff *skb, __u16 flags)
 
 	hci_queue_acl(chan, &chan->data_q, skb, flags);
 
-	queue_work(hdev->workqueue, &hdev->tx_work);
+	hci_sched_tx(hdev);
 }
 
 /* Send SCO data */
@@ -3306,7 +3317,7 @@ void hci_send_sco(struct hci_conn *conn, struct sk_buff *skb)
 	bt_dev_dbg(hdev, "hcon %p queued %d", conn,
 		   skb_queue_len(&conn->data_q));
 
-	queue_work(hdev->workqueue, &hdev->tx_work);
+	hci_sched_tx(hdev);
 }
 
 /* Send ISO data */
@@ -3377,7 +3388,7 @@ void hci_send_iso(struct hci_conn *conn, struct sk_buff *skb)
 
 	hci_queue_iso(conn, &conn->data_q, skb);
 
-	queue_work(hdev->workqueue, &hdev->tx_work);
+	hci_sched_tx(hdev);
 }
 
 /* ---- HCI TX task (outgoing data) ---- */
-- 
2.53.0



