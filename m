Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF7D37AA97;
	Sat, 12 Sep 2026 08:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200933; cv=none; b=DxK9PGzPLnzY3e52McyKsg5EUaB/KU/J1VD1urgzrJ0JEfFz8bEIEaUNkpPQln9yTPtSvzoRfPFEd7LJahUp+7K4vFG3lOwxhJPyv05Ru0LUbwUuHhUHJqvoaTDUYQyFpsN60f7KQQ9DVt1d7E4o6l0uvfRgrnxdlo8En0kJVVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200933; c=relaxed/simple;
	bh=1MYLSW1gBJpou0vLvoc6UTJwYSWyKDNNrvmixu2uorI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puvnf0VpGR02HW2pbEALc+qkvS55TIIrwBNiAOgTAx2nqAXn9r2MwT519JJFa29p5BseXTAkdbnzM/j9reUT1oL+RP+afRtwBQQAwK8CGOfV/ZDyUhbhk424LgqrB9Nk6fAHgVVa+66J7V3OAwka0zcz8C8wb+C5D9PL9wnOIdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NoFSLqkL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NoFSLqkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023BC1F000FF;
	Sat, 12 Sep 2026 08:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200932;
	bh=jf8X+e3H2tkwqE9pf3E3a4+NOz6fMZFILeweWFzImcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NoFSLqkL+YLbx9S1PB0cVFmbLSlOvzNqbGsNkNDodOddhSfkyqSa/eGBHmw17nB6s
	 BPaB0bz01iZoY75Z/SBmAfCHvvS2emORi6LVQs1zrcc63PeXtLz9AqJEf0WnVw1UpJ
	 IF0GqxNb1pClMH/RvKQj/BhrqEo0tivN7Tawv5/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0892/1815] wifi: mt76: fix HE DCM max-RU capability encoding
Date: Sat, 12 Sep 2026 08:44:02 +0200
Message-ID: <20260912065709.860751737@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit cbeed7096794f748d16c78cd9d3e0004420d1e9d ]

sta_rec_he.dcm_rx_max_nss was assigned twice: the second assignment,
sourced from HE PHY capability byte 8 (DCM max RU), overwrote the RX-NSS
value and left dcm_max_ru at zero. Every associated HE station advertising
DCM support was configured in firmware with a wrong dcm_rx_max_nss and a
zero dcm_max_ru. Store the DCM max-RU value in dcm_max_ru as intended.

The same copy-paste error existed in both the shared connac2 path and the
mt7915 path.

Fixes: c336318f57a9 ("mt76: mt7915: add HE capabilities support for peers")
Fixes: 67aa27431c7f ("mt76: mt7921: rely on mt76_connac_mcu common library")
Link: https://patch.msgid.link/20260724124813.3961474-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 69a2f5398404d..b4d81ad02ea92 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -757,7 +757,7 @@ mt76_connac_mcu_sta_he_tlv(struct sk_buff *skb, struct ieee80211_sta *sta)
 		HE_PHY(CAP3_DCM_MAX_CONST_RX_MASK, elem->phy_cap_info[3]);
 	he->dcm_rx_max_nss =
 		HE_PHY(CAP3_DCM_MAX_RX_NSS_2, elem->phy_cap_info[3]);
-	he->dcm_rx_max_nss =
+	he->dcm_max_ru =
 		HE_PHY(CAP8_DCM_MAX_RU_MASK, elem->phy_cap_info[8]);
 
 	he->pkt_ext = 2;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 119bd35822958..96d2770f7c398 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -902,7 +902,7 @@ mt7915_mcu_sta_he_tlv(struct sk_buff *skb, struct ieee80211_sta *sta,
 		HE_PHY(CAP3_DCM_MAX_CONST_RX_MASK, elem->phy_cap_info[3]);
 	he->dcm_rx_max_nss =
 		HE_PHY(CAP3_DCM_MAX_RX_NSS_2, elem->phy_cap_info[3]);
-	he->dcm_rx_max_nss =
+	he->dcm_max_ru =
 		HE_PHY(CAP8_DCM_MAX_RU_MASK, elem->phy_cap_info[8]);
 
 	he->pkt_ext = 2;
-- 
2.53.0



