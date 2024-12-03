Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DC51F757D;
	Tue,  3 Dec 2024 14:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237572; cv=none; b=AFnl1M5f4NTNZ4ej3stR0SoDq51teAe94oa1iB/g882LdVVekWetDENyNzRLxuvV1h+OdsbJQrTMg3LYkMfFAWoOHRHQYbt97pXDfG6a/BvXjoGyPzKGaSVbFM9WrWO0PPN6IrWToySTiHn2F1LZOun9Qwk2AA1ZXy82TfZO+GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237572; c=relaxed/simple;
	bh=m0vIrncE88i1VZ+5cw9rFpyTi8yYbpAgF9Kq78XjQbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQ7YAMfeuCdmsbbpIRT/9K2c5iVyUcYc58xyHE5uN3NDwjNK5dMSthcllPd/PnBlW1n1mQOIheLjYJJXL/7vguEG0ANSaH1aaQnsl2RlsLYG+l/4mZKKnYDlCJUi9btnBbr8wEievp9M+hO+OottEaTlaJ1z8OW84Z0zgAQo1S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aodkao23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aodkao23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB750C4CECF;
	Tue,  3 Dec 2024 14:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237572;
	bh=m0vIrncE88i1VZ+5cw9rFpyTi8yYbpAgF9Kq78XjQbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aodkao23r4smNhvNqCWHomf/JfE+t7i8AIpxa5k1ikakcQtGfSZKUhtZH4TTJuAMU
	 CfPu1BdKV2K3OkqGL6FKQb1+fSS289I053jXUAcE80ht5j+r7KsJRvYeKa8alCFKGX
	 7FT3qtZES9nz8N4G7uHhrH8USuQLDt/PxujL28mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 010/817] wifi: iwlwifi: mvm: Use the sync timepoint API in suspend
Date: Tue,  3 Dec 2024 15:33:02 +0100
Message-ID: <20241203143956.034362333@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Daniel Gabay <daniel.gabay@intel.com>

[ Upstream commit 9715246ca0bfc9feaec1b4ff5b3d38de65a7025d ]

When starting the suspend flow, HOST_D3_START triggers an _async_
firmware dump collection for debugging purposes. The async worker
may race with suspend flow and fail to get NIC access, resulting in
the following warning:
"Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)"

Fix this by switching to the sync version to ensure the dump
completes before proceeding with the suspend flow, avoiding
potential race issues.

Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241010140328.9aae318cd593.I4b322009f39489c0b1d8893495c887870f73ed9c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/init.c | 4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c  | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/init.c b/drivers/net/wireless/intel/iwlwifi/fw/init.c
index d8b083be5b6b5..de87e0e3e0725 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/init.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/init.c
@@ -39,10 +39,12 @@ void iwl_fw_runtime_init(struct iwl_fw_runtime *fwrt, struct iwl_trans *trans,
 }
 IWL_EXPORT_SYMBOL(iwl_fw_runtime_init);
 
+/* Assumes the appropriate lock is held by the caller */
 void iwl_fw_runtime_suspend(struct iwl_fw_runtime *fwrt)
 {
 	iwl_fw_suspend_timestamp(fwrt);
-	iwl_dbg_tlv_time_point(fwrt, IWL_FW_INI_TIME_POINT_HOST_D3_START, NULL);
+	iwl_dbg_tlv_time_point_sync(fwrt, IWL_FW_INI_TIME_POINT_HOST_D3_START,
+				    NULL);
 }
 IWL_EXPORT_SYMBOL(iwl_fw_runtime_suspend);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 99a541d442bb1..f4f87edb86e5c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1398,7 +1398,9 @@ int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	iwl_mvm_pause_tcm(mvm, true);
 
+	mutex_lock(&mvm->mutex);
 	iwl_fw_runtime_suspend(&mvm->fwrt);
+	mutex_unlock(&mvm->mutex);
 
 	return __iwl_mvm_suspend(hw, wowlan, false);
 }
-- 
2.43.0



