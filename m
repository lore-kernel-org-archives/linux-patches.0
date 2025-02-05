Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B0F1509BD;
	Wed,  5 Feb 2025 14:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764030; cv=none; b=KZGBH7mVFpacKr5BHuksONtsamJn931TKlqYDfTEe3M1nQQRjJ1m2KGVZBqac8BgBWx4yM3RLvaar6Ad45gDghG01cwQMcXn/ZzS/oSXm7qZ+0DZci4N9Vu8SLErsF4DMnypw0kBtKuDBGKQ6DvB3HsTeuPLc9nGb5nM09vz8Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764030; c=relaxed/simple;
	bh=jklQwgSkMdN7kXqIdiS7v8iC/mAr+f37omVvNxKmjro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTDIxaBiZdty3Rq8MT6VrkJI+rd3XRHWDVGoM+NDRcBIgsDlPQOhAQAWrXwtG3SnlYPC5MdNICa6ciULM+5A5FV43SXBy+eca0GykO7lySyF5ToxsoP9deqhBPQUfg4Rt0ys/zQdS24wwbz+B1JjNeSFr5ibSMkB6ciBfsVbx/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnj7AX8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnj7AX8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB36C4CED1;
	Wed,  5 Feb 2025 14:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764030;
	bh=jklQwgSkMdN7kXqIdiS7v8iC/mAr+f37omVvNxKmjro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xnj7AX8mUV2G/4hEHwOPcWhZ9yEvx3hlaQuD8fr6xLw4qi4652tY+UOHBd2iUN1rE
	 liUm8zs6G9OLJ0Wr5PSa7PfqP/axUlcM4VBof/MlsgvpqMZ0ZkCH4TZ37twnoGUgod
	 hP6+PJL7N2PDDBz7UXmu2wOchBv3/c/Z6E7Ngj10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/393] wifi: mt76: mt7996: fix incorrect indexing of MIB FW event
Date: Wed,  5 Feb 2025 14:40:48 +0100
Message-ID: <20250205134425.232174311@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 302171e103597..19afe89fce785 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3189,6 +3189,13 @@ int mt7996_mcu_get_chip_config(struct mt7996_dev *dev, u32 *cap)
 
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
@@ -3198,16 +3205,15 @@ int mt7996_mcu_get_chan_mib_info(struct mt7996_phy *phy, bool chan_switch)
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
@@ -3216,7 +3222,7 @@ int mt7996_mcu_get_chan_mib_info(struct mt7996_phy *phy, bool chan_switch)
 	struct sk_buff *skb;
 	int i, ret;
 
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < IDX_NUM; i++) {
 		req.data[i].tag = cpu_to_le16(UNI_CMD_MIB_DATA);
 		req.data[i].len = cpu_to_le16(sizeof(req.data[i]));
 		req.data[i].offs = cpu_to_le32(offs[i]);
@@ -3235,17 +3241,24 @@ int mt7996_mcu_get_chan_mib_info(struct mt7996_phy *phy, bool chan_switch)
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



