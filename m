Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B32258CD6;
	Thu, 17 Apr 2025 18:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914122; cv=none; b=S4YeNoCYGKPqTSnhANAJLsgywRQOBKKiKBJBMRHoHMBRmfkKveL3Lyt9k8dv4XKSHIi+HmNBaiajjnxq39QqsqXLD+bfn4633ombv7xIUHp6fs+qQWG5RimjrApyOsvITXTO3Kut5Y8gRJTHj1u8h1dwaGdJ9/9O+Dsw2HQ1GhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914122; c=relaxed/simple;
	bh=uLEX9zEe7bu5Vt1w9YlNCG3dEzTvISzq7h/QVEQL3Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1Vw2hHmk+/55riJU+VhECJP6goCcAhypqcq/c3HnUlIRk+XpfTYKj6cjtJRfiNU4cir1TqU6QgDgITQZbIMwCnKXArRnJhSiBsousHJsKgH7mHzWX2A+aTJGdyxcKnJLO0z4HiRhbVvJ9z7jRD/5WpjNjGkUuuRvyKcdPUu0bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrO6HOjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrO6HOjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7825BC4CEEA;
	Thu, 17 Apr 2025 18:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914121;
	bh=uLEX9zEe7bu5Vt1w9YlNCG3dEzTvISzq7h/QVEQL3Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrO6HOjEGzAcTEDgRNuVjYmiwSDvuBfAslbC8U5JUGC4sLTMi7n8TbzdAf9tvp8c+
	 BXdsxfBB6WXDzqWC/rmSTkRLrLVBhXorYS0hJDzXoqHHv1Jj+H3kTl3wVK6TEZ5kM9
	 LjAQbngso5MypZ/DD/U+/g5W9SBJq4nedcvWAdhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <quic_miaoqing@quicinc.com>,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 084/414] wifi: ath11k: fix memory leak in ath11k_xxx_remove()
Date: Thu, 17 Apr 2025 19:47:22 +0200
Message-ID: <20250417175114.822354304@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqing Pan <quic_miaoqing@quicinc.com>

[ Upstream commit efb24b1f0d29537714dd3cc46fb335ac27855251 ]

The firmware memory was allocated in ath11k_pci_probe() or
ath11k_ahb_probe(), but not freed in ath11k_xxx_remove() in case
ATH11K_FLAG_QMI_FAIL bit is set. So call ath11k_fw_destroy() to
free the memory.

Found while fixing the same problem in ath12k:
https://lore.kernel.org/linux-wireless/20240314012746.2729101-1-quic_miaoqing@quicinc.com

Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-04546-QCAHSPSWPL_V1_V2_SILICONZ_IOE-1

Signed-off-by: Miaoqing Pan <quic_miaoqing@quicinc.com>
Reviewed-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Link: https://patch.msgid.link/20250123084948.1124357-1-quic_miaoqing@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ahb.c  | 4 +++-
 drivers/net/wireless/ath/ath11k/core.c | 3 +--
 drivers/net/wireless/ath/ath11k/fw.c   | 3 ++-
 drivers/net/wireless/ath/ath11k/pci.c  | 3 ++-
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index f2fc04596d481..eedba3766ba24 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
- * Copyright (c) 2022-2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2022-2025 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <linux/module.h>
@@ -1290,6 +1290,7 @@ static void ath11k_ahb_remove(struct platform_device *pdev)
 	ath11k_core_deinit(ab);
 
 qmi_fail:
+	ath11k_fw_destroy(ab);
 	ath11k_ahb_free_resources(ab);
 }
 
@@ -1309,6 +1310,7 @@ static void ath11k_ahb_shutdown(struct platform_device *pdev)
 	ath11k_core_deinit(ab);
 
 free_resources:
+	ath11k_fw_destroy(ab);
 	ath11k_ahb_free_resources(ab);
 }
 
diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index be67382c00f6d..950e93177d674 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <linux/module.h>
@@ -2214,7 +2214,6 @@ void ath11k_core_deinit(struct ath11k_base *ab)
 	ath11k_hif_power_down(ab);
 	ath11k_mac_destroy(ab);
 	ath11k_core_soc_destroy(ab);
-	ath11k_fw_destroy(ab);
 }
 EXPORT_SYMBOL(ath11k_core_deinit);
 
diff --git a/drivers/net/wireless/ath/ath11k/fw.c b/drivers/net/wireless/ath/ath11k/fw.c
index 4e36292a79db8..cbbd8e57119f2 100644
--- a/drivers/net/wireless/ath/ath11k/fw.c
+++ b/drivers/net/wireless/ath/ath11k/fw.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
- * Copyright (c) 2022-2023, Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2022-2025 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include "core.h"
@@ -166,3 +166,4 @@ void ath11k_fw_destroy(struct ath11k_base *ab)
 {
 	release_firmware(ab->fw.fw);
 }
+EXPORT_SYMBOL(ath11k_fw_destroy);
diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index be9d2c69cc413..6ebfa5d02e2e5 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2019-2020 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <linux/module.h>
@@ -981,6 +981,7 @@ static void ath11k_pci_remove(struct pci_dev *pdev)
 	ath11k_core_deinit(ab);
 
 qmi_fail:
+	ath11k_fw_destroy(ab);
 	ath11k_mhi_unregister(ab_pci);
 
 	ath11k_pcic_free_irq(ab);
-- 
2.39.5



