Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED5562805;
	Tue, 23 Jan 2024 01:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975026; cv=none; b=H7jAO33FSmCQtWLHQi7M4fg5TPg+vbZzG/SKUkHrTtn4dMgK0KwZ1CdHuAO7TRXeL7AAnUy9bMg6nDNJcT/n6Av8X7KtVKaHblflFjrbPE46lNV0mx6+5E+sFLMO35moNMDsvd1kQvPA6YPpETKmn+3DZTgUo05ANfWSqruGy4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975026; c=relaxed/simple;
	bh=nb8Laz0XxKjPQV07DCwHHqPNxJzMEf/osc4w3WZikck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbldfiIlbpwyou+n4YVtpwHZlJ+LNRD0OuCfNtlHbOWGcFCiIyp7sjv4ASVGJyDD7oo0C/y38DmRVq/ste4R19Q3JGr+PIq/6DrdVyBv8Qa1Ys3WPhn1hzj0i9+Qi6/1T0HfMAWF/B0L35xrWbk2BiQY67r2gip2M0LJV8gCPpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZw4aOc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZw4aOc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34524C43390;
	Tue, 23 Jan 2024 01:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975026;
	bh=nb8Laz0XxKjPQV07DCwHHqPNxJzMEf/osc4w3WZikck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZw4aOc7gQsgFDExA0S6JwZL6D564HeOTvqDnMRH05UU+WdmZ7GHdmQIYmCq62ucu
	 Zm5qOUR4iADvmocXkMaIsLjea4BhVv26ZYAg2ng074gnUUOQOQ3NhMBvAiqoPnhQQv
	 O/M0BRLTo6HZBml5msGw+UsjlAWDKwJh3x9Js5QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 202/583] wifi: iwlwifi: assign phy_ctxt before eSR activation
Date: Mon, 22 Jan 2024 15:54:13 -0800
Message-ID: <20240122235818.171712139@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 9b6614e5ead5d19a71893bcca3f1a6569ca0c456 ]

eSR is activated when a chanctx is assigned to more than one link.
During eSR activation we should disable RLC for both phys, and configure
the FW with a special phy command for both phys.
Currently we assign the phy_ctxt to the link only after eSR activation,
so RLC is not disabled for the new phy_ctxt, and a cmd is not sent to FW.
Fix this by first assigning the new phy_ctxt to the link and then
doing the eSR activation.

Fixes: 12bacfc2c065 ("wifi: iwlwifi: handle eSR transitions")
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231219215605.3d94507f5d9a.I537fcd73aedf94c7348c03157e486f24301fef14@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 2ddb6f763a0b..1e58f0234293 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -269,17 +269,17 @@ __iwl_mvm_mld_assign_vif_chanctx(struct iwl_mvm *mvm,
 		}
 	}
 
+	mvmvif->link[link_id]->phy_ctxt = phy_ctxt;
+
 	if (iwl_mvm_is_esr_supported(mvm->fwrt.trans) && n_active > 1) {
 		mvmvif->link[link_id]->listen_lmac = true;
 		ret = iwl_mvm_esr_mode_active(mvm, vif);
 		if (ret) {
 			IWL_ERR(mvm, "failed to activate ESR mode (%d)\n", ret);
-			return ret;
+			goto out;
 		}
 	}
 
-	mvmvif->link[link_id]->phy_ctxt = phy_ctxt;
-
 	if (switching_chanctx) {
 		/* reactivate if we turned this off during channel switch */
 		if (vif->type == NL80211_IFTYPE_AP)
-- 
2.43.0



