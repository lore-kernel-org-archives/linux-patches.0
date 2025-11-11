Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537204C97;
	Tue, 11 Nov 2025 00:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822200; cv=none; b=bKYDEjum4DWWyPKQsUc8W4uzSU3D+MCYSyHwzthEUWoXnh+I8Q9FY9fSPhHJ2TXU+/bGDQ7hMbSD925GRpL4m5VGC3Av/jCmjyx90enaa7TpDA5//gm3JwYX+hfR+boogHNKeIqbYYrLASDgIACLcV7z1U04Oxq8MXnipt7Kh08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822200; c=relaxed/simple;
	bh=3GaKkF62YxlI+alECGu7yJ+1r+4k8+dQcoJ0iYayyBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItWsr+51VsJNUIainZsJk96pzb8Dq28zkeY4PTUgB4VdP2+38JuZ5o1ODeuXmyTmt0PNvEclfH0zADPUvRd11U3pWqkOLr+L/pogo44SWK21gF+6PvtFF4NzJyy0mPKFSEPmi4H2K+sa5d7sh9OLV6ChUUCsRsaYYgoFtfDH7No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsbZHfOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsbZHfOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB70AC113D0;
	Tue, 11 Nov 2025 00:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822200;
	bh=3GaKkF62YxlI+alECGu7yJ+1r+4k8+dQcoJ0iYayyBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsbZHfOUlaXzOL+V600YL8FCZsyes/8pj1XfUJ9hC4qQgU3105G4pgUWqGszkFXhi
	 BqBPk/DJyScHmVMB42wkWBnXy9H+mo2SelrVLDER1SmUaxLoB8rGWVxY43slzXEklo
	 TnfmyPbicIWdgIUrB1nIPg18oEl6YrwnCnGEpF64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 057/849] Bluetooth: hci_sync: fix race in hci_cmd_sync_dequeue_once
Date: Tue, 11 Nov 2025 09:33:47 +0900
Message-ID: <20251111004537.813776646@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@163.com>

[ Upstream commit 09b0cd1297b4dbfe736aeaa0ceeab2265f47f772 ]

hci_cmd_sync_dequeue_once() does lookup and then cancel
the entry under two separate lock sections. Meanwhile,
hci_cmd_sync_work() can also delete the same entry,
leading to double list_del() and "UAF".

Fix this by holding cmd_sync_work_lock across both
lookup and cancel, so that the entry cannot be removed
concurrently.

Fixes: 505ea2b29592 ("Bluetooth: hci_sync: Add helper functions to manipulate cmd_sync queue")
Reported-by: Cen Zhang <zzzccc427@163.com>
Signed-off-by: Cen Zhang <zzzccc427@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index eefdb6134ca53..d160e5e1fe8ab 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -863,11 +863,17 @@ bool hci_cmd_sync_dequeue_once(struct hci_dev *hdev,
 {
 	struct hci_cmd_sync_work_entry *entry;
 
-	entry = hci_cmd_sync_lookup_entry(hdev, func, data, destroy);
-	if (!entry)
+	mutex_lock(&hdev->cmd_sync_work_lock);
+
+	entry = _hci_cmd_sync_lookup_entry(hdev, func, data, destroy);
+	if (!entry) {
+		mutex_unlock(&hdev->cmd_sync_work_lock);
 		return false;
+	}
 
-	hci_cmd_sync_cancel_entry(hdev, entry);
+	_hci_cmd_sync_cancel_entry(hdev, entry, -ECANCELED);
+
+	mutex_unlock(&hdev->cmd_sync_work_lock);
 
 	return true;
 }
-- 
2.51.0



