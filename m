Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C70D18FDAB;
	Mon, 10 Mar 2025 17:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628778; cv=none; b=olta3grikcTB64DUKB4Npw+Kq1Nb/F6wzDctWFmssshyRXFsfwrQc92C4N9QmZeOuNNY8I5y/HOK6X2y6RpPu+mIareZtWtRPjKwR6aCNbE6qaBcNiQ1xbWoIxEjOKaFacISXyPLBII7Y6VIyUOTZgxQjCQKw2Fw8wX9Gpbe2LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628778; c=relaxed/simple;
	bh=iJ2fQXs0p/mQtsM6laLT5pik9nVjkGT2RPVIxP9Yx6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SN91sQx+KXNFWoxk1WWrLvkV4yBHg1aU2c2JsUWfcGXO0QMg8QHvMPFpB34pNayprehHyJ6KkRUdTMSHGSAHFHWymZ0+Lh6x6ZvrMgF40RnlOru7cGUDXLeNnynaKazwDdO4ZlQog9QaLv17kXUpkna9kcI/TE+uXZPLDMRJBHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDOc2YRM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDOc2YRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8939BC4CEE5;
	Mon, 10 Mar 2025 17:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628777;
	bh=iJ2fQXs0p/mQtsM6laLT5pik9nVjkGT2RPVIxP9Yx6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MDOc2YRMFek4MNehuArBbS6whzT2OQxnr4JVVsqemhntqp9TzWZu2tri7G9zLbZRp
	 05Og5HhkMuvsA3s/G2zzo2XIuF8GWRGGK2jUyo7iCgN0oVY3UIOm7uBiCRclK5ely0
	 JOlNU+2bNvMqvzuxzI3SbRHO+2CLAnZmZ+tmiafs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/620] wifi: cfg80211: Handle specific BSSID in 6GHz scanning
Date: Mon, 10 Mar 2025 17:58:31 +0100
Message-ID: <20250310170548.146991244@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 0fca7784b7a14d4ede64f479662afb98876ec7f8 ]

When the scan parameters for a 6GHz scan specify a unicast
BSSID address, and the corresponding AP is found in the scan
list, add a corresponding entry in the collocated AP list,
so this AP would be directly probed even if it was not
advertised as a collocated AP.

This is needed for handling a scan request that is intended
for a ML probe flow, where user space can requests a scan
to retrieve information for other links in the AP MLD.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230928172905.54b954bc02ad.I1c072793d3d77a4c8fbbc64b4db5cce1bbb00382@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 1a0d24775cde ("wifi: cfg80211: adjust allocation of colocated AP data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index dc41b31073e75..ad857cd1e6f0e 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -796,10 +796,47 @@ static int cfg80211_scan_6ghz(struct cfg80211_registered_device *rdev)
 		list_for_each_entry(intbss, &rdev->bss_list, list) {
 			struct cfg80211_bss *res = &intbss->pub;
 			const struct cfg80211_bss_ies *ies;
+			const struct element *ssid_elem;
+			struct cfg80211_colocated_ap *entry;
+			u32 s_ssid_tmp;
+			int ret;
 
 			ies = rcu_access_pointer(res->ies);
 			count += cfg80211_parse_colocated_ap(ies,
 							     &coloc_ap_list);
+
+			/* In case the scan request specified a specific BSSID
+			 * and the BSS is found and operating on 6GHz band then
+			 * add this AP to the collocated APs list.
+			 * This is relevant for ML probe requests when the lower
+			 * band APs have not been discovered.
+			 */
+			if (is_broadcast_ether_addr(rdev_req->bssid) ||
+			    !ether_addr_equal(rdev_req->bssid, res->bssid) ||
+			    res->channel->band != NL80211_BAND_6GHZ)
+				continue;
+
+			ret = cfg80211_calc_short_ssid(ies, &ssid_elem,
+						       &s_ssid_tmp);
+			if (ret)
+				continue;
+
+			entry = kzalloc(sizeof(*entry) + IEEE80211_MAX_SSID_LEN,
+					GFP_ATOMIC);
+
+			if (!entry)
+				continue;
+
+			memcpy(entry->bssid, res->bssid, ETH_ALEN);
+			entry->short_ssid = s_ssid_tmp;
+			memcpy(entry->ssid, ssid_elem->data,
+			       ssid_elem->datalen);
+			entry->ssid_len = ssid_elem->datalen;
+			entry->short_ssid_valid = true;
+			entry->center_freq = res->channel->center_freq;
+
+			list_add_tail(&entry->list, &coloc_ap_list);
+			count++;
 		}
 		spin_unlock_bh(&rdev->bss_lock);
 	}
-- 
2.39.5



