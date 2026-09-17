Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7972949D5AF;
	Thu, 17 Sep 2026 17:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667861; cv=none; b=QVaCqblwEvkw2v74Gix9kv7pp16YdAf/HVKaqfioS8GwusetV8WABqzaD2xJt5DWlEX5P3kuajHNsG5qwMJvlae0zXkEFtV2j0IRgz5FNJzSAftKtbA4CA3ecv2WCuHblOKxa3C29fI8ubiGUyNNpLgOMG+JAStQXEUyG9yrPec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667861; c=relaxed/simple;
	bh=+58Wx1DjfTU6rqV6pI0914GlR5Ivl96Tb9sRt7+g8hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4jMKAh5LJhyHml7O9qL372YKb2JeKQdKT5Kxic3UpNgoReNkz2xoB+AaN+a9fjyYiOJT6TPHlQpkNxMWcWynvxwMf77eUrUeUdJYiApQKA3eZ6sQ6et4bAwBLl0Vvm5CRqTWXgsRUKSAe52CXr6DAlxiYa3KzM/sgSVrf8ueG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eo96QLVG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eo96QLVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E271F000FF;
	Thu, 17 Sep 2026 17:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667860;
	bh=dhtcyBBT/EiRNdwhIubuD/p2gY/1SHFZ2Jm0wxadqXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eo96QLVGBMDGFIXpB88+KhQjI1XAVkyXtJPmLuc5w41K5Z00j4i4dDBl0o5WLgrwp
	 4jvSxP7YkD/noi0JJ8yo5ovEBK5pVFlUSaeQGjffkBPOyVMOEixKjqWvcrTfj5m/Yq
	 PcnYCl0ni5cgpiZyAvaUybQoK+a4hSR6UBmAcFDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thiyagarajan Pandiyan <thiyagarajan@aerlync.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0233/1102] wifi: nl80211: Increase ie_len size to prevent truncated IEs in new peer notifications
Date: Thu, 17 Sep 2026 16:02:56 +0100
Message-ID: <20260917151545.436344496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 8dcb218e08047..fcc5934a20c0f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -7810,7 +7810,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
  * cfg80211 then sends a notification to userspace.
  */
 void cfg80211_notify_new_peer_candidate(struct net_device *dev,
-		const u8 *macaddr, const u8 *ie, u8 ie_len,
+		const u8 *macaddr, const u8 *ie, size_t ie_len,
 		int sig_dbm, gfp_t gfp);
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d9fa7e8447877..b302caafd4d31 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18581,7 +18581,7 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 }
 
 void cfg80211_notify_new_peer_candidate(struct net_device *dev, const u8 *addr,
-					const u8 *ie, u8 ie_len,
+					const u8 *ie, size_t ie_len,
 					int sig_dbm, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-- 
2.53.0



