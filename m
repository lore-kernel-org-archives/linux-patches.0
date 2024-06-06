Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D2E1A186B;
	Thu,  6 Jun 2024 14:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683192; cv=none; b=myt8ReNd2x3fz+Skuhv7KXvFSThUjlT3ob5iRsuWqHJQw9ZCqFZQpvVdhKh4Pcg06oo8eoFxzis3L+g5mQzLwlAKhGYXJYmKhTIdcUHRYw4ljQmdMnYBKy3qzq4dmXi7W2/gOLvEr7m7Q0+GiIXA/DeEIpRkU1oxA5Ly3kFPKF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683192; c=relaxed/simple;
	bh=vakNZApLelEuaF9AHqRTF4/oFqUGizJ8PSqGhIIvHG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krsk1Ped7s6UaDeI96lLMlkw/ESm8tgS3IyBd6YXdgXJLmS+5pFgR+Hp+PD+35YtFzLe4ZxZM0/tA/UsGmq2JiJMdzsemHYtVgZ3ZO02vYSBy+TPKIDshQ6vXHVJX88BKRFPXn0Wem7rfRBZq/dIkId7+Fs6b/KuzXKd0O8n+Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8Q3OxfI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8Q3OxfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9495C2BD10;
	Thu,  6 Jun 2024 14:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683191;
	bh=vakNZApLelEuaF9AHqRTF4/oFqUGizJ8PSqGhIIvHG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8Q3OxfI/162Wk3uhHUURtZ8b/pgX4ASpnIy43SxfNp6CVU21LAIhMKhdBaC8EP9L
	 xsKPbtpjciHnNm3nHU8XqhC/RVgHH5ihw64005joSLi8InioD2+i0P4Uw2u2NZaJ4R
	 w4kDo5Zup1rVSEmXbJ/uC1Khd0tx5OlVzDp2ClgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/744] wifi: iwlwifi: mvm: select STA mask only for active links
Date: Thu,  6 Jun 2024 15:56:47 +0200
Message-ID: <20240606131736.748671587@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2783ab506eaa36dbef40bda0f96eb49fe149790e ]

During reconfig, we might send keys, but those should be only
sent to already active link stations. Iterate only active ones
to fix that issue.

Fixes: aea99650f731 ("wifi: iwlwifi: mvm: set STA mask for keys in MLO")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240320232419.c6818d1c6033.I6357f05c55ef111002ddc169287eb356ca0c1b21@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
index 3907707e87716..8f5b8b26909da 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
@@ -9,7 +9,9 @@
 u32 iwl_mvm_sta_fw_id_mask(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			   int filter_link_id)
 {
+	struct ieee80211_link_sta *link_sta;
 	struct iwl_mvm_sta *mvmsta;
+	struct ieee80211_vif *vif;
 	unsigned int link_id;
 	u32 result = 0;
 
@@ -17,26 +19,27 @@ u32 iwl_mvm_sta_fw_id_mask(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		return 0;
 
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	vif = mvmsta->vif;
 
 	/* it's easy when the STA is not an MLD */
 	if (!sta->valid_links)
 		return BIT(mvmsta->deflink.sta_id);
 
 	/* but if it is an MLD, get the mask of all the FW STAs it has ... */
-	for (link_id = 0; link_id < ARRAY_SIZE(mvmsta->link); link_id++) {
-		struct iwl_mvm_link_sta *link_sta;
+	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+		struct iwl_mvm_link_sta *mvm_link_sta;
 
 		/* unless we have a specific link in mind */
 		if (filter_link_id >= 0 && link_id != filter_link_id)
 			continue;
 
-		link_sta =
+		mvm_link_sta =
 			rcu_dereference_check(mvmsta->link[link_id],
 					      lockdep_is_held(&mvm->mutex));
 		if (!link_sta)
 			continue;
 
-		result |= BIT(link_sta->sta_id);
+		result |= BIT(mvm_link_sta->sta_id);
 	}
 
 	return result;
-- 
2.43.0



