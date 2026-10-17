Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE26384CED;
	Sat, 17 Oct 2026 16:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254535; cv=none; b=MzhVrfDPW4su8zM7M7Ni/7x6TMPWS+I9Ddxfr9w2YSHC4ueX9x3N375PjaiuTjN5dP7xcK30MPg3UHT1OzfnuZyxk0ewmicYOXWAh/eHTeNNxpmdAD74mxBHFHVhLhCjpZ17zbyZTLkJKFE1dcAY47gNwn+JjZF17LMhJ+Ga0dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254535; c=relaxed/simple;
	bh=0kHMBJyVwnkI8p9onWPEf7svFMIVx59g6nYdNqGodXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITJ5rQmOn7o5OYN06hUy+BrtmRa4AJ5JwJL2OteSUUMKDM0gSAgU4BE/6xeG+FyBlK0J8VrLohX4j7SA8ZC5RDDGObH77H5F3fEVgpIzo2SsJAQZPNVMbxm/fuwR1cfUni2u9ZHp+uR0zN3rZPlqWSnlUUlLQsAPRXqLZ/enldc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMvGqYAF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMvGqYAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3158B1F000C4;
	Sat, 17 Oct 2026 16:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254534;
	bh=LoqLeEnRIALg3vKrL6ITT37BHh4rt4YbOMPp449PVKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DMvGqYAFh572aXtUMQYnmIIEaHEAHAhWGssY9Q7GGZzYhpyQhS5pWKJ52x2k1Htl8
	 Qpa2HzLpjyXOiAGbmjYhAx60+ihYhBE1ePG+0gmVZO/wc3GziULIEWw1qrCHKrZwNh
	 fbt+e2Q9m39EJOnnxd+GS3noVQzr+0qVg4zhB3XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Zhang <wei.zhang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 480/869] wifi: ath11k: cancel SSR work items during PCI shutdown
Date: Sat, 17 Oct 2026 17:55:21 +0200
Message-ID: <20261017160049.428085024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 drivers/net/wireless/ath/ath11k/pci.c | 7 +++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index 9c2200cc0348b..593f24602fc45 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2020 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
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
index 6b0e52a6fb89b..18957d450080e 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -1023,6 +1023,13 @@ static void ath11k_pci_shutdown(struct pci_dev *pdev)
 	struct ath11k_pci *ab_pci = ath11k_pci_priv(ab);
 
 	ath11k_pci_set_irq_affinity_hint(ab_pci, NULL);
+
+	spin_lock_bh(&ab->base_lock);
+	set_bit(ATH11K_FLAG_UNREGISTERING, &ab->dev_flags);
+	spin_unlock_bh(&ab->base_lock);
+
+	cancel_work_sync(&ab->reset_work);
+
 	ath11k_pci_power_down(ab);
 }
 
-- 
2.53.0



