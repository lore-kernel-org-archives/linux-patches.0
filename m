Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115C31C8700;
	Tue, 27 Aug 2024 15:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771882; cv=none; b=tNDNMvhe9MU4YDLzHgXTE2pLJcvBTtPxqbMCYL6AdnIBZTXyauh/4mXrByaQlqBuVK+nVbvzXclqr1Fyb0pFX5YvwAtINhaCyWQo7IHMmpfGMewiX9mk3j+haPrlYaUbMN2ZARKHmMsKW8FVDw95t5Pa0CI3tLdfk17vu4oywsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771882; c=relaxed/simple;
	bh=D92b1fVQRwdkPNbX/AhkNw/pl4jyy4ZmrMUuyqnQIvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8OuAMSymh2RQ02gIGKlx2dP6WPw6j1oszpHTHiMm6wsmB4uwkmZxPr6xXGvu5FqTuDlluoww9z57Nfx0lq5GKsWFhQ6oEa/9YOvCoYUwKkFEkqs7ISw8IbBx3UEtOElqPAeC4kFuKauAcigNjqzU39BpxTu7f1RbosZ6ztRBNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIgyMZ97; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIgyMZ97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B99C61040;
	Tue, 27 Aug 2024 15:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771881;
	bh=D92b1fVQRwdkPNbX/AhkNw/pl4jyy4ZmrMUuyqnQIvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIgyMZ97JoHvb1QgMwAJDX3IHmH66Uu57QEn87I18eZS/UE8Jdorf5PSAVIquPYGn
	 aDKQ4AAvAc/VVp1ubWEGmtg0hYfYzXde/u1VVQP0hLvHb3O3Ku2mg61UOpYTH3qbjV
	 0AfMnolaC2zybv9vyNLlUqworRU7wdt+PKgkUe6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/321] wifi: mac80211: take wiphy lock for MAC addr change
Date: Tue, 27 Aug 2024 16:35:57 +0200
Message-ID: <20240827143840.097731509@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

[ Upstream commit a26787aa13974fb0b3fb42bfeb4256c1b686e305 ]

We want to ensure everything holds the wiphy lock,
so also extend that to the MAC change callback.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 74a7c93f45ab ("wifi: mac80211: fix change_address deadlock during unregister")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index e00e1bf0f754a..408ee5afc9ae7 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -251,9 +251,9 @@ static int ieee80211_can_powered_addr_change(struct ieee80211_sub_if_data *sdata
 	return ret;
 }
 
-static int ieee80211_change_mac(struct net_device *dev, void *addr)
+static int _ieee80211_change_mac(struct ieee80211_sub_if_data *sdata,
+				 void *addr)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	struct sockaddr *sa = addr;
 	bool check_dup = true;
@@ -278,7 +278,7 @@ static int ieee80211_change_mac(struct net_device *dev, void *addr)
 
 	if (live)
 		drv_remove_interface(local, sdata);
-	ret = eth_mac_addr(dev, sa);
+	ret = eth_mac_addr(sdata->dev, sa);
 
 	if (ret == 0) {
 		memcpy(sdata->vif.addr, sa->sa_data, ETH_ALEN);
@@ -294,6 +294,19 @@ static int ieee80211_change_mac(struct net_device *dev, void *addr)
 	return ret;
 }
 
+static int ieee80211_change_mac(struct net_device *dev, void *addr)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	int ret;
+
+	wiphy_lock(local->hw.wiphy);
+	ret = _ieee80211_change_mac(sdata, addr);
+	wiphy_unlock(local->hw.wiphy);
+
+	return ret;
+}
+
 static inline int identical_mac_addr_allowed(int type1, int type2)
 {
 	return type1 == NL80211_IFTYPE_MONITOR ||
-- 
2.43.0



