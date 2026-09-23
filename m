Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D13386441;
	Wed, 23 Sep 2026 14:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174399; cv=none; b=MX8cQ/UTSlLk2a0dpSXfI8j0hne2SGn3c8fsxC651I0oIPofHRqsRrAvJNsjRjj6FIO8iUo+frQBCt6DDO2n9ZaaC86H0ouzrlcPA5szpga7ypKHqUAaZgvAjhZkBVdfaeq+2vTocWUvaS97fHFiwWdMUVnGCtv5poG0OAhjb2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174399; c=relaxed/simple;
	bh=LDgLLm2A7XjS972H+fP+8b0Npe3ZwiQ2FxLY6DjCnL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4EauphKANp6fIjRLJNmMDqr0yPmSMUlCscTkHhyM46aocay0O3u4kDTBx0f89lnA2mcjc9Buhv63njGW6J722hKuCUFk8vk9VPVaVigwHzwQsie5zY2wCj8sTOwTkaRxrIXpqJPbIoncoIypZ6Tp8I2ru7DppUfxZIKvx9/sps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PC6WAbkT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PC6WAbkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F251F1F000FF;
	Wed, 23 Sep 2026 14:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174398;
	bh=8TMYlmS91MjbWtXlo6Z+QLnE3dK97X+oPsXvD+dWblQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PC6WAbkT82t47Rl72c9w1BvR7bmrpU3Sy1eS5Ym/hXESdYlEbtVP8tBfVFqJ88w9j
	 /LRu7JHgJWRbdRo7TbirVUPQ4yIUlpXtPFD7g/r2BprqFJo8K8GBMlfzZLmHjtRrcQ
	 YbDIk92NgFknEO/2fJjed8ekhWyQLCKHJ+hbiz+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/398] wifi: mac80211: unlist vifs when their netdev is unregistered
Date: Wed, 23 Sep 2026 16:02:24 +0200
Message-ID: <20260923140645.248282868@linuxfoundation.org>
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
index 82eff9e867c1f..3da26d4d75fc3 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -885,9 +885,33 @@ static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
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



