Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96386395AD4;
	Thu, 17 Sep 2026 17:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665006; cv=none; b=PuLek35oPRUImVYgH4CKXSDG00LKKq8jAl5O9GkS8aQqvWk3/6a0/thbBskEGIABccWNfwn9EH8Yb/Oucsw4J1LRmoDAN9Z0NRPvKeFN1lMLlWn37Sb7JAox05iCXmM9icVhAJl/AcP9ifFDrLf0DsHYqCN2vBsopWRcT6ziVV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665006; c=relaxed/simple;
	bh=4kf65R4HTRu/DAQ214zqtRSrBRgr5FO6WQt//0+gOSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7sdTb/2LMDyZSIyjUyvf6HWjZecQIlqqCig6DEalFydxqiH4OEdDIO5viyZp5oSFfIH0lvmF01pKLNlCc3PVyg10zY0NYymExo8nBS1/lQOtbrC+0Pn7/OnsEBXVb8Ny629xQLSjNOLZc/Ex/vK3xfZhr4sxkLhjNeGGgCFN3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ze2IcmC8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ze2IcmC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC12D1F000FF;
	Thu, 17 Sep 2026 17:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665005;
	bh=zfY9wRvNhLe0V8EXcpEuTKC7aNQyaLf07C3Mr+zkmcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ze2IcmC8+cTGwUON8HokVisttBXsd3gYH8AV+2/kSp3G89kH5LTvDrfS7K35Ewvjt
	 YCjYEoNq6V+oAVAv6+5mZNyCgwOLSlYluUQnq62cNiaLCDId38zECS2dGWhSTBpXvX
	 JaLwkoJ9Syr8b23gcZbEmpX2KsxksFWGZfuFY6RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0521/1250] wifi: iwlwifi: mvm: fix sched scan IE sizing
Date: Thu, 17 Sep 2026 16:05:16 +0100
Message-ID: <20260917151606.070259247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 4f155d262b31b9b17e0f9856bdabe0968eb4930f ]

Scheduled scan built the probe request before iwl_mvm_scan_fits(),
so oversized IEs could be copied into the fixed preq buffer before
length validation. Move iwl_mvm_build_scan_probe() after the fits
check.

Also advertise max_sched_scan_ie_len using iwl_mvm_max_scan_ie_len()
so userspace limits account for driver-inserted DS/TPC bytes.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Link: https://patch.msgid.link/20260714141909.53d2722c79e7.Iebb922efa6173c92f14cd8aa8b4e7f372c0a0fb7@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 +---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     | 4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 83fb3f9af4745..a0bf9815aef6b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -625,9 +625,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	hw->wiphy->max_sched_scan_reqs = 1;
 	hw->wiphy->max_sched_scan_ssids = PROBE_OPTION_MAX;
 	hw->wiphy->max_match_sets = iwl_umac_scan_get_max_profiles(mvm->fw);
-	/* we create the 802.11 header and zero length SSID IE. */
-	hw->wiphy->max_sched_scan_ie_len =
-		SCAN_OFFLOAD_PROBE_REQ_SIZE - 24 - 2;
+	hw->wiphy->max_sched_scan_ie_len = iwl_mvm_max_scan_ie_len(mvm);
 	hw->wiphy->max_sched_scan_plans = IWL_MAX_SCHED_SCAN_PLANS;
 	hw->wiphy->max_sched_scan_plan_interval = U16_MAX;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index b588f1dcf20d5..bc2c240160b2c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -3148,8 +3148,6 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
-
 	/* for 6 GHZ band only PSC channels need to be added */
 	for (i = 0; i < params.n_channels; i++) {
 		struct ieee80211_channel *channel = params.channels[i];
@@ -3183,6 +3181,8 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		goto out;
 	}
 
+	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
+
 	uid = iwl_mvm_build_scan_cmd(mvm, vif, &hcmd, &params, type);
 	if (uid < 0) {
 		ret = uid;
-- 
2.53.0



