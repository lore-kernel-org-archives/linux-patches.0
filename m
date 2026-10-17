Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEC93C0A1E;
	Sat, 17 Oct 2026 17:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259100; cv=none; b=RZgAGeHzM7oO8RNsYe4c2HGhDCoN09UrXERha3d3ObPjyNGNoK6lvynRLfhrzkPNQxwdo/Rm4meeOSIbiuzl9CBF2x6WO4pYc9Afa2fFNZ8LsBCu8j4VCJoLrjzt9SOXhBWD3LWB9J7u42s/A/VYxPSAh4GPugP+jVqiF5KEwpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259100; c=relaxed/simple;
	bh=YR4wEtL3po6UlQqi8hif6zKFOotgJRpDj5XHvRRsWyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNG4tHRREiKDsmWCwDZypcHyU9sWYRrHh/I7ejR7lVKxCEMQvuO3J6WveLThNLcGSIErMalDkdlSoOhZTAUL+wIiQNfxr70qVVTvvgAOTY6WK0LcU37cXfqhGTOYu8XdA/nL2mZt4EPnSTFOLeDpTWSj2Cte3J8yCFbkRV5FtGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1kkGyxR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1kkGyxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE481F000C4;
	Sat, 17 Oct 2026 17:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259099;
	bh=6bSPlc/1l/zWgg4y5tzA73Vp+bIm+WeFx2VCmb3vhtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1kkGyxRKT3EgxSZIKTWw5/f71dp9H0qDkfShZm/0odlIwThf0TD1wrOolN4KE3Yy
	 mcpyDOvi+vXtN3fY+WUgFf3KrP/H49YZV549SdYNDjjrkJBLwR5GyWZWCuPc3atzxZ
	 QaF4yo7adO3ATbLk1EGe52wS/cBOhTiCCS8f2iDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Cen Zhang <zzzccc427@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1100/1674] wifi: cfg80211: use wiphy work for socket owner autodisconnect
Date: Sat, 17 Oct 2026 17:56:12 +0200
Message-ID: <20261017160459.364006128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 include/net/cfg80211.h | 2 +-
 net/wireless/core.c    | 7 ++++---
 net/wireless/core.h    | 2 +-
 net/wireless/nl80211.c | 3 ++-
 net/wireless/sme.c     | 6 ++----
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index cda0b2907f329..d6270cdb64485 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6000,7 +6000,7 @@ struct wireless_dev {
 	enum ieee80211_bss_type conn_bss_type;
 	u32 conn_owner_nlportid;
 
-	struct work_struct disconnect_wk;
+	struct wiphy_work disconnect_wk;
 	u8 disconnect_bssid[ETH_ALEN];
 
 	struct list_head event_list;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 800fbfd591949..f283d74a3ba02 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1220,6 +1220,7 @@ static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 	list_del_rcu(&wdev->list);
 	synchronize_net();
 	rdev->devlist_generation++;
+	wiphy_work_cancel(wdev->wiphy, &wdev->disconnect_wk);
 
 	cfg80211_mlme_purge_registrations(wdev);
 
@@ -1408,7 +1409,7 @@ void cfg80211_init_wdev(struct wireless_dev *wdev)
 	     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
 		wdev->netdev->priv_flags |= IFF_DONT_BRIDGE;
 
-	INIT_WORK(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
+	wiphy_work_init(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
 }
 
 void cfg80211_register_wdev(struct cfg80211_registered_device *rdev,
@@ -1516,9 +1517,9 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		wiphy_lock(&rdev->wiphy);
 		cfg80211_leave(rdev, wdev);
 		cfg80211_remove_links(wdev);
-		wiphy_unlock(&rdev->wiphy);
 		/* since we just did cfg80211_leave() nothing to do there */
-		cancel_work_sync(&wdev->disconnect_wk);
+		wiphy_work_cancel(wdev->wiphy, &wdev->disconnect_wk);
+		wiphy_unlock(&rdev->wiphy);
 		cancel_work_sync(&wdev->pmsr_free_wk);
 		break;
 	case NETDEV_DOWN:
diff --git a/net/wireless/core.h b/net/wireless/core.h
index f0a3a23176385..735ca87ffa17d 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -427,7 +427,7 @@ void __cfg80211_port_authorized(struct wireless_dev *wdev, const u8 *bssid,
 				const u8 *td_bitmap, u8 td_bitmap_len);
 int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev);
-void cfg80211_autodisconnect_wk(struct work_struct *work);
+void cfg80211_autodisconnect_wk(struct wiphy *wiphy, struct wiphy_work *work);
 
 /* SME implementation */
 void cfg80211_conn_work(struct work_struct *work);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e4cd5503ae119..c4af4cc443676 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -20029,7 +20029,8 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 				wdev->nl_owner_dead = true;
 				schedule_work(&rdev->destroy_work);
 			} else if (wdev->conn_owner_nlportid == notify->portid) {
-				schedule_work(&wdev->disconnect_wk);
+				wiphy_work_queue(wdev->wiphy,
+						 &wdev->disconnect_wk);
 			}
 
 			cfg80211_release_pmsr(wdev, notify->portid);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 6f116ae5442bf..eb0434783f9fb 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1584,13 +1584,12 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
  * Used to clean up after the connection / connection attempt owner socket
  * disconnects
  */
-void cfg80211_autodisconnect_wk(struct work_struct *work)
+void cfg80211_autodisconnect_wk(struct wiphy *wiphy, struct wiphy_work *work)
 {
 	struct wireless_dev *wdev =
 		container_of(work, struct wireless_dev, disconnect_wk);
-	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
-	wiphy_lock(wdev->wiphy);
 	wdev_lock(wdev);
 
 	if (wdev->conn_owner_nlportid) {
@@ -1629,5 +1628,4 @@ void cfg80211_autodisconnect_wk(struct work_struct *work)
 	}
 
 	wdev_unlock(wdev);
-	wiphy_unlock(wdev->wiphy);
 }
-- 
2.53.0



