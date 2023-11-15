Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620CF3C475
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CyPoWI5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CE6C433D9;
	Wed, 15 Nov 2023 19:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077213;
	bh=AWtBayWPtioh5+KLCfWxyfU5yBoBR9ARLSKm/MHWtRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyPoWI5s7YPvuUNpoBMKHQ6ZymQcBCCGUQNolv7cWWvNVGujSCRTraF+mEqX2z556
	 KHAmRNCO1iWxgZ7mu0+2UbNo/kJSpGiRqIzgyrtcAfVl37Qr1WMXRO7yLPbHFi/dIQ
	 4pqeg49749y82zEomOwazR0lOvwSLOvyWVhqzNNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/603] wifi: iwlwifi: mvm: fix iwl_mvm_mac_flush_sta()
Date: Wed, 15 Nov 2023 14:11:26 -0500
Message-ID: <20231115191622.948092786@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 43874283ce6c5bd32ac9d30878b2c96a974357cb ]

When I implemented iwl_mvm_mac_flush_sta() I completely botched it;
it basically always happens after the iwl_mvm_sta_pre_rcu_remove()
call, and that already clears mvm->fw_id_to_mac_id[] entries, so we
cannot rely on those at iwl_mvm_mac_flush_sta() time. This means it
never did anything.

Fix this by just going through the station IDs and now with the new
API for iwl_mvm_flush_sta(), call those.

Fixes: a6cc6ccb1c8a ("wifi: iwlwifi: mvm: support new flush_sta method")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20231011130030.0b5878e93118.I1093e60163052e7be64d2b01424097cd6a272979@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 20 +++++++++----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index e68026a657059..a25ea638229b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -5602,22 +5602,20 @@ void iwl_mvm_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 void iwl_mvm_mac_flush_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta)
 {
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-	int i;
+	struct iwl_mvm_link_sta *mvm_link_sta;
+	struct ieee80211_link_sta *link_sta;
+	int link_id;
 
 	mutex_lock(&mvm->mutex);
-	for (i = 0; i < mvm->fw->ucode_capa.num_stations; i++) {
-		struct iwl_mvm_sta *mvmsta;
-		struct ieee80211_sta *tmp;
-
-		tmp = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
-						lockdep_is_held(&mvm->mutex));
-		if (tmp != sta)
+	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+		mvm_link_sta = rcu_dereference_protected(mvmsta->link[link_id],
+							 lockdep_is_held(&mvm->mutex));
+		if (!mvm_link_sta)
 			continue;
 
-		mvmsta = iwl_mvm_sta_from_mac80211(sta);
-
-		if (iwl_mvm_flush_sta(mvm, mvmsta->deflink.sta_id,
+		if (iwl_mvm_flush_sta(mvm, mvm_link_sta->sta_id,
 				      mvmsta->tfd_queue_msk))
 			IWL_ERR(mvm, "flush request fail\n");
 	}
-- 
2.42.0



