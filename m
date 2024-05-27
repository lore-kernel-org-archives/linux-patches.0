Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7871161935;
	Mon, 27 May 2024 19:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836560; cv=none; b=c6T9+FqJL/kR/0YgtU3wFvWJA+UE4YEcWWUv0Od5ztLIt955zKs+b3tvryVv3Gwg3jrNgBMsQ1Vr3gNK5MT33qQhIRhRjDXkJjZfRiGEx8sdabRjbd3PgEsdTyaZjhDKigAlivll16LW76YlCOUUjD1vISms6qv5zRfCPajRg5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836560; c=relaxed/simple;
	bh=qLJDf3/3NhUVOF6e7RfLz76xy59FkXsRXVWz/DYvab0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3eppgMiSuBwghOZkZPkj+X6cMlQdGgqbijAD3eO9CjknKLaRySpJiPm5KfTx8DZSWA+FWVqV8M+tYSIKtI7yMQw0Qt2ChIVABUvvNZ+M2L9TCTiLGBYiOj5+LiI7y4Q09LcUgYKGlB6JfZJUEAGBgcg/WOvIj7gjmJiNfQQeDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2XLm+zh/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2XLm+zh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA53CC32781;
	Mon, 27 May 2024 19:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836559;
	bh=qLJDf3/3NhUVOF6e7RfLz76xy59FkXsRXVWz/DYvab0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2XLm+zh/BdAdzCFZLzb9e1PzpKgHEj6fQ0PBotbe/tG8E7LL7FbbZhyh21oY4H4Zu
	 A/hfFKSuXvT63M6UNsLb6EoyuLEJMHW6/qVNKULwmgOxGtLO3Hhs7xCLLL9L0mdb6+
	 Qrbkmk2GmBF9JOGxMRafTih5213Bvb9I69qAPeco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 102/427] wifi: iwlwifi: mvm: allocate STA links only for active links
Date: Mon, 27 May 2024 20:52:29 +0200
Message-ID: <20240527185611.279952849@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 62bdd97598f8be82a24f556f78336b05d1c3e84b ]

For the mvm driver, data structures match what's in the firmware,
we allocate FW IDs for them already etc. During link switch we
already allocate/free the STA links appropriately, but initially
we'd allocate them always. Fix this to allocate memory, a STA ID,
etc. only for active links.

Fixes: 57974a55d995 ("wifi: iwlwifi: mvm: refactor iwl_mvm_mac_sta_state_common()")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240319100755.f2093ff73465.Ie891e1cc9c9df09ae22be6aad5c143e376f40f0e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
index 23e64a757cfe8..4ba1599ed71ca 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
@@ -582,14 +582,14 @@ static int iwl_mvm_mld_alloc_sta_links(struct iwl_mvm *mvm,
 				       struct ieee80211_sta *sta)
 {
 	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+	struct ieee80211_link_sta *link_sta;
 	unsigned int link_id;
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	for (link_id = 0; link_id < ARRAY_SIZE(sta->link); link_id++) {
-		if (!rcu_access_pointer(sta->link[link_id]) ||
-		    mvm_sta->link[link_id])
+	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+		if (WARN_ON(mvm_sta->link[link_id]))
 			continue;
 
 		ret = iwl_mvm_mld_alloc_sta_link(mvm, vif, sta, link_id);
-- 
2.43.0



