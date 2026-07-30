Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A685943FD2C;
	Thu, 30 Jul 2026 14:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421349; cv=none; b=gkqsZfCeePV1qPiPINf0xG68FbrLb7ov01gik3yLLf5OPMGy6tClEatXNzYgiNjjfLNwZEqIqajtH6yfYJkNQoX9nD2qQIgcrGxQRr7oCest7tmP3LaW0Z+tPOBEq46EVVEgDmWfY/dbYZJ/1pj6ZtpbyO4KuBB24KKy6CEYo/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421349; c=relaxed/simple;
	bh=qVOHz0NwXy7vM3xn9+q2IqyHW5+eG5A3Kl7/DbH/JNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffQcze5l9VEPImmgru0t3z96An+DNAvOErj9Z6UZ5cUCZy27bIc+tV/9LT6jx+CSwBCpt8apUDfjoVTRusviHfXi16MPQ6P/uUGYz+hvfMDLDLb7ovFcrgg5kzc9s4Vqf5BYcgP9UC0go+ylP2bAeKUjAOL7l/6FVBK9lpDOAqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2U4vOWl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2U4vOWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55FA1F000E9;
	Thu, 30 Jul 2026 14:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421347;
	bh=p7bOy4dFqO2Lz5ZG80KuvFGkBaF1TeyGlEPAUla6yWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u2U4vOWlysqyftG+ZaR+mhd3spgToCcW8Ob3TItYTtb0bgnBiusSTWIcuEx7/2vOy
	 KuQH3V8w2vuj9zqZGXUk7iNrupiam7xfwmRUS3uJz5l4iK36KbWkNR5fhJnDn1O7M3
	 8lK3Gs7AybICKJsbycGwJLfU6ZPAvy98OHLE5p90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Cen Zhang <zzzccc427@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 071/744] wifi: cfg80211: use wiphy work for socket owner autodisconnect
Date: Thu, 30 Jul 2026 16:05:44 +0200
Message-ID: <20260730141445.782859780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 0c2ed186bbe14304415476d6707b747dddcd8583 ]

nl80211_netlink_notify() walks the cfg80211 wireless device list when a
NETLINK_GENERIC socket is released. If the socket owns a connection, the
notifier queues the embedded wdev->disconnect_wk work item.

That work is a plain work_struct today. NETDEV_GOING_DOWN cancels it, but a
NETLINK_URELEASE notifier that already observed conn_owner_nlportid can
queue it after that cancel returns. _cfg80211_unregister_wdev() then
removes the wdev from the list and waits for RCU readers, but
synchronize_net() does not drain work queued by such a reader.

Make the autodisconnect work a wiphy_work instead. The callback already
needs the wiphy mutex, and wiphy_work runs under that mutex. This lets
teardown cancel pending autodisconnect work while holding the mutex,
without a cancel_work_sync() vs. worker locking concern.

Also cancel the wiphy work after list_del_rcu() and synchronize_net(). Any
NETLINK_URELEASE notifier that had already reached the wdev list has then
either queued the work and it is removed, or can no longer find the wdev.

Fixes: bd2522b16884 ("cfg80211: NL80211_ATTR_SOCKET_OWNER support for CMD_CONNECT")
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/20260706152418.779226-1-zzzccc427@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h |  2 +-
 net/wireless/core.c    | 10 ++++++----
 net/wireless/core.h    |  2 +-
 net/wireless/nl80211.c |  3 ++-
 net/wireless/sme.c     |  6 ++----
 5 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e7441414909cce..909fb76751c508 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6990,7 +6990,7 @@ struct wireless_dev {
 	enum ieee80211_bss_type conn_bss_type;
 	u32 conn_owner_nlportid;
 
-	struct work_struct disconnect_wk;
+	struct wiphy_work disconnect_wk;
 	u8 disconnect_bssid[ETH_ALEN];
 
 	struct list_head event_list;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 6dd24115177112..7f6a0418d83018 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1378,6 +1378,7 @@ static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 	list_del_rcu(&wdev->list);
 	synchronize_net();
 	rdev->devlist_generation++;
+	wiphy_work_cancel(wdev->wiphy, &wdev->disconnect_wk);
 
 	cfg80211_mlme_purge_registrations(wdev);
 
@@ -1585,7 +1586,7 @@ void cfg80211_init_wdev(struct wireless_dev *wdev)
 	     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
 		wdev->netdev->priv_flags |= IFF_DONT_BRIDGE;
 
-	INIT_WORK(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
+	wiphy_work_init(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
 }
 
 void cfg80211_register_wdev(struct cfg80211_registered_device *rdev,
@@ -1691,10 +1692,11 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		break;
 	case NETDEV_GOING_DOWN:
 		cfg80211_leave(rdev, wdev, -1);
-		scoped_guard(wiphy, &rdev->wiphy)
+		scoped_guard(wiphy, &rdev->wiphy) {
 			cfg80211_remove_links(wdev);
-		/* since we just did cfg80211_leave() nothing to do there */
-		cancel_work_sync(&wdev->disconnect_wk);
+			/* since we just did cfg80211_leave() nothing to do there */
+			wiphy_work_cancel(wdev->wiphy, &wdev->disconnect_wk);
+		}
 		break;
 	case NETDEV_DOWN:
 		wiphy_lock(&rdev->wiphy);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 5ad38519d8a64b..8d40f1e6538bca 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -428,7 +428,7 @@ void __cfg80211_port_authorized(struct wireless_dev *wdev, const u8 *peer_addr,
 				const u8 *td_bitmap, u8 td_bitmap_len);
 int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev);
-void cfg80211_autodisconnect_wk(struct work_struct *work);
+void cfg80211_autodisconnect_wk(struct wiphy *wiphy, struct wiphy_work *work);
 
 /* SME implementation */
 void cfg80211_conn_work(struct work_struct *work);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3476681ecd7aa8..68f9219796e199 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -22557,7 +22557,8 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 				wdev->nl_owner_dead = true;
 				schedule_work(&rdev->destroy_work);
 			} else if (wdev->conn_owner_nlportid == notify->portid) {
-				schedule_work(&wdev->disconnect_wk);
+				wiphy_work_queue(wdev->wiphy,
+						 &wdev->disconnect_wk);
 			}
 
 			cfg80211_release_pmsr(wdev, notify->portid);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 86e2ccaa678ce5..1ddaadbed74c82 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1577,13 +1577,11 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
  * Used to clean up after the connection / connection attempt owner socket
  * disconnects
  */
-void cfg80211_autodisconnect_wk(struct work_struct *work)
+void cfg80211_autodisconnect_wk(struct wiphy *wiphy, struct wiphy_work *work)
 {
 	struct wireless_dev *wdev =
 		container_of(work, struct wireless_dev, disconnect_wk);
-	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
-
-	guard(wiphy)(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	if (wdev->conn_owner_nlportid) {
 		switch (wdev->iftype) {
-- 
2.53.0



