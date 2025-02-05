Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652F61519BE;
	Wed,  5 Feb 2025 14:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765167; cv=none; b=AHKYEoEjyF/KCJY7Gw6Xz8G1KzhLUrsKaIDMCngJq3GwBOXdU8rkJjaXWaEGTzD00cqsdCiQBcmoE4dct/biDBnvAgObA8bNOCNe6lIBm/9/VaAP30jlWYmjeUUzk78m583FKVVzFYn4XP3flvSLkuhRs9rJgE7crLxPmnpcgnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765167; c=relaxed/simple;
	bh=/d/IoqD2pO5mXETN9c7K1rcs3iROSXmsDk5UYqH4/i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGzYJr+w97kXFdAiTNzrrEKzavzPF08PLe3B76wLvNusvTDhjDizYMusbpJVHDDY001iK2odlKFwG4Draq7W0g6VU2sBCFJaVxPM5p6aWpKb0oDGv56ZrcHNXHg4MMtq+Jh/VCH/XcB2Je2SYv6zCuFqUAys5hsBeiI5xAsIFWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zksvklab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zksvklab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C397EC4CEDD;
	Wed,  5 Feb 2025 14:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765167;
	bh=/d/IoqD2pO5mXETN9c7K1rcs3iROSXmsDk5UYqH4/i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZksvklabHI8jaBc/hs89f3zh+6qtZKrRYnCTvxTQrAu/Sw/LeBclv18Yvpu/oMgin
	 jLQLK+lOLFn6ia03MTyelIX2lpStBsSx5hXMw4+Ylv9Fywr9aAgBtP3fzIwHU1V6Lg
	 pJX3bQnN5m4P75K8zFbxhCkBnw4FdgqkU7rkYxCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 196/590] wifi: mt76: mt7925: Properly handle responses for commands with events
Date: Wed,  5 Feb 2025 14:39:11 +0100
Message-ID: <20250205134502.777020656@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 349460913a4d029cc37c9e3817b1903233b4a627 ]

Properly retrieve the response for commands with events. Ensure accurate
handling of event-driven commands.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-17-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c |  1 -
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c  | 10 +++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 116b6980c7335..ddc67423efe2c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1244,7 +1244,6 @@ void mt7925_mac_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 		memcpy(dev_req.tlv.omac_addr, vif->addr, ETH_ALEN);
 		mt76_mcu_send_msg(mdev, MCU_UNI_CMD(DEV_INFO_UPDATE),
 				  &dev_req, sizeof(dev_req), true);
-
 	}
 
 	if (vif->type == NL80211_IFTYPE_STATION) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index c7dd263446c9e..ce3d8197b026a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1252,7 +1252,7 @@ int mt7925_mcu_set_mlo_roc(struct mt792x_bss_conf *mconf, u16 sel_links,
 	}
 
 	return mt76_mcu_send_msg(&mvif->phy->dev->mt76, MCU_UNI_CMD(ROC),
-				 &req, sizeof(req), false);
+				 &req, sizeof(req), true);
 }
 
 int mt7925_mcu_set_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
@@ -1301,7 +1301,7 @@ int mt7925_mcu_set_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
 	}
 
 	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(ROC),
-				 &req, sizeof(req), false);
+				 &req, sizeof(req), true);
 }
 
 int mt7925_mcu_abort_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
@@ -1331,7 +1331,7 @@ int mt7925_mcu_abort_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
 	};
 
 	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(ROC),
-				 &req, sizeof(req), false);
+				 &req, sizeof(req), true);
 }
 
 int mt7925_mcu_set_eeprom(struct mt792x_dev *dev)
@@ -1484,12 +1484,12 @@ mt7925_mcu_set_bss_pm(struct mt792x_dev *dev,
 	int err;
 
 	err = mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(BSS_INFO_UPDATE),
-				&req1, sizeof(req1), false);
+				&req1, sizeof(req1), true);
 	if (err < 0 || !enable)
 		return err;
 
 	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(BSS_INFO_UPDATE),
-				 &req, sizeof(req), false);
+				 &req, sizeof(req), true);
 }
 
 static void
-- 
2.39.5



