Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12661F4FDC;
	Wed,  6 Nov 2024 12:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896828; cv=none; b=b5XC6ktFuXZ/ykAnQuPyS3b0dRiEhCNZ5oQdEeFZrOszvlqrKm9e7PzPGrMIwc+M/yWV+TMivt5mhfQ5sC3P2X4jQQcQ/U+ZA9XtBV7kZ8NhZ1U9HDfFUd1Z6Eg6+V6HCzGm3qRXCsPzXTtGHLN35XJwjSm11F6aZeYIGnPXNoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896828; c=relaxed/simple;
	bh=Fpg/jbVvD6UMp77hz9/78o9+L8J9Yvt6wvpGSoGei6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTwVFCDW32pLLdjQaRoWSH/iItM1pANpZmISDCRUb5/MtrjrPr6rJlj+EhLZHuH+M2ro3WmT6VkzlT6ikPpjN1siW791EHw/IMPC+yenXinoEik+wT+43tdRvNdGH3ugsgSNkIvePHjVNNs6gd3LjhEDsDm/+sVX64kUDe2dmJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgkB04Ji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgkB04Ji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D953CC4CECD;
	Wed,  6 Nov 2024 12:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896827;
	bh=Fpg/jbVvD6UMp77hz9/78o9+L8J9Yvt6wvpGSoGei6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RgkB04JiubcCUeNmWTCgeuV1ikmO2yjYfvwV9C1AkziM5saddRVdc6/aS7n9C0hJw
	 DdeLZWRib0GH9H7VYcsiX79z4x1zUTeSDs7GF/NG/wmnhS9giK7j+MKRUjmn6710Rh
	 Gw6GeN613qzvdJkdleBbPn+3qboxXkAna93E5jWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/110] wifi: iwlwifi: mvm: Fix response handling in iwl_mvm_send_recovery_cmd()
Date: Wed,  6 Nov 2024 13:04:34 +0100
Message-ID: <20241106120305.067593767@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 594c88a9ac496..553117e8fdd90 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1261,8 +1261,8 @@ static void iwl_mvm_disconnect_iterator(void *data, u8 *mac,
 void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
 {
 	u32 error_log_size = mvm->fw->ucode_capa.error_log_size;
+	u32 status = 0;
 	int ret;
-	u32 resp;
 
 	struct iwl_fw_error_recovery_cmd recovery_cmd = {
 		.flags = cpu_to_le32(flags),
@@ -1270,7 +1270,6 @@ void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
 	};
 	struct iwl_host_cmd host_cmd = {
 		.id = WIDE_ID(SYSTEM_GROUP, FW_ERROR_RECOVERY_CMD),
-		.flags = CMD_WANT_SKB,
 		.data = {&recovery_cmd, },
 		.len = {sizeof(recovery_cmd), },
 	};
@@ -1290,7 +1289,7 @@ void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
 		recovery_cmd.buf_size = cpu_to_le32(error_log_size);
 	}
 
-	ret = iwl_mvm_send_cmd(mvm, &host_cmd);
+	ret = iwl_mvm_send_cmd_status(mvm, &host_cmd, &status);
 	kfree(mvm->error_recovery_buf);
 	mvm->error_recovery_buf = NULL;
 
@@ -1301,11 +1300,10 @@ void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
 
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



