Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E3415FA91;
	Mon, 27 May 2024 19:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837874; cv=none; b=Q6HMgBFLpDn6fA3IE4s8WcDylHE6e7BZzrjIpt7Og9EZbX2tGuc0fgu30cg+CFOw1JQu+9wNMNT242QniLVYKtf9vOglR3j+HGfaiLcGuYzJAz0I/an6Q9nJc+2Sh5uAYxDDCWGycSbEg/wx1qfq6RwtOcEEj9Ya+m0lmYEEylw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837874; c=relaxed/simple;
	bh=lX6uhSRmdp4O+lCrsFXrr7MySbvK72/TjJ//8XJ++sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ne6+Andm/ct5IKhMopNDVLI5C0LI/WbAnZO4mt/StpB0Duo9WUyMQX4fJqEdlFU86SK8Ybvu0w42PGxnAiSfSmq8MMrA4ISslS7duJZH0egr344T4AYQIg/9mKY8fk7IyXNxPZCEd19Upyh4uhMazDy40tlGm7c8DaHPP2oh3VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+i2NrLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+i2NrLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A82C32781;
	Mon, 27 May 2024 19:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837873;
	bh=lX6uhSRmdp4O+lCrsFXrr7MySbvK72/TjJ//8XJ++sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+i2NrLVvqisibsPIjVJassupKjRBvbYmPVT25amyy9Ol6cd3NIrThvw3oqIoCgoN
	 k5EulGB1Hr2uSLkMim0f4yNBB7hlX0iAfPJJHteyg5R76yy3wW2SwlMudFfW4Tcc7e
	 dQDQNAxqJ2ssEHPcFeB99uh0v3bAQ0iSw3HSx9NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 171/493] wifi: iwlwifi: mvm: allocate STA links only for active links
Date: Mon, 27 May 2024 20:52:53 +0200
Message-ID: <20240527185635.945929504@linuxfoundation.org>
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



