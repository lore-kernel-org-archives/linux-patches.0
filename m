Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF0F25E469;
	Wed, 23 Sep 2026 14:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172914; cv=none; b=tLy7u3yNLAJaLsexwCrqcvsfCpUOZr32jcoGBZ+2xee2tsoLHJfeowSj+EUcOkMehdg5hGP1llOSOn1L4ryLkxuzatZwAMO7q6oL2BtEB+urL2zIoE6pAclpe9Su7lF2YtJn0YBp/LT891N+yQAfokV816jdkxkutbtgzkf81yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172914; c=relaxed/simple;
	bh=9YgSfhapoOcfQv5DVm8lwaQ/MOgkPIHiwsWAisdCS0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxVlj5BshZpyK1J1+EFH/zLSiHnqX+tFsgs1nKKAgn3pCpenHrNllDkMU2fwsCCFyVrv/sC2etagMc9nWSWVZOmpYKIkBL5Rz8gQT+KAn8dGi+c5EpXJO7uhmYxVuwWWFLRLxiwOljSqQV2Y90a0QSQZJfHA4ScFxfQC7og7S/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVtbO8z7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVtbO8z7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE2E1F000FF;
	Wed, 23 Sep 2026 14:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172912;
	bh=ZbPJ8YlZDghDiVJP/vJMz3BRCETTR2E7Lme7sa339rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aVtbO8z73nA+O2ktkz4VAm+e8iH28nTMuTCHpi/e12SeFoS7hfXVaQwV0zL/FL54p
	 dOtVzRmRnSvbRScyX6WhyXady4eeFKl1/ae7N5APA4uqsaSZgvwNUMcaqqy9LrjZT1
	 j+40CVdi85L529vHJjPRXCjz4nTs59B29ZTPqUPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c5f8a81e794d4a4f2014@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 080/438] wifi: cfg80211: get the wiphy out of a dying network namespace
Date: Wed, 23 Sep 2026 16:01:41 +0200
Message-ID: <20260923140646.857590680@linuxfoundation.org>
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
index 59facacf1a36f..bc7e2c50cc726 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -168,20 +168,24 @@ static int cfg80211_switch_wdev_netns(struct wireless_dev *wdev,
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
@@ -199,7 +203,7 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		/* this only fails on allocation failure */
 		err = device_rename(&rdev->wiphy.dev,
 				    dev_name(&rdev->wiphy.dev));
-		if (err)
+		if (err && !force)
 			wiphy_net_set(&rdev->wiphy, old_net);
 
 		nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
@@ -212,8 +216,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		}
 	}
 
-	if (!err)
-		return 0;
+	if (!err || force)
+		return err;
 
 	/* set to the last one to undo all of them */
 	wdev = list_entry(&rdev->wiphy.wdev_list, typeof(*wdev), list);
@@ -229,6 +233,15 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
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
@@ -1879,7 +1892,7 @@ static void __net_exit cfg80211_pernet_exit(struct net *net)
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



