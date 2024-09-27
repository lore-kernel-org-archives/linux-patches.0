Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3621779BD;
	Fri, 27 Sep 2024 12:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439897; cv=none; b=V7B4pOJcX7RSyJcA1b/y/tGHTe+2V71JGcMo56Bee+83krsDUSHmIrTLBOklQZtA17i/QHynhggMqzIB5QfQjhiHhG7Ggz68/fDbvTO+TWhnwmloaxQ7GiFDR84GdTL/j4ppj92KVdhQgw+FNz630Oij5u5NciJ5JIUybu8lkhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439897; c=relaxed/simple;
	bh=IVDplkoSsoFNWzYHfysuEgRtNweYsAQPs9ffMuBx8A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jh+H2ItthTdgCBtc02NOc9vE+0olyqC35m+rv7Wdm8SBvdjUw19SFiSBfMiTyD37NmaLbruWFz7PkLMLeYwQ4A/d2XN/iv10orHkNlLWCuDzrJOiTN8MdxCN+4jEV+IndYUwbmZKivJAHZYb2vLmt/RdfwkRKnypD0wjesGfKXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ek7trO+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ek7trO+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C026CC4CEC4;
	Fri, 27 Sep 2024 12:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439897;
	bh=IVDplkoSsoFNWzYHfysuEgRtNweYsAQPs9ffMuBx8A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ek7trO+5eUcs1B7C44Kp+ErxjCFkV3HRQE7mzU2762bLGBW0/aToB5sR0RFY60C42
	 osok0j6vM2w3mvRdG+aRyw5z7Av87fknv2se4YKiabgJhBFW+6QcqHhoJma1rxfNZR
	 PjvDciA1T2PZZU01R1gQrGWISQW1WxrlTouvAH0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 15/54] wifi: iwlwifi: mvm: fix iwl_mvm_scan_fits() calculation
Date: Fri, 27 Sep 2024 14:23:07 +0200
Message-ID: <20240927121720.314942062@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

[ Upstream commit d44162280899c3fc2c6700e21e491e71c3c96e3d ]

The calculation should consider also the 6GHz IE's len, fix that.
In addition, in iwl_mvm_sched_scan_start() the scan_fits helper is
called only in case non_psc_incldued is true, but it should be called
regardless, fix that as well.

Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240825191257.7db825442fd2.I99f4d6587709de02072fd57957ec7472331c6b1d@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 23 ++++++++++---------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 9ca90c0806c0f..c61068144c638 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -830,8 +830,8 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
 	return ((n_ssids <= PROBE_OPTION_MAX) &&
 		(n_channels <= mvm->fw->ucode_capa.n_scan_channels) &
 		(ies->common_ie_len +
-		 ies->len[NL80211_BAND_2GHZ] +
-		 ies->len[NL80211_BAND_5GHZ] <=
+		 ies->len[NL80211_BAND_2GHZ] + ies->len[NL80211_BAND_5GHZ] +
+		 ies->len[NL80211_BAND_6GHZ] <=
 		 iwl_mvm_max_scan_ie_fw_cmd_room(mvm)));
 }
 
@@ -3118,18 +3118,16 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		params.n_channels = j;
 	}
 
-	if (non_psc_included &&
-	    !iwl_mvm_scan_fits(mvm, req->n_ssids, ies, params.n_channels)) {
-		kfree(params.channels);
-		return -ENOBUFS;
+	if (!iwl_mvm_scan_fits(mvm, req->n_ssids, ies, params.n_channels)) {
+		ret = -ENOBUFS;
+		goto out;
 	}
 
 	uid = iwl_mvm_build_scan_cmd(mvm, vif, &hcmd, &params, type);
-
-	if (non_psc_included)
-		kfree(params.channels);
-	if (uid < 0)
-		return uid;
+	if (uid < 0) {
+		ret = uid;
+		goto out;
+	}
 
 	ret = iwl_mvm_send_cmd(mvm, &hcmd);
 	if (!ret) {
@@ -3146,6 +3144,9 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		mvm->sched_scan_pass_all = SCHED_SCAN_PASS_ALL_DISABLED;
 	}
 
+out:
+	if (non_psc_included)
+		kfree(params.channels);
 	return ret;
 }
 
-- 
2.43.0



