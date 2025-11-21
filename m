Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36172FF173;
	Fri, 21 Nov 2025 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732751; cv=none; b=gaciIJ8cRfBuLw/Jt8Fse3RGFD+AAdV8EcupRJZVR3zzgFLNNcIEd/H8SYS6OWyZj9cxRk4DFBIWbgTKNVch6NoXlzU10cOvHHXu0ItWaLaIssNVnqr8JVJf+d9K7Kvituwlq6TIenehAIIpqtz4i+1nJAj0pOuSIkWOcv3RSNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732751; c=relaxed/simple;
	bh=h8My363KJZoou59hdGo6AOgFguO/QJil9YX8/LcHnJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzIN1TNMjudkxGVbqp63yzEPWXlUBibp/duoLdNm/T/IPIUizdav5tiGt+4zTIq4UjPBG3FoGpri5sUidQGWBFs1FUgMnMBqsLVj7pZQPq8cXvl5lcuuQn0r1sMVaxl1c1VP2X6fp1//D+q9UToUJUvN+LSLzwwsJbfa3+moutU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuGHxs4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuGHxs4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A04C4CEFB;
	Fri, 21 Nov 2025 13:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732750;
	bh=h8My363KJZoou59hdGo6AOgFguO/QJil9YX8/LcHnJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zuGHxs4Y9g93eiv69uOBnbqXWcAN/rsy5/yKPYDjiAw2nKpIGTdQgXuLqX6MnkdEn
	 M1vzT202tJYeBQvI9t6XwBLjkJ+3JCWeEh2RachL1oVswwotL5v31Zz5Jb5a+A3Ll2
	 QbPXF+kXf6R39QJzFqLKXMqjud3pz3u2L2Ul/TbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 230/529] wifi: mt76: mt7921: Add 160MHz beamformee capability for mt7922 device
Date: Fri, 21 Nov 2025 14:08:49 +0100
Message-ID: <20251121130239.202131897@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Quan Zhou <quan.zhou@mediatek.com>

[ Upstream commit 25ef5b5d02ac03fe8dd91cf25bd011a570fbeba2 ]

Enable 160MHz beamformee support on mt7922 by updating HE capability
element configuration. Previously, only 160MHz channel width was set,
but beamformee for 160MHz was not properly advertised. This patch
adds BEAMFORMEE_MAX_STS_ABOVE_80MHZ_4 capability to allow devices
to utilize 160MHz BW for beamforming.

Tested by connecting to 160MHz-bandwidth beamforming AP and verified
HE capability.

Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
Link: https://patch.msgid.link/ae637afaffed387018fdc43709470ef65898ff0b.1756383627.git.quan.zhou@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 15b7d22d3639f..ae7a01c7ce36d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -135,6 +135,8 @@ mt7921_init_he_caps(struct mt792x_phy *phy, enum nl80211_band band,
 			if (is_mt7922(phy->mt76->dev)) {
 				he_cap_elem->phy_cap_info[0] |=
 					IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_160MHZ_IN_5G;
+				he_cap_elem->phy_cap_info[4] |=
+					IEEE80211_HE_PHY_CAP4_BEAMFORMEE_MAX_STS_ABOVE_80MHZ_4;
 				he_cap_elem->phy_cap_info[8] |=
 					IEEE80211_HE_PHY_CAP8_20MHZ_IN_160MHZ_HE_PPDU |
 					IEEE80211_HE_PHY_CAP8_80MHZ_IN_160MHZ_HE_PPDU;
-- 
2.51.0



