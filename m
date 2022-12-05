Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B698415C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9D1C433D6;
	Mon,  5 Dec 2022 19:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268289;
	bh=vyB7Dr5dTwIjfelJfSs8bEcds1DIZm/W1E+vdpUOGpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvxP4f14Pa0hFsYKMrLb/n9jgiFdXE+X6VXQa6eVAYJSFt81IyLszEI8XOzOIPNkO
	 SkJm8oxbj0pKBqDfXS2IbLqGogM/af4P9htQojpQ6i+sVNFhTu6IGgVgKU5CqRDHTe
	 DbZu7+xaObzgWV/3E/3BL/7ZIt1ikGQTtjhf4zII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?S=C3=B6nke=20Huster?= <shuster@seemoo.tu-darmstadt.de>
Subject: [PATCH 6.0 048/124] wifi: cfg80211: dont allow multi-BSSID in S1G
Date: Mon,  5 Dec 2022 20:09:14 +0100
Message-Id: <20221205190809.802211838@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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
index 56db0f12ca7c..b4d788572992 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2527,10 +2527,15 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
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
 	    !cfg80211_find_elem(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
 		return res;
-- 
2.35.1



