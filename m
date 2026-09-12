Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D87274B46;
	Sat, 12 Sep 2026 14:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225111; cv=none; b=sIaJBKBhsDFYslzgY3MlsdwPDaJ1wjAxSoTBkbmf3hek4vTirBu0pjdvDNl/oCVNi8ZDHKITQ2ypuNaOYp7OUkhO55k5m9p2dqFtQzAqiOMqzIb+fAE5h10Hx9G2uzYUZrXugg0rAyhdCW/VhVy+vh5zQdr/OV+5ag7SlE8xs64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225111; c=relaxed/simple;
	bh=c/0HskSS3Y6QARp7Mi4OOlpjNp9OQfO+nMnnIEiBHv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qViSJvmOx6XSBntKzMoJh9WkXkNiKfSwxQTBhrRl4N333abTvQaSVZbYDWbp/NSGAZ7Vq5nQm5vi9Z4YFjH273M18/04ST4sCtSdPAGGoEwXbW1dNSGyDmmxAtUNnTFnRxCzWC9QAia7/T9APP4CiBykZ1GlUqwjIkR2J9UC2wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAbpXTgI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAbpXTgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1727A1F000FF;
	Sat, 12 Sep 2026 14:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225109;
	bh=FFUOjlLeAeu6bJKZvSnrxiWIATcgg1BrAv/v13Xybrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rAbpXTgIomuIrHe0Z400JojYZJfbkGl86q+STlLXJqXStsZdMbGTC0feSwmZJ77Pz
	 1JcvT6uoK6UT/Fnj19zC8sVRdDFnh9+SsDVeXHCqnWmlKjO70w9Dhiv9OjSaX1UK7F
	 rEm8dLDLfnYDkd3FgNEL2vATqf3QHC6Ghv1HOE9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1129/1424] Bluetooth: hci_sync: free the advertising instance on the failure and cancel paths
Date: Sat, 12 Sep 2026 08:59:21 +0200
Message-ID: <20260912065632.583379083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 4daeae9299317..7e9a45350596d 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -611,8 +611,6 @@ static int adv_timeout_expire_sync(struct hci_dev *hdev, void *data)
 {
 	u8 instance = *(u8 *)data;
 
-	kfree(data);
-
 	hci_clear_adv_instance_sync(hdev, NULL, instance, false);
 
 	if (list_empty(&hdev->adv_instances))
@@ -621,6 +619,12 @@ static int adv_timeout_expire_sync(struct hci_dev *hdev, void *data)
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
@@ -641,7 +645,9 @@ static void adv_timeout_expire(struct work_struct *work)
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



