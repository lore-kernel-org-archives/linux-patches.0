Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD962DE717
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301106; cv=none; b=j2/LpaBnS/ug7piNUWn8MGYFFzMJtdfAth8nRPQcMchlY99rUHSmLmOYv4fdUrz6ATeSrDxPaeRWtAm1K5mFQRYFxz568SaeGj6e4yPmQbdjQSFMR+EfgoCTyot//z5qYY9FASi4yAq19LXq4YHNW6GdHSpFHVo9c+cP46MJ/Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301106; c=relaxed/simple;
	bh=n5tXH2gD6+CtWNUQdR7C/L6vhkUZT3ktzg7iQZppVJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlV9NHs3zw0UmPbAESC4oJgm5lNriaoe6CL9CYPpkMBQLBSmi27gcSOgcINBugHiZ+57/6K69nmFaaAL33mNffWNz5kTv49/yQbljZYTC6CVUieRyxqwbCrgT7NyPlKcTvVeyOXHxVb8gGRBn/VRxEVHsNNJbPxW0abZonAaCUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9XudTMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9XudTMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93B0C19423;
	Sat, 28 Feb 2026 17:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301106;
	bh=n5tXH2gD6+CtWNUQdR7C/L6vhkUZT3ktzg7iQZppVJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9XudTMY2zux4hoQGlZ6FoFPQmQXoY/AxjjrQu70fXxjxyqpL3qzsjxfjgZ+lPWDV
	 i9oWpIgy6DWUhYqTk6rcA1oI4tB/RB+iVNcJS08nqrQ0zOG5MjHtjeCMuh44D9vJ5w
	 CLUbIuIt8crapmaH/efS/ugEEfaCWjlL/RB3rLZqtTCgHYXrj1CFetkuukQlWJFHwo
	 ZpBey6+w6NLhvrf2TkuActdHJT8z78zLZno3oNC55uVRT3cx+WrPWsAj22eBiknzO/
	 rfNY+i5os4jb5asrkCDsW+Kn+Pb3NXqP7Pd/0xBSuzKpy6R8jZyapE9mviLlJD8PmQ
	 N6s4pAMjFaXwg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nidhish A N <nidhish.a.n@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 260/752] wifi: iwlwifi: mld: Fix primary link selection logic
Date: Sat, 28 Feb 2026 12:39:31 -0500
Message-ID: <20260228174750.1542406-260-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nidhish A N <nidhish.a.n@intel.com>

[ Upstream commit 7a749db26cab2334d5b356ac31e6f1147c7682da ]

When assigning emlsr.primary with emlsr.selected_primary
we are checking if BIT(mld_vif->emlsr.selected_links) are
a part of vif->active_links. This is incorrect as
emlsr.selected_links is a bitmap of possibly two selected links.
Therefore, performing the BIT() operation on it does not
yield any meaningful result and almost always leads to
incorrect primary link selection.

Additionally, we cannot rely on vif->active_links at this
stage of the link switch flow because it contains both the
removed links and also the newly added links.
For example, if we had selected links in the past (0x11)
and we now select links because of TTLM/debugfs (0x100),
vif->active_links will now be (0x111) and primary link
will be 0, while 0 is not even an active link. Thus,
we create our own bitmap of final active links.

Signed-off-by: Nidhish A N <nidhish.a.n@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260111193638.38b2e14e3a20.Ie81a88dfff0c5d2becedabab8398702808f6b1bf@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mld/mac80211.c | 23 ++++++++++++-------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 2a7e7417d7d84..0f2db3ed58530 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -980,7 +980,9 @@ int iwl_mld_assign_vif_chanctx(struct ieee80211_hw *hw,
 {
 	struct iwl_mld *mld = IWL_MAC80211_GET_MLD(hw);
 	struct iwl_mld_link *mld_link = iwl_mld_link_from_mac80211(link);
-	unsigned int n_active = iwl_mld_count_active_links(mld, vif);
+	struct iwl_mld_link *temp_mld_link;
+	struct iwl_mld_vif *mld_vif = iwl_mld_vif_from_mac80211(vif);
+	u16 final_active_links = 0;
 	int ret;
 
 	lockdep_assert_wiphy(mld->wiphy);
@@ -988,10 +990,7 @@ int iwl_mld_assign_vif_chanctx(struct ieee80211_hw *hw,
 	if (WARN_ON(!mld_link))
 		return -EINVAL;
 
-	/* if the assigned one was not counted yet, count it now */
 	if (!rcu_access_pointer(mld_link->chan_ctx)) {
-		n_active++;
-
 		/* Track addition of non-BSS link */
 		if (ieee80211_vif_type_p2p(vif) != NL80211_IFTYPE_STATION) {
 			ret = iwl_mld_emlsr_check_non_bss_block(mld, 1);
@@ -1012,17 +1011,25 @@ int iwl_mld_assign_vif_chanctx(struct ieee80211_hw *hw,
 
 	rcu_assign_pointer(mld_link->chan_ctx, ctx);
 
-	if (n_active > 1) {
-		struct iwl_mld_vif *mld_vif = iwl_mld_vif_from_mac80211(vif);
+	/* We cannot rely on vif->active_links at this stage as it contains
+	 * both the removed links and the newly added links.
+	 * Therefore, we create our own bitmap of the final active links,
+	 * which does not include the removed links.
+	 */
+	for_each_mld_vif_valid_link(mld_vif, temp_mld_link) {
+		if (rcu_access_pointer(temp_mld_link->chan_ctx))
+			final_active_links |= BIT(link_id);
+	}
 
+	if (hweight16(final_active_links) > 1) {
 		/* Indicate to mac80211 that EML is enabled */
 		vif->driver_flags |= IEEE80211_VIF_EML_ACTIVE;
 		mld_vif->emlsr.last_entry_ts = jiffies;
 
-		if (vif->active_links & BIT(mld_vif->emlsr.selected_links))
+		if (final_active_links == mld_vif->emlsr.selected_links)
 			mld_vif->emlsr.primary = mld_vif->emlsr.selected_primary;
 		else
-			mld_vif->emlsr.primary = __ffs(vif->active_links);
+			mld_vif->emlsr.primary = __ffs(final_active_links);
 
 		iwl_dbg_tlv_time_point(&mld->fwrt, IWL_FW_INI_TIME_ESR_LINK_UP,
 				       NULL);
-- 
2.51.0

