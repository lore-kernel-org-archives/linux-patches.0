Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2543E19E7F7;
	Sat, 12 Sep 2026 08:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201217; cv=none; b=uda4lN1kTUYWbDXCG7TDAEzyPM1+Yu5ccTmqPbc1bazd7CGLl3FBXAWj+UKQBF8ffNGF3DnoW9wcNexWQMna20zc2tyehwpfwZ0U+Tj8KfvVCDYy/8Dx+upRXBPkrPcN5CPL/ZrZIuOkBQ0RaN59pTmqohf9QuQPrZtnH2uNL4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201217; c=relaxed/simple;
	bh=A+Ilt1JvC9MUVKD+ONTlrD7i+9W0cFRpyu8lHsLBNuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYH47H4wPcW5rl5YYIvaQj4iv63OPIbNibd10BZXU6QQ8kAz6DBdpeVwQW4bRm7Rl7ocm99g706/+BH1xk6ZoYDwsPjszP9XN4awyLeNFR+oNWSc910uM2SQBCvrIYF88QF3xwO/H9Hhgh7Ba9h6ZKTfZ4zhPWftprL0YKMENiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cxqd1XO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cxqd1XO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2993C1F000FF;
	Sat, 12 Sep 2026 08:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201216;
	bh=ANTmyS6N9vlI6pexDwCd1Kua55o9XsqBT3PS2BPWEac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1cxqd1XOeHmWv5GEgPK2kKNck8VJJKSiSjBGQYqLobShLeIzm2M32hIXcHiswMPPM
	 VN4RQ5ZzPt5lBh1QrKA99YWffgt4YZwGff3ki1Fv97xkROz+c5gRVsyhdaz7RJE4cn
	 aq2BE3BFtg/FODskFn4+Jn4WOeFzsjFz7nolqixY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"shengwei.lu" <shengwei.lu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0950/1815] wifi: mt76: mt7925: Fix EHT Beamformee SS subfields to meet 802.11be minimum
Date: Sat, 12 Sep 2026 08:45:00 +0200
Message-ID: <20260912065711.266692605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 6a09c0a0d4280..9f080da13341b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -187,19 +187,21 @@ mt7925_init_eht_caps(struct mt792x_phy *phy, enum nl80211_band band,
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



