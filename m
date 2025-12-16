Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9726B33D6E5;
	Tue, 16 Dec 2025 11:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886055; cv=none; b=kxRO9mLMZCTb+C/MVB5ExjpWiCeMcXHSMlUWFSOuoOTCbo+hDRzqSmXQdklekhKCuqBcgb6bmW1b0CrgQFSWMB4EuBtRuaBCk0PdbpI8uDvIoA73XyZ23nYdaYlo2fiAUWO7TaGnJTT5xlef6YKlDaMavI+RF3gbxKQVDwNn6xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886055; c=relaxed/simple;
	bh=Swvaz41RXOn+tjpBXZJhoa2f9+S9YJU9xapDTKhOMeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WL7yjusm7obuJls3g7W7Kn9LAqkj5F2S/jmO9JKVaAEj5GSHK0c4eTrD8WKCWh6pURRRtHeMTAn4xmhsPoUAOfdQYlG8XNvw76RImtu6rnTzGbeZiT5yeizXewD952F932q5T8PtXDN5qezkVkGGW878rFQClx+XsnTTeUYw10Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5HAUN6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5HAUN6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D4DC4CEF1;
	Tue, 16 Dec 2025 11:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886055;
	bh=Swvaz41RXOn+tjpBXZJhoa2f9+S9YJU9xapDTKhOMeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5HAUN6eZKIRpKMX7NHgJL794Mavk0DgbSuA2fxhdldLE8C85iJ6EYDhZZkSSr2Vz
	 MDY5wNIREVnp+uQHO4QhJ3J6Mna0my5gMBR/fL7byV3qRhwHgEsES2A4JjxdPK/hwI
	 5i3PyMuEuNp7cuXTu486t1pWCkOSvHy3EryE0ca8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 325/507] wifi: mt76: mt7921: add MBSSID support
Date: Tue, 16 Dec 2025 12:12:46 +0100
Message-ID: <20251216111357.240328352@linuxfoundation.org>
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

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 7ae99dd459ba1ea83a9b3d8de254f374182e602c ]

Enable MBSSID support for MT7921 by setting the
appropriate capability to the firmware.

Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250812111642.3620845-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: cdb2941a516c ("Revert "wifi: mt76: mt792x: improve monitor interface handling"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.c  | 25 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt792x_core.c  |  5 ++--
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 16db0f2082d1e..fc3e6728fcfbf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1662,6 +1662,31 @@ int mt76_connac_mcu_uni_add_bss(struct mt76_phy *phy,
 			return err;
 	}
 
+	if (enable && vif->bss_conf.bssid_indicator) {
+		struct {
+			struct {
+				u8 bss_idx;
+				u8 pad[3];
+			} __packed hdr;
+			struct bss_info_uni_mbssid mbssid;
+		} mbssid_req = {
+			.hdr = {
+				.bss_idx = mvif->idx,
+			},
+			.mbssid = {
+				.tag = cpu_to_le16(UNI_BSS_INFO_11V_MBSSID),
+				.len = cpu_to_le16(sizeof(struct bss_info_uni_mbssid)),
+				.max_indicator = vif->bss_conf.bssid_indicator,
+				.mbss_idx =  vif->bss_conf.bssid_index,
+			},
+		};
+
+		err = mt76_mcu_send_msg(mdev, MCU_UNI_CMD(BSS_INFO_UPDATE),
+					&mbssid_req, sizeof(mbssid_req), true);
+		if (err < 0)
+			return err;
+	}
+
 	return mt76_connac_mcu_uni_set_chctx(phy, mvif, ctx);
 }
 EXPORT_SYMBOL_GPL(mt76_connac_mcu_uni_add_bss);
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index 44378f7394e8d..c0e56541a9547 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -689,12 +689,11 @@ int mt792x_init_wiphy(struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, SUPPORTS_VHT_EXT_NSS_BW);
 	ieee80211_hw_set(hw, CONNECTION_MONITOR);
 	ieee80211_hw_set(hw, NO_VIRTUAL_MONITOR);
+	ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
+	ieee80211_hw_set(hw, SUPPORTS_ONLY_HE_MULTI_BSSID);
 
 	if (is_mt7921(&dev->mt76)) {
 		ieee80211_hw_set(hw, CHANCTX_STA_CSA);
-	} else {
-		ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
-		ieee80211_hw_set(hw, SUPPORTS_ONLY_HE_MULTI_BSSID);
 	}
 
 	if (dev->pm.enable)
-- 
2.51.0



