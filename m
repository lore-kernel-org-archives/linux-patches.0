Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9634C15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F5DC433D6;
	Mon,  5 Dec 2022 19:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268957;
	bh=7cLohowrTqi+J5FHoSAZS3Yt0yXI6XzmQk6RCw0bKCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBRn2Z5LZazx9KkOPt/nmOS4NoGmuEWxOdOv3NvOG8Fs/DXdGAWgxs+F/SAiP7vZ4
	 NCccR0sSpBwQpfSVOWu9xUib9us7yCb5DGEWukT8xuam7cYM9FaW0rl5lPhg0DP1is
	 zUqjJkPQvBXvA6pMS00EQBjk9Orz8kqR/VreBCZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?S=C3=B6nke=20Huster?= <shuster@seemoo.tu-darmstadt.de>
Subject: [PATCH 5.15 046/120] wifi: cfg80211: dont allow multi-BSSID in S1G
Date: Mon,  5 Dec 2022 20:09:46 +0100
Message-Id: <20221205190807.945882699@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit acd3c92acc7aaec50a94d0a7faf7ccd74e952493 ]

In S1G beacon frames there shouldn't be multi-BSSID elements
since that's not supported, remove that to avoid a potential
integer underflow and/or misparsing the frames due to the
different length of the fixed part of the frame.

While at it, initialize non_tx_data so we don't send garbage
values to the user (even if it doesn't seem to matter now.)

Reported-and-tested-by: Sönke Huster <shuster@seemoo.tu-darmstadt.de>
Fixes: 9eaffe5078ca ("cfg80211: convert S1G beacon to scan results")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 937ec4c2a3bf..ef31e401d791 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2477,10 +2477,15 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	const struct cfg80211_bss_ies *ies1, *ies2;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
-	struct cfg80211_non_tx_bss non_tx_data;
+	struct cfg80211_non_tx_bss non_tx_data = {};
 
 	res = cfg80211_inform_single_bss_frame_data(wiphy, data, mgmt,
 						    len, gfp);
+
+	/* don't do any further MBSSID handling for S1G */
+	if (ieee80211_is_s1g_beacon(mgmt->frame_control))
+		return res;
+
 	if (!res || !wiphy->support_mbssid ||
 	    !cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
 		return res;
-- 
2.35.1



