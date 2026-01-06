Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38AF284694;
	Tue,  6 Jan 2026 17:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719754; cv=none; b=U4RFPo7KsA2x6FcYK5u3KFD3i2qdtuDHEJhke6N/08BX2ImPUALLWuaehx8ZStyJxXQfbTQYbhEGmHf5v61JNnxgasKxM8ox7OItdGgrucxhyivpE4Y9DCpKZXC46MMEOQxNgvd6mFDG7GiY3vHt3JzNiI+CXYpKaAl7xuUD3jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719754; c=relaxed/simple;
	bh=AqSsDoIabaK4a30pDEwE+dgf/Ksolsb5Hxy2uDtzSo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIbQeKOkAm8rDMRDJGUqs3Quse/0h5HIWBVqGcggDn7L01njbmi324vTQFbIJN5bC7AMKMhPagqoKnTlTQRkYyR3p6ptdctUKLyaDGfNvpjgtazB9oZS5msi3A1qEJk6qJcDujKy1mf3ZZpqh0xZW1hD7wRtUCPaPbOwL/0Xy2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPuyAZ6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPuyAZ6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2700C116C6;
	Tue,  6 Jan 2026 17:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719753;
	bh=AqSsDoIabaK4a30pDEwE+dgf/Ksolsb5Hxy2uDtzSo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPuyAZ6BRHyCHmUcM/tgdtLzwQnaN/nUJ/du3JbrtN7Kwx+Ezx4bKTe33rOMNkiTi
	 FSV0eQI5ykAHE5jHulz9DtLtEXC1oxCQCfXtyUCSTT96XEBxZ5TeiY1XZeCfxD0207
	 9Zwf4VuFIOM7OyDeTCJkCIAsJ6fa/BB5D2mX77XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/567] wifi: cfg80211: stop radar detection in cfg80211_leave()
Date: Tue,  6 Jan 2026 17:56:51 +0100
Message-ID: <20260106170452.421267384@linuxfoundation.org>
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

[ Upstream commit 9f33477b9a31a1edfe2df9f1a0359cccb0e16b4c ]

If an interface is set down or, per the previous patch, changes
type, radar detection for it should be cancelled. This is done
for AP mode in mac80211 (somewhat needlessly, since cfg80211 can
do it, but didn't until now), but wasn't handled for mesh, so if
radar detection was started and then the interface set down or
its type switched (the latter sometimes happning in the hwsim
test 'mesh_peer_connected_dfs'), radar detection would be around
with the interface unknown to the driver, later leading to some
warnings around chanctx usage.

Link: https://patch.msgid.link/20251121174021.290120e419e3.I2a5650c9062e29c988992dd8ce0d8eb570d23267@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c |  1 +
 net/wireless/core.h |  1 +
 net/wireless/mlme.c | 19 +++++++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index dc207a8986c7f..6bb8a7037d24d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1343,6 +1343,7 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 
 	cfg80211_pmsr_wdev_down(wdev);
 
+	cfg80211_stop_radar_detection(wdev);
 	cfg80211_stop_background_radar_detection(wdev);
 
 	switch (wdev->iftype) {
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3b3e3cd7027ac..d4b26cbe3342d 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -483,6 +483,7 @@ cfg80211_start_background_radar_detection(struct cfg80211_registered_device *rde
 					  struct wireless_dev *wdev,
 					  struct cfg80211_chan_def *chandef);
 
+void cfg80211_stop_radar_detection(struct wireless_dev *wdev);
 void cfg80211_stop_background_radar_detection(struct wireless_dev *wdev);
 
 void cfg80211_background_cac_done_wk(struct work_struct *work);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index d1a66410b9c55..26319522c7abc 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1271,6 +1271,25 @@ cfg80211_start_background_radar_detection(struct cfg80211_registered_device *rde
 	return 0;
 }
 
+void cfg80211_stop_radar_detection(struct wireless_dev *wdev)
+{
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	int link_id;
+
+	for_each_valid_link(wdev, link_id) {
+		struct cfg80211_chan_def chandef;
+
+		if (!wdev->links[link_id].cac_started)
+			continue;
+
+		chandef = *wdev_chandef(wdev, link_id);
+		rdev_end_cac(rdev, wdev->netdev, link_id);
+		nl80211_radar_notify(rdev, &chandef, NL80211_RADAR_CAC_ABORTED,
+				     wdev->netdev, GFP_KERNEL);
+	}
+}
+
 void cfg80211_stop_background_radar_detection(struct wireless_dev *wdev)
 {
 	struct wiphy *wiphy = wdev->wiphy;
-- 
2.51.0



