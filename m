Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C84A322C88;
	Sun,  7 Jun 2026 10:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827856; cv=none; b=ruUjyMo5o4BqFYoOQQaMFN+sP4dWkqx1EUoZFql3DL3e39Rrzt41LHOlIDN1fdhOA8rTVCA306HjCtmQnHpi12tR+17Nz44si2ZfJNlQPoVIcyCPSXFvjwn9aN9S9FKFPZzUcQeIk6HP5f5lgJc0IjDBfqsPkcxIMXD2bRM2CUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827856; c=relaxed/simple;
	bh=nEU1xgtHO17d1bpVk8wwX9smIEptBxuJLVb+C3KF3FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjX7+344ucyAQNVi4X/Eq4BuOW4j/JAGoexgBObn/VnUErlxyUhf/LBEhVmzrdmYFbjp1vSCPkBW3u6+tKSEsqYOCifn523l+qERaujfMdRsm3uT0JKlzvZ7SAzWFyaTs2fKNtIRna9te+D/kpIt0WG754l8Pu5ZuO3M/w5Iex8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/UiSmvu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/UiSmvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA1E1F00893;
	Sun,  7 Jun 2026 10:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827855;
	bh=sHB/TECIDLHvyxcHncI1IJ7odrlf53dJPI/IRJd9htE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/UiSmvuPKRRvNw551rSgrNb63KDlySgzQF0YNly41ws1Zvt9+NUf900Ak3vKLeev
	 xJ/VrDOl5SdbpsbmDOpbsr5Jv4faMarI918xv9BCpiGXRmx3Y9lQxE3dq9eEbkrViT
	 aPpMsJsN6wVWlt3K3kKW1AhjTzmYchmSDl4opIs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heitor Alves de Siqueira <halves@igalia.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/315] Bluetooth: hci_sync: Set HCI_CMD_DRAIN_WORKQUEUE during device close
Date: Sun,  7 Jun 2026 11:57:49 +0200
Message-ID: <20260607095730.630733065@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Heitor Alves de Siqueira <halves@igalia.com>

[ Upstream commit 525daaea459fc215f432de1b8debbd9144bf97b0 ]

Since hci_dev_close_sync() can now be called during the reset path, we
should also set HCI_CMD_DRAIN_WORKQUEUE. This avoids queuing timeouts
while the hdev workqueue is being drained.

Fixes: 877afadad2dc ("Bluetooth: When HCI work queue is drained, only queue chained work")
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index f498ab28f1aa06..73e429c41e17b5 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5246,6 +5246,12 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 
 	bt_dev_dbg(hdev, "");
 
+	/* Set HCI_DRAIN_WORKQUEUE flag to prevent queuing work during
+	 * reset/close. See hci_cmd_work() and handle_cmd_cnt_and_timer().
+	 */
+	hci_dev_set_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);
+	synchronize_rcu();
+
 	if (hci_dev_test_flag(hdev, HCI_UNREGISTER)) {
 		disable_delayed_work(&hdev->power_off);
 		disable_delayed_work(&hdev->ncmd_timer);
@@ -5269,6 +5275,7 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 
 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
 		cancel_delayed_work_sync(&hdev->cmd_timer);
+		hci_dev_clear_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);
 		return err;
 	}
 
@@ -5368,6 +5375,7 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 	/* Clear flags */
 	hdev->flags &= BIT(HCI_RAW);
 	hci_dev_clear_volatile_flags(hdev);
+	hci_dev_clear_flag(hdev, HCI_CMD_DRAIN_WORKQUEUE);
 
 	memset(hdev->eir, 0, sizeof(hdev->eir));
 	memset(hdev->dev_class, 0, sizeof(hdev->dev_class));
-- 
2.53.0



