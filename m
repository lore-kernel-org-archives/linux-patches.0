Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370811DFDA8;
	Wed,  6 Nov 2024 12:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895901; cv=none; b=N5sXFYTH6laP/QkNYAllWZYOFXm862kNFRcBz/sL0D8luN9Y5rVHCiRoGO9JnVeENb3MNa6tv8sjVtAnCctT1wt5BW42uEXdI8/Hva8Kxq+veQ9CpwR9zntImhN+XSCpCAM8ikILSD9C0VK8JI+OjuVLRQNbFME+WCrcspniPT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895901; c=relaxed/simple;
	bh=Kg3/+FB/Vk+/N9tcQE4qGoUZehCLR+iw1zhLi3dzLlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSY/bhLjrtYYg7f9FdwW5JL77ZzWGlvltnp4cr/eHU27QA1cVb2JKycql0+qUM7VeeOVAu7LklP+QFi8M18VBUC/s1z1HbA5Bv/g39s3TXcqWfUignooS5ZCSdGmYiJb9ZszaoBF6gykocUmjjx5fpKsdoYGj64jzaCvGmZzNcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=raXLz7+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="raXLz7+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640F2C4CECD;
	Wed,  6 Nov 2024 12:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895900;
	bh=Kg3/+FB/Vk+/N9tcQE4qGoUZehCLR+iw1zhLi3dzLlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=raXLz7+lMio+IAd+GXtiW4lauBRBdAsWIXBnSKDV8y9uQhB2hJ9s3aHrX9c1ZRjvS
	 peyFK1YkbVQ9T73I0hYQpvN6osQVUS/dHeJe1S8lvS4YQLE72AlwPJC+Od0rf7WbKv
	 tkpEcOGRGFhikDd4O2TUy2YKSX2GkuhOV6DAADC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 022/245] wifi: iwlwifi: mvm: dont add default link in fw restart flow
Date: Wed,  6 Nov 2024 13:01:15 +0100
Message-ID: <20241106120319.781927785@linuxfoundation.org>
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

[ Upstream commit 734a377e1eacc5153bae0ccd4423365726876e93 ]

When we add the vif (and its default link) in fw restart we may
override the link that already exists. We take care of this but if
link 0 is a valid MLO link, then we will re-create a default link on
mvmvif->link[0] and we'll loose the real link we had there.

In non-MLO, we need to re-create the default link upon the interface
creation, this is fine. In MLO, we'll just wait for change_vif_links()
to re-build the links.

Fixes: bf976c814c86 ("wifi: iwlwifi: mvm: implement link change ops")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241010140328.385bfea1b2e9.I4a127312285ccb529cc95cc4edf6fbe1e0a136ad@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/intel/iwlwifi/mvm/mld-mac80211.c | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 27980d58e6956..c4ccc353a8fd4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -41,8 +41,6 @@ static int iwl_mvm_mld_mac_add_interface(struct ieee80211_hw *hw,
 	/* reset deflink MLO parameters */
 	mvmvif->deflink.fw_link_id = IWL_MVM_FW_LINK_ID_INVALID;
 	mvmvif->deflink.active = 0;
-	/* the first link always points to the default one */
-	mvmvif->link[0] = &mvmvif->deflink;
 
 	ret = iwl_mvm_mld_mac_ctxt_add(mvm, vif);
 	if (ret)
@@ -60,9 +58,19 @@ static int iwl_mvm_mld_mac_add_interface(struct ieee80211_hw *hw,
 				     IEEE80211_VIF_SUPPORTS_CQM_RSSI;
 	}
 
-	ret = iwl_mvm_add_link(mvm, vif, &vif->bss_conf);
-	if (ret)
-		goto out_free_bf;
+	/* We want link[0] to point to the default link, unless we have MLO and
+	 * in this case this will be modified later by .change_vif_links()
+	 * If we are in the restart flow with an MLD connection, we will wait
+	 * to .change_vif_links() to setup the links.
+	 */
+	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status) ||
+	    !ieee80211_vif_is_mld(vif)) {
+		mvmvif->link[0] = &mvmvif->deflink;
+
+		ret = iwl_mvm_add_link(mvm, vif, &vif->bss_conf);
+		if (ret)
+			goto out_free_bf;
+	}
 
 	/* Save a pointer to p2p device vif, so it can later be used to
 	 * update the p2p device MAC when a GO is started/stopped
@@ -1188,7 +1196,11 @@ iwl_mvm_mld_change_vif_links(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	if (old_links == 0) {
+	/* If we're in RESTART flow, the default link wasn't added in
+         * drv_add_interface(), and link[0] doesn't point to it.
+	 */
+	if (old_links == 0 && !test_bit(IWL_MVM_STATUS_IN_HW_RESTART,
+					&mvm->status)) {
 		err = iwl_mvm_disable_link(mvm, vif, &vif->bss_conf);
 		if (err)
 			goto out_err;
-- 
2.43.0



