Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E2333981;
	Tue,  8 Oct 2024 12:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389727; cv=none; b=AFtkRPf/t0TrJSQnxF81ZT+iiWvXZPaI9mO/Bob7kuSToGMCeVNQJ0RbttDXJZl6HKucuWbrmgHHHY1DYkRdzvzvJ7TQx5p2LvXC21a9De1xpcyKxISu1H5LwV+IrlleOmQ+BMTdpFf4WCjFcsbdcZFYNn4yIaIF28YdGZCd9Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389727; c=relaxed/simple;
	bh=baAnRgF5QraSWKXFcKMkTXg59UlvKXi/YeXta0EOsb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKVrIvT88UVbZv+RhEFePZimaag8ZtRyK/UQvEesLb3c5S6au5DcUC3w6r8R0U4T/WlPjqeshhNxBJ2KnZHBrzq9gz658BSzS7yGEqT2XIKoxyjo5N+Pzmr6AadlBOgAWCgmykEFw8KGbaXitnazllTMc/W9MX2zo7uGUrOpe9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWh9t+vm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWh9t+vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05348C4CEC7;
	Tue,  8 Oct 2024 12:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389727;
	bh=baAnRgF5QraSWKXFcKMkTXg59UlvKXi/YeXta0EOsb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWh9t+vmVGl8atHfi2DsGiuX3VaaIYtxWwEGMbNOW6vrWcSUNiltzUMIlfR4LZEJJ
	 /cEn8rZmUAeC0Bl77M8F3NbLMwCOLLaeIqnxRLIZZtjODZ8mwX6sPiCbz4fEus6Hr7
	 4QeuZDFVzxY3N3iJA/GDRDBh2mZvY+E6NrueOJoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 078/482] wifi: iwlwifi: mvm: Fix a race in scan abort flow
Date: Tue,  8 Oct 2024 14:02:21 +0200
Message-ID: <20241008115651.375997154@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 87c1c28a9aa149489e1667f5754fc24f4973d2d0 ]

When the upper layer requests to cancel an ongoing scan, a race
is possible in which by the time the driver starts to handle the
upper layers scan cancel flow, the FW already completed handling
the scan request and the driver received the scan complete
notification but still did not handle the notification. In such a
case the FW will simply ignore the scan abort request coming from
the driver, no notification would arrive from the FW and the entire
abort flow would be considered a failure.

To better handle this, check the status code returned by the FW for
the scan abort command. In case the status indicates that
no scan was aborted, complete the scan abort flow with success, i.e.,
the scan was aborted, as the flow is expected to consume the scan
complete notification.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240825085558.483989d3baef.I3340556a222388504c6330b333360bf77d10f9e2@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/fw/api/scan.h  | 13 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 42 +++++++++++++++----
 2 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
index 6684506f4fc48..6cf237850ea0c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/scan.h
@@ -1132,6 +1132,19 @@ struct iwl_umac_scan_abort {
 	__le32 flags;
 } __packed; /* SCAN_ABORT_CMD_UMAC_API_S_VER_1 */
 
+/**
+ * enum iwl_umac_scan_abort_status
+ *
+ * @IWL_UMAC_SCAN_ABORT_STATUS_SUCCESS: scan was successfully aborted
+ * @IWL_UMAC_SCAN_ABORT_STATUS_IN_PROGRESS: scan abort is in progress
+ * @IWL_UMAC_SCAN_ABORT_STATUS_NOT_FOUND: nothing to abort
+ */
+enum iwl_umac_scan_abort_status {
+	IWL_UMAC_SCAN_ABORT_STATUS_SUCCESS = 0,
+	IWL_UMAC_SCAN_ABORT_STATUS_IN_PROGRESS,
+	IWL_UMAC_SCAN_ABORT_STATUS_NOT_FOUND,
+};
+
 /**
  * struct iwl_umac_scan_complete
  * @uid: scan id, &enum iwl_umac_scan_uid_offsets
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index d7c276237c74e..d8a3d47f5c072 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -3313,13 +3313,23 @@ void iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
 		       mvm->scan_start);
 }
 
-static int iwl_mvm_umac_scan_abort(struct iwl_mvm *mvm, int type)
+static int iwl_mvm_umac_scan_abort(struct iwl_mvm *mvm, int type, bool *wait)
 {
-	struct iwl_umac_scan_abort cmd = {};
+	struct iwl_umac_scan_abort abort_cmd = {};
+	struct iwl_host_cmd cmd = {
+		.id = WIDE_ID(IWL_ALWAYS_LONG_GROUP, SCAN_ABORT_UMAC),
+		.len = { sizeof(abort_cmd), },
+		.data = { &abort_cmd, },
+		.flags = CMD_SEND_IN_RFKILL,
+	};
+
 	int uid, ret;
+	u32 status = IWL_UMAC_SCAN_ABORT_STATUS_NOT_FOUND;
 
 	lockdep_assert_held(&mvm->mutex);
 
+	*wait = true;
+
 	/* We should always get a valid index here, because we already
 	 * checked that this type of scan was running in the generic
 	 * code.
@@ -3328,17 +3338,28 @@ static int iwl_mvm_umac_scan_abort(struct iwl_mvm *mvm, int type)
 	if (WARN_ON_ONCE(uid < 0))
 		return uid;
 
-	cmd.uid = cpu_to_le32(uid);
+	abort_cmd.uid = cpu_to_le32(uid);
 
 	IWL_DEBUG_SCAN(mvm, "Sending scan abort, uid %u\n", uid);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm,
-				   WIDE_ID(IWL_ALWAYS_LONG_GROUP, SCAN_ABORT_UMAC),
-				   CMD_SEND_IN_RFKILL, sizeof(cmd), &cmd);
+	ret = iwl_mvm_send_cmd_status(mvm, &cmd, &status);
+
+	IWL_DEBUG_SCAN(mvm, "Scan abort: ret=%d, status=%u\n", ret, status);
 	if (!ret)
 		mvm->scan_uid_status[uid] = type << IWL_MVM_SCAN_STOPPING_SHIFT;
 
-	IWL_DEBUG_SCAN(mvm, "Scan abort: ret=%d\n", ret);
+	/* Handle the case that the FW is no longer familiar with the scan that
+	 * is to be stopped. In such a case, it is expected that the scan
+	 * complete notification was already received but not yet processed.
+	 * In such a case, there is no need to wait for a scan complete
+	 * notification and the flow should continue similar to the case that
+	 * the scan was really aborted.
+	 */
+	if (status == IWL_UMAC_SCAN_ABORT_STATUS_NOT_FOUND) {
+		mvm->scan_uid_status[uid] = type << IWL_MVM_SCAN_STOPPING_SHIFT;
+		*wait = false;
+	}
+
 	return ret;
 }
 
@@ -3348,6 +3369,7 @@ static int iwl_mvm_scan_stop_wait(struct iwl_mvm *mvm, int type)
 	static const u16 scan_done_notif[] = { SCAN_COMPLETE_UMAC,
 					      SCAN_OFFLOAD_COMPLETE, };
 	int ret;
+	bool wait = true;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -3359,7 +3381,7 @@ static int iwl_mvm_scan_stop_wait(struct iwl_mvm *mvm, int type)
 	IWL_DEBUG_SCAN(mvm, "Preparing to stop scan, type %x\n", type);
 
 	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN))
-		ret = iwl_mvm_umac_scan_abort(mvm, type);
+		ret = iwl_mvm_umac_scan_abort(mvm, type, &wait);
 	else
 		ret = iwl_mvm_lmac_scan_abort(mvm);
 
@@ -3367,6 +3389,10 @@ static int iwl_mvm_scan_stop_wait(struct iwl_mvm *mvm, int type)
 		IWL_DEBUG_SCAN(mvm, "couldn't stop scan type %d\n", type);
 		iwl_remove_notification(&mvm->notif_wait, &wait_scan_done);
 		return ret;
+	} else if (!wait) {
+		IWL_DEBUG_SCAN(mvm, "no need to wait for scan type %d\n", type);
+		iwl_remove_notification(&mvm->notif_wait, &wait_scan_done);
+		return 0;
 	}
 
 	return iwl_wait_notification(&mvm->notif_wait, &wait_scan_done,
-- 
2.43.0



