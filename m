Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814AE156C5E;
	Wed,  5 Feb 2025 14:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765773; cv=none; b=VQRel78Eug5SYcE3NDCp9Y6JadxdS5eXcxdJd5XB9QMwYnWTewBtkaH1xQz6A3KJSD1BqofGK3M9C1woSiWGi6bhMoJ0On/qpclyXxMELT5YGh/oV3C6JMRXf2LulL8hjMr8Kvggj+dpaeaKDcJEx+1eEJCVSdg/UDjJ5PdHu84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765773; c=relaxed/simple;
	bh=FcIRQ40uWOKLaxlrx/mNOyAB97/G/C2EQjZU3sqKfVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5XUAEbsCZgbgRqHIADzvqHasWREejAzEuV2yNuXYRQsHRYrCvxZkM19NnLzszFJe/Lkd8Kzph6N7zS4ymXfG42zSiRnFWv+2zOVBUnSFSGUTojvsbl2w52CUAMbv0KOLRDLDFHnaCO6n7g7HNMbwPmlXCD1rV1agkKRZ+3o3NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfgMB93Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfgMB93Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3429C4CED6;
	Wed,  5 Feb 2025 14:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765773;
	bh=FcIRQ40uWOKLaxlrx/mNOyAB97/G/C2EQjZU3sqKfVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfgMB93ZxubVphyerJ0jDWfI843FBBcFl44+Fm2XFMgwwKEi+5FFOIk6+rNiMkPCp
	 mmKbNgKuE8PKRI9H9Phh4/9kueed5N6MG/IyaYfHTsBOnx7hg5tNInbKIdXzfBfvDi
	 YTYVpQz/VF4AWtAPdKe/0e6pOUfLZ7+2lwk56mlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 212/623] wifi: mt76: mt7996: fix incorrect indexing of MIB FW event
Date: Wed,  5 Feb 2025 14:39:14 +0100
Message-ID: <20250205134504.338912892@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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



