Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AA050B403;
	Thu, 17 Sep 2026 16:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663980; cv=none; b=KfZJLgcY8k1jd1kB8QDLiWFnNrcuFgn9Y/qQu2F5OSuBKHwoFQngfPxlVZnCFtB6cnn2dTbOZ0pbJwbAW8ldSA6vOgb7d6Jz0IAUhaTOPmInOriOcbn6en8z082kQSfnMeVCwDR1ujzqFpj3rfjcMVgbLB3uRliSNjnaK0MrPyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663980; c=relaxed/simple;
	bh=8d4dImvTNW/vG0jhZ+7j2nIOCfG03dBCYr8D5wfCZC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYpLYxAjvk/4BNQgvGtsuDMGQnlgOTOQwvMV1BqAmwUJb0dmfpDI9GD+xUnZHOCGVZFSzm8U0YctY6jtjecXoPC/HJ/8PyGFAh+0zmKdcRcWgE5fd/FTjiOJs4ERVwZS4kp0OkiwRQh17FnWewjnFs40Jl56Zi5WfXJwhzQpHFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8G0/8GQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8G0/8GQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99571F000FF;
	Thu, 17 Sep 2026 16:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663978;
	bh=GtkPNTtfO1TBo1ydMETnNPVAycyjxsloKITp+/NJm4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8G0/8GQoVc5jlsC7ggCIbE+oWzunTkhtx1lbpLWT27qCn3nEo86W/zGontEVfOY1
	 LTDJ33IR3bAeMGQHwVWD/jPsBwKeZ5lxbeY1jMSIVu7kPcmTt0qycvcuLAvHdPjqP6
	 H6tKctYpM5XqzCH3qzIeiS4KkQTx5DUZojUYqPyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0211/1250] wifi: iwlwifi: fix the access to CNVR TOP registers
Date: Thu, 17 Sep 2026 16:00:06 +0100
Message-ID: <20260917151557.846893794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit c73869c1df2a27dc3c928e94b42660124318f727 ]

For Dr and Sc, we need to wait until the TOP is ready to gets its
registers read by the host.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Daniel Gabay <daniel.gabay@intel.com>
Link: https://patch.msgid.link/20260511203428.09778340db51.I28d678ad404bbf8068f139666d38e29be5aa063b@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 18 ++++++++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h   |  4 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |  7 ++++-
 .../intel/iwlwifi/pcie/gen1_2/trans.c         | 26 ++++++++++++++++++-
 4 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index b1944584c6931..c4ccfffdf6af9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2003-2014, 2018-2022, 2024-2025 Intel Corporation
+ * Copyright (C) 2003-2014, 2018-2022, 2024-2026 Intel Corporation
  * Copyright (C) 2015-2016 Intel Deutschland GmbH
  */
 #include <linux/device.h>
@@ -168,6 +168,22 @@ int iwl_poll_prph_bit(struct iwl_trans *trans, u32 addr,
 	return -ETIMEDOUT;
 }
 
+int iwl_poll_umac_prph_bits_no_grab(struct iwl_trans *trans, u32 addr,
+				    u32 bits, u32 mask, int timeout)
+{
+	int t = 0;
+
+	do {
+		if ((iwl_read_umac_prph_no_grab(trans, addr) & mask) ==
+		    (bits & mask))
+			return 0;
+		udelay(IWL_POLL_INTERVAL);
+		t += IWL_POLL_INTERVAL;
+	} while (t < timeout);
+
+	return -ETIMEDOUT;
+}
+
 void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 {
 	if (iwl_trans_grab_nic_access(trans)) {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
index 5bcec239ffc4a..d920a32fc173c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2018-2021, 2025 Intel Corporation
+ * Copyright (C) 2018-2021, 2025-2026 Intel Corporation
  */
 #ifndef __iwl_io_h__
 #define __iwl_io_h__
@@ -51,6 +51,8 @@ static inline void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
 
 int iwl_poll_prph_bit(struct iwl_trans *trans, u32 addr,
 		      u32 bits, u32 mask, int timeout);
+int iwl_poll_umac_prph_bits_no_grab(struct iwl_trans *trans, u32 addr,
+				    u32 bits, u32 mask, int timeout);
 void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask);
 void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 			    u32 bits, u32 mask);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index a7214ddcfaf56..6ca1f51b69a1c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2005-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2005-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016 Intel Deutschland GmbH
  */
@@ -411,6 +411,11 @@ enum {
 #define HPM_SECONDARY_DEVICE_STATE      0xa03404
 #define WFPM_MAC_OTP_CFG7_ADDR		0xa03338
 #define WFPM_MAC_OTP_CFG7_DATA		0xa0333c
+#define WFPM_RSRCS_4PHS_REQ_STTS	0xa033f8
+#define WFPM_RSRCS_4PHS_ACK_STTS	0xa033fc
+
+#define RSRC_REQ_CNVR_TOP BIT(6)
+#define RSRC_ACK_CNVR_TOP BIT(6)
 
 
 /* For UMAG_GEN_HW_STATUS reg check */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index 59307b5df4417..b003abf1fe2ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2007-2015, 2018-2024 Intel Corporation
+ * Copyright (C) 2007-2015, 2018-2024, 2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -4000,6 +4000,30 @@ static void get_crf_id(struct iwl_trans *iwl_trans,
 	else
 		sd_reg_ver_addr = SD_REG_VER;
 
+	/* wait until the device is ready to access the prph registers */
+	if (iwl_trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_DR ||
+	    iwl_trans->mac_cfg->device_family == IWL_DEVICE_FAMILY_SC) {
+		u32 req = iwl_read_umac_prph_no_grab(iwl_trans,
+						     WFPM_RSRCS_4PHS_REQ_STTS);
+		int ret;
+
+		if (!(req & RSRC_REQ_CNVR_TOP)) {
+			IWL_ERR(iwl_trans,
+				"WFPM_RSRCS_4PHS_REQ_STTS bit 6 is clear 0x%x\n",
+				req);
+			return;
+		}
+
+		ret = iwl_poll_umac_prph_bits_no_grab(iwl_trans,
+						      WFPM_RSRCS_4PHS_ACK_STTS,
+						      RSRC_ACK_CNVR_TOP,
+						      RSRC_ACK_CNVR_TOP,
+						      50 * 1000);
+		if (ret < 0)
+			IWL_ERR(iwl_trans,
+				"WFPM_RSRCS_4PHS_ACK_STTS bit 6 is clear\n");
+	}
+
 	/* Enable access to peripheral registers */
 	val = iwl_read_umac_prph_no_grab(iwl_trans, WFPM_CTRL_REG);
 	val |= WFPM_AUX_CTL_AUX_IF_MAC_OWNER_MSK;
-- 
2.53.0



