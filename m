Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0870E50B429;
	Wed, 23 Sep 2026 14:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174384; cv=none; b=Dx7Mk5wa2h+LCKalWQCbFPXjD4DBBkjCsgLCa28lJiTPh+MGfjyAdIOhXlaobZDgrQUdZ4iV890g+VhqygtKcV+BD8+d/W1sacwH/s2fcxDfsi96hDu4kcu4INwvb7nt8dJijlgWVNX2ag1JCiSwYWK6XWkx2esY8bMgsZuIgoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174384; c=relaxed/simple;
	bh=u4iaLNxkQ7eJDJU7L/YYAiAVlapqeX8Z3avDcWRQrGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOzJ6MfeqQmsv9rgIqUQ/v1wWTAjBsq5+vFa7iLsp1a3WJ6WIsEhXbUhR9m7f7iAHYJxIGFcEEegayrzHLJ2aLsoTrH7teoUALH+AxVxOCImNiLvA+/y2N7j+LR+1BEMzKahd6+ouVNk03Rqv6gA+g7rkUES7k54aX8q+vFqytQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewIKUSMj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewIKUSMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9281F000FF;
	Wed, 23 Sep 2026 14:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174382;
	bh=xPHwY2lOqv/0TESULw2Oikl2k9CdUp2dgSfZx96aBfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewIKUSMjVv43bNkLHFQyHkufEceYUGFL+r+Rxh1uaOunMKcucR8mN32BoAR6hZstv
	 wJ0MLc2eZWAo5t+9TZl49Us+a67+HDP1OWAuY2OTvvcHIfT2LzGB+4/oyqiezTmN25
	 q9Nck6Wo7xwg97BG+ss8n8A8DR0rq2z+EMFjgQeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3515319a302224e081b4@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/398] wifi: cfg80211: undo netns switch if renaming the wiphy fails
Date: Wed, 23 Sep 2026 16:02:23 +0200
Message-ID: <20260923140645.222618731@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a41bd1938a9bfe226d444172a7e20e4bd5097960 ]

Once all the interfaces have been moved, cfg80211_switch_netns()
moves the wiphy itself by setting its network namespace and then
renaming it, which makes sysfs move it. The rename can fail (but
only on allocation failures), leaving things mixed up and hitting
the warning there.

Ignoring it isn't great, undo the move and let the change fail
in this case. If undo fails then WARN, then things would again
be stuck in two different network namespaces.

Assisted-by: LLM
Reported-by: syzbot+3515319a302224e081b4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3515319a302224e081b4
Fixes: 463d018323851 ("cfg80211: make aware of net namespaces")
Link: https://patch.msgid.link/20260904170220.7966cc705e33.Ib398351113bbd3cab85302467060cab378564421@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 88 +++++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 38 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 3c11f35f957db..c38a737171569 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -150,9 +150,25 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
+static int cfg80211_switch_wdev_netns(struct wireless_dev *wdev,
+				      struct net *net)
+{
+	int err;
+
+	if (!wdev->netdev)
+		return 0;
+
+	wdev->netdev->netns_immutable = false;
+	err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
+	wdev->netdev->netns_immutable = true;
+
+	return err;
+}
+
 int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			  struct net *net)
 {
+	struct net *old_net = wiphy_net(&rdev->wiphy);
 	struct wireless_dev *wdev;
 	int err = 0;
 
@@ -160,58 +176,54 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		return -EOPNOTSUPP;
 
 	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
-		if (!wdev->netdev)
-			continue;
-		wdev->netdev->netns_immutable = false;
-		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
-		wdev->netdev->netns_immutable = true;
+		err = cfg80211_switch_wdev_netns(wdev, net);
 		if (err)
-			break;
+			goto undo;
 	}
 
-	if (err) {
-		/* failed -- clean up to old netns */
-		net = wiphy_net(&rdev->wiphy);
-
-		list_for_each_entry_continue_reverse(wdev,
-						     &rdev->wiphy.wdev_list,
-						     list) {
+	scoped_guard(wiphy, &rdev->wiphy) {
+		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 			if (!wdev->netdev)
 				continue;
-			wdev->netdev->netns_immutable = false;
-			err = dev_change_net_namespace(wdev->netdev, net,
-							"wlan%d");
-			WARN_ON(err);
-			wdev->netdev->netns_immutable = true;
+			nl80211_notify_iface(rdev, wdev,
+					     NL80211_CMD_DEL_INTERFACE);
 		}
 
-		return err;
-	}
+		nl80211_notify_wiphy(rdev, NL80211_CMD_DEL_WIPHY);
 
-	guard(wiphy)(&rdev->wiphy);
+		wiphy_net_set(&rdev->wiphy, net);
 
-	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
-		if (!wdev->netdev)
-			continue;
-		nl80211_notify_iface(rdev, wdev, NL80211_CMD_DEL_INTERFACE);
-	}
-
-	nl80211_notify_wiphy(rdev, NL80211_CMD_DEL_WIPHY);
+		/* this only fails on allocation failure */
+		err = device_rename(&rdev->wiphy.dev,
+				    dev_name(&rdev->wiphy.dev));
+		if (err)
+			wiphy_net_set(&rdev->wiphy, old_net);
 
-	wiphy_net_set(&rdev->wiphy, net);
+		nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
 
-	err = device_rename(&rdev->wiphy.dev, dev_name(&rdev->wiphy.dev));
-	WARN_ON(err);
+		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+			if (!wdev->netdev)
+				continue;
+			nl80211_notify_iface(rdev, wdev,
+					     NL80211_CMD_NEW_INTERFACE);
+		}
+	}
 
-	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
+	if (!err)
+		return 0;
 
-	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
-		if (!wdev->netdev)
-			continue;
-		nl80211_notify_iface(rdev, wdev, NL80211_CMD_NEW_INTERFACE);
-	}
+	/* set to the last one to undo all of them */
+	wdev = list_entry(&rdev->wiphy.wdev_list, typeof(*wdev), list);
+undo:
+	/*
+	 * Move back everything, if this fails again (allocation failures)
+	 * then things get stuck in different network namespaces.
+	 */
+	list_for_each_entry_continue_reverse(wdev, &rdev->wiphy.wdev_list,
+					     list)
+		WARN_ON(cfg80211_switch_wdev_netns(wdev, old_net));
 
-	return 0;
+	return err;
 }
 
 static void cfg80211_rfkill_poll(struct rfkill *rfkill, void *data)
-- 
2.53.0



