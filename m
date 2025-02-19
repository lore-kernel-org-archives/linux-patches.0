Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154971CCEE7;
	Wed, 19 Feb 2025 09:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956170; cv=none; b=Nb7vwfW82Pm6JWCTtqhYIA4g90jFOK5WogCOHNreR316MBil513tSlkTNWLylnZSKdwx6jgGV2HEuEN2aB/qfk1S9SZywoqPlpTNMpBBs5PA+YIqKjxvMIUkLLIbuhVOj7E6zTeD35q7aHbCEZitRiK0/fxit5oF7gpqF6Xl2no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956170; c=relaxed/simple;
	bh=HsNPhsS8YSals8HuXGnYcZtMUMoUidyBb/Pa/mtG9j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWEBg3OG9ek7R4f9QieANXpiXe878s/A4Ue49GaaXaYO2w45C8dtoEry3k+7xDkR41/1ojGhhC8k6hWDMZPyx79c4WxTvuC0gexMCqjKUWWqmYQ2fuURe2uDLvUgpfsRB3aSdC1VKH6wpsGeEPbbpHXHEqxvauV4lKjfGsP3X2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzvQ62xd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzvQ62xd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920A6C4CED1;
	Wed, 19 Feb 2025 09:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956170;
	bh=HsNPhsS8YSals8HuXGnYcZtMUMoUidyBb/Pa/mtG9j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzvQ62xdnBLjgrMzFLSvpnBhj+iTAnTbd+IKKJzins3yo3a1FxO0pNhq6Ie7lkG/1
	 bcTbrkJM6jvGxDu054x5oMJ30k2fJR+OAbEFxQ9wtotLSPMhJ7ju0JVG3XmM9D7yWT
	 vGzxt3iSGi1W05n8rDlIwGGgpeFuxvWfmeFJJ6/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/578] wifi: cfg80211: Handle specific BSSID in 6GHz scanning
Date: Wed, 19 Feb 2025 09:21:33 +0100
Message-ID: <20250219082656.462149967@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 398b6bab4b60e..42514768bcb10 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -799,10 +799,47 @@ static int cfg80211_scan_6ghz(struct cfg80211_registered_device *rdev)
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



