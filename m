Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2A3156F39;
	Wed,  5 Feb 2025 14:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765282; cv=none; b=lzzh2/yIOEDw5J+0I+onJqwnibHFNDhhvj7tUn2vNo8eedmn08IZhXdGeilb2ZKhR9Ah/ZMtSrh/Z7FPfHFF8E33Tlkrd0ofFh8FcCCHXifQEhw1fjHpjKy7RHnB6u5ZxCBjBngBZuNEYrjABgJ0rObtLQzMhlLLuNlQ4Kjw6GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765282; c=relaxed/simple;
	bh=Sm5/i4ROrzV9+yK7A7Fw3ylTGDq12rNbVv7e56DLCSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dpj7vN9Ty8u/v9+t6G965OQbXvBYmnz/6+Bv3pGLu+ynXhpblhKVkmBPJ8Vj45WK8/Fd0R3kcqRWS+1wSWZNFq9sqdJhwN6hGCGnDtGk70KK84LJT30ukl2hNlRbHVLQB8Ki/vnPhpGKq2nEfiiqOmG51Iy4nMEPTrgBNissOwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/DUf93H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/DUf93H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4691C4CEE2;
	Wed,  5 Feb 2025 14:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765282;
	bh=Sm5/i4ROrzV9+yK7A7Fw3ylTGDq12rNbVv7e56DLCSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/DUf93HNTcZv+GwTe/2KUzRXQZx614n3rIIXtLFKvB5ZmRwOvsCGqo5nXUGtKw+H
	 vry4NPSj3EvEaH+YHupaFoRR1RvZRdMW5+MdtxDSflj33iXCbeNOfsv3ppwsP5l5Pl
	 A+jrdpjTl451UVgKOtc7Le38UwjWXmug6HgERHLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 206/590] wifi: mt76: mt7996: fix incorrect indexing of MIB FW event
Date: Wed,  5 Feb 2025 14:39:21 +0100
Message-ID: <20250205134503.163495199@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Lin <benjamin-jw.lin@mediatek.com>

[ Upstream commit 5c2a25a1ab76a2976dddc5ffd58498866f3ef7c2 ]

Fix wrong calculation of the channel times due to incorrect
interpretation from the FW event.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Benjamin Lin <benjamin-jw.lin@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20250114101026.3587702-4-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 45 ++++++++++++-------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 6c445a9dbc03d..d6d80b1b2d697 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3666,6 +3666,13 @@ int mt7996_mcu_get_chip_config(struct mt7996_dev *dev, u32 *cap)
 
 int mt7996_mcu_get_chan_mib_info(struct mt7996_phy *phy, bool chan_switch)
 {
+	enum {
+		IDX_TX_TIME,
+		IDX_RX_TIME,
+		IDX_OBSS_AIRTIME,
+		IDX_NON_WIFI_TIME,
+		IDX_NUM
+	};
 	struct {
 		struct {
 			u8 band;
@@ -3675,16 +3682,15 @@ int mt7996_mcu_get_chan_mib_info(struct mt7996_phy *phy, bool chan_switch)
 			__le16 tag;
 			__le16 len;
 			__le32 offs;
-		} data[4];
+		} data[IDX_NUM];
 	} __packed req = {
 		.hdr.band = phy->mt76->band_idx,
 	};
-	/* strict order */
 	static const u32 offs[] = {
-		UNI_MIB_TX_TIME,
-		UNI_MIB_RX_TIME,
-		UNI_MIB_OBSS_AIRTIME,
-		UNI_MIB_NON_WIFI_TIME,
+		[IDX_TX_TIME] = UNI_MIB_TX_TIME,
+		[IDX_RX_TIME] = UNI_MIB_RX_TIME,
+		[IDX_OBSS_AIRTIME] = UNI_MIB_OBSS_AIRTIME,
+		[IDX_NON_WIFI_TIME] = UNI_MIB_NON_WIFI_TIME,
 	};
 	struct mt76_channel_state *state = phy->mt76->chan_state;
 	struct mt76_channel_state *state_ts = &phy->state_ts;
@@ -3693,7 +3699,7 @@ int mt7996_mcu_get_chan_mib_info(struct mt7996_phy *phy, bool chan_switch)
 	struct sk_buff *skb;
 	int i, ret;
 
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < IDX_NUM; i++) {
 		req.data[i].tag = cpu_to_le16(UNI_CMD_MIB_DATA);
 		req.data[i].len = cpu_to_le16(sizeof(req.data[i]));
 		req.data[i].offs = cpu_to_le32(offs[i]);
@@ -3712,17 +3718,24 @@ int mt7996_mcu_get_chan_mib_info(struct mt7996_phy *phy, bool chan_switch)
 		goto out;
 
 #define __res_u64(s) le64_to_cpu(res[s].data)
-	state->cc_tx += __res_u64(1) - state_ts->cc_tx;
-	state->cc_bss_rx += __res_u64(2) - state_ts->cc_bss_rx;
-	state->cc_rx += __res_u64(2) + __res_u64(3) - state_ts->cc_rx;
-	state->cc_busy += __res_u64(0) + __res_u64(1) + __res_u64(2) + __res_u64(3) -
+	state->cc_tx += __res_u64(IDX_TX_TIME) - state_ts->cc_tx;
+	state->cc_bss_rx += __res_u64(IDX_RX_TIME) - state_ts->cc_bss_rx;
+	state->cc_rx += __res_u64(IDX_RX_TIME) +
+			__res_u64(IDX_OBSS_AIRTIME) -
+			state_ts->cc_rx;
+	state->cc_busy += __res_u64(IDX_TX_TIME) +
+			  __res_u64(IDX_RX_TIME) +
+			  __res_u64(IDX_OBSS_AIRTIME) +
+			  __res_u64(IDX_NON_WIFI_TIME) -
 			  state_ts->cc_busy;
-
 out:
-	state_ts->cc_tx = __res_u64(1);
-	state_ts->cc_bss_rx = __res_u64(2);
-	state_ts->cc_rx = __res_u64(2) + __res_u64(3);
-	state_ts->cc_busy = __res_u64(0) + __res_u64(1) + __res_u64(2) + __res_u64(3);
+	state_ts->cc_tx = __res_u64(IDX_TX_TIME);
+	state_ts->cc_bss_rx = __res_u64(IDX_RX_TIME);
+	state_ts->cc_rx = __res_u64(IDX_RX_TIME) + __res_u64(IDX_OBSS_AIRTIME);
+	state_ts->cc_busy = __res_u64(IDX_TX_TIME) +
+			    __res_u64(IDX_RX_TIME) +
+			    __res_u64(IDX_OBSS_AIRTIME) +
+			    __res_u64(IDX_NON_WIFI_TIME);
 #undef __res_u64
 
 	dev_kfree_skb(skb);
-- 
2.39.5



