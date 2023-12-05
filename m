Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA176FB1;
	Tue,  5 Dec 2023 03:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SK0YempZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BBAC433C7;
	Tue,  5 Dec 2023 03:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747085;
	bh=8Z5ybYsUxr3h1cGV3fHHROKZjTlZXJWK8NOivwq2vco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SK0YempZy/70Z7Px5YU40HMb+b1NKqJ/hS/lA7n6CfDOT3N95pNEBUMFthPDeLzNb
	 /ZBLGNEUbukCpM9B8/M1mkro7zHOXesivMOp556DZBrKR2PuSvU50U+fxP4IXwTIdJ
	 ubAIiuTZclVxHySmJu7QSKuvdRjh5cnjzyoBTTMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 054/107] wifi: cfg80211: fix CQM for non-range use
Date: Tue,  5 Dec 2023 12:16:29 +0900
Message-ID: <20231205031534.727119128@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

commit 7e7efdda6adb385fbdfd6f819d76bc68c923c394 upstream.

My prior race fix here broke CQM when ranges aren't used, as
the reporting worker now requires the cqm_config to be set in
the wdev, but isn't set when there's no range configured.

Rather than continuing to special-case the range version, set
the cqm_config always and configure accordingly, also tracking
if range was used or not to be able to clear the configuration
appropriately with the same API, which was actually not right
if both were implemented by a driver for some reason, as is
the case with mac80211 (though there the implementations are
equivalent so it doesn't matter.)

Also, the original multiple-RSSI commit lost checking for the
callback, so might have potentially crashed if a driver had
neither implementation, and userspace tried to use it despite
not being advertised as supported.

Cc: stable@vger.kernel.org
Fixes: 4a4b8169501b ("cfg80211: Accept multiple RSSI thresholds for CQM")
Fixes: 37c20b2effe9 ("wifi: cfg80211: fix cqm_config access race")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.h    |    1 
 net/wireless/nl80211.c |   50 ++++++++++++++++++++++++++++++-------------------
 2 files changed, 32 insertions(+), 19 deletions(-)

--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -297,6 +297,7 @@ struct cfg80211_cqm_config {
 	u32 rssi_hyst;
 	s32 last_rssi_event_value;
 	enum nl80211_cqm_rssi_threshold_event last_rssi_event_type;
+	bool use_range_api;
 	int n_rssi_thresholds;
 	s32 rssi_thresholds[];
 };
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12574,10 +12574,6 @@ static int cfg80211_cqm_rssi_update(stru
 	int i, n, low_index;
 	int err;
 
-	/* RSSI reporting disabled? */
-	if (!cqm_config)
-		return rdev_set_cqm_rssi_range_config(rdev, dev, 0, 0);
-
 	/*
 	 * Obtain current RSSI value if possible, if not and no RSSI threshold
 	 * event has been received yet, we should receive an event after a
@@ -12652,18 +12648,6 @@ static int nl80211_set_cqm_rssi(struct g
 	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
 		return -EOPNOTSUPP;
 
-	if (n_thresholds <= 1 && rdev->ops->set_cqm_rssi_config) {
-		if (n_thresholds == 0 || thresholds[0] == 0) /* Disabling */
-			return rdev_set_cqm_rssi_config(rdev, dev, 0, 0);
-
-		return rdev_set_cqm_rssi_config(rdev, dev,
-						thresholds[0], hysteresis);
-	}
-
-	if (!wiphy_ext_feature_isset(&rdev->wiphy,
-				     NL80211_EXT_FEATURE_CQM_RSSI_LIST))
-		return -EOPNOTSUPP;
-
 	if (n_thresholds == 1 && thresholds[0] == 0) /* Disabling */
 		n_thresholds = 0;
 
@@ -12671,6 +12655,20 @@ static int nl80211_set_cqm_rssi(struct g
 	old = rcu_dereference_protected(wdev->cqm_config,
 					lockdep_is_held(&wdev->mtx));
 
+	/* if already disabled just succeed */
+	if (!n_thresholds && !old)
+		return 0;
+
+	if (n_thresholds > 1) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_CQM_RSSI_LIST) ||
+		    !rdev->ops->set_cqm_rssi_range_config)
+			return -EOPNOTSUPP;
+	} else {
+		if (!rdev->ops->set_cqm_rssi_config)
+			return -EOPNOTSUPP;
+	}
+
 	if (n_thresholds) {
 		cqm_config = kzalloc(struct_size(cqm_config, rssi_thresholds,
 						 n_thresholds),
@@ -12685,13 +12683,26 @@ static int nl80211_set_cqm_rssi(struct g
 		memcpy(cqm_config->rssi_thresholds, thresholds,
 		       flex_array_size(cqm_config, rssi_thresholds,
 				       n_thresholds));
+		cqm_config->use_range_api = n_thresholds > 1 ||
+					    !rdev->ops->set_cqm_rssi_config;
 
 		rcu_assign_pointer(wdev->cqm_config, cqm_config);
+
+		if (cqm_config->use_range_api)
+			err = cfg80211_cqm_rssi_update(rdev, dev, cqm_config);
+		else
+			err = rdev_set_cqm_rssi_config(rdev, dev,
+						       thresholds[0],
+						       hysteresis);
 	} else {
 		RCU_INIT_POINTER(wdev->cqm_config, NULL);
+		/* if enabled as range also disable via range */
+		if (old->use_range_api)
+			err = rdev_set_cqm_rssi_range_config(rdev, dev, 0, 0);
+		else
+			err = rdev_set_cqm_rssi_config(rdev, dev, 0, 0);
 	}
 
-	err = cfg80211_cqm_rssi_update(rdev, dev, cqm_config);
 	if (err) {
 		rcu_assign_pointer(wdev->cqm_config, old);
 		kfree_rcu(cqm_config, rcu_head);
@@ -18758,10 +18769,11 @@ void cfg80211_cqm_rssi_notify_work(struc
 	wdev_lock(wdev);
 	cqm_config = rcu_dereference_protected(wdev->cqm_config,
 					       lockdep_is_held(&wdev->mtx));
-	if (!wdev->cqm_config)
+	if (!cqm_config)
 		goto unlock;
 
-	cfg80211_cqm_rssi_update(rdev, wdev->netdev, cqm_config);
+	if (cqm_config->use_range_api)
+		cfg80211_cqm_rssi_update(rdev, wdev->netdev, cqm_config);
 
 	rssi_level = cqm_config->last_rssi_event_value;
 	rssi_event = cqm_config->last_rssi_event_type;


