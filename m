Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC30D1A2567;
	Thu,  6 Jun 2024 14:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683193; cv=none; b=Pven0HFZxr1Y6CQxg/gtq1ilfvtpqRkssqj5iu/Or0U3JsTLtxhCB3V8Xt0qukQMLt+5qu3bZTcy27AyoUoFoV0iF83ahXp658uTSu8hIrdStflI+21Vpe7dCKqlae04lORW6kVCg9Tkakhb9GVQKnKt8+XVMCWmesxAjxfmUUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683193; c=relaxed/simple;
	bh=OvqnIqJJuX4kIfXIh10d1F9aQy5SSHvkUcapL36lQSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+1tGt8zEIQFOk5hxufEBrGVDNNFA6V4k4VoTUzM+CLvZDgnNtkUsL+tYmB/EMbYzWBSVIIFnBT4a94CP0BHyVesjua6yZnSSLFW1YGDqgvvgeW/0URzarewKKPcsII0HobAabnJnf0n3KGPJD18PmDWlcKhZX8/2Bu6/CMY4jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7HVg3GU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7HVg3GU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD84EC32781;
	Thu,  6 Jun 2024 14:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683192;
	bh=OvqnIqJJuX4kIfXIh10d1F9aQy5SSHvkUcapL36lQSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7HVg3GUNgIe9T0UqdKw487vZLN8ZkhRu0pziyH1j+BEA2PO8sqgz8k8zl1/apPJy
	 5im5cWrzNk6t3nDnT7ScYNnutv3XaH6GD4rhnTXicb+v01lvBDNfaPxyqcd5InqCaO
	 qRrjhqhtcfryBJYV9WjyOXVqK6rBAa6o3Qw2tDuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/744] wifi: iwlwifi: reconfigure TLC during HW restart
Date: Thu,  6 Jun 2024 15:56:48 +0200
Message-ID: <20240606131736.784147853@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 96833fb3c7abfd57bb3ee2de2534c5a3f52b0838 ]

Since the HW restart flow with multi-link is very similar to
the initial association, we do need to reconfigure TLC there.
Remove the check that prevented that.

Fixes: d2d0468f60cd ("wifi: iwlwifi: mvm: configure TLC on link activation")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240320232419.a00adcfe381a.Ic798beccbb7b7d852dc976d539205353588853b0@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 2d1fd7ac8577f..e22db69d99909 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -296,13 +296,8 @@ __iwl_mvm_mld_assign_vif_chanctx(struct iwl_mvm *mvm,
 	 * this needs the phy context assigned (and in FW?), and we cannot
 	 * do it later because it needs to be initialized as soon as we're
 	 * able to TX on the link, i.e. when active.
-	 *
-	 * Firmware restart isn't quite correct yet for MLO, but we don't
-	 * need to do it in that case anyway since it will happen from the
-	 * normal station state callback.
 	 */
-	if (mvmvif->ap_sta &&
-	    !test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
+	if (mvmvif->ap_sta) {
 		struct ieee80211_link_sta *link_sta;
 
 		rcu_read_lock();
-- 
2.43.0



