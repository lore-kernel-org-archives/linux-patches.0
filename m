Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D4F1A6195;
	Tue, 30 Jul 2024 16:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356884; cv=none; b=tDpBNJlXHodSjXMU7S64CVvdmZE8VefGU/qSqgLjliGjqYGnJ5ODK3KMmOZwsxADhgrkGJKUAxWJMkwhtRMpR30fSV46GbiMMmJjgqbDPw5wsI4Wylj+B7vqM9FfkeSOb0hQz3M7nJeT4ScKULnfpe0V9aQWQnJMCnLUrPrYsSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356884; c=relaxed/simple;
	bh=Cy3XptCeCdJOdUOVGtGFSgj6qAwgL6oCO6fn4naVAug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0ZW4Tr+w+vHN/rceQCAJf9NNWw00bWx/qJeOhAe0dRFfZMc0nyx5LDsuBAz0iOZKmHZtvQ17rCvfi1m39Vmg3yhtNYSKZaIF1sx8pInD1yUefpC4cvnmpEr7MxNh1UFcetGT9Cok+6MxNFVfd63NJDu8r7NOXNSJwQkeOOcguI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xf/jd1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xf/jd1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248CAC32782;
	Tue, 30 Jul 2024 16:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356884;
	bh=Cy3XptCeCdJOdUOVGtGFSgj6qAwgL6oCO6fn4naVAug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xf/jd1O+gWrwEqQJwo1zoY0WUsi3kmvZzF8on0pk8VTCEdOXcusvem62m4Ue7vsl
	 nExPRtPf9hIpnUqxvDPIUxRcpTeAVYWZ+kOPfHijmzN6h8jzAuc8nazHDVnab1Ec5N
	 fpaE1w3CZpRTO3yMx6f2Ky3ik8Uz2IAUb/zFKMVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 196/809] wifi: iwlwifi: mvm: separate non-BSS/ROC EMLSR blocking
Date: Tue, 30 Jul 2024 17:41:12 +0200
Message-ID: <20240730151732.348219641@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 5f1fee9644759d07f3d3a468389c7c18027083d7 ]

If non-BSS and remain-on-channel (ROC) blocking were to occur
simultaneously, they'd step on each other's toes, unblocking
when not yet supported. Disentangle these bits, and ROC doesn't
need to use the non_bss_link() function then.

Fixes: a1efeb823084 ("wifi: iwlwifi: mvm: Block EMLSR when a p2p/softAP vif is active")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240605140556.461fcf7b95bb.Id0d21dcb739d426ff15ec068b5df8abaab58884d@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   | 10 +++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h        |  5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c |  5 +++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index dac6155ae1bd0..259afecd1a98d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4861,6 +4861,7 @@ int iwl_mvm_roc_common(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       const struct iwl_mvm_roc_ops *ops)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct ieee80211_vif *bss_vif = iwl_mvm_get_bss_vif(mvm);
 	u32 lmac_id;
 	int ret;
 
@@ -4873,9 +4874,12 @@ int iwl_mvm_roc_common(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	 */
 	flush_work(&mvm->roc_done_wk);
 
-	ret = iwl_mvm_esr_non_bss_link(mvm, vif, 0, true);
-	if (ret)
-		return ret;
+	if (!IS_ERR_OR_NULL(bss_vif)) {
+		ret = iwl_mvm_block_esr_sync(mvm, bss_vif,
+					     IWL_MVM_ESR_BLOCKED_ROC);
+		if (ret)
+			return ret;
+	}
 
 	mutex_lock(&mvm->mutex);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 0a1959bd40799..6837d8afb9877 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -360,7 +360,9 @@ struct iwl_mvm_vif_link_info {
  * @IWL_MVM_ESR_BLOCKED_WOWLAN: WOWLAN is preventing the enablement of EMLSR
  * @IWL_MVM_ESR_BLOCKED_TPT: block EMLSR when there is not enough traffic
  * @IWL_MVM_ESR_BLOCKED_FW: FW didn't recommended/forced exit from EMLSR
- * @IWL_MVM_ESR_BLOCKED_NON_BSS: An active non-bssid link's preventing EMLSR
+ * @IWL_MVM_ESR_BLOCKED_NON_BSS: An active non-BSS interface's link is
+ *	preventing EMLSR
+ * @IWL_MVM_ESR_BLOCKED_ROC: remain-on-channel is preventing EMLSR
  * @IWL_MVM_ESR_EXIT_MISSED_BEACON: exited EMLSR due to missed beacons
  * @IWL_MVM_ESR_EXIT_LOW_RSSI: link is deactivated/not allowed for EMLSR
  *	due to low RSSI.
@@ -377,6 +379,7 @@ enum iwl_mvm_esr_state {
 	IWL_MVM_ESR_BLOCKED_TPT		= 0x4,
 	IWL_MVM_ESR_BLOCKED_FW		= 0x8,
 	IWL_MVM_ESR_BLOCKED_NON_BSS	= 0x10,
+	IWL_MVM_ESR_BLOCKED_ROC		= 0x20,
 	IWL_MVM_ESR_EXIT_MISSED_BEACON	= 0x10000,
 	IWL_MVM_ESR_EXIT_LOW_RSSI	= 0x20000,
 	IWL_MVM_ESR_EXIT_COEX		= 0x40000,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 31bc80cdcb7d5..c0322349bfcd8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -47,6 +47,7 @@ void iwl_mvm_te_clear_data(struct iwl_mvm *mvm,
 
 static void iwl_mvm_cleanup_roc(struct iwl_mvm *mvm)
 {
+	struct ieee80211_vif *bss_vif = iwl_mvm_get_bss_vif(mvm);
 	struct ieee80211_vif *vif = mvm->p2p_device_vif;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -119,9 +120,9 @@ static void iwl_mvm_cleanup_roc(struct iwl_mvm *mvm)
 			iwl_mvm_rm_aux_sta(mvm);
 	}
 
+	if (vif && !IS_ERR_OR_NULL(bss_vif))
+		iwl_mvm_unblock_esr(mvm, bss_vif, IWL_MVM_ESR_BLOCKED_ROC);
 	mutex_unlock(&mvm->mutex);
-	if (vif)
-		iwl_mvm_esr_non_bss_link(mvm, vif, 0, false);
 }
 
 void iwl_mvm_roc_done_wk(struct work_struct *wk)
-- 
2.43.0



