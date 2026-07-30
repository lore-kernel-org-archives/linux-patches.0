Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8F7430CDD;
	Thu, 30 Jul 2026 14:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421307; cv=none; b=NqJGwuJ6o2DW1Cw0tUWSZWz/zKu4R4I8GjIxzzllBkriZyggBxHAgJIMfhs7nJP0itaqYqPZUu+2PMFHA+0Vzb0iiMrb6S4ksmYAuGPS3v/QKFQlmxHi+gHkp0w5P02IFtGlstlPrhc7yg5pDfqZg9jHoPfKNGGf4sH0g6EFsME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421307; c=relaxed/simple;
	bh=6C0sBIh1aFJBG5gcJ9t5gNdX1RIe+sY4QOb3HNnnyKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kycaOakywGd3keKOZxmm8/nbq9Uz2Pacp58PkD6RMEHCkeyJbIj1txHZFuMxPqHPr6r/XQ6ZHWvyNuPia7+O6tta/HajNbK74kPyjEzNz3TM4l8LDIyXuHZBdtsUqzn6ySvQgl47qReYkxiQPtja9bNhcWJPDgAjvNdHAua6GPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpAGeXWy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpAGeXWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA7B1F000E9;
	Thu, 30 Jul 2026 14:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421306;
	bh=oQM6ka6IWKOYr3qwz4cVtl/SD0A+B5PKaZkAhllkLK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GpAGeXWyXa4H9KtmEIEdeLN1MUJwtlCpK8M1GKSp+0yTOMvXr0V1Jt89hNJT5nZaN
	 WxtBZXg6VbQKo204TQGLs6XlrwuO57VxLX/mYOSFcFAZJJJGhKhPo1IxjXkd8R7FVK
	 XxFfwhKKzaif5b+30q8PpnR1CN34dw0P6PE3tleY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 059/744] wifi: cfg80211: convert pmsr_free_wk to wiphy_work to fix deadlock
Date: Thu, 30 Jul 2026 16:05:32 +0200
Message-ID: <20260730141445.530481489@linuxfoundation.org>
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
index 9d3639ff9c28e7..e7441414909cce 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -7027,7 +7027,7 @@ struct wireless_dev {
 
 	struct list_head pmsr_list;
 	spinlock_t pmsr_lock;
-	struct work_struct pmsr_free_wk;
+	struct wiphy_work pmsr_free_wk;
 
 	unsigned long unprot_beacon_reported;
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 2743a8a50fe3e4..6dd24115177112 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1561,7 +1561,7 @@ void cfg80211_init_wdev(struct wireless_dev *wdev)
 	INIT_LIST_HEAD(&wdev->mgmt_registrations);
 	INIT_LIST_HEAD(&wdev->pmsr_list);
 	spin_lock_init(&wdev->pmsr_lock);
-	INIT_WORK(&wdev->pmsr_free_wk, cfg80211_pmsr_free_wk);
+	wiphy_work_init(&wdev->pmsr_free_wk, cfg80211_pmsr_free_wk);
 
 #ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.default_key = -1;
@@ -1695,7 +1695,6 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			cfg80211_remove_links(wdev);
 		/* since we just did cfg80211_leave() nothing to do there */
 		cancel_work_sync(&wdev->disconnect_wk);
-		cancel_work_sync(&wdev->pmsr_free_wk);
 		break;
 	case NETDEV_DOWN:
 		wiphy_lock(&rdev->wiphy);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index ae2d56d3ad9083..5ad38519d8a64b 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -583,7 +583,7 @@ cfg80211_get_6ghz_power_type(const u8 *elems, size_t elems_len,
 
 void cfg80211_release_pmsr(struct wireless_dev *wdev, u32 portid);
 void cfg80211_pmsr_wdev_down(struct wireless_dev *wdev);
-void cfg80211_pmsr_free_wk(struct work_struct *work);
+void cfg80211_pmsr_free_wk(struct wiphy *wiphy, struct wiphy_work *work);
 
 void cfg80211_remove_link(struct wireless_dev *wdev, unsigned int link_id);
 void cfg80211_remove_links(struct wireless_dev *wdev);
diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index 0ca93fd7d46f8d..1ee7a9e2cdef21 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -645,13 +645,11 @@ static void cfg80211_pmsr_process_abort(struct wireless_dev *wdev)
 	}
 }
 
-void cfg80211_pmsr_free_wk(struct work_struct *work)
+void cfg80211_pmsr_free_wk(struct wiphy *wiphy, struct wiphy_work *work)
 {
 	struct wireless_dev *wdev = container_of(work, struct wireless_dev,
 						 pmsr_free_wk);
 
-	guard(wiphy)(wdev->wiphy);
-
 	cfg80211_pmsr_process_abort(wdev);
 }
 
@@ -667,7 +665,7 @@ void cfg80211_pmsr_wdev_down(struct wireless_dev *wdev)
 	}
 	spin_unlock_bh(&wdev->pmsr_lock);
 
-	cancel_work_sync(&wdev->pmsr_free_wk);
+	wiphy_work_cancel(wdev->wiphy, &wdev->pmsr_free_wk);
 	if (found)
 		cfg80211_pmsr_process_abort(wdev);
 
@@ -682,7 +680,7 @@ void cfg80211_release_pmsr(struct wireless_dev *wdev, u32 portid)
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



