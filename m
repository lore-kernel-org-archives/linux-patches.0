Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1512C1AE84C;
	Thu, 15 Aug 2024 14:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730985; cv=none; b=NsKgyDPIz3knibPP+r1Gjpw1u+JQK8/u7qy4fcIWezshtO1nq1rH2IUZFAqhYN0Y4UNdYlJWI+sL5cgjzLRXo6Jt/WXmfATkCDTKFrGYbdPGT7WOk60cdf30qCJTDK9k0RmCkGCkURAhJIjkbtW9AEOR0W0DnH97ef5hzJk8mck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730985; c=relaxed/simple;
	bh=+epm1Ze4trRhU0LXeWm6ZScHhvIEnN8KHWRGgw3tzw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMhebWV3bW1E1JI0P1uENNnwSmRlMbMXC1RNAy+K6M8uQs2c+A9/1Hx6iefyvMgFnh7gG0Idi5bUk2ucbrmsAmgsUpguQq/WAb9JRqg1qhJeGt9fyEfVn+MnTDbUpPpIVkFe5wwOzTRLT6je7CvdWXxFxSIpH5qMmnfuchZ3TcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzfxSEEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzfxSEEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847E8C32786;
	Thu, 15 Aug 2024 14:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730984;
	bh=+epm1Ze4trRhU0LXeWm6ZScHhvIEnN8KHWRGgw3tzw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzfxSEEQJaORMxAAHPlmsIugay6AzctTEPyTrcai19pb4swwlNDY6iLTMzdoxteJ6
	 J1s3IE4uHW57TJw6fa3xQF0t5lwJS1ARMoeq5dMAiW4/3xF4a4jXl6pq1UxC40a1Mx
	 3njhdPQwZoSGfy7yOI1oG2TUOoxHWc+E5jw46oZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 23/67] wifi: mac80211: take wiphy lock for MAC addr change
Date: Thu, 15 Aug 2024 15:25:37 +0200
Message-ID: <20240815131839.224649878@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6e3bfb46af44d..9ac5252c3da00 100644
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



