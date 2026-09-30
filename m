Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722D851118B;
	Wed, 30 Sep 2026 16:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784442; cv=none; b=uy47krRuWWwT4MhOauMSxlrZUSTwDTQuFO571B5rLtXklTI3vnq29sxRjVPawQayQPNW3jYhtSVAQRoWz5dWRsBDoySMB3HSiVGth1t91ny6m6U1nefXkBFRfxsBWSk66Pcy8h7/p3TWZm4gyZDwMEleNGBLeB1GfgdRtMHWSDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784442; c=relaxed/simple;
	bh=EQOfnEy1mYU95O7UnWlfPC0Z7ROEQnpcOaWQZT4QNfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIyr1LlEvysI7l36O68lt5KrzX3SawOAJLbJ3nLDPf/dPM7Ol9DXvwPI13GI2gzFmZDM6iTYoyFmpHqer12uwxM05tFhGxoI9yloe9VOCEgtmxoR7g9vdAehjPd4SxjjCMEitbsbTYO4Du8G5YywXw6jxZ8pFZGnlpgp/UJNs3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8hWCCow; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8hWCCow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867391F00899;
	Wed, 30 Sep 2026 16:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784437;
	bh=bzYkCrFFeRMHwJCMVxEi+84uaIPHs/WO9EuZ2mSV/1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N8hWCCowlqMQEBhusmIuHitb1Mvmiud1rJDTAj9xvuTtIcZru+QxCvzR+x8tJduSn
	 xcgZqIfK9gQJg/t4+nuxFAhvKB+Ph/dri4lrPbyOCvViIr+DmWJ+O+/GrEk+BgunUf
	 vbD62n9/m3tmk1eP0gk2VFX759XQj0dbLlPaUNrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thiyagarajan Pandiyan <thiyagarajan@aerlync.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/982] wifi: nl80211: Increase ie_len size to prevent truncated IEs in new peer notifications
Date: Wed, 30 Sep 2026 17:14:50 +0200
Message-ID: <20260930152420.118957290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f39a60475c24c..90aad35cccc10 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -7273,7 +7273,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
  * cfg80211 then sends a notification to userspace.
  */
 void cfg80211_notify_new_peer_candidate(struct net_device *dev,
-		const u8 *macaddr, const u8 *ie, u8 ie_len,
+		const u8 *macaddr, const u8 *ie, size_t ie_len,
 		int sig_dbm, gfp_t gfp);
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 069b04c29b64e..aa85e2e063bbc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18280,7 +18280,7 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 }
 
 void cfg80211_notify_new_peer_candidate(struct net_device *dev, const u8 *addr,
-					const u8 *ie, u8 ie_len,
+					const u8 *ie, size_t ie_len,
 					int sig_dbm, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-- 
2.53.0



