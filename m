Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EA412B176;
	Tue, 30 Apr 2024 10:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474186; cv=none; b=ZeOeIjwdaJTebw1AjBUAp1T8n/P1ZzlFGZQFUX2vuLmjDBe2TrAwz3tm0R1+g8nHdAPs8/7Qvc+mu6zFKJAi+WS0Po01UuZqi1Xks+4PGUkj8CTyqW4I0cDkOnX7Itjkv0u13pbUnEfNRyyGy3TcKPprQqpRnrYVdLMLK69zdPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474186; c=relaxed/simple;
	bh=Hc0hzF/TvxjFtYHkySKP5NC0bNRd7XsO//6+KpfRtak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pytz9D4daQqoqWvWLNTr1DD53PqzYMzTf4O8RwmpqtqPxRR9hgwgROXFMU9/R/T0vH9VUmGFCIROeMTxDPuFpgo4ZUQwYZtfueNLWEpxf0FyXcYXsNLCPMhHc7GA0CqhJsihfw5I0hG56B9U00IshksPbzeP7+IgYMFwgBB0qqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRsS/B7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRsS/B7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFC0C2BBFC;
	Tue, 30 Apr 2024 10:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474186;
	bh=Hc0hzF/TvxjFtYHkySKP5NC0bNRd7XsO//6+KpfRtak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRsS/B7uG8hQoFctMO125PbkeXoj54Y3py0F7cFisBGbAMxRs+CNa2kPndTh6eJw+
	 d5EqTA6m4YZvSQ8R6IrU664tkTL3D4zkC1rbjP1v4yofHCNdWe8nqlQOSlrZcyXsWd
	 O/q3j2R9YbaC/JasSNPI37SWRF2VxHTmzWn1wEy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 082/228] Bluetooth: hci_sync: Add helper functions to manipulate cmd_sync queue
Date: Tue, 30 Apr 2024 12:37:40 +0200
Message-ID: <20240430103106.169890814@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

[ Upstream commit 505ea2b295929e7be2b4e1bc86ee31cb7862fb01 ]

This adds functions to queue, dequeue and lookup into the cmd_sync
list.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 2e7ed5f5e69b ("Bluetooth: hci_sync: Use advertised PHYs on hci_le_ext_create_conn_sync")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_sync.h |  12 +++
 net/bluetooth/hci_sync.c         | 132 +++++++++++++++++++++++++++++--
 2 files changed, 136 insertions(+), 8 deletions(-)

diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index ed334c253ebcd..4ff4aa68ee196 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -48,6 +48,18 @@ int hci_cmd_sync_submit(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
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
index cffa61ecf234f..22db2949eb3ef 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -570,6 +570,17 @@ void hci_cmd_sync_init(struct hci_dev *hdev)
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
@@ -578,13 +589,8 @@ void hci_cmd_sync_clear(struct hci_dev *hdev)
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
 
@@ -676,6 +682,115 @@ int hci_cmd_sync_queue(struct hci_dev *hdev, hci_cmd_sync_work_func_t func,
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
@@ -2932,7 +3047,8 @@ int hci_update_passive_scan(struct hci_dev *hdev)
 	    hci_dev_test_flag(hdev, HCI_UNREGISTER))
 		return 0;
 
-	return hci_cmd_sync_queue(hdev, update_passive_scan_sync, NULL, NULL);
+	return hci_cmd_sync_queue_once(hdev, update_passive_scan_sync, NULL,
+				       NULL);
 }
 
 int hci_write_sc_support_sync(struct hci_dev *hdev, u8 val)
-- 
2.43.0



