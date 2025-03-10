Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F53F1E519;
	Mon, 10 Mar 2025 17:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626703; cv=none; b=hGzMLkatHJKFKd4F5eQzrRu9yvg1WPgmVmeFmX8AwJ2ufQpYOGhIhBM5SYJxa1uhuTFkDhG3FnpyxEG2pbkQL1bDW8OmRY/1KiG5D+8ko4Ajm8kklLxIYKJMbtd5M3ml/HxpdJa7sR4olNmJjav5LDfyhSKFjtf4oTSyp/SUPK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626703; c=relaxed/simple;
	bh=r23OKe9QBJB4s1mtyI13dV3lR65TfCgp2I950HyaXPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXUQ+H3PPWgzPxFXqHoxla5UA6+dlc1DBMaJ/6do3xEIj+KiGWoFojEw9jn17sFXu2Q3RerD7LKWI4u1wZWQSihvt3b+SwmsNod1q7Za8kKJi+pvgQ0DDnkY2hICj8j/jmn+gNMjhNx/DPnoEExn9AvMOwTlrQ78FiICeEIabAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CqgqeeTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqgqeeTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72AAC4CEF1;
	Mon, 10 Mar 2025 17:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626703;
	bh=r23OKe9QBJB4s1mtyI13dV3lR65TfCgp2I950HyaXPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CqgqeeTQx0ZjX9YuWiQV5VtZqK8hVmeOuYunvJaZZb145gyisvic6WMkXrG2BFoYy
	 LmFdrdnzdorlJ4jrSi5XSIvHaoLgxMIpQ0EPJC02G781DTHslmhUYhlrTPu1jgJof3
	 u+z57hDZM/ZKZ94iDaHj6LgpR9FXptLcg5faO3Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 084/207] wifi: iwlwifi: mvm: dont dump the firmware state upon RFKILL while suspend
Date: Mon, 10 Mar 2025 18:04:37 +0100
Message-ID: <20250310170451.101987573@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit d48ff3ce92259bae7e77732c7cfd7cbc7992c021 ]

This is not really a firmware error. We need to reload the firmware, but
this doesn't mean that we should consider this as a firmware error.
When the firmware was restarted upon resume, this wasn't felt by the
driver. Now that we keep the firmware running during suspend even if we
don't have wowlan, this started to pop-up.

Fixes: e8bb19c1d590 ("wifi: iwlwifi: support fast resume")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250209143303.a10463a40318.I14131781c3124b58e60e1f5e9d793a2bc88b464c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 77 ++++++++++++++-------
 1 file changed, 51 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 33794780d5c9e..5797d28b6a0d1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -3099,8 +3099,14 @@ static void iwl_mvm_d3_disconnect_iter(void *data, u8 *mac,
 		ieee80211_resume_disconnect(vif);
 }
 
-static bool iwl_mvm_check_rt_status(struct iwl_mvm *mvm,
-				   struct ieee80211_vif *vif)
+enum rt_status {
+	FW_ALIVE,
+	FW_NEEDS_RESET,
+	FW_ERROR,
+};
+
+static enum rt_status iwl_mvm_check_rt_status(struct iwl_mvm *mvm,
+					      struct ieee80211_vif *vif)
 {
 	u32 err_id;
 
@@ -3108,29 +3114,35 @@ static bool iwl_mvm_check_rt_status(struct iwl_mvm *mvm,
 	if (iwl_fwrt_read_err_table(mvm->trans,
 				    mvm->trans->dbg.lmac_error_event_table[0],
 				    &err_id)) {
-		if (err_id == RF_KILL_INDICATOR_FOR_WOWLAN && vif) {
-			struct cfg80211_wowlan_wakeup wakeup = {
-				.rfkill_release = true,
-			};
-			ieee80211_report_wowlan_wakeup(vif, &wakeup,
-						       GFP_KERNEL);
+		if (err_id == RF_KILL_INDICATOR_FOR_WOWLAN) {
+			IWL_WARN(mvm, "Rfkill was toggled during suspend\n");
+			if (vif) {
+				struct cfg80211_wowlan_wakeup wakeup = {
+					.rfkill_release = true,
+				};
+
+				ieee80211_report_wowlan_wakeup(vif, &wakeup,
+							       GFP_KERNEL);
+			}
+
+			return FW_NEEDS_RESET;
 		}
-		return true;
+		return FW_ERROR;
 	}
 
 	/* check if we have lmac2 set and check for error */
 	if (iwl_fwrt_read_err_table(mvm->trans,
 				    mvm->trans->dbg.lmac_error_event_table[1],
 				    NULL))
-		return true;
+		return FW_ERROR;
 
 	/* check for umac error */
 	if (iwl_fwrt_read_err_table(mvm->trans,
 				    mvm->trans->dbg.umac_error_event_table,
 				    NULL))
-		return true;
+		return FW_ERROR;
 
-	return false;
+	return FW_ALIVE;
 }
 
 /*
@@ -3499,6 +3511,7 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 	bool d0i3_first = fw_has_capa(&mvm->fw->ucode_capa,
 				      IWL_UCODE_TLV_CAPA_D0I3_END_FIRST);
 	bool resume_notif_based = iwl_mvm_d3_resume_notif_based(mvm);
+	enum rt_status rt_status;
 	bool keep = false;
 
 	mutex_lock(&mvm->mutex);
@@ -3522,14 +3535,19 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 
 	iwl_fw_dbg_read_d3_debug_data(&mvm->fwrt);
 
-	if (iwl_mvm_check_rt_status(mvm, vif)) {
-		IWL_ERR(mvm, "FW Error occurred during suspend. Restarting.\n");
+	rt_status = iwl_mvm_check_rt_status(mvm, vif);
+	if (rt_status != FW_ALIVE) {
 		set_bit(STATUS_FW_ERROR, &mvm->trans->status);
-		iwl_mvm_dump_nic_error_log(mvm);
-		iwl_dbg_tlv_time_point(&mvm->fwrt,
-				       IWL_FW_INI_TIME_POINT_FW_ASSERT, NULL);
-		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
-					false, 0);
+		if (rt_status == FW_ERROR) {
+			IWL_ERR(mvm, "FW Error occurred during suspend. Restarting.\n");
+			iwl_mvm_dump_nic_error_log(mvm);
+			iwl_dbg_tlv_time_point(&mvm->fwrt,
+					       IWL_FW_INI_TIME_POINT_FW_ASSERT,
+					       NULL);
+			iwl_fw_dbg_collect_desc(&mvm->fwrt,
+						&iwl_dump_desc_assert,
+						false, 0);
+		}
 		ret = 1;
 		goto err;
 	}
@@ -3686,6 +3704,7 @@ int iwl_mvm_fast_resume(struct iwl_mvm *mvm)
 		.notif_expected =
 			IWL_D3_NOTIF_D3_END_NOTIF,
 	};
+	enum rt_status rt_status;
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -3695,14 +3714,20 @@ int iwl_mvm_fast_resume(struct iwl_mvm *mvm)
 	mvm->last_reset_or_resume_time_jiffies = jiffies;
 	iwl_fw_dbg_read_d3_debug_data(&mvm->fwrt);
 
-	if (iwl_mvm_check_rt_status(mvm, NULL)) {
-		IWL_ERR(mvm, "FW Error occurred during suspend. Restarting.\n");
+	rt_status = iwl_mvm_check_rt_status(mvm, NULL);
+	if (rt_status != FW_ALIVE) {
 		set_bit(STATUS_FW_ERROR, &mvm->trans->status);
-		iwl_mvm_dump_nic_error_log(mvm);
-		iwl_dbg_tlv_time_point(&mvm->fwrt,
-				       IWL_FW_INI_TIME_POINT_FW_ASSERT, NULL);
-		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
-					false, 0);
+		if (rt_status == FW_ERROR) {
+			IWL_ERR(mvm,
+				"iwl_mvm_check_rt_status failed, device is gone during suspend\n");
+			iwl_mvm_dump_nic_error_log(mvm);
+			iwl_dbg_tlv_time_point(&mvm->fwrt,
+					       IWL_FW_INI_TIME_POINT_FW_ASSERT,
+					       NULL);
+			iwl_fw_dbg_collect_desc(&mvm->fwrt,
+						&iwl_dump_desc_assert,
+						false, 0);
+		}
 		mvm->trans->state = IWL_TRANS_NO_FW;
 		ret = -ENODEV;
 
-- 
2.39.5



