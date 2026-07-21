Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D8546AA71;
	Tue, 21 Jul 2026 15:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648202; cv=none; b=otZ4i3dtgGrUKBfz0N41ZQeSwkPXpbrz0YSmjVJ/Uo5FiOlKFJLs+phits7Tf93+SmrpUiLYGoOtIhUrVHdDgFsll3X38VhPOi6xvIWcfsaJ6ghJOeGm7WkLh/JF0ZOPMVUnfhj+tXSLjAgco/pkknPqT4qFlVS2GKZb0u1vBlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648202; c=relaxed/simple;
	bh=cwFKhvckrIsVNDDKEF3hTngpVCohv1dvhDZ5Rvh13dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNm72gMiHvIbmJigIrNFyjWEKLCg/xeAEaZF5id9YWxZ8x/Wbdv67LGSkpg/pPPp75NX9wpL9JXNGAbuyMCiEHUc2CiArrQtUNkhprQDDojgLi21sxPR6KACuga64ocYlatLNK09MUiP0gNvxXplCf3m2aw4c16wAy768FBl9zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzrQJXkZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzrQJXkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8915A1F000E9;
	Tue, 21 Jul 2026 15:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648201;
	bh=roskZvoyP/xeRCSYKsrw01wtgqiZLIZ6yn1kDVG1vZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tzrQJXkZF/4C+WC8p9q6uXyaePJFpf2l2i7/nvvEJyzvKnQY+2gD2azRweaOugkSd
	 HL46+V1gkxFLkKuq446ZwTvGA+yR4yq1oPju375QhSpf95sA7XiNgqPEEwqCOPqKCg
	 qhlnYlIfqb0LehlbhpYTZDdmm7QPZwckg71BDA4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Zhang <wei.zhang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0110/2077] wifi: ath11k: cancel SSR work items during PCI shutdown
Date: Tue, 21 Jul 2026 16:56:23 +0200
Message-ID: <20260721152555.289919107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Zhang <wei.zhang@oss.qualcomm.com>

[ Upstream commit 8c79aac429b583301f387374ff37c59be671df87 ]

A reboot can crash the kernel if it overlaps with WLAN firmware crash
recovery (SSR). The crash is a NULL pointer dereference in the MHI teardown
path while freeing DMA-backed MHI contexts.

Simplified trace:
  dma_free_attrs
  mhi_deinit_dev_ctxt [mhi]
  ath11k_pci_power_down [ath11k_pci]
  ath11k_pci_shutdown [ath11k_pci]
  device_shutdown
  kernel_restart

On the host side, SSR is driven by the MHI RDDM callback, which queues
reset_work to perform device recovery. reset_work power-cycles the device
by calling ath11k_hif_power_down() followed by ath11k_hif_power_up(). The
power-down phase deinitializes MHI and frees DMA resources.

Shutdown/reboot runs fully asynchronously with this RDDM-driven SSR
recovery flow. As a result, the shutdown path
(ath11k_pci_shutdown() -> ath11k_pci_power_down()) can race with the SSR
recovery sequence.

Fix this by canceling SSR-related work items during PCI shutdown, marking
the device as unregistering, and serializing the RDDM callback path that
checks and queues reset_work. This ensures that no new SSR recovery work
can be queued once teardown has started, and that any in-flight recovery
work is fully synchronized before device power-down, preventing MHI
teardown and DMA resource freeing from running more than once.

Note: This issue only affects PCI/MHI-based devices. AHB-based ath11k
devices do not queue reset_work in normal SSR flows.

Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-04866.5-QCAHSPSWPL_V1_V2_SILICONZ_IOE-1

Fixes: 13da397f884d ("ath11k: add support for device recovery for QCA6390/WCN6855")
Fixes: 5edbb148bc57 ("wifi: ath11k: Add firmware coredump collection support")
Signed-off-by: Wei Zhang <wei.zhang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260404043050.3433754-1-wei.zhang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mhi.c | 4 +++-
 drivers/net/wireless/ath/ath11k/pci.c | 8 ++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index f994233df2bb94..a6c9ff112c68f4 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2020 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
 #include <linux/msi.h>
@@ -282,8 +282,10 @@ static void ath11k_mhi_op_status_cb(struct mhi_controller *mhi_cntrl,
 			break;
 		}
 
+		spin_lock_bh(&ab->base_lock);
 		if (!(test_bit(ATH11K_FLAG_UNREGISTERING, &ab->dev_flags)))
 			queue_work(ab->workqueue_aux, &ab->reset_work);
+		spin_unlock_bh(&ab->base_lock);
 
 		break;
 	default:
diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 7114eca8810dbf..35bb9e7a63a207 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -1210,6 +1210,14 @@ static void ath11k_pci_shutdown(struct pci_dev *pdev)
 	struct ath11k_pci *ab_pci = ath11k_pci_priv(ab);
 
 	ath11k_pci_set_irq_affinity_hint(ab_pci, NULL);
+
+	spin_lock_bh(&ab->base_lock);
+	set_bit(ATH11K_FLAG_UNREGISTERING, &ab->dev_flags);
+	spin_unlock_bh(&ab->base_lock);
+
+	cancel_work_sync(&ab->reset_work);
+	cancel_work_sync(&ab->dump_work);
+
 	ath11k_pci_power_down(ab, false);
 }
 
-- 
2.53.0



