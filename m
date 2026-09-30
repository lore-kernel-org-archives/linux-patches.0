Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091A35208B3;
	Wed, 30 Sep 2026 17:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790922; cv=none; b=FdmMxdPvntqRvtk9Zk5ZWfeB/eiTrh29m0NAmT6x2Y8rQ/GYpR7Advr6KkoLDC1kri/PO45YGb5uTTVcWJFW3cI/IyRlfnMl7UmkTNpyR25h256lzjP6V4kD+8cv+R83O+Pw8POcLGdB6q4eM6BVmPPPcP4BDvOVlSbUkhLFUiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790922; c=relaxed/simple;
	bh=ZXoQcGEC3VAWW6sP/WI5y2pHmMwGXn7B3efxoZHHCT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFJuZJNHbQnueWnIV5u/zM4vxSunaMviNj9auqXtPoAWFwQoX5NUcYexkvLdgPBFDmIQ1kDS4KAuCzd4xn0hVuSllYCZqFn3U0SzCndEZ/MnykH2nH7HEvzG3Bc7p0yAPBDtwG2RWJGCwfYJpZsEs305AYrgtrv4t8pkpMxHoVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXaa+CRe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXaa+CRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382671F000FF;
	Wed, 30 Sep 2026 17:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790920;
	bh=JB+OzIMJ4HCVxyFb4PxeVwFJ8cLDy/iOoocRC7DnLj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kXaa+CReLdIhDxlq4XiLJCQZGDQocKpMz31zs3jTo53lYzlRn6NwQO0An0iTFKdAa
	 3xHnc92JsMKKeeH9wDp7i1Nx9ptUGwRAoUHMjIve4SKG/xGumfLm+73nb1wa7/ducR
	 HNFd0bIsKmCVIs4XUIuNh8buKslZDyQT5AeeBcHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thiyagarajan Pandiyan <thiyagarajan@aerlync.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/752] wifi: nl80211: Increase ie_len size to prevent truncated IEs in new peer notifications
Date: Wed, 30 Sep 2026 17:19:49 +0200
Message-ID: <20260930152400.753971007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3925763426618..96614abbe6600 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6745,7 +6745,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
  * cfg80211 then sends a notification to userspace.
  */
 void cfg80211_notify_new_peer_candidate(struct net_device *dev,
-		const u8 *macaddr, const u8 *ie, u8 ie_len,
+		const u8 *macaddr, const u8 *ie, size_t ie_len,
 		int sig_dbm, gfp_t gfp);
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2c74da398cf4e..312163181d6b6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16659,7 +16659,7 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 }
 
 void cfg80211_notify_new_peer_candidate(struct net_device *dev, const u8 *addr,
-					const u8 *ie, u8 ie_len,
+					const u8 *ie, size_t ie_len,
 					int sig_dbm, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-- 
2.53.0



