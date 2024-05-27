Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49F515FA91;
	Mon, 27 May 2024 19:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837975; cv=none; b=lUNsy7w+Iu1gmXi/c7mvhAOFKpFgh0m/U8dSlgEycyCka2Z37eVFkPk0t4rvQpqYm6XW0BNFMtqBxAc8bLs3zpNZ+BXXyR2U1dqgpCbpRXRAe3hLITTzTZe3FHvEPK4b9y3GrAnHoUcvdzwWxt++LUzTrdBBRVvcdeumhs4DnYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837975; c=relaxed/simple;
	bh=tXJPcfpj4kSxaaLP2p8Tvz+2MyXAW6xXUNKwA9afJ6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbRwxEcG9fyptP/ILkipg5PcHlRLPrXol2TEwrPwnybLLpk635d3DbC+Siv9UO3OJSKQLGNSGW67mSnXl801kVnUf6csggVeNHDabmqZPr5rkPIcPqc3/TFmNC5RvUAtzdXyVuZL2VKabZC1yUoKWExZtyprhnxM5UJDNjJhKag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9qVsxxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9qVsxxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481EAC2BBFC;
	Mon, 27 May 2024 19:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837975;
	bh=tXJPcfpj4kSxaaLP2p8Tvz+2MyXAW6xXUNKwA9afJ6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y9qVsxxQYF/iR6KeMwP6ke61+YbY+D+2XdS64WgaEcrKZqjjjWSsZMOzpPLnsubmo
	 fHoTKDC2R3jEgh5cXjfr4EXQn8gLGQybB7s8i6UgTE0O6wUk4EYjbRNNB7p5dUjvZU
	 X3rEyqynPKdNlAnqMwFfgt4vmt+xLnw7WzF7WdCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 175/493] wifi: iwlwifi: mvm: select STA mask only for active links
Date: Mon, 27 May 2024 20:52:57 +0200
Message-ID: <20240527185636.072823266@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 4ba1599ed71ca..dffdd00f8ab62 100644
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



