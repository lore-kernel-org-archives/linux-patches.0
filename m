Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C311A596
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4SO3UAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3DBC433C7;
	Mon,  9 Oct 2023 13:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857620;
	bh=pkIEYF9r9Gs8SE9jyoQmxqpdrYUss1k5oiS3p1HpkFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4SO3UAKhrK7PjKnENcbEpG2Harj1fdvuGog7IjGsXBSJpk7AW5QouiqgO+JIWh13
	 ZfvJz5UUEw7fJgrCXFCRg8MKaRM/qp4GeaTnPpgQj8Rm9fIF1L/8E0OHUeL5tHwS30
	 RGMkrVnlW1OgH91I6NlOUXmQOLawPf6tXfaL8QZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/162] wifi: cfg80211: hold wiphy lock in auto-disconnect
Date: Mon,  9 Oct 2023 15:00:58 +0200
Message-ID: <20231009130125.042777516@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e9da6df7492a981b071bafd169fb4c35b45f5ebf ]

Most code paths in cfg80211 already hold the wiphy lock,
mostly by virtue of being called from nl80211, so make
the auto-disconnect worker also hold it, aligning the
locking promises between different parts of cfg80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 37c20b2effe9 ("wifi: cfg80211: fix cqm_config access race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 6 ++----
 net/wireless/sme.c  | 4 +++-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 609b79fe4a748..9ac7c54379cf3 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1162,10 +1162,6 @@ static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 	kfree_sensitive(wdev->wext.keys);
 	wdev->wext.keys = NULL;
 #endif
-	/* only initialized if we have a netdev */
-	if (wdev->netdev)
-		flush_work(&wdev->disconnect_wk);
-
 	cfg80211_cqm_config_free(wdev);
 
 	/*
@@ -1439,6 +1435,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		cfg80211_leave(rdev, wdev);
 		cfg80211_remove_links(wdev);
 		wiphy_unlock(&rdev->wiphy);
+		/* since we just did cfg80211_leave() nothing to do there */
+		cancel_work_sync(&wdev->disconnect_wk);
 		break;
 	case NETDEV_DOWN:
 		wiphy_lock(&rdev->wiphy);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 6e87d2cd83456..b97834284baef 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -5,7 +5,7 @@
  * (for nl80211's connect() and wext)
  *
  * Copyright 2009	Johannes Berg <johannes@sipsolutions.net>
- * Copyright (C) 2009, 2020, 2022 Intel Corporation. All rights reserved.
+ * Copyright (C) 2009, 2020, 2022-2023 Intel Corporation. All rights reserved.
  * Copyright 2017	Intel Deutschland GmbH
  */
 
@@ -1555,6 +1555,7 @@ void cfg80211_autodisconnect_wk(struct work_struct *work)
 		container_of(work, struct wireless_dev, disconnect_wk);
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 
+	wiphy_lock(wdev->wiphy);
 	wdev_lock(wdev);
 
 	if (wdev->conn_owner_nlportid) {
@@ -1593,4 +1594,5 @@ void cfg80211_autodisconnect_wk(struct work_struct *work)
 	}
 
 	wdev_unlock(wdev);
+	wiphy_unlock(wdev->wiphy);
 }
-- 
2.40.1



