Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DF41D546
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80B2C433C7;
	Wed,  4 Oct 2023 18:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443006;
	bh=vNQvvq6XT0rB1gSlgmCbg5UwO81nUKyf1dqHL41wdTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2QjrMC94px2y1bOWtnWchwM7KuN3iEKo+abT3CMP5U4g5nHJnmu0+M3/9jEHzqRyO
	 H2qJ4Eu/OzeHpIrBRFyI+W7wmRZhBZ17tNzLXHvwcZla6MxBoEzGWSMvz5FPxWpXrJ
	 BNy/1KdUbtLKw8gNjyrJr3cvc7nzB6kw8HbBur/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Paul Grandperrin <paul.grandperrin@gmail.com>,
	Ricky Wu <ricky_wu@realtek.com>,
	Jade Lovelace <lists@jade.fyi>
Subject: [PATCH 5.15 159/183] misc: rtsx: Fix some platforms can not boot and move the l1ss judgment to probe
Date: Wed,  4 Oct 2023 19:56:30 +0200
Message-ID: <20231004175210.679674119@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricky WU <ricky_wu@realtek.com>

commit 0e4cac557531a4c93de108d9ff11329fcad482ff upstream.

commit 101bd907b424 ("misc: rtsx: judge ASPM Mode to set PETXCFG Reg")
some readers no longer force #CLKREQ to low
when the system need to enter ASPM.
But some platform maybe not implement complete ASPM?
it causes some platforms can not boot

Like in the past only the platform support L1ss we release the #CLKREQ.
Move the judgment (L1ss) to probe,
we think read config space one time when the driver start is enough

Fixes: 101bd907b424 ("misc: rtsx: judge ASPM Mode to set PETXCFG Reg")
Cc: stable <stable@kernel.org>
Reported-by: Paul Grandperrin <paul.grandperrin@gmail.com>
Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
Tested-By: Jade Lovelace <lists@jade.fyi>
Link: https://lore.kernel.org/r/37b1afb997f14946a8784c73d1f9a4f5@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/rts5227.c  |   55 +++--------------------------------
 drivers/misc/cardreader/rts5228.c  |   57 +++++++++++--------------------------
 drivers/misc/cardreader/rts5249.c  |   56 ++++--------------------------------
 drivers/misc/cardreader/rts5260.c  |   43 ++++++++-------------------
 drivers/misc/cardreader/rts5261.c  |   52 ++++++++-------------------------
 drivers/misc/cardreader/rtsx_pcr.c |   51 +++++++++++++++++++++++++++++----
 6 files changed, 102 insertions(+), 212 deletions(-)

--- a/drivers/misc/cardreader/rts5227.c
+++ b/drivers/misc/cardreader/rts5227.c
@@ -81,63 +81,20 @@ static void rts5227_fetch_vendor_setting
 
 static void rts5227_init_from_cfg(struct rtsx_pcr *pcr)
 {
-	struct pci_dev *pdev = pcr->pci;
-	int l1ss;
-	u32 lval;
 	struct rtsx_cr_option *option = &pcr->option;
 
-	l1ss = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_L1SS);
-	if (!l1ss)
-		return;
-
-	pci_read_config_dword(pdev, l1ss + PCI_L1SS_CTL1, &lval);
-
 	if (CHK_PCI_PID(pcr, 0x522A)) {
-		if (0 == (lval & 0x0F))
-			rtsx_pci_enable_oobs_polling(pcr);
-		else
+		if (rtsx_check_dev_flag(pcr, ASPM_L1_1_EN | ASPM_L1_2_EN
+				| PM_L1_1_EN | PM_L1_2_EN))
 			rtsx_pci_disable_oobs_polling(pcr);
+		else
+			rtsx_pci_enable_oobs_polling(pcr);
 	}
 
-	if (lval & PCI_L1SS_CTL1_ASPM_L1_1)
-		rtsx_set_dev_flag(pcr, ASPM_L1_1_EN);
-	else
-		rtsx_clear_dev_flag(pcr, ASPM_L1_1_EN);
-
-	if (lval & PCI_L1SS_CTL1_ASPM_L1_2)
-		rtsx_set_dev_flag(pcr, ASPM_L1_2_EN);
-	else
-		rtsx_clear_dev_flag(pcr, ASPM_L1_2_EN);
-
-	if (lval & PCI_L1SS_CTL1_PCIPM_L1_1)
-		rtsx_set_dev_flag(pcr, PM_L1_1_EN);
-	else
-		rtsx_clear_dev_flag(pcr, PM_L1_1_EN);
-
-	if (lval & PCI_L1SS_CTL1_PCIPM_L1_2)
-		rtsx_set_dev_flag(pcr, PM_L1_2_EN);
-	else
-		rtsx_clear_dev_flag(pcr, PM_L1_2_EN);
-
 	if (option->ltr_en) {
-		u16 val;
-
-		pcie_capability_read_word(pcr->pci, PCI_EXP_DEVCTL2, &val);
-		if (val & PCI_EXP_DEVCTL2_LTR_EN) {
-			option->ltr_enabled = true;
-			option->ltr_active = true;
+		if (option->ltr_enabled)
 			rtsx_set_ltr_latency(pcr, option->ltr_active_latency);
-		} else {
-			option->ltr_enabled = false;
-		}
 	}
-
-	if (rtsx_check_dev_flag(pcr, ASPM_L1_1_EN | ASPM_L1_2_EN
-				| PM_L1_1_EN | PM_L1_2_EN))
-		option->force_clkreq_0 = false;
-	else
-		option->force_clkreq_0 = true;
-
 }
 
 static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
@@ -171,7 +128,7 @@ static int rts5227_extra_init_hw(struct
 	else
 		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0x30, 0x00);
 
-	if (option->force_clkreq_0 && pcr->aspm_mode == ASPM_MODE_CFG)
+	if (option->force_clkreq_0)
 		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG,
 				FORCE_CLKREQ_DELINK_MASK, FORCE_CLKREQ_LOW);
 	else
--- a/drivers/misc/cardreader/rts5228.c
+++ b/drivers/misc/cardreader/rts5228.c
@@ -378,59 +378,25 @@ static void rts5228_process_ocp(struct r
 
 static void rts5228_init_from_cfg(struct rtsx_pcr *pcr)
 {
-	struct pci_dev *pdev = pcr->pci;
-	int l1ss;
-	u32 lval;
 	struct rtsx_cr_option *option = &pcr->option;
 
-	l1ss = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_L1SS);
-	if (!l1ss)
-		return;
-
-	pci_read_config_dword(pdev, l1ss + PCI_L1SS_CTL1, &lval);
-
-	if (0 == (lval & 0x0F))
-		rtsx_pci_enable_oobs_polling(pcr);
-	else
+	if (rtsx_check_dev_flag(pcr, ASPM_L1_1_EN | ASPM_L1_2_EN
+				| PM_L1_1_EN | PM_L1_2_EN))
 		rtsx_pci_disable_oobs_polling(pcr);
-
-	if (lval & PCI_L1SS_CTL1_ASPM_L1_1)
-		rtsx_set_dev_flag(pcr, ASPM_L1_1_EN);
-	else
-		rtsx_clear_dev_flag(pcr, ASPM_L1_1_EN);
-
-	if (lval & PCI_L1SS_CTL1_ASPM_L1_2)
-		rtsx_set_dev_flag(pcr, ASPM_L1_2_EN);
-	else
-		rtsx_clear_dev_flag(pcr, ASPM_L1_2_EN);
-
-	if (lval & PCI_L1SS_CTL1_PCIPM_L1_1)
-		rtsx_set_dev_flag(pcr, PM_L1_1_EN);
 	else
-		rtsx_clear_dev_flag(pcr, PM_L1_1_EN);
-
-	if (lval & PCI_L1SS_CTL1_PCIPM_L1_2)
-		rtsx_set_dev_flag(pcr, PM_L1_2_EN);
-	else
-		rtsx_clear_dev_flag(pcr, PM_L1_2_EN);
+		rtsx_pci_enable_oobs_polling(pcr);
 
 	rtsx_pci_write_register(pcr, ASPM_FORCE_CTL, 0xFF, 0);
-	if (option->ltr_en) {
-		u16 val;
 
-		pcie_capability_read_word(pcr->pci, PCI_EXP_DEVCTL2, &val);
-		if (val & PCI_EXP_DEVCTL2_LTR_EN) {
-			option->ltr_enabled = true;
-			option->ltr_active = true;
+	if (option->ltr_en) {
+		if (option->ltr_enabled)
 			rtsx_set_ltr_latency(pcr, option->ltr_active_latency);
-		} else {
-			option->ltr_enabled = false;
-		}
 	}
 }
 
 static int rts5228_extra_init_hw(struct rtsx_pcr *pcr)
 {
+	struct rtsx_cr_option *option = &pcr->option;
 
 	rtsx_pci_write_register(pcr, RTS5228_AUTOLOAD_CFG1,
 			CD_RESUME_EN_MASK, CD_RESUME_EN_MASK);
@@ -461,6 +427,17 @@ static int rts5228_extra_init_hw(struct
 	else
 		rtsx_pci_write_register(pcr, PETXCFG, 0x30, 0x00);
 
+	/*
+	 * If u_force_clkreq_0 is enabled, CLKREQ# PIN will be forced
+	 * to drive low, and we forcibly request clock.
+	 */
+	if (option->force_clkreq_0)
+		rtsx_pci_write_register(pcr, PETXCFG,
+				 FORCE_CLKREQ_DELINK_MASK, FORCE_CLKREQ_LOW);
+	else
+		rtsx_pci_write_register(pcr, PETXCFG,
+				 FORCE_CLKREQ_DELINK_MASK, FORCE_CLKREQ_HIGH);
+
 	rtsx_pci_write_register(pcr, PWD_SUSPEND_EN, 0xFF, 0xFB);
 	rtsx_pci_write_register(pcr, pcr->reg_pm_ctrl3, 0x10, 0x00);
 	rtsx_pci_write_register(pcr, RTS5228_REG_PME_FORCE_CTL,
--- a/drivers/misc/cardreader/rts5249.c
+++ b/drivers/misc/cardreader/rts5249.c
@@ -85,64 +85,22 @@ static void rtsx_base_fetch_vendor_setti
 
 static void rts5249_init_from_cfg(struct rtsx_pcr *pcr)
 {
-	struct pci_dev *pdev = pcr->pci;
-	int l1ss;
 	struct rtsx_cr_option *option = &(pcr->option);
-	u32 lval;
-
-	l1ss = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_L1SS);
-	if (!l1ss)
-		return;
-
-	pci_read_config_dword(pdev, l1ss + PCI_L1SS_CTL1, &lval);
 
 	if (CHK_PCI_PID(pcr, PID_524A) || CHK_PCI_PID(pcr, PID_525A)) {
-		if (0 == (lval & 0x0F))
-			rtsx_pci_enable_oobs_polling(pcr);
-		else
+		if (rtsx_check_dev_flag(pcr, ASPM_L1_1_EN | ASPM_L1_2_EN
+				| PM_L1_1_EN | PM_L1_2_EN))
 			rtsx_pci_disable_oobs_polling(pcr);
+		else
+			rtsx_pci_enable_oobs_polling(pcr);
 	}
 
-
-	if (lval & PCI_L1SS_CTL1_ASPM_L1_1)
-		rtsx_set_dev_flag(pcr, ASPM_L1_1_EN);
-
-	if (lval & PCI_L1SS_CTL1_ASPM_L1_2)
-		rtsx_set_dev_flag(pcr, ASPM_L1_2_EN);
-
-	if (lval & PCI_L1SS_CTL1_PCIPM_L1_1)
-		rtsx_set_dev_flag(pcr, PM_L1_1_EN);
-
-	if (lval & PCI_L1SS_CTL1_PCIPM_L1_2)
-		rtsx_set_dev_flag(pcr, PM_L1_2_EN);
-
 	if (option->ltr_en) {
-		u16 val;
-
-		pcie_capability_read_word(pdev, PCI_EXP_DEVCTL2, &val);
-		if (val & PCI_EXP_DEVCTL2_LTR_EN) {
-			option->ltr_enabled = true;
-			option->ltr_active = true;
+		if (option->ltr_enabled)
 			rtsx_set_ltr_latency(pcr, option->ltr_active_latency);
-		} else {
-			option->ltr_enabled = false;
-		}
 	}
 }
 
-static int rts5249_init_from_hw(struct rtsx_pcr *pcr)
-{
-	struct rtsx_cr_option *option = &(pcr->option);
-
-	if (rtsx_check_dev_flag(pcr, ASPM_L1_1_EN | ASPM_L1_2_EN
-				| PM_L1_1_EN | PM_L1_2_EN))
-		option->force_clkreq_0 = false;
-	else
-		option->force_clkreq_0 = true;
-
-	return 0;
-}
-
 static void rts52xa_save_content_from_efuse(struct rtsx_pcr *pcr)
 {
 	u8 cnt, sv;
@@ -254,7 +212,6 @@ static int rts5249_extra_init_hw(struct
 	struct rtsx_cr_option *option = &(pcr->option);
 
 	rts5249_init_from_cfg(pcr);
-	rts5249_init_from_hw(pcr);
 
 	rtsx_pci_init_cmd(pcr);
 
@@ -302,11 +259,12 @@ static int rts5249_extra_init_hw(struct
 		}
 	}
 
+
 	/*
 	 * If u_force_clkreq_0 is enabled, CLKREQ# PIN will be forced
 	 * to drive low, and we forcibly request clock.
 	 */
-	if (option->force_clkreq_0 && pcr->aspm_mode == ASPM_MODE_CFG)
+	if (option->force_clkreq_0)
 		rtsx_pci_write_register(pcr, PETXCFG,
 			FORCE_CLKREQ_DELINK_MASK, FORCE_CLKREQ_LOW);
 	else
--- a/drivers/misc/cardreader/rts5260.c
+++ b/drivers/misc/cardreader/rts5260.c
@@ -480,47 +480,19 @@ static void rts5260_pwr_saving_setting(s
 
 static void rts5260_init_from_cfg(struct rtsx_pcr *pcr)
 {
-	struct pci_dev *pdev = pcr->pci;
-	int l1ss;
 	struct rtsx_cr_option *option = &pcr->option;
-	u32 lval;
-
-	l1ss = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_L1SS);
-	if (!l1ss)
-		return;
-
-	pci_read_config_dword(pdev, l1ss + PCI_L1SS_CTL1, &lval);
-
-	if (lval & PCI_L1SS_CTL1_ASPM_L1_1)
-		rtsx_set_dev_flag(pcr, ASPM_L1_1_EN);
-
-	if (lval & PCI_L1SS_CTL1_ASPM_L1_2)
-		rtsx_set_dev_flag(pcr, ASPM_L1_2_EN);
-
-	if (lval & PCI_L1SS_CTL1_PCIPM_L1_1)
-		rtsx_set_dev_flag(pcr, PM_L1_1_EN);
-
-	if (lval & PCI_L1SS_CTL1_PCIPM_L1_2)
-		rtsx_set_dev_flag(pcr, PM_L1_2_EN);
 
 	rts5260_pwr_saving_setting(pcr);
 
 	if (option->ltr_en) {
-		u16 val;
-
-		pcie_capability_read_word(pdev, PCI_EXP_DEVCTL2, &val);
-		if (val & PCI_EXP_DEVCTL2_LTR_EN) {
-			option->ltr_enabled = true;
-			option->ltr_active = true;
+		if (option->ltr_enabled)
 			rtsx_set_ltr_latency(pcr, option->ltr_active_latency);
-		} else {
-			option->ltr_enabled = false;
-		}
 	}
 }
 
 static int rts5260_extra_init_hw(struct rtsx_pcr *pcr)
 {
+	struct rtsx_cr_option *option = &pcr->option;
 
 	/* Set mcu_cnt to 7 to ensure data can be sampled properly */
 	rtsx_pci_write_register(pcr, 0xFC03, 0x7F, 0x07);
@@ -539,6 +511,17 @@ static int rts5260_extra_init_hw(struct
 
 	rts5260_init_hw(pcr);
 
+	/*
+	 * If u_force_clkreq_0 is enabled, CLKREQ# PIN will be forced
+	 * to drive low, and we forcibly request clock.
+	 */
+	if (option->force_clkreq_0)
+		rtsx_pci_write_register(pcr, PETXCFG,
+				 FORCE_CLKREQ_DELINK_MASK, FORCE_CLKREQ_LOW);
+	else
+		rtsx_pci_write_register(pcr, PETXCFG,
+				 FORCE_CLKREQ_DELINK_MASK, FORCE_CLKREQ_HIGH);
+
 	rtsx_pci_write_register(pcr, pcr->reg_pm_ctrl3, 0x10, 0x00);
 
 	return 0;
--- a/drivers/misc/cardreader/rts5261.c
+++ b/drivers/misc/cardreader/rts5261.c
@@ -424,54 +424,17 @@ static int rts5261_init_from_hw(struct r
 
 static void rts5261_init_from_cfg(struct rtsx_pcr *pcr)
 {
-	struct pci_dev *pdev = pcr->pci;
-	int l1ss;
-	u32 lval;
 	struct rtsx_cr_option *option = &pcr->option;
 
-	l1ss = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_L1SS);
-	if (!l1ss)
-		return;
-
-	pci_read_config_dword(pdev, l1ss + PCI_L1SS_CTL1, &lval);
-
-	if (lval & PCI_L1SS_CTL1_ASPM_L1_1)
-		rtsx_set_dev_flag(pcr, ASPM_L1_1_EN);
-	else
-		rtsx_clear_dev_flag(pcr, ASPM_L1_1_EN);
-
-	if (lval & PCI_L1SS_CTL1_ASPM_L1_2)
-		rtsx_set_dev_flag(pcr, ASPM_L1_2_EN);
-	else
-		rtsx_clear_dev_flag(pcr, ASPM_L1_2_EN);
-
-	if (lval & PCI_L1SS_CTL1_PCIPM_L1_1)
-		rtsx_set_dev_flag(pcr, PM_L1_1_EN);
-	else
-		rtsx_clear_dev_flag(pcr, PM_L1_1_EN);
-
-	if (lval & PCI_L1SS_CTL1_PCIPM_L1_2)
-		rtsx_set_dev_flag(pcr, PM_L1_2_EN);
-	else
-		rtsx_clear_dev_flag(pcr, PM_L1_2_EN);
-
-	rtsx_pci_write_register(pcr, ASPM_FORCE_CTL, 0xFF, 0);
 	if (option->ltr_en) {
-		u16 val;
-
-		pcie_capability_read_word(pdev, PCI_EXP_DEVCTL2, &val);
-		if (val & PCI_EXP_DEVCTL2_LTR_EN) {
-			option->ltr_enabled = true;
-			option->ltr_active = true;
+		if (option->ltr_enabled)
 			rtsx_set_ltr_latency(pcr, option->ltr_active_latency);
-		} else {
-			option->ltr_enabled = false;
-		}
 	}
 }
 
 static int rts5261_extra_init_hw(struct rtsx_pcr *pcr)
 {
+	struct rtsx_cr_option *option = &pcr->option;
 	u32 val;
 
 	rtsx_pci_write_register(pcr, RTS5261_AUTOLOAD_CFG1,
@@ -517,6 +480,17 @@ static int rts5261_extra_init_hw(struct
 	else
 		rtsx_pci_write_register(pcr, PETXCFG, 0x30, 0x00);
 
+	/*
+	 * If u_force_clkreq_0 is enabled, CLKREQ# PIN will be forced
+	 * to drive low, and we forcibly request clock.
+	 */
+	if (option->force_clkreq_0)
+		rtsx_pci_write_register(pcr, PETXCFG,
+				 FORCE_CLKREQ_DELINK_MASK, FORCE_CLKREQ_LOW);
+	else
+		rtsx_pci_write_register(pcr, PETXCFG,
+				 FORCE_CLKREQ_DELINK_MASK, FORCE_CLKREQ_HIGH);
+
 	rtsx_pci_write_register(pcr, PWD_SUSPEND_EN, 0xFF, 0xFB);
 	rtsx_pci_write_register(pcr, pcr->reg_pm_ctrl3, 0x10, 0x00);
 	rtsx_pci_write_register(pcr, RTS5261_REG_PME_FORCE_CTL,
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1400,11 +1400,8 @@ static int rtsx_pci_init_hw(struct rtsx_
 			return err;
 	}
 
-	if (pcr->aspm_mode == ASPM_MODE_REG) {
+	if (pcr->aspm_mode == ASPM_MODE_REG)
 		rtsx_pci_write_register(pcr, ASPM_FORCE_CTL, 0x30, 0x30);
-		rtsx_pci_write_register(pcr, PETXCFG,
-				FORCE_CLKREQ_DELINK_MASK, FORCE_CLKREQ_HIGH);
-	}
 
 	/* No CD interrupt if probing driver with card inserted.
 	 * So we need to initialize pcr->card_exist here.
@@ -1419,7 +1416,9 @@ static int rtsx_pci_init_hw(struct rtsx_
 
 static int rtsx_pci_init_chip(struct rtsx_pcr *pcr)
 {
-	int err;
+	struct rtsx_cr_option *option = &(pcr->option);
+	int err, l1ss;
+	u32 lval;
 	u16 cfg_val;
 	u8 val;
 
@@ -1504,6 +1503,48 @@ static int rtsx_pci_init_chip(struct rts
 			pcr->aspm_enabled = true;
 	}
 
+	l1ss = pci_find_ext_capability(pcr->pci, PCI_EXT_CAP_ID_L1SS);
+	if (l1ss) {
+		pci_read_config_dword(pcr->pci, l1ss + PCI_L1SS_CTL1, &lval);
+
+		if (lval & PCI_L1SS_CTL1_ASPM_L1_1)
+			rtsx_set_dev_flag(pcr, ASPM_L1_1_EN);
+		else
+			rtsx_clear_dev_flag(pcr, ASPM_L1_1_EN);
+
+		if (lval & PCI_L1SS_CTL1_ASPM_L1_2)
+			rtsx_set_dev_flag(pcr, ASPM_L1_2_EN);
+		else
+			rtsx_clear_dev_flag(pcr, ASPM_L1_2_EN);
+
+		if (lval & PCI_L1SS_CTL1_PCIPM_L1_1)
+			rtsx_set_dev_flag(pcr, PM_L1_1_EN);
+		else
+			rtsx_clear_dev_flag(pcr, PM_L1_1_EN);
+
+		if (lval & PCI_L1SS_CTL1_PCIPM_L1_2)
+			rtsx_set_dev_flag(pcr, PM_L1_2_EN);
+		else
+			rtsx_clear_dev_flag(pcr, PM_L1_2_EN);
+
+		pcie_capability_read_word(pcr->pci, PCI_EXP_DEVCTL2, &cfg_val);
+		if (cfg_val & PCI_EXP_DEVCTL2_LTR_EN) {
+			option->ltr_enabled = true;
+			option->ltr_active = true;
+		} else {
+			option->ltr_enabled = false;
+		}
+
+		if (rtsx_check_dev_flag(pcr, ASPM_L1_1_EN | ASPM_L1_2_EN
+				| PM_L1_1_EN | PM_L1_2_EN))
+			option->force_clkreq_0 = false;
+		else
+			option->force_clkreq_0 = true;
+	} else {
+		option->ltr_enabled = false;
+		option->force_clkreq_0 = true;
+	}
+
 	if (pcr->ops->fetch_vendor_settings)
 		pcr->ops->fetch_vendor_settings(pcr);
 


