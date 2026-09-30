Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F465187EF;
	Wed, 30 Sep 2026 17:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788457; cv=none; b=Wn7FO+K++MYqTSwXAt/GjWajR/u28gDj3L3cmIJY4vycxP33hyElY+xHyhSHESTAol0WaPdr+pVBTFkLTJpenyWiJVyH3MXulmoVQCAukGyJCRve+xDFDNQKK3NIvfQP7KztgCzvifEKXbNZ2J+Ov3ReuwuLdhynEzA3hmz1ar8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788457; c=relaxed/simple;
	bh=gHAWlplrQD0W5X9TDHQNSdIG3Gt8xWSVvTXwgahZyqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZ6aSJd7/ELgCNcbH6d9bagEaBl/2oIJpGsPnSZznpCi9o2QX28mk1L7l445TetKECvXDxQFxCLUSJZ7mfeAu96k3Z/+T/alOOiRyiVCBBAYqdutNjJY8/x+aMSslROrSUQfn3gncoal5XgtZwf27wN6oF1MF4mVVOI1zZe0VL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLkHEJx+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLkHEJx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1441F000FF;
	Wed, 30 Sep 2026 17:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788456;
	bh=h5MD8QNnhIsOoHYwaZE7HaDJvV7HmPHaSHzw8XJqbwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tLkHEJx+yfTfT/c5E0yrhMHxbD5sQsbzwMhAcyeOWS9n+py1MyGh2tAdYmNBxT5os
	 gXUGgJojy4zZZ8ugfDn2RVspZFhQEyklbJ9HpYHJHjk0lSbp7zQPSnHNdrQr77NDXp
	 U7o9+KNcK7kG/JCQ4iA9ZDCjHTIXVq7ISsMFvHwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b6919040d9958e2fc1ae@syzkaller.appspotmail.com,
	ThangNN99 <ngocthang2710.1999@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/877] Bluetooth: hci_core: Fix queuing tx_work after workqueue is drained
Date: Wed, 30 Sep 2026 17:17:22 +0200
Message-ID: <20260930152417.561955313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 24f2119c7abfa..85aecd4c5b9b2 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3277,6 +3277,17 @@ static void hci_queue_acl(struct hci_chan *chan, struct sk_buff_head *queue,
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
@@ -3285,7 +3296,7 @@ void hci_send_acl(struct hci_chan *chan, struct sk_buff *skb, __u16 flags)
 
 	hci_queue_acl(chan, &chan->data_q, skb, flags);
 
-	queue_work(hdev->workqueue, &hdev->tx_work);
+	hci_sched_tx(hdev);
 }
 
 /* Send SCO data */
@@ -3310,7 +3321,7 @@ void hci_send_sco(struct hci_conn *conn, struct sk_buff *skb)
 	bt_dev_dbg(hdev, "hcon %p queued %d", conn,
 		   skb_queue_len(&conn->data_q));
 
-	queue_work(hdev->workqueue, &hdev->tx_work);
+	hci_sched_tx(hdev);
 }
 
 /* Send ISO data */
@@ -3381,7 +3392,7 @@ void hci_send_iso(struct hci_conn *conn, struct sk_buff *skb)
 
 	hci_queue_iso(conn, &conn->data_q, skb);
 
-	queue_work(hdev->workqueue, &hdev->tx_work);
+	hci_sched_tx(hdev);
 }
 
 /* ---- HCI TX task (outgoing data) ---- */
-- 
2.53.0



