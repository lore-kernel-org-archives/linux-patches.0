Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4053EA89
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aiBGLL/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C528C433C9;
	Wed, 15 Nov 2023 19:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076997;
	bh=AD0gUP+1uVYI5KNS3IOv5zVBr62vv8QFIh5uqhaO9cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aiBGLL/N0pO3kEyuVgCHwcyjFAfVig8StdWn4UlPO3SnGrQU4eHgzBcqiyxBfxP8t
	 gOTl3ERnwOGmn9RCDdlVQNf/VhJ1AJu6W3cGjuifBDTliX25BTdSiwsWJFxMtsq/Nn
	 qJLR+AtIIFjGvabYQq0Gb/qE6FVxBaZqutzoZ3N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/603] wifi: mt76: mt7915: fix beamforming availability check
Date: Wed, 15 Nov 2023 14:10:38 -0500
Message-ID: <20231115191619.594790496@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: MeiChia Chiu <meichia.chiu@mediatek.com>

[ Upstream commit ced1a0b8f3944e44e7f4eb3772dea1bada25d38a ]

Without this patch, when ap sets the tx stream number to 2,
ap won't send any beamforming packet.

Fixes: f89f297aef28 ("mt76: mt7915: fix txbf starec TLV issues")
Signed-off-by: MeiChia Chiu <meichia.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 92a341aa58228..5d8e985cd7d45 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1015,13 +1015,13 @@ mt7915_is_ebf_supported(struct mt7915_phy *phy, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, bool bfee)
 {
 	struct mt7915_vif *mvif = (struct mt7915_vif *)vif->drv_priv;
-	int tx_ant = hweight8(phy->mt76->chainmask) - 1;
+	int sts = hweight16(phy->mt76->chainmask);
 
 	if (vif->type != NL80211_IFTYPE_STATION &&
 	    vif->type != NL80211_IFTYPE_AP)
 		return false;
 
-	if (!bfee && tx_ant < 2)
+	if (!bfee && sts < 2)
 		return false;
 
 	if (sta->deflink.he_cap.has_he) {
-- 
2.42.0



