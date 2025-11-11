Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368DE332ED0;
	Tue, 11 Nov 2025 01:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823947; cv=none; b=uNdg4xOaRmfpPfgD3jZyCTi7eMM6bdSr1bn2dUxAo7Ql6SHw8yjMG6TmAjDK4uVeOj8O+B1HAfjeSDZ+QlxHBkONj0czO8oL14HGo2iVIoweg9bMNO7j9AISTcAgSDiy69HhUiQHE7pbmkS9MlTJXoeBIXGJuD6bc6NvAYffDVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823947; c=relaxed/simple;
	bh=nOz5o5Mtz48dJWQg15QG93xRApWOS1Ec9+VD3hHEFO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SD0rPx7gnVAIJ34T0YZ2ufLGaLbu0xpm3ZqHcZJvCFvldtmsnDE/X8y6f+J394eqYTvxzvsCcyWeVfECVvuPmcgf5KVNS5Qx/5B2LyFxqovinZpEHkwb+iZfofk3lXxkhpR8tJIRLfiyJO4Z3uhOB0OnfeUkD3qxswABChd35TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qj4X/HK/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qj4X/HK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FFAC19422;
	Tue, 11 Nov 2025 01:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823947;
	bh=nOz5o5Mtz48dJWQg15QG93xRApWOS1Ec9+VD3hHEFO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qj4X/HK/58vKdJrqvoK8Byxbn7RjvdpihLR7aHfzbXhV1qL5iiUrRUZHf7i3T/bMF
	 fjyXmry9PEu000g3wawHrA0Pu20wl34OOrXVXxlxLUb4X6wmYve36f0fevih71iWXG
	 39xAXxlkHGWOdedIjcZuQCwoK3lztLLEST1GcuZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 355/565] wifi: mt76: mt7921: Add 160MHz beamformee capability for mt7922 device
Date: Tue, 11 Nov 2025 09:43:31 +0900
Message-ID: <20251111004534.858109193@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 5b832f1aa00d7..0a7eafc470596 100644
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



