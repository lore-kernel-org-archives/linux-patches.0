Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3B42F235F;
	Tue, 17 Jun 2025 16:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176009; cv=none; b=k+gz+3G3RxBRbk6rjDu2T7fEUs6tOyQdVXEouRa1JRetQGoax941aVjJZMYW+vi907GD/PNHK/6mVcGadx+CDJ5LuiJTFnpxmcqrv4byPCi2HEpuv7a9rqBRETqHAY0CmEIoIp3C5IazMqZ/l9jav3Fft04onogDMP4iTEnPPqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176009; c=relaxed/simple;
	bh=T1LSHwO1rHixtmZPDE8DTfPmoBiOZtfM6QY7+nuoV7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfxzIHqa+x3DfxN/yakGzIX0dEaDoe4P4+MXIMRMSzRTSoBTGydLmJrgZxOTXJ6IGCUjZ1Twd8JRySERAIlgXuiJGHL02LKGIDXibXrOw4PXE/27/pG9uMuxdQ3SgIIYtnwL17nzOrOK3uiK0An1ZYIVmp5lZil7hW9g1Kb+py4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjH5GDz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjH5GDz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2CAC4CEE7;
	Tue, 17 Jun 2025 16:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176008;
	bh=T1LSHwO1rHixtmZPDE8DTfPmoBiOZtfM6QY7+nuoV7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjH5GDz6IXPKupORljQlJoq9PEtUVeUg0KeJFKm+gSmbmZfiJ6BOTy8ZFnV/Fpv/q
	 yO9ghHUz2QkvieTLh1bpBi1L9CD4c6+3rv75A2Xv53j9nhFJyS4+B8+HI10R2vJTfA
	 R6fVafgv5qFSL0/O0FHeGFbP014Q6u9QtebtzP+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Lo <michael.lo@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/512] wifi: mt76: mt7925: ensure all MCU commands wait for response
Date: Tue, 17 Jun 2025 17:22:33 +0200
Message-ID: <20250617152427.220762475@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Michael Lo <michael.lo@mediatek.com>

[ Upstream commit aa97ff5782cf01cf2163593e1f57bbde63a06047 ]

Modify MCU command sending functions to wait for a response,
ensuring consistent behavior across all commands and improves
reliability by confirming that each command is processed
successfully.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Michael Lo <michael.lo@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250414013954.1151774-3-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 9a9900eba5020..a19c108ad4b5c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -769,7 +769,7 @@ int mt7925_mcu_fw_log_2_host(struct mt792x_dev *dev, u8 ctrl)
 	int ret;
 
 	ret = mt76_mcu_send_and_get_msg(&dev->mt76, MCU_UNI_CMD(WSYS_CONFIG),
-					&req, sizeof(req), false, NULL);
+					&req, sizeof(req), true, NULL);
 	return ret;
 }
 
@@ -1411,7 +1411,7 @@ int mt7925_mcu_set_eeprom(struct mt792x_dev *dev)
 	};
 
 	return mt76_mcu_send_and_get_msg(&dev->mt76, MCU_UNI_CMD(EFUSE_CTRL),
-					 &req, sizeof(req), false, NULL);
+					 &req, sizeof(req), true, NULL);
 }
 EXPORT_SYMBOL_GPL(mt7925_mcu_set_eeprom);
 
@@ -2741,7 +2741,7 @@ int mt7925_mcu_set_dbdc(struct mt76_phy *phy, bool enable)
 	conf->band = 0; /* unused */
 
 	err = mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(SET_DBDC_PARMS),
-				    false);
+				    true);
 
 	return err;
 }
@@ -2859,7 +2859,7 @@ int mt7925_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	}
 
 	err = mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(SCAN_REQ),
-				    false);
+				    true);
 	if (err < 0)
 		clear_bit(MT76_HW_SCANNING, &phy->state);
 
@@ -2965,7 +2965,7 @@ int mt7925_mcu_sched_scan_req(struct mt76_phy *phy,
 	}
 
 	return mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(SCAN_REQ),
-				     false);
+				     true);
 }
 EXPORT_SYMBOL_GPL(mt7925_mcu_sched_scan_req);
 
@@ -3001,7 +3001,7 @@ mt7925_mcu_sched_scan_enable(struct mt76_phy *phy,
 		clear_bit(MT76_HW_SCHED_SCANNING, &phy->state);
 
 	return mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(SCAN_REQ),
-				     false);
+				     true);
 }
 
 int mt7925_mcu_cancel_hw_scan(struct mt76_phy *phy,
@@ -3040,7 +3040,7 @@ int mt7925_mcu_cancel_hw_scan(struct mt76_phy *phy,
 	}
 
 	return mt76_mcu_send_msg(phy->dev, MCU_UNI_CMD(SCAN_REQ),
-				 &req, sizeof(req), false);
+				 &req, sizeof(req), true);
 }
 EXPORT_SYMBOL_GPL(mt7925_mcu_cancel_hw_scan);
 
@@ -3145,7 +3145,7 @@ int mt7925_mcu_set_channel_domain(struct mt76_phy *phy)
 	memcpy(__skb_push(skb, sizeof(req)), &req, sizeof(req));
 
 	return mt76_mcu_skb_send_msg(dev, skb, MCU_UNI_CMD(SET_DOMAIN_INFO),
-				     false);
+				     true);
 }
 EXPORT_SYMBOL_GPL(mt7925_mcu_set_channel_domain);
 
-- 
2.39.5



