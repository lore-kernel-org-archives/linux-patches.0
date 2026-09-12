Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4B1372B57;
	Sat, 12 Sep 2026 12:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217672; cv=none; b=U9PyuxCKUrqKqnhUU7fbWkC49ch/CYXvuYiDpGrg9lBQOh5M5PNwhyBEV2EvpAVB/5XKpkI97ji2QV9hC3p+HL41E4bBVflyF7RClhnVYO07M2ZWOvrzv5d0Xid926lArgVPMHKQx0iestdatzaRYiR0s2ft+8tfCmmckdBvDF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217672; c=relaxed/simple;
	bh=F/p3eRfiY9lcG4CvHWHg9/FttT50aPylsIswM/IittQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRzpaa79XW2N9ozPsrGh/YeOU/lxEXNjXBxZuD6dt9wf+Emv5dr+/tbyzPfzt8bs8evlYQUtOiVNqSnJEWFOJbYaENc6rl/G0ty94TsS6eJLU/h7tXmSmVpwGYHPTqi4zggYzlDIOAiHoi3ev6Soi5ddASLB8oEkwspyErfhNi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJilJckp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJilJckp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76A51F000FF;
	Sat, 12 Sep 2026 12:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217671;
	bh=xDTv8DEI8QpeJcjxunjFswGeRcVmiqHClt0RydVfYFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJilJckpgWYhhTPmomeUzzG1QcCIYrmyy2+OgzMYiAw7Or0YbgTjL7XeV8ObAYp5O
	 bjqm/ePuyzgdwtXQdQtwbbmVuUofHEKR38mXE99YK1kpfWba1OnUxumS0qI7DB4dMM
	 FdYbBHFr2+6mFDR62ocS4evdg8oNUEZv4URN3yBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0988/1376] Bluetooth: hci_sync: free the advertising instance on the failure and cancel paths
Date: Sat, 12 Sep 2026 08:56:54 +0200
Message-ID: <20260912065629.586906441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index cb6889ed9e0da..cc2b0b85426f3 100644
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



