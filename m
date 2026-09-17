Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B334EF143;
	Thu, 17 Sep 2026 16:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663935; cv=none; b=EQdokfVEDn+rTkRIPmUXlsihSyiYCDEjKUKOSY3YxDS9yu6ny3IrwIcwxVSy1WS6TKGKBpHiV517UG+P4MA6OHWqBzDcPZTxKDyXiNi8eXsXTYdC/0wIo5Tc28NJjL6qHV+c270B/6PH+wyY7lPM5oNQY8MjnBl8YZPNzaNw2R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663935; c=relaxed/simple;
	bh=qpomd2w+Klg0rZdjdUQwH0tDMbAEYF0iRb+KAiqtPwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijvG8AutBqM80O+dBZPRNA3y9WUGhTR/4RDjuVOjTZJbhG3t59BC+e1GxoVjGv33q+P+K4x1nd9CZGeqpO/WEJVSkquIBgU6fKxK/qNHIiUCCDJMvG26pknQHDPxljarL/NpfeYYDVY3Vtsv0VuBJIs29je3yFBz7b02sI09Bgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kz1HLwnP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kz1HLwnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291C91F000FF;
	Thu, 17 Sep 2026 16:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663933;
	bh=VRanbwJB6pMY1NSTzccPqkkt7DanlncY37azUTp6gQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kz1HLwnPU/kJBJ6WyYqregCkPPirzViwAQtBWjp7pCM9A1GHmgJTW8BOH0Hz7J7MN
	 2wPnqAU6fDDENf8/Pbg0g2dzHlDJZRT5PqL4oUeLVF2zI3pWM5EKoj8nFZnHRx8bXg
	 yK7hfRlAxXtQX3QGfK8TCQq7YwhjwxNW/IErqpls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dian-Syuan Yang <dian_syuan0116@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0202/1250] wifi: rtw89: pci: enable LTR based on pcie control register
Date: Thu, 17 Sep 2026 15:59:57 +0100
Message-ID: <20260917151557.595021953@linuxfoundation.org>
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

From: Dian-Syuan Yang <dian_syuan0116@realtek.com>

[ Upstream commit 779bbe1902f29d0ef131249ddd42a8dfbe21d0fb ]

Originally, driver always transmits LTR (Latency Tolerance Reporting) to
pcie host, but it may cause pcie link down on some platforms because
LTR is not supported. As a result, driver will check the control
register of LTR setting to decide whether to enable LTR feature.

This applies to Wi-Fi 6 chips only. For Wi-Fi 7 chips, although the
driver still issues LTR, the hardware has its own internal logic
to determine whether to actually transmit it to pcie host.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260515014433.16168-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index b24237c1e7df7..364278a71e87d 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -3036,6 +3036,17 @@ static int rtw89_pci_mode_op(struct rtw89_dev *rtwdev)
 	return 0;
 }
 
+static bool rtw89_pci_dev_ltr_enabled(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_pci *rtwpci = (struct rtw89_pci *)rtwdev->priv;
+	struct pci_dev *pdev = rtwpci->pdev;
+	u16 cap;
+
+	pcie_capability_read_word(pdev, PCI_EXP_DEVCTL2, &cap);
+
+	return !!(cap & PCI_EXP_DEVCTL2_LTR_EN);
+}
+
 static int rtw89_pci_ops_deinit(struct rtw89_dev *rtwdev)
 {
 	const struct rtw89_pci_info *info = rtwdev->pci_info;
@@ -3140,7 +3151,7 @@ int rtw89_pci_ltr_set(struct rtw89_dev *rtwdev, bool en)
 {
 	u32 val;
 
-	if (!en)
+	if (!en || !rtw89_pci_dev_ltr_enabled(rtwdev))
 		return 0;
 
 	val = rtw89_read32(rtwdev, R_AX_LTR_CTRL_0);
@@ -3176,6 +3187,9 @@ int rtw89_pci_ltr_set_v1(struct rtw89_dev *rtwdev, bool en)
 	u32 dec_ctrl;
 	u32 val32;
 
+	if (!rtw89_pci_dev_ltr_enabled(rtwdev))
+		return 0;
+
 	val32 = rtw89_read32(rtwdev, R_AX_LTR_CTRL_0);
 	if (rtw89_pci_ltr_is_err_reg_val(val32))
 		return -EINVAL;
-- 
2.53.0



