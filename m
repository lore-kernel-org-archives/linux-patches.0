Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7B03290D1;
	Sat, 12 Sep 2026 16:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231103; cv=none; b=O8irELuKWnF20qI2I4hsREsLR0n/NEW/+jWBEsvCLABAVq6t3MACjEX3CjS9ld0SJxwKcMhoVmG5US52GgKG4fLNLyRK32gckyKXTnadtf67yhyypnBpMBfRs2MrT5CajYnRGK2nDfKT1Kgr0z2fsGmR+GKI9xbJIKdS95PrGEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231103; c=relaxed/simple;
	bh=ty9ezX+iZvuHvjedi6ur8wfqM6GWPGvJBx2rJIjflws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0OcwtyxLZtbkjVD6G3xHowfA6mpdbPZi/D6wdiwqgeYK5+C1PRGcppnqNRa3KiiRx08xq8FjKBS1GUAIhkHtwHR3PSMgEO/X3wjL0IOh854T/kDYJesc4taHoYy+nVshsb+nGlqRDCnxS0Al2t7e/B9sYAOB5FQsM35OhSJYck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IY4rEBvf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IY4rEBvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A791F000FF;
	Sat, 12 Sep 2026 16:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231102;
	bh=S7De5VuwbY7rrNQDQCeZGY8RMHULf8e1uTaDrpcheeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IY4rEBvfaB7P+gHkHtJsagf/0/LzbTTxU/b8LH/GJj/aDjzPtSaTHlC1PNZsTrK3m
	 H8QXniRGdMns9l6ek+a2+M9Dgm25xDW3F46nJjo1eAyKJ00k8FUOBPiyY8UatMyGqq
	 hBN2bND4mcmZXTK/l7M3sPL54TBV3Q+dm37v6Y/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0931/1191] Bluetooth: hci_sync: free the advertising instance on the failure and cancel paths
Date: Sat, 12 Sep 2026 09:00:59 +0200
Message-ID: <20260912065609.138901530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 120d8dc042e3d45073bb6e50ee7b058a0b182627 ]

adv_timeout_expire() hands a kmalloc()ed instance byte to
hci_cmd_sync_queue() with a NULL destroy callback, and only
adv_timeout_expire_sync() frees it. That leaks on two paths:

 - the return value is not checked, and hci_cmd_sync_queue() does not
   take ownership when it fails (-ENETDOWN, -ENODEV, -ENOMEM);

 - a cancelled entry is not released, as _hci_cmd_sync_cancel_entry()
   does not free entry->data when there is no destroy callback.
   hci_cmd_sync_clear() cancels every pending entry when the controller
   is unregistered.

Free the buffer from a destroy callback, and in the caller when the entry
could not be queued at all.

Fixes: c249ea9b4309 ("Bluetooth: Move Adv Instance timer to hci_sync")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 005e38a79c73d..d5856448d4678 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -606,8 +606,6 @@ static int adv_timeout_expire_sync(struct hci_dev *hdev, void *data)
 {
 	u8 instance = *(u8 *)data;
 
-	kfree(data);
-
 	hci_clear_adv_instance_sync(hdev, NULL, instance, false);
 
 	if (list_empty(&hdev->adv_instances))
@@ -616,6 +614,12 @@ static int adv_timeout_expire_sync(struct hci_dev *hdev, void *data)
 	return 0;
 }
 
+static void adv_timeout_expire_destroy(struct hci_dev *hdev, void *data,
+				       int err)
+{
+	kfree(data);
+}
+
 static void adv_timeout_expire(struct work_struct *work)
 {
 	u8 *inst_ptr;
@@ -636,7 +640,9 @@ static void adv_timeout_expire(struct work_struct *work)
 		goto unlock;
 
 	*inst_ptr = hdev->cur_adv_instance;
-	hci_cmd_sync_queue(hdev, adv_timeout_expire_sync, inst_ptr, NULL);
+	if (hci_cmd_sync_queue(hdev, adv_timeout_expire_sync, inst_ptr,
+			       adv_timeout_expire_destroy) < 0)
+		kfree(inst_ptr);
 
 unlock:
 	hci_dev_unlock(hdev);
-- 
2.53.0



