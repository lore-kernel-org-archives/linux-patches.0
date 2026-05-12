Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E17B6FC5;
	Tue, 12 May 2026 18:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609739; cv=none; b=J2a3bgnZNjmsIyDGjQjERNJ/pIYqJ7FzWqD9DqF9Sp/Y5NxetPQZgHmoC2pVZylXxGcSPZZoLbMvguFHZSOQdhpqyLCrVvLvJhWHeaAdj3LSeYFwTsZU+/nzpzTE8OpnlymXXI28fL7nBt6NaSbi6SLE8r7kgoGk9KsYJaOPVNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609739; c=relaxed/simple;
	bh=wxoRvNwTMAiEPmevA40ny4bKgYvNTVueR2usgk3SohM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QJ7U0lKL3vcGxxgf/bed+V4WAOH/sJEaVwjU8jh/klVMyLX7YUnnZQKthK0BzqJ+Z2dUB2FTGyEcwLB6Ry1LH1YlZpO4r3VvM3Z7VtbT7rI8HF7kob02Z0f+R0F4S7cLgBgslKJzfrkQ6IFQx/I3QpN4TzpvEKvZ5kXTuYmHbsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAa5Ix7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAa5Ix7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2DAC2BCB0;
	Tue, 12 May 2026 18:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609738;
	bh=wxoRvNwTMAiEPmevA40ny4bKgYvNTVueR2usgk3SohM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAa5Ix7RVXuAtmZ5E/aqXQ/xc00HDgZcC9+i9NlIZmEzB/dVrhICUlzFAS0znk67n
	 3JHre/CAtwrBd41SAiFiGXW3OI8BQopr11vFIPPJTzUa3cd4bNSTl6CJjq5HdONH0t
	 FhSkquHOgJbP8FvLysoL0sDRUFUnQZf16pTHxvM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 297/307] crypto: qat - fix firmware loading failure for GEN6 devices
Date: Tue, 12 May 2026 19:41:32 +0200
Message-ID: <20260512173946.398311393@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>

[ Upstream commit e7dcb722bb75bb3f3992f580a8728a794732fd7a ]

QAT GEN6 hardware requires a minimum 3 us delay during the acceleration
engine reset sequence to ensure the hardware fully settles.
Without this delay, the firmware load may fail intermittently.

Add a delay after placing the AE into reset and before clearing the reset,
matching the hardware requirements and ensuring stable firmware loading.
Earlier generations remain unaffected.

Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/adf_accel_engine.c         |    7 +++++++
 drivers/crypto/intel/qat/qat_common/icp_qat_fw_loader_handle.h |    1 +
 drivers/crypto/intel/qat/qat_common/qat_hal.c                  |    5 ++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2020 Intel Corporation */
+#include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/pci.h>
 #include "adf_cfg.h"
@@ -162,8 +163,14 @@ int adf_ae_stop(struct adf_accel_dev *ac
 static int adf_ae_reset(struct adf_accel_dev *accel_dev, int ae)
 {
 	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
+	unsigned long reset_delay;
 
 	qat_hal_reset(loader_data->fw_loader);
+
+	reset_delay = loader_data->fw_loader->chip_info->reset_delay_us;
+	if (reset_delay)
+		fsleep(reset_delay);
+
 	if (qat_hal_clr_reset(loader_data->fw_loader))
 		return -EFAULT;
 
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -27,6 +27,7 @@ struct icp_qat_fw_loader_chip_info {
 	int mmp_sram_size;
 	bool nn;
 	bool lm2lm3;
+	u16 reset_delay_us;
 	u32 lm_size;
 	u32 icp_rst_csr;
 	u32 icp_rst_mask;
--- a/drivers/crypto/intel/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_hal.c
@@ -20,6 +20,7 @@
 #define RST_CSR_QAT_LSB			20
 #define RST_CSR_AE_LSB			0
 #define MC_TIMESTAMP_ENABLE		(0x1 << 7)
+#define MIN_RESET_DELAY_US		3
 
 #define IGNORE_W1C_MASK ((~(1 << CE_BREAKPOINT_BITPOS)) & \
 	(~(1 << CE_CNTL_STORE_PARITY_ERROR_BITPOS)) & \
@@ -713,8 +714,10 @@ static int qat_hal_chip_init(struct icp_
 		handle->chip_info->wakeup_event_val = 0x80000000;
 		handle->chip_info->fw_auth = true;
 		handle->chip_info->css_3k = true;
-		if (handle->pci_dev->device == PCI_DEVICE_ID_INTEL_QAT_6XXX)
+		if (handle->pci_dev->device == PCI_DEVICE_ID_INTEL_QAT_6XXX) {
 			handle->chip_info->dual_sign = true;
+			handle->chip_info->reset_delay_us = MIN_RESET_DELAY_US;
+		}
 		handle->chip_info->tgroup_share_ustore = true;
 		handle->chip_info->fcu_ctl_csr = FCU_CONTROL_4XXX;
 		handle->chip_info->fcu_sts_csr = FCU_STATUS_4XXX;


