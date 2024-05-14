Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAC85A79B;
	Tue, 14 May 2024 10:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683193; cv=none; b=ZsN0i4LEj44CHKwhpfUjl4rl6iTJvJ9wiJC4dl6uDs9kJ5U1PeCvN0kWs8sq2IckygltAqnHRYx6MVvVppy5gdk+7pDZyswqZfT8nh97a5oCvevlnWlvoeViqks80jG/1p93oM66dgNGOimm8b87YkqblYYZniac1rx5xgq3rPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683193; c=relaxed/simple;
	bh=moQgNV6JvimZ1BaURMV5+kUzZFUtpiaph+0R9b0jSJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoanPbQuLKti6Xmws2NrI3WP40ZKWY8x6ys3t6cfKT/46pGT0EJm90E0pYrAjpBkfaYYWp5Uph+Pd8ppQp2YbXUNEWSKkQVaz5bFxrADNh5onKLYjteg1WRKS9ijxKRxearYrxSDYB2xzkUqKN1XQnhHu66doWwIMmZF5DwHxlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnYT5Nnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnYT5Nnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9FBC32781;
	Tue, 14 May 2024 10:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683192;
	bh=moQgNV6JvimZ1BaURMV5+kUzZFUtpiaph+0R9b0jSJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnYT5NnbkAYtPyeSLsRjQoDoZbk1qGmB/TgMuNdAi/0gmgzhAbEAsQbia08D4z8Jl
	 eJh3dNvIxOHSJfHZT0R5DBtOJy5Sv+OiePDdjXIE3d1zJMwGDHdImufFTC6SGnPddH
	 s1xt/cwisYmuolZjt/gpuTkoTTWstsZ3mQEWsL8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 150/336] accel/ivpu: Remove d3hot_after_power_off WA
Date: Tue, 14 May 2024 12:15:54 +0200
Message-ID: <20240514101044.265146044@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

[ Upstream commit e3caadf1f9dfc9d62b5ffc3bd73ebac0c8f26b3f ]

Always enter D3hot after entering D0i3 an all platforms.
This minimizes power usage.

Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240402104929.941186-3-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_drv.c     | 20 ++++++++++----------
 drivers/accel/ivpu/ivpu_drv.h     |  3 +--
 drivers/accel/ivpu/ivpu_hw_37xx.c |  4 +---
 drivers/accel/ivpu/ivpu_pm.c      |  7 ++-----
 4 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_drv.c b/drivers/accel/ivpu/ivpu_drv.c
index b35c7aedca03e..bad1ccc81ad73 100644
--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (C) 2020-2023 Intel Corporation
+ * Copyright (C) 2020-2024 Intel Corporation
  */
 
 #include <linux/firmware.h>
@@ -371,12 +371,15 @@ int ivpu_shutdown(struct ivpu_device *vdev)
 {
 	int ret;
 
-	ivpu_prepare_for_reset(vdev);
+	/* Save PCI state before powering down as it sometimes gets corrupted if NPU hangs */
+	pci_save_state(to_pci_dev(vdev->drm.dev));
 
 	ret = ivpu_hw_power_down(vdev);
 	if (ret)
 		ivpu_warn(vdev, "Failed to power down HW: %d\n", ret);
 
+	pci_set_power_state(to_pci_dev(vdev->drm.dev), PCI_D3hot);
+
 	return ret;
 }
 
@@ -543,11 +546,11 @@ static int ivpu_dev_init(struct ivpu_device *vdev)
 	/* Power up early so the rest of init code can access VPU registers */
 	ret = ivpu_hw_power_up(vdev);
 	if (ret)
-		goto err_power_down;
+		goto err_shutdown;
 
 	ret = ivpu_mmu_global_context_init(vdev);
 	if (ret)
-		goto err_power_down;
+		goto err_shutdown;
 
 	ret = ivpu_mmu_init(vdev);
 	if (ret)
@@ -584,10 +587,8 @@ static int ivpu_dev_init(struct ivpu_device *vdev)
 	ivpu_mmu_reserved_context_fini(vdev);
 err_mmu_gctx_fini:
 	ivpu_mmu_global_context_fini(vdev);
-err_power_down:
-	ivpu_hw_power_down(vdev);
-	if (IVPU_WA(d3hot_after_power_off))
-		pci_set_power_state(to_pci_dev(vdev->drm.dev), PCI_D3hot);
+err_shutdown:
+	ivpu_shutdown(vdev);
 err_xa_destroy:
 	xa_destroy(&vdev->submitted_jobs_xa);
 	xa_destroy(&vdev->context_xa);
@@ -610,9 +611,8 @@ static void ivpu_bo_unbind_all_user_contexts(struct ivpu_device *vdev)
 static void ivpu_dev_fini(struct ivpu_device *vdev)
 {
 	ivpu_pm_disable(vdev);
+	ivpu_prepare_for_reset(vdev);
 	ivpu_shutdown(vdev);
-	if (IVPU_WA(d3hot_after_power_off))
-		pci_set_power_state(to_pci_dev(vdev->drm.dev), PCI_D3hot);
 
 	ivpu_jobs_abort_all(vdev);
 	ivpu_job_done_consumer_fini(vdev);
diff --git a/drivers/accel/ivpu/ivpu_drv.h b/drivers/accel/ivpu/ivpu_drv.h
index 069ace4adb2d1..e7a9e849940ea 100644
--- a/drivers/accel/ivpu/ivpu_drv.h
+++ b/drivers/accel/ivpu/ivpu_drv.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Copyright (C) 2020-2023 Intel Corporation
+ * Copyright (C) 2020-2024 Intel Corporation
  */
 
 #ifndef __IVPU_DRV_H__
@@ -87,7 +87,6 @@
 struct ivpu_wa_table {
 	bool punit_disabled;
 	bool clear_runtime_mem;
-	bool d3hot_after_power_off;
 	bool interrupt_clear_with_0;
 	bool disable_clock_relinquish;
 	bool disable_d0i3_msg;
diff --git a/drivers/accel/ivpu/ivpu_hw_37xx.c b/drivers/accel/ivpu/ivpu_hw_37xx.c
index 32bb772e03cf9..5e392b6823764 100644
--- a/drivers/accel/ivpu/ivpu_hw_37xx.c
+++ b/drivers/accel/ivpu/ivpu_hw_37xx.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (C) 2020-2023 Intel Corporation
+ * Copyright (C) 2020-2024 Intel Corporation
  */
 
 #include "ivpu_drv.h"
@@ -75,7 +75,6 @@ static void ivpu_hw_wa_init(struct ivpu_device *vdev)
 {
 	vdev->wa.punit_disabled = false;
 	vdev->wa.clear_runtime_mem = false;
-	vdev->wa.d3hot_after_power_off = true;
 
 	REGB_WR32(VPU_37XX_BUTTRESS_INTERRUPT_STAT, BUTTRESS_ALL_IRQ_MASK);
 	if (REGB_RD32(VPU_37XX_BUTTRESS_INTERRUPT_STAT) == BUTTRESS_ALL_IRQ_MASK) {
@@ -86,7 +85,6 @@ static void ivpu_hw_wa_init(struct ivpu_device *vdev)
 
 	IVPU_PRINT_WA(punit_disabled);
 	IVPU_PRINT_WA(clear_runtime_mem);
-	IVPU_PRINT_WA(d3hot_after_power_off);
 	IVPU_PRINT_WA(interrupt_clear_with_0);
 }
 
diff --git a/drivers/accel/ivpu/ivpu_pm.c b/drivers/accel/ivpu/ivpu_pm.c
index a15d30d0943af..2d706cb29a5a5 100644
--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (C) 2020-2023 Intel Corporation
+ * Copyright (C) 2020-2024 Intel Corporation
  */
 
 #include <linux/highmem.h>
@@ -58,15 +58,12 @@ static int ivpu_suspend(struct ivpu_device *vdev)
 {
 	int ret;
 
-	/* Save PCI state before powering down as it sometimes gets corrupted if NPU hangs */
-	pci_save_state(to_pci_dev(vdev->drm.dev));
+	ivpu_prepare_for_reset(vdev);
 
 	ret = ivpu_shutdown(vdev);
 	if (ret)
 		ivpu_err(vdev, "Failed to shutdown VPU: %d\n", ret);
 
-	pci_set_power_state(to_pci_dev(vdev->drm.dev), PCI_D3hot);
-
 	return ret;
 }
 
-- 
2.43.0



