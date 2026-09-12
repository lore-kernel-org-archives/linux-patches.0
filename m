Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4819361960;
	Sat, 12 Sep 2026 08:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200966; cv=none; b=gk5zLdd2SUYRLQPalWu+6v0xghimIp5NEvZEkQHHwpPgIzcSvf8+c60h9Z1bcDPCwxrW541fUZxceu7xZnZkzbOJNPX1xdBk+1yxOugAdX2HOevMlYizkOH+vx2m/iqCeXXzMKB6jYO7bHAnN81GP3/q93jAPExafTMCng3H3hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200966; c=relaxed/simple;
	bh=npLoC1DgViJhryCtABN27xIhQTeLrwlHc+BAkUFrOu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+JSAPQNMx7PmYHOehYMIt3N+SR2WC7EbA4iY3XFv2/GwkcbiRHn1SjXDmawZOAOxuQYrH6WJngHhR7r6vbJPWeGPoFlZxf7yfVS7AAGan624iXr0HyY/uK4RHXDVAwvqgpSH31qWcWNMx8v3TrsrPXCUZzhFzjR3xD2uzWlEz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mLiiqDM1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mLiiqDM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789CB1F000FF;
	Sat, 12 Sep 2026 08:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200965;
	bh=j2B6owUQXYRukoXk/DpVQ5+4VbvoGWdvccaqUvY8vbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mLiiqDM1Te1jeH3nExZ/PkNZcsXs7M9lkobXc9YPXsJsjnlOj93HDI12bOYy80457
	 4YDsBLk9m9ovj5heCZiRH0x9YYgZHTfM0h7WrPsXKa+7+9VJfsfBeqxi9k5XY5uD/M
	 JnmIa8K5HLiAbYC+8V9j1FSc61QmwL+bo7qnOxgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0898/1815] wifi: mt76: fix ER-SU 106-tone RU check in RX rate decode
Date: Sat, 12 Sep 2026 08:44:08 +0200
Message-ID: <20260912065710.002481679@linuxfoundation.org>
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

[ Upstream commit 29fe963d86e434b32d07958a6785be724e45c787 ]

MT_PHY_TYPE_HE_EXT_SU is an enum value (9), not a bit flag, so the
bitwise test "*mode & MT_PHY_TYPE_HE_EXT_SU" also matches OFDM, HT-GF and
several HE/EHT modes. Only genuine ER-SU should be classified as a
106-tone RU at 40 MHz; use an equality comparison.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Fixes: d832f5e73815 ("mt76: connac: move mt76_connac2_mac_fill_rx_rate in connac module")
Link: https://patch.msgid.link/20260724124813.3961474-7-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index fc9f782032ef2..780320198f6ac 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -1114,7 +1114,7 @@ int mt76_connac2_mac_fill_rx_rate(struct mt76_dev *dev,
 	case IEEE80211_STA_RX_BW_20:
 		break;
 	case IEEE80211_STA_RX_BW_40:
-		if (*mode & MT_PHY_TYPE_HE_EXT_SU &&
+		if (*mode == MT_PHY_TYPE_HE_EXT_SU &&
 		    (idx & MT_PRXV_TX_ER_SU_106T)) {
 			status->bw = RATE_INFO_BW_HE_RU;
 			status->he_ru =
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index b99a48c3664ee..259b18dcdc880 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -349,7 +349,7 @@ mt7996_mac_fill_rx_rate(struct mt7996_dev *dev,
 	case IEEE80211_STA_RX_BW_20:
 		break;
 	case IEEE80211_STA_RX_BW_40:
-		if (*mode & MT_PHY_TYPE_HE_EXT_SU &&
+		if (*mode == MT_PHY_TYPE_HE_EXT_SU &&
 		    (idx & MT_PRXV_TX_ER_SU_106T)) {
 			status->bw = RATE_INFO_BW_HE_RU;
 			status->he_ru =
-- 
2.53.0



