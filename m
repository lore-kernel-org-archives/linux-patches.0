Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5A94F93BA;
	Wed, 30 Sep 2026 15:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782604; cv=none; b=temAZFkK/LwDSWpdayRdCruovxfwyarinLEBN7qQngGkIIzlbwhwWqbIYbzWOSwnnj6+oqbTwiCGRmWcH/u751y7EN3xoSI7kNkOqnkHMO/wIiOoWRYUyc4DiYz0rQtQ3oKPWYY4RwgSkTNOz95eQlrSz+klM3px3NsYCq+vWWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782604; c=relaxed/simple;
	bh=FfrERFp66rSLVyfKxxzcDLLDDxSSYmhtCKgpUke7RGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDz8soy+aBgh1BbuEgG5hLKrCG1IJZQNbe1b8eLaoVItmpWvEUbj3T+4fq3GcnPQofCEGobuA9AMbWpNAVcaOfH4cBdRz7u8g2MFdTJBCo3zIVQMxm0T515apacqu9+WCRALaxTtcGh64AJCxOqatdcuKJw0UQvpnysKsushCYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0PmJ1/c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0PmJ1/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B1E1F00898;
	Wed, 30 Sep 2026 15:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782595;
	bh=Y9tjLEPfy/Xy0wahCw7JkRzW0Mh7I/E8mNS5k2Xm40U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0PmJ1/c0/6B6j06Gbbyu2ME4g0qUKwAR0zCiwSswhIV3QvQJQcOV4OGs0oP/R/om
	 ZOynRdNk2Sr1zSxB4jn09hyRvF8+TU0agUnDdR50M1XZAP9HFAvNwq0J3eU/fXmTp2
	 O8R/anlIEl5SJD5AKNqstHPsfKtlLMCm+cyWdO94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thiyagarajan Pandiyan <thiyagarajan@aerlync.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/595] wifi: nl80211: Increase ie_len size to prevent truncated IEs in new peer notifications
Date: Wed, 30 Sep 2026 17:19:54 +0200
Message-ID: <20260930152349.910689365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5595c2a949397..a2758f9ce340c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6482,7 +6482,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
  * cfg80211 then sends a notification to userspace.
  */
 void cfg80211_notify_new_peer_candidate(struct net_device *dev,
-		const u8 *macaddr, const u8 *ie, u8 ie_len,
+		const u8 *macaddr, const u8 *ie, size_t ie_len,
 		int sig_dbm, gfp_t gfp);
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3b2a70b467de9..506d621212e44 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16259,7 +16259,7 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 }
 
 void cfg80211_notify_new_peer_candidate(struct net_device *dev, const u8 *addr,
-					const u8 *ie, u8 ie_len,
+					const u8 *ie, size_t ie_len,
 					int sig_dbm, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-- 
2.53.0



