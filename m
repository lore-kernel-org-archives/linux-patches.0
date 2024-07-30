Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CF41A6177;
	Tue, 30 Jul 2024 16:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356635; cv=none; b=DVKAOfy83w99m1jIBi6ibuR9C3T5wJiT8LbGcvR54hGeK3i0UpTqe1ambMlFORs95wuJZisj7GKt6R6e/993xkdtflHGc9rpunJEkFbYwb23POC7kamS0BlZDAqwQhghbR+vJoMFBVFF8wP+N8acd/X6vEFYaNBdsA84t5KsZzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356635; c=relaxed/simple;
	bh=y2XZ0CUwdSjaxsdt8WnQ+/oFL56d3F7dvAVx0FTYDz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJmY8Cq4/fuba/re72LAE2BEgDnbeIweA3Ny8NNsTPEjuCCklhp99usjimdg8yeVlj4I80fXKAuJngM2o8+Lx7XueAFQ/WD0i/WgREO08Ws22x2fQdxwP6mJ6lxOGzx+4iZlfqweR/Va0DBYisIOwaqQ9P4eVxaGcvE7YWg92WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0WNv8AJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0WNv8AJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59ADC32782;
	Tue, 30 Jul 2024 16:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356635;
	bh=y2XZ0CUwdSjaxsdt8WnQ+/oFL56d3F7dvAVx0FTYDz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0WNv8AJymuJBmuDNoNHD+uBaSb3zvH8WB1UbYn7CmWqjNONAIxxAjvgydk49MccO
	 Gyty+jCR92w7YyOTfZYnSPrJGdS36A5nzPzko2+2C+Afucglk3eF45zIapVqZ233sk
	 HVIS+/BbU6LZcc9R63msCOntyUJFjfzDO1Kdh9k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 169/809] wifi: rtw89: 8852c: correct logic and restore PCI PHY EQ after device resume
Date: Tue, 30 Jul 2024 17:40:45 +0200
Message-ID: <20240730151731.282455589@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 9e305a6f01ad539dc134b8017521495378d8e00e ]

PCI PHY EQ value is missing after card off/on, so update the value after
device resume. The original commit only updates once at probe stage, which
could lead problem after suspend/resume.

The logic should be read a value from one register and write to another
register with a mask to avoid affecting unrelated bits.

Fixes: a78d33a1286c ("wifi: rtw89: 8852c: disable PCI PHY EQ to improve compatibility")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/20240521040139.20311-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 03bbcf9b6737c..b36aa9a6bb3fc 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -2330,21 +2330,20 @@ static void rtw89_pci_disable_eq(struct rtw89_dev *rtwdev)
 	u32 backup_aspm;
 	u32 phy_offset;
 	u16 oobs_val;
-	u16 val16;
 	int ret;
 
 	if (rtwdev->chip->chip_id != RTL8852C)
 		return;
 
-	backup_aspm = rtw89_read32(rtwdev, R_AX_PCIE_MIX_CFG_V1);
-	rtw89_write32_clr(rtwdev, R_AX_PCIE_MIX_CFG_V1, B_AX_ASPM_CTRL_MASK);
-
 	g1_oobs = rtw89_read16_mask(rtwdev, R_RAC_DIRECT_OFFSET_G1 +
 					    RAC_ANA09 * RAC_MULT, BAC_OOBS_SEL);
 	g2_oobs = rtw89_read16_mask(rtwdev, R_RAC_DIRECT_OFFSET_G2 +
 					    RAC_ANA09 * RAC_MULT, BAC_OOBS_SEL);
 	if (g1_oobs && g2_oobs)
-		goto out;
+		return;
+
+	backup_aspm = rtw89_read32(rtwdev, R_AX_PCIE_MIX_CFG_V1);
+	rtw89_write32_clr(rtwdev, R_AX_PCIE_MIX_CFG_V1, B_AX_ASPM_CTRL_MASK);
 
 	ret = rtw89_pci_get_phy_offset_by_link_speed(rtwdev, &phy_offset);
 	if (ret)
@@ -2354,15 +2353,16 @@ static void rtw89_pci_disable_eq(struct rtw89_dev *rtwdev)
 	rtw89_write16(rtwdev, phy_offset + RAC_ANA10 * RAC_MULT, ADDR_SEL_PINOUT_DIS_VAL);
 	rtw89_write16_set(rtwdev, phy_offset + RAC_ANA19 * RAC_MULT, B_PCIE_BIT_RD_SEL);
 
-	val16 = rtw89_read16_mask(rtwdev, phy_offset + RAC_ANA1F * RAC_MULT,
-				  OOBS_LEVEL_MASK);
-	oobs_val = u16_encode_bits(val16, OOBS_SEN_MASK);
+	oobs_val = rtw89_read16_mask(rtwdev, phy_offset + RAC_ANA1F * RAC_MULT,
+				     OOBS_LEVEL_MASK);
 
-	rtw89_write16(rtwdev, R_RAC_DIRECT_OFFSET_G1 + RAC_ANA03 * RAC_MULT, oobs_val);
+	rtw89_write16_mask(rtwdev, R_RAC_DIRECT_OFFSET_G1 + RAC_ANA03 * RAC_MULT,
+			   OOBS_SEN_MASK, oobs_val);
 	rtw89_write16_set(rtwdev, R_RAC_DIRECT_OFFSET_G1 + RAC_ANA09 * RAC_MULT,
 			  BAC_OOBS_SEL);
 
-	rtw89_write16(rtwdev, R_RAC_DIRECT_OFFSET_G2 + RAC_ANA03 * RAC_MULT, oobs_val);
+	rtw89_write16_mask(rtwdev, R_RAC_DIRECT_OFFSET_G2 + RAC_ANA03 * RAC_MULT,
+			   OOBS_SEN_MASK, oobs_val);
 	rtw89_write16_set(rtwdev, R_RAC_DIRECT_OFFSET_G2 + RAC_ANA09 * RAC_MULT,
 			  BAC_OOBS_SEL);
 
@@ -2783,7 +2783,6 @@ static int rtw89_pci_ops_mac_pre_init_ax(struct rtw89_dev *rtwdev)
 	const struct rtw89_pci_info *info = rtwdev->pci_info;
 	int ret;
 
-	rtw89_pci_disable_eq(rtwdev);
 	rtw89_pci_ber(rtwdev);
 	rtw89_pci_rxdma_prefth(rtwdev);
 	rtw89_pci_l1off_pwroff(rtwdev);
@@ -4155,6 +4154,7 @@ static int __maybe_unused rtw89_pci_resume(struct device *dev)
 				  B_AX_SEL_REQ_ENTR_L1);
 	}
 	rtw89_pci_l2_hci_ldo(rtwdev);
+	rtw89_pci_disable_eq(rtwdev);
 	rtw89_pci_filter_out(rtwdev);
 	rtw89_pci_link_cfg(rtwdev);
 	rtw89_pci_l1ss_cfg(rtwdev);
@@ -4289,6 +4289,7 @@ int rtw89_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_clear_resource;
 	}
 
+	rtw89_pci_disable_eq(rtwdev);
 	rtw89_pci_filter_out(rtwdev);
 	rtw89_pci_link_cfg(rtwdev);
 	rtw89_pci_l1ss_cfg(rtwdev);
-- 
2.43.0



