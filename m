Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5C029C35A;
	Tue, 16 Dec 2025 11:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885191; cv=none; b=A78DU7GWCFyvWcLlqA6O3YwujxrndeeqNEySSHAD8SUoGAMh9lHt5Q38m44D56i3zjkUl60nVvaKnWOH4mN3uiDni+M3P7/LoZTFAUmMBFpaTXAztAthDoLlg70QBYslpw1KnWjuugSvDOlqk3BSoyFhz/7fjpwROyP1/4WisWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885191; c=relaxed/simple;
	bh=/nVCsPks3zu52EQuWXvkz2sf73zxDpbnvOhUr5ZHTqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+NtoTX2Vt7C7aD8S0qC8Wa/AHBOCMm/7jSS901mWJMHY7MLx9BJONUW73HaaZoZG92Mb5XXhuAMYt/l5ivEEcr2+8Jsjj7xkJKogxWsdsWyOQ2oxlWtKepTH+U8NehXYQmBhOw7G559KIRs8N3MHVbhZE8ImfuIXiU+Ur5L0pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHo7/Gxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHo7/Gxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B77AC16AAE;
	Tue, 16 Dec 2025 11:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885191;
	bh=/nVCsPks3zu52EQuWXvkz2sf73zxDpbnvOhUr5ZHTqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHo7/Gxdrl3oR8/z7LxI85SDbJPkhON51uWpNU6Vih9ayUsOp2FqpNA8USoY4k7kf
	 yLfN0aODkclUtUO4qmkcfjrP20d1Nsvy3VWprXlBYTxdOZjtuZkXFF88RsAqUvIxCM
	 LvwvxpNBtGj3/hLmpp/5ys1kGEIBh4sa+j3paIdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 033/507] wifi: ath11k: restore register window after global reset
Date: Tue, 16 Dec 2025 12:07:54 +0100
Message-ID: <20251216111346.738096837@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 596b911644cc19ecba0dbc9c92849fb59390e29a ]

Hardware target implements an address space larger than that PCI BAR can
map. In order to be able to access the whole target address space, the BAR
space is split into 4 segments, of which the last 3, called windows, can
be dynamically mapped to the desired area. This is achieved by updating
window register with appropriate window value. Currently each time when
accessing a register that beyond ATH11K_PCI_WINDOW_START, host calculates
the window value and caches it after window update, this way next time
when accessing a register falling in the same window, host knows that the
window is already good hence no additional update needed.

However this mechanism breaks after global reset is triggered in
ath11k_pci_soc_global_reset(), because with global reset hardware resets
window register hence the window is not properly mapped any more. Current
host does nothing about this, as a result a subsequent register access may
not work as expected if it falls in a window same as before.

Although there is no obvious issue seen now, better to fix it to avoid
future problem. The fix is done by restoring the window register after
global reset.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.30

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20251014-ath11k-reset-window-cache-v1-1-b85271b111dd@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/pci.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index d8655badd96d0..7114eca8810db 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2019-2020 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
 #include <linux/module.h>
@@ -177,6 +177,19 @@ static inline void ath11k_pci_select_static_window(struct ath11k_pci *ab_pci)
 		  ab_pci->ab->mem + ATH11K_PCI_WINDOW_REG_ADDRESS);
 }
 
+static void ath11k_pci_restore_window(struct ath11k_base *ab)
+{
+	struct ath11k_pci *ab_pci = ath11k_pci_priv(ab);
+
+	spin_lock_bh(&ab_pci->window_lock);
+
+	iowrite32(ATH11K_PCI_WINDOW_ENABLE_BIT | ab_pci->register_window,
+		  ab->mem + ATH11K_PCI_WINDOW_REG_ADDRESS);
+	ioread32(ab->mem + ATH11K_PCI_WINDOW_REG_ADDRESS);
+
+	spin_unlock_bh(&ab_pci->window_lock);
+}
+
 static void ath11k_pci_soc_global_reset(struct ath11k_base *ab)
 {
 	u32 val, delay;
@@ -201,6 +214,11 @@ static void ath11k_pci_soc_global_reset(struct ath11k_base *ab)
 	val = ath11k_pcic_read32(ab, PCIE_SOC_GLOBAL_RESET);
 	if (val == 0xffffffff)
 		ath11k_warn(ab, "link down error during global reset\n");
+
+	/* Restore window register as its content is cleared during
+	 * hardware global reset, such that it aligns with host cache.
+	 */
+	ath11k_pci_restore_window(ab);
 }
 
 static void ath11k_pci_clear_dbg_registers(struct ath11k_base *ab)
-- 
2.51.0



