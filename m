Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD76270838;
	Mon, 23 Jun 2025 21:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712992; cv=none; b=YBiiLxUwF3p0brVIw8llo/J9kdv25JDOeEIuWh+fxZ/G81VeQAPogsrqnMu9IjIk/QD9HYpQCbiIbFXcacQc7IwLuxFqDhzOe+j4xR05r9MWzmaXuTwUOvp5eLFa4d84/OFyFT8lrKQk88jBjAsEVE+XiTKJcRohouFah2YwpF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712992; c=relaxed/simple;
	bh=eP72x9/b03hRRjaoufwFZH2t4qq98ZgF9CAnX05/UFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYNGqBZaI8o95XZqazcMu0VT3N1X7xuP5xj5da4MgCnDMR+n66bBXCsWilIh420u2AzPT5J9JyyEIbdzeiDQQuF3J0Dby9epLBVWY5Trg3g7EO/uUkPANYQxH99t6PH7xV+1URzBnKzUCd8lsDAxYCq/gS5P9b8DytaAE+lhy4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUkfmlpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUkfmlpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45908C4CEEA;
	Mon, 23 Jun 2025 21:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712992;
	bh=eP72x9/b03hRRjaoufwFZH2t4qq98ZgF9CAnX05/UFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUkfmlptu2CLp9C+5RT0aVF4l+MGFS/r99yn1eKCoaU9J9WlNhx/xRhT8+91iai1J
	 fna8XDryIP9pCIz3+OiUmWaEIJ9OVLTCeiVdMJMfIkTT/vVF+Fbo4RgAw3V89lLF8b
	 D1w8pelJZPNNNl8OSdSrPjACBsXBpRceG/0kYx40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gong <wgong@codeaurora.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/355] ath10k: add atomic protection for device recovery
Date: Mon, 23 Jun 2025 15:05:17 +0200
Message-ID: <20250623130630.248176479@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Gong <wgong@codeaurora.org>

[ Upstream commit 5dadbe4e3718fb2214199b6dc7af1077fe14bf32 ]

When it has more than one restart_work queued meanwhile, the 2nd
restart_work is very easy to break the 1st restart work and lead
recovery fail.

Add a flag to allow only one restart work running untill
device successfully recovered.

It already has flag ATH10K_FLAG_CRASH_FLUSH, but it can not use this
flag again, because it is clear in ath10k_core_start. The function
ieee80211_reconfig(called by ieee80211_restart_work) of mac80211 do
many things and drv_start(call to ath10k_core_start) is 1st thing,
when drv_start complete, it does not mean restart complete. So it
add new flag and clear it in ath10k_reconfig_complete, because it
is the last thing called from drv_reconfig_complete of function
ieee80211_reconfig, after it, the restart process finished.

Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00049

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/010101746bead6a0-d5e97c66-dedd-4b92-810e-c2e4840fafc9-000000@us-west-2.amazonses.com
Stable-dep-of: 1650d32b92b0 ("ath10k: snoc: fix unbalanced IRQ enable in crash recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c  | 11 +++++++++++
 drivers/net/wireless/ath/ath10k/core.h  |  4 ++++
 drivers/net/wireless/ath/ath10k/debug.c |  6 +++---
 drivers/net/wireless/ath/ath10k/mac.c   |  1 +
 drivers/net/wireless/ath/ath10k/pci.c   |  2 +-
 drivers/net/wireless/ath/ath10k/sdio.c  |  6 +++---
 drivers/net/wireless/ath/ath10k/snoc.c  |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.c   |  2 +-
 8 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index d03a36c45f9f3..8ce5fbfcee972 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2292,6 +2292,17 @@ static int ath10k_init_hw_params(struct ath10k *ar)
 	return 0;
 }
 
+void ath10k_core_start_recovery(struct ath10k *ar)
+{
+	if (test_and_set_bit(ATH10K_FLAG_RESTARTING, &ar->dev_flags)) {
+		ath10k_warn(ar, "already restarting\n");
+		return;
+	}
+
+	queue_work(ar->workqueue, &ar->restart_work);
+}
+EXPORT_SYMBOL(ath10k_core_start_recovery);
+
 static void ath10k_core_restart(struct work_struct *work)
 {
 	struct ath10k *ar = container_of(work, struct ath10k, restart_work);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index b50ab9e229dc5..b471c0ccf006b 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -857,6 +857,9 @@ enum ath10k_dev_flags {
 
 	/* Per Station statistics service */
 	ATH10K_FLAG_PEER_STATS,
+
+	/* Indicates that ath10k device is during recovery process and not complete */
+	ATH10K_FLAG_RESTARTING,
 };
 
 enum ath10k_cal_mode {
@@ -1312,6 +1315,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		      const struct ath10k_fw_components *fw_components);
 int ath10k_wait_for_suspend(struct ath10k *ar, u32 suspend_opt);
 void ath10k_core_stop(struct ath10k *ar);
+void ath10k_core_start_recovery(struct ath10k *ar);
 int ath10k_core_register(struct ath10k *ar,
 			 const struct ath10k_bus_params *bus_params);
 void ath10k_core_unregister(struct ath10k *ar);
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index ab737177a86bf..64d48d8cce50c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -583,7 +583,7 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
 		ret = ath10k_debug_fw_assert(ar);
 	} else if (!strcmp(buf, "hw-restart")) {
 		ath10k_info(ar, "user requested hw restart\n");
-		queue_work(ar->workqueue, &ar->restart_work);
+		ath10k_core_start_recovery(ar);
 		ret = 0;
 	} else {
 		ret = -EINVAL;
@@ -2005,7 +2005,7 @@ static ssize_t ath10k_write_btcoex(struct file *file,
 		}
 	} else {
 		ath10k_info(ar, "restarting firmware due to btcoex change");
-		queue_work(ar->workqueue, &ar->restart_work);
+		ath10k_core_start_recovery(ar);
 	}
 
 	if (val)
@@ -2136,7 +2136,7 @@ static ssize_t ath10k_write_peer_stats(struct file *file,
 
 	ath10k_info(ar, "restarting firmware due to Peer stats change");
 
-	queue_work(ar->workqueue, &ar->restart_work);
+	ath10k_core_start_recovery(ar);
 	ret = count;
 
 exit:
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 323b6763cb0f5..5dd0239e9d51b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7969,6 +7969,7 @@ static void ath10k_reconfig_complete(struct ieee80211_hw *hw,
 		ath10k_info(ar, "device successfully recovered\n");
 		ar->state = ATH10K_STATE_ON;
 		ieee80211_wake_queues(ar->hw);
+		clear_bit(ATH10K_FLAG_RESTARTING, &ar->dev_flags);
 	}
 
 	mutex_unlock(&ar->conf_mutex);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 2c8f04b415c71..83ef0517f0991 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1774,7 +1774,7 @@ static void ath10k_pci_fw_dump_work(struct work_struct *work)
 
 	mutex_unlock(&ar->dump_mutex);
 
-	queue_work(ar->workqueue, &ar->restart_work);
+	ath10k_core_start_recovery(ar);
 }
 
 static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 418e40560f59f..2ccbb6b4f1b5b 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -562,7 +562,7 @@ static int ath10k_sdio_mbox_rx_alloc(struct ath10k *ar,
 				    ATH10K_HTC_MBOX_MAX_PAYLOAD_LENGTH);
 			ret = -ENOMEM;
 
-			queue_work(ar->workqueue, &ar->restart_work);
+			ath10k_core_start_recovery(ar);
 			ath10k_warn(ar, "exceeds length, start recovery\n");
 
 			goto err;
@@ -961,7 +961,7 @@ static int ath10k_sdio_mbox_read_int_status(struct ath10k *ar,
 	ret = ath10k_sdio_read(ar, MBOX_HOST_INT_STATUS_ADDRESS,
 			       irq_proc_reg, sizeof(*irq_proc_reg));
 	if (ret) {
-		queue_work(ar->workqueue, &ar->restart_work);
+		ath10k_core_start_recovery(ar);
 		ath10k_warn(ar, "read int status fail, start recovery\n");
 		goto out;
 	}
@@ -2505,7 +2505,7 @@ void ath10k_sdio_fw_crashed_dump(struct ath10k *ar)
 
 	ath10k_sdio_enable_intrs(ar);
 
-	queue_work(ar->workqueue, &ar->restart_work);
+	ath10k_core_start_recovery(ar);
 }
 
 static int ath10k_sdio_probe(struct sdio_func *func,
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index f7ee1032b1729..ee5b16d79f14f 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1315,7 +1315,7 @@ int ath10k_snoc_fw_indication(struct ath10k *ar, u64 type)
 	switch (type) {
 	case ATH10K_QMI_EVENT_FW_READY_IND:
 		if (test_bit(ATH10K_SNOC_FLAG_REGISTERED, &ar_snoc->flags)) {
-			queue_work(ar->workqueue, &ar->restart_work);
+			ath10k_core_start_recovery(ar);
 			break;
 		}
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index dc5d9f9be34f0..c9a74f3e2e601 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1957,7 +1957,7 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
 	if (ret == -EAGAIN) {
 		ath10k_warn(ar, "wmi command %d timeout, restarting hardware\n",
 			    cmd_id);
-		queue_work(ar->workqueue, &ar->restart_work);
+		ath10k_core_start_recovery(ar);
 	}
 
 	return ret;
-- 
2.39.5



