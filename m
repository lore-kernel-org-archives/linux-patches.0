Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B9C1F943D;
	Wed,  6 Nov 2024 12:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897335; cv=none; b=Xpsht2K3s/zi3w4KrFvlMvaa28aRKjjo3CT018AmZS5ATOYJOV3FkC80AaIC+8dYQfNBG8IdJVi8DL6fwwsUrIe3AB+L1+2QVW3sodYm0R87taEgFU5WZXLKP+GjJuJOLgM5V2YTFoT/VBD8q5AHD73zvRbm+ksJ0UCp7ukXh8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897335; c=relaxed/simple;
	bh=SSxak3SB3+VAYBaq3bQoahgUS7tqZ3S7ACI8wyCxeIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/tOHttMbhdrwPbOA99a/YCFcsqdt+FwbyFFKrWg0ub12n3AMIeyYpZspc0WU1TfVBhamSAtlsiqh8T/bvGlP2k/RbpE3hHcV8/A3RcXM7wBiOpqFIfLCa+/AV5+Mtr15lcWL35JT2rxwAxPlA6aUPvO4NGqRB+peeajow5ml6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8PiRf8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8PiRf8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D39C4CECD;
	Wed,  6 Nov 2024 12:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897334;
	bh=SSxak3SB3+VAYBaq3bQoahgUS7tqZ3S7ACI8wyCxeIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8PiRf8+AxQkwQCyB3Yqipq/A5LvNr7vUHNnaGZ4JhKU0Q0x8v78tahjYlqCgTAHZ
	 cXmDw3WAMPeWb7F4OSiWPpwxy7jXtPnS94kL+LQqFU4StQ4is/Wt4KVurSTZpObr4P
	 IbP8OOaIQCeDsE4q/mCAlIaD6SFJCmf35QVOKblQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/151] wifi: iwlwifi: mvm: dont add default link in fw restart flow
Date: Wed,  6 Nov 2024 13:03:27 +0100
Message-ID: <20241106120309.366595327@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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
index 4d9a872818a52..d05a800cbdb4c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -39,8 +39,6 @@ static int iwl_mvm_mld_mac_add_interface(struct ieee80211_hw *hw,
 	/* reset deflink MLO parameters */
 	mvmvif->deflink.fw_link_id = IWL_MVM_FW_LINK_ID_INVALID;
 	mvmvif->deflink.active = 0;
-	/* the first link always points to the default one */
-	mvmvif->link[0] = &mvmvif->deflink;
 
 	ret = iwl_mvm_mld_mac_ctxt_add(mvm, vif);
 	if (ret)
@@ -58,9 +56,19 @@ static int iwl_mvm_mld_mac_add_interface(struct ieee80211_hw *hw,
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
@@ -1015,7 +1023,11 @@ iwl_mvm_mld_change_vif_links(struct ieee80211_hw *hw,
 
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



