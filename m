Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861A5449B2A;
	Thu, 30 Jul 2026 16:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427463; cv=none; b=IDEEwXqUHg46FRTOGJPI6PhD21HEErPgCP4W/zIujwCFD8yQFXhJi12HdqAXEaK7AHCBsPm/qVlNXXtFBVrqSG6M7vGENhq4/hovXaliYq/aLga56OPRDQDYh1bHBq85wVqLuFCHROBEq8jO4z+x+AU3d9XQb7hoEYUv5HHASRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427463; c=relaxed/simple;
	bh=APme1/C2PW3yXIyBmNipkhD+IGnjAUc1fApAjKdCl/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmafILn/FRBEn4w1uQb/pb3l4Spgjr6P21zeMFgCLdOTDeKPYENo+qt2dX1txdcum1hcBUcEfoXyqDngvypF4YJWm5qTN+9DXyx9iK9LK6iSju6F6+zjozEDuZPwQa4ocBL0uztRTimSAOYHq7fPDcZh0AZjQ4XkTKtDnoV8xCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGsiEh8W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGsiEh8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93921F00A3A;
	Thu, 30 Jul 2026 16:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427462;
	bh=M/6Qb3Bw1SeOYF3oCfu+6OEXx9nVjeUOdHxsnSLpxZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rGsiEh8WcbUIeVTWwZwX38Up9pe3Qc+k0l5p/iy2yzbLv9FwmOkwiHBiAXt85gwNW
	 a0oUDi+leBEwczaMLdBAGkqtEIbC4N85Xpnjpps3jaagvn8rSvTyRzzaqoUgE8IbJo
	 Oqs0E4ztNQCAtz60PngNc12G5Bw2OJIjbPoT12h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/484] wifi: mt76: mt7996: fix possible NULL-pointer deref in mt7996_mcu_sta_bfer_eht()
Date: Thu, 30 Jul 2026 16:11:14 +0200
Message-ID: <20260730141427.313953031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 2fffc472bec490c8357defcee9c075ca74467352 ]

mt76_connac_get_eht_phy_cap routine can theoretically return NULL so
check cap pointer before dereferencing it.

Fixes: ba01944adee9f ("wifi: mt76: mt7996: add EHT beamforming support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260621-mt76_connac_get_he_phy_cap-fix-v1-4-ed4ccf7a0363@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index ccbd9b9c409d82..2abc8d15ea8522 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1360,14 +1360,18 @@ mt7996_mcu_sta_bfer_eht(struct ieee80211_sta *sta, struct ieee80211_vif *vif,
 	struct ieee80211_sta_eht_cap *pc = &sta->deflink.eht_cap;
 	struct ieee80211_eht_cap_elem_fixed *pe = &pc->eht_cap_elem;
 	struct ieee80211_eht_mcs_nss_supp *eht_nss = &pc->eht_mcs_nss_supp;
-	const struct ieee80211_sta_eht_cap *vc =
-		mt76_connac_get_eht_phy_cap(phy->mt76, vif);
-	const struct ieee80211_eht_cap_elem_fixed *ve = &vc->eht_cap_elem;
 	u8 nss_mcs = u8_get_bits(eht_nss->bw._80.rx_tx_mcs9_max_nss,
 				 IEEE80211_EHT_MCS_NSS_RX) - 1;
+	const struct ieee80211_eht_cap_elem_fixed *ve;
+	const struct ieee80211_sta_eht_cap *vc;
 	u8 snd_dim, sts;
 
+	vc = mt76_connac_get_eht_phy_cap(phy->mt76, vif);
+	if (!vc)
+		return;
+
 	bf->tx_mode = MT_PHY_TYPE_EHT_MU;
+	ve = &vc->eht_cap_elem;
 
 	mt7996_mcu_sta_sounding_rate(bf);
 
-- 
2.53.0



