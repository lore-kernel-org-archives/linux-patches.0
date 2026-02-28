Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371FE2DE717
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301104; cv=none; b=XzTf56FyqhcWAoJOVVpRo3wqd0itslnP/CLik7Wd1NT5+6jo57sBJ8APLZ1dy4M8v7yt82PNLl2zEQH6r3GDgYKxvbu3doOsEg/FbYqSXUeWt9ciLtYfC+BkE/Ovh1rDN9ZPXWowODNrcd/VgqWKFwmy24gPxIZxjxyBDNNvncw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301104; c=relaxed/simple;
	bh=J9hh2TDRS52hjtfXWjezCpSO0luovuop9OjDEah+r/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aill6lOJWQ7oJqdwDydFPB/lFTgx9TsYw6lyolk6vJECDCbc0g+dNRncgsVczB6gHvnmxf70b7yuV0Iad0DH2bBg4YVcdWMRP2hjuBJDzvnkR1dkcbcHrd5bLq5TO7KCemOgbkUxpZQhE0Ve9oJ5iawoamX0mJx/IgJOzEPhKgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iAq30uw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iAq30uw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC45C19423;
	Sat, 28 Feb 2026 17:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301104;
	bh=J9hh2TDRS52hjtfXWjezCpSO0luovuop9OjDEah+r/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAq30uw/CjQhRmuJIgg9nYwIWqJPMhpMCLcuPU35zXVjAHmrawYMgubhwnz2zhXod
	 CxGGoonZ9aO4NXPHfMalivU/t8VJ4N8PFGyvEZh+HLA3WaiH7nf3tt0GDwUP01Bay5
	 GBtpDi+Uiv4geQHBcEQCLHAw3w5JGuaALMregHgeAadDz6F6KtEOEcQ3fiLEqdJPfG
	 UjxtaXGD5m+ezTzlcHG7v+KZnYdqhFn2z3sVREvMyNC0HbYa1XCvDy4LoyASJTdoIN
	 rtEmN+GUoGJJxdDlXSr26stShtu7he+NTpmENz8ImeWxjrSAp7fBNP3yY12J9UCNHv
	 b+cKtdktg0gag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 257/752] wifi: iwlwifi: mvm: check the validity of noa_len
Date: Sat, 28 Feb 2026 12:39:28 -0500
Message-ID: <20260228174750.1542406-257-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 1e3fb3c4a8e6c581d0f4533dba887fabf53d607d ]

Validate iwl_probe_resp_data_notif::noa_attr::len_low since we are using
its value to determine the noa_len, which is later used for the NoA
attribute.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251110150012.99b663d9b424.I206fd54c990ca9e1160b9b94fa8be44e67bcc1b9@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 867807abde664..49ffc4ecee855 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1761,6 +1761,20 @@ void iwl_mvm_probe_resp_data_notif(struct iwl_mvm *mvm,
 
 	mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
+	/*
+	 * len_low should be 2 + n*13 (where n is the number of descriptors.
+	 * 13 is the size of a NoA descriptor). We can have either one or two
+	 * descriptors.
+	 */
+	if (IWL_FW_CHECK(mvm, notif->noa_active &&
+			 notif->noa_attr.len_low != 2 +
+			 sizeof(struct ieee80211_p2p_noa_desc) &&
+			 notif->noa_attr.len_low != 2 +
+			 sizeof(struct ieee80211_p2p_noa_desc) * 2,
+			 "Invalid noa_attr.len_low (%d)\n",
+			 notif->noa_attr.len_low))
+		return;
+
 	new_data = kzalloc(sizeof(*new_data), GFP_KERNEL);
 	if (!new_data)
 		return;
-- 
2.51.0

