Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8375E13D516;
	Fri,  6 Dec 2024 14:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496503; cv=none; b=kmT8lO25gygDCfiNnSK41lSxE9ECrmK37pIsCCT7Z8ZcVlHAKZabE+d+T2Z/OuxxBAk9Ih7pYl2Bx9bjBSVc7Lf3zPqo0Kr6N+RmjfoqZcQJ2XF/kqzd9Y7WfGroUGLpD3jhKeqoCOyE2sb4KZCi0focUHIDEszUZxsZwrVgUzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496503; c=relaxed/simple;
	bh=zVCc/jRLrIlNufYv+LMZDqmvS6xDVHiqZ2aue7LITjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9v9liO3qTyqmUDMTlXicEKPM/cDDRHglNxOyotka86qVkHtRdV6Slege40988Av2MxFaoOkrS/57sTxXTZ+P56Jo7iTtBt4vD7rPFW5iZkabfLPBsKxiIhS8+eWvqn3zjbLjbK3QnpgdGr2AueTfvzStyA2u2Q+6BYXiPZyDzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYlx9Kii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYlx9Kii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C58C4CED1;
	Fri,  6 Dec 2024 14:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496503;
	bh=zVCc/jRLrIlNufYv+LMZDqmvS6xDVHiqZ2aue7LITjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYlx9KiiXQ6T4nrSzCVvuVIwEC4DXfUgmI3m0W1a7iYpbqTpotXAHZHoVR1NQfXmG
	 XSQghp10sTDGW/qH3OvxtZRhnwpM4Y/FY7BQP3U8AMdbbUiDI3eI5wywmm5IUWtwxw
	 aET9NvAZDCbHT1jL7uiGFPIQ0u8oYgdFgf072ZW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/676] wifi: iwlwifi: mvm: Use the sync timepoint API in suspend
Date: Fri,  6 Dec 2024 15:27:05 +0100
Message-ID: <20241206143653.605329801@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 135bd48bfe9fa..cf02a2afbee56 100644
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
index 08d1fab7f53c3..592b9157d50c6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1382,7 +1382,9 @@ int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	iwl_mvm_pause_tcm(mvm, true);
 
+	mutex_lock(&mvm->mutex);
 	iwl_fw_runtime_suspend(&mvm->fwrt);
+	mutex_unlock(&mvm->mutex);
 
 	return __iwl_mvm_suspend(hw, wowlan, false);
 }
-- 
2.43.0



