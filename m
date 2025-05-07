Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F2F1FF5EC;
	Wed,  7 May 2025 18:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643918; cv=none; b=QuK5OFYIrTiKS7PskAceBtZ9iA0SQfUvscVhcGxzL8ctTEMAnMRiVgS/uqXzFUxi+RDENMW3YBGQaIuf1c7R1ktXH9yE1TYa5AwqcG+ABqgblTp0yecZRpRmACKGmjZdnAeLbA9tVrGZUeoPOZbCXr7eSD05fKstzjC/pyoHtPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643918; c=relaxed/simple;
	bh=HDZpADKCQ0KZtkKcMU4GaDNqXsGnpO9+SWV2KRnwcqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSR3qdE+OFXhQ/TiGO/G18NmR7UqJhtMW6zb7sUbi1DEzClKjT2lPerjMV5eP0fBrDudG6QT/RBEmTgFNStrdrCcPLmi26iOHbfPMudxyK6/abd+eVcTUouo89B+q+IH1lXkeC5j1aAzDWcFL7whfTIypaWnKGbVnYoajeToCzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcJuOpyj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcJuOpyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33242C4CEEE;
	Wed,  7 May 2025 18:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643918;
	bh=HDZpADKCQ0KZtkKcMU4GaDNqXsGnpO9+SWV2KRnwcqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcJuOpyjmhmx+nyv+JT+lB/2XMQEapldas220KdA2nibxTMlf953KejXCdvFykWhh
	 CwTz6S+3OadxhjWdHIFNgpevYAXDHvDYMZLoiRfpIBAjgvmD02rzc4rZYSrNnSs5kZ
	 RciByiRu+DqmzET5YQkxRezlqPTiKEeBQTcA3Rc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 061/183] wifi: iwlwifi: back off on continuous errors
Date: Wed,  7 May 2025 20:38:26 +0200
Message-ID: <20250507183827.156048394@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d49437a6afc707951e5767ef70c9726b6c05da08 ]

When errors occur repeatedly, the driver shouldn't go into a
tight loop trying to reset the device. Implement the backoff
I had already defined IWL_TRANS_RESET_DELAY for, but clearly
forgotten the implementation of.

Fixes: 9a2f13c40c63 ("wifi: iwlwifi: implement reset escalation")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250420095642.8816e299efa2.I82cde34e2345a2b33b1f03dbb040f5ad3439a5aa@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/iwl-trans.c    | 27 ++++++++++++++-----
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  7 +++--
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  3 ++-
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 47854a36413e1..8ad2bd64dbd3d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -21,6 +21,7 @@ struct iwl_trans_dev_restart_data {
 	struct list_head list;
 	unsigned int restart_count;
 	time64_t last_error;
+	bool backoff;
 	char name[];
 };
 
@@ -125,13 +126,20 @@ iwl_trans_determine_restart_mode(struct iwl_trans *trans)
 	if (!data)
 		return at_least;
 
-	if (ktime_get_boottime_seconds() - data->last_error >=
+	if (!data->backoff &&
+	    ktime_get_boottime_seconds() - data->last_error >=
 			IWL_TRANS_RESET_OK_TIME)
 		data->restart_count = 0;
 
 	index = data->restart_count;
-	if (index >= ARRAY_SIZE(escalation_list))
+	if (index >= ARRAY_SIZE(escalation_list)) {
 		index = ARRAY_SIZE(escalation_list) - 1;
+		if (!data->backoff) {
+			data->backoff = true;
+			return IWL_RESET_MODE_BACKOFF;
+		}
+		data->backoff = false;
+	}
 
 	return max(at_least, escalation_list[index]);
 }
@@ -140,7 +148,8 @@ iwl_trans_determine_restart_mode(struct iwl_trans *trans)
 
 static void iwl_trans_restart_wk(struct work_struct *wk)
 {
-	struct iwl_trans *trans = container_of(wk, typeof(*trans), restart.wk);
+	struct iwl_trans *trans = container_of(wk, typeof(*trans),
+					       restart.wk.work);
 	struct iwl_trans_reprobe *reprobe;
 	enum iwl_reset_mode mode;
 
@@ -168,6 +177,12 @@ static void iwl_trans_restart_wk(struct work_struct *wk)
 		return;
 
 	mode = iwl_trans_determine_restart_mode(trans);
+	if (mode == IWL_RESET_MODE_BACKOFF) {
+		IWL_ERR(trans, "Too many device errors - delay next reset\n");
+		queue_delayed_work(system_unbound_wq, &trans->restart.wk,
+				   IWL_TRANS_RESET_DELAY);
+		return;
+	}
 
 	iwl_trans_inc_restart_count(trans->dev);
 
@@ -227,7 +242,7 @@ struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 	trans->dev = dev;
 	trans->num_rx_queues = 1;
 
-	INIT_WORK(&trans->restart.wk, iwl_trans_restart_wk);
+	INIT_DELAYED_WORK(&trans->restart.wk, iwl_trans_restart_wk);
 
 	return trans;
 }
@@ -271,7 +286,7 @@ int iwl_trans_init(struct iwl_trans *trans)
 
 void iwl_trans_free(struct iwl_trans *trans)
 {
-	cancel_work_sync(&trans->restart.wk);
+	cancel_delayed_work_sync(&trans->restart.wk);
 	kmem_cache_destroy(trans->dev_cmd_pool);
 }
 
@@ -403,7 +418,7 @@ void iwl_trans_op_mode_leave(struct iwl_trans *trans)
 
 	iwl_trans_pcie_op_mode_leave(trans);
 
-	cancel_work_sync(&trans->restart.wk);
+	cancel_delayed_work_sync(&trans->restart.wk);
 
 	trans->op_mode = NULL;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index f6234065dbdde..9c64e1fd4c096 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -958,7 +958,7 @@ struct iwl_trans {
 	struct iwl_dma_ptr invalid_tx_cmd;
 
 	struct {
-		struct work_struct wk;
+		struct delayed_work wk;
 		struct iwl_fw_error_dump_mode mode;
 		bool during_reset;
 	} restart;
@@ -1159,7 +1159,7 @@ static inline void iwl_trans_schedule_reset(struct iwl_trans *trans,
 	 */
 	trans->restart.during_reset = test_bit(STATUS_IN_SW_RESET,
 					       &trans->status);
-	queue_work(system_unbound_wq, &trans->restart.wk);
+	queue_delayed_work(system_unbound_wq, &trans->restart.wk, 0);
 }
 
 static inline void iwl_trans_fw_error(struct iwl_trans *trans,
@@ -1258,6 +1258,9 @@ enum iwl_reset_mode {
 	IWL_RESET_MODE_RESCAN,
 	IWL_RESET_MODE_FUNC_RESET,
 	IWL_RESET_MODE_PROD_RESET,
+
+	/* keep last - special backoff value */
+	IWL_RESET_MODE_BACKOFF,
 };
 
 void iwl_trans_pcie_reset(struct iwl_trans *trans, enum iwl_reset_mode mode);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index c917ed4c19bcc..b1ccace7377fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2351,7 +2351,8 @@ void iwl_trans_pcie_reset(struct iwl_trans *trans, enum iwl_reset_mode mode)
 	struct iwl_trans_pcie_removal *removal;
 	char _msg = 0, *msg = &_msg;
 
-	if (WARN_ON(mode < IWL_RESET_MODE_REMOVE_ONLY))
+	if (WARN_ON(mode < IWL_RESET_MODE_REMOVE_ONLY ||
+		    mode == IWL_RESET_MODE_BACKOFF))
 		return;
 
 	if (test_bit(STATUS_TRANS_DEAD, &trans->status))
-- 
2.39.5



