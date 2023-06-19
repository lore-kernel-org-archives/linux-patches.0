Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD323C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F93C433CA;
	Mon, 19 Jun 2023 10:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171060;
	bh=BdTPbDUZQfzs2/aektdDy5C9ZubzpwmICNvD7KtBhh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNdSiTcAaSZ0UQvwI60SnvbvIOIX53aZSNq/EUMmAVvrhb20EY04JH3ERu59x4WeT
	 Iz3MhmTCoFjq/BCMYki3vTpnHcAPY3B0MzxdFaWZxwVDBGqiOUiZ6I1KTWPD6RJuki
	 k9V3xODuForgDSxyHZeJdU9gRDSkZI+asAEb51m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 134/187] wifi: mac80211: take lock before setting vif links
Date: Mon, 19 Jun 2023 12:29:12 +0200
Message-ID: <20230619102204.102487377@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 15846f95ab01b71fdb1cef8df73680aad41edf70 ]

ieee80211_vif_set_links requires the sdata->local->mtx lock to be held.
Add the appropriate locking around the calls in both the link add and
remove handlers.

This causes a warning when e.g. ieee80211_link_release_channel is called
via ieee80211_link_stop from ieee80211_vif_update_links.

Fixes: 0d8c4a3c8688 ("wifi: mac80211: implement add/del interface link callbacks")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230608163202.fa0c6597fdad.I83dd70359f6cda30f86df8418d929c2064cf4995@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5ddbe0c8cfaa1..2c4689a1bf064 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -4778,11 +4778,16 @@ static int ieee80211_add_intf_link(struct wiphy *wiphy,
 				   unsigned int link_id)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	int res;
 
 	if (wdev->use_4addr)
 		return -EOPNOTSUPP;
 
-	return ieee80211_vif_set_links(sdata, wdev->valid_links);
+	mutex_lock(&sdata->local->mtx);
+	res = ieee80211_vif_set_links(sdata, wdev->valid_links);
+	mutex_unlock(&sdata->local->mtx);
+
+	return res;
 }
 
 static void ieee80211_del_intf_link(struct wiphy *wiphy,
@@ -4791,7 +4796,9 @@ static void ieee80211_del_intf_link(struct wiphy *wiphy,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
+	mutex_lock(&sdata->local->mtx);
 	ieee80211_vif_set_links(sdata, wdev->valid_links);
+	mutex_unlock(&sdata->local->mtx);
 }
 
 static int sta_add_link_station(struct ieee80211_local *local,
-- 
2.39.2



