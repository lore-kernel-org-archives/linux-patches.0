Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9471DF978;
	Wed,  6 Nov 2024 12:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895888; cv=none; b=VKnfFo0t+TBYDTjxJ68JAwWCeeVsyVezPQDgrvNOmZhTakS7C1TuKL5jqmW8KftyqQZ9fqfv076rqKtGqahBUrP4rWq2iEo0ZuF2x9Qe6JVYbo4rR+Q4B5WYDcfxjWSNiQBo3qkAAWGUNcauz7aEPKUh53GqdV2DMfYZGIc1sW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895888; c=relaxed/simple;
	bh=7JME/qD7oQuttpd5vCbtWuQ//Zv0xh4OTdp6yFz8bTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7xI0/vqlP2BDjU1LpPgNd7UJRFMMU+5TVYWiBTTu5tQgwqdTzTpCdCRlCH2etbeWa2UTgdxaJqGYkAc7bssjOD0EfZSoZbdDYjB99GQeIIY1j9RlpIF1crWWEvzdPfQKK94HUGaBzROdeD9t39FiGPHddkW1UI1asM7jClhRO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2/gWpnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2/gWpnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F4FC4CECD;
	Wed,  6 Nov 2024 12:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895888;
	bh=7JME/qD7oQuttpd5vCbtWuQ//Zv0xh4OTdp6yFz8bTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2/gWpnLUURNT27BsOLO5BA6dNbF3B0/PBse6iyc7NO1E4u4kRFoBuc/58fdNiKGs
	 6SBLCcYoiUZ9oqbNuPqj2NGLPXRVcgrbPCLHRRKIxWvLh08ZloCENeX0pd1f+1vD5N
	 Bz9bVECdOrb5H0lyZYl9W3GAb/6lR70Z1Daa+BLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 019/245] wifi: iwlwifi: mvm: dont leak a link on AP removal
Date: Wed,  6 Nov 2024 13:01:12 +0100
Message-ID: <20241106120319.708814924@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 3ed092997a004d68a3a5b0eeb94e71b69839d0f7 ]

Release the link mapping resource in AP removal. This impacted devices
that do not support the MLD API (9260 and down).
On those devices, we couldn't start the AP again after the AP has been
already started and stopped.

Fixes: a8b5d4809b50 ("wifi: iwlwifi: mvm: Configure the link mapping for non-MLD FW")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241010140328.c54c42779882.Ied79e0d6244dc5a372e8b6ffa8ee9c6e1379ec1d@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 1ebcc6417ecef..e38cff6176dd3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1951,7 +1951,6 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 		mvm->p2p_device_vif = NULL;
 	}
 
-	iwl_mvm_unset_link_mapping(mvm, vif, &vif->bss_conf);
 	iwl_mvm_mac_ctxt_remove(mvm, vif);
 
 	RCU_INIT_POINTER(mvm->vif_id_to_mac[mvmvif->id], NULL);
@@ -1960,6 +1959,7 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 		mvm->monitor_on = false;
 
 out:
+	iwl_mvm_unset_link_mapping(mvm, vif, &vif->bss_conf);
 	if (vif->type == NL80211_IFTYPE_AP ||
 	    vif->type == NL80211_IFTYPE_ADHOC) {
 		iwl_mvm_dealloc_int_sta(mvm, &mvmvif->deflink.mcast_sta);
-- 
2.43.0



