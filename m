Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1E73FB3B;
	Thu, 13 Feb 2025 15:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460048; cv=none; b=eA5WZ4HB6P9uDcYYW+w5yAJzRcZxiqXfb3o65FA+VjcGhfZ84SpgDQ5b0X/zw/bPyRqlLSiSsMrSOoKja1w8MT2S4UHRCAuCkM1bX7cDf8dG7Yp2ZvC8KujdIuGFglz++N8lhYbKoQwLDn0L7wE0rMKi6przTGkXZTjllg26ULc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460048; c=relaxed/simple;
	bh=8h10gbFeUh0LIxLngSvuZrv02V9YtXZtxDyWyB4xPjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bd/6i4/mi/xkvy6Wx0hfXgtU8JwBy0GtnYDkn5j9iuL7yN/fyJEX8Mq+X2AmAfjrbAU5bNozjpTjNsi8KBa0EjqK3vGAzLb6cnVG9ZMeHzYpj6PG0z2nb5uICYLRwdQmlaVzgiWb4Hai8zUqYNaU9ZsKW2NtTaQQbyQ+YA622oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zC5F/e9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zC5F/e9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49903C4CED1;
	Thu, 13 Feb 2025 15:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460047;
	bh=8h10gbFeUh0LIxLngSvuZrv02V9YtXZtxDyWyB4xPjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zC5F/e9Wi7+nJ/P0veCybFFO80nWDgFglwkaXpHgC++0Tm0rS/nDD8qDw/MTZ+mNj
	 FP1hYijmBH1/UcATNJoM6EkTZnd8C4ERASsOlVC3Vp9yDue6+pmu8CFg7zkMORm4+l
	 Fj5aP71RgXzWd/do6krSYHvkm8JFWAud/uHODVXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.13 441/443] wifi: rtw89: pci: disable PCIE wake bit when PCIE deinit
Date: Thu, 13 Feb 2025 15:30:06 +0100
Message-ID: <20250213142457.632979147@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

commit 9c1df813e08832c3836c254bc8a2f83ff22dbc06 upstream.

The PCIE wake bit is to control PCIE wake signal to host. When PCIE is
going down, clear this bit to prevent waking up host unexpectedly.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241111063835.15454-1-pkshih@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c    |   16 +++++++++++++---
 drivers/net/wireless/realtek/rtw89/pci.h    |    9 +++++++++
 drivers/net/wireless/realtek/rtw89/pci_be.c |    1 +
 3 files changed, 23 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -2516,7 +2516,7 @@ static int rtw89_pci_dphy_delay(struct r
 				       PCIE_DPHY_DLY_25US, PCIE_PHY_GEN1);
 }
 
-static void rtw89_pci_power_wake(struct rtw89_dev *rtwdev, bool pwr_up)
+static void rtw89_pci_power_wake_ax(struct rtw89_dev *rtwdev, bool pwr_up)
 {
 	if (pwr_up)
 		rtw89_write32_set(rtwdev, R_AX_HCI_OPT_CTRL, BIT_WAKE_CTRL);
@@ -2825,6 +2825,8 @@ static int rtw89_pci_ops_deinit(struct r
 {
 	const struct rtw89_pci_info *info = rtwdev->pci_info;
 
+	rtw89_pci_power_wake(rtwdev, false);
+
 	if (rtwdev->chip->chip_id == RTL8852A) {
 		/* ltr sw trigger */
 		rtw89_write32_set(rtwdev, R_AX_LTR_CTRL_0, B_AX_APP_LTR_IDLE);
@@ -2867,7 +2869,7 @@ static int rtw89_pci_ops_mac_pre_init_ax
 		return ret;
 	}
 
-	rtw89_pci_power_wake(rtwdev, true);
+	rtw89_pci_power_wake_ax(rtwdev, true);
 	rtw89_pci_autoload_hang(rtwdev);
 	rtw89_pci_l12_vmain(rtwdev);
 	rtw89_pci_gen2_force_ib(rtwdev);
@@ -2912,6 +2914,13 @@ static int rtw89_pci_ops_mac_pre_init_ax
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
@@ -4325,7 +4334,7 @@ const struct rtw89_pci_gen_def rtw89_pci
 					    B_AX_RDU_INT},
 
 	.mac_pre_init = rtw89_pci_ops_mac_pre_init_ax,
-	.mac_pre_deinit = NULL,
+	.mac_pre_deinit = rtw89_pci_ops_mac_pre_deinit_ax,
 	.mac_post_init = rtw89_pci_ops_mac_post_init_ax,
 
 	.clr_idx_all = rtw89_pci_clr_idx_all_ax,
@@ -4343,6 +4352,7 @@ const struct rtw89_pci_gen_def rtw89_pci
 	.l1ss_set = rtw89_pci_l1ss_set_ax,
 
 	.disable_eq = rtw89_pci_disable_eq_ax,
+	.power_wake = rtw89_pci_power_wake_ax,
 };
 EXPORT_SYMBOL(rtw89_pci_gen_ax);
 
--- a/drivers/net/wireless/realtek/rtw89/pci.h
+++ b/drivers/net/wireless/realtek/rtw89/pci.h
@@ -1290,6 +1290,7 @@ struct rtw89_pci_gen_def {
 	void (*l1ss_set)(struct rtw89_dev *rtwdev, bool enable);
 
 	void (*disable_eq)(struct rtw89_dev *rtwdev);
+	void (*power_wake)(struct rtw89_dev *rtwdev, bool pwr_up);
 };
 
 #define RTW89_PCI_SSID(v, d, ssv, ssd, cust) \
@@ -1805,4 +1806,12 @@ static inline void rtw89_pci_disable_eq(
 	gen_def->disable_eq(rtwdev);
 }
 
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
@@ -691,5 +691,6 @@ const struct rtw89_pci_gen_def rtw89_pci
 	.l1ss_set = rtw89_pci_l1ss_set_be,
 
 	.disable_eq = rtw89_pci_disable_eq_be,
+	.power_wake = _patch_pcie_power_wake_be,
 };
 EXPORT_SYMBOL(rtw89_pci_gen_be);


