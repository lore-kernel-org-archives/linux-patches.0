Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDCA34F49F;
	Tue, 16 Dec 2025 11:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886156; cv=none; b=dAnkMwFB0gjZczGejw4b8k14j3uzNNqh7SUAlCO29i6dAk9rlxED22lWbHEe0HzNgYp8pmsASy/iEcLRFTyxwuGLHcaehr1/CNhx0Ykt7d+XuMXEb7vIy5Sq/mWqCMrfYR39tlEnzUlyhktbem8ntcRCqxdVwQCzl4gxbHaPIxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886156; c=relaxed/simple;
	bh=n12f45r9xq46BwI8crqu5bOdjUlIJsm5Rlb+LuB1dSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O08KktGb/HX7eOr1sZoR6ZjDhTf0340HidmS7HS+hKKxLH/GVcohs3/lMak1hKNWAi0ztVLNgy9FpXcPvLVuv38sdW94don/8HBe24MFVHY7LyoQvg/Z5axdtt1lWqObayrgr8KooBn0nTjMGom6e0mKOxnXPBoV5gM70vnX9zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dokTi+Jc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dokTi+Jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FF3C4CEF1;
	Tue, 16 Dec 2025 11:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886156;
	bh=n12f45r9xq46BwI8crqu5bOdjUlIJsm5Rlb+LuB1dSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dokTi+Jc6w0GUBu8HuqkJSIkN8ZuY40QoepWMqEMAgFA+F9EuRkis2C+3DvtTP9FF
	 ZyXkP53eqxWJibrivUGAGgWEXCcg2hcpB7foskKoEVJRwYCFKoN4VBNeKVT9syWAUX
	 BfIhaWrQAYJZekQEY2lZJIk2M7Jf8UnHmwxvz1fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 322/507] wifi: mt76: mt7996: fix null pointer deref in mt7996_conf_tx()
Date: Tue, 16 Dec 2025 12:12:43 +0100
Message-ID: <20251216111357.132574675@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 79277f8ad15ec5f255ed0e1427c7a8a3e94e7f52 ]

If a link does not have an assigned channel yet, mt7996_vif_link returns
NULL. We still need to store the updated queue settings in that case, and
apply them later.
Move the location of the queue params to within struct mt7996_vif_link.

Fixes: c0df2f0caa8d ("wifi: mt76: mt7996: prepare mt7996_mcu_set_tx for MLO support")
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250929111723.52486-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   | 6 +++---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    | 5 ++++-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h | 7 ++++++-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 4693d376e64ee..016b7e02d969d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -650,8 +650,8 @@ mt7996_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	       unsigned int link_id, u16 queue,
 	       const struct ieee80211_tx_queue_params *params)
 {
-	struct mt7996_dev *dev = mt7996_hw_dev(hw);
-	struct mt7996_vif_link *mlink = mt7996_vif_link(dev, vif, link_id);
+	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
+	struct mt7996_vif_link_info *link_info = &mvif->link_info[link_id];
 	static const u8 mq_to_aci[] = {
 		[IEEE80211_AC_VO] = 3,
 		[IEEE80211_AC_VI] = 2,
@@ -660,7 +660,7 @@ mt7996_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	};
 
 	/* firmware uses access class index */
-	mlink->queue_params[mq_to_aci[queue]] = *params;
+	link_info->queue_params[mq_to_aci[queue]] = *params;
 	/* no need to update right away, we'll get BSS_CHANGED_QOS */
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 0d688ec5a8163..07b962e235850 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3438,6 +3438,9 @@ int mt7996_mcu_set_tx(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 #define WMM_PARAM_SET		(WMM_AIFS_SET | WMM_CW_MIN_SET | \
 				 WMM_CW_MAX_SET | WMM_TXOP_SET)
 	struct mt7996_vif_link *link = mt7996_vif_conf_link(dev, vif, link_conf);
+	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
+	unsigned int link_id = link_conf->link_id;
+	struct mt7996_vif_link_info *link_info = &mvif->link_info[link_id];
 	struct {
 		u8 bss_idx;
 		u8 __rsv[3];
@@ -3455,7 +3458,7 @@ int mt7996_mcu_set_tx(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 	skb_put_data(skb, &hdr, sizeof(hdr));
 
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		struct ieee80211_tx_queue_params *q = &link->queue_params[ac];
+		struct ieee80211_tx_queue_params *q = &link_info->queue_params[ac];
 		struct edca *e;
 		struct tlv *tlv;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 048d9a9898c6e..498a2eefd7a8a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -246,16 +246,21 @@ struct mt7996_vif_link {
 	struct mt7996_sta_link msta_link;
 	struct mt7996_phy *phy;
 
-	struct ieee80211_tx_queue_params queue_params[IEEE80211_NUM_ACS];
 	struct cfg80211_bitrate_mask bitrate_mask;
 
 	u8 mld_idx;
 };
 
+struct mt7996_vif_link_info {
+	struct ieee80211_tx_queue_params queue_params[IEEE80211_NUM_ACS];
+};
+
 struct mt7996_vif {
 	struct mt7996_vif_link deflink; /* must be first */
 	struct mt76_vif_data mt76;
 
+	struct mt7996_vif_link_info link_info[IEEE80211_MLD_MAX_NUM_LINKS];
+
 	u8 mld_group_idx;
 	u8 mld_remap_idx;
 };
-- 
2.51.0



