Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FAF1AB52A;
	Thu,  6 Jun 2024 14:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683259; cv=none; b=RdzM+quZqNVxXOuai5PWPxlfwibW5AbNZKK9BaPKdaSwxdI59xQPhp5zRB3GK/fyfGsd06Z3fu7Q/tFMuDNZVizzNfTxZ+M9tDbIIghjslpLxl0C4+QV9/SZ2k8XeOygutImgyr4jXp3z8cCmptd8AYMS8RIVpi0/rzyKrh60uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683259; c=relaxed/simple;
	bh=RsPa2wPVI2x4Sz6Gq4SEbkLvsO/O103zshqHFSpHBCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrXr4k/bTqL7Y/syNoirCwEOO9paLd9a+0ToyLj/2lCd31Sl1P55mS4bEBYhTGWbKdorWypJiRZFVxUtHzJZ5K/JOTFlFeOKSuWhKphE1XqEjJHxsBXEAsxoO9nXcsaCrRfYGcvaxZIa4jJnLpylign41XlnDpr6/0Bs54wfC/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEG37kGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEG37kGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D49C32781;
	Thu,  6 Jun 2024 14:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683259;
	bh=RsPa2wPVI2x4Sz6Gq4SEbkLvsO/O103zshqHFSpHBCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEG37kGfUsgdnAxV0DnBP8iBWSM+iseKVBnKjxPAZvkjU0GHykPyBvISgmOOTCtxP
	 UYqZbXUw8Bwylc44EoUeF6dk9YvzxWfFNiCOM3USe/cx0sKrdGVsv+VMaNgcyflVpw
	 flt3k+XWIR03sc2r8KMyO4sjs3XI46CxWH5DHXds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/744] wifi: iwlwifi: mvm: init vif works only once
Date: Thu,  6 Jun 2024 15:57:28 +0200
Message-ID: <20240606131738.081634082@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

[ Upstream commit 0bcc2155983e03c41b21a356af87ae839a6b3ead ]

It's dangerous to re-initialize works repeatedly, especially
delayed ones that have an associated timer, and even more so
if they're not necessarily canceled inbetween. This can be
the case for these workers here during FW restart scenarios,
so make sure to initialize it only once.

While at it, also ensure it is cancelled correctly.

Fixes: f67806140220 ("iwlwifi: mvm: disconnect in case of bad channel switch parameters")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240416134215.ddf8eece5eac.I4164f5c9c444b64a9abbaab14c23858713778e35@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 19 +++++++++++++++++--
 .../wireless/intel/iwlwifi/mvm/mld-mac80211.c |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  2 ++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index ee9d14250a261..375f401b14535 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1513,6 +1513,17 @@ static int iwl_mvm_alloc_bcast_mcast_sta(struct iwl_mvm *mvm,
 					IWL_STA_MULTICAST);
 }
 
+void iwl_mvm_mac_init_mvmvif(struct iwl_mvm *mvm, struct iwl_mvm_vif *mvmvif)
+{
+	lockdep_assert_held(&mvm->mutex);
+
+	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
+		return;
+
+	INIT_DELAYED_WORK(&mvmvif->csa_work,
+			  iwl_mvm_channel_switch_disconnect_wk);
+}
+
 static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif)
 {
@@ -1522,6 +1533,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	iwl_mvm_mac_init_mvmvif(mvm, mvmvif);
+
 	mvmvif->mvm = mvm;
 
 	/* the first link always points to the default one */
@@ -1595,8 +1608,6 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		mvm->p2p_device_vif = vif;
 
 	iwl_mvm_tcm_add_vif(mvm, vif);
-	INIT_DELAYED_WORK(&mvmvif->csa_work,
-			  iwl_mvm_channel_switch_disconnect_wk);
 
 	if (vif->type == NL80211_IFTYPE_MONITOR) {
 		mvm->monitor_on = true;
@@ -1638,6 +1649,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
 				 struct ieee80211_vif *vif)
 {
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
 	if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
 		/*
 		 * Flush the ROC worker which will flush the OFFCHANNEL queue.
@@ -1646,6 +1659,8 @@ void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
 		 */
 		flush_work(&mvm->roc_done_wk);
 	}
+
+	cancel_delayed_work_sync(&mvmvif->csa_work);
 }
 
 /* This function is doing the common part of removing the interface for
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index e22db69d99909..aef8824469e1e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -13,6 +13,8 @@ static int iwl_mvm_mld_mac_add_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	iwl_mvm_mac_init_mvmvif(mvm, mvmvif);
+
 	mvmvif->mvm = mvm;
 
 	/* Not much to do here. The stack will not allow interface
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 218f3bc31104b..c780e5ffcd596 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1737,6 +1737,8 @@ int iwl_mvm_load_d3_fw(struct iwl_mvm *mvm);
 
 int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm);
 
+void iwl_mvm_mac_init_mvmvif(struct iwl_mvm *mvm, struct iwl_mvm_vif *mvmvif);
+
 /*
  * FW notifications / CMD responses handlers
  * Convention: iwl_mvm_rx_<NAME OF THE CMD>
-- 
2.43.0



