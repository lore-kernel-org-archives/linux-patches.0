Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B37441A4E5;
	Sat, 12 Sep 2026 08:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202678; cv=none; b=uNvkBh0oTcgD5eI9oSZGvrl3jFDOmmb4MYwxAPrSoVnktfM6499SyIwD9rXetVlpQS9jaA3fzWUh0uU73mn80vP+RBQz0eZh+9bWfFnAEVCPzX26HrmANtYOt/LheSxVFLwBFOd1wuUakgG+k0aWEqiPW6EM28a08nMI/RxuzoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202678; c=relaxed/simple;
	bh=AOk50gItfPRR50dNwSAF2WQCgleExhey7r4ckAPFYyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lt17eu4zsym42G3g9Hci4dmosODkznA7ZqZcwk7DUQANdaSeZexRYFFQEWixGt0oQu4L0W5GqQtu5702udn1M4zH1oLy7UzTfktOMs64rQlxHZnwNYsIoaI0W+Ofs51U1ERvW1dAGC13IDk+jsR0E09MP6oF7kWwT10m0Lz7n3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pc76Tbxw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pc76Tbxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEEA1F000FF;
	Sat, 12 Sep 2026 08:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202676;
	bh=UnFgFlY+Y2E8n7HZomOC9xzi6pp1PYb0+6QgJC+8olc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pc76Tbxw2ZzmtBKohlDygHZl9vv9OmarRDTpXw1k5LIS3sVDj9xhNKcby+917fe2A
	 XR6Wk8bZDt86KfbDo188Y75fWHPQD5Ada0BC1ZHwiFUkBGavP1a0hn7hjfL3U0Mbxe
	 YwOcKkg5fcqkOepzroecl3FNPlSSV+XJm0HjxEWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1252/1815] Bluetooth: hci_sync: free the advertising instance on the failure and cancel paths
Date: Sat, 12 Sep 2026 08:50:02 +0200
Message-ID: <20260912065718.406158324@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index f44f02ddb94e5..e6ffeb2c60939 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -540,8 +540,6 @@ static int adv_timeout_expire_sync(struct hci_dev *hdev, void *data)
 {
 	u8 instance = *(u8 *)data;
 
-	kfree(data);
-
 	hci_clear_adv_instance_sync(hdev, NULL, instance, false);
 
 	if (list_empty(&hdev->adv_instances))
@@ -550,6 +548,12 @@ static int adv_timeout_expire_sync(struct hci_dev *hdev, void *data)
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
@@ -570,7 +574,9 @@ static void adv_timeout_expire(struct work_struct *work)
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



