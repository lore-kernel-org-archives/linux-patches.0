Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809001CB310;
	Wed,  6 Nov 2024 13:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899108; cv=none; b=tscJfgsbJsJnNWIiXuWcTj4NvaniFQ+FmE4EwbLvVDHGTzRjAavXhKmVCPvP4w3ap5oh62TV+wKi9HSJK8OsDW0GLtH61PZ5jXdxyhWoSxLHuh1/AB1DA80+AJ2L9UJHxhLuGofdEVlgmIefD20D6GEIK81wpWRRocKe/3bVMV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899108; c=relaxed/simple;
	bh=GQjpg4vXp+G/pdPuKYA/x9uNF8G3pBSGw9aKOW8+ovY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUJ08g+jp2LA0Dv/WxPc9GR2WvwAnAgwxjdNgQoZMvllmo8kbsjr3O5arfVLyGz6akwM8IEWs0OGu+hUvwzTAMMXHHjh1YnL4m0k1Wp4uApnNm1kCnJ59GxeSEj8EvSGtP4vSfWHcWqOaInw8WgzcxOMuul0F4SwlmFDwLQmZhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QSnDe+hZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSnDe+hZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B7BC4CECD;
	Wed,  6 Nov 2024 13:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899108;
	bh=GQjpg4vXp+G/pdPuKYA/x9uNF8G3pBSGw9aKOW8+ovY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSnDe+hZS4kCIkuF2X8nE/nGL+0cjrFb1U15UZwb+Y8+oNgfFaUqllyfKdOyo9aSz
	 PlxGT1rFQ3C9MMBOJUCJigOdfLRsC0Wtfig5NvTSW79hJ3OqxmS+TzXJM0DXwBatOs
	 GOddR3Rk2SQFJWj/x4jMyU0kcVD0aFpCv3cSvyoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 428/462] mac80211: do drv_reconfig_complete() before restarting all
Date: Wed,  6 Nov 2024 13:05:21 +0100
Message-ID: <20241106120342.083716692@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 13dee10b30c058ee2c58c5da00339cc0d4201aa6 ]

When we reconfigure, the driver might do some things to complete
the reconfiguration. It's strange and could be broken in some
cases because we restart other works (e.g. remain-on-channel and
TX) before this happens, yet only start queues later.

Change this to do the reconfig complete when reconfiguration is
actually complete, not when we've already started doing other
things again.

For iwlwifi, this should fix a race where the reconfig can race
with TX, for ath10k and ath11k that also use this it won't make
a difference because they just start queues there, and mac80211
also stopped the queues and will restart them later as before.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211129152938.cab99f22fe19.Iefe494687f15fd85f77c1b989d1149c8efdfdc36@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 07a6e3b78a65 ("wifi: iwlwifi: mvm: Fix response handling in iwl_mvm_send_recovery_cmd()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 6223af1c3457a..8d3069c93a60a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2491,6 +2491,13 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		mutex_unlock(&local->sta_mtx);
 	}
 
+	/*
+	 * If this is for hw restart things are still running.
+	 * We may want to change that later, however.
+	 */
+	if (local->open_count && (!suspended || reconfig_due_to_wowlan))
+		drv_reconfig_complete(local, IEEE80211_RECONFIG_TYPE_RESTART);
+
 	if (local->in_reconfig) {
 		local->in_reconfig = false;
 		barrier();
@@ -2509,13 +2516,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 					IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 					false);
 
-	/*
-	 * If this is for hw restart things are still running.
-	 * We may want to change that later, however.
-	 */
-	if (local->open_count && (!suspended || reconfig_due_to_wowlan))
-		drv_reconfig_complete(local, IEEE80211_RECONFIG_TYPE_RESTART);
-
 	if (!suspended)
 		return 0;
 
-- 
2.43.0



