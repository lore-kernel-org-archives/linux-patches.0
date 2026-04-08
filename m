Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7ED3537EF;
	Wed,  8 Apr 2026 18:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672894; cv=none; b=CG5aEGQ86Gc0GgAq8E43qOmzJ6bljIoVolwG1wE+dOqDZabRqChSV0OI6BW+qGsGjvvy9vc7MtET35mLGNxSyxqVDVccj9vJn2dhd2TIiiptfXaSPvCZ9UuIccrGfCvPmD3uJ2TeIyGua1V/6P0wSSk+whOmGfK0/JRa6jkLslM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672894; c=relaxed/simple;
	bh=ec2pFFwCWXF4x9JkTDwZmofrlRye0slkuScxeB/0s30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8Nc/n1qTRgsUClLxe+fDlesW2XUChz9rZq1RJ2k8cjD6I0yIVmCMBYLFrd5f2MkAMhE6vBgZgfC719vpI7R/bOxV9ioPZB7Bp1rzlegGq2NgXPNPtJvrdtY61JO9fdfIoDniKzOF8R4tqgoPjNiveqJX5MtMtMq+p3uuba1D30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALLfgIcB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALLfgIcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E2CC19421;
	Wed,  8 Apr 2026 18:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672894;
	bh=ec2pFFwCWXF4x9JkTDwZmofrlRye0slkuScxeB/0s30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALLfgIcBAJg4OqNYd5U49PBuXhNSTGAJkfwUwLO8w9f/R87cPy27seclOHg20Z9ts
	 ygH2zanJjtZZXKbHQ0kn46rXSmaB1NHd0lLmPtkLkDC7O5I7A1ZKC+dSPaJK4vjeGB
	 tD11ewjhvn/cBxIMCwWIEkHkeeL2EBX6nRMPnG3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/277] wifi: iwlwifi: disable EHT if the device doesnt allow it
Date: Wed,  8 Apr 2026 20:00:07 +0200
Message-ID: <20260408175934.681820162@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 7ed47d42943fba8ced505f62d4358f63963bb968 ]

We have a few devices that don't allow EHT. Make sure we reflect this
towards mac80211 so that we won't try to enable it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251019114304.71121f4e5557.I49e2329d4121f9e52d0889156d0c3e8778e27d88@changeid
Stable-dep-of: 687a95d204e7 ("wifi: iwlwifi: mld: correctly set wifi generation data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/cfg/rf-fm.c    |  1 +
 .../net/wireless/intel/iwlwifi/cfg/rf-wh.c    | 23 +++++++++++++++++++
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  5 +++-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c |  6 +++--
 5 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/rf-fm.c b/drivers/net/wireless/intel/iwlwifi/cfg/rf-fm.c
index 456a666c8dfdf..fd82050e33a3c 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/rf-fm.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/rf-fm.c
@@ -19,6 +19,7 @@
 	.non_shared_ant = ANT_B,					\
 	.vht_mu_mimo_supported = true,					\
 	.uhb_supported = true,						\
+	.eht_supported = true,						\
 	.num_rbds = IWL_NUM_RBDS_EHT,					\
 	.nvm_ver = IWL_FM_NVM_VERSION,					\
 	.nvm_type = IWL_NVM_EXT
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/rf-wh.c b/drivers/net/wireless/intel/iwlwifi/cfg/rf-wh.c
index b8c6b06e70991..b5803ea1eb782 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/rf-wh.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/rf-wh.c
@@ -4,8 +4,31 @@
  */
 #include "iwl-config.h"
 
+/* NVM versions */
+#define IWL_WH_NVM_VERSION		0x0a1d
+
+#define IWL_DEVICE_WH							\
+	.ht_params = {							\
+		.stbc = true,						\
+		.ldpc = true,						\
+		.ht40_bands = BIT(NL80211_BAND_2GHZ) |			\
+			      BIT(NL80211_BAND_5GHZ),			\
+	},								\
+	.led_mode = IWL_LED_RF_STATE,					\
+	.non_shared_ant = ANT_B,					\
+	.vht_mu_mimo_supported = true,					\
+	.uhb_supported = true,						\
+	.num_rbds = IWL_NUM_RBDS_EHT,					\
+	.nvm_ver = IWL_WH_NVM_VERSION,					\
+	.nvm_type = IWL_NVM_EXT
+
 /* currently iwl_rf_wh/iwl_rf_wh_160mhz are just defines for the FM ones */
 
+const struct iwl_rf_cfg iwl_rf_wh_non_eht = {
+	IWL_DEVICE_WH,
+	.eht_supported = false,
+};
+
 const char iwl_killer_be1775s_name[] =
 	"Killer(R) Wi-Fi 7 BE1775s 320MHz Wireless Network Adapter (BE211D2W)";
 const char iwl_killer_be1775i_name[] =
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 0b34c9f90b3ff..3b4f990a8d0bb 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -418,6 +418,7 @@ struct iwl_mac_cfg {
  * @vht_mu_mimo_supported: VHT MU-MIMO support
  * @nvm_type: see &enum iwl_nvm_type
  * @uhb_supported: ultra high band channels supported
+ * @eht_supported: EHT supported
  * @num_rbds: number of receive buffer descriptors to use
  *	(only used for multi-queue capable devices)
  *
@@ -450,7 +451,8 @@ struct iwl_rf_cfg {
 	    host_interrupt_operation_mode:1,
 	    lp_xtal_workaround:1,
 	    vht_mu_mimo_supported:1,
-	    uhb_supported:1;
+	    uhb_supported:1,
+	    eht_supported:1;
 	u8 valid_tx_ant;
 	u8 valid_rx_ant;
 	u8 non_shared_ant;
@@ -744,6 +746,7 @@ extern const struct iwl_rf_cfg iwl_rf_fm;
 extern const struct iwl_rf_cfg iwl_rf_fm_160mhz;
 #define iwl_rf_wh iwl_rf_fm
 #define iwl_rf_wh_160mhz iwl_rf_fm_160mhz
+extern const struct iwl_rf_cfg iwl_rf_wh_non_eht;
 #define iwl_rf_pe iwl_rf_fm
 #endif /* CONFIG_IWLMLD */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 23465e4c4b399..e021fc57d85d2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -2080,7 +2080,7 @@ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
 		!!(mac_flags & NVM_MAC_SKU_FLAGS_BAND_5_2_ENABLED);
 	nvm->sku_cap_mimo_disabled =
 		!!(mac_flags & NVM_MAC_SKU_FLAGS_MIMO_DISABLED);
-	if (CSR_HW_RFID_TYPE(trans->info.hw_rf_id) >= IWL_CFG_RF_TYPE_FM)
+	if (trans->cfg->eht_supported)
 		nvm->sku_cap_11be_enable = true;
 
 	/* Initialize PHY sku data */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index de04a84def0d8..73001cdce13aa 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1061,8 +1061,10 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct iwl_dev_info iwl_dev_info_table[] = {
 
 /* WH RF */
 	IWL_DEV_INFO(iwl_rf_wh, iwl_be211_name, RF_TYPE(WH)),
-	IWL_DEV_INFO(iwl_rf_wh, iwl_ax221_name, RF_TYPE(WH), SUBDEV(0x0514)),
-	IWL_DEV_INFO(iwl_rf_wh, iwl_ax221_name, RF_TYPE(WH), SUBDEV(0x4514)),
+	IWL_DEV_INFO(iwl_rf_wh_non_eht, iwl_ax221_name, RF_TYPE(WH),
+		     SUBDEV(0x0514)),
+	IWL_DEV_INFO(iwl_rf_wh_non_eht, iwl_ax221_name, RF_TYPE(WH),
+		     SUBDEV(0x4514)),
 	IWL_DEV_INFO(iwl_rf_wh_160mhz, iwl_be213_name, RF_TYPE(WH), BW_LIMITED),
 
 /* PE RF */
-- 
2.53.0



