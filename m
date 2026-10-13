Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CB74FC342;
	Tue, 13 Oct 2026 12:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894483; cv=none; b=oVmXzEmKWxXEDbHvA/kv/74xnBtQDfcTog8RJiz6/E7j0BpD0y9tU5MZodLxHbEkPG/S4+clJacGOaRBUaYCVa85L/5QedGqtkdsW/UNy+h3rpQkBX0pLeHYR/BLUrHblgLoFf4l2an1xja6ea24OiVOk0+wvll2i8npdsl7oj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894483; c=relaxed/simple;
	bh=Uw9DmRRKFkwaPsBVcyl6Las23KpYkNSSbMvtLW/gLko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ED3sIhn95Sh4Gj05Bz3rWYFMz/OWMVRatp1V0Tn039rhqG3CezK92nCkV+clCbCQROi5I0zNhNVqASozIEtJv5vk/UQZ0y1PMos57wl+IEcCq7oAtz3PBW34ZLKtXLVBytqPBahiBc5p4GCeKKonRPS3B46uFOVP5Io5jzwraYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5KiRFHx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5KiRFHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BF11F00899;
	Tue, 13 Oct 2026 12:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894481;
	bh=/EKEVeqhUBdsc9ojOSIEs3ACTwVKu/DKanMGWa+lE4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b5KiRFHx8/pqIkcqnANknQbw7+pHxFudO5wlNvfPxuPu+fCTxo7hwvEWGuVkLZ6SH
	 vi1MPdCjTyGKYGkRjD0KfmfKBQIkQL+QVew0fb9rRXQzyxVpA+PqRLHPH+XbH+QqBO
	 8TBZagCZ1lLVk1hmPAWB7BQj1fQxW079QtEmjnIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingying Tang <yingying.tang@oss.qualcomm.com>,
	Joonhoe Kim <26rote@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 573/621] Revert "wifi: ath12k: add panic handler"
Date: Tue, 13 Oct 2026 13:39:28 +0200
Message-ID: <20261013112934.403471003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Yingying Tang <yingying.tang@oss.qualcomm.com>

[ Upstream commit 05165f7b3b9ab6817fe216c24f90755b7c5e15f3 ]

ath12k_core_panic_handler() is invoked via atomic_notifier_call_chain(),
which runs inside an RCU read-side critical section. The current code calls
ath12k_pci_sw_reset() synchronously from this context, which eventually
reaches mhi_device_get_sync() and schedule_timeout(), triggering a voluntary
context switch within RCU.

Call trace:
rcu_note_context_switch+0x4c4/0x508 (P)
__schedule+0xbc/0x1204
schedule+0x34/0x110
schedule_timeout+0x84/0x11c
__mhi_device_get_sync+0x164/0x228 [mhi]
mhi_device_get_sync+0x1c/0x3c [mhi]
ath12k_wifi7_pci_bus_wake_up+0x20/0x2c [ath12k_wifi7]
ath12k_pci_read32+0x58/0x350 [ath12k]
ath12k_pci_clear_dbg_registers+0x28/0xb8 [ath12k]
ath12k_pci_panic_handler+0x20/0x44 [ath12k] ath12k_core_panic_handler+0x28/0x3c [ath12k]
notifier_call_chain+0x78/0x1c0
atomic_notifier_call_chain+0x3c/0x5c

Revert change "wifi: ath12k: add panic handler" to avoid this issue.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Signed-off-by: Yingying Tang <yingying.tang@oss.qualcomm.com>
Tested-by: Joonhoe Kim <26rote@gmail.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Fixes: 809055628bce ("wifi: ath12k: add panic handler")
Link: https://patch.msgid.link/20260612032332.2278338-1-yingying.tang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c | 33 +-------------------------
 drivers/net/wireless/ath/ath12k/core.h |  3 ---
 drivers/net/wireless/ath/ath12k/hif.h  |  9 -------
 drivers/net/wireless/ath/ath12k/pci.c  |  8 -------
 4 files changed, 1 insertion(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index a02db6fd23549..dc969b2516ea0 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1733,29 +1733,6 @@ int ath12k_core_pre_init(struct ath12k_base *ab)
 	return 0;
 }
 
-static int ath12k_core_panic_handler(struct notifier_block *nb,
-				     unsigned long action, void *data)
-{
-	struct ath12k_base *ab = container_of(nb, struct ath12k_base,
-					      panic_nb);
-
-	return ath12k_hif_panic_handler(ab);
-}
-
-static int ath12k_core_panic_notifier_register(struct ath12k_base *ab)
-{
-	ab->panic_nb.notifier_call = ath12k_core_panic_handler;
-
-	return atomic_notifier_chain_register(&panic_notifier_list,
-					      &ab->panic_nb);
-}
-
-static void ath12k_core_panic_notifier_unregister(struct ath12k_base *ab)
-{
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &ab->panic_nb);
-}
-
 static inline
 bool ath12k_core_hw_group_create_ready(struct ath12k_hw_group *ag)
 {
@@ -2148,18 +2125,13 @@ int ath12k_core_init(struct ath12k_base *ab)
 	struct ath12k_hw_group *ag;
 	int ret;
 
-	ret = ath12k_core_panic_notifier_register(ab);
-	if (ret)
-		ath12k_warn(ab, "failed to register panic handler: %d\n", ret);
-
 	mutex_lock(&ath12k_hw_group_mutex);
 
 	ag = ath12k_core_hw_group_assign(ab);
 	if (!ag) {
 		mutex_unlock(&ath12k_hw_group_mutex);
 		ath12k_warn(ab, "unable to get hw group\n");
-		ret = -ENODEV;
-		goto err_unregister_notifier;
+		return -ENODEV;
 	}
 
 	mutex_unlock(&ath12k_hw_group_mutex);
@@ -2184,8 +2156,6 @@ int ath12k_core_init(struct ath12k_base *ab)
 
 err_unassign_hw_group:
 	ath12k_core_hw_group_unassign(ab);
-err_unregister_notifier:
-	ath12k_core_panic_notifier_unregister(ab);
 
 	return ret;
 }
@@ -2194,7 +2164,6 @@ void ath12k_core_deinit(struct ath12k_base *ab)
 {
 	ath12k_core_hw_group_destroy(ab->ag);
 	ath12k_core_hw_group_unassign(ab);
-	ath12k_core_panic_notifier_unregister(ab);
 }
 
 void ath12k_core_free(struct ath12k_base *ab)
diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index 93cdfcaf95bd2..67ddf84a8a55f 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -15,7 +15,6 @@
 #include <linux/ctype.h>
 #include <linux/firmware.h>
 #include <linux/of_reserved_mem.h>
-#include <linux/panic_notifier.h>
 #include <linux/average.h>
 #include <linux/of.h>
 #include "qmi.h"
@@ -1221,8 +1220,6 @@ struct ath12k_base {
 
 #endif /* CONFIG_ACPI */
 
-	struct notifier_block panic_nb;
-
 	struct ath12k_hw_group *ag;
 	struct ath12k_wsi_info wsi_info;
 	enum ath12k_firmware_mode fw_mode;
diff --git a/drivers/net/wireless/ath/ath12k/hif.h b/drivers/net/wireless/ath/ath12k/hif.h
index e8840fab6061c..42bb00c13ef3d 100644
--- a/drivers/net/wireless/ath/ath12k/hif.h
+++ b/drivers/net/wireless/ath/ath12k/hif.h
@@ -30,7 +30,6 @@ struct ath12k_hif_ops {
 	void (*ce_irq_enable)(struct ath12k_base *ab);
 	void (*ce_irq_disable)(struct ath12k_base *ab);
 	void (*get_ce_msi_idx)(struct ath12k_base *ab, u32 ce_id, u32 *msi_idx);
-	int (*panic_handler)(struct ath12k_base *ab);
 	void (*coredump_download)(struct ath12k_base *ab);
 };
 
@@ -149,14 +148,6 @@ static inline void ath12k_hif_power_down(struct ath12k_base *ab, bool is_suspend
 	ab->hif.ops->power_down(ab, is_suspend);
 }
 
-static inline int ath12k_hif_panic_handler(struct ath12k_base *ab)
-{
-	if (!ab->hif.ops->panic_handler)
-		return NOTIFY_DONE;
-
-	return ab->hif.ops->panic_handler(ab);
-}
-
 static inline void ath12k_hif_coredump_download(struct ath12k_base *ab)
 {
 	if (ab->hif.ops->coredump_download)
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 37f41635d3b00..c26c41f62feb6 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -1523,13 +1523,6 @@ void ath12k_pci_power_down(struct ath12k_base *ab, bool is_suspend)
 	ath12k_pci_sw_reset(ab_pci->ab, false);
 }
 
-static int ath12k_pci_panic_handler(struct ath12k_base *ab)
-{
-	ath12k_pci_sw_reset(ab, false);
-
-	return NOTIFY_OK;
-}
-
 static const struct ath12k_hif_ops ath12k_pci_hif_ops = {
 	.start = ath12k_pci_start,
 	.stop = ath12k_pci_stop,
@@ -1547,7 +1540,6 @@ static const struct ath12k_hif_ops ath12k_pci_hif_ops = {
 	.ce_irq_enable = ath12k_pci_hif_ce_irq_enable,
 	.ce_irq_disable = ath12k_pci_hif_ce_irq_disable,
 	.get_ce_msi_idx = ath12k_pci_get_ce_msi_idx,
-	.panic_handler = ath12k_pci_panic_handler,
 #ifdef CONFIG_ATH12K_COREDUMP
 	.coredump_download = ath12k_pci_coredump_download,
 #endif
-- 
2.53.0



