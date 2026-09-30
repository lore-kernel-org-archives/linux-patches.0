Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB8151DAFF;
	Wed, 30 Sep 2026 17:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791169; cv=none; b=q1EngLI9HDaiKCfbvepwGlhZ/dn2N0vlEQG5jTsP9nI2cEDjcv4ZhHupvP9mVI6FWr2m+MPUdMMgAz6qTf5Fl3TUM6fc9ITD3/Ek+wfn/BF7WhOPIT0MMJJW7jXIX8J/6G3dSLx3h5y4tFP5A3YaZqn4HwwzE5cZIEHCt3Xvdms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791169; c=relaxed/simple;
	bh=8debpu+vThyOVhva7CbnSdVmuLGLPAwuIzgEl+jN6VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZY5sMNPOcYCExsYEIdOY/UkVnojO2qGckEvC6NNUeXkAJgwmlRPQqxYnDw32wKGldYJViFFZWtMFbxW7bBOH6SNIJDr6KxTZ6Nt3XcWIwtQL7G0KJwM0mZ+xTnHOOb97Sz1jpu0ve1HcnwAJQWa9kh3cSAKfd82ZDpUAzTFglc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmYQQSY3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmYQQSY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B571F000FF;
	Wed, 30 Sep 2026 17:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791167;
	bh=HljsG5A3tkAbk8RmS8SEdD+8c7vMiD3W0CfXRG23FNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmYQQSY3Z5wFmLs4nMB34B1cpAGoNzn37LuUeQ2PKhnWzv31ZtF6f4psls2uJo7NB
	 1MxyZjmUUIdWqAPudSe6yV5qMvllTsqmCEqkRsB2aQkgCeqQOGMR9+0RK8AvHnrwQK
	 7sXHSO72HseI6sZcHRmqNdUfQd7ucY02CSvTP22I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 207/752] wifi: iwlwifi: mvm: fix sched scan IE sizing
Date: Wed, 30 Sep 2026 17:21:17 +0200
Message-ID: <20260930152402.710427708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 080ce8e4e2439..614b2ff754099 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -586,9 +586,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
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
index 3d0396b8afaab..534b46928c8ff 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -2746,8 +2746,6 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
-
 	/* for 6 GHZ band only PSC channels need to be added */
 	for (i = 0; i < params.n_channels; i++) {
 		struct ieee80211_channel *channel = params.channels[i];
@@ -2781,6 +2779,8 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		goto out;
 	}
 
+	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
+
 	uid = iwl_mvm_build_scan_cmd(mvm, vif, &hcmd, &params, type);
 	if (uid < 0) {
 		ret = uid;
-- 
2.53.0



