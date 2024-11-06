Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA4F1F7072;
	Wed,  6 Nov 2024 12:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896956; cv=none; b=RPurY2NYI2dLm1myCewzdcXwMSKXlMeYjrpk4PyXn4D9qO6SYF0zwmnoQSEAf9gHVq7hpnWyljewmMTNr3LCUOgzhqP91I9/HwPKl2RpxhdYO80+w6soX8e+f4AHzk5v/dSasr9nUtWg6JY+H1uRiLq23T8J7rSBe3LDLWMXDLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896956; c=relaxed/simple;
	bh=Ax0vzl8Z8H0YeFkaldTWY0AMFMKbW/txvfalNIz4/ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+VrhIQ++X8RcHHrAk5b2Ush0TQTXXlJoYUDT0rYQub7mw4TVq/jX21XX4ia7986XzWgfMfz1soJWvgijOF6E+mB9tetYVV+oyMzPrPKZaWatLSfH+6uEFsejTmFaC4t7rnBS8UjBLbBNwotGvMQ4yZV+HFXeQ/IkrA3Gpkds+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SaX4YaSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SaX4YaSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501A9C4CED4;
	Wed,  6 Nov 2024 12:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896956;
	bh=Ax0vzl8Z8H0YeFkaldTWY0AMFMKbW/txvfalNIz4/ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SaX4YaSgx2EeIrD7fCIxfjvEmj+yjjTnDEJGwhb9HRYrV7sIZf4RBCghX5W6nAAsV
	 lQyQRpvSavHEnfS7x5Ut7xO1LO+JBqc/tTlpfOmh+FrlHA7OYbk+C5NKB+Y1j1L0lZ
	 TxHAZ74aTRl4QSNbeKafREpK0gU88fwYGmYhizAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/126] wifi: iwlwifi: mvm: Fix response handling in iwl_mvm_send_recovery_cmd()
Date: Wed,  6 Nov 2024 13:03:40 +0100
Message-ID: <20241106120306.615730906@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bf305f1e3ea1d..4706df3ae81bb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1358,8 +1358,8 @@ static void iwl_mvm_disconnect_iterator(void *data, u8 *mac,
 void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
 {
 	u32 error_log_size = mvm->fw->ucode_capa.error_log_size;
+	u32 status = 0;
 	int ret;
-	u32 resp;
 
 	struct iwl_fw_error_recovery_cmd recovery_cmd = {
 		.flags = cpu_to_le32(flags),
@@ -1367,7 +1367,6 @@ void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
 	};
 	struct iwl_host_cmd host_cmd = {
 		.id = WIDE_ID(SYSTEM_GROUP, FW_ERROR_RECOVERY_CMD),
-		.flags = CMD_WANT_SKB,
 		.data = {&recovery_cmd, },
 		.len = {sizeof(recovery_cmd), },
 	};
@@ -1387,7 +1386,7 @@ void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
 		recovery_cmd.buf_size = cpu_to_le32(error_log_size);
 	}
 
-	ret = iwl_mvm_send_cmd(mvm, &host_cmd);
+	ret = iwl_mvm_send_cmd_status(mvm, &host_cmd, &status);
 	kfree(mvm->error_recovery_buf);
 	mvm->error_recovery_buf = NULL;
 
@@ -1398,11 +1397,10 @@ void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
 
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



