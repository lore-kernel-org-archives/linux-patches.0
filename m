Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD042318EC5;
	Wed, 30 Sep 2026 16:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785779; cv=none; b=F4p6I9WXlNnIiV8TmW2zwZS3kboGYa5povySZlcsyvVd7SZttLd3SJIDu4KHeVAuDg55kGIujbllBkF3KpMcQjMaDfA6VXIsPU4gggpVYKPvVZYsKAPk0gr+HetZHjTpzVPsqPWKljFesW5mx72ln/xg0AKB60jHgPfWMO3qM7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785779; c=relaxed/simple;
	bh=xQfcEf7FG7PA46lNBOYD9/TVfSLoWX9rCmiFZe6STzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOazQ3R2Ku1BE1/mwgTypEcrNuTRp3CSc978WoRZB4g7JQuZ/pz6jAZ6JXsFpbRB4Ods4+Uote+7nKO9wGpUbE/bXmTyFUpswMpp+hI8iC9bqeLQA+CfYFyqZeiW9DpcyWdn+j4nZwP7Asg4zstohQVzlPuKca4cQlvAGVjJoN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZr6VE2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZr6VE2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F211F000FF;
	Wed, 30 Sep 2026 16:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785778;
	bh=57KJy9OQWIpHo3I13RKWTg0/64qC/N3IagwHo0uEnrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZr6VE2Sqk2M7GACZpijEIvrtqurFd8rY+k5jEMrV03pwjucDhVN4uhrA4oIfwJX6
	 fmyMdz0S2xn7fIqVriC15HmwUg6fOJtuDi3inkyp2WGY5TSxGF4P9oOK9JQW8tsVSV
	 EIAmW9XVbhh0n6acFlFCqlP95oK9N3r/uW5Fo+Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 628/982] wifi: mac80211: unlist vifs when their netdev is unregistered
Date: Wed, 30 Sep 2026 17:22:44 +0200
Message-ID: <20260930152430.261416807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4224a7c244a3d..ee28c190faab3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -861,9 +861,33 @@ static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
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
 
 static u16 ieee80211_netdev_select_queue(struct net_device *dev,
-- 
2.53.0



