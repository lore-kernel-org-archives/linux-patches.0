Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1DB14EC58;
	Tue, 23 Jul 2024 18:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759858; cv=none; b=CeO2Z752D4kdOHIOB2LgsmllT1bp1mHkP+JR1mAEVBbsqYsq4OtcYHIKOeodRityg+qsSKeO0NVMEbxMRROrLNyXjRRaHrv5mfqpRH8JVx2flsMPMBgZPPkMHX07fpIxECnKz3tH7gdlrGgqEt2NCnq0da7QRs1VPQeM60qJe3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759858; c=relaxed/simple;
	bh=uTJJCj7W3AUR+G/+QxVi7bY3UhjqwVF3VughUiT5uqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIrlF7xckAsz84CBpiVnC0LhE/8Ms0Uf0HFEMYwxCvAgIPPtODfmV5oJvWRSSPdNKFw14xL1gP99sTpl5vHXr+dAmYgazZhpZktpuo55gt3jcrOaqj2GWXt91FsZeaxcjJLPXOSMs9sX7zBRxvF7+YrWlED/oIQrw9itVo2ZuaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ePCoXSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ePCoXSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989BDC4AF0A;
	Tue, 23 Jul 2024 18:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759858;
	bh=uTJJCj7W3AUR+G/+QxVi7bY3UhjqwVF3VughUiT5uqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ePCoXSW88kIEzOuK10DTC2PK3QW/FW9Xcvt3ZIgvEx42wy2VMzbT/+g2/NIvU6US
	 quhlf4bQWe+eaPQCVyYDBI+DgzSSR4LzS5yoy3Q0Bi/c3DjuvsyadmZxv4g6nAJoa0
	 FuqmcSvPfAem3TXzFVp4TWyzMUakp1tgW2dF4z5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 021/163] wifi: iwlwifi: mvm: handle BA session teardown in RF-kill
Date: Tue, 23 Jul 2024 20:22:30 +0200
Message-ID: <20240723180144.290142399@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 4d08c0b3357cba0aeffaf3abc62cae0c154f2816 ]

When entering RF-kill, mac80211 tears down BA sessions, but
due to RF-kill the commands aren't sent to the device. As a
result, there can be frames pending on the reorder buffer or
perhaps even received while doing so, leading to warnings.

Avoid the warnings by doing the BA session teardown normally
even in RF-kill, which also requires queue sync.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240513132416.0762cd80fb3d.I43c5877f3b546159b2db4f36d6d956b333c41cf0@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c  |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 12 ++++++++----
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 3b61fe8ca47fa..d3db883dfaa5b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -6164,7 +6164,7 @@ void iwl_mvm_sync_rx_queues_internal(struct iwl_mvm *mvm,
 		.len[0] = sizeof(cmd),
 		.data[1] = data,
 		.len[1] = size,
-		.flags = sync ? 0 : CMD_ASYNC,
+		.flags = CMD_SEND_IN_RFKILL | (sync ? 0 : CMD_ASYNC),
 	};
 	int ret;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
index a21e29947475f..dbe668db7ce37 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
@@ -1012,7 +1012,8 @@ static int iwl_mvm_mld_update_sta_baids(struct iwl_mvm *mvm,
 
 		cmd.modify.tid = cpu_to_le32(data->tid);
 
-		ret = iwl_mvm_send_cmd_pdu(mvm, cmd_id, 0, sizeof(cmd), &cmd);
+		ret = iwl_mvm_send_cmd_pdu(mvm, cmd_id, CMD_SEND_IN_RFKILL,
+					   sizeof(cmd), &cmd);
 		data->sta_mask = new_sta_mask;
 		if (ret)
 			return ret;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 491c449fd4316..908d0bc474da6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2836,7 +2836,12 @@ static int iwl_mvm_fw_baid_op_cmd(struct iwl_mvm *mvm,
 		.action = start ? cpu_to_le32(IWL_RX_BAID_ACTION_ADD) :
 				  cpu_to_le32(IWL_RX_BAID_ACTION_REMOVE),
 	};
-	u32 cmd_id = WIDE_ID(DATA_PATH_GROUP, RX_BAID_ALLOCATION_CONFIG_CMD);
+	struct iwl_host_cmd hcmd = {
+		.id = WIDE_ID(DATA_PATH_GROUP, RX_BAID_ALLOCATION_CONFIG_CMD),
+		.flags = CMD_SEND_IN_RFKILL,
+		.len[0] = sizeof(cmd),
+		.data[0] = &cmd,
+	};
 	int ret;
 
 	BUILD_BUG_ON(sizeof(struct iwl_rx_baid_cfg_resp) != sizeof(baid));
@@ -2848,7 +2853,7 @@ static int iwl_mvm_fw_baid_op_cmd(struct iwl_mvm *mvm,
 		cmd.alloc.ssn = cpu_to_le16(ssn);
 		cmd.alloc.win_size = cpu_to_le16(buf_size);
 		baid = -EIO;
-	} else if (iwl_fw_lookup_cmd_ver(mvm->fw, cmd_id, 1) == 1) {
+	} else if (iwl_fw_lookup_cmd_ver(mvm->fw, hcmd.id, 1) == 1) {
 		cmd.remove_v1.baid = cpu_to_le32(baid);
 		BUILD_BUG_ON(sizeof(cmd.remove_v1) > sizeof(cmd.remove));
 	} else {
@@ -2857,8 +2862,7 @@ static int iwl_mvm_fw_baid_op_cmd(struct iwl_mvm *mvm,
 		cmd.remove.tid = cpu_to_le32(tid);
 	}
 
-	ret = iwl_mvm_send_cmd_pdu_status(mvm, cmd_id, sizeof(cmd),
-					  &cmd, &baid);
+	ret = iwl_mvm_send_cmd_status(mvm, &hcmd, &baid);
 	if (ret)
 		return ret;
 
-- 
2.43.0



