Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0127C168C4;
	Mon, 27 May 2024 19:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837930; cv=none; b=J3MIdSzziqUZWGBfoNpRVySnsCQJ/Ztryd1ALDenNEnva0p/fULCKhe2ArE3iR6ddC0YPHBSEhrpotouuHl29pOVO1wDVbRyhhOmzXQxNzj71yleJ9JC+Z6twOOqWV7FHfbhzQqcE1cx/mC59gzneyPbBmFREhZKGOhDSiDlH8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837930; c=relaxed/simple;
	bh=vAYdHzlhCh0eW4X7zHOhYJ95D0XLHe7ss52sfjuK9Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cS29k81fXD0sR23ZnfhecWOEV28+9B2gC+0lFpfG7kOgijZDFTxw98dpH7nu+X06Hn4xTX6EyhGvxTOd0eeMdA2PGOiFkkiQS4ROV8wzYqY851HjrqL2Vvf7TaEi86IIoF69OYylfswUHfmzUdIeEwdjSlU/043Yimx4LBV1XYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtoV2AYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtoV2AYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC35C2BBFC;
	Mon, 27 May 2024 19:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837929;
	bh=vAYdHzlhCh0eW4X7zHOhYJ95D0XLHe7ss52sfjuK9Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtoV2AYF8LWr+Oq4uMyxHRx3i70ZFlV37PWLH2i3SqQsUzLB+7Vy98CK7sZIj2rcB
	 KXImpkZllfGtBm+Lhej4mP0TrlbPkH5mtHXon1Kt+Xo46y+Exr5iKiHK7+2iYhG3xS
	 TDPePYX203DX8tvYnUqNrivRY115FffLjpZjQljQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 173/493] wifi: iwlwifi: implement can_activate_links callback
Date: Mon, 27 May 2024 20:52:55 +0200
Message-ID: <20240527185636.006011654@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit c4d32f2745c75c9041937767f0329f6f1051778b ]

This callback checks if a given bitmap of active_links
will be supported by the driver or not.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://msgid.link/20240123200528.a26fd48bfe3d.I03ae6b4c7fd24e8701660a68cec9403dc3469a0e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 9737da2f00d6 ("wifi: iwlwifi: mvm: fix active link counting during recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/intel/iwlwifi/mvm/mld-mac80211.c  | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 893b69fc841b8..1da4fd1c4560b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -254,9 +254,6 @@ __iwl_mvm_mld_assign_vif_chanctx(struct iwl_mvm *mvm,
 	if (!rcu_access_pointer(link_conf->chanctx_conf))
 		n_active++;
 
-	if (n_active > iwl_mvm_max_active_links(mvm, vif))
-		return -EOPNOTSUPP;
-
 	if (WARN_ON_ONCE(!mvmvif->link[link_id]))
 		return -EINVAL;
 
@@ -1122,17 +1119,12 @@ iwl_mvm_mld_change_vif_links(struct ieee80211_hw *hw,
 			     struct ieee80211_bss_conf *old[IEEE80211_MLD_MAX_NUM_LINKS])
 {
 	struct iwl_mvm_vif_link_info *new_link[IEEE80211_MLD_MAX_NUM_LINKS] = {};
-	unsigned int n_active = iwl_mvm_mld_count_active_links(vif);
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	u16 removed = old_links & ~new_links;
 	u16 added = new_links & ~old_links;
 	int err, i;
 
-	if (hweight16(new_links) > 1 &&
-	    n_active > iwl_mvm_max_active_links(mvm, vif))
-		return -EOPNOTSUPP;
-
 	for (i = 0; i < IEEE80211_MLD_MAX_NUM_LINKS; i++) {
 		int r;
 
@@ -1224,6 +1216,15 @@ iwl_mvm_mld_change_sta_links(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static bool iwl_mvm_mld_can_activate_links(struct ieee80211_hw *hw,
+					   struct ieee80211_vif *vif,
+					   u16 desired_links)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	return hweight16(desired_links) <= iwl_mvm_max_active_links(mvm, vif);
+}
+
 const struct ieee80211_ops iwl_mvm_mld_hw_ops = {
 	.tx = iwl_mvm_mac_tx,
 	.wake_tx_queue = iwl_mvm_mac_wake_tx_queue,
@@ -1318,4 +1319,5 @@ const struct ieee80211_ops iwl_mvm_mld_hw_ops = {
 
 	.change_vif_links = iwl_mvm_mld_change_vif_links,
 	.change_sta_links = iwl_mvm_mld_change_sta_links,
+	.can_activate_links = iwl_mvm_mld_can_activate_links,
 };
-- 
2.43.0



