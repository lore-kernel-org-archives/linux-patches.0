Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6501D07BA;
	Thu, 17 Apr 2025 18:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914569; cv=none; b=M5NkMfqK3RJ43TI+Aw3xpFWIlReLRCNe9vEFPVzyeYL+VXCjRpw4mD7CplUp2ZQ1Uo5WRFlLy0Pua0VGc29VIPk7myLCDZYklrujfZJhdvMnugrj6XIh5vLKTY9LvCpXabSvort42USAClH4UE9GKzEHy34jT2MqENS8N+2iOkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914569; c=relaxed/simple;
	bh=gLZY9HacbQZs9y//ojsj21pIp3aCT6El1GlD9UOxHQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nY/Nvz8P3QqpUqJoyiPT204y/BCjC1uHfXeD0Ahf3herW95y159NjFCMeK0fqFdgm3EnZAjBzjqm/l/aiXJ1JyHehWzzcn1fx7HHJ5ZAC95iLTS61LgN0+pFA5h8393tusTygHna3uVP0wqwHWaEQn6JSyxlk+trNZLueCu5vxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5s3Dl1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5s3Dl1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7131BC4CEE4;
	Thu, 17 Apr 2025 18:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914568;
	bh=gLZY9HacbQZs9y//ojsj21pIp3aCT6El1GlD9UOxHQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5s3Dl1Jysu064RBXkUiSW6imP02gVKSUyHJDQxmpE3g5GBqTOW3lwexix7mej7mt
	 Si3MDlw5mufZ4d1HOgUpuYQ2yEfNuwQtjFibRTNx5Z1aPem10iLfSCEXpC/gpJ3Max
	 ONZvb09iFgIbv70VsejDCnREFJ7Z7IFi0PMB3Lis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Caleb Jorden <cjorden@gmail.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.13 259/414] wifi: mt76: mt7925: fix the wrong link_idx when a p2p_device is present
Date: Thu, 17 Apr 2025 19:50:17 +0200
Message-ID: <20250417175121.848395218@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit 4bada9b0a29c185d45cc9512509edd6069fbfa79 upstream.

When the p2p device and MLO station are running concurrently, the p2p device
will occupy the wrong link_idx when the MLO secondary link is added.

Fixes: 9e4c3a007f01 ("wifi: mt76: connac: Extend mt76_connac_mcu_uni_add_dev for MLO")
Cc: stable@vger.kernel.org
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Tested-by: Caleb Jorden <cjorden@gmail.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250305000851.493671-2-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h            |    1 +
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c |    4 ++--
 drivers/net/wireless/mediatek/mt76/mt7925/main.c     |   14 ++++++++++----
 3 files changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -755,6 +755,7 @@ struct mt76_testmode_data {
 
 struct mt76_vif {
 	u8 idx;
+	u8 link_idx;
 	u8 omac_idx;
 	u8 band_idx;
 	u8 wmm_idx;
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1164,7 +1164,7 @@ int mt76_connac_mcu_uni_add_dev(struct m
 			.tag = cpu_to_le16(DEV_INFO_ACTIVE),
 			.len = cpu_to_le16(sizeof(struct req_tlv)),
 			.active = enable,
-			.link_idx = mvif->idx,
+			.link_idx = mvif->link_idx,
 		},
 	};
 	struct {
@@ -1187,7 +1187,7 @@ int mt76_connac_mcu_uni_add_dev(struct m
 			.bmc_tx_wlan_idx = cpu_to_le16(wcid->idx),
 			.sta_idx = cpu_to_le16(wcid->idx),
 			.conn_state = 1,
-			.link_idx = mvif->idx,
+			.link_idx = mvif->link_idx,
 		},
 	};
 	int err, idx, cmd, len;
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -356,10 +356,15 @@ static int mt7925_mac_link_bss_add(struc
 	struct mt76_txq *mtxq;
 	int idx, ret = 0;
 
-	mconf->mt76.idx = __ffs64(~dev->mt76.vif_mask);
-	if (mconf->mt76.idx >= MT792x_MAX_INTERFACES) {
-		ret = -ENOSPC;
-		goto out;
+	if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
+		mconf->mt76.idx = MT792x_MAX_INTERFACES;
+	} else {
+		mconf->mt76.idx = __ffs64(~dev->mt76.vif_mask);
+
+		if (mconf->mt76.idx >= MT792x_MAX_INTERFACES) {
+			ret = -ENOSPC;
+			goto out;
+		}
 	}
 
 	mconf->mt76.omac_idx = ieee80211_vif_is_mld(vif) ?
@@ -367,6 +372,7 @@ static int mt7925_mac_link_bss_add(struc
 	mconf->mt76.band_idx = 0xff;
 	mconf->mt76.wmm_idx = ieee80211_vif_is_mld(vif) ?
 			      0 : mconf->mt76.idx % MT76_CONNAC_MAX_WMM_SETS;
+	mconf->mt76.link_idx = hweight16(mvif->valid_links);
 
 	if (mvif->phy->mt76->chandef.chan->band != NL80211_BAND_2GHZ)
 		mconf->mt76.basic_rates_idx = MT792x_BASIC_RATES_TBL + 4;


