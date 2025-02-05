Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C00149C53;
	Wed,  5 Feb 2025 14:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764680; cv=none; b=EY7M+yHGWpBCAufNC51vPyinlwuvZJg385NBv/khSPIf57gAtITAsNqpnBo3MCfQPGrKcjGMExkz8PrZJwv4hPxt/QwYAKCrfae/icBDfl5KRVGUPXDGJZkG2ix3BS1nl8PsgReIIDXikKmQLbCfvBcyNn+6CZ0QOhlhIYlenQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764680; c=relaxed/simple;
	bh=c1pHGyeX+xQAuPMIgoXonB/y0YWpCUvUK+q1/TKXSgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcKhmfByaiMm+qVRoQfXYiLf2KzFuhmVS8kDrKrXjLB6nlDOqYr6bDwVErq1sAN9p/uYjoKfirJjF5JLQlTXQ5TQGGkK21o2RSzko1p0I2hm3EwvDavfbn0cpsZaryFG1fjZC2eUhnbyeVvqi7Lhtey9lSKuS2UYZX249YulL+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXlGoaG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXlGoaG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D5CC4CED1;
	Wed,  5 Feb 2025 14:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764680;
	bh=c1pHGyeX+xQAuPMIgoXonB/y0YWpCUvUK+q1/TKXSgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXlGoaG8LYVob9XHhW6B7yHlogghJxyT58LcjwBx2V256jSN64L4WZQvOpo4JmCjC
	 dnyHUIZK9IHowI5JJcVwCQVyIsxCxq6XpyuBXX2o0Ixy0x3sjtnLMmQVnj+J9Us2Ai
	 EP77EN8vRcjuB31RIA02ZwYjzpnDp9wtPBD23PYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/590] wifi: rtw89: chan: manage active interfaces
Date: Wed,  5 Feb 2025 14:38:23 +0100
Message-ID: <20250205134500.938295141@linuxfoundation.org>
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

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 68ec751b288178de7d19b71ea61648269a35b8cd ]

To set channel well for combination of MCC (multi-channel concurrency) and
impending MLO support, we need a method to manage relation between active
interfaces and channel contexts. If an interface owns at least one active
link, we call it an active interface. We add a list to manage active ones.

Basically, the list follows the active order except for the below case. To
be compatible with legacy behavior, the first interface that owns the first
channel context will put at the first entry in the list when recalculating.

Besides, MCC can also select and fill roles based on the above active list.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241022083106.149252-4-pkshih@realtek.com
Stable-dep-of: e47f0a589854 ("wifi: rtw89: fix proceeding MCC with wrong scanning state after sequence changes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/chan.c     | 105 ++++++++++++++++--
 drivers/net/wireless/realtek/rtw89/core.c     |   4 +-
 drivers/net/wireless/realtek/rtw89/core.h     |  10 ++
 drivers/net/wireless/realtek/rtw89/mac80211.c |   2 +
 4 files changed, 108 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/chan.c b/drivers/net/wireless/realtek/rtw89/chan.c
index ba6332da8019c..2b7e6921ff9c6 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.c
+++ b/drivers/net/wireless/realtek/rtw89/chan.c
@@ -10,6 +10,10 @@
 #include "ps.h"
 #include "util.h"
 
+static void rtw89_swap_chanctx(struct rtw89_dev *rtwdev,
+			       enum rtw89_chanctx_idx idx1,
+			       enum rtw89_chanctx_idx idx2);
+
 static enum rtw89_subband rtw89_get_subband_type(enum rtw89_band band,
 						 u8 center_chan)
 {
@@ -226,11 +230,15 @@ static void rtw89_config_default_chandef(struct rtw89_dev *rtwdev)
 void rtw89_entity_init(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_hal *hal = &rtwdev->hal;
+	struct rtw89_entity_mgnt *mgnt = &hal->entity_mgnt;
 
 	hal->entity_pause = false;
 	bitmap_zero(hal->entity_map, NUM_OF_RTW89_CHANCTX);
 	bitmap_zero(hal->changes, NUM_OF_RTW89_CHANCTX_CHANGES);
 	atomic_set(&hal->roc_chanctx_idx, RTW89_CHANCTX_IDLE);
+
+	INIT_LIST_HEAD(&mgnt->active_list);
+
 	rtw89_config_default_chandef(rtwdev);
 }
 
@@ -272,6 +280,71 @@ static void rtw89_entity_calculate_weight(struct rtw89_dev *rtwdev,
 	}
 }
 
+static void rtw89_normalize_link_chanctx(struct rtw89_dev *rtwdev,
+					 struct rtw89_vif_link *rtwvif_link)
+{
+	struct rtw89_vif *rtwvif = rtwvif_link->rtwvif;
+	struct rtw89_vif_link *cur;
+
+	if (unlikely(!rtwvif_link->chanctx_assigned))
+		return;
+
+	cur = rtw89_vif_get_link_inst(rtwvif, 0);
+	if (!cur || !cur->chanctx_assigned)
+		return;
+
+	if (cur == rtwvif_link)
+		return;
+
+	rtw89_swap_chanctx(rtwdev, rtwvif_link->chanctx_idx, cur->chanctx_idx);
+}
+
+static void rtw89_entity_recalc_mgnt_roles(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_hal *hal = &rtwdev->hal;
+	struct rtw89_entity_mgnt *mgnt = &hal->entity_mgnt;
+	struct rtw89_vif_link *link;
+	struct rtw89_vif *role;
+	u8 pos = 0;
+	int i;
+
+	lockdep_assert_held(&rtwdev->mutex);
+
+	for (i = 0; i < RTW89_MAX_INTERFACE_NUM; i++)
+		mgnt->active_roles[i] = NULL;
+
+	/* To be consistent with legacy behavior, expect the first active role
+	 * which uses RTW89_CHANCTX_0 to put at position 0, and make its first
+	 * link instance take RTW89_CHANCTX_0. (normalizing)
+	 */
+	list_for_each_entry(role, &mgnt->active_list, mgnt_entry) {
+		for (i = 0; i < role->links_inst_valid_num; i++) {
+			link = rtw89_vif_get_link_inst(role, i);
+			if (!link || !link->chanctx_assigned)
+				continue;
+
+			if (link->chanctx_idx == RTW89_CHANCTX_0) {
+				rtw89_normalize_link_chanctx(rtwdev, link);
+
+				list_del(&role->mgnt_entry);
+				list_add(&role->mgnt_entry, &mgnt->active_list);
+				break;
+			}
+		}
+	}
+
+	list_for_each_entry(role, &mgnt->active_list, mgnt_entry) {
+		if (unlikely(pos >= RTW89_MAX_INTERFACE_NUM)) {
+			rtw89_warn(rtwdev,
+				   "%s: active roles are over max iface num\n",
+				   __func__);
+			break;
+		}
+
+		mgnt->active_roles[pos++] = role;
+	}
+}
+
 enum rtw89_entity_mode rtw89_entity_recalc(struct rtw89_dev *rtwdev)
 {
 	DECLARE_BITMAP(recalc_map, NUM_OF_RTW89_CHANCTX) = {};
@@ -327,6 +400,8 @@ enum rtw89_entity_mode rtw89_entity_recalc(struct rtw89_dev *rtwdev)
 		rtw89_assign_entity_chan(rtwdev, idx, &chan);
 	}
 
+	rtw89_entity_recalc_mgnt_roles(rtwdev);
+
 	if (hal->entity_pause)
 		return rtw89_get_entity_mode(rtwdev);
 
@@ -716,6 +791,7 @@ struct rtw89_mcc_fill_role_selector {
 };
 
 static_assert((u8)NUM_OF_RTW89_CHANCTX >= NUM_OF_RTW89_MCC_ROLES);
+static_assert(RTW89_MAX_INTERFACE_NUM >= NUM_OF_RTW89_MCC_ROLES);
 
 static int rtw89_mcc_fill_role_iterator(struct rtw89_dev *rtwdev,
 					struct rtw89_mcc_role *mcc_role,
@@ -745,14 +821,18 @@ static int rtw89_mcc_fill_role_iterator(struct rtw89_dev *rtwdev,
 
 static int rtw89_mcc_fill_all_roles(struct rtw89_dev *rtwdev)
 {
+	struct rtw89_hal *hal = &rtwdev->hal;
+	struct rtw89_entity_mgnt *mgnt = &hal->entity_mgnt;
 	struct rtw89_mcc_fill_role_selector sel = {};
 	struct rtw89_vif_link *rtwvif_link;
 	struct rtw89_vif *rtwvif;
 	int ret;
+	int i;
 
-	rtw89_for_each_rtwvif(rtwdev, rtwvif) {
-		if (!rtw89_vif_is_active_role(rtwvif))
-			continue;
+	for (i = 0; i < NUM_OF_RTW89_MCC_ROLES; i++) {
+		rtwvif = mgnt->active_roles[i];
+		if (!rtwvif)
+			break;
 
 		rtwvif_link = rtw89_vif_get_link_inst(rtwvif, 0);
 		if (unlikely(!rtwvif_link)) {
@@ -760,14 +840,7 @@ static int rtw89_mcc_fill_all_roles(struct rtw89_dev *rtwdev)
 			continue;
 		}
 
-		if (sel.bind_vif[rtwvif_link->chanctx_idx]) {
-			rtw89_warn(rtwdev,
-				   "MCC skip extra vif <macid %d> on chanctx[%d]\n",
-				   rtwvif_link->mac_id, rtwvif_link->chanctx_idx);
-			continue;
-		}
-
-		sel.bind_vif[rtwvif_link->chanctx_idx] = rtwvif_link;
+		sel.bind_vif[i] = rtwvif_link;
 	}
 
 	ret = rtw89_iterate_mcc_roles(rtwdev, rtw89_mcc_fill_role_iterator, &sel);
@@ -2501,12 +2574,18 @@ int rtw89_chanctx_ops_assign_vif(struct rtw89_dev *rtwdev,
 				 struct ieee80211_chanctx_conf *ctx)
 {
 	struct rtw89_chanctx_cfg *cfg = (struct rtw89_chanctx_cfg *)ctx->drv_priv;
+	struct rtw89_vif *rtwvif = rtwvif_link->rtwvif;
+	struct rtw89_hal *hal = &rtwdev->hal;
+	struct rtw89_entity_mgnt *mgnt = &hal->entity_mgnt;
 	struct rtw89_entity_weight w = {};
 
 	rtwvif_link->chanctx_idx = cfg->idx;
 	rtwvif_link->chanctx_assigned = true;
 	cfg->ref_count++;
 
+	if (list_empty(&rtwvif->mgnt_entry))
+		list_add_tail(&rtwvif->mgnt_entry, &mgnt->active_list);
+
 	if (cfg->idx == RTW89_CHANCTX_0)
 		goto out;
 
@@ -2526,6 +2605,7 @@ void rtw89_chanctx_ops_unassign_vif(struct rtw89_dev *rtwdev,
 				    struct ieee80211_chanctx_conf *ctx)
 {
 	struct rtw89_chanctx_cfg *cfg = (struct rtw89_chanctx_cfg *)ctx->drv_priv;
+	struct rtw89_vif *rtwvif = rtwvif_link->rtwvif;
 	struct rtw89_hal *hal = &rtwdev->hal;
 	enum rtw89_chanctx_idx roll;
 	enum rtw89_entity_mode cur;
@@ -2536,6 +2616,9 @@ void rtw89_chanctx_ops_unassign_vif(struct rtw89_dev *rtwdev,
 	rtwvif_link->chanctx_assigned = false;
 	cfg->ref_count--;
 
+	if (!rtw89_vif_is_active_role(rtwvif))
+		list_del_init(&rtwvif->mgnt_entry);
+
 	if (cfg->ref_count != 0)
 		goto out;
 
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 37d2bcba1b315..e864da4d37519 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -192,13 +192,13 @@ static const struct ieee80211_iface_combination rtw89_iface_combs[] = {
 	{
 		.limits = rtw89_iface_limits,
 		.n_limits = ARRAY_SIZE(rtw89_iface_limits),
-		.max_interfaces = 2,
+		.max_interfaces = RTW89_MAX_INTERFACE_NUM,
 		.num_different_channels = 1,
 	},
 	{
 		.limits = rtw89_iface_limits_mcc,
 		.n_limits = ARRAY_SIZE(rtw89_iface_limits_mcc),
-		.max_interfaces = 2,
+		.max_interfaces = RTW89_MAX_INTERFACE_NUM,
 		.num_different_channels = 2,
 	},
 };
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 0ed31b37d10fe..65ad3d03d0530 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -4628,6 +4628,14 @@ enum rtw89_entity_mode {
 	RTW89_ENTITY_MODE_UNHANDLED = -ESRCH,
 };
 
+#define RTW89_MAX_INTERFACE_NUM 2
+
+/* only valid when running with chanctx_ops */
+struct rtw89_entity_mgnt {
+	struct list_head active_list;
+	struct rtw89_vif *active_roles[RTW89_MAX_INTERFACE_NUM];
+};
+
 struct rtw89_chanctx {
 	struct cfg80211_chan_def chandef;
 	struct rtw89_chan chan;
@@ -4671,6 +4679,7 @@ struct rtw89_hal {
 	bool entity_active[RTW89_PHY_MAX];
 	bool entity_pause;
 	enum rtw89_entity_mode entity_mode;
+	struct rtw89_entity_mgnt entity_mgnt;
 
 	struct rtw89_edcca_bak edcca_bak;
 	u32 disabled_dm_bitmap; /* bitmap of enum rtw89_dm_type */
@@ -5607,6 +5616,7 @@ struct rtw89_dev {
 struct rtw89_vif {
 	struct rtw89_dev *rtwdev;
 	struct list_head list;
+	struct list_head mgnt_entry;
 
 	u8 mac_addr[ETH_ALEN];
 	__be32 ip_addr;
diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 13fb3cac27016..299566e2f612d 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -192,6 +192,8 @@ static int rtw89_ops_add_interface(struct ieee80211_hw *hw,
 	if (!rtw89_rtwvif_in_list(rtwdev, rtwvif))
 		list_add_tail(&rtwvif->list, &rtwdev->rtwvifs_list);
 
+	INIT_LIST_HEAD(&rtwvif->mgnt_entry);
+
 	ether_addr_copy(rtwvif->mac_addr, vif->addr);
 
 	rtwvif->offchan = false;
-- 
2.39.5



