Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D103905EB;
	Sat, 17 Oct 2026 16:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254305; cv=none; b=tL7zYJcXdjsH/5y3RWN9OogOAVpqC8F5wfEiPx7LGCmFwJRHWvTv6ix6eC4OSP3k5k4PV8k5R8VCiDm/sm6Cx+Y3kkVnqqK+QhRiglgRdGx/tvwDocx/m5zoqn1R1vxPEfiT6d6ZQYss3SOV9OqO4tpcOrWM75x6dirhPwJXmmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254305; c=relaxed/simple;
	bh=KN4qVo0l5XTh7bQChpDva27c9j8DgTT5MefeJZt0fjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFyle727cMant6YAjW7JDjQpRALtYK0Of/6lf436aTD15tqkIETCIVMX/FCeDTXHyviG0Jk16tsM2UNFpG90bxXa8HAnFDD7uVdt452m4B8a1TF1KL+una/XHlkZ+5akYrDhc/+DYZmKWYpP6FDDAZ/WZnLo8nDC56jc+z0AoXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f521L+vZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f521L+vZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E4B1F000C4;
	Sat, 17 Oct 2026 16:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254304;
	bh=PSOvJNk9bk2ypfdfrysrYKqLm5P1zwPvXl4CbToaWRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f521L+vZbVO85meY7DSZvq/CTeuigLN5IRcaLrQUBUjoYH4ZaFk1aH+sMnNS7yUtv
	 5UeMkp8hqEV2B+5veS404W7lTS9zG7BK6+Cfi72ttGARy535JPC4/EfGhJjajyxeBk
	 Dl3OleH0rBB1aB0WmGejjDq3pcVS0htzEBfTu3BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Cen Zhang <zzzccc427@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 403/869] wifi: cfg80211: use wiphy work for socket owner autodisconnect
Date: Sat, 17 Oct 2026 17:54:04 +0200
Message-ID: <20261017160047.467148870@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ede91e4709ee5..a04b98eff1666 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6389,7 +6389,7 @@ struct wireless_dev {
 	enum ieee80211_bss_type conn_bss_type;
 	u32 conn_owner_nlportid;
 
-	struct work_struct disconnect_wk;
+	struct wiphy_work disconnect_wk;
 	u8 disconnect_bssid[ETH_ALEN];
 
 	struct list_head event_list;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 7c278b8694393..e4b7917455fb4 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1280,6 +1280,7 @@ static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 	list_del_rcu(&wdev->list);
 	synchronize_net();
 	rdev->devlist_generation++;
+	wiphy_work_cancel(wdev->wiphy, &wdev->disconnect_wk);
 
 	cfg80211_mlme_purge_registrations(wdev);
 
@@ -1463,7 +1464,7 @@ void cfg80211_init_wdev(struct wireless_dev *wdev)
 	     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
 		wdev->netdev->priv_flags |= IFF_DONT_BRIDGE;
 
-	INIT_WORK(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
+	wiphy_work_init(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
 }
 
 void cfg80211_register_wdev(struct cfg80211_registered_device *rdev,
@@ -1571,9 +1572,9 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		scoped_guard(wiphy, &rdev->wiphy) {
 			cfg80211_leave(rdev, wdev);
 			cfg80211_remove_links(wdev);
+			/* since we just did cfg80211_leave() nothing to do there */
+			wiphy_work_cancel(wdev->wiphy, &wdev->disconnect_wk);
 		}
-		/* since we just did cfg80211_leave() nothing to do there */
-		cancel_work_sync(&wdev->disconnect_wk);
 		break;
 	case NETDEV_DOWN:
 		wiphy_lock(&rdev->wiphy);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b02b456cfca37..505acfe4a16d6 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -418,7 +418,7 @@ void __cfg80211_port_authorized(struct wireless_dev *wdev, const u8 *peer_addr,
 				const u8 *td_bitmap, u8 td_bitmap_len);
 int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev);
-void cfg80211_autodisconnect_wk(struct work_struct *work);
+void cfg80211_autodisconnect_wk(struct wiphy *wiphy, struct wiphy_work *work);
 
 /* SME implementation */
 void cfg80211_conn_work(struct work_struct *work);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6261befa1e949..dddd15f2d6b57 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -20153,7 +20153,8 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 				wdev->nl_owner_dead = true;
 				schedule_work(&rdev->destroy_work);
 			} else if (wdev->conn_owner_nlportid == notify->portid) {
-				schedule_work(&wdev->disconnect_wk);
+				wiphy_work_queue(wdev->wiphy,
+						 &wdev->disconnect_wk);
 			}
 
 			cfg80211_release_pmsr(wdev, notify->portid);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index ab57648ca5774..059b01bdb630b 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1578,13 +1578,11 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
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



