Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093981DF978;
	Wed,  6 Nov 2024 12:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895904; cv=none; b=Ztq/4oGGfLS4IWHT+b7v0KJAnIPf3pkIymVUwFNoktDmsurPz3H1SZbhm7askgD2HMr62CcJeOW22ePZQMLfCUzyy41dFyY0tqpA84tEUrOu6xEzm3a++lFZ0LsgZ/AL206QbbnTLm8qQMfjWe2cNI1+mud1FmFWgcGqHurULSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895904; c=relaxed/simple;
	bh=4l15eMwk3dncQ1XJHzVO3R2jDPL7ZsZ5UnL2JjszJLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fr4MX/Tu/o4R0/W5RiYPfmT48Y2qr0T5Ffloca/J7pooBCIcHCIeyg4zmABMA6Lm/uycYQL6kHLQVWSMt2cM0mkWcRsoRkJoms4I81vTFska2CHjqxQJGMBk7MkOUFim7sKagUla6LsnzV1BYlPnJNFJVW1jvKSJcBOn4vXQMlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KXHduDmD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KXHduDmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B830C4CED3;
	Wed,  6 Nov 2024 12:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895903;
	bh=4l15eMwk3dncQ1XJHzVO3R2jDPL7ZsZ5UnL2JjszJLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KXHduDmD1UqsHtyFLst9ETYmal7l6TrgUGZEeJZpuy+n9FWIxUXXP6zMaFRskudgi
	 F6PyThazTTkwznbmuxTJFiAkBMuVeWjF1/iY5O0QIq/yHY7d6bPl/ZgpLBcQNPMgk5
	 Q5u5xOqVEtswA5Zczh4kGDYqBOvGjIbvgaznVN3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 023/245] Revert "wifi: iwlwifi: remove retry loops in start"
Date: Wed,  6 Nov 2024 13:01:16 +0100
Message-ID: <20241106120319.805249955@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit bfc0ed73e095cc3858d35731f191fa6e3d813262 ]

Revert commit dfdfe4be183b ("wifi: iwlwifi: remove retry loops in
start"), it turns out that there's an issue with the PNVM load
notification from firmware not getting processed, that this patch
has been somewhat successfully papering over. Since this is being
reported, revert the loop removal for now.

We will later at least clean this up to only attempt to retry if
there was a timeout, but currently we don't even bubble up the
failure reason to the correct layer, only returning NULL.

Fixes: dfdfe4be183b ("wifi: iwlwifi: remove retry loops in start")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20241022092212.4aa82a558a00.Ibdeff9c8f0d608bc97fc42024392ae763b6937b7@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  | 28 +++++++++++++------
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h  |  3 ++
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 10 ++++++-
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index aaaabd67f9593..3709039a294d8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1413,25 +1413,35 @@ _iwl_op_mode_start(struct iwl_drv *drv, struct iwlwifi_opmode_table *op)
 	const struct iwl_op_mode_ops *ops = op->ops;
 	struct dentry *dbgfs_dir = NULL;
 	struct iwl_op_mode *op_mode = NULL;
+	int retry, max_retry = !!iwlwifi_mod_params.fw_restart * IWL_MAX_INIT_RETRY;
 
 	/* also protects start/stop from racing against each other */
 	lockdep_assert_held(&iwlwifi_opmode_table_mtx);
 
+	for (retry = 0; retry <= max_retry; retry++) {
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	drv->dbgfs_op_mode = debugfs_create_dir(op->name,
-						drv->dbgfs_drv);
-	dbgfs_dir = drv->dbgfs_op_mode;
+		drv->dbgfs_op_mode = debugfs_create_dir(op->name,
+							drv->dbgfs_drv);
+		dbgfs_dir = drv->dbgfs_op_mode;
 #endif
 
-	op_mode = ops->start(drv->trans, drv->trans->cfg,
-			     &drv->fw, dbgfs_dir);
-	if (op_mode)
-		return op_mode;
+		op_mode = ops->start(drv->trans, drv->trans->cfg,
+				     &drv->fw, dbgfs_dir);
+
+		if (op_mode)
+			return op_mode;
+
+		if (test_bit(STATUS_TRANS_DEAD, &drv->trans->status))
+			break;
+
+		IWL_ERR(drv, "retry init count %d\n", retry);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	debugfs_remove_recursive(drv->dbgfs_op_mode);
-	drv->dbgfs_op_mode = NULL;
+		debugfs_remove_recursive(drv->dbgfs_op_mode);
+		drv->dbgfs_op_mode = NULL;
 #endif
+	}
 
 	return NULL;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.h b/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
index 1549ff4295497..6a1d31892417b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.h
@@ -98,6 +98,9 @@ void iwl_drv_stop(struct iwl_drv *drv);
 #define VISIBLE_IF_IWLWIFI_KUNIT static
 #endif
 
+/* max retry for init flow */
+#define IWL_MAX_INIT_RETRY 2
+
 #define FW_NAME_PRE_BUFSIZE	64
 struct iwl_trans;
 const char *iwl_drv_get_fwname_pre(struct iwl_trans *trans, char *buf);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index e38cff6176dd3..63b2c6fe3f8ab 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1292,12 +1292,14 @@ int iwl_mvm_mac_start(struct ieee80211_hw *hw)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
+	int retry, max_retry = 0;
 
 	mutex_lock(&mvm->mutex);
 
 	/* we are starting the mac not in error flow, and restart is enabled */
 	if (!test_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED, &mvm->status) &&
 	    iwlwifi_mod_params.fw_restart) {
+		max_retry = IWL_MAX_INIT_RETRY;
 		/*
 		 * This will prevent mac80211 recovery flows to trigger during
 		 * init failures
@@ -1305,7 +1307,13 @@ int iwl_mvm_mac_start(struct ieee80211_hw *hw)
 		set_bit(IWL_MVM_STATUS_STARTING, &mvm->status);
 	}
 
-	ret = __iwl_mvm_mac_start(mvm);
+	for (retry = 0; retry <= max_retry; retry++) {
+		ret = __iwl_mvm_mac_start(mvm);
+		if (!ret)
+			break;
+
+		IWL_ERR(mvm, "mac start retry %d\n", retry);
+	}
 	clear_bit(IWL_MVM_STATUS_STARTING, &mvm->status);
 
 	mutex_unlock(&mvm->mutex);
-- 
2.43.0



