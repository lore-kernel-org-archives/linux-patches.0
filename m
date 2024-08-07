Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AF923CE;
	Wed,  7 Aug 2024 15:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042940; cv=none; b=KZ8Uw6LJy2smSc9ikJJYFl2LQ4tANOYrocWekNeC2WRzpckPXMkmV4GF2/8hb8fQ+FI8c+8nIiYCH3JQa0ooky1qwKJcEHA+5w5lVy5XimTgkxW+UyZ3wJyIPIpct3lS+lfwJuXCFU7zIU2qSR3uH4HFDV78MmXk0ceqB1Cv1pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042940; c=relaxed/simple;
	bh=BsT6tZrpOoe3NWmQl77IM5RmbbUriB6/dbQ2Nhjp1S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCwlKtU6WcDSQdtYR+g0sS4pkUzuTy5vMSMyDwjQAy4EAqag1iVR+Vgrqn3hYltQRILZgCwefmwwuud9qY4gdTg4UUOTgJ41Ep9JONuU6xonmbIFgOXKPDqVxqRpp7+FJzoJzBdhN2eQ6IiaZdk6+jUY1LaoZDeRxE4mTJza310=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g09UbO9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g09UbO9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82AEC32781;
	Wed,  7 Aug 2024 15:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042940;
	bh=BsT6tZrpOoe3NWmQl77IM5RmbbUriB6/dbQ2Nhjp1S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g09UbO9xXlJIam6noCx+DPEZtM5HabYRm2qVA9UJF4kXg+bJiBTTagqtzU2sZMARV
	 xqExnz+E9piy8ZhMl+T0LiIn9voDyyshkDhNQ0+DJeqL4VJGE+driTO+W3vgWh2o0T
	 jIXqlFtmLNCZXO1Zuc8CFGKNWOUVoislM9Tt5WuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0f3afa93b91202f21939@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 030/123] wifi: cfg80211: correct S1G beacon length calculation
Date: Wed,  7 Aug 2024 16:59:09 +0200
Message-ID: <20240807150021.800786430@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6873cc4416078202882691b424fcca5b5fb1a94d ]

The minimum header length calculation (equivalent to the start
of the elements) for the S1G long beacon erroneously required
only up to the start of u.s1g_beacon rather than the start of
u.s1g_beacon.variable. Fix that, and also shuffle the branches
around a bit to not assign useless values that are overwritten
later.

Reported-by: syzbot+0f3afa93b91202f21939@syzkaller.appspotmail.com
Fixes: 9eaffe5078ca ("cfg80211: convert S1G beacon to scan results")
Link: https://patch.msgid.link/20240724132912.9662972db7c1.I8779675b5bbda4994cc66f876b6b87a2361c3c0b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 0222ede0feb60..292b530a6dd31 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3136,8 +3136,7 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 			       struct ieee80211_mgmt *mgmt, size_t len,
 			       gfp_t gfp)
 {
-	size_t min_hdr_len = offsetof(struct ieee80211_mgmt,
-				      u.probe_resp.variable);
+	size_t min_hdr_len;
 	struct ieee80211_ext *ext = NULL;
 	enum cfg80211_bss_frame_type ftype;
 	u16 beacon_interval;
@@ -3160,10 +3159,16 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 
 	if (ieee80211_is_s1g_beacon(mgmt->frame_control)) {
 		ext = (void *) mgmt;
-		min_hdr_len = offsetof(struct ieee80211_ext, u.s1g_beacon);
 		if (ieee80211_is_s1g_short_beacon(mgmt->frame_control))
 			min_hdr_len = offsetof(struct ieee80211_ext,
 					       u.s1g_short_beacon.variable);
+		else
+			min_hdr_len = offsetof(struct ieee80211_ext,
+					       u.s1g_beacon.variable);
+	} else {
+		/* same for beacons */
+		min_hdr_len = offsetof(struct ieee80211_mgmt,
+				       u.probe_resp.variable);
 	}
 
 	if (WARN_ON(len < min_hdr_len))
-- 
2.43.0



