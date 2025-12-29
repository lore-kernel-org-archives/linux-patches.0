Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FB5272801;
	Mon, 29 Dec 2025 16:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024931; cv=none; b=PoOFgnJ0ChgHc4oViJ3wsy9W0OAmm+vOZ5w/ij9PZniu6ZHg2ARu3VmvLlwp//81Ef8+bz659Pwpwas1N4YNqsjqcZBg1ZzZ+mhHWAQ7Zn2BoGcWRYC4vvlWVh/PYQhIFpvo0Xr7nSnGqZOQPPRRjtydd9iEAD4xc9/Zas/sgCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024931; c=relaxed/simple;
	bh=0szN5ZZAHUMF353l/B7UZpEoVPcskYz1SVh/07Fp1AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLP3HNkxCGuJBAmpBBHGB6VzFrwo6WX62GsHwoi2OnrsdSct/FPSnt3zZ7VLmaRI8Dvhxol0REnjFc84gdhoixNIh3W2QrsAfWR/Z92mQWBEVivV+YFASK8VMjUI8I+yyM7Qlk2ic2NYESborCJa/qtq4jgz9dNGW3+IjDTBVGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFKNlnw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFKNlnw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DEDC4CEF7;
	Mon, 29 Dec 2025 16:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024931;
	bh=0szN5ZZAHUMF353l/B7UZpEoVPcskYz1SVh/07Fp1AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFKNlnw3BW3VuqbK8yUlr5RwpkyCw4loxgJa9cWr+mH3tijqrZ2ohrat18KuKt6OV
	 5CxC1uYGrFhxq1e4feYsnwCP203n0IZyZVBD8I7xjbt5/w43HT53TrWmDCiFXWt/8a
	 314zIcDmubtT/n6DDmyUq2XMQpmqfXbWluwsADLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/430] wifi: cfg80211: stop radar detection in cfg80211_leave()
Date: Mon, 29 Dec 2025 17:07:17 +0100
Message-ID: <20251229160725.658347538@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 54a34d8d356e0..5e5c1bc380a89 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1365,6 +1365,7 @@ void cfg80211_leave(struct cfg80211_registered_device *rdev,
 
 	cfg80211_pmsr_wdev_down(wdev);
 
+	cfg80211_stop_radar_detection(wdev);
 	cfg80211_stop_background_radar_detection(wdev);
 
 	switch (wdev->iftype) {
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b6bd7f4d6385a..d5d78752227af 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -489,6 +489,7 @@ cfg80211_start_background_radar_detection(struct cfg80211_registered_device *rde
 					  struct wireless_dev *wdev,
 					  struct cfg80211_chan_def *chandef);
 
+void cfg80211_stop_radar_detection(struct wireless_dev *wdev);
 void cfg80211_stop_background_radar_detection(struct wireless_dev *wdev);
 
 void cfg80211_background_cac_done_wk(struct work_struct *work);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 46394eb2086f6..3fc175f9f8686 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1295,6 +1295,25 @@ cfg80211_start_background_radar_detection(struct cfg80211_registered_device *rde
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



