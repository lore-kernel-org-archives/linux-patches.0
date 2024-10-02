Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2ED1D0DE1;
	Wed,  2 Oct 2024 14:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879230; cv=none; b=nqSTjz9P3Eq7zu/hTtPtauoDK630eEg1T20T9njTYhSVr/E8bQWc9uSqs/O74pDTARH3LAkRlXOMSJo8ZWyxyj7aorFFPc/PXfiX22GbPtTJE7MW95ufUL/+pmCS/Q62zzmCVzCFU9yDNF8O3iqfWsluv2efpCAdFnSRTffiUsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879230; c=relaxed/simple;
	bh=pLvI9UfJHBkKRBAu1nYnC46ksJWT5eCGf6TH4rfRCIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwXVeKpQLpoulpeqRkJfCcTPTY3plWCJNLwJ5wKT5tir40IpRicIf1aiQxWekrvxZWjHAHHG1B4GtZdIYZhWgNXvodtMZh0QJgObah5yrNoA62YIlS/kR6guuoPZgAwtHfit3jU7zYkhJ6CT8k3Vcd5SufxZMB6J2p5Lc4MaB80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5B/J5nr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5B/J5nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAEEC4CEC2;
	Wed,  2 Oct 2024 14:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879229;
	bh=pLvI9UfJHBkKRBAu1nYnC46ksJWT5eCGf6TH4rfRCIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5B/J5nrwTAXF+D1HT7ZuNtFcdKM+mU8hk3w7Bk5SWsepAHbxUGvnfoJM0eLp9n2u
	 N4pwVv+Cvryrmwwt9Q1eqmVJeU18z1umegKQxWEI1LN952dyFH+XKOVOgsoLRxvcX6
	 GrgWs8a2CnO0DUK/U0vKO/DahJjvHNkM/K7P9org=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/538] wifi: mt76: mt7996: fix HE and EHT beamforming capabilities
Date: Wed,  2 Oct 2024 14:54:46 +0200
Message-ID: <20241002125753.886231897@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2016ed9197fe3..aee531cab46f6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -561,8 +561,6 @@ mt7996_set_stream_he_txbf_caps(struct mt7996_phy *phy,
 		return;
 
 	elem->phy_cap_info[3] |= IEEE80211_HE_PHY_CAP3_SU_BEAMFORMER;
-	if (vif == NL80211_IFTYPE_AP)
-		elem->phy_cap_info[4] |= IEEE80211_HE_PHY_CAP4_MU_BEAMFORMER;
 
 	c = FIELD_PREP(IEEE80211_HE_PHY_CAP5_BEAMFORMEE_NUM_SND_DIM_UNDER_80MHZ_MASK,
 		       sts - 1) |
@@ -570,6 +568,11 @@ mt7996_set_stream_he_txbf_caps(struct mt7996_phy *phy,
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
@@ -729,7 +732,6 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 		IEEE80211_EHT_MAC_CAP0_OM_CONTROL;
 
 	eht_cap_elem->phy_cap_info[0] =
-		IEEE80211_EHT_PHY_CAP0_320MHZ_IN_6GHZ |
 		IEEE80211_EHT_PHY_CAP0_NDP_4_EHT_LFT_32_GI |
 		IEEE80211_EHT_PHY_CAP0_SU_BEAMFORMER |
 		IEEE80211_EHT_PHY_CAP0_SU_BEAMFORMEE;
@@ -743,30 +745,36 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
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
@@ -780,14 +788,6 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
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
@@ -798,8 +798,29 @@ mt7996_init_eht_caps(struct mt7996_phy *phy, enum nl80211_band band,
 
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



