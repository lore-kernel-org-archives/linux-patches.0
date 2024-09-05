Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA80198E93;
	Thu,  5 Sep 2024 09:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529712; cv=none; b=aU4Lj0hxpCqCfHJFjGbpK3Y/A6GpkcpQDjMMpEEQ5952WhtfEdv3vgaY/zGZGpvYMXPTcGr6kenw27oHADVWvrYmfj9zs5dvw7O5vYIgFvQmOjx37g6lMz6pM8NWNbCK8ewM6MN3EpV5ADtsd5vVRVTDVSTDHaPl7DU9HgQRL+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529712; c=relaxed/simple;
	bh=sAvZvj2FyUw9D6tRBizVzvuG6LbAscZ4sKQGDK872Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rb1T7uAsX50JK+9Nnd4snw9T0+xLgA1z7m+kOqpfxRYrNbKHR9ix6teFrwPEX0VcAN2driD+Q1+4WQsWMh7/DYyMkRbniJwJhx2Kdz+xRyvnQb2xKuOozFtFfUrbkPOW6PzRkjPQkiVgn9CO6QwO7h4FvAOVUwxoQ6RcgnWhLB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHc3QK3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHc3QK3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D936C4CEC3;
	Thu,  5 Sep 2024 09:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529712;
	bh=sAvZvj2FyUw9D6tRBizVzvuG6LbAscZ4sKQGDK872Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHc3QK3MHcbwWIq0xEvDSed6Tp7OHeaxbshSYUTLocjcfMaVtL3jTsRto79B73dR+
	 pBWVzL6ztiKt0+QOHa/Tzs+Wreq0Iqq1tKb/UcXxisbTMNEBmUjSyJ0Aco/1Iyzk8w
	 vXDv1X/IoM9ZAjT2lunYgxgYFWLBezTJLMzDUp8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 119/184] wifi: cfg80211: restrict operation during radar detection
Date: Thu,  5 Sep 2024 11:40:32 +0200
Message-ID: <20240905093736.874777422@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2d33ecf5d0148671c74e68e18755b9411a7ba923 ]

Just like it's not currently possible to start radar
detection while already operating, it shouldn't be
possible to start operating while radar detection is
running. Fix that.

Also, improve the check whether operating (carrier
might not be up if e.g. attempting to join IBSS).

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240506211158.ae8dca3d0d6c.I7c70a66a5fbdbc63a78fee8a34f31d1995491bc3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/ibss.c    |  5 ++++-
 net/wireless/mesh.c    |  5 ++++-
 net/wireless/nl80211.c | 21 +++++++++++++++------
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 9f02ee5f08be..34e5acff3935 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -3,7 +3,7 @@
  * Some IBSS support code for cfg80211.
  *
  * Copyright 2009	Johannes Berg <johannes@sipsolutions.net>
- * Copyright (C) 2020-2023 Intel Corporation
+ * Copyright (C) 2020-2024 Intel Corporation
  */
 
 #include <linux/etherdevice.h>
@@ -94,6 +94,9 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 
 	lockdep_assert_held(&rdev->wiphy.mtx);
 
+	if (wdev->cac_started)
+		return -EBUSY;
+
 	if (wdev->u.ibss.ssid_len)
 		return -EALREADY;
 
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 83306979fbe2..aaca65b66af4 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Portions
- * Copyright (C) 2022-2023 Intel Corporation
+ * Copyright (C) 2022-2024 Intel Corporation
  */
 #include <linux/ieee80211.h>
 #include <linux/export.h>
@@ -127,6 +127,9 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (!rdev->ops->join_mesh)
 		return -EOPNOTSUPP;
 
+	if (wdev->cac_started)
+		return -EBUSY;
+
 	if (!setup->chandef.chan) {
 		/* if no channel explicitly given, use preset channel */
 		setup->chandef = wdev->u.mesh.preset_chandef;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c2829d673bc7..967bc4935b4e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5965,6 +5965,9 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->start_ap)
 		return -EOPNOTSUPP;
 
+	if (wdev->cac_started)
+		return -EBUSY;
+
 	if (wdev->links[link_id].ap.beacon_interval)
 		return -EALREADY;
 
@@ -9957,6 +9960,17 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 
 	flush_delayed_work(&rdev->dfs_update_channels_wk);
 
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_MESH_POINT:
+	case NL80211_IFTYPE_ADHOC:
+		break;
+	default:
+		/* caution - see cfg80211_beaconing_iface_active() below */
+		return -EINVAL;
+	}
+
 	wiphy_lock(wiphy);
 
 	dfs_region = reg_get_dfs_region(wiphy);
@@ -9987,12 +10001,7 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 		goto unlock;
 	}
 
-	if (netif_carrier_ok(dev)) {
-		err = -EBUSY;
-		goto unlock;
-	}
-
-	if (wdev->cac_started) {
+	if (cfg80211_beaconing_iface_active(wdev) || wdev->cac_started) {
 		err = -EBUSY;
 		goto unlock;
 	}
-- 
2.43.0



