Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DA8438468;
	Thu, 30 Jul 2026 14:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422015; cv=none; b=Ju/uYjwi/61bSUScaNZ4Wid5UREbDiyRFTkQQWjuvDYvlrm/QramMfLbE0utA1OORxgjygzc/GHbmlqYBYzotmt9z8C9KhYvd2T4t5/RGlTaRRd0j//rX1NwCIoHPkp/nHvR4COyOvuh0X2iRo+yqT+zzPQVt5k4gNiVpndoHYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422015; c=relaxed/simple;
	bh=O9kEHKxB7+pu+/rYG/jjZDsZGnlY0he9M7lHIgNoNkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeqC6CNmWcpxMEdSlhVudKXtvMSAjrVLTqGQrf3mFhQTnwBnMz9gvWOIWvKIfIn022uC65mgtWS+Bky/edGfXd5SAtx7cPKgxAspzVrkIkfzq6uhBqrdvMUdI27hKSz5ZBHiDyAhRoOiypksFvJKxNsGJXY6gGHo9LYWE3BnKlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlOYuidl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlOYuidl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE7F1F000E9;
	Thu, 30 Jul 2026 14:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422014;
	bh=5BxB09Lsl0P//15YVzkKn/UH8EQ5u/o7Xl/8SxBtXCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OlOYuidlyQCDcyjb+24qjNQ0n/YUq3d6rQZlKRRivhV8NR8Y8vmpOvaHLllZ8vnsC
	 HbgvBsViC4f2XJfu0WtzPioG6hXX8CeHGWETdg2nqQ9ABnhVlsy/yaEs+eYcPb69Fj
	 uK9RrlaFWPLrs1fpTXEYASjLelLuqtjMiXE6lPws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 296/744] wifi: mt76: mt7996: fix possible NULL-pointer deref in mt7996_mcu_sta_bfer_eht()
Date: Thu, 30 Jul 2026 16:09:29 +0200
Message-ID: <20260730141450.584964545@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index a6a21ddd17a2a0..9772475c5e6b28 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1920,14 +1920,18 @@ mt7996_mcu_sta_bfer_eht(struct ieee80211_link_sta *link_sta,
 	struct ieee80211_sta_eht_cap *pc = &link_sta->eht_cap;
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
 
 	mt7996_mcu_sta_sounding_rate(bf, phy);
 
-- 
2.53.0



