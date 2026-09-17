Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A364FC332;
	Thu, 17 Sep 2026 16:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664381; cv=none; b=oU8twHuCb/mOCuuqhOVLwOnT4r3mdmbSRuqCduPCjYCOHnOxsjL8v/GIPdmul/PkiZhOeYIINBoccy5FpBnIEm9tdxmpGTJYNUKICNJbJJ34YJCOax1H1a3PMb1M7Pi5y9wOIMJ1lEtAtwjkkB0rcQ5brtSonYiqbwIzYsGVs8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664381; c=relaxed/simple;
	bh=P8ZtOlBmcsf+KjSj2hCQ98JNKYeD1kO3JSBS5m3N4xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlrH/mPpWvtpEmqG5bCvgZX4vFc+9Kv6r1Kp+Z0/LFk0j/43F6Qop/SmKOimoyaPiIE4DhwLixT6+tASYosU/TxATpqpZiqmfC6anv18Jn0jQQ/sy48HQydTV84Cv5S/UNaGb5Cq6ySzPrRDeJ5VOKRrkbQuc+B4m2ewtpqLNkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1bLO0iP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1bLO0iP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B28C1F000FF;
	Thu, 17 Sep 2026 16:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664380;
	bh=RhNwk4RZvAUZHHVhlEHRBvr1eyptgj5ZIUqlZrK9H3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p1bLO0iPjiVhoQxRbv+48IyX856Nb9WKMVifLIRp2J/CJTbvmlNLdDg45zVakJZ3x
	 gQkTZZkhyLlX6q0LThaY4o27h+PGGrTo8CIOc+i/qQFuTVvYfGkUw7UHyCSIdE6i5u
	 fLDYFIDmNPpGLt3vaHOxZgSjYTy+NdqN/IpxX2cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thiyagarajan Pandiyan <thiyagarajan@aerlync.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0337/1250] wifi: nl80211: Increase ie_len size to prevent truncated IEs in new peer notifications
Date: Thu, 17 Sep 2026 16:02:12 +0100
Message-ID: <20260917151601.218707588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 634743ba5fa66..0b9bc2247d323 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -8255,7 +8255,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
  * cfg80211 then sends a notification to userspace.
  */
 void cfg80211_notify_new_peer_candidate(struct net_device *dev,
-		const u8 *macaddr, const u8 *ie, u8 ie_len,
+		const u8 *macaddr, const u8 *ie, size_t ie_len,
 		int sig_dbm, gfp_t gfp);
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 906a974cce5dc..28b9cd017ae38 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -20379,7 +20379,7 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 }
 
 void cfg80211_notify_new_peer_candidate(struct net_device *dev, const u8 *addr,
-					const u8 *ie, u8 ie_len,
+					const u8 *ie, size_t ie_len,
 					int sig_dbm, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-- 
2.53.0



