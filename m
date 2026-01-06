Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF7D346E5F;
	Tue,  6 Jan 2026 17:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719760; cv=none; b=CpStuCV+lDh7hYwMAbF6PAQB7XoOFK06H39sk2kEODMmB0vyGeItbrJEuzieOXyb7VtSE7o7BdxlO/77lnfsAxFPVq6IO/cSeGLqqoafHH/Wiiy3hj+FGOcGER8MbYYi5AxMWaaJF3erv23hqs3me8d6VL27G1ZE9duvFyZrD0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719760; c=relaxed/simple;
	bh=DQZYEr1PMUQXhmo6kHnx61Wh3pyT4LFuOOZFrErrGK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKDdkCdvRX8VID0avxnsimls8Ye9xWfSvJFJr7L1jziFcHS0GQqF0zj5z89n7FN3aBRF8XaZwBlj9kfIiC5XTVviveU+U+FKmPXTSdwPJTvTvPMdaZybq44cy/u4FKpxj59w2nxbH6gTCAJ8/HNWBqnDHONZuucRMNdEC1k5FiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzQC48ca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzQC48ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575FFC116C6;
	Tue,  6 Jan 2026 17:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719759;
	bh=DQZYEr1PMUQXhmo6kHnx61Wh3pyT4LFuOOZFrErrGK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzQC48capmcCABgUrprjRHpr2WcbeqojT7/p50v82w6dlHxQ4OBHFEovJpwHbPqd6
	 FwxckeovqMlryZ+X+PBwHpaquL4pMvGlPr/nhjztsMsioDGGAb7Kmf1UHYhiiT7/lT
	 lkQGUagTjouP/sip6ESCQxhrQlo0mh1eWK1AKx1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/567] wifi: cfg80211: use cfg80211_leave() in iftype change
Date: Tue,  6 Jan 2026 17:56:52 +0100
Message-ID: <20260106170452.457159461@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7a27b73943a70ee226fa125327101fb18e94701d ]

When changing the interface type, all activity on the interface has
to be stopped first. This was done independent of existing code in
cfg80211_leave(), so didn't handle e.g. background radar detection.
Use cfg80211_leave() to handle it the same way.

Note that cfg80211_leave() behaves slightly differently for IBSS in
wireless extensions, it won't send an event in that case. We could
handle that, but since nl80211 was used to change the type, IBSS is
rare, and wext is already a corner case, it doesn't seem worth it.

Link: https://patch.msgid.link/20251121174021.922ef48ce007.I970c8514252ef8a864a7fbdab9591b71031dee03@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index b115489a846f8..6aff651a9b68d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1230,28 +1230,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		dev->ieee80211_ptr->use_4addr = false;
 		rdev_set_qos_map(rdev, dev, NULL);
 
-		switch (otype) {
-		case NL80211_IFTYPE_AP:
-		case NL80211_IFTYPE_P2P_GO:
-			cfg80211_stop_ap(rdev, dev, -1, true);
-			break;
-		case NL80211_IFTYPE_ADHOC:
-			cfg80211_leave_ibss(rdev, dev, false);
-			break;
-		case NL80211_IFTYPE_STATION:
-		case NL80211_IFTYPE_P2P_CLIENT:
-			cfg80211_disconnect(rdev, dev,
-					    WLAN_REASON_DEAUTH_LEAVING, true);
-			break;
-		case NL80211_IFTYPE_MESH_POINT:
-			/* mesh should be handled? */
-			break;
-		case NL80211_IFTYPE_OCB:
-			cfg80211_leave_ocb(rdev, dev);
-			break;
-		default:
-			break;
-		}
+		cfg80211_leave(rdev, dev->ieee80211_ptr);
 
 		cfg80211_process_rdev_events(rdev);
 		cfg80211_mlme_purge_registrations(dev->ieee80211_ptr);
-- 
2.51.0



