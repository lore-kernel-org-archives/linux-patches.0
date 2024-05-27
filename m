Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424A5262BE;
	Mon, 27 May 2024 19:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837978; cv=none; b=A6wFUyuveiHP8C0aWvjbLbU/G+T5D7CdZ4X/t7TC5DKmOFWC5KBhaAVo3qN0tdOb+M6uYUyk5JwhkIKbJde9RpWXUxZiIptrFrOA/n4AXnbQlcMTte7mheo3IWWr2N01zbTOg/EtTm8Ev8tsqDH9P9YUo1/2LMebGE9824M0NKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837978; c=relaxed/simple;
	bh=1g2E4Hwg2261a04yIzycm07Wg6HNqNtPgQvXpbYfNQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqYL7tn+Oi204J1bgZEKZJ9/NisRObu4fV+1U1qq4TiUgOnuBrwxSvaoiDExIPo8bh2dfHfvdvXCmeGWPw+17rmJBvbp1p0ursVQvRI4m7oG6JJ1SfI5KtVeL/R4COUSfAYiutXMYhEcrBY8WOG4sjMcpQ81B+4H/fcQ7FjcrGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vmkyl1dC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vmkyl1dC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD54C2BBFC;
	Mon, 27 May 2024 19:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837978;
	bh=1g2E4Hwg2261a04yIzycm07Wg6HNqNtPgQvXpbYfNQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vmkyl1dCyTNzx7YOKqISQI5HT9qd6cbPz7E2UjtnSwE5pbt5KmdlGEZw2AvfR6Inn
	 32rPxyqTE4fOVcnbhdBbxvfy62XEO0+fO8cXpS4dOGCjIz0dqA8DpzPeCPRd6LCjjY
	 uAw2Hzfrq3reRLejaQLviMiy2mGDZ18gbjNm3GMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 176/493] wifi: iwlwifi: reconfigure TLC during HW restart
Date: Mon, 27 May 2024 20:52:58 +0200
Message-ID: <20240527185636.107462641@linuxfoundation.org>
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
index 0aa54d33e3ba1..935cbe2026491 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -292,13 +292,8 @@ __iwl_mvm_mld_assign_vif_chanctx(struct iwl_mvm *mvm,
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



