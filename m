Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BA530BF6F;
	Mon, 13 Oct 2025 15:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369628; cv=none; b=SAfQg6XJVoQ6+agQvWWDMV/eOHXvQjvM+E/cQfip9vXc+HhXnIwnB+5carsu6qh8pbSR51xPw3dgMq5JmRqV8Vg2rkLaQEHtDUEUcKGXlUc3IG76U2pEr4S7yiDEIiDv/ozVoXEb6LCNcaxtLHfKop3KvoHDtntB9NEdYETd8Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369628; c=relaxed/simple;
	bh=8LdaCAGOiXqwGTqtERMZJS9c4uSmyux1D3RnmuvoID0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9O8jHdiF5hs2Rr8ysrktD2lpbZzm1Fm3GfLx71RXuM4/I1jqEKzckQWf2wXm4q7YYRNd4GKx40W1s6rGqdw/qn68ykCdud7Ls+UQJSx5ekXrKyjYkJbBpMl4WbHs2a4DMQip3X90ZNIVE4AY9GMJJQCjDHqeqzQht6inOKYoJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAgh8U4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAgh8U4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AF6C116B1;
	Mon, 13 Oct 2025 15:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369628;
	bh=8LdaCAGOiXqwGTqtERMZJS9c4uSmyux1D3RnmuvoID0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAgh8U4iJBLvJDCFu9VgEQLArPxQVcUpN/Zpe2DQxZRza+mu8yDfnEAUITO7/NAjd
	 MaAYh2GgAZHLBf/nT0YrjNZG3Ws4W/NYxIPnfCGgPN7xEeS82Epdz7Si6CiDEej2wN
	 E3CWdYDU9GMZSGcmQNtwRt42mrfokPhUw/ztBKAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 314/563] wifi: mac80211: consider links for validating SCAN_FLAG_AP in scan request during MLO
Date: Mon, 13 Oct 2025 16:42:55 +0200
Message-ID: <20251013144422.640283739@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>

[ Upstream commit 36b75dcb1e25739a3a0975699208c98f4b55d012 ]

Commit 78a7a126dc5b ("wifi: mac80211: validate SCAN_FLAG_AP in scan request
during MLO") introduced a check that rejects scan requests if any link is
already beaconing. This works fine when all links share the same radio, but
breaks down in multi-radio setups.

Consider a scenario where a 2.4 GHz link is beaconing and a scan is
requested on a 5 GHz link, each backed by a different physical radio. The
current logic still blocks the scan, even though it should be allowed. As a
result, interface bring-up fails unnecessarily in valid configurations.

Fix this by checking whether the scan is being requested on the same
underlying radio as the beaconing link. Only reject the scan if it targets
a link that is already beaconing and the NL80211_FEATURE_AP_SCAN is not
set. This ensures correct behavior in multi-radio environments and avoids
false rejections.

Fixes: 78a7a126dc5b ("wifi: mac80211: validate SCAN_FLAG_AP in scan request during MLO")
Signed-off-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Link: https://patch.msgid.link/20250812-fix_scan_ap_flag_requirement_during_mlo-v4-3-383ffb6da213@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2ed07fa121ab7..7609c7c31df74 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3001,6 +3001,9 @@ static int ieee80211_scan(struct wiphy *wiphy,
 			  struct cfg80211_scan_request *req)
 {
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_link_data *link;
+	struct ieee80211_channel *chan;
+	int radio_idx;
 
 	sdata = IEEE80211_WDEV_TO_SUB_IF(req->wdev);
 
@@ -3028,10 +3031,20 @@ static int ieee80211_scan(struct wiphy *wiphy,
 		 * the frames sent while scanning on other channel will be
 		 * lost)
 		 */
-		if (ieee80211_num_beaconing_links(sdata) &&
-		    (!(wiphy->features & NL80211_FEATURE_AP_SCAN) ||
-		     !(req->flags & NL80211_SCAN_FLAG_AP)))
-			return -EOPNOTSUPP;
+		for_each_link_data(sdata, link) {
+			/* if the link is not beaconing, ignore it */
+			if (!sdata_dereference(link->u.ap.beacon, sdata))
+				continue;
+
+			chan = link->conf->chanreq.oper.chan;
+			radio_idx = cfg80211_get_radio_idx_by_chan(wiphy, chan);
+
+			if (ieee80211_is_radio_idx_in_scan_req(wiphy, req,
+							       radio_idx) &&
+			    (!(wiphy->features & NL80211_FEATURE_AP_SCAN) ||
+			     !(req->flags & NL80211_SCAN_FLAG_AP)))
+				return -EOPNOTSUPP;
+		}
 		break;
 	case NL80211_IFTYPE_NAN:
 	default:
-- 
2.51.0



