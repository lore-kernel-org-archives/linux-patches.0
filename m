Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7641465A8;
	Tue, 25 Jun 2024 09:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308760; cv=none; b=G4suxW8QwfREs+94fJIY/wmTrqUTVNoTz1wcYNjkPHPRWvfiusdIYyuqFB6Q5rkuy/tSHOzSuKPct1qzeECkukbvsGRemQFqgSkmoEt0/g2ENNgp7PiPUORWOrHMVzPUwZ00DS7Atsn+hLYm9Wim+dAFBJpFJjN5VAIq7rBmwz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308760; c=relaxed/simple;
	bh=zsBdnFXGqz8DnIMB3hTSaOBunWrkqi5iBV3YEKgcP54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4xCH5Cr/8E/6Q+1E5JzUQJjIbFzpwVzv+EORqtGLkMS3nKuaaIRTX2DxZ6GI1Dyd8LMd06R+RLNz/73HijLoOKd+DMBhBS/MVmKkVV+wRRMgDW3kNcaD6/w7Cr/K+1sUnwJmL9Ma+Za3Pl8JNr9KWyECXkE0moCNSMPlXkHurg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+TDFqCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+TDFqCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EB0C32781;
	Tue, 25 Jun 2024 09:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308760;
	bh=zsBdnFXGqz8DnIMB3hTSaOBunWrkqi5iBV3YEKgcP54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+TDFqCEXfDvliaQaFQPv0rm97AVykpcWEUPqfNxzLf+9BdSSb/ilPfB42dD8rN49
	 d/ZYBJKNU8S9G4bl+xFOKKVMdHtKrlrxvaBRFfgBwGStWwAjax7itiLRTTDwFJm7W9
	 y2RE9bspfsok/Du1YF9hq2ByqqHORAzFg1GB1RD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Savyasaachi Vanga <savyasaachiv@gmail.com>
Subject: [PATCH 6.9 199/250] wifi: mac80211: fix monitor channel with chanctx emulation
Date: Tue, 25 Jun 2024 11:32:37 +0200
Message-ID: <20240625085555.692174084@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 0d9c2beed116e623ac30810d382bd67163650f98 upstream.

After the channel context emulation, there were reports that
changing the monitor channel no longer works. This is because
those drivers don't have WANT_MONITOR_VIF, so the setting the
channel always exits out quickly.

Fix this by always allocating the virtual monitor sdata, and
simply not telling the driver about it unless it wanted to.
This way, we have an interface/sdata to bind the chanctx to,
and the emulation can work correctly.

Cc: stable@vger.kernel.org
Fixes: 0a44dfc07074 ("wifi: mac80211: simplify non-chanctx drivers")
Reported-and-tested-by: Savyasaachi Vanga <savyasaachiv@gmail.com>
Closes: https://lore.kernel.org/r/chwoymvpzwtbmzryrlitpwmta5j6mtndocxsyqvdyikqu63lon@gfds653hkknl
Link: https://msgid.link/20240612122351.b12d4a109dde.I1831a44417faaab92bea1071209abbe4efbe3fba@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/driver-ops.c |   17 +++++++++++++++++
 net/mac80211/iface.c      |   21 +++++++++------------
 net/mac80211/util.c       |    2 +-
 3 files changed, 27 insertions(+), 13 deletions(-)

--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -311,6 +311,18 @@ int drv_assign_vif_chanctx(struct ieee80
 	might_sleep();
 	lockdep_assert_wiphy(local->hw.wiphy);
 
+	/*
+	 * We should perhaps push emulate chanctx down and only
+	 * make it call ->config() when the chanctx is actually
+	 * assigned here (and unassigned below), but that's yet
+	 * another change to all drivers to add assign/unassign
+	 * emulation callbacks. Maybe later.
+	 */
+	if (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
+	    local->emulate_chanctx &&
+	    !ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF))
+		return 0;
+
 	if (!check_sdata_in_driver(sdata))
 		return -EIO;
 
@@ -338,6 +350,11 @@ void drv_unassign_vif_chanctx(struct iee
 	might_sleep();
 	lockdep_assert_wiphy(local->hw.wiphy);
 
+	if (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
+	    local->emulate_chanctx &&
+	    !ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF))
+		return;
+
 	if (!check_sdata_in_driver(sdata))
 		return;
 
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1122,9 +1122,6 @@ int ieee80211_add_virtual_monitor(struct
 	struct ieee80211_sub_if_data *sdata;
 	int ret;
 
-	if (!ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF))
-		return 0;
-
 	ASSERT_RTNL();
 	lockdep_assert_wiphy(local->hw.wiphy);
 
@@ -1146,11 +1143,13 @@ int ieee80211_add_virtual_monitor(struct
 
 	ieee80211_set_default_queues(sdata);
 
-	ret = drv_add_interface(local, sdata);
-	if (WARN_ON(ret)) {
-		/* ok .. stupid driver, it asked for this! */
-		kfree(sdata);
-		return ret;
+	if (ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF)) {
+		ret = drv_add_interface(local, sdata);
+		if (WARN_ON(ret)) {
+			/* ok .. stupid driver, it asked for this! */
+			kfree(sdata);
+			return ret;
+		}
 	}
 
 	set_bit(SDATA_STATE_RUNNING, &sdata->state);
@@ -1188,9 +1187,6 @@ void ieee80211_del_virtual_monitor(struc
 {
 	struct ieee80211_sub_if_data *sdata;
 
-	if (!ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF))
-		return;
-
 	ASSERT_RTNL();
 	lockdep_assert_wiphy(local->hw.wiphy);
 
@@ -1210,7 +1206,8 @@ void ieee80211_del_virtual_monitor(struc
 
 	ieee80211_link_release_channel(&sdata->deflink);
 
-	drv_remove_interface(local, sdata);
+	if (ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF))
+		drv_remove_interface(local, sdata);
 
 	kfree(sdata);
 }
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1841,7 +1841,7 @@ int ieee80211_reconfig(struct ieee80211_
 
 	/* add interfaces */
 	sdata = wiphy_dereference(local->hw.wiphy, local->monitor_sdata);
-	if (sdata) {
+	if (sdata && ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF)) {
 		/* in HW restart it exists already */
 		WARN_ON(local->resuming);
 		res = drv_add_interface(local, sdata);


