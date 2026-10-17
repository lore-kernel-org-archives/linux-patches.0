Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06B8362154;
	Sat, 17 Oct 2026 17:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259103; cv=none; b=QlwasM4HOgmbvD1FYh6S1LhZ2/Cgi4ZcCO1TZBoDdnEVoDnL/72XDSVnonvyoNmXA7Uw5iT6+UHgoH/YZY43nJpk3CF3tq+PjTqWt8ihJRA8tQ2PoF7iPdXBaDZAeMtu3aBGnQvZv5XxZXZ2mVsu6/f9xz49biPTdssw1zHTXCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259103; c=relaxed/simple;
	bh=vBQvazhcKTh2lyCrA4xxBrt4/fX425O0kf388TMVP6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HktbJuLViHkhLIkCq45Jbji591AMXQVQdl4oLqlGJTUm3imNzPVtjwWstoCO3itfOa/U8j2aa4wHwIn9pwZSFp41KhIvd2Vvc5N/1PoahApEsUVqUlgzQcFkt+wWv8WinCf3EXTjoE/BoLqusAcAoHwEQyNEANfVSxN91lRWuKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ngSORV3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ngSORV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0B81F000C4;
	Sat, 17 Oct 2026 17:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259102;
	bh=BJHUfqHNiNqLA9uprm6xoBgXCyfR87jChkueI6Rqk7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ngSORV36dR6qvNHSY4YeZ99S0ZvSka5yT0b4wOjoDwxpCug+Qq2eeGL8DFX2ZmHS
	 g4CqEbkHNFbmAX8UdEeIIXTFgsCdZfbxZ4JYKSh5wdb0qYZvBidBUvNRDoyWWIq/Li
	 O3XPbvQ35pvLoF1XAJf/C6XZfROVn53Fw0Xy3n+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1101/1674] wifi: cfg80211: convert pmsr_free_wk to wiphy_work to fix deadlock
Date: Sat, 17 Oct 2026 17:56:13 +0200
Message-ID: <20261017160459.391784178@linuxfoundation.org>
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

From: Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>

[ Upstream commit 2b0eab425e1f658d8fe1df7590e3b9af5959505e ]

When a netlink socket that owns a PMSR session is closed,
cfg80211_release_pmsr() clears the request's nl_portid and queues
pmsr_free_wk to call cfg80211_pmsr_process_abort() asynchronously.

If the interface tears down concurrently, cfg80211_pmsr_wdev_down()
is called under wiphy_lock and calls cancel_work_sync(&pmsr_free_wk)
to wait for any running work. The work function acquires wiphy_lock
via guard(wiphy) before calling process_abort.

This is a deadlock: wdev_down holds wiphy_lock and blocks inside
cancel_work_sync(); pmsr_free_wk blocks trying to acquire that same
wiphy_lock. Neither thread can proceed.

The same deadlock is reachable from cfg80211_leave_locked(), which
calls cfg80211_pmsr_wdev_down() for all interface types under
wiphy_lock.

Fix this by converting pmsr_free_wk from a plain work_struct to a
wiphy_work. The wiphy_work dispatcher holds wiphy_lock when running
work items, so the explicit guard(wiphy) in the work function is no
longer needed. wiphy_work_cancel() can be called safely while holding
wiphy_lock - since wiphy_lock prevents the work from running
concurrently, wiphy_work_cancel() never blocks, eliminating the
deadlock.

Remove the cancel_work_sync() for pmsr_free_wk from the
NETDEV_GOING_DOWN handler. cfg80211_leave(), called unconditionally
just before it, already cancels any pending work under wiphy_lock
via wiphy_work_cancel() inside cfg80211_pmsr_wdev_down().

Fixes: 6dccbc9f3e1d ("wifi: cfg80211: cancel pmsr_free_wk in cfg80211_pmsr_wdev_down")
Signed-off-by: Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>
Link: https://patch.msgid.link/20260703082523.2629324-1-peddolla.reddy@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 2 +-
 net/wireless/core.c    | 3 +--
 net/wireless/core.h    | 2 +-
 net/wireless/pmsr.c    | 8 +++-----
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d6270cdb64485..720181902f1fd 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6042,7 +6042,7 @@ struct wireless_dev {
 
 	struct list_head pmsr_list;
 	spinlock_t pmsr_lock;
-	struct work_struct pmsr_free_wk;
+	struct wiphy_work pmsr_free_wk;
 
 	unsigned long unprot_beacon_reported;
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f283d74a3ba02..622192eeb7834 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1387,7 +1387,7 @@ void cfg80211_init_wdev(struct wireless_dev *wdev)
 	INIT_LIST_HEAD(&wdev->mgmt_registrations);
 	INIT_LIST_HEAD(&wdev->pmsr_list);
 	spin_lock_init(&wdev->pmsr_lock);
-	INIT_WORK(&wdev->pmsr_free_wk, cfg80211_pmsr_free_wk);
+	wiphy_work_init(&wdev->pmsr_free_wk, cfg80211_pmsr_free_wk);
 
 #ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.default_key = -1;
@@ -1520,7 +1520,6 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		/* since we just did cfg80211_leave() nothing to do there */
 		wiphy_work_cancel(wdev->wiphy, &wdev->disconnect_wk);
 		wiphy_unlock(&rdev->wiphy);
-		cancel_work_sync(&wdev->pmsr_free_wk);
 		break;
 	case NETDEV_DOWN:
 		wiphy_lock(&rdev->wiphy);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 735ca87ffa17d..3ba403698f415 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -575,7 +575,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 
 void cfg80211_release_pmsr(struct wireless_dev *wdev, u32 portid);
 void cfg80211_pmsr_wdev_down(struct wireless_dev *wdev);
-void cfg80211_pmsr_free_wk(struct work_struct *work);
+void cfg80211_pmsr_free_wk(struct wiphy *wiphy, struct wiphy_work *work);
 
 void cfg80211_remove_link(struct wireless_dev *wdev, unsigned int link_id);
 void cfg80211_remove_links(struct wireless_dev *wdev);
diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index 678bbe5bf455f..88aade01cd068 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -634,16 +634,14 @@ static void cfg80211_pmsr_process_abort(struct wireless_dev *wdev)
 	}
 }
 
-void cfg80211_pmsr_free_wk(struct work_struct *work)
+void cfg80211_pmsr_free_wk(struct wiphy *wiphy, struct wiphy_work *work)
 {
 	struct wireless_dev *wdev = container_of(work, struct wireless_dev,
 						 pmsr_free_wk);
 
-	wiphy_lock(wdev->wiphy);
 	wdev_lock(wdev);
 	cfg80211_pmsr_process_abort(wdev);
 	wdev_unlock(wdev);
-	wiphy_unlock(wdev->wiphy);
 }
 
 void cfg80211_pmsr_wdev_down(struct wireless_dev *wdev)
@@ -658,7 +656,7 @@ void cfg80211_pmsr_wdev_down(struct wireless_dev *wdev)
 	}
 	spin_unlock_bh(&wdev->pmsr_lock);
 
-	cancel_work_sync(&wdev->pmsr_free_wk);
+	wiphy_work_cancel(wdev->wiphy, &wdev->pmsr_free_wk);
 	if (found)
 		cfg80211_pmsr_process_abort(wdev);
 
@@ -673,7 +671,7 @@ void cfg80211_release_pmsr(struct wireless_dev *wdev, u32 portid)
 	list_for_each_entry(req, &wdev->pmsr_list, list) {
 		if (req->nl_portid == portid) {
 			req->nl_portid = 0;
-			schedule_work(&wdev->pmsr_free_wk);
+			wiphy_work_queue(wdev->wiphy, &wdev->pmsr_free_wk);
 		}
 	}
 	spin_unlock_bh(&wdev->pmsr_lock);
-- 
2.53.0



