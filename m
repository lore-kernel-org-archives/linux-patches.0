Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990A41F09B3;
	Fri, 21 Nov 2025 13:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731181; cv=none; b=sLCLFEOgKD7wbif7/nMlnQMVwnnYymQZiAB8ccEUoiu3dltAgO/bopWJAvtQYgdqmwax3R0r2qhedWO7b4x5KjX5oV2jLUPYX59FfK0TaUbdHHdK3FkcK5vkUc3UG3i+JS2EOS+1c9xt0Q/GD8Wi1pRf51tZovdB0ptaHhaFj4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731181; c=relaxed/simple;
	bh=qAD1+3hFDrnE6fypgSziLWSkhQXI/zZ9pfZVJ26bcrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+QcmZhE2TqqD839e0lYxbWcj3nApABAHIsm6MObkYGmtcZrnvaTr8ma6agY7clUlLfq5Wu0KbaF58saoGTtYxXkUrOFuj5kpOePaxVClNfQk61pNkvGfCbZUEUpqTlfog2SQVrSK/dxZKZD/Yr1M0Qg7gm2Yvhig29tzB9gZxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVVcOdmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVVcOdmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25374C4CEF1;
	Fri, 21 Nov 2025 13:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731181;
	bh=qAD1+3hFDrnE6fypgSziLWSkhQXI/zZ9pfZVJ26bcrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVVcOdmQk7ru9LR4tvMpOCtJgswIfnizA/aiIvvNqOF1eRMxjbehXolxDeoGSEEbt
	 b0ljyw5Y0rJNQHYVoEBYksiE0naWV7jvACFRbhPn38u5WDugrq8jRdBGsDhpoFGel9
	 h4peSJLqKjEkcibWiJMeekP/IdgblWJ2eZaa6TBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 084/247] wifi: iwlwifi: mld: always take beacon ies in link grading
Date: Fri, 21 Nov 2025 14:10:31 +0100
Message-ID: <20251121130157.611375938@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 1a222625b468effd13d1ebb662c36a41c28a835a ]

One of the factors of a link's grade is the channel load, which is
calculated from the AP's bss load element.
The current code takes this element from the beacon for an active link,
and from bss->ies for an inactive link.

bss->ies is set to either the beacon's ies or to the probe response
ones, with preference to the probe response (meaning that if there was
even one probe response, the ies of it will be stored in bss->ies and
won't be overiden by the beacon ies).

The probe response can be very old, i.e. from the connection time,
where a beacon is updated before each link selection (which is
triggered only after a passive scan).

In such case, the bss load element in the probe response will not
include the channel load caused by the STA, where the beacon will.

This will cause the inactive link to always have a lower channel
load, and therefore an higher grade than the active link's one.

This causes repeated link switches, causing the throughput to drop.

Fix this by always taking the ies from the beacon, as those are for
sure new.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251110145652.b493dbb1853a.I058ba7309c84159f640cc9682d1bda56dd56a536@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/link.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/link.c b/drivers/net/wireless/intel/iwlwifi/mld/link.c
index 131190977d4b0..5b10e1e443178 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/link.c
@@ -701,18 +701,13 @@ static int
 iwl_mld_get_chan_load_from_element(struct iwl_mld *mld,
 				   struct ieee80211_bss_conf *link_conf)
 {
-	struct ieee80211_vif *vif = link_conf->vif;
 	const struct cfg80211_bss_ies *ies;
 	const struct element *bss_load_elem = NULL;
 	const struct ieee80211_bss_load_elem *bss_load;
 
 	guard(rcu)();
 
-	if (ieee80211_vif_link_active(vif, link_conf->link_id))
-		ies = rcu_dereference(link_conf->bss->beacon_ies);
-	else
-		ies = rcu_dereference(link_conf->bss->ies);
-
+	ies = rcu_dereference(link_conf->bss->beacon_ies);
 	if (ies)
 		bss_load_elem = cfg80211_find_elem(WLAN_EID_QBSS_LOAD,
 						   ies->data, ies->len);
-- 
2.51.0



