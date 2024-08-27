Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC2F1C4EE6;
	Tue, 27 Aug 2024 14:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770077; cv=none; b=JZeW7eCBXBWFaEfbrnXO2jLw52Y3NLPCKqWDpGtQah6HG8fxcFEtkvdCnS6GD9EcVPN+6I6LPRoXhwlFzaDuVrVO3sHs53xbaPi+ih84sh+cxCtWbrwTGjZ5pN3fHuLNIhuDevbfbeljpU+uLoHH7/OSO73yGWHXgXOn3Vpf1yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770077; c=relaxed/simple;
	bh=llMjLvsDGmnH1A2St0WlXHIO7KSuZ92UvF7nW+yktyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mu5uXD1aaA46GuyiuGbMRLQ28t2+duXLZ7d9IplFZDYEA2DEgDvo7+4qZyedV6MC3eALB6n3/p5eUZ9vqaeDne3zi1kO7rot93j6S9wLvegCS2BFF/VbPotYMXVnruTzPT6x05SLghmHV5tkf6xRqyNfZZTR8LsZEKQpyOhS5Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zi0v58pN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zi0v58pN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918B8C61040;
	Tue, 27 Aug 2024 14:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770077;
	bh=llMjLvsDGmnH1A2St0WlXHIO7KSuZ92UvF7nW+yktyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zi0v58pNE5p95rT0vqXNBZvOFqhSHZIlQ3Uar0s1O9nikqcGXDtFl3sIYjG6oFCiD
	 Dpi653KEz6tnEL4jw1jsq9SV8EKf0GL+nrGn5vvjkoSwjidOFaUDthzVilyRv7PR6E
	 e2R8R+XShB96hSPdRrDBqip5LLuBnhc5xo9yTyxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/341] wifi: mac80211: lock wiphy in IP address notifier
Date: Tue, 27 Aug 2024 16:35:19 +0200
Message-ID: <20240827143846.757004232@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

[ Upstream commit 730538edc8e0eb14b02708f65100a0deaf43e6cd ]

Lock the wiphy in the IP address notifier as another
place that should have it locked before calling into
the driver. This needs a bit of attention since the
notifier can be called while the wiphy is already
locked, when we remove an interface. Handle this by
not running the notifier in this case, and instead
calling out to the driver directly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 14 ++++++++++++++
 net/mac80211/main.c  | 22 +++++++++++++++++++++-
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 52b048807feae..a7c39e895b1e5 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2315,6 +2315,20 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 	list_for_each_entry_safe(sdata, tmp, &unreg_list, list) {
 		bool netdev = sdata->dev;
 
+		/*
+		 * Remove IP addresses explicitly, since the notifier will
+		 * skip the callbacks if wdev->registered is false, since
+		 * we can't acquire the wiphy_lock() again there if already
+		 * inside this locked section.
+		 */
+		sdata_lock(sdata);
+		sdata->vif.cfg.arp_addr_cnt = 0;
+		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+		    sdata->u.mgd.associated)
+			ieee80211_vif_cfg_change_notify(sdata,
+							BSS_CHANGED_ARP_FILTER);
+		sdata_unlock(sdata);
+
 		list_del(&sdata->list);
 		cfg80211_unregister_wdev(&sdata->wdev);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e0c701c5e5f93..066424e62ff09 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -443,7 +443,7 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 	if (!wdev)
 		return NOTIFY_DONE;
 
-	if (wdev->wiphy != local->hw.wiphy)
+	if (wdev->wiphy != local->hw.wiphy || !wdev->registered)
 		return NOTIFY_DONE;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(ndev);
@@ -458,6 +458,25 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 		return NOTIFY_DONE;
 
 	ifmgd = &sdata->u.mgd;
+
+	/*
+	 * The nested here is needed to convince lockdep that this is
+	 * all OK. Yes, we lock the wiphy mutex here while we already
+	 * hold the notifier rwsem, that's the normal case. And yes,
+	 * we also acquire the notifier rwsem again when unregistering
+	 * a netdev while we already hold the wiphy mutex, so it does
+	 * look like a typical ABBA deadlock.
+	 *
+	 * However, both of these things happen with the RTNL held
+	 * already. Therefore, they can't actually happen, since the
+	 * lock orders really are ABC and ACB, which is fine due to
+	 * the RTNL (A).
+	 *
+	 * We still need to prevent recursion, which is accomplished
+	 * by the !wdev->registered check above.
+	 */
+	mutex_lock_nested(&local->hw.wiphy->mtx, 1);
+	__acquire(&local->hw.wiphy->mtx);
 	sdata_lock(sdata);
 
 	/* Copy the addresses to the vif config list */
@@ -476,6 +495,7 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 		ieee80211_vif_cfg_change_notify(sdata, BSS_CHANGED_ARP_FILTER);
 
 	sdata_unlock(sdata);
+	wiphy_unlock(local->hw.wiphy);
 
 	return NOTIFY_OK;
 }
-- 
2.43.0



