Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3727581D;
	Tue, 10 Sep 2024 10:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964353; cv=none; b=ZkKnKXLX+kytXBU6dnddKb8/ExXiIcTsgMHtISzLaav8cFo+nyLaMg1exYC4ihY0hfAxVRieMWIt9x1FLkPCNLgRwwSobXMaIFtceR4ALRtiJhv5TZ6uGKBbGQw0H1I0EboEtbhxilXsZ/ZlcN3wfwWLMpiqt+e+Xak09c1sIJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964353; c=relaxed/simple;
	bh=cvdtacIgadADaVusgDlKKtRlyNdKBINoVwM1JmJ8Wt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyLpdPNJdqVGo7wYphurhSvHtUH5cFcraCEhpBYDesig3vHL7VLfGZ64gzYaPn0g7B8q+xTJKd1cP1rqiqQVlBvMVfj/JNFW6Ra5c+XRTXtuP43Bo5FAwCE1Xq4v3IDA15PPEHXNJHQY1ta08iS6LPnFVmVNenMliezh1Orsnh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gV0FFoE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gV0FFoE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C437C4CEC3;
	Tue, 10 Sep 2024 10:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964352;
	bh=cvdtacIgadADaVusgDlKKtRlyNdKBINoVwM1JmJ8Wt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gV0FFoE7qhq8dNek0dG0wZ5OIgUrLsD50buUbN0aoDIVacShtS2qZ9RgvfNx8CMXt
	 0h02KRE7STFkpv09ZTs6ZDLibQdqTBEnNaNn7bK5398suFcTrAGkk/lhLj2xhUcByG
	 nua0LD0j9cRK6YyfbAOow5q/a4p1VfmWRAneqIqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/269] Bluetooth: hci_sync: Add helper functions to manipulate cmd_sync queue
Date: Tue, 10 Sep 2024 11:31:43 +0200
Message-ID: <20240910092612.324820264@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 505ea2b295929e7be2b4e1bc86ee31cb7862fb01 ]

This adds functions to queue, dequeue and lookup into the cmd_sync
list.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 227a0cdf4a02 ("Bluetooth: MGMT: Fix not generating command complete for MGMT_OP_DISCONNECT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_sync.h |  12 +++
 net/bluetooth/hci_sync.c         | 132 +++++++++++++++++++++++++++++--
 2 files changed, 136 insertions(+), 8 deletions(-)

diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index 37ca8477b3f4..24c0053d8f0c 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -50,6 +50,18 @@ int hci_cmd_sync_submit(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 			void *data, hci_cmd_sync_work_destroy_t destroy);
 int hci_cmd_sync_queue(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 		       void *data, hci_cmd_sync_work_destroy_t destroy);
+struct hci_cmd_sync_work_entry *
+hci_cmd_sync_lookup_entry(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
+			  void *data, hci_cmd_sync_work_destroy_t destroy);
+int hci_cmd_sync_queue_once(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
+			    void *data, hci_cmd_sync_work_destroy_t destroy);
+void hci_cmd_sync_cancel_entry(struct hci_dev *hdev,
+			       struct hci_cmd_sync_work_entry *entry);
+bool hci_cmd_sync_dequeue(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
+			  void *data, hci_cmd_sync_work_destroy_t destroy);
+bool hci_cmd_sync_dequeue_once(struct hci_dev *hdev,
+			      hci_cmd_sync_work_func_t func, void *data,
+			      hci_cmd_sync_work_destroy_t destroy);
 
 int hci_update_eir_sync(struct hci_dev *hdev);
 int hci_update_class_sync(struct hci_dev *hdev);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 19ceb7ce66bf..ed18e35c7097 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -651,6 +651,17 @@ void hci_cmd_sync_init(struct hci_dev *hdev)
 	INIT_DELAYED_WORK(&hdev->adv_instance_expire, adv_timeout_expire);
 }
 
+static void _hci_cmd_sync_cancel_entry(struct hci_dev *hdev,
+				       struct hci_cmd_sync_work_entry *entry,
+				       int err)
+{
+	if (entry->destroy)
+		entry->destroy(hdev, entry->data, err);
+
+	list_del(&entry->list);
+	kfree(entry);
+}
+
 void hci_cmd_sync_clear(struct hci_dev *hdev)
 {
 	struct hci_cmd_sync_work_entry *entry, *tmp;
@@ -659,13 +670,8 @@ void hci_cmd_sync_clear(struct hci_dev *hdev)
 	cancel_work_sync(&hdev->reenable_adv_work);
 
 	mutex_lock(&hdev->cmd_sync_work_lock);
-	list_for_each_entry_safe(entry, tmp, &hdev->cmd_sync_work_list, list) {
-		if (entry->destroy)
-			entry->destroy(hdev, entry->data, -ECANCELED);
-
-		list_del(&entry->list);
-		kfree(entry);
-	}
+	list_for_each_entry_safe(entry, tmp, &hdev->cmd_sync_work_list, list)
+		_hci_cmd_sync_cancel_entry(hdev, entry, -ECANCELED);
 	mutex_unlock(&hdev->cmd_sync_work_lock);
 }
 
@@ -757,6 +763,115 @@ int hci_cmd_sync_queue(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
 }
 EXPORT_SYMBOL(hci_cmd_sync_queue);
 
+static struct hci_cmd_sync_work_entry *
+_hci_cmd_sync_lookup_entry(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
+			   void *data, hci_cmd_sync_work_destroy_t destroy)
+{
+	struct hci_cmd_sync_work_entry *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, &hdev->cmd_sync_work_list, list) {
+		if (func && entry->func != func)
+			continue;
+
+		if (data && entry->data != data)
+			continue;
+
+		if (destroy && entry->destroy != destroy)
+			continue;
+
+		return entry;
+	}
+
+	return NULL;
+}
+
+/* Queue HCI command entry once:
+ *
+ * - Lookup if an entry already exist and only if it doesn't creates a new entry
+ *   and queue it.
+ */
+int hci_cmd_sync_queue_once(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
+			    void *data, hci_cmd_sync_work_destroy_t destroy)
+{
+	if (hci_cmd_sync_lookup_entry(hdev, func, data, destroy))
+		return 0;
+
+	return hci_cmd_sync_queue(hdev, func, data, destroy);
+}
+EXPORT_SYMBOL(hci_cmd_sync_queue_once);
+
+/* Lookup HCI command entry:
+ *
+ * - Return first entry that matches by function callback or data or
+ *   destroy callback.
+ */
+struct hci_cmd_sync_work_entry *
+hci_cmd_sync_lookup_entry(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
+			  void *data, hci_cmd_sync_work_destroy_t destroy)
+{
+	struct hci_cmd_sync_work_entry *entry;
+
+	mutex_lock(&hdev->cmd_sync_work_lock);
+	entry = _hci_cmd_sync_lookup_entry(hdev, func, data, destroy);
+	mutex_unlock(&hdev->cmd_sync_work_lock);
+
+	return entry;
+}
+EXPORT_SYMBOL(hci_cmd_sync_lookup_entry);
+
+/* Cancel HCI command entry */
+void hci_cmd_sync_cancel_entry(struct hci_dev *hdev,
+			       struct hci_cmd_sync_work_entry *entry)
+{
+	mutex_lock(&hdev->cmd_sync_work_lock);
+	_hci_cmd_sync_cancel_entry(hdev, entry, -ECANCELED);
+	mutex_unlock(&hdev->cmd_sync_work_lock);
+}
+EXPORT_SYMBOL(hci_cmd_sync_cancel_entry);
+
+/* Dequeue one HCI command entry:
+ *
+ * - Lookup and cancel first entry that matches.
+ */
+bool hci_cmd_sync_dequeue_once(struct hci_dev *hdev,
+			       hci_cmd_sync_work_func_t func,
+			       void *data, hci_cmd_sync_work_destroy_t destroy)
+{
+	struct hci_cmd_sync_work_entry *entry;
+
+	entry = hci_cmd_sync_lookup_entry(hdev, func, data, destroy);
+	if (!entry)
+		return false;
+
+	hci_cmd_sync_cancel_entry(hdev, entry);
+
+	return true;
+}
+EXPORT_SYMBOL(hci_cmd_sync_dequeue_once);
+
+/* Dequeue HCI command entry:
+ *
+ * - Lookup and cancel any entry that matches by function callback or data or
+ *   destroy callback.
+ */
+bool hci_cmd_sync_dequeue(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
+			  void *data, hci_cmd_sync_work_destroy_t destroy)
+{
+	struct hci_cmd_sync_work_entry *entry;
+	bool ret = false;
+
+	mutex_lock(&hdev->cmd_sync_work_lock);
+	while ((entry = _hci_cmd_sync_lookup_entry(hdev, func, data,
+						   destroy))) {
+		_hci_cmd_sync_cancel_entry(hdev, entry, -ECANCELED);
+		ret = true;
+	}
+	mutex_unlock(&hdev->cmd_sync_work_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(hci_cmd_sync_dequeue);
+
 int hci_update_eir_sync(struct hci_dev *hdev)
 {
 	struct hci_cp_write_eir cp;
@@ -3048,7 +3163,8 @@ int hci_update_passive_scan(struct hci_dev *hdev)
 	    hci_dev_test_flag(hdev, HCI_UNREGISTER))
 		return 0;
 
-	return hci_cmd_sync_queue(hdev, update_passive_scan_sync, NULL, NULL);
+	return hci_cmd_sync_queue_once(hdev, update_passive_scan_sync, NULL,
+				       NULL);
 }
 
 int hci_write_sc_support_sync(struct hci_dev *hdev, u8 val)
-- 
2.43.0



