Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F1039EF12;
	Wed, 23 Sep 2026 14:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174402; cv=none; b=rmN/Lfm2uh0tQhsJ6QSGNOHbrSq4YOY87SsCfloUhW9uScwkvdSqFvzaAldDFUSwNoEZUCRcY9dkuMdt0v+9IfAigb5cNNBLu7Mrj+xFq5mIZrVl4TELYC7BRGTkiTK3hMsXCSTsV4DBwsA3PXEBB+G01TrRfMavShjQ6+awEMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174402; c=relaxed/simple;
	bh=ymcJEkQAVIZiTfF07Ma8jUn/kKA6APtTORLtrvcj/2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqoug6g1DE9/CLKxZT4D14I7Ul8uDR3aeF82n3F8HCwv6CxFfdsiwLddSx6xoTbs41riO9A18VMMQwqaSaUbMQEPMt/k0fh4oHO2fkyQwEO8vIkk/cexBkPULOSkb4gmKa5AdTtv/agIUSfOWbjWYRTTL8DpwXuAak4OkVGtm1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFFdfvno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFFdfvno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E271F000FF;
	Wed, 23 Sep 2026 14:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174401;
	bh=1OQy9CBiUVLo925cf9EptmvSLQ40820vW7182ccyc4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFFdfvnok5YDRQaqhmtFEaqEnuSjQY+mqP5rnzCvniNmqC60QqVkHpI0ZKNcLiuDI
	 VoE4oYO7MxUwb+Rmp5Fkx0kHzH16PZB2VmtUfPHZbyYKEAvEJ5uQ8vnhv/vmRDrq3K
	 9lwVdKpLwvSmtn8raOKuYG4fYzukcC68YG/oaniA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c5f8a81e794d4a4f2014@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 071/398] wifi: cfg80211: get the wiphy out of a dying network namespace
Date: Wed, 23 Sep 2026 16:02:25 +0200
Message-ID: <20260923140645.274018247@linuxfoundation.org>
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

[ Upstream commit 4635b1a1c1d693178a537446a6e09963f0fdae52 ]

When a network namespace is destroyed, cfg80211_pernet_exit() moves any
wiphy back to the initial namespace, and just warns if that fails. But
moving an interface can fail (due to allocation failures), and then the
wiphy is left behind with a garbage netns pointer:

  Kernel mode fault at addr 0x30
  genlmsg_multicast_netns.constprop.0+0x46/0xcf [cfg80211]
  nl80211_notify_wiphy+0xcd/0xe8 [cfg80211]
  wiphy_unregister+0x169/0x3fc [cfg80211]

Note that commit debac3a20dec ("net: Remove conflicting altnames for
dying netns in __dev_change_net_namespace().") fixed another path
that could reach it without allocation failures.

Remove interfaces that cannot be moved instead of failing the switch,
so that the wiphy always ends up in the initial namespace. In this
case the netdev core will unregister the interfaces anyway.

Assisted-by: LLM
Reported-by: syzbot+c5f8a81e794d4a4f2014@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c5f8a81e794d4a4f2014
Fixes: 463d018323851 ("cfg80211: make aware of net namespaces")
Link: https://patch.msgid.link/20260904170220.7f3edc6d9992.I5e57921011244d3d8ef14d89e738aa19a5d972a0@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index c38a737171569..01e44ba4eddd1 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -165,20 +165,24 @@ static int cfg80211_switch_wdev_netns(struct wireless_dev *wdev,
 	return err;
 }
 
-int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
-			  struct net *net)
+static int __cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
+				   struct net *net, bool force)
 {
 	struct net *old_net = wiphy_net(&rdev->wiphy);
-	struct wireless_dev *wdev;
+	struct wireless_dev *wdev, *tmp;
 	int err = 0;
 
-	if (!(rdev->wiphy.flags & WIPHY_FLAG_NETNS_OK))
-		return -EOPNOTSUPP;
-
-	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+	list_for_each_entry_safe(wdev, tmp, &rdev->wiphy.wdev_list, list) {
 		err = cfg80211_switch_wdev_netns(wdev, net);
-		if (err)
+		if (!err)
+			continue;
+		if (!force)
 			goto undo;
+		/* remove interfaces that fail to allow wiphy switching */
+		dev_close(wdev->netdev);
+		scoped_guard(wiphy, &rdev->wiphy)
+			cfg80211_unregister_wdev(wdev);
+		err = 0;
 	}
 
 	scoped_guard(wiphy, &rdev->wiphy) {
@@ -196,7 +200,7 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		/* this only fails on allocation failure */
 		err = device_rename(&rdev->wiphy.dev,
 				    dev_name(&rdev->wiphy.dev));
-		if (err)
+		if (err && !force)
 			wiphy_net_set(&rdev->wiphy, old_net);
 
 		nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
@@ -209,8 +213,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		}
 	}
 
-	if (!err)
-		return 0;
+	if (!err || force)
+		return err;
 
 	/* set to the last one to undo all of them */
 	wdev = list_entry(&rdev->wiphy.wdev_list, typeof(*wdev), list);
@@ -226,6 +230,15 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 	return err;
 }
 
+int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
+			  struct net *net)
+{
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_NETNS_OK))
+		return -EOPNOTSUPP;
+
+	return __cfg80211_switch_netns(rdev, net, false);
+}
+
 static void cfg80211_rfkill_poll(struct rfkill *rfkill, void *data)
 {
 	struct cfg80211_registered_device *rdev = data;
@@ -1764,7 +1777,7 @@ static void __net_exit cfg80211_pernet_exit(struct net *net)
 	rtnl_lock();
 	for_each_rdev(rdev) {
 		if (net_eq(wiphy_net(&rdev->wiphy), net))
-			WARN_ON(cfg80211_switch_netns(rdev, &init_net));
+			WARN_ON(__cfg80211_switch_netns(rdev, &init_net, true));
 	}
 	rtnl_unlock();
 }
-- 
2.53.0



