Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2286330B2D;
	Thu, 28 May 2026 19:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998245; cv=none; b=NwnMRS9JJLFvGDxqg5GxQDTKPbnHBQo3/BN/rL7R2t+fkv6UfiwDcK4llma9j46/MoqscYg+n2xpE0nCXih8fTjn49Ui4nR1+Ylf19BL4qSZlDlGt+DnUnx9GNT88Z+hfszb/uh3SCI62KFIu5ud27XT1UB5hc2uamn1ltFfjxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998245; c=relaxed/simple;
	bh=fezpSpFrTtrFWwkL/dzTqFhgO0pO/NoxDT8wXh4yMM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djWS6w4VzSxvlaaztn9sJ7T8qF9jLxoFbuXLqIUzfZtrgyxqKaOa1oI1L47ANJJ1DPb9tz2RkcTNlRpAi3wJBnFlsJO9WA2MPfJMdxQ0q+HqN8JQeHpSjL3Ngxev5SKkDVSovsG79ECICTz0U6ennRWU85bkSkfzpYox9G2leyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Er85x5E/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Er85x5E/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7371F000E9;
	Thu, 28 May 2026 19:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998244;
	bh=b6p/8wUloJbNtQ3EzgobKrlwSn1IKMaR0B5v/JfXW3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Er85x5E/a5SiSivlHtbAnBYob3C9WuwZ2MJYfPLpdAbvwaxq/iCVE+CbqEFs4fP8q
	 /kU+aXdrg/pahgCQJk7JzlbXadlidUdqbIEFP6BwzOFi0YWfcY10kzTvbjVlbtvaut
	 5NJekimntZMkGMhXHNuUcHltqGEl89wPmQnd5z7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 7.0 078/461] wifi: iwlwifi: mvm: fix driver-set TX rates on old devices
Date: Thu, 28 May 2026 21:43:27 +0200
Message-ID: <20260528194649.176988689@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit fb84b5cbcaab3ca0f4e961d92a40ed7f3aac483b upstream.

On old devices such as 7265D, rates are still encoded in version 1
format, which doesn't use the CCK/OFDM rate index (0-3/0-7) but
rather their PLCP value (e.g. 10 for 1 Mbps CCK rate.)

While introducing v3 rates, I changed the driver from internally
handling v1 rates and converting to v2, to internally handling v3
and converting to v1 or v2 according to the firmware. I accordingly
changed the code in iwl_mvm_mac80211_idx_to_hwrate() to no longer
have different values for different APIs. This was correct.

However, I later reverted this part of the change, because it was
reported that I had broken beacon rates, causing a FW assert/crash.
This caused TX_CMD rates to be set incorrectly, potentially causing
a warning when reported back from the device as having been used.

Fix this (hopefully correctly now) by handling beacon rates in the
TX_CMD that's embedded in the beacon template command separately.
Restore iwl_mvm_mac80211_idx_to_hwrate() to return only the rate
index, not PLCP value, fixing the real TX_CMD.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20260515151351.7407e293dff7.I4ea1a17f8fe99c933d3f3e30d077cf4246125c3e@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |   27 ++++++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    |   14 +++--------
 2 files changed, 22 insertions(+), 19 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2014 Intel Mobile Communications GmbH
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
  */
@@ -927,13 +927,18 @@ u8 iwl_mvm_mac_ctxt_get_lowest_rate(stru
 
 u16 iwl_mvm_mac_ctxt_get_beacon_flags(const struct iwl_fw *fw, u8 rate_idx)
 {
-	u16 flags = iwl_mvm_mac80211_idx_to_hwrate(fw, rate_idx);
 	bool is_new_rate = iwl_fw_lookup_cmd_ver(fw, BEACON_TEMPLATE_CMD, 0) > 10;
+	u16 flags = 0;
 
 	if (rate_idx <= IWL_LAST_CCK_RATE)
 		flags |= is_new_rate ? IWL_MAC_BEACON_CCK
 			  : IWL_MAC_BEACON_CCK_V1;
 
+	if (iwl_fw_lookup_cmd_ver(fw, TX_CMD, 0) > 8)
+		flags |= iwl_mvm_mac80211_idx_to_hwrate(fw, rate_idx);
+	else
+		flags |= iwl_fw_rate_idx_to_plcp(rate_idx);
+
 	return flags;
 }
 
@@ -962,6 +967,7 @@ static void iwl_mvm_mac_ctxt_set_tx(stru
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct ieee80211_tx_info *info;
+	u32 rate_n_flags = 0;
 	u8 rate;
 	u32 tx_flags;
 
@@ -981,18 +987,21 @@ static void iwl_mvm_mac_ctxt_set_tx(stru
 			 IWL_UCODE_TLV_CAPA_BEACON_ANT_SELECTION)) {
 		iwl_mvm_toggle_tx_ant(mvm, &mvm->mgmt_last_antenna_idx);
 
-		tx_params->rate_n_flags =
-			cpu_to_le32(BIT(mvm->mgmt_last_antenna_idx) <<
-				    RATE_MCS_ANT_POS);
+		rate_n_flags |= BIT(mvm->mgmt_last_antenna_idx) <<
+					RATE_MCS_ANT_POS;
 	}
 
 	rate = iwl_mvm_mac_ctxt_get_beacon_rate(mvm, info, vif);
 
-	tx_params->rate_n_flags |=
-		cpu_to_le32(iwl_mvm_mac80211_idx_to_hwrate(mvm->fw, rate));
-	if (rate == IWL_FIRST_CCK_RATE)
-		tx_params->rate_n_flags |= cpu_to_le32(RATE_MCS_CCK_MSK_V1);
+	if (rate < IWL_FIRST_OFDM_RATE)
+		rate_n_flags |= RATE_MCS_MOD_TYPE_CCK;
+	else
+		rate_n_flags |= RATE_MCS_MOD_TYPE_LEGACY_OFDM;
+
+	rate_n_flags |= iwl_mvm_mac80211_idx_to_hwrate(mvm->fw, rate);
 
+	tx_params->rate_n_flags = iwl_mvm_v3_rate_to_fw(rate_n_flags,
+							mvm->fw_rates_ver);
 }
 
 int iwl_mvm_mac_ctxt_send_beacon_cmd(struct iwl_mvm *mvm,
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2014 Intel Mobile Communications GmbH
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
  */
@@ -159,15 +159,9 @@ int iwl_mvm_legacy_rate_to_mac80211_idx(
 
 u8 iwl_mvm_mac80211_idx_to_hwrate(const struct iwl_fw *fw, int rate_idx)
 {
-	if (iwl_fw_lookup_cmd_ver(fw, TX_CMD, 0) > 8)
-		/* In the new rate legacy rates are indexed:
-		 * 0 - 3 for CCK and 0 - 7 for OFDM.
-		 */
-		return (rate_idx >= IWL_FIRST_OFDM_RATE ?
-			rate_idx - IWL_FIRST_OFDM_RATE :
-			rate_idx);
-
-	return iwl_fw_rate_idx_to_plcp(rate_idx);
+	return rate_idx >= IWL_FIRST_OFDM_RATE ?
+		rate_idx - IWL_FIRST_OFDM_RATE :
+		rate_idx;
 }
 
 u8 iwl_mvm_mac80211_ac_to_ucode_ac(enum ieee80211_ac_numbers ac)


