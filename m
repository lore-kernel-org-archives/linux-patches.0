Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FC01EFFA3;
	Wed, 19 Feb 2025 08:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955397; cv=none; b=rrfZmYO7hff67eM79ZD3hB+0mCYhF7QdzWjkuw+1/CAosLoocQjIZTZQslvT7S1FZ1ETbGMGP2t98Ho7M620QyZAqTdPqc5Tgn0yGozNS4X8LS1mfUni2hHWiKRsn8tSOoGjgVatlnuAP7OXdR1wOMyrfm8aHXvnvVSZCTnCTUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955397; c=relaxed/simple;
	bh=6YclWAnrjXbFY/hs/7TSoEEe/gFtz9evS1OAWvV5BJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNgxj2oGU3M8MYG+vCWLq/sgD502FGs6c323TULlqmrZDMU3omXKAf2B7XNfNnGYrW3yFx1b3ygLHIcPbAYNwh5LXdvaaxyzCmU4UYy5qJuAbdxNqa2E1k1e6heQ6o2ZaSzLUj8tpFzlysq8bIpgmmO0gJ2nbpqzdSrp9YavJ00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbCcpD7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbCcpD7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F28C4CED1;
	Wed, 19 Feb 2025 08:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955397;
	bh=6YclWAnrjXbFY/hs/7TSoEEe/gFtz9evS1OAWvV5BJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbCcpD7Qx2CP9Mz6qwYpBXk9v5dqtei94gTjOfSXL3sOyYHBnhqbU+yTG1K/MEcry
	 C9AU+15JWFNsLhxAFMB8Nvav9bxhFE9JpCKwJJiAAORMMMIbpxUCVhzovFbwwtBkL4
	 Y78BQ28sxBh7+EaUPUOJPmgwT7Y/awD3s/qnaeT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Zenm Chen <zenmchen@gmail.com>
Subject: [PATCH 6.12 223/230] wifi: rtw89: pci: disable PCIE wake bit when PCIE deinit
Date: Wed, 19 Feb 2025 09:29:00 +0100
Message-ID: <20250219082610.413123951@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

commit 9c1df813e08832c3836c254bc8a2f83ff22dbc06 upstream.

The PCIE wake bit is to control PCIE wake signal to host. When PCIE is
going down, clear this bit to prevent waking up host unexpectedly.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241111063835.15454-1-pkshih@realtek.com
Signed-off-by: Zenm Chen <zenmchen@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c    |   17 ++++++++++++++---
 drivers/net/wireless/realtek/rtw89/pci.h    |   11 +++++++++++
 drivers/net/wireless/realtek/rtw89/pci_be.c |    2 ++
 3 files changed, 27 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -2492,7 +2492,7 @@ static int rtw89_pci_dphy_delay(struct r
 				       PCIE_DPHY_DLY_25US, PCIE_PHY_GEN1);
 }
 
-static void rtw89_pci_power_wake(struct rtw89_dev *rtwdev, bool pwr_up)
+static void rtw89_pci_power_wake_ax(struct rtw89_dev *rtwdev, bool pwr_up)
 {
 	if (pwr_up)
 		rtw89_write32_set(rtwdev, R_AX_HCI_OPT_CTRL, BIT_WAKE_CTRL);
@@ -2799,6 +2799,8 @@ static int rtw89_pci_ops_deinit(struct r
 {
 	const struct rtw89_pci_info *info = rtwdev->pci_info;
 
+	rtw89_pci_power_wake(rtwdev, false);
+
 	if (rtwdev->chip->chip_id == RTL8852A) {
 		/* ltr sw trigger */
 		rtw89_write32_set(rtwdev, R_AX_LTR_CTRL_0, B_AX_APP_LTR_IDLE);
@@ -2841,7 +2843,7 @@ static int rtw89_pci_ops_mac_pre_init_ax
 		return ret;
 	}
 
-	rtw89_pci_power_wake(rtwdev, true);
+	rtw89_pci_power_wake_ax(rtwdev, true);
 	rtw89_pci_autoload_hang(rtwdev);
 	rtw89_pci_l12_vmain(rtwdev);
 	rtw89_pci_gen2_force_ib(rtwdev);
@@ -2886,6 +2888,13 @@ static int rtw89_pci_ops_mac_pre_init_ax
 	return 0;
 }
 
+static int rtw89_pci_ops_mac_pre_deinit_ax(struct rtw89_dev *rtwdev)
+{
+	rtw89_pci_power_wake_ax(rtwdev, false);
+
+	return 0;
+}
+
 int rtw89_pci_ltr_set(struct rtw89_dev *rtwdev, bool en)
 {
 	u32 val;
@@ -4264,7 +4273,7 @@ const struct rtw89_pci_gen_def rtw89_pci
 					    B_AX_RDU_INT},
 
 	.mac_pre_init = rtw89_pci_ops_mac_pre_init_ax,
-	.mac_pre_deinit = NULL,
+	.mac_pre_deinit = rtw89_pci_ops_mac_pre_deinit_ax,
 	.mac_post_init = rtw89_pci_ops_mac_post_init_ax,
 
 	.clr_idx_all = rtw89_pci_clr_idx_all_ax,
@@ -4280,6 +4289,8 @@ const struct rtw89_pci_gen_def rtw89_pci
 	.aspm_set = rtw89_pci_aspm_set_ax,
 	.clkreq_set = rtw89_pci_clkreq_set_ax,
 	.l1ss_set = rtw89_pci_l1ss_set_ax,
+
+	.power_wake = rtw89_pci_power_wake_ax,
 };
 EXPORT_SYMBOL(rtw89_pci_gen_ax);
 
--- a/drivers/net/wireless/realtek/rtw89/pci.h
+++ b/drivers/net/wireless/realtek/rtw89/pci.h
@@ -1276,6 +1276,8 @@ struct rtw89_pci_gen_def {
 	void (*aspm_set)(struct rtw89_dev *rtwdev, bool enable);
 	void (*clkreq_set)(struct rtw89_dev *rtwdev, bool enable);
 	void (*l1ss_set)(struct rtw89_dev *rtwdev, bool enable);
+
+	void (*power_wake)(struct rtw89_dev *rtwdev, bool pwr_up);
 };
 
 struct rtw89_pci_info {
@@ -1766,4 +1768,13 @@ static inline int rtw89_pci_poll_txdma_c
 
 	return gen_def->poll_txdma_ch_idle(rtwdev);
 }
+
+static inline void rtw89_pci_power_wake(struct rtw89_dev *rtwdev, bool pwr_up)
+{
+	const struct rtw89_pci_info *info = rtwdev->pci_info;
+	const struct rtw89_pci_gen_def *gen_def = info->gen_def;
+
+	gen_def->power_wake(rtwdev, pwr_up);
+}
+
 #endif
--- a/drivers/net/wireless/realtek/rtw89/pci_be.c
+++ b/drivers/net/wireless/realtek/rtw89/pci_be.c
@@ -614,5 +614,7 @@ const struct rtw89_pci_gen_def rtw89_pci
 	.aspm_set = rtw89_pci_aspm_set_be,
 	.clkreq_set = rtw89_pci_clkreq_set_be,
 	.l1ss_set = rtw89_pci_l1ss_set_be,
+
+	.power_wake = _patch_pcie_power_wake_be,
 };
 EXPORT_SYMBOL(rtw89_pci_gen_be);


