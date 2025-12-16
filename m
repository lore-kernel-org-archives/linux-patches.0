Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F4D35CB7D;
	Tue, 16 Dec 2025 12:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887021; cv=none; b=N2ThH4OtsUoHOA1G+B2Qv0DquswV62k0hWUScxKE2km0APHQAhKE02DVf1eiC85Vn9dLFS7g7VUzl6obrMmZmPvxV7jSVDCT77dZZcZsxFxUsMoqvDNcJuF94oGGVTjxXi6M/YgxgpbzVuIOUZcPyrl0ESgpyGpqD5HKEmRtM0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887021; c=relaxed/simple;
	bh=M7iNPnfhtrj+xcer/j4jJ3bWmu3pxvIZgP+1iFYlaW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0aJv4st2D8qNbTY8bYYigAM1R0MePi/BF3r+DASzvYY36szc5+jIC3s6PpS+6MZSmQD3DcQ5i8uuQvxp0aPLCRbI8LsOrSHKGfCP8a0BVtt8L88O16wbsZnrRP5fOVH4JdlAbsPhIILOkvcCA3vBtxliqF9NwMFQPig8qVvxG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9flkoB5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9flkoB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B297C4CEF1;
	Tue, 16 Dec 2025 12:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887021;
	bh=M7iNPnfhtrj+xcer/j4jJ3bWmu3pxvIZgP+1iFYlaW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9flkoB5HpiazGsAuW5gFDwc6zOWNjTMYphH2L4WkfjuyquEN9SrfcY9/KfzMhGZa
	 tdhXrLbmxEU9TIS7HbEtwYUMwus7olCgP79Ko6nv0WLvgEVU8fqDHPeREg8EpUf/JQ
	 5rVvrjSbEiIBvtm8RUVsDay0epWM2uGRVz8pJ50c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 096/614] wifi: ath12k: restore register window after global reset
Date: Tue, 16 Dec 2025 12:07:43 +0100
Message-ID: <20251216111404.798101371@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit a41281f6518e485220d180a6031d302a736fc463 ]

Hardware target implements an address space larger than that PCI BAR can
map. In order to be able to access the whole target address space, the
BAR space is split into 4 segments, of which the last 3, called windows,
can be dynamically mapped to the desired area. This is achieved by
updating WINDOW_REG_ADDRESS register with appropriate window value.
Currently each time when accessing a register that beyond WINDOW_START,
host calculates the window value and caches it after window update,
this way next time when accessing a register falling in the same window,
host knows that the window is already good hence no additional update
needed.

However this mechanism breaks after global reset is triggered in
ath12k_pci_soc_global_reset(), because with global reset hardware resets
WINDOW_REG_ADDRESS register hence the window is not properly mapped any
more. Current host does nothing about this, as a result a subsequent
register access may not work as expected if it falls in a window same as
before.

Although there is no obvious issue seen now, better to fix it to avoid
future problem. The fix is done by restoring the window register after
global reset.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00284.1-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20251017-ath12k-reset-window-cache-v1-1-29e0e751deed@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/pci.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index c729d5526c753..60b8f7361b7f6 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2019-2021 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
 #include <linux/module.h>
@@ -218,6 +218,19 @@ static inline bool ath12k_pci_is_offset_within_mhi_region(u32 offset)
 	return (offset >= PCI_MHIREGLEN_REG && offset <= PCI_MHI_REGION_END);
 }
 
+static void ath12k_pci_restore_window(struct ath12k_base *ab)
+{
+	struct ath12k_pci *ab_pci = ath12k_pci_priv(ab);
+
+	spin_lock_bh(&ab_pci->window_lock);
+
+	iowrite32(WINDOW_ENABLE_BIT | ab_pci->register_window,
+		  ab->mem + WINDOW_REG_ADDRESS);
+	ioread32(ab->mem + WINDOW_REG_ADDRESS);
+
+	spin_unlock_bh(&ab_pci->window_lock);
+}
+
 static void ath12k_pci_soc_global_reset(struct ath12k_base *ab)
 {
 	u32 val, delay;
@@ -242,6 +255,11 @@ static void ath12k_pci_soc_global_reset(struct ath12k_base *ab)
 	val = ath12k_pci_read32(ab, PCIE_SOC_GLOBAL_RESET);
 	if (val == 0xffffffff)
 		ath12k_warn(ab, "link down error during global reset\n");
+
+	/* Restore window register as its content is cleared during
+	 * hardware global reset, such that it aligns with host cache.
+	 */
+	ath12k_pci_restore_window(ab);
 }
 
 static void ath12k_pci_clear_dbg_registers(struct ath12k_base *ab)
-- 
2.51.0



