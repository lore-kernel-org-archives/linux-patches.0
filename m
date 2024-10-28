Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC25C18DF7D;
	Mon, 28 Oct 2024 06:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098314; cv=none; b=CtrOI31r4ikjkgOA9N8pF2ullZNmvuIMbQVkjJoFXiadd/uuw6+jqRnss1clONE2SeupEfSsalPnHzmHpKaXPgmBsXnoCtRox3Vq8RyrOU8IM7aTiOZpJwKqy1gf9VoU7H3vL70Gc+RTYb7tLFKz9kPubQkqvOQlSH/6VCeQuuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098314; c=relaxed/simple;
	bh=uoWiSB6CaoDRruGode2gRvKpgkQnPT96w0fUXLgnAC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgvL9IRkZUEigyumhbEJj4preNq4bBPWeXQfZ2H3bzeeLFctpq3QE0DKKNqVFcX2rl3qcX8pRh2Fp4Zghw/PTxTE1Ut587gP2HHgpmJr5E47tRy/OlHX76prmSUxyAYGUQXxf4sttzKyGyDBzN5mI3WOlH2HWqwzPNePvaiQcg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9iEgrgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9iEgrgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAB9C4CEC3;
	Mon, 28 Oct 2024 06:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098314;
	bh=uoWiSB6CaoDRruGode2gRvKpgkQnPT96w0fUXLgnAC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9iEgrgvtru+MXKB3bhc+x6l2eR8ipoFr5fSkS4Qyb9Z2cUrUAS+ns1V0gljninWZ
	 E1jaKvUJEDKjYcCa81U2XfzKJAGqJ7/Na7zmo/tg1btSmyIYHAzruiuPtjvW6kchf5
	 LatevzU3AflMh5cY1fZttLO8usO4+7/fj6DZnZyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 171/261] Bluetooth: hci_core: Disable works on hci_unregister_dev
Date: Mon, 28 Oct 2024 07:25:13 +0100
Message-ID: <20241028062316.280318850@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 989fa5171f005ecf63440057218d8aeb1795287d ]

This make use of disable_work_* on hci_unregister_dev since the hci_dev is
about to be freed new submissions are not disarable.

Fixes: 0d151a103775 ("Bluetooth: hci_core: cancel all works upon hci_unregister_dev()")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 24 +++++++++++++++---------
 net/bluetooth/hci_sync.c | 12 +++++++++---
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index b2f8f9c5b6106..6e07350817bec 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1644,12 +1644,12 @@ void hci_adv_instances_clear(struct hci_dev *hdev)
 	struct adv_info *adv_instance, *n;
 
 	if (hdev->adv_instance_timeout) {
-		cancel_delayed_work(&hdev->adv_instance_expire);
+		disable_delayed_work(&hdev->adv_instance_expire);
 		hdev->adv_instance_timeout = 0;
 	}
 
 	list_for_each_entry_safe(adv_instance, n, &hdev->adv_instances, list) {
-		cancel_delayed_work_sync(&adv_instance->rpa_expired_cb);
+		disable_delayed_work_sync(&adv_instance->rpa_expired_cb);
 		list_del(&adv_instance->list);
 		kfree(adv_instance);
 	}
@@ -2685,11 +2685,11 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	list_del(&hdev->list);
 	write_unlock(&hci_dev_list_lock);
 
-	cancel_work_sync(&hdev->rx_work);
-	cancel_work_sync(&hdev->cmd_work);
-	cancel_work_sync(&hdev->tx_work);
-	cancel_work_sync(&hdev->power_on);
-	cancel_work_sync(&hdev->error_reset);
+	disable_work_sync(&hdev->rx_work);
+	disable_work_sync(&hdev->cmd_work);
+	disable_work_sync(&hdev->tx_work);
+	disable_work_sync(&hdev->power_on);
+	disable_work_sync(&hdev->error_reset);
 
 	hci_cmd_sync_clear(hdev);
 
@@ -2796,8 +2796,14 @@ static void hci_cancel_cmd_sync(struct hci_dev *hdev, int err)
 {
 	bt_dev_dbg(hdev, "err 0x%2.2x", err);
 
-	cancel_delayed_work_sync(&hdev->cmd_timer);
-	cancel_delayed_work_sync(&hdev->ncmd_timer);
+	if (hci_dev_test_flag(hdev, HCI_UNREGISTER)) {
+		disable_delayed_work_sync(&hdev->cmd_timer);
+		disable_delayed_work_sync(&hdev->ncmd_timer);
+	} else  {
+		cancel_delayed_work_sync(&hdev->cmd_timer);
+		cancel_delayed_work_sync(&hdev->ncmd_timer);
+	}
+
 	atomic_set(&hdev->cmd_cnt, 1);
 
 	hci_cmd_sync_cancel_sync(hdev, err);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 40ccdef168d7d..ae7a5817883aa 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5131,9 +5131,15 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 
 	bt_dev_dbg(hdev, "");
 
-	cancel_delayed_work(&hdev->power_off);
-	cancel_delayed_work(&hdev->ncmd_timer);
-	cancel_delayed_work(&hdev->le_scan_disable);
+	if (hci_dev_test_flag(hdev, HCI_UNREGISTER)) {
+		disable_delayed_work(&hdev->power_off);
+		disable_delayed_work(&hdev->ncmd_timer);
+		disable_delayed_work(&hdev->le_scan_disable);
+	} else {
+		cancel_delayed_work(&hdev->power_off);
+		cancel_delayed_work(&hdev->ncmd_timer);
+		cancel_delayed_work(&hdev->le_scan_disable);
+	}
 
 	hci_cmd_sync_cancel_sync(hdev, ENODEV);
 
-- 
2.43.0



