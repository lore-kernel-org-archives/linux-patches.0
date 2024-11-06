Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5271EC017;
	Wed,  6 Nov 2024 12:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897331; cv=none; b=EXrpcgcTrpMbOJXVzD9NoiIoGPLavBGedP4eARbtFXFWxADO2fxeaArUYAvvFubnno6UTZAo9qmHc+X9dO9Qb6V2XUqPCp7nRCghDKXJSfjkl2+TtpdOJ81qciND3bhih3vUsQ4od8T2mQhXIqax9WADrC9Mvlu7IDJTwA/ZGVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897331; c=relaxed/simple;
	bh=qXeNJwgXdq3YRmq9qQb3oKYyfPI8csf4W7rZ4vjkWNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+cUY0AE0+k39Z3Rty8Ce5Dau5tBy9QWh/lLpi+jFGSX2WP52yhY8Fr0kyQMcY9n/hhY+R8qb9SsX4wqB0aAD5UrCmH6kt+sLmKzdXffo2Xz/C2tMsD8INa6CnC2ndc+KrEIqvfKuw9x1GTjDrjrcX84b+jVQgPRJSDfPxCP9KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9YVeInP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9YVeInP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE341C4CECD;
	Wed,  6 Nov 2024 12:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897331;
	bh=qXeNJwgXdq3YRmq9qQb3oKYyfPI8csf4W7rZ4vjkWNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9YVeInP9OUDu7USzvKOxwq9oLKTwgOr0ScYbLMR8Zn1iOOEzT3vk0BD/10gt8rk+
	 o4Ei8ayBfsIADQMocZjxCdf2NvPc1nsr3IbIr3Q6AfOjWVs7xPXkm4vuIxXfFILvkP
	 UuA5eg8DfMTOh3l6ziwGrfRIjYk9lyeYOpH6ja90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/151] wifi: iwlwifi: mvm: Fix response handling in iwl_mvm_send_recovery_cmd()
Date: Wed,  6 Nov 2024 13:03:26 +0100
Message-ID: <20241106120309.337945733@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Gabay <daniel.gabay@intel.com>

[ Upstream commit 07a6e3b78a65f4b2796a8d0d4adb1a15a81edead ]

1. The size of the response packet is not validated.
2. The response buffer is not freed.

Resolve these issues by switching to iwl_mvm_send_cmd_status(),
which handles both size validation and frees the buffer.

Fixes: f130bb75d881 ("iwlwifi: add FW recovery flow")
Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241010140328.76c73185951e.Id3b6ca82ced2081f5ee4f33c997491d0ebda83f7@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 4bc395a5731b2..80b5c20d3a480 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1404,8 +1404,8 @@ static void iwl_mvm_disconnect_iterator(void *data, u8 *mac,
 void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
 {
 	u32 error_log_size = mvm->fw->ucode_capa.error_log_size;
+	u32 status = 0;
 	int ret;
-	u32 resp;
 
 	struct iwl_fw_error_recovery_cmd recovery_cmd = {
 		.flags = cpu_to_le32(flags),
@@ -1413,7 +1413,6 @@ void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
 	};
 	struct iwl_host_cmd host_cmd = {
 		.id = WIDE_ID(SYSTEM_GROUP, FW_ERROR_RECOVERY_CMD),
-		.flags = CMD_WANT_SKB,
 		.data = {&recovery_cmd, },
 		.len = {sizeof(recovery_cmd), },
 	};
@@ -1433,7 +1432,7 @@ void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
 		recovery_cmd.buf_size = cpu_to_le32(error_log_size);
 	}
 
-	ret = iwl_mvm_send_cmd(mvm, &host_cmd);
+	ret = iwl_mvm_send_cmd_status(mvm, &host_cmd, &status);
 	kfree(mvm->error_recovery_buf);
 	mvm->error_recovery_buf = NULL;
 
@@ -1444,11 +1443,10 @@ void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
 
 	/* skb respond is only relevant in ERROR_RECOVERY_UPDATE_DB */
 	if (flags & ERROR_RECOVERY_UPDATE_DB) {
-		resp = le32_to_cpu(*(__le32 *)host_cmd.resp_pkt->data);
-		if (resp) {
+		if (status) {
 			IWL_ERR(mvm,
 				"Failed to send recovery cmd blob was invalid %d\n",
-				resp);
+				status);
 
 			ieee80211_iterate_interfaces(mvm->hw, 0,
 						     iwl_mvm_disconnect_iterator,
-- 
2.43.0



