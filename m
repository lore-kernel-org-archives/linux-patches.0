Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049D22DB785;
	Wed, 30 Sep 2026 18:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794346; cv=none; b=r1Y+NJ2YP3hc7Eh+3IRMRy26NbjVoMnzDhkcEy8rTfFiZUR1KPdFFl7ue8vxOND0TtCeBUG3lJaeYPYHKM3neihKHWqzS/+/WeCoGME6xjx4Cq81ALhq8JZnkf+taXmA6geHPDDG5Ax2IsdilYR0DyKvCsq4aA9Hh76XSFZuJeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794346; c=relaxed/simple;
	bh=k+zOTw0mgiYPbNTt2rlcAYQyR4MJUudyImS4NcsXsA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riHXj5tMeHpdIMAy4BEEpMvacSuR17r405acg7W6JICtwtI9lYyZhBYkw3aBzaCrXqVn0ytLZ1IdOKhI6MKsUFSqDW///gVze2/rUqagolc4t5/o1HM8Ufy2pPXO1WVnHvrA9v/h8iZdew6l/XjhKPoH8AzfIrmZ5KZA1Sy55oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omSAomlK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omSAomlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612371F000FF;
	Wed, 30 Sep 2026 18:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794344;
	bh=+29GRE/DWMQ6ibYJ2vK7Cm/S1zKmW8P1AcdCooGjAzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=omSAomlKB9bNS4VDqXSTY+jxS6ZmObaXVZq1j3JI8Ide5+Atc5ybK5Scgzxo4C7vH
	 k3ihhGU1xwjLBSrFqPF+Zuuz6htCD14kRDmnUt2tG20o9gLAOaMoO4wGqZBuUw60Az
	 KihojYUbu0iLR4PDPDrJMy20FGF314o7aruCEQZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thiyagarajan Pandiyan <thiyagarajan@aerlync.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0178/1193] wifi: nl80211: Increase ie_len size to prevent truncated IEs in new peer notifications
Date: Wed, 30 Sep 2026 17:14:22 +0200
Message-ID: <20260930152438.151485219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thiyagarajan Pandiyan <thiyagarajan@aerlync.com>

[ Upstream commit dfb67ae569bf0726187725b1ef8d89377778861e ]

Currently, ie_len in cfg80211_notify_new_peer_candidate is defined as
1-byte field, capping the maximum IE list size at 255 bytes. When a
large beacon is received, the IE list is truncated, passing incomplete
data to wpa_supplicant. This causes supplicant to fail parsing the IEs.

Increasing the size of ie_len to allow the full length of the IE list to
be forwarded properly.

Signed-off-by: Thiyagarajan Pandiyan <thiyagarajan@aerlync.com>
Link: https://patch.msgid.link/20260605054307.427874-1-thiyagarajan@aerlync.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 2 +-
 net/wireless/nl80211.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5b3a63c377d60..cda0b2907f329 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -7383,7 +7383,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
  * cfg80211 then sends a notification to userspace.
  */
 void cfg80211_notify_new_peer_candidate(struct net_device *dev,
-		const u8 *macaddr, const u8 *ie, u8 ie_len,
+		const u8 *macaddr, const u8 *ie, size_t ie_len,
 		int sig_dbm, gfp_t gfp);
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 79c3c065ab0c2..e4cd5503ae119 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18502,7 +18502,7 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 }
 
 void cfg80211_notify_new_peer_candidate(struct net_device *dev, const u8 *addr,
-					const u8 *ie, u8 ie_len,
+					const u8 *ie, size_t ie_len,
 					int sig_dbm, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-- 
2.53.0



