Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6425B15703F;
	Mon, 29 Jan 2024 17:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548144; cv=none; b=By0RzfBjj+Qbd5gZzTBp630klI30J9id+CG+oc1Kl1MU7Artl8w41Qeax9WwIOITz4hjHgzJuSZGMY165XL7Zq+oaDWxaG/8qlYnKk5Asgf/QdhXi+fIw5Z6edkxoDghKp54Of/TTkQejJi2g9XgM0qjj16yV/o+sVxAa7QzR50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548144; c=relaxed/simple;
	bh=qPK9Ei02pTIg+Kb62C4r3OaargjWrv/nPgbJL1mcCkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMmgb/GGQ0UVpAAi988Rg2lnDR6rSiXLZniL69eVsiP1i07QQMyuFeo0LpJDnW02Tzcr7vf7TCjr/wsSxjj4gKqb3zWwazPOUkraG6ZaIVpeVrPwbftjtnXBT8CtF2VlEtSeK0tDLBR0Zc9ahmv73E6S9H+2sBOepj54qiuZkGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZEsOnSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZEsOnSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA17C433F1;
	Mon, 29 Jan 2024 17:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548144;
	bh=qPK9Ei02pTIg+Kb62C4r3OaargjWrv/nPgbJL1mcCkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZEsOnSZWkuQPD/bKQR7Z9+zE+0tx/f/zWS4dFmTYpKCKqGZbWYsXa44h2DfXY+K/
	 vQb7OJ2LWRcbPpHvcve4JK/Pz1qQOW2AvFEHjquFGF/ZbuXhbl9YW8/rN4nsE79iLZ
	 TQ67xJAPv/OF59+QsL31ggYw6txv+UfpVki9NjC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.7 139/346] wifi: ath11k: rely on mac80211 debugfs handling for vif
Date: Mon, 29 Jan 2024 09:02:50 -0800
Message-ID: <20240129170020.481869622@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

commit 556857aa1d0855aba02b1c63bc52b91ec63fc2cc upstream.

mac80211 started to delete debugfs entries in certain cases, causing a
ath11k to crash when it tried to delete the entries later. Fix this by
relying on mac80211 to delete the entries when appropriate and adding
them from the vif_add_debugfs handler.

Fixes: 0a3d898ee9a8 ("wifi: mac80211: add/remove driver debugfs entries as appropriate")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218364
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240115101805.1277949-1-benjamin@sipsolutions.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/core.h    |    4 ----
 drivers/net/wireless/ath/ath11k/debugfs.c |   25 ++++++++++---------------
 drivers/net/wireless/ath/ath11k/debugfs.h |   12 ++----------
 drivers/net/wireless/ath/ath11k/mac.c     |   12 +-----------
 4 files changed, 13 insertions(+), 40 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -368,10 +368,6 @@ struct ath11k_vif {
 	struct ieee80211_chanctx_conf chanctx;
 	struct ath11k_arp_ns_offload arp_ns_offload;
 	struct ath11k_rekey_data rekey_data;
-
-#ifdef CONFIG_ATH11K_DEBUGFS
-	struct dentry *debugfs_twt;
-#endif /* CONFIG_ATH11K_DEBUGFS */
 };
 
 struct ath11k_vif_iter {
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -1893,35 +1893,30 @@ static const struct file_operations ath1
 	.open = simple_open
 };
 
-void ath11k_debugfs_add_interface(struct ath11k_vif *arvif)
+void ath11k_debugfs_op_vif_add(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif)
 {
+	struct ath11k_vif *arvif = ath11k_vif_to_arvif(vif);
 	struct ath11k_base *ab = arvif->ar->ab;
+	struct dentry *debugfs_twt;
 
 	if (arvif->vif->type != NL80211_IFTYPE_AP &&
 	    !(arvif->vif->type == NL80211_IFTYPE_STATION &&
 	      test_bit(WMI_TLV_SERVICE_STA_TWT, ab->wmi_ab.svc_map)))
 		return;
 
-	arvif->debugfs_twt = debugfs_create_dir("twt",
-						arvif->vif->debugfs_dir);
-	debugfs_create_file("add_dialog", 0200, arvif->debugfs_twt,
+	debugfs_twt = debugfs_create_dir("twt",
+					 arvif->vif->debugfs_dir);
+	debugfs_create_file("add_dialog", 0200, debugfs_twt,
 			    arvif, &ath11k_fops_twt_add_dialog);
 
-	debugfs_create_file("del_dialog", 0200, arvif->debugfs_twt,
+	debugfs_create_file("del_dialog", 0200, debugfs_twt,
 			    arvif, &ath11k_fops_twt_del_dialog);
 
-	debugfs_create_file("pause_dialog", 0200, arvif->debugfs_twt,
+	debugfs_create_file("pause_dialog", 0200, debugfs_twt,
 			    arvif, &ath11k_fops_twt_pause_dialog);
 
-	debugfs_create_file("resume_dialog", 0200, arvif->debugfs_twt,
+	debugfs_create_file("resume_dialog", 0200, debugfs_twt,
 			    arvif, &ath11k_fops_twt_resume_dialog);
 }
 
-void ath11k_debugfs_remove_interface(struct ath11k_vif *arvif)
-{
-	if (!arvif->debugfs_twt)
-		return;
-
-	debugfs_remove_recursive(arvif->debugfs_twt);
-	arvif->debugfs_twt = NULL;
-}
--- a/drivers/net/wireless/ath/ath11k/debugfs.h
+++ b/drivers/net/wireless/ath/ath11k/debugfs.h
@@ -306,8 +306,8 @@ static inline int ath11k_debugfs_rx_filt
 	return ar->debug.rx_filter;
 }
 
-void ath11k_debugfs_add_interface(struct ath11k_vif *arvif);
-void ath11k_debugfs_remove_interface(struct ath11k_vif *arvif);
+void ath11k_debugfs_op_vif_add(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif);
 void ath11k_debugfs_add_dbring_entry(struct ath11k *ar,
 				     enum wmi_direct_buffer_module id,
 				     enum ath11k_dbg_dbr_event event,
@@ -386,14 +386,6 @@ static inline int ath11k_debugfs_get_fw_
 	return 0;
 }
 
-static inline void ath11k_debugfs_add_interface(struct ath11k_vif *arvif)
-{
-}
-
-static inline void ath11k_debugfs_remove_interface(struct ath11k_vif *arvif)
-{
-}
-
 static inline void
 ath11k_debugfs_add_dbring_entry(struct ath11k *ar,
 				enum wmi_direct_buffer_module id,
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6750,13 +6750,6 @@ static int ath11k_mac_op_add_interface(s
 		goto err;
 	}
 
-	/* In the case of hardware recovery, debugfs files are
-	 * not deleted since ieee80211_ops.remove_interface() is
-	 * not invoked. In such cases, try to delete the files.
-	 * These will be re-created later.
-	 */
-	ath11k_debugfs_remove_interface(arvif);
-
 	memset(arvif, 0, sizeof(*arvif));
 
 	arvif->ar = ar;
@@ -6933,8 +6926,6 @@ static int ath11k_mac_op_add_interface(s
 
 	ath11k_dp_vdev_tx_attach(ar, arvif);
 
-	ath11k_debugfs_add_interface(arvif);
-
 	if (vif->type != NL80211_IFTYPE_MONITOR &&
 	    test_bit(ATH11K_FLAG_MONITOR_CONF_ENABLED, &ar->monitor_flags)) {
 		ret = ath11k_mac_monitor_vdev_create(ar);
@@ -7050,8 +7041,6 @@ err_vdev_del:
 	/* Recalc txpower for remaining vdev */
 	ath11k_mac_txpower_recalc(ar);
 
-	ath11k_debugfs_remove_interface(arvif);
-
 	/* TODO: recal traffic pause state based on the available vdevs */
 
 	mutex_unlock(&ar->conf_mutex);
@@ -9149,6 +9138,7 @@ static const struct ieee80211_ops ath11k
 #endif
 
 #ifdef CONFIG_ATH11K_DEBUGFS
+	.vif_add_debugfs		= ath11k_debugfs_op_vif_add,
 	.sta_add_debugfs		= ath11k_debugfs_sta_op_add,
 #endif
 


