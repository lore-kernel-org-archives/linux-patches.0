Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727A84F3EAA;
	Wed, 30 Sep 2026 17:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788346; cv=none; b=GKPv8z5+m3Guit4FlhLATxGIWLb4jweHALv2TQzcClWwlSKqG8pgcMAu5xSiIVCbxCuKhJJ8E80I8CqEUQkAZDcdzdXxrbtIn4THX8jKQrNKU+geCb3kEHJUfnob3DiY4Hyo1cLkNjgl8p5ZDTwooy/AlAlBdw+Kvv0S1+9udOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788346; c=relaxed/simple;
	bh=vJOG6h0Q0HH717wg03hMsZAmkEjksYhVCwTvF2joQ4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hch4+M9fhe24iGv9qNrKs2beI8obu4fuMIg4sxEzx08Q3+mSgWQVqVRy0iRo346DVdQzWTrjTA/OUrVY0YinERuWPCy66zi1Yy0aJmDiR0Kk/U0NAt2n4XvEVI7n7cLm/oQj8gCdDPw9QMfWfzYEM4V097s3j0pkoyPb/CfjIaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5c8Vwkj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5c8Vwkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD28F1F00899;
	Wed, 30 Sep 2026 17:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788345;
	bh=xs2Cnv3IfYY7A/2ofIuyOG3waeZLyZ0vQJyHLrEewpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z5c8VwkjnFeq+icr8T29c32STl1TyUFzQ3KKLEpE9bAdJLR0EX+aO08RqqnaW0QW+
	 ntQUyU9FCXJnju3G/A3HaruMq9D5iej++vxTDJKHr16iZ+ERPaj9STua5DM2+G7NdF
	 tJW1kzf5icDgKxwcP+nAje4JrBaVNiXGUxaktZyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/877] wifi: mac80211: unlist vifs when their netdev is unregistered
Date: Wed, 30 Sep 2026 17:16:16 +0200
Message-ID: <20260930152416.143249271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit eee2efd82867b623982ac51925b5a1812a74c50d ]

mac80211 only removes vifs from the local->interfaces list when
an interface is removed via ieee80211_if_remove(), before it
unregisters the netdev. However, it's possible for a netdev to
be unregistered without going through that: When the netns that
holds the wiphy is destroyed, the wiphy is supposed to move to
the init_ns, but that can run into allocation failures.

Then, mac80211 has an interface listed that doesn't exist, and
will eventually hit

  BUG: failure at net/wireless/core.h:141/wiphy_to_rdev()!
  ...
  _cfg80211_unregister_wdev+0x24/0x36a [cfg80211]
  cfg80211_unregister_wdev+0x15/0x1d [cfg80211]
  ieee80211_remove_interfaces+0x1ff/0x257 [mac80211]
  ieee80211_unregister_hw+0x73/0x1d1 [mac80211]
  mac80211_hwsim_del_radio+0x114/0x166 [mac80211_hwsim]

Remove the interface from the list in ->ndo_uninit if it's still
around to avoid this.

Assisted-by: LLM
Fixes: 463d018323851 ("cfg80211: make aware of net namespaces")
Link: https://patch.msgid.link/20260904170220.038ad73e6c04.I990abca78483e058746b6f42b4796717c3028164@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 98bc924d74fa6..ac0a7374d721a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -862,9 +862,33 @@ static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 	ieee80211_link_stop(&sdata->deflink);
 }
 
+/*
+ * The netdev can be unregistered without mac80211 doing it, e.g. by the netdev
+ * core when cfg80211 couldn't move it out of a network namespace that's being
+ * destroyed. Drop it from the interface list either way.
+ */
+static void ieee80211_unlist_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sub_if_data *iter;
+
+	ASSERT_RTNL();
+
+	list_for_each_entry(iter, &local->interfaces, list) {
+		if (iter != sdata)
+			continue;
+		guard(mutex)(&local->iflist_mtx);
+		list_del_rcu(&sdata->list);
+		return;
+	}
+}
+
 static void ieee80211_uninit(struct net_device *dev)
 {
-	ieee80211_teardown_sdata(IEEE80211_DEV_TO_SUB_IF(dev));
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	ieee80211_unlist_sdata(sdata);
+	ieee80211_teardown_sdata(sdata);
 }
 
 static int ieee80211_netdev_setup_tc(struct net_device *dev,
-- 
2.53.0



