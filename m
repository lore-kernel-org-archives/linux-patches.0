Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13618154C05;
	Tue, 23 Jan 2024 00:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969399; cv=none; b=p4mAJp2EvV0dkEYPXpX2OcmVKp4oJ2UmuWCnQc9ru/h7T/iqQxqjObGJwJirqY06hTlDFb5DliSxCjK6kX90N6fK94xs59uf0UpglbV/6hQn3QoOgkodIMSUQj8MUqHGSwuXSui9YBK/Na1wGtnUHRr5xpVt60fzok22qjlF3MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969399; c=relaxed/simple;
	bh=zt6tEt9dr9uStX2a1XFZvKwbnk0n0kfWZqGmXyLPHZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rf1nK/30ATZC3IbM2KSWpthrcE0J550Ul1ZGNYMEn/r0RpPtDw2aetU8dpCtm4rk8/OWufUt87eLABGHAXuYLkkQrXRzxLmGn83MHQ/Z9DJaEIgaEDJuji9FPnuz/8rLSI9DvLj/jTobjjCzlB+IR9ku0I3N9VWz5ZE/HHUyVOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWXwJh1N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWXwJh1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73835C43399;
	Tue, 23 Jan 2024 00:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969398;
	bh=zt6tEt9dr9uStX2a1XFZvKwbnk0n0kfWZqGmXyLPHZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWXwJh1NBcaPspPJmZyURhdIBRLWYLNn/6rTF9JR3KmNG09KNDbWDZQf5v2SE1xWW
	 xTBvtd5Vl663DwHvFDlK1mJNPNUe4l+QXtGaS8Zz7DO8adflDkTHcBB2PJ4wTqdSCz
	 qjOVt3/kBcxooU9/B+hpkX3tWDAD1BSTVGnDOBcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 220/641] wifi: iwlwifi: assign phy_ctxt before eSR activation
Date: Mon, 22 Jan 2024 15:52:04 -0800
Message-ID: <20240122235824.831619915@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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
index 8e263acbc763..61170173f917 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -271,17 +271,17 @@ __iwl_mvm_mld_assign_vif_chanctx(struct iwl_mvm *mvm,
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



