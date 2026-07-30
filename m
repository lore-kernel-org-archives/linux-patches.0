Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A183538657E;
	Thu, 30 Jul 2026 15:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425844; cv=none; b=YUVMLQ/S2i0kpfmUgHrq618/WL4h9N6oPej0Mx3rm1G0+X6fM4ZctmLzkA/ACNfbSJt8i/B+IdUrDnkMxHJK4aO7+ZjW9uetlYMgW6acjEwiQW8FBcEymaWxAt/PICzlTGz2DLmPC8kCBwE+NM42nuagxp1AH+oGKuceozJee1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425844; c=relaxed/simple;
	bh=MYr2gFSD8K6IHWdllopjFJ8x7Tdt0IfO2eQ2OKsdcxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaqXkS7n04Foo3mBTU8imPy5Mgukfgb/D+vGvu8YOtJ23XoWCQVr1hoBMTqNu4hcKARqT2ULaYHQIFVgN+KxYTzVAi112/DP2Ptt/LjCTRqUXy14y77RAmJOaJ88Z5Moxea/aLyTRfQMS3aEp37jWVMihj/+0m/k8oMAE0qdYNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xM9KHUac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xM9KHUac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042041F000E9;
	Thu, 30 Jul 2026 15:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425843;
	bh=hLeLlUeAezsP/+m0xPhgsKqdIVpJiBXbzfdtHTP2IsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xM9KHUacIwYEVXGLrSiv8k7L8R9fL6gvns7EfZL21G6ht8vUtCBk5aRHFe9rfhRBG
	 EAGuT46YuWQOjlMy7Buiu37yRqSiPiu++KBNanNrJYOpYmV5smbeLUSNiVIErXM7JD
	 y2uutKzZtocTG1o2CgSzA9YtXQ8SbnuPtR7N4Eks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 211/602] wifi: mt76: mt7996: fix possible NULL-pointer deref in mt7996_mcu_sta_bfer_eht()
Date: Thu, 30 Jul 2026 16:10:03 +0200
Message-ID: <20260730141440.388651075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 5730980fdc64eb..a5693efee74b85 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1604,14 +1604,18 @@ mt7996_mcu_sta_bfer_eht(struct ieee80211_sta *sta, struct ieee80211_vif *vif,
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



