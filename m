Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC362198E90;
	Thu,  5 Sep 2024 09:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529856; cv=none; b=hViQBilO7Pg0s1/e06fD5fMv0t3+vNklnOtOXrBUd+76jpo7hKKQZASSmZ+AzErWu+rHDexEhiQIMVF8jSigcPfMYIKuG3/Kg/K3hFc48fMKiBg5XNnHlRUH3kPb0mT9pPJUdADXOY7qFVvtIO4xHa9PbNtgxCF3uFGxHy3v0Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529856; c=relaxed/simple;
	bh=7QGrt5tQJib+Kdssd7E3soRWyCwWKpPO7ymHnQ2xM5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwUaP0mQ2xDXC3TlLVwUZpYnpie5w3Lw+syZ6In/aJ+BQ/L0KTZ4eRagaE/LH1pnm/t0kN2wEVYNd2nk1smMpwxGIsEEDDMJrs5iLyxICI81Lj0dyPM5NjBCJw4j8Fnt5+Vslvxqr7cVJfLNJ9g7zCwx3KynqF2UmgWzpIJqOoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SS0+hOUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SS0+hOUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C9FC4CEC3;
	Thu,  5 Sep 2024 09:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529856;
	bh=7QGrt5tQJib+Kdssd7E3soRWyCwWKpPO7ymHnQ2xM5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SS0+hOUDAiHoOS0Y8MAoDsmE5y4Z20nQzIbS+S5OgLvHg4Dbzy5GyHBXmraXp09T8
	 Osov/1rQImZsqJ6Lc8I5wt3Ipn7AAZZ1X31wkW3RuheOSvSejCUyVah8f+dcw+6hxb
	 dqehEGjZiO/mUObao5h0i1LlFKYApVbUgScteEKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 123/184] wifi: iwlwifi: mvm: use only beacon BSS load for active links
Date: Thu,  5 Sep 2024 11:40:36 +0200
Message-ID: <20240905093737.030637966@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d9b7531fe98a0c2a0387270557cf0a514c28dd28 ]

For active links, don't take information that may have been
received in probe responses, as those are not protected. For
inactive links, there may not be a choice.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240527190228.6947dc462fa9.I2076961211d6785c8a15b4308e0e87a413148222@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/link.c      | 14 ++++++++++++--
 .../net/wireless/intel/iwlwifi/mvm/tests/links.c   |  1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/link.c b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
index 92ac6cc40faa..61b5648d3ab0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
@@ -504,17 +504,27 @@ iwl_mvm_get_puncturing_factor(const struct ieee80211_bss_conf *link_conf)
 static unsigned int
 iwl_mvm_get_chan_load(struct ieee80211_bss_conf *link_conf)
 {
+	struct ieee80211_vif *vif = link_conf->vif;
 	struct iwl_mvm_vif_link_info *mvm_link =
 		iwl_mvm_vif_from_mac80211(link_conf->vif)->link[link_conf->link_id];
 	const struct element *bss_load_elem;
 	const struct ieee80211_bss_load_elem *bss_load;
 	enum nl80211_band band = link_conf->chanreq.oper.chan->band;
+	const struct cfg80211_bss_ies *ies;
 	unsigned int chan_load;
 	u32 chan_load_by_us;
 
 	rcu_read_lock();
-	bss_load_elem = ieee80211_bss_get_elem(link_conf->bss,
-					       WLAN_EID_QBSS_LOAD);
+	if (ieee80211_vif_link_active(vif, link_conf->link_id))
+		ies = rcu_dereference(link_conf->bss->beacon_ies);
+	else
+		ies = rcu_dereference(link_conf->bss->ies);
+
+	if (ies)
+		bss_load_elem = cfg80211_find_elem(WLAN_EID_QBSS_LOAD,
+						   ies->data, ies->len);
+	else
+		bss_load_elem = NULL;
 
 	/* If there isn't BSS Load element, take the defaults */
 	if (!bss_load_elem ||
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tests/links.c b/drivers/net/wireless/intel/iwlwifi/mvm/tests/links.c
index f49e3c98b1ba..991dc875a7ea 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tests/links.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tests/links.c
@@ -208,6 +208,7 @@ static void setup_link_conf(struct kunit *test)
 	bss_load->channel_util = params->channel_util;
 
 	rcu_assign_pointer(bss.ies, ies);
+	rcu_assign_pointer(bss.beacon_ies, ies);
 }
 
 static void test_link_grading(struct kunit *test)
-- 
2.43.0



