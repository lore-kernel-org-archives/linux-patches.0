Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C2B3C768E;
	Sat, 17 Oct 2026 18:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260807; cv=none; b=ARHzfOqPcsm/ZOvqFd8ighmzf8AM5Ftz/Aao2d7zi3AKFlavUgZtB2rtUH9mhhjtko80Pl+NjhbL7ADBuhEtLRip0xys9RQ+joF6zeoxk1G/YZcg+/Zd9RQuWw9uEISR8et5FeB2rUkBK7hiNprEC/L1H2z3da3WGzJtHuvpwrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260807; c=relaxed/simple;
	bh=qw+gaGdZm6cqHnRqKLLSr4u3lgIYgibJpDrlX1k2nTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukDltJm3u11zm00IQ2/+2K2U78aDHVw/76AaO7fjDI+2tZMvkGfrialShJCgYSmt7Zmlj7pPQRlB7Hjh4lgkrMAmjPw1OfIfNySqp9D5D7w4HiHyyDY22/wjQncUC3tS3ZLkBWTKrffUvTOn+MrP+8P7RdpFcZDM2X3PHzR9Ihk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgKuHS3O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgKuHS3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468E81F000C4;
	Sat, 17 Oct 2026 18:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260805;
	bh=/9CmXTdD58WXcJZIsNOTmlTqn88vbQx4W5mlm9OIfTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xgKuHS3ONz55R7XCOCop34xb1cuKn5mJROiHEhg/yhkfP8LIVFStUpNbsa0KffBK5
	 ebLcT0UcSATJMqvwFjkm9wvr0xURU1lwpzFRHVDB3dpMlzEUEPiRnIiRPlXUrOfG7q
	 bJdLU/A6zsthtQxoEUoa+1D7PZPWUwR4q51upFmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b6919040d9958e2fc1ae@syzkaller.appspotmail.com,
	ThangNN99 <ngocthang2710.1999@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1665/1674] Bluetooth: hci_core: Fix queuing tx_work after workqueue is drained
Date: Sat, 17 Oct 2026 18:05:37 +0200
Message-ID: <20261017160513.806664781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index fcdca0c0c8cb9..84d9a445e08d1 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3235,6 +3235,17 @@ static void hci_queue_acl(struct hci_chan *chan, struct sk_buff_head *queue,
 	}
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
@@ -3243,7 +3254,7 @@ void hci_send_acl(struct hci_chan *chan, struct sk_buff *skb, __u16 flags)
 
 	hci_queue_acl(chan, &chan->data_q, skb, flags);
 
-	queue_work(hdev->workqueue, &hdev->tx_work);
+	hci_sched_tx(hdev);
 }
 
 /* Send SCO data */
@@ -3264,7 +3275,7 @@ void hci_send_sco(struct hci_conn *conn, struct sk_buff *skb)
 	hci_skb_pkt_type(skb) = HCI_SCODATA_PKT;
 
 	skb_queue_tail(&conn->data_q, skb);
-	queue_work(hdev->workqueue, &hdev->tx_work);
+	hci_sched_tx(hdev);
 }
 
 /* Send ISO data */
@@ -3337,7 +3348,7 @@ void hci_send_iso(struct hci_conn *conn, struct sk_buff *skb)
 
 	hci_queue_iso(conn, &conn->data_q, skb);
 
-	queue_work(hdev->workqueue, &hdev->tx_work);
+	hci_sched_tx(hdev);
 }
 
 /* ---- HCI TX task (outgoing data) ---- */
-- 
2.53.0



