Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1A915ECFF;
	Mon, 27 May 2024 19:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836564; cv=none; b=YkSyI5WPUF8bXvXv3LM+3qj2zqSYrqh0zdY0vCvB8QHz5eAzddjox1gnMn3gOYx6PVSf5TMo8T2Va19rEi0Eu5YYeezS/tNN8CXBT1lb5IEZHNtC0e1SZe5rspueCdKXl8R9WNaOXAsY0Vd3S9cuYAddC+64ZyvziwTzcbRCvD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836564; c=relaxed/simple;
	bh=OVgE7XL0N1rsoWYrOyUNd7wW9HWkskPkrWNjbsoHFYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJpU3KpSwmbEpZ+RGhqlynIr8UiKHJFYKrPf9M5R1na4vA9cQ8IBZNwAa0nPPgB2QK0lmknvVLiAFN3YAeyaKLpSCuVAg/h9vZwhr1sWchppAm7afwwhDcqG6TVHz/FHtOezi7uH8OQ56V240cnLpbtCKVxiJON8nDPaHN1cwRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUifmXVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUifmXVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA85AC4AF0A;
	Mon, 27 May 2024 19:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836564;
	bh=OVgE7XL0N1rsoWYrOyUNd7wW9HWkskPkrWNjbsoHFYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUifmXVQUs44e6WPU77D+h2QDCntAg/LDeaxlbTltfb5aHY+7caDgBqX774WM9S1y
	 zZhYd3Q3cf2wsb/Ltx3IAWNh1nsxHKnJ7RZdtkj3Eosvp6RULC65rqsiUK+w6kKLoP
	 otrkRK0yUNuptlvCijdPp+FPHRRSAg3fRtkDNnns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 104/427] wifi: iwlwifi: mvm: fix active link counting during recovery
Date: Mon, 27 May 2024 20:52:31 +0200
Message-ID: <20240527185611.466217454@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 9737da2f00d6409ae48a79d4dddd9362b230aa31 ]

During recovery, the chanctx_conf in mac80211 is still non-NULL even
though the channel context has not yet been assigned again. In that
case, the real count is actually lower.

Switch to instead count the phy_ctx assignment and ensure that the
assignment is cleared at the start of recovery.

Fixes: 12bacfc2c065 ("wifi: iwlwifi: handle eSR transitions")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240320232419.55f37339e7d1.I57006568a90ffb7a1232def1b2f3264dea711ba6@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/intel/iwlwifi/mvm/mld-mac80211.c | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 084314bf6f369..d18304ac126cd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -189,17 +189,13 @@ static void iwl_mvm_mld_mac_remove_interface(struct ieee80211_hw *hw,
 	mutex_unlock(&mvm->mutex);
 }
 
-static unsigned int iwl_mvm_mld_count_active_links(struct ieee80211_vif *vif)
+static unsigned int iwl_mvm_mld_count_active_links(struct iwl_mvm_vif *mvmvif)
 {
 	unsigned int n_active = 0;
 	int i;
 
 	for (i = 0; i < IEEE80211_MLD_MAX_NUM_LINKS; i++) {
-		struct ieee80211_bss_conf *link_conf;
-
-		link_conf = link_conf_dereference_protected(vif, i);
-		if (link_conf &&
-		    rcu_access_pointer(link_conf->chanctx_conf))
+		if (mvmvif->link[i] && mvmvif->link[i]->phy_ctxt)
 			n_active++;
 	}
 
@@ -245,18 +241,18 @@ __iwl_mvm_mld_assign_vif_chanctx(struct iwl_mvm *mvm,
 {
 	u16 *phy_ctxt_id = (u16 *)ctx->drv_priv;
 	struct iwl_mvm_phy_ctxt *phy_ctxt = &mvm->phy_ctxts[*phy_ctxt_id];
-	unsigned int n_active = iwl_mvm_mld_count_active_links(vif);
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	unsigned int n_active = iwl_mvm_mld_count_active_links(mvmvif);
 	unsigned int link_id = link_conf->link_id;
 	int ret;
 
-	/* if the assigned one was not counted yet, count it now */
-	if (!rcu_access_pointer(link_conf->chanctx_conf))
-		n_active++;
-
 	if (WARN_ON_ONCE(!mvmvif->link[link_id]))
 		return -EINVAL;
 
+	/* if the assigned one was not counted yet, count it now */
+	if (!mvmvif->link[link_id]->phy_ctxt)
+		n_active++;
+
 	/* mac parameters such as HE support can change at this stage
 	 * For sta, need first to configure correct state from drv_sta_state
 	 * and only after that update mac config.
@@ -416,7 +412,7 @@ __iwl_mvm_mld_unassign_vif_chanctx(struct iwl_mvm *mvm,
 
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	unsigned int n_active = iwl_mvm_mld_count_active_links(vif);
+	unsigned int n_active = iwl_mvm_mld_count_active_links(mvmvif);
 	unsigned int link_id = link_conf->link_id;
 
 	/* shouldn't happen, but verify link_id is valid before accessing */
-- 
2.43.0



