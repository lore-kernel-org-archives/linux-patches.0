Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F53E329C7C;
	Wed, 23 Sep 2026 14:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174618; cv=none; b=ccG5RRjGA4L41PEKbL5gswYUZKqfMh7qmpu+V1/GfkRaf/4N0VlrKcb3YpK9f5LYAla05YtU64ermPn23pYzOjlGwBZPu0J6BWtzcf63gKJ57qzuHTkJqnnOXG+xhD9LeDsOQ08G04XcLS2c2qBZJ14cgkMThY9WgqEWVKEHda0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174618; c=relaxed/simple;
	bh=toELB1w27b01lC2BQRqIOyVGezzi+FgGOZkqN3ehdtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BP6rtfN57yLYQXf8oSwyQi2XmsCI6arqUYSB8hKF7RZwjI0heWHgB3snthzSElTqTrjPPx1knXkPkc9lfYww1VUbS8ee+G6ng4tpyckC79FACnTRoGIW7hEUACfGJ/t+kk6Iyc8EgvwwKv1nqflqCF3EitxXWzxTa852OPnuIGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvYfIbWh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvYfIbWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A174C1F00899;
	Wed, 23 Sep 2026 14:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174617;
	bh=c34aRssCUpP+34rcZ7osSVntmOPafdK5VM2bliGMS0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvYfIbWhTUgiUAG/JjnXME0d7S+oExQF1l+7w/O3pj8LpMy2N+qXvklX+ayjrvAE7
	 8fArbS3KPCTaFwVDnGHgOUUuT19SeEs3AFzwjVE/z6laa8CKg7szMVTVuEZgqyU3La
	 +r7px9gYqePEQl8ymUZ1oUbIx57Esn8a5Tw7pbw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b170dbf55520ebf5969a@syzkaller.appspotmail.com,
	Aby Sam Ross <abysamross@gmail.com>,
	Tristan Madani <tristan@talencesecurity.com>,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 143/398] Bluetooth: coredump: Quiesce dump work on unregister
Date: Wed, 23 Sep 2026 16:03:37 +0200
Message-ID: <20260923140647.138130532@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit d236517c264e41dc09833c708ef23bccb7a91219 ]

hci_devcd_handle_pkt_init() arms dump_timeout and coredump producers
queue dump_rx without holding an hdev reference. Unregister leaves both
works live, so disconnecting during an active dump lets them access hdev
after hci_release_dev() frees it.

Shut down coredump processing during unregister. Close the producer gate
under dump_q.lock before disabling both works, then free the active buffer
and queued packets under hci_dev_lock. Serializing the gate with enqueue
prevents controller-specific workers from adding packets after the final
purge.

Fixes: 9695ef876fd1 ("Bluetooth: Add support for hci devcoredump")
Reported-by: syzbot+b170dbf55520ebf5969a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b170dbf55520ebf5969a
Reported-by: Aby Sam Ross <abysamross@gmail.com>
Link: https://lore.kernel.org/r/20260322210849.68743-1-abysamross@gmail.com
Suggested-by: Aby Sam Ross <abysamross@gmail.com>
Reported-by: Tristan Madani <tristan@talencesecurity.com>
Link: https://lore.kernel.org/r/20260814231248.3096377-1-tristmd@gmail.com
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: OpenAI Codex:gpt-5
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/coredump.h |  2 +
 net/bluetooth/coredump.c         | 65 +++++++++++++++++++++-----------
 net/bluetooth/hci_core.c         |  1 +
 3 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/include/net/bluetooth/coredump.h b/include/net/bluetooth/coredump.h
index 72f51b587a046..00c12c7ac042f 100644
--- a/include/net/bluetooth/coredump.h
+++ b/include/net/bluetooth/coredump.h
@@ -61,6 +61,7 @@ struct hci_devcoredump {
 #ifdef CONFIG_DEV_COREDUMP
 
 void hci_devcd_reset(struct hci_dev *hdev);
+void hci_devcd_shutdown(struct hci_dev *hdev);
 void hci_devcd_rx(struct work_struct *work);
 void hci_devcd_timeout(struct work_struct *work);
 
@@ -75,6 +76,7 @@ int hci_devcd_abort(struct hci_dev *hdev);
 #else
 
 static inline void hci_devcd_reset(struct hci_dev *hdev) {}
+static inline void hci_devcd_shutdown(struct hci_dev *hdev) {}
 static inline void hci_devcd_rx(struct work_struct *work) {}
 static inline void hci_devcd_timeout(struct work_struct *work) {}
 
diff --git a/net/bluetooth/coredump.c b/net/bluetooth/coredump.c
index 720cb79adf964..b15971ad78a8f 100644
--- a/net/bluetooth/coredump.c
+++ b/net/bluetooth/coredump.c
@@ -105,6 +105,22 @@ static void hci_devcd_free(struct hci_dev *hdev)
 	hci_devcd_reset(hdev);
 }
 
+void hci_devcd_shutdown(struct hci_dev *hdev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&hdev->dump.dump_q.lock, flags);
+	hdev->dump.supported = false;
+	spin_unlock_irqrestore(&hdev->dump.dump_q.lock, flags);
+
+	disable_work_sync(&hdev->dump.dump_rx);
+	disable_delayed_work_sync(&hdev->dump.dump_timeout);
+
+	hci_dev_lock(hdev);
+	hci_devcd_free(hdev);
+	hci_dev_unlock(hdev);
+}
+
 /* Call with hci_dev_lock only. */
 static int hci_devcd_alloc(struct hci_dev *hdev, u32 size)
 {
@@ -444,7 +460,29 @@ EXPORT_SYMBOL(hci_devcd_register);
 
 static inline bool hci_devcd_enabled(struct hci_dev *hdev)
 {
-	return hdev->dump.supported;
+	return READ_ONCE(hdev->dump.supported);
+}
+
+static int hci_devcd_queue(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	unsigned long flags;
+	int err = 0;
+
+	spin_lock_irqsave(&hdev->dump.dump_q.lock, flags);
+	if (!hdev->dump.supported)
+		err = -EOPNOTSUPP;
+	else
+		__skb_queue_tail(&hdev->dump.dump_q, skb);
+	spin_unlock_irqrestore(&hdev->dump.dump_q.lock, flags);
+
+	if (err) {
+		kfree_skb(skb);
+		return err;
+	}
+
+	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
+
+	return 0;
 }
 
 int hci_devcd_init(struct hci_dev *hdev, u32 dump_size)
@@ -461,10 +499,7 @@ int hci_devcd_init(struct hci_dev *hdev, u32 dump_size)
 	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_INIT;
 	put_unaligned_le32(dump_size, skb_put(skb, 4));
 
-	skb_queue_tail(&hdev->dump.dump_q, skb);
-	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
-
-	return 0;
+	return hci_devcd_queue(hdev, skb);
 }
 EXPORT_SYMBOL(hci_devcd_init);
 
@@ -480,10 +515,7 @@ int hci_devcd_append(struct hci_dev *hdev, struct sk_buff *skb)
 
 	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_SKB;
 
-	skb_queue_tail(&hdev->dump.dump_q, skb);
-	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
-
-	return 0;
+	return hci_devcd_queue(hdev, skb);
 }
 EXPORT_SYMBOL(hci_devcd_append);
 
@@ -505,10 +537,7 @@ int hci_devcd_append_pattern(struct hci_dev *hdev, u8 pattern, u32 len)
 	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_PATTERN;
 	skb_put_data(skb, &p, sizeof(p));
 
-	skb_queue_tail(&hdev->dump.dump_q, skb);
-	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
-
-	return 0;
+	return hci_devcd_queue(hdev, skb);
 }
 EXPORT_SYMBOL(hci_devcd_append_pattern);
 
@@ -525,10 +554,7 @@ int hci_devcd_complete(struct hci_dev *hdev)
 
 	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_COMPLETE;
 
-	skb_queue_tail(&hdev->dump.dump_q, skb);
-	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
-
-	return 0;
+	return hci_devcd_queue(hdev, skb);
 }
 EXPORT_SYMBOL(hci_devcd_complete);
 
@@ -545,9 +571,6 @@ int hci_devcd_abort(struct hci_dev *hdev)
 
 	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_ABORT;
 
-	skb_queue_tail(&hdev->dump.dump_q, skb);
-	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
-
-	return 0;
+	return hci_devcd_queue(hdev, skb);
 }
 EXPORT_SYMBOL(hci_devcd_abort);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 31c668ad99366..c0a8bd7af781e 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2709,6 +2709,7 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	disable_work_sync(&hdev->error_reset);
 	disable_delayed_work_sync(&hdev->cmd_timer);
 	disable_delayed_work_sync(&hdev->ncmd_timer);
+	hci_devcd_shutdown(hdev);
 
 	hci_cmd_sync_clear(hdev);
 
-- 
2.53.0



