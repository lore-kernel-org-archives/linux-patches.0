Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CCF3BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aI6dEpiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34157C433C9;
	Wed, 15 Nov 2023 19:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076185;
	bh=gfdIf6W3bwAslmrHnBBWqsoG2CVTMJMlpTuwkEsxA74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aI6dEpiNjnzuKNuUKoe/wR7ZHSpPtPBzscji+L3UbTrN7TWjoxRsYVR9QrJ18r7LH
	 k5Prv67XtmGDfZwOFMREzjiujv9MHrPfuaa1u9Lkgc/9Lp8tHKM5jpeTvvo5VPFVlz
	 qL7QOf9ZBNCUzTf/b4RGp2cF+RgJaZSI53JVV4fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 129/550] wifi: iwlwifi: mvm: Correctly set link configuration
Date: Wed, 15 Nov 2023 14:11:53 -0500
Message-ID: <20231115191609.626081076@linuxfoundation.org>
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

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 35b9281fb710ea9fa47dca56774f4a9606fe9154 ]

In case the link puncturing is changed such that the channel
is no longer punctured, configure the FW correctly indicating
the EHT parameters changed (with a 0 punctured map).

Allow EHT parameters configuration only when the link really
supports EHT.

Fixes: 55eb1c5fa4b2 ("wifi: iwlwifi: mvm: add support for the new LINK command")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20231004123422.2666ef86e032.I4b0e95722660acc5345ceefba7e8866a69572e8e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/link.c       | 13 ++++++++-----
 .../net/wireless/intel/iwlwifi/mvm/mld-mac80211.c   |  2 +-
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/link.c b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
index ace82e2c5bd91..4f8d2a3191ec7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
@@ -194,11 +194,14 @@ int iwl_mvm_link_changed(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		flags_mask |= LINK_FLG_MU_EDCA_CW;
 	}
 
-	if (link_conf->eht_puncturing && !iwlwifi_mod_params.disable_11be)
-		cmd.puncture_mask = cpu_to_le16(link_conf->eht_puncturing);
-	else
-		/* This flag can be set only if the MAC has eht support */
-		changes &= ~LINK_CONTEXT_MODIFY_EHT_PARAMS;
+	if (changes & LINK_CONTEXT_MODIFY_EHT_PARAMS) {
+		if (iwlwifi_mod_params.disable_11be ||
+		    !link_conf->eht_support)
+			changes &= ~LINK_CONTEXT_MODIFY_EHT_PARAMS;
+		else
+			cmd.puncture_mask =
+				cpu_to_le16(link_conf->eht_puncturing);
+	}
 
 	cmd.bss_color = link_conf->he_bss_color.color;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 778a311b500bc..a3a2e9a1fa7bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -653,7 +653,7 @@ iwl_mvm_mld_link_info_changed_station(struct iwl_mvm *mvm,
 	}
 
 	/* Update EHT Puncturing info */
-	if (changes & BSS_CHANGED_EHT_PUNCTURING && vif->cfg.assoc && has_eht)
+	if (changes & BSS_CHANGED_EHT_PUNCTURING && vif->cfg.assoc)
 		link_changes |= LINK_CONTEXT_MODIFY_EHT_PARAMS;
 
 	if (link_changes) {
-- 
2.42.0



