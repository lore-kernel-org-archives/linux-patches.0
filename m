Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B81C15099D;
	Tue, 15 Oct 2024 11:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992269; cv=none; b=aslJMYYeNc6vmf0rq6N1bd9Kh1gdROJ9/qxa8MfSM86IBtjgjGm8vgBH7peL2DVj4e10agWH/e4lSdQ/aW2HSdDtOV2dCpzuOUpAtcrgQbypi/sXyRevOruV4bvPEVQTEn0uCPjg79doVSd+4wH3WGZYIXEpP+IchEv3VQXvdW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992269; c=relaxed/simple;
	bh=71hqkC3GGX5jUASLWU/NDfjVOa3vw6++c+bQb2F5mKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYN7VR5RpdWTKupVTbXWpjbZSfyOB+2mCcSZ1D5ippb9PMnhuKjpYLQniEn5tmnQ/BZjxMgMU/FaN4wTFGnCiMSkzGNlnXtT8Tnwx+1c5yjIFLRmAXiiWR882dUoWs6vD60dLo5F4uSMsyorkuALywyzq0EAkrWzs5dBLvWqCE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDsx+7Ph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDsx+7Ph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D05BC4CEC6;
	Tue, 15 Oct 2024 11:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992269;
	bh=71hqkC3GGX5jUASLWU/NDfjVOa3vw6++c+bQb2F5mKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDsx+7PhdlpXPwAWWDktC82LntcjmYhuO4NnRMFanzQTxC3A95ifhlBId8JwRXxEK
	 PDCfjMyOMEfE3NiXB7Mduz8B4xhYzsno7z3/lnGGjtbaF/LRvirWukVlRZUOO46uLU
	 cp9lYqHCmhyt6ZOmgrUwFjOtL38/zcy8M7Ot2njk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/691] wifi: iwlwifi: mvm: fix iwl_mvm_scan_fits() calculation
Date: Tue, 15 Oct 2024 13:20:15 +0200
Message-ID: <20241015112443.013268480@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4bab14ceef5f5..aa6ef64912056 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -834,8 +834,8 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
 	return ((n_ssids <= PROBE_OPTION_MAX) &&
 		(n_channels <= mvm->fw->ucode_capa.n_scan_channels) &
 		(ies->common_ie_len +
-		 ies->len[NL80211_BAND_2GHZ] +
-		 ies->len[NL80211_BAND_5GHZ] <=
+		 ies->len[NL80211_BAND_2GHZ] + ies->len[NL80211_BAND_5GHZ] +
+		 ies->len[NL80211_BAND_6GHZ] <=
 		 iwl_mvm_max_scan_ie_fw_cmd_room(mvm)));
 }
 
@@ -2775,18 +2775,16 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
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
@@ -2803,6 +2801,9 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		mvm->sched_scan_pass_all = SCHED_SCAN_PASS_ALL_DISABLED;
 	}
 
+out:
+	if (non_psc_included)
+		kfree(params.channels);
 	return ret;
 }
 
-- 
2.43.0



