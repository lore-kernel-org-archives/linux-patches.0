Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319C4519E02;
	Wed, 23 Sep 2026 14:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173196; cv=none; b=iHOofdGacA6K6lhI1V7mzWqrQCSqMZSB8RpW0YGgz6eKkCaBoyT/HERlmOSTrwVAOCqgKwVCGBpJJn3dKO9Ba+VyydSdsI/vAYaiPy9dfx+wD5h8eBy+FAigg1BPkjsK0RfvYDsJb8Mxr9SnegXhqb5Eu69t4DQn7zdO+DlgBdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173196; c=relaxed/simple;
	bh=W53RLdR0AvDW1+m09DdGcLSBHtdYFb933iaoEerXwI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPBO1EUpswgXp6Bp3WLFePDmRRIcXuPyulHzNafqL2EZPwMzam/L4+vp6ookvBmbnpL/22mGWSnZVMZ6yITZv+yEeyKik6b5JKSNquMfo7nMrMSLf24GTPlYHhddYRWV7XhmQ+Q75kD9M1zIDVDoMWnMDYFC+T/NyA06qWBfwYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9nHaCTF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9nHaCTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952291F000FF;
	Wed, 23 Sep 2026 14:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173195;
	bh=ui0acwrYd5rsZ8W5jxGhUt5xjKg2VBztBsnTByhCRvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9nHaCTFKPDPYL2E5aWr4smKNIwZv2CpAfFnKPHCKQR5LbWV7ghXAVZ/0MXYwJH+t
	 VIxz4qTnos2hhjmWEpw4uNhUpQiBCMUUBBXcvTgR7uhUSNVgFrw0ycQbv7iPaVqc7U
	 RueUQeQsOkX9CA4KHxyjTMc6O26UMS4tafYVgYWU=
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
Subject: [PATCH 7.2 170/438] Bluetooth: coredump: Quiesce dump work on unregister
Date: Wed, 23 Sep 2026 16:03:11 +0200
Message-ID: <20260923140649.175571255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 86a9677ed7025..3ea5ea7267d9c 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2670,6 +2670,7 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	disable_work_sync(&hdev->error_reset);
 	disable_delayed_work_sync(&hdev->cmd_timer);
 	disable_delayed_work_sync(&hdev->ncmd_timer);
+	hci_devcd_shutdown(hdev);
 
 	hci_cmd_sync_clear(hdev);
 
-- 
2.53.0



