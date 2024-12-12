Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE8414A82;
	Thu, 12 Dec 2024 15:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018771; cv=none; b=KswX1YePuGJgB5COFubaeclM/FqMQ8+/A2eWv/eCitS7Q2qkaVYc19guyVDnOeWUfA/Noha2OsQzypPfcuUJ1hDt6uT34QvM7w37yWXdc2IvQo/qWD5DVGyMHkqi9fJ5DkoIadaqpuLkCwfQaa1tdldUp6jya3K3cgpy7bpzo80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018771; c=relaxed/simple;
	bh=Xz+yJWMyjHlbucbM4UzMob1COJb9OzZObw91FifpZ+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Et792xH6812bhje/jbteD3yICFL16aq3MuzS36F+hyG/ck3K0sdNAV/LlfSMKUYa0Cj7RIB9elPdCb3o0+UCybuB35bOkkPwA+dP4aw+fT6htsu4McqlsLlGpVUfUhWSkZdDXI/7PUUdCggY0R1b6V9VI4a8G9AjoXLIgzq7N1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIek4Zco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIek4Zco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD0FC4CED3;
	Thu, 12 Dec 2024 15:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018771;
	bh=Xz+yJWMyjHlbucbM4UzMob1COJb9OzZObw91FifpZ+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIek4ZcoPXCYtX+tFdc0aa22Rj7qff8JH6ISIbIVsEuy2OU0EOS4NoaiuEtJwcmMY
	 ygsdiVhA3elnMjCffyEtYdAW5+REVKnztgC1w/lxw9oAuQS4Nm63B4jSNcfDEUjW7Z
	 vo91HUvlUt2LIxWNua1en0hlwCw7rpKKdBu/GxJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/772] wifi: iwlwifi: mvm: Use the sync timepoint API in suspend
Date: Thu, 12 Dec 2024 15:49:09 +0100
Message-ID: <20241212144349.995023905@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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
index 425588605a262..53302c29c2291 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1375,7 +1375,9 @@ int iwl_mvm_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	iwl_mvm_pause_tcm(mvm, true);
 
+	mutex_lock(&mvm->mutex);
 	iwl_fw_runtime_suspend(&mvm->fwrt);
+	mutex_unlock(&mvm->mutex);
 
 	return __iwl_mvm_suspend(hw, wowlan, false);
 }
-- 
2.43.0



