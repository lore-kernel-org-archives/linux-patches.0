Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708A71D04A2;
	Wed,  2 Oct 2024 13:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877500; cv=none; b=r8wuLzqw6XAluVCPVNIwqdPlTfXSO+yg3hXBYZMudcZbsjaI9alKEvAOOmIscyP1rKlFF2fMeABDVNS2jARmvPBB4mkOy5oZzlAaADicwZp1xcsjOXIVTjS5d7YDZrJPrCGNH8rHWZdCygJ1tR/H3ggvjkskwKibEC1Q6/slxNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877500; c=relaxed/simple;
	bh=deOTsmh0M6tK9R4p0qVxtpMLXky2dVMwuP+bhZidwPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkj2mhMYihVhs8GVdf1kSmS8d93QBFpvtlxcmOTzop2QxJTmciaGEYsPihkBpm/7CLABJVnF3EqwhxI2U088zh0csZxw/JdTxLbbHbzkZ7htwxyWnRcG2Hz5UAaQYmPPkvEDvvIsbl2Osq7CYjYTlx3iQ4AAoYKicLrMcOoE8ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eogU3XYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eogU3XYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD30C4CEC2;
	Wed,  2 Oct 2024 13:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877500;
	bh=deOTsmh0M6tK9R4p0qVxtpMLXky2dVMwuP+bhZidwPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eogU3XYLB3cAge8in7Oab1Gv5wvmk0Zu2dC/L8r3WFHHftAKcvWtJuz2uap4B6CB3
	 f+5l/rmYklXBHt16VS+qkthl1kkZGTD6PxX0KYrsfoQXXjRzJT1XnVftRexQ3wsm5R
	 IpYfDmf6+9o0lZ5NPQ6WtlfZTYx1OkqoDBMB8qLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 068/634] wifi: mt76: mt7996: fix HE and EHT beamforming capabilities
Date: Wed,  2 Oct 2024 14:52:48 +0200
Message-ID: <20241002125813.790489126@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit e1f4847fdbdf5d44ae60e035c131920e5ab88598 ]

Fix HE and EHT beamforming capabilities for different bands and
interface types.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Fixes: 348533eb968d ("wifi: mt76: mt7996: add EHT capability init")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20240816094635.2391-5-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/init.c  | 65 ++++++++++++-------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 283df84f1b433..a98dcb40490bf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1011,8 +1011,6 @@ mt7996_set_stream_he_txbf_caps(struct mt7996_phy *phy,
 		return;
 
 	elem->phy_cap_info[3] |= IEEE80211_HE_PHY_CAP3_SU_BEAMFORMER;
-	if (vif == NL80211_IFTYPE_AP)
-		elem->phy_cap_info[4] |= IEEE80211_HE_PHY_CAP4_MU_BEAMFORMER;
 
 	c = FIELD_PREP(IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_UNDER_80MHZ_MASK,
 		       sts - 1) |
@@ -1020,6 +1018,11 @@ mt7996_set_stream_he_txbf_caps(struct mt7996_phy *phy,
 		       sts - 1);
 	elem->phy_cap_info[5] |= c;
 
+	if (vif != NL80211_IFTYPE_AP)
+		return;
+
+	elem->phy_cap_info[4] |= IEEE80211_HE_PHY_CAP4_MU_BEAMFORMER;
+
 	c = IEEE80211_HE_PHY_CAP6_TRIG_SU_BEAMFORMING_FB |
 	    IEEE80211_HE_PHY_CAP6_TRIG_MU_BEAMFORMING_PARTIAL_BW_FB;
 	elem->phy_cap_info[6] |= c;
@@ -1179,7 +1182,6 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 		IEEE80211_EHT_MAC_CAP0_OM_CONTROL;
 
 	eht_cap_elem->phy_cap_info[0] =
-		IEEE80211_EHT_PHY_CAP0_320MHZ_IN_6GHZ |
 		IEEE80211_EHT_PHY_CAP0_NDP_4_EHT_LFT_32_GI |
 		IEEE80211_EHT_PHY_CAP0_SU_BEAMFORMER |
 		IEEE80211_EHT_PHY_CAP0_SU_BEAMFORMEE;
@@ -1193,30 +1195,36 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 		u8_encode_bits(u8_get_bits(val, GENMASK(2, 1)),
 			       IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_80MHZ_MASK) |
 		u8_encode_bits(val,
-			       IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_160MHZ_MASK) |
-		u8_encode_bits(val,
-			       IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_320MHZ_MASK);
+			       IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_160MHZ_MASK);
 
 	eht_cap_elem->phy_cap_info[2] =
 		u8_encode_bits(sts - 1, IEEE80211_EHT_PHY_CAP2_SOUNDING_DIM_80MHZ_MASK) |
-		u8_encode_bits(sts - 1, IEEE80211_EHT_PHY_CAP2_SOUNDING_DIM_160MHZ_MASK) |
-		u8_encode_bits(sts - 1, IEEE80211_EHT_PHY_CAP2_SOUNDING_DIM_320MHZ_MASK);
+		u8_encode_bits(sts - 1, IEEE80211_EHT_PHY_CAP2_SOUNDING_DIM_160MHZ_MASK);
+
+	if (band == NL80211_BAND_6GHZ) {
+		eht_cap_elem->phy_cap_info[0] |=
+			IEEE80211_EHT_PHY_CAP0_320MHZ_IN_6GHZ;
+
+		eht_cap_elem->phy_cap_info[1] |=
+			u8_encode_bits(val,
+				       IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_320MHZ_MASK);
+
+		eht_cap_elem->phy_cap_info[2] |=
+			u8_encode_bits(sts - 1,
+				       IEEE80211_EHT_PHY_CAP2_SOUNDING_DIM_320MHZ_MASK);
+	}
 
 	eht_cap_elem->phy_cap_info[3] =
 		IEEE80211_EHT_PHY_CAP3_NG_16_SU_FEEDBACK |
 		IEEE80211_EHT_PHY_CAP3_NG_16_MU_FEEDBACK |
 		IEEE80211_EHT_PHY_CAP3_CODEBOOK_4_2_SU_FDBK |
-		IEEE80211_EHT_PHY_CAP3_CODEBOOK_7_5_MU_FDBK |
-		IEEE80211_EHT_PHY_CAP3_TRIG_SU_BF_FDBK |
-		IEEE80211_EHT_PHY_CAP3_TRIG_MU_BF_PART_BW_FDBK |
-		IEEE80211_EHT_PHY_CAP3_TRIG_CQI_FDBK;
+		IEEE80211_EHT_PHY_CAP3_CODEBOOK_7_5_MU_FDBK;
 
 	eht_cap_elem->phy_cap_info[4] =
 		u8_encode_bits(min_t(int, sts - 1, 2),
 			       IEEE80211_EHT_PHY_CAP4_MAX_NC_MASK);
 
 	eht_cap_elem->phy_cap_info[5] =
-		IEEE80211_EHT_PHY_CAP5_NON_TRIG_CQI_FEEDBACK |
 		u8_encode_bits(IEEE80211_EHT_PHY_CAP5_COMMON_NOMINAL_PKT_PAD_16US,
 			       IEEE80211_EHT_PHY_CAP5_COMMON_NOMINAL_PKT_PAD_MASK) |
 		u8_encode_bits(u8_get_bits(0x11, GENMASK(1, 0)),
@@ -1230,14 +1238,6 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 			       IEEE80211_EHT_PHY_CAP6_MAX_NUM_SUPP_EHT_LTF_MASK) |
 		u8_encode_bits(val, IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_MASK);
 
-	eht_cap_elem->phy_cap_info[7] =
-		IEEE80211_EHT_PHY_CAP7_NON_OFDMA_UL_MU_MIMO_80MHZ |
-		IEEE80211_EHT_PHY_CAP7_NON_OFDMA_UL_MU_MIMO_160MHZ |
-		IEEE80211_EHT_PHY_CAP7_NON_OFDMA_UL_MU_MIMO_320MHZ |
-		IEEE80211_EHT_PHY_CAP7_MU_BEAMFORMER_80MHZ |
-		IEEE80211_EHT_PHY_CAP7_MU_BEAMFORMER_160MHZ |
-		IEEE80211_EHT_PHY_CAP7_MU_BEAMFORMER_320MHZ;
-
 	val = u8_encode_bits(nss, IEEE80211_EHT_MCS_NSS_RX) |
 	      u8_encode_bits(nss, IEEE80211_EHT_MCS_NSS_TX);
 #define SET_EHT_MAX_NSS(_bw, _val) do {				\
@@ -1248,8 +1248,29 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 
 	SET_EHT_MAX_NSS(80, val);
 	SET_EHT_MAX_NSS(160, val);
-	SET_EHT_MAX_NSS(320, val);
+	if (band == NL80211_BAND_6GHZ)
+		SET_EHT_MAX_NSS(320, val);
 #undef SET_EHT_MAX_NSS
+
+	if (iftype != NL80211_IFTYPE_AP)
+		return;
+
+	eht_cap_elem->phy_cap_info[3] |=
+		IEEE80211_EHT_PHY_CAP3_TRIG_SU_BF_FDBK |
+		IEEE80211_EHT_PHY_CAP3_TRIG_MU_BF_PART_BW_FDBK;
+
+	eht_cap_elem->phy_cap_info[7] =
+		IEEE80211_EHT_PHY_CAP7_NON_OFDMA_UL_MU_MIMO_80MHZ |
+		IEEE80211_EHT_PHY_CAP7_NON_OFDMA_UL_MU_MIMO_160MHZ |
+		IEEE80211_EHT_PHY_CAP7_MU_BEAMFORMER_80MHZ |
+		IEEE80211_EHT_PHY_CAP7_MU_BEAMFORMER_160MHZ;
+
+	if (band != NL80211_BAND_6GHZ)
+		return;
+
+	eht_cap_elem->phy_cap_info[7] |=
+		IEEE80211_EHT_PHY_CAP7_NON_OFDMA_UL_MU_MIMO_320MHZ |
+		IEEE80211_EHT_PHY_CAP7_MU_BEAMFORMER_320MHZ;
 }
 
 static void
-- 
2.43.0



