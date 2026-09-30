Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B03D3BA253;
	Wed, 30 Sep 2026 18:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794715; cv=none; b=BrhRu08vatbqNTBmuwnoyqYVj100G7mb3FZkfnG/+Fv2x0tflOwwbl9MIsO16FbZX+D7c3t7cDWvl4jgC6iBU29xMnrd9+IanGVBb7d7zpMb4iJR6H7QUflRgt2jMoBd+S2ZiDJ8imKXk4MCpn83xR+CUNc7oycqHBn2vk3BYX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794715; c=relaxed/simple;
	bh=GSsFm2NlLDZC4NoOXETzNHSEpo1iSFo/F75gF+OmqVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyIQQCUvBhfoVkIpDUyE5UetHHh/ZYi6huh+DI9072Z2UlmIlxAF8bY1o2Rs9SKjKOAGIXR8jrZBdPL4aXDHA3M/diiUGr5GPhOqhfAl79ycMpkwx+RK1V4XdHT13AR0rVdqV/tFK+RbUBsptiZtqRh+/AqHXpVXssMrEe7MoeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5EYhY3O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5EYhY3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FB91F000FF;
	Wed, 30 Sep 2026 18:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794714;
	bh=+rA8jy0nTilruSbDj3IYyqTQWLu0+jfzJmrIX253TNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5EYhY3OZ51UuWjwtR0VO2OxIr2ULJduAb63m+EBdqUm+2gF4vu75ZXfG/oXem8An
	 dtBlaaZkc3p5JSzHZeCS1oBfZMLdpzX+6AM+K4hknEuKqz54IwRdb+pJARs7kZdJ9S
	 ynMjKXB4CrmA2vHLHKFeMHvKopX4vFyyBwzntMvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0307/1193] wifi: iwlwifi: mvm: fix sched scan IE sizing
Date: Wed, 30 Sep 2026 17:16:31 +0200
Message-ID: <20260930152440.968827368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9f7dc8c33bd7c..4ec2ea44f4886 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -563,9 +563,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
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
index 8b22779e5b3e5..3bbf5f5b4f5f8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -3089,8 +3089,6 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
-
 	/* for 6 GHZ band only PSC channels need to be added */
 	for (i = 0; i < params.n_channels; i++) {
 		struct ieee80211_channel *channel = params.channels[i];
@@ -3124,6 +3122,8 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		goto out;
 	}
 
+	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
+
 	uid = iwl_mvm_build_scan_cmd(mvm, vif, &hcmd, &params, type);
 	if (uid < 0) {
 		ret = uid;
-- 
2.53.0



