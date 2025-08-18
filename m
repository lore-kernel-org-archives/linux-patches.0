Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EB7321F24;
	Mon, 18 Aug 2025 13:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523792; cv=none; b=MdAZ19Gweex4jKYWSH7snMTEBOYm3sgWmVwu4Il0np8sDr74dKO0FQQqqoyRqAoyKedhg5EoKGD/GhrelqXW+Nx1qla28k0X2HOhfr3OvcdiOOTVKS5oMvV6/lh+RMru3iWlBOktRvJeXKtV7zeyur8czbxyw3Iq6f5Iu2IpUSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523792; c=relaxed/simple;
	bh=0nznBdUOk7frE/5TrK4yPAqAzplXQ//k6yR6OEKGgd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stlEzywEHP2GMlOFdJpZBa6FqgC4c7BXsnlsFTfx9nGU7FtbYJGJWHHl7ovYm+Tqr85NwD4K/hDmQCgCtm+kV21FrjlDlOMXK1g80C7aMnHz8zXtzQw5dLpCxMCuci82UDKIfjbr0GD90reRlhLopsfASeyd4MZT76n6oGgshqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NaBAr4jm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NaBAr4jm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDA8C4CEEB;
	Mon, 18 Aug 2025 13:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523792;
	bh=0nznBdUOk7frE/5TrK4yPAqAzplXQ//k6yR6OEKGgd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NaBAr4jmpjca6hjH0rd5Ot5mDhxbY7E55jY95uK1wF2a7y6IgckRXD9XafHrn4TR3
	 4wGMLDiH9cFXm26Gi00TOca2Ee8fLntNWYqhDbq+4fQ3SpLOpy8B5iu0/rJR79Y3S6
	 Oz/FLvybQfhrDjO/FJLJ2RDbRMIZ7SuAJQmSRud4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 274/515] wifi: ath10k: shutdown driver when hardware is unreliable
Date: Mon, 18 Aug 2025 14:44:20 +0200
Message-ID: <20250818124508.967978465@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kang Yang <kang.yang@oss.qualcomm.com>

[ Upstream commit c256a94d1b1b15109740306f7f2a7c2173e12072 ]

In rare cases, ath10k may lose connection with the PCIe bus due to
some unknown reasons, which could further lead to system crashes during
resuming due to watchdog timeout:

ath10k_pci 0000:01:00.0: wmi command 20486 timeout, restarting hardware
ath10k_pci 0000:01:00.0: already restarting
ath10k_pci 0000:01:00.0: failed to stop WMI vdev 0: -11
ath10k_pci 0000:01:00.0: failed to stop vdev 0: -11
ieee80211 phy0: PM: **** DPM device timeout ****
Call Trace:
 panic+0x125/0x315
 dpm_watchdog_set+0x54/0x54
 dpm_watchdog_handler+0x57/0x57
 call_timer_fn+0x31/0x13c

At this point, all WMI commands will timeout and attempt to restart
device. So set a threshold for consecutive restart failures. If the
threshold is exceeded, consider the hardware is unreliable and all
ath10k operations should be skipped to avoid system crash.

fail_cont_count and pending_recovery are atomic variables, and
do not involve complex conditional logic. Therefore, even if recovery
check and reconfig complete are executed concurrently, the recovery
mechanism will not be broken.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1

Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20250623022731.509-1-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 48 +++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/core.h | 11 ++++--
 drivers/net/wireless/ath/ath10k/mac.c  |  7 +++-
 drivers/net/wireless/ath/ath10k/wmi.c  |  6 ++++
 4 files changed, 63 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 6d336e39d673..1adc35e37f40 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2491,12 +2491,50 @@ static int ath10k_init_hw_params(struct ath10k *ar)
 	return 0;
 }
 
+static bool ath10k_core_needs_recovery(struct ath10k *ar)
+{
+	long time_left;
+
+	/* Sometimes the recovery will fail and then the next all recovery fail,
+	 * so avoid infinite recovery.
+	 */
+	if (atomic_read(&ar->fail_cont_count) >= ATH10K_RECOVERY_MAX_FAIL_COUNT) {
+		ath10k_err(ar, "consecutive fail %d times, will shutdown driver!",
+			   atomic_read(&ar->fail_cont_count));
+		ar->state = ATH10K_STATE_WEDGED;
+		return false;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "total recovery count: %d", ++ar->recovery_count);
+
+	if (atomic_read(&ar->pending_recovery)) {
+		/* Sometimes it happened another recovery work before the previous one
+		 * completed, then the second recovery work will destroy the previous
+		 * one, thus below is to avoid that.
+		 */
+		time_left = wait_for_completion_timeout(&ar->driver_recovery,
+							ATH10K_RECOVERY_TIMEOUT_HZ);
+		if (time_left) {
+			ath10k_warn(ar, "previous recovery succeeded, skip this!\n");
+			return false;
+		}
+
+		/* Record the continuous recovery fail count when recovery failed. */
+		atomic_inc(&ar->fail_cont_count);
+
+		/* Avoid having multiple recoveries at the same time. */
+		return false;
+	}
+
+	atomic_inc(&ar->pending_recovery);
+
+	return true;
+}
+
 void ath10k_core_start_recovery(struct ath10k *ar)
 {
-	if (test_and_set_bit(ATH10K_FLAG_RESTARTING, &ar->dev_flags)) {
-		ath10k_warn(ar, "already restarting\n");
+	if (!ath10k_core_needs_recovery(ar))
 		return;
-	}
 
 	queue_work(ar->workqueue, &ar->restart_work);
 }
@@ -2532,6 +2570,8 @@ static void ath10k_core_restart(struct work_struct *work)
 	struct ath10k *ar = container_of(work, struct ath10k, restart_work);
 	int ret;
 
+	reinit_completion(&ar->driver_recovery);
+
 	set_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
 
 	/* Place a barrier to make sure the compiler doesn't reorder
@@ -2596,8 +2636,6 @@ static void ath10k_core_restart(struct work_struct *work)
 	if (ret)
 		ath10k_warn(ar, "failed to send firmware crash dump via devcoredump: %d",
 			    ret);
-
-	complete(&ar->driver_recovery);
 }
 
 static void ath10k_core_set_coverage_class_work(struct work_struct *work)
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 446dca74f06a..85e16c945b5c 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -4,6 +4,7 @@
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
  * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
 #ifndef _CORE_H_
@@ -87,6 +88,8 @@
 				  IEEE80211_IFACE_SKIP_SDATA_NOT_IN_DRIVER)
 #define ATH10K_ITER_RESUME_FLAGS (IEEE80211_IFACE_ITER_RESUME_ALL |\
 				  IEEE80211_IFACE_SKIP_SDATA_NOT_IN_DRIVER)
+#define ATH10K_RECOVERY_TIMEOUT_HZ			(5 * HZ)
+#define ATH10K_RECOVERY_MAX_FAIL_COUNT			4
 
 struct ath10k;
 
@@ -865,9 +868,6 @@ enum ath10k_dev_flags {
 	/* Per Station statistics service */
 	ATH10K_FLAG_PEER_STATS,
 
-	/* Indicates that ath10k device is during recovery process and not complete */
-	ATH10K_FLAG_RESTARTING,
-
 	/* protected by conf_mutex */
 	ATH10K_FLAG_NAPI_ENABLED,
 };
@@ -1211,6 +1211,11 @@ struct ath10k {
 	struct work_struct bundle_tx_work;
 	struct work_struct tx_complete_work;
 
+	atomic_t pending_recovery;
+	unsigned int recovery_count;
+	/* continuous recovery fail count */
+	atomic_t fail_cont_count;
+
 	/* cycle count is reported twice for each visited channel during scan.
 	 * access protected by data_lock
 	 */
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c61b95a928da..0a53ec55b46b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8139,7 +8139,12 @@ static void ath10k_reconfig_complete(struct ieee80211_hw *hw,
 		ath10k_info(ar, "device successfully recovered\n");
 		ar->state = ATH10K_STATE_ON;
 		ieee80211_wake_queues(ar->hw);
-		clear_bit(ATH10K_FLAG_RESTARTING, &ar->dev_flags);
+
+		/* Clear recovery state. */
+		complete(&ar->driver_recovery);
+		atomic_set(&ar->fail_cont_count, 0);
+		atomic_set(&ar->pending_recovery, 0);
+
 		if (ar->hw_params.hw_restart_disconnect) {
 			list_for_each_entry(arvif, &ar->arvifs, list) {
 				if (arvif->is_up && arvif->vdev_type == WMI_VDEV_TYPE_STA)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 5e061f7525a6..09066e6aca40 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
  * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
 #include <linux/skbuff.h>
@@ -1941,6 +1942,11 @@ int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id)
 	}
 
 	wait_event_timeout(ar->wmi.tx_credits_wq, ({
+		if (ar->state == ATH10K_STATE_WEDGED) {
+			ret = -ESHUTDOWN;
+			ath10k_dbg(ar, ATH10K_DBG_WMI,
+				   "drop wmi command %d, hardware is wedged\n", cmd_id);
+		}
 		/* try to send pending beacons first. they take priority */
 		ath10k_wmi_tx_beacons_nowait(ar);
 
-- 
2.39.5



