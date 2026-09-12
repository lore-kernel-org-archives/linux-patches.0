Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062F837A498;
	Sat, 12 Sep 2026 10:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210434; cv=none; b=YSkp8xQIQHm4Oc2w9cc4V8Z7+f0b+kANaBkRdFgppslG9I6v1PM/tLOZPyPLlrzACeepBpbqp9cqTTAhVqN3L/3kpSbd3nuIILpGWRm+kNLWdmoA6vl988bEDeNIqNX3ydvCGU+5ck8mW62AvyUpPrMwlhkEvk3cRQQA/wd7nck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210434; c=relaxed/simple;
	bh=Q8/BUUZBAZZVD0jAWGrlrXtspsflr5hERji6mYQd3CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Re5sGqOugBeP9StvOPXL1YHB0Cu8+j52W+cFvJen+V5yapeyDg/vnKUvlIy2SuinF6SKr7BidUmKT13bWRmw0ZY83DtYP+98l8ZhH0FhAQbu16HM9TnNTkxDVLYauSGqA9Xd+e7XXzdgJmGHTIthaMsLNiLdp7c8wl330AxWmQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDlw+iHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDlw+iHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF2B1F000FF;
	Sat, 12 Sep 2026 10:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210432;
	bh=AKSZPiKEO3elX9I5TG3aMojbqrjg/MUusqEeF/TYeRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZDlw+iHBTHFDZMQTek2COe5G5mrtv8nzVPmspV3XYi+BKX2GkwJORdr/4NHeP7FzQ
	 QF+yv6Tp/HyQAO4Ocs8I7p0yE8jUIrU8qXPNFQfuNFMRxhFv+n8XdCNztehqdKK9Fq
	 gBpxIM+Fz6XWFT6Npg3dzdLVAnXbkAP8Bzn7uMPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1026/1518] Bluetooth: hci_sync: free the advertising instance on the failure and cancel paths
Date: Sat, 12 Sep 2026 08:53:15 +0200
Message-ID: <20260912065646.660375780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 27261f8e904e4..be5886a7424f5 100644
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



