Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF634F93C9;
	Tue, 13 Oct 2026 12:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893572; cv=none; b=jYYjUbvhWH54PZtsGuVGJUyVtx58fqAztECB4zJGF80ClpUQnvk/Zun/Y4bgmg2sdlo4B2KwOeuaBRpVSg/zyfaFDbzPNoXyC950B1LP0j3PpWLEzYXoQMRewdlZQg/QhmxQS9Iwob/66kM6Pv3Ph7nUUfCXqE4iQRH8uPbABq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893572; c=relaxed/simple;
	bh=G/5kRBaRCry8ErFRsMqsSTOFXYiePVF36SJobTP7KwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG1DUzsCOAwVuZ77boewLaH/X1DzGHjUVV5A3rsVyyMLUY3mlLtVdoUAFFqvEHIGTasYuqk3FQIQzLbhHBSb9NHSos00KOFbTKlG140ONNl5W0a6pmJvAtf3TTBVtEu0eSNt9G1YkgC3MXMHK3TkMZZah8wgj4+4/etU0P2QHKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjLwaK60; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjLwaK60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E30E1F000FF;
	Tue, 13 Oct 2026 12:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893571;
	bh=jl5TibJbKEnFoTs0FNvqpSdGxDztebJVTaeiq8OOlU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yjLwaK60/yeyRyvv9+L9tyUt1jh4wAsvBeXMslU/OBJE63nyz3yrZJ4To+ZWL0R8Z
	 AnxBPy9iVUZml1bGlbLD/ECIb//F8mjwwxnYB9vSNZdxAcHH0AWq3VnYvNadtVik6z
	 rp9tDVV6mWV10lKNt5DrF0maKLRmSErrEM9IsoKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Cen Zhang <zzzccc427@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 270/621] wifi: cfg80211: use wiphy work for socket owner autodisconnect
Date: Tue, 13 Oct 2026 13:34:25 +0200
Message-ID: <20261013112927.269104299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0b9bc2247d323..322c0649ccbd4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6813,7 +6813,7 @@ struct wireless_dev {
 	enum ieee80211_bss_type conn_bss_type;
 	u32 conn_owner_nlportid;
 
-	struct work_struct disconnect_wk;
+	struct wiphy_work disconnect_wk;
 	u8 disconnect_bssid[ETH_ALEN];
 
 	struct list_head event_list;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 01e44ba4eddd1..c7d4498682549 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1385,6 +1385,7 @@ static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 	list_del_rcu(&wdev->list);
 	synchronize_net();
 	rdev->devlist_generation++;
+	wiphy_work_cancel(wdev->wiphy, &wdev->disconnect_wk);
 
 	cfg80211_mlme_purge_registrations(wdev);
 
@@ -1568,7 +1569,7 @@ void cfg80211_init_wdev(struct wireless_dev *wdev)
 	     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
 		wdev->netdev->priv_flags |= IFF_DONT_BRIDGE;
 
-	INIT_WORK(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
+	wiphy_work_init(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
 }
 
 void cfg80211_register_wdev(struct cfg80211_registered_device *rdev,
@@ -1676,9 +1677,9 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
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
index d7ac3145fd1ae..04c014d9ad078 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -434,7 +434,7 @@ void __cfg80211_port_authorized(struct wireless_dev *wdev, const u8 *peer_addr,
 				const u8 *td_bitmap, u8 td_bitmap_len);
 int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev);
-void cfg80211_autodisconnect_wk(struct work_struct *work);
+void cfg80211_autodisconnect_wk(struct wiphy *wiphy, struct wiphy_work *work);
 
 /* SME implementation */
 void cfg80211_conn_work(struct work_struct *work);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ad36fa03c69ee..5f84753f731b5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -21956,7 +21956,8 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 				wdev->nl_owner_dead = true;
 				schedule_work(&rdev->destroy_work);
 			} else if (wdev->conn_owner_nlportid == notify->portid) {
-				schedule_work(&wdev->disconnect_wk);
+				wiphy_work_queue(wdev->wiphy,
+						 &wdev->disconnect_wk);
 			}
 
 			cfg80211_release_pmsr(wdev, notify->portid);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 4e629ca305bcc..72166b70ee679 100644
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



