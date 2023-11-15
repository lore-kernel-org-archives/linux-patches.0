Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476CF3BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qs412+dO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7596C433C9;
	Wed, 15 Nov 2023 19:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076176;
	bh=j/qFsTwM+y2PlXrmdCjiOcmAcbwwBSSrJfAl3tyqCWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qs412+dOyfkcPoDn1ty5wnevDknK9I8h/iXa9zXgHlROIluJmFEgdH2WXEWPe7p/y
	 7QKxZRvM0M4DDXbgOJ2Tw1+pDgUoeUK7MsDHUc70rhmtToz4ze2iimaOzei6IdbEWJ
	 ni1oeJ60xE7gDQsPJih9X15UA3K2CEeBCmJNWtuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 123/550] wifi: iwlwifi: mvm: update stations MFP flag after association
Date: Wed, 15 Nov 2023 14:11:47 -0500
Message-ID: <20231115191609.216853369@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 5a86dcb4a908845e6b7ff39b78fb1141b895408f ]

The management frames protection flag is always set when the station
is not yet authorized. However, it was not cleared after association
even if the association did not use MFP. As a result, all public
action frames are not parsed by fw (which will cause FTM to fail,
for example). Update the station MFP flag after the station is
authorized.

Fixes: 4c8d5c8d079e ("wifi: iwlwifi: mvm: tell firmware about per-STA MFP enablement")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230926110319.2488cbd01bde.Ic0f08b7d3efcbdce27ec897f84d740fec8d169ef@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index ce7905faa08ff..81b0b4284882e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3790,6 +3790,12 @@ iwl_mvm_sta_state_assoc_to_authorized(struct iwl_mvm *mvm,
 
 	iwl_mvm_rs_rate_init_all_links(mvm, vif, sta);
 
+	/* MFP is set by default before the station is authorized.
+	 * Clear it here in case it's not used.
+	 */
+	if (!sta->mfp)
+		return callbacks->update_sta(mvm, vif, sta);
+
 	return 0;
 }
 
-- 
2.42.0



