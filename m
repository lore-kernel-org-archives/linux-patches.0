Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB281EB22;
	Tue, 13 Feb 2024 17:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845790; cv=none; b=EUYjNkLZo3NqrE5loTzrzj+KLqTQpqUPvSWnj8PKbzDyH02BkEx32JKi0KCaNEQfbdnQu12M1r1IaRb1adDZJPT+wNNM6NuH2gFftj7+X9iQkx8fxeD7mB6K1njzlgayrqeG3N2pKybeX0GIIjENEkqFGF7/rbSVwEtZRUc5sXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845790; c=relaxed/simple;
	bh=7L0w9XNh4e0xuxWg1D6qqpcrOsJ5GkAgHc2uzxkkrA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYjO7Zskt6jUsRZcayCuI0xEXRwUPpgVzOPWdTWPHcbuAWAXesDK3Y3CSrL1v4gZl4RIfdEh0zuvWwgZOOup1+AMHDC0Txorz8Pan++RXOd4A8ACAoINXGnE/SRmQENmkY1krmbpTi2mpEMAuG8bBAfDPCkzz+obae5/250K8IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9lF9lYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9lF9lYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FBCC43390;
	Tue, 13 Feb 2024 17:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845790;
	bh=7L0w9XNh4e0xuxWg1D6qqpcrOsJ5GkAgHc2uzxkkrA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9lF9lYQSUbezzL7g6UKaunz3QygGayOANS1tYUY6SMB/dXjbz0Bg9ep5PO/O8P/t
	 mEjHp24bPBTA9+QnmmC540A9nII01jSoSJjPjVkp4Tl5xr0dAkSODWKtVYwMlB7xSN
	 oeIyhVER9l1+O/xlrfSHA+V56VIs/hzCcNuWPqeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 029/124] wifi: iwlwifi: exit eSR only after the FW does
Date: Tue, 13 Feb 2024 18:20:51 +0100
Message-ID: <20240213171854.582382053@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 16867c38bcd3be2eb9016a3198a096f93959086e ]

Currently the driver exits eSR by calling
iwl_mvm_esr_mode_inactive() before updating the FW
(by deactivating one of the links), and therefore before
sending the EML frame notifying that we are no longer in eSR.

This is wrong for several reasons:
1. The driver sends SMPS activation frames when we are still in eSR
   and SMPS should be disabled when in eSR
2. The driver restores RLC configuration as it was before eSR
   entering, and RLC command shouldn't be sent in eSR

Fix this by calling iwl_mvm_esr_mode_inactive() after FW update

Fixes: 12bacfc2c065 ("wifi: iwlwifi: handle eSR transitions")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://msgid.link/20240201155157.d8d9dc277d4e.Ib5aee0fd05e35b1da7f18753eb3c8fa0a3f872f3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 1f36e934ef69..893b69fc841b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -438,6 +438,9 @@ __iwl_mvm_mld_unassign_vif_chanctx(struct iwl_mvm *mvm,
 		mvmvif->ap_ibss_active = false;
 	}
 
+	iwl_mvm_link_changed(mvm, vif, link_conf,
+			     LINK_CONTEXT_MODIFY_ACTIVE, false);
+
 	if (iwl_mvm_is_esr_supported(mvm->fwrt.trans) && n_active > 1) {
 		int ret = iwl_mvm_esr_mode_inactive(mvm, vif);
 
@@ -449,9 +452,6 @@ __iwl_mvm_mld_unassign_vif_chanctx(struct iwl_mvm *mvm,
 	if (vif->type == NL80211_IFTYPE_MONITOR)
 		iwl_mvm_mld_rm_snif_sta(mvm, vif);
 
-	iwl_mvm_link_changed(mvm, vif, link_conf,
-			     LINK_CONTEXT_MODIFY_ACTIVE, false);
-
 	if (switching_chanctx)
 		return;
 	mvmvif->link[link_id]->phy_ctxt = NULL;
-- 
2.43.0



