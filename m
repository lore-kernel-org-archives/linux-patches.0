Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C388227701F;
	Tue,  8 Apr 2025 12:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116750; cv=none; b=SVQ45Awnhk9RheoYZCB0rL42iW31epWYlJI6Nt192ASzmihg0vQyCAoIWA9f1HC0gMK1/oJxZDGrPZrMjEeWqw/oYdDiHBdm5Y8ELbt2w4Glo1TefjRw9xOCUqgQwgFz5/vMrjoGU8su9J2fwVd36XAFCVOEQ6At/5vhXFPHr8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116750; c=relaxed/simple;
	bh=0t5YZHyGq3JgjjJQLzWxZuaJTpVp2sTC4oU9g32lt5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/v7frljNxkzKAELCqsFydKgNqtEJtWx/CMQTZ/ihTe54GcbxSjDs/u0q1Ab8bMX96aJS06DJNv4wst0WAGQBRe2Vk191Vk8O+h7cz5vPThDHXZeSlSoXuIpN61Oy/O6LRwaMYD2THZUkFZtNOc9HoWqhvv6P/BREHZTZJfhmiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wP0wOp5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wP0wOp5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE1FC4CEFA;
	Tue,  8 Apr 2025 12:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116750;
	bh=0t5YZHyGq3JgjjJQLzWxZuaJTpVp2sTC4oU9g32lt5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wP0wOp5RkgCP1IRpyLc7nI62my94Ozod96AQY6kYS5iZQMpZ9cOXLNk1KD3cHdHDz
	 i9/Q2GAD5xOb07Zgc6L4vKHHKjoViKK3Y66ZUmL+Dhqw7KPbaHKNqK4SpmniA3URrF
	 gUe4aZVjb+1IXaKJTy76V8oGHids+ToUDCXbbKQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 254/423] wifi: mac80211: remove debugfs dir for virtual monitor
Date: Tue,  8 Apr 2025 12:49:40 +0200
Message-ID: <20250408104851.657845734@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Wetzel <Alexander@wetzel-home.de>

[ Upstream commit 646262c71aca87bb66945933abe4e620796d6c5a ]

Don't call ieee80211_debugfs_recreate_netdev() for virtual monitor
interface when deleting it.

The virtual monitor interface shouldn't have debugfs entries and trying
to update them will *create* them on deletion.

And when the virtual monitor interface is created/destroyed multiple
times we'll get warnings about debugfs name conflicts.

Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
Link: https://patch.msgid.link/20250204164240.370153-1-Alexander@wetzel-home.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/driver-ops.c | 10 ++++++++--
 net/mac80211/iface.c      | 11 ++++++-----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index fe868b5216220..9b7d099948207 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -115,8 +115,14 @@ void drv_remove_interface(struct ieee80211_local *local,
 
 	sdata->flags &= ~IEEE80211_SDATA_IN_DRIVER;
 
-	/* Remove driver debugfs entries */
-	ieee80211_debugfs_recreate_netdev(sdata, sdata->vif.valid_links);
+	/*
+	 * Remove driver debugfs entries.
+	 * The virtual monitor interface doesn't get a debugfs
+	 * entry, so it's exempt here.
+	 */
+	if (sdata != local->monitor_sdata)
+		ieee80211_debugfs_recreate_netdev(sdata,
+						  sdata->vif.valid_links);
 
 	trace_drv_remove_interface(local, sdata);
 	local->ops->remove_interface(&local->hw, &sdata->vif);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index af9055252e6df..8bbfa45e1796d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1205,16 +1205,17 @@ void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 		return;
 	}
 
-	RCU_INIT_POINTER(local->monitor_sdata, NULL);
-	mutex_unlock(&local->iflist_mtx);
-
-	synchronize_net();
-
+	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 	ieee80211_link_release_channel(&sdata->deflink);
 
 	if (ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF))
 		drv_remove_interface(local, sdata);
 
+	RCU_INIT_POINTER(local->monitor_sdata, NULL);
+	mutex_unlock(&local->iflist_mtx);
+
+	synchronize_net();
+
 	kfree(sdata);
 }
 
-- 
2.39.5



