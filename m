Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335391E00AB;
	Wed,  6 Nov 2024 13:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899141; cv=none; b=pXbHKcFKc73cvoT4tdc217VlQIE1c4H3dHotpkLUwYUD6ZTXZKLKIjajLfhLyuJOy8L1YAuT1WyxDicvYPn8lyHPyXVcgY3tIfS2tTa6HP6/a9QDtjr0x/4yaHy/JhmWiPU577/ZlGIHNc392zAAIIhkQ5tGOmFajpbFTB2Cb9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899141; c=relaxed/simple;
	bh=eFeWUI0mYH/y6bt/QBCUao+dZDH7J4fRVGV+VKs8DNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5l9pwjbwCpP14rdJdNr0ZDc8wUdgkXis4cGJZI1MzEZ+pCPNSIQvsV+UQmHvOgGut5W3GAGpHl+N49yPZsBgq6WpRKazs1AubxL02Le13RZRTQlIf5LVlKDzOaYFqd1u8ObbYOx858JZBDGgTuXwjxakFmf9a3KZkEC1CWWk1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bb/8huDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bb/8huDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD20EC4CED3;
	Wed,  6 Nov 2024 13:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899141;
	bh=eFeWUI0mYH/y6bt/QBCUao+dZDH7J4fRVGV+VKs8DNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bb/8huDCCOBgLkGKvpk7sB8HzRz1i927PvUsp6Al08LtWgghP7fwQjlPP6Eg0T4Ee
	 +mTHN4ySscD6EfRonq5xxOYBP2GzLe9XwbgYe/Br5L4MJfLRL7h+ZR+0nfqsCAWUyb
	 bx8DSlu4s6B+iFPkh+skkNBz94o4ggXyVToyFPFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/73] mac80211: do drv_reconfig_complete() before restarting all
Date: Wed,  6 Nov 2024 13:05:17 +0100
Message-ID: <20241106120300.356440553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ef7b6d88ee00c..28676a305916c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2656,6 +2656,13 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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
@@ -2674,13 +2681,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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



