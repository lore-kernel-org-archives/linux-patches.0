Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5709A46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B0BC433EF;
	Mon, 16 Jan 2023 16:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885567;
	bh=bo6XE/YdRJaQNeYc9BDV036GtXFwChRa8OJ+V2WwGDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCUAFLg5dEkX/c/aNQWrO414Ycn83Vlj3x9Q1VE8xSTTvCyJDpMeVx7JTtFcPC8xe
	 OBYTZA7gTXIMxCXOhz3efTxGIS4Ck5LepGQAnm/sY6f3rPOZJeKNWKjIN6ObcDbUSh
	 pKYr1jczCBWophBlPJP1L4SM8XGFearndeokcy/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/658] wifi: rtl8xxxu: Fix reading the vendor of combo chips
Date: Mon, 16 Jan 2023 16:43:09 +0100
Message-Id: <20230116154914.170061316@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 6f103aeb5e985ac08f3a4a049a2c17294f40cff9 ]

The wifi + bluetooth combo chips (RTL8723AU and RTL8723BU) read the
chip vendor from the wrong register because the val32 variable gets
overwritten. Add one more variable to avoid this.

This had no real effect on RTL8723BU. It may have had an effect on
RTL8723AU.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/24af8024-2f07-552b-93d8-38823d8e3cb0@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c    | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index b472dc4c551e..4a81e810a0ce 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1608,18 +1608,18 @@ static void rtl8xxxu_print_chipinfo(struct rtl8xxxu_priv *priv)
 static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 {
 	struct device *dev = &priv->udev->dev;
-	u32 val32, bonding;
+	u32 val32, bonding, sys_cfg;
 	u16 val16;
 
-	val32 = rtl8xxxu_read32(priv, REG_SYS_CFG);
-	priv->chip_cut = (val32 & SYS_CFG_CHIP_VERSION_MASK) >>
+	sys_cfg = rtl8xxxu_read32(priv, REG_SYS_CFG);
+	priv->chip_cut = (sys_cfg & SYS_CFG_CHIP_VERSION_MASK) >>
 		SYS_CFG_CHIP_VERSION_SHIFT;
-	if (val32 & SYS_CFG_TRP_VAUX_EN) {
+	if (sys_cfg & SYS_CFG_TRP_VAUX_EN) {
 		dev_info(dev, "Unsupported test chip\n");
 		return -ENOTSUPP;
 	}
 
-	if (val32 & SYS_CFG_BT_FUNC) {
+	if (sys_cfg & SYS_CFG_BT_FUNC) {
 		if (priv->chip_cut >= 3) {
 			sprintf(priv->chip_name, "8723BU");
 			priv->rtl_chip = RTL8723B;
@@ -1641,7 +1641,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 		if (val32 & MULTI_GPS_FUNC_EN)
 			priv->has_gps = 1;
 		priv->is_multi_func = 1;
-	} else if (val32 & SYS_CFG_TYPE_ID) {
+	} else if (sys_cfg & SYS_CFG_TYPE_ID) {
 		bonding = rtl8xxxu_read32(priv, REG_HPON_FSM);
 		bonding &= HPON_FSM_BONDING_MASK;
 		if (priv->fops->tx_desc_size ==
@@ -1689,7 +1689,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 	case RTL8188E:
 	case RTL8192E:
 	case RTL8723B:
-		switch (val32 & SYS_CFG_VENDOR_EXT_MASK) {
+		switch (sys_cfg & SYS_CFG_VENDOR_EXT_MASK) {
 		case SYS_CFG_VENDOR_ID_TSMC:
 			sprintf(priv->chip_vendor, "TSMC");
 			break;
@@ -1706,7 +1706,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 		}
 		break;
 	default:
-		if (val32 & SYS_CFG_VENDOR_ID) {
+		if (sys_cfg & SYS_CFG_VENDOR_ID) {
 			sprintf(priv->chip_vendor, "UMC");
 			priv->vendor_umc = 1;
 		} else {
-- 
2.35.1



