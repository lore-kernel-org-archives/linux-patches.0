Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E8E262BE;
	Mon, 27 May 2024 19:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838094; cv=none; b=hLX7acGKSx4DIsJNVgwTdWA693eyNDd5y3tbA5DRAoUf7uaDN8Yt1R46c5Vd33serHeTykwoMkKMDS0bkwtjs0co2VDyf/y7PG2klhrYWPNku0SOjtcxFlf9sMb/w7SiwjwIbA57wE6ijLf4sUzB9Cq1UzKvKg8kmGTSsRpq3Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838094; c=relaxed/simple;
	bh=bqQ57iN8N5BvLiL/gYhPLoGhi8lzg4+NpWJXNX7TVes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmHW1DUIhmBjzi/r/sLN5M2Y+gVVTlLNptam+V3h88kUhJtyt6IPWs3FRWQkUXaHBpyXygsPLukuFps6iQRQNAGtJsx8H5KsMs1C2EVM//Mmrdmu6uDrX0v4uLfedKa7uNKuW4dWqkbkHLKw2fOsH38Y50DPpu8pBJ9y3masPeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lO9UqfXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lO9UqfXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0220CC2BBFC;
	Mon, 27 May 2024 19:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838094;
	bh=bqQ57iN8N5BvLiL/gYhPLoGhi8lzg4+NpWJXNX7TVes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lO9UqfXgwUqIvSTo4SzWIRtgLPZCZSz2OcWpjXzvzfOKCysNLfHndm7nA3ZQLbVW/
	 bCv1HJW9X8YXC8KqWBTEwCAAVxXB4CQdf7igAQjwCLYHZ8bz+M5Lbb5Up6HPg2eR+n
	 h2KEBtVaQLsnU5/TbZy2Hq5/AoHiC1yTjPyhdjVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 222/493] wifi: iwlwifi: mvm: init vif works only once
Date: Mon, 27 May 2024 20:53:44 +0200
Message-ID: <20240527185637.567527435@linuxfoundation.org>
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
index e321d41d1aba2..05735817918be 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1547,6 +1547,17 @@ static int iwl_mvm_alloc_bcast_mcast_sta(struct iwl_mvm *mvm,
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
@@ -1557,6 +1568,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	iwl_mvm_mac_init_mvmvif(mvm, mvmvif);
+
 	mvmvif->mvm = mvm;
 
 	/* the first link always points to the default one */
@@ -1632,8 +1645,6 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		mvm->p2p_device_vif = vif;
 
 	iwl_mvm_tcm_add_vif(mvm, vif);
-	INIT_DELAYED_WORK(&mvmvif->csa_work,
-			  iwl_mvm_channel_switch_disconnect_wk);
 
 	if (vif->type == NL80211_IFTYPE_MONITOR) {
 		mvm->monitor_on = true;
@@ -1671,6 +1682,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
 				 struct ieee80211_vif *vif)
 {
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
 	if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
 		/*
 		 * Flush the ROC worker which will flush the OFFCHANNEL queue.
@@ -1679,6 +1692,8 @@ void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
 		 */
 		flush_work(&mvm->roc_done_wk);
 	}
+
+	cancel_delayed_work_sync(&mvmvif->csa_work);
 }
 
 /* This function is doing the common part of removing the interface for
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 935cbe2026491..1b39c9ea55fa3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -14,6 +14,8 @@ static int iwl_mvm_mld_mac_add_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	iwl_mvm_mac_init_mvmvif(mvm, mvmvif);
+
 	mvmvif->mvm = mvm;
 
 	/* Not much to do here. The stack will not allow interface
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index fe0fa9ff533d7..4653f608355cc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1769,6 +1769,8 @@ int iwl_mvm_load_d3_fw(struct iwl_mvm *mvm);
 
 int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm);
 
+void iwl_mvm_mac_init_mvmvif(struct iwl_mvm *mvm, struct iwl_mvm_vif *mvmvif);
+
 /*
  * FW notifications / CMD responses handlers
  * Convention: iwl_mvm_rx_<NAME OF THE CMD>
-- 
2.43.0



