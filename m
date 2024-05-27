Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ECB15FD16;
	Mon, 27 May 2024 19:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836711; cv=none; b=n4ZuGWc3Nkmx0hQz3D3dt+j4tXlkT6/vNK3nLE2fiOWRkIDHOOXQIwWiSQCoo3A7j8CPBGrsBCZrBAkU4N3S+QZRS6k6LC05o8/atXDAlzMHfthyQQlA92Oqg30mxNw9J9kjwV4qThCceK2WFflaFhMT8T2gquTXHjzkjV1IJMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836711; c=relaxed/simple;
	bh=Krn+jGhPidbLxOjovPrZbCDVKJBw4kWenobzYiGx/w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ia/aECTxdWmvOIHLW/wc96rcHMt7Jzo2Qx45MLYGJl1IN62ny7/t/Ao+lFe/g1l2HQS2dhj47HFzfdgbgSuXeZ4LNSCZiGM9pjbbJh2dy1RePuOf+Krl5OhXDIqz8/SIw7iBKDMUF972R90gF6Koo/a/Ywir2vfVU2epIAEG5lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBQtKCL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBQtKCL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF56C32786;
	Mon, 27 May 2024 19:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836711;
	bh=Krn+jGhPidbLxOjovPrZbCDVKJBw4kWenobzYiGx/w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBQtKCL/66NusYqsu/kBVPakgoGmgJCwQ7RLFt7aHxlBH+KJpo/0uGB+9M9Rd5Ut8
	 0koYtJQbkRFJZ0dQBGapjPPn0f5NyEJXepIIJmu6SGBen86BMtMzD/z/mmixERKPZq
	 dzQP5rCp06NqGATmkIqGH27rQYuootaiPDQgJAZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 158/427] wifi: iwlwifi: mvm: init vif works only once
Date: Mon, 27 May 2024 20:53:25 +0200
Message-ID: <20240527185617.215336702@linuxfoundation.org>
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
index 2425c22e83f4a..7ed7444c98715 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1564,6 +1564,17 @@ static int iwl_mvm_alloc_bcast_mcast_sta(struct iwl_mvm *mvm,
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
@@ -1574,6 +1585,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	iwl_mvm_mac_init_mvmvif(mvm, mvmvif);
+
 	mvmvif->mvm = mvm;
 
 	/* the first link always points to the default one */
@@ -1655,8 +1668,6 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		mvm->p2p_device_vif = vif;
 
 	iwl_mvm_tcm_add_vif(mvm, vif);
-	INIT_DELAYED_WORK(&mvmvif->csa_work,
-			  iwl_mvm_channel_switch_disconnect_wk);
 
 	if (vif->type == NL80211_IFTYPE_MONITOR) {
 		mvm->monitor_on = true;
@@ -1694,6 +1705,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
 				 struct ieee80211_vif *vif)
 {
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
 	if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
 		/*
 		 * Flush the ROC worker which will flush the OFFCHANNEL queue.
@@ -1702,6 +1715,8 @@ void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
 		 */
 		flush_work(&mvm->roc_done_wk);
 	}
+
+	cancel_delayed_work_sync(&mvmvif->csa_work);
 }
 
 /* This function is doing the common part of removing the interface for
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index ffbcc5a2d0ae7..df183a79db4c8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -14,6 +14,8 @@ static int iwl_mvm_mld_mac_add_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	iwl_mvm_mac_init_mvmvif(mvm, mvmvif);
+
 	mvmvif->mvm = mvm;
 
 	/* Not much to do here. The stack will not allow interface
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index c45039d2ad2fa..d1ab35eb55b23 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1783,6 +1783,8 @@ int iwl_mvm_load_d3_fw(struct iwl_mvm *mvm);
 
 int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm);
 
+void iwl_mvm_mac_init_mvmvif(struct iwl_mvm *mvm, struct iwl_mvm_vif *mvmvif);
+
 /*
  * FW notifications / CMD responses handlers
  * Convention: iwl_mvm_rx_<NAME OF THE CMD>
-- 
2.43.0



