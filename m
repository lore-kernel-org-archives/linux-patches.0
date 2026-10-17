Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AA122F767;
	Sat, 17 Oct 2026 17:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258070; cv=none; b=JDkq73dVIBUEw1QoLYtZfq58i46GUtcs6mSS9C9AND3Cj7R6CRjjGZS3z+BqwsETDzGp934Jpq2BYU35AcbYE9fVrUU/5fwZxdSaLgbLHib405JFQd1aZXEv7437dDBl27ed5WBogqnngvdO0I+oHhXtzHipAoaueDG5OP5f4cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258070; c=relaxed/simple;
	bh=BqzR6rLFAGxNecOVT3AAXTbRXCj/BjIzmm/RFnCbGWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPzTs6eXPLnXc3lvId/TEnXENEiSsYBYjL5AkJw7lfZPHQxaa4uCIB2nmyA4B2eI9rbaFWV0oAMxQMngNx3BPkd1tBAAyMPYNTyif0PipLVM5Bf7TumFCIGx7mJCYTe94Bec3biddMTMJoY7odHgyJEGhdMt69lHzep7QxnRUGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2XOMhK7P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2XOMhK7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67321F000C4;
	Sat, 17 Oct 2026 17:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258069;
	bh=cNwKZGtlug7+Ik/ubgsATqALTZIkyLloUZi/Jjv5gic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2XOMhK7PPSgIfCPtwg3GnNkrpbu3Tb/EIgr/CBEhVIlwZlsAiuM361JbvmAoVFTyX
	 h1zId5NGROJ+FBHB8b7eo+TDFyF6dVsQUXQqBySZQniULb8QeKQE466lnac80+ikNh
	 fQcLFQTnTdTNxWiM5IhELljdPuAqbuIpmzC3faAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0763/1674] wifi: iwlwifi: return ERR_PTR from opmode start()
Date: Sat, 17 Oct 2026 17:50:35 +0200
Message-ID: <20261017160450.684431422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8b0fc79f9e5b49a1ab27b53edc64d9ffbceeb312 ]

In order to restrict the retry loops for timeouts, first
pass the error code up using ERR_PTR(). This of course
requires all existing functions to be updated accordingly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241227095718.3fe5031d5784.I7307996c91dac69619ff9c616b8a077423fac19f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: cf80c02a9fdb ("wifi: iwlwifi: Fix error code in iwl_op_mode_dvm_start()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 34 ++++++++++++-------
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  | 24 +++++++++----
 3 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index b490a88b97ca7..1d6b4a0313a45 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1245,7 +1245,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		STATISTICS_NOTIFICATION,
 		REPLY_TX,
 	};
-	int i;
+	int i, err;
 
 	/************************
 	 * 1. Allocating HW data
@@ -1253,6 +1253,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	hw = iwl_alloc_all();
 	if (!hw) {
 		pr_err("%s: Cannot allocate network device\n", trans->name);
+		err = -ENOMEM;
 		goto out;
 	}
 
@@ -1303,8 +1304,10 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		break;
 	}
 
-	if (WARN_ON(!priv->lib))
+	if (WARN_ON(!priv->lib)) {
+		err = -ENODEV;
 		goto out_free_hw;
+	}
 
 	/*
 	 * Populate the state variables that the transport layer needs
@@ -1383,12 +1386,14 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	IWL_INFO(priv, "Detected %s, REV=0x%X\n",
 		priv->trans->name, priv->trans->hw_rev);
 
-	if (iwl_trans_start_hw(priv->trans))
+	err = iwl_trans_start_hw(priv->trans);
+	if (err)
 		goto out_free_hw;
 
 	/* Read the EEPROM */
-	if (iwl_read_eeprom(priv->trans, &priv->eeprom_blob,
-			    &priv->eeprom_blob_size)) {
+	err = iwl_read_eeprom(priv->trans, &priv->eeprom_blob,
+			      &priv->eeprom_blob_size);
+	if (err) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
 		goto out_free_hw;
 	}
@@ -1399,13 +1404,17 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	priv->nvm_data = iwl_parse_eeprom_data(priv->trans, priv->cfg,
 					       priv->eeprom_blob,
 					       priv->eeprom_blob_size);
-	if (!priv->nvm_data)
+	if (!priv->nvm_data) {
+		err = -ENOMEM;
 		goto out_free_eeprom_blob;
+	}
 
-	if (iwl_nvm_check_version(priv->nvm_data, priv->trans))
+	err = iwl_nvm_check_version(priv->nvm_data, priv->trans);
+	if (err)
 		goto out_free_eeprom;
 
-	if (iwl_eeprom_init_hw_params(priv))
+	err = iwl_eeprom_init_hw_params(priv);
+	if (err)
 		goto out_free_eeprom;
 
 	/* extract MAC Address */
@@ -1452,7 +1461,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		atomic_set(&priv->queue_stop_count[i], 0);
 	}
 
-	if (iwl_init_drv(priv))
+	err = iwl_init_drv(priv);
+	if (err)
 		goto out_free_eeprom;
 
 	/* At this point both hw and priv are initialized. */
@@ -1488,7 +1498,8 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	 *
 	 * 7. Setup and register with mac80211 and debugfs
 	 **************************************************/
-	if (iwlagn_mac_setup_register(priv, &fw->ucode_capa))
+	err = iwlagn_mac_setup_register(priv, &fw->ucode_capa);
+	if (err)
 		goto out_destroy_workqueue;
 
 	iwl_dbgfs_register(priv, dbgfs_dir);
@@ -1509,8 +1520,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 out_free_hw:
 	ieee80211_free_hw(priv->hw);
 out:
-	op_mode = NULL;
-	return op_mode;
+	return ERR_PTR(err);
 }
 
 static void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 36e8d0e8c91bb..5c5a664dddc69 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1438,7 +1438,7 @@ _iwl_op_mode_start(struct iwl_drv *drv, struct iwlwifi_opmode_table *op)
 		op_mode = ops->start(drv->trans, drv->trans->cfg,
 				     &drv->fw, dbgfs_dir);
 
-		if (op_mode)
+		if (!IS_ERR(op_mode))
 			return op_mode;
 
 		IWL_ERR(drv, "retry init count %d\n", retry);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 7ed684d638bd7..431f97c5aedc5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1112,6 +1112,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	size_t scan_size;
 	u32 min_backoff;
 	struct iwl_mvm_csme_conn_info *csme_conn_info __maybe_unused;
+	int err;
 
 	/*
 	 * We use IWL_MVM_STATION_COUNT_MAX to check the validity of the station
@@ -1129,7 +1130,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 				iwl_mvm_has_mld_api(fw) ? &iwl_mvm_mld_hw_ops :
 				&iwl_mvm_hw_ops);
 	if (!hw)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_BZ)
 		max_agg = IEEE80211_MAX_AMPDU_BUF_EHT;
@@ -1173,8 +1174,10 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		trans->rx_mpdu_cmd_hdr_size =
 			sizeof(struct iwl_rx_mpdu_res_start);
 
-		if (WARN_ON(trans->num_rx_queues > 1))
+		if (WARN_ON(trans->num_rx_queues > 1)) {
+			err = -EINVAL;
 			goto out_free;
+		}
 	}
 
 	mvm->fw_restart = iwlwifi_mod_params.fw_restart ? -1 : 0;
@@ -1244,8 +1247,10 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		iwl_fw_lookup_notif_ver(mvm->fw, LOCATION_GROUP,
 					TOF_RANGE_RESPONSE_NOTIF, 5);
 	/* we only support up to version 9 */
-	if (WARN_ON_ONCE(mvm->cmd_ver.range_resp > 9))
+	if (WARN_ON_ONCE(mvm->cmd_ver.range_resp > 9)) {
+		err = -EINVAL;
 		goto out_free;
+	}
 
 	/*
 	 * Populate the state variables that the transport layer needs
@@ -1329,6 +1334,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	mvm->phy_db = iwl_phy_db_init(trans);
 	if (!mvm->phy_db) {
 		IWL_ERR(mvm, "Cannot init phy_db\n");
+		err = -ENOMEM;
 		goto out_free;
 	}
 
@@ -1344,8 +1350,10 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	scan_size = iwl_mvm_scan_size(mvm);
 
 	mvm->scan_cmd = kmalloc(scan_size, GFP_KERNEL);
-	if (!mvm->scan_cmd)
+	if (!mvm->scan_cmd) {
+		err = -ENOMEM;
 		goto out_free;
+	}
 	mvm->scan_cmd_size = scan_size;
 
 	/* invalidate ids to prevent accidental removal of sta_id 0 */
@@ -1374,7 +1382,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	iwl_mvm_mei_scan_filter_init(&mvm->mei_scan_filter);
 
-	if (iwl_mvm_start_get_nvm(mvm)) {
+	err = iwl_mvm_start_get_nvm(mvm);
+	if (err) {
 		/*
 		 * Getting NVM failed while CSME is the owner, but we are
 		 * registered to MEI, we'll get the NVM later when it'll be
@@ -1387,7 +1396,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	}
 
 
-	if (iwl_mvm_start_post_nvm(mvm))
+	err = iwl_mvm_start_post_nvm(mvm);
+	if (err)
 		goto out_thermal_exit;
 
 	return op_mode;
@@ -1409,7 +1419,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	iwl_trans_op_mode_leave(trans);
 
 	ieee80211_free_hw(mvm->hw);
-	return NULL;
+	return ERR_PTR(err);
 }
 
 void iwl_mvm_stop_device(struct iwl_mvm *mvm)
-- 
2.53.0



