Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCD3502776;
	Thu, 17 Sep 2026 17:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667582; cv=none; b=nMkvnIIdOKTp+qCRmid5FkNbcs8y0a2Oy1M9dV1FuWdwDVEToKkzEXNhpeWgr6cX1j5R48ct3jp4ZEqRJ7uqKa/n6ao7/Uu6r0FEoP3z8jJBL2OmGzvTDQXda1S7ii7HVvCU2VEQWa7r4mYQF5WaQXyixRLCU6BWys2ASARuIrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667582; c=relaxed/simple;
	bh=TZxK7laLNLA3XobeiR5POUxbULgr7/GwFjir/rtxP2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GI+sndrBkt2hcqlR3xRdss5H+cwPmH4LxGfSkjldZk0DztMlZaMdqNEPbk/bWbftd0E+Vr3AxOmAoID0lSugiS8yxBdPNTRRENZjloihhBDUfJymlAjEItcuuax+WEVfhaBWBIyLdZgbXmkouTlECPtxuFw5qLu+WvjXEI1xICM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvZ5al41; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvZ5al41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1341F000FF;
	Thu, 17 Sep 2026 17:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667580;
	bh=66/xKcUwRdPbr5gg7y3RIYRmBQt71rUla6kcMMpTyWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vvZ5al413ZBy83fjkpPapyfFAgqmd0rAglv/qDYgkfa6D5lREhPiECNz+y69B63CG
	 h5qz//XscVWGfEOk7iOLZyUjshgPAlm1KNo3cuCfBSFAooEnczrgNNQWuqMimqttX1
	 b6q6ft0EQ9PUEoj1bqjRxT5ie0nEhEtVlzI/Ngig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dian-Syuan Yang <dian_syuan0116@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0141/1102] wifi: rtw89: pci: enable LTR based on pcie control register
Date: Thu, 17 Sep 2026 16:01:24 +0100
Message-ID: <20260917151543.062677564@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c3a8a7af06472..cd094b32884a9 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -2794,6 +2794,17 @@ static int rtw89_pci_mode_op(struct rtw89_dev *rtwdev)
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
@@ -2898,7 +2909,7 @@ int rtw89_pci_ltr_set(struct rtw89_dev *rtwdev, bool en)
 {
 	u32 val;
 
-	if (!en)
+	if (!en || !rtw89_pci_dev_ltr_enabled(rtwdev))
 		return 0;
 
 	val = rtw89_read32(rtwdev, R_AX_LTR_CTRL_0);
@@ -2934,6 +2945,9 @@ int rtw89_pci_ltr_set_v1(struct rtw89_dev *rtwdev, bool en)
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



