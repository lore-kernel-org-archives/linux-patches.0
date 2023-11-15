Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCDC3C462
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p70Cp5NP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02747C433C7;
	Wed, 15 Nov 2023 19:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077121;
	bh=i8uKfHK23vQ0rdz2tVpVDmNrhSZGh7doKZ0humXa+0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p70Cp5NPLADiH8eCBfXWc77s8YQJDN3DXfeAQvP2mMtUG8dQk7FOM4eX+SltBYTEy
	 xb3CHE8rV1rKn7lB3MDclR/sUJysh9CRvO0bN6wBKLJ1/lOluwB8ZQhD+aisPbEr1f
	 lkorIbOZMDgP4tbg4swdH4ZiCJ7kNhlUWqEO1qsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/603] wifi: iwlwifi: mvm: update stations MFP flag after association
Date: Wed, 15 Nov 2023 14:11:16 -0500
Message-ID: <20231115191622.314642681@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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
index 5918c1f2b10c3..f852e5d770d9b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3791,6 +3791,12 @@ iwl_mvm_sta_state_assoc_to_authorized(struct iwl_mvm *mvm,
 
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



