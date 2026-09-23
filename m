Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D800942E8DC;
	Wed, 23 Sep 2026 14:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172809; cv=none; b=PJeZnYQ+SIl3Y4FFc7/9qa2Wiqry4V2A1ahl/WIxyPo4/XyfXT9gKK/ofCN59v4BSXfA0q831FXayQER2G11H/cUa0ZQm8MRcTTeIiWGqe8ne9G81EXCsYs80D5OdXR6xpzMjbmnPFZGS9Rn+TySbUXKik+m144yNB0Bsgzx64E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172809; c=relaxed/simple;
	bh=TedEP+t2WA7AvHKdeZo4kCtqlzAzTpPjX9mK5xffVQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dja43SrZig8ZMz3dS8kKgM6CpX7jXVa4zzeqMJKGMhCfC9AUbbNuVQTMDhRIXn4Vuc6sqF2Sl9P0/vcfT5TYY5x+tBFVSnHdEr5JjrWGhHzKODM+r2TVGFqBdP+/RMdwUZxgwzbQmnDgix8IJS9JBQzybFjurisAa2acImtZrFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+whRDMl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+whRDMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E131F000FF;
	Wed, 23 Sep 2026 14:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172807;
	bh=xeEIroYzZcQ5Vhq/wSPmimo1kfCVdvVNFxvsWTG8XtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+whRDMlgu0Hns4f7TKHXq/gzFSYU7gGBnmtuRsD3EPboWKlRLd35IAphr4WzDe4B
	 HS6oJJ8pMqFZHhGg8jwm9WQCzPltJ2neCtgn7TaHZ0gDLREtzhLH+DtadwUV564+ZU
	 n3AxI6MDAGvrbJj8VTMDAsAQgzRQITEGpUooAdLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7f064ba1704c2466e36d@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 067/438] wifi: cfg80211: ibss: ref BSS entry for joined event
Date: Wed, 23 Sep 2026 16:01:28 +0200
Message-ID: <20260923140646.527150977@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 708f9d43d6a2eb9c6b83fe62af628de9dffd9314 ]

When the IBSS is joined, we only record the BSSID/channel in the event
and look up the BSS entry when processing it. However, that's racy,
e.g. a new scan with NL80211_SCAN_FLAG_FLUSH can remove it, causing a
warning in the event work:

  !bss
  WARNING: net/wireless/ibss.c:37 at __cfg80211_ibss_joined+0x3d3/0x440
  Workqueue: cfg80211 cfg80211_event_work
   cfg80211_process_wdev_events+0x39f/0x5b0 net/wireless/util.c:1144
   cfg80211_process_rdev_events+0xa1/0x110 net/wireless/util.c:1179
   cfg80211_event_work+0x2f/0x40 net/wireless/core.c:393

Do the lookup early (the driver is expected to only join an IBSS that
has a BSS entry) and keep a reference to it.

Assisted-by: LLM
Fixes: 667503ddcb96 ("cfg80211: fix locking")
Reported-by: syzbot+7f064ba1704c2466e36d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7f064ba1704c2466e36d
Link: https://patch.msgid.link/20260904165614.f49a213f0e49.I192bfe738750ebb5f2c4faa3019a428da64cd3ec@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.h |  6 ++----
 net/wireless/ibss.c | 36 ++++++++++++++++++++----------------
 net/wireless/util.c |  3 +--
 3 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 979e968ff5959..81e595247b932 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -290,8 +290,7 @@ struct cfg80211_event {
 			bool locally_generated;
 		} dc;
 		struct {
-			u8 bssid[ETH_ALEN];
-			struct ieee80211_channel *channel;
+			struct cfg80211_bss *bss;
 		} ij;
 		struct {
 			u8 peer_addr[ETH_ALEN];
@@ -354,8 +353,7 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 void cfg80211_clear_ibss(struct net_device *dev, bool nowext);
 int cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, bool nowext);
-void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
-			    struct ieee80211_channel *channel);
+void __cfg80211_ibss_joined(struct net_device *dev, struct cfg80211_bss *bss);
 int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 			    struct wireless_dev *wdev);
 
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index b1d748bdb504e..7f6779d326b81 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -16,26 +16,18 @@
 #include "rdev-ops.h"
 
 
-void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
-			    struct ieee80211_channel *channel)
+void __cfg80211_ibss_joined(struct net_device *dev, struct cfg80211_bss *bss)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_bss *bss;
 #ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
 #endif
 
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_ADHOC))
-		return;
+		goto put_bss;
 
 	if (!wdev->u.ibss.ssid_len)
-		return;
-
-	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid, NULL, 0,
-			       IEEE80211_BSS_TYPE_IBSS, IEEE80211_PRIVACY_ANY);
-
-	if (WARN_ON(!bss))
-		return;
+		goto put_bss;
 
 	if (wdev->u.ibss.current_bss) {
 		cfg80211_unhold_bss(wdev->u.ibss.current_bss);
@@ -43,17 +35,22 @@ void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 	}
 
 	cfg80211_hold_bss(bss_from_pub(bss));
+	/* the reference from the event is transferred to current_bss */
 	wdev->u.ibss.current_bss = bss_from_pub(bss);
 
 	cfg80211_upload_connect_keys(wdev);
 
-	nl80211_send_ibss_bssid(wiphy_to_rdev(wdev->wiphy), dev, bssid,
+	nl80211_send_ibss_bssid(wiphy_to_rdev(wdev->wiphy), dev, bss->bssid,
 				GFP_KERNEL);
 #ifdef CONFIG_CFG80211_WEXT
 	memset(&wrqu, 0, sizeof(wrqu));
-	memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
+	memcpy(wrqu.ap_addr.sa_data, bss->bssid, ETH_ALEN);
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
 #endif
+	return;
+
+put_bss:
+	cfg80211_put_bss(wdev->wiphy, bss);
 }
 
 void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
@@ -62,6 +59,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_event *ev;
+	struct cfg80211_bss *bss;
 	unsigned long flags;
 
 	trace_cfg80211_ibss_joined(dev, bssid, channel);
@@ -69,13 +67,19 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 	if (WARN_ON(!channel))
 		return;
 
+	bss = cfg80211_get_bss(wdev->wiphy, channel, bssid, NULL, 0,
+			       IEEE80211_BSS_TYPE_IBSS, IEEE80211_PRIVACY_ANY);
+	if (WARN_ON(!bss))
+		return;
+
 	ev = kzalloc_obj(*ev, gfp);
-	if (!ev)
+	if (!ev) {
+		cfg80211_put_bss(wdev->wiphy, bss);
 		return;
+	}
 
 	ev->type = EVENT_IBSS_JOINED;
-	memcpy(ev->ij.bssid, bssid, ETH_ALEN);
-	ev->ij.channel = channel;
+	ev->ij.bss = bss;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index ef56fe0ac41b2..12285bbd29730 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1184,8 +1184,7 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 						!ev->dc.locally_generated);
 			break;
 		case EVENT_IBSS_JOINED:
-			__cfg80211_ibss_joined(wdev->netdev, ev->ij.bssid,
-					       ev->ij.channel);
+			__cfg80211_ibss_joined(wdev->netdev, ev->ij.bss);
 			break;
 		case EVENT_STOPPED:
 			/*
-- 
2.53.0



