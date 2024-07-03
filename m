Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B38416DEC3;
	Wed,  3 Jul 2024 11:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005239; cv=none; b=IcSjrYY1qggN2mFJ6e8XzL/Ku7uXuSaxtnfc3e6spL7ppkNI1K8z5gjSCGenK5VgQVrERDNYiUPH8LLtpFdQfekUrsRt81Px3Vp65rNUw5HgMROnI9YcWQ/CZAfreSBDzzhjKQXsjMqGcW1kMWJz8zMGIEprPbOtXE9nfE45sII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005239; c=relaxed/simple;
	bh=bkN6v4f0Ogh6iDPrmZUhGkvBG5JMwYxoP688quonjhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuX8fI9xrJ0+5YxVUauqoAp58Q6Q2z09KhXvkv+mW2oavts4MFq612eaxGH5Q0zL4jCdvPUq1C4WPSA0xnu+1DFM6Nbo+ne5NSNAUyybVXOo+FefnL5NDevo/wPfJZmzmJGoEEHtbOWM1k65cNM8JX7GjGMvddM6WQX+Nwi3Pxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0MaAiZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0MaAiZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68856C2BD10;
	Wed,  3 Jul 2024 11:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005238;
	bh=bkN6v4f0Ogh6iDPrmZUhGkvBG5JMwYxoP688quonjhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0MaAiZWuAPKcMtPTm4YfLp8JhyekKtfei7js8HA7G5pSNGTf10WNcYUiz7ROqzEY
	 xBXC5g3TpnMhgDnLi2CGTgKCb8SHrZq7FvYuMPfiW3Xxsvz1jr4tmCXLw2+iCFfAZY
	 /D2lTBfhwOeWii+TwMT6KxMYfL2Cgj9QWAlsQPr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/356] wifi: iwlwifi: mvm: check n_ssids before accessing the ssids
Date: Wed,  3 Jul 2024 12:35:43 +0200
Message-ID: <20240703102913.378710287@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 60d62757df30b74bf397a2847a6db7385c6ee281 ]

In some versions of cfg80211, the ssids poinet might be a valid one even
though n_ssids is 0. Accessing the pointer in this case will cuase an
out-of-bound access. Fix this by checking n_ssids first.

Fixes: c1a7515393e4 ("iwlwifi: mvm: add adaptive dwell support")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://msgid.link/20240513132416.6e4d1762bf0d.I5a0e6cc8f02050a766db704d15594c61fe583d45@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index c0ffa26bc5aaa..0605363b62720 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1312,7 +1312,7 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 		if (IWL_MVM_ADWELL_MAX_BUDGET)
 			cmd->v7.adwell_max_budget =
 				cpu_to_le16(IWL_MVM_ADWELL_MAX_BUDGET);
-		else if (params->ssids && params->ssids[0].ssid_len)
+		else if (params->n_ssids && params->ssids[0].ssid_len)
 			cmd->v7.adwell_max_budget =
 				cpu_to_le16(IWL_SCAN_ADWELL_MAX_BUDGET_DIRECTED_SCAN);
 		else
@@ -1414,7 +1414,7 @@ iwl_mvm_scan_umac_dwell_v10(struct iwl_mvm *mvm,
 	if (IWL_MVM_ADWELL_MAX_BUDGET)
 		general_params->adwell_max_budget =
 			cpu_to_le16(IWL_MVM_ADWELL_MAX_BUDGET);
-	else if (params->ssids && params->ssids[0].ssid_len)
+	else if (params->n_ssids && params->ssids[0].ssid_len)
 		general_params->adwell_max_budget =
 			cpu_to_le16(IWL_SCAN_ADWELL_MAX_BUDGET_DIRECTED_SCAN);
 	else
-- 
2.43.0



