Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215494;
	b=KYHopr0mJWFs1K/fzhJBMdoNNM2Xp1+PXn0j1b5oEOBebCC9rue5wpT4kOs0uQkytTc2
	 SYc655euVteaBtfhZoH+IkNz1OzGejUKwGRD5t5M3wCLU0vm6jg+JZZjtJbJ3O6SBcIzn
	 oCXMh6Dl+OP7iKCRvxYP/EpR06ClRhD4yZDFtPCJAU0OgJhCaDY+G1xPvEdIrP8Js0YOR
	 q99cJq1NJsphW2CwtkhJSLcmh8FQ9OD+DPAYIjGcvAUyjs09xzKXn0RcOEjcP+hm3+Ftd
	 dVXcPfvETv3mX9ag+WNrLx2gd7z5TfjkXFK++n1JFDd4RHKv3t+DZRRl1Awn73M5zbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0zRb0BHIcWX+Uma2bofH3fnBsjmR8CiTUIuZB4yeH58=;
	b=C5X58xqhf/awQt5arg02SdJiUeh8geF+3BWnuVZhpRk7ILYmblZFwm9ADYpgRn25rZE8
	 guZOK9HtTekMJmmeV9nctIVoOw0MqqobVb8y21U4KMlowpvXxJNEwJ7V7DwQVt2KcqWP0
	 iA+dsgXE9PNPF1oT1+ET+Tq1jjRmf6QQCLU8F8UD7ARWy5Lkhp7HC2tZVXf795/tZ5rUq
	 0bt/QQEGBgYD6JRrrFWJWCXkFn9/OGh8EXg1f3PnGdD6Paz2ueK9pluYzH/ZQLstv5Z/w
	 K3FPQaUTsU3oA13V6jlDq83XouJ1Qzn0N0D1bXTwWzDxC8dCNoPxXWZBLGw9HTXZZyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NahNzQTA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658ED606A31A;
	Wed, 28 Oct 2026 19:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NahNzQTA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AF31F01825;
	Wed, 28 Oct 2026 19:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215494;
	bh=0zRb0BHIcWX+Uma2bofH3fnBsjmR8CiTUIuZB4yeH58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NahNzQTAdLCMo1kkCP4rYL+C+uSRbM/j9egRLVfITsLElJV11S7k1jL4hRHQUBBCC
	 QxcapxzZ+xxp7KiVSEyLMg4xGSnuowwrQHfMjc2NR8dKKMC8PES/MhzPR/+f/P7y4p
	 1V5ELlZwgrIpvU841cNK053n61nE2I6kPccgujOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1187/1887] wifi: cfg80211: convert pmsr_free_wk to wiphy_work to fix deadlock
Date: Wed, 28 Oct 2026 17:54:43 +0100
Message-ID: <20261028170526.418206001@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 net/wireless/core.c    | 4 ++--
 net/wireless/core.h    | 2 +-
 net/wireless/pmsr.c    | 6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c41c032f84c59..b04d249550fe4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5959,7 +5959,7 @@ struct wireless_dev {
 
 	struct list_head pmsr_list;
 	spinlock_t pmsr_lock;
-	struct work_struct pmsr_free_wk;
+	struct wiphy_work pmsr_free_wk;
 
 	unsigned long unprot_beacon_reported;
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 972d785319593..a781893473afe 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1201,7 +1201,7 @@ static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 	ASSERT_RTNL();
 	lockdep_assert_held(&rdev->wiphy.mtx);
 
-	flush_work(&wdev->pmsr_free_wk);
+	wiphy_work_flush(wdev->wiphy, &wdev->pmsr_free_wk);
 
 	nl80211_notify_iface(rdev, wdev, NL80211_CMD_DEL_INTERFACE);
 
@@ -1383,7 +1383,7 @@ void cfg80211_init_wdev(struct wireless_dev *wdev)
 	INIT_LIST_HEAD(&wdev->mgmt_registrations);
 	INIT_LIST_HEAD(&wdev->pmsr_list);
 	spin_lock_init(&wdev->pmsr_lock);
-	INIT_WORK(&wdev->pmsr_free_wk, cfg80211_pmsr_free_wk);
+	wiphy_work_init(&wdev->pmsr_free_wk, cfg80211_pmsr_free_wk);
 
 #ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.default_key = -1;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 18f62a23b7052..733eb2e587c16 100644
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
index e3987ba2d40a0..c84e218930f76 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -635,7 +635,7 @@ static void cfg80211_pmsr_process_abort(struct wireless_dev *wdev)
 	}
 }
 
-void cfg80211_pmsr_free_wk(struct work_struct *work)
+void cfg80211_pmsr_free_wk(struct wiphy *wiphy, struct wiphy_work *work)
 {
 	struct wireless_dev *wdev = container_of(work, struct wireless_dev,
 						 pmsr_free_wk);
@@ -657,7 +657,7 @@ void cfg80211_pmsr_wdev_down(struct wireless_dev *wdev)
 	}
 	spin_unlock_bh(&wdev->pmsr_lock);
 
-	cancel_work_sync(&wdev->pmsr_free_wk);
+	wiphy_work_cancel(wdev->wiphy, &wdev->pmsr_free_wk);
 	if (found)
 		cfg80211_pmsr_process_abort(wdev);
 
@@ -672,7 +672,7 @@ void cfg80211_release_pmsr(struct wireless_dev *wdev, u32 portid)
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



