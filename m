Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F051DA31F;
	Mon,  6 Jan 2025 15:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177045; cv=none; b=T26JEw5sCvMGy1iZDuPpELYxbG0SqkaTjWxFIb1i7f08WMEnpd1DCM0JWGFEP0XTXOgat/+rv30myQonk1dXnOwEeyZmUf5oxbl7EzyPXMXNk+fRAc9BuuGSW4+PKpYdEgYXCt5ZhfaKEkKJX98nhHsmCq4MQunJR0PYOXZBb0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177045; c=relaxed/simple;
	bh=/uGj4sqkh6Ol7Gp9CawK7fDAf4n0SwImLoty8ipM1c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7kwic8pabiyqUDTVpn7q5V8bsPfyRAdrvuCBKNUDns9Cp87yX6Wl/vU7bhywV7oKUyJK8zHc6XKkdBhedjyLvzzLlVAgodupusiSEyB0qduUzoblaB2/MOs4thpv1y949LTW4Kwo2v9FdsdZehPqh97duALRboxqmKnnD4uM3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9DjoIpa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9DjoIpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E23C4CED2;
	Mon,  6 Jan 2025 15:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177045;
	bh=/uGj4sqkh6Ol7Gp9CawK7fDAf4n0SwImLoty8ipM1c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9DjoIpam4ThD0FxR5Tk7O9FRqXimJbn1JDRke8MlRGLjvHeop377JZ/FmVeG9NNi
	 fzTdoDMvNxzrXKY2QtWiMIlVLPSFjUFQs3ZUTjYrDOFLDPpy5GYlee8LqZXyciZ4np
	 cEDkIkJnbARj47sg9HECJeD7GUH7K9gq9y4XOsAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rory Little <rory@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/222] wifi: mac80211: Add non-atomic station iterator
Date: Mon,  6 Jan 2025 16:13:57 +0100
Message-ID: <20250106151151.857834175@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rory Little <rory@candelatech.com>

[ Upstream commit 7c3b69eadea9e57c28bf914b0fd70f268f3682e1 ]

Drivers may at times want to iterate their stations with a function
which requires some non-atomic operations.

ieee80211_iterate_stations_mtx() introduces an API to iterate stations
while holding that wiphy's mutex. This allows the iterating function to
do non-atomic operations safely.

Signed-off-by: Rory Little <rory@candelatech.com>
Link: https://patch.msgid.link/20240806004024.2014080-2-rory@candelatech.com
[unify internal list iteration functions]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 8fac3266c68a ("wifi: ath12k: fix atomic calls in ath12k_mac_op_set_bitrate_mask()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h | 18 ++++++++++++++++++
 net/mac80211/util.c    | 16 +++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 901fe3ac139e..835a58ce9ca5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6080,6 +6080,24 @@ void ieee80211_iterate_stations_atomic(struct ieee80211_hw *hw,
 				       void (*iterator)(void *data,
 						struct ieee80211_sta *sta),
 				       void *data);
+
+/**
+ * ieee80211_iterate_stations_mtx - iterate stations
+ *
+ * This function iterates over all stations associated with a given
+ * hardware that are currently uploaded to the driver and calls the callback
+ * function for them. This version can only be used while holding the wiphy
+ * mutex.
+ *
+ * @hw: the hardware struct of which the interfaces should be iterated over
+ * @iterator: the iterator function to call
+ * @data: first argument of the iterator function
+ */
+void ieee80211_iterate_stations_mtx(struct ieee80211_hw *hw,
+				    void (*iterator)(void *data,
+						     struct ieee80211_sta *sta),
+				    void *data);
+
 /**
  * ieee80211_queue_work - add work onto the mac80211 workqueue
  *
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d682c32821a1..cc3c46a82077 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -827,7 +827,8 @@ static void __iterate_stations(struct ieee80211_local *local,
 {
 	struct sta_info *sta;
 
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+	list_for_each_entry_rcu(sta, &local->sta_list, list,
+				lockdep_is_held(&local->hw.wiphy->mtx)) {
 		if (!sta->uploaded)
 			continue;
 
@@ -848,6 +849,19 @@ void ieee80211_iterate_stations_atomic(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_stations_atomic);
 
+void ieee80211_iterate_stations_mtx(struct ieee80211_hw *hw,
+				    void (*iterator)(void *data,
+						     struct ieee80211_sta *sta),
+				    void *data)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	__iterate_stations(local, iterator, data);
+}
+EXPORT_SYMBOL_GPL(ieee80211_iterate_stations_mtx);
+
 struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
-- 
2.39.5



