Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C433ACA6F;
	Sat, 12 Sep 2026 10:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209347; cv=none; b=ZqMAkmVkOAOXUgJYhovGSjW+O3GVMXmcIHQ9g/DB0RQg8+hCLfnANDF1btgtAsrLTaCeB3e80uNQ7Zu4mEFGvCN83QjCmRbgLU+h3Go2tYNKf4tpSQ6LvWDPoNac6WSD1SEWQDkl2F8qr6iiExBqiFeo4m3Ktfj2ZOFGOEbt3eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209347; c=relaxed/simple;
	bh=prGXwfnb2DFT5dKT2fpnCWXphZuFh3OVp74FkDdG0qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOe2rJj61723kerTm8+jQ5pd6eW8LDXJdlKQVGMyuwSNO/Lv4FVdOL2exKQDoD+qW4w7bLU3yvWgqfw0lKqRPyh46dZMf2fmEEdnA04SZ9eaQCe6mn13ofrv8tfWKDJJC+QVZRwrQPVoWB1CWB4JPc7fRTtFMosfDYoQ+ezAPuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5rPBnSP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5rPBnSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE201F000FF;
	Sat, 12 Sep 2026 10:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209345;
	bh=ax76iKRZ191zOUtsu0qOgBLiAL7kt3Zq37e+nbiSWzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c5rPBnSPqx5j71wOulG1VjLlVlRyK6MUCC7HXptKE8wnhTKtfOkoM+RfyMXl8Z8yD
	 nh36Az9Tz1AHtbn3eAbLqtmDXK+MGKl4N9Qx6tgicFxP/03ah7oux9rxIDgN1w5Bbj
	 S1ce7dObukuHc7pvVuN4ERabPghlxH/ZFMZfC6I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"shengwei.lu" <shengwei.lu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0802/1518] wifi: mt76: mt7925: Fix EHT Beamformee SS subfields to meet 802.11be minimum
Date: Sat, 12 Sep 2026 08:49:31 +0200
Message-ID: <20260912065641.575364412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: shengwei.lu <shengwei.lu@mediatek.com>

[ Upstream commit 404c4e564f6b1eeffd10bf2b2d3b86620f5794c3 ]

Per IEEE 802.11be, the Beamformee SS <= 80/160/320 MHz 3-bit subfields
in the EHT PHY Capabilities are encoded as (Nss - 1) and are required
to be >= 3 (i.e. at least 4 SS receive capability) whenever SU
Beamformee is advertised.

MT7925 is a 2x2 STA (sts = 2), so directly filling (sts - 1) = 1
violates the spec minimum. Clamp the encoded value to 3 when sts <= 3,
otherwise use (sts - 1). This is applied consistently to the
BEAMFORMEE_SS <= 80 MHz (split across phy_cap_info[0]/[1]), <= 160 MHz
and <= 320 MHz (6 GHz only) subfields.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: shengwei.lu <shengwei.lu@mediatek.com>
Link: https://patch.msgid.link/20260723031108.2017653-1-jb.tsai@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index c291e05496b47..1eeb33981c743 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -182,19 +182,21 @@ mt7925_init_eht_caps(struct mt792x_phy *phy, enum nl80211_band band,
 		eht_cap_elem->phy_cap_info[0] |=
 			IEEE80211_EHT_PHY_CAP0_320MHZ_IN_6GHZ;
 
+	val = (sts > 3) ? sts - 1 : 3;
+
 	eht_cap_elem->phy_cap_info[0] |=
-		u8_encode_bits(u8_get_bits(sts - 1, BIT(0)),
+		u8_encode_bits(u8_get_bits(val, BIT(0)),
 			       IEEE80211_EHT_PHY_CAP0_BEAMFORMEE_SS_80MHZ_MASK);
 
 	eht_cap_elem->phy_cap_info[1] =
-		u8_encode_bits(u8_get_bits(sts - 1, GENMASK(2, 1)),
+		u8_encode_bits(u8_get_bits(val, GENMASK(2, 1)),
 			       IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_80MHZ_MASK) |
-		u8_encode_bits(sts - 1,
+		u8_encode_bits(val,
 			       IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_160MHZ_MASK);
 
 	if (band == NL80211_BAND_6GHZ && is_320mhz_supported(&phy->dev->mt76))
 		eht_cap_elem->phy_cap_info[1] |=
-			u8_encode_bits(sts - 1,
+			u8_encode_bits(val,
 				       IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_320MHZ_MASK);
 
 	eht_cap_elem->phy_cap_info[2] =
-- 
2.53.0



