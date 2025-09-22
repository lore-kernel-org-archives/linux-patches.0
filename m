Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335232F1FDA;
	Mon, 22 Sep 2025 19:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570099; cv=none; b=RBtFtZvfGsSBOQmhQCPiXdDcOuE6Us6L+lnzvS2RUSAJ24CnbKMMlE4gmU27dsEAzpxhu35js5wvfL1ae17FDeBoJa5XCwVPVHWBTIPQaDxSU1x/hkhEa+8EPUx/lWkHRucvbE7nM0yEolKDGWEudkoxZuZxo/zRXiqIDVaLkgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570099; c=relaxed/simple;
	bh=JRDNsXIoeuFcX/z1xr3LdqlkUcQoDGstj+7lrH90AzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRiHOf70OzZzldDqU5jB+TKVxudxQvwOIahmostlUyVLerpKwkZccmvSQ/PQQmODxOzLENqBmLi3g9/DsPmfqWwMdJFuTsCZDBStxkbIfbeqy1stTkcGceL74wU7TL1sICVX9REt6AXdb1t5Y/201L/sXRA1MW3ao+dxG077le0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTAqUxjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTAqUxjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AAAC4CEF5;
	Mon, 22 Sep 2025 19:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570099;
	bh=JRDNsXIoeuFcX/z1xr3LdqlkUcQoDGstj+7lrH90AzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTAqUxjjIdFShPgCUS23L2CXoylZIxjRBrD4QOS4kLsbw9OrAVsvaKJjtV6R4bmpZ
	 BvqXd29vQ/lsn9asrpfLhMdXpxytioQjS8oLXq2h6TZbHYIjvogG8nP12zr46m6L6Z
	 zU25S0rFW7D2QKyat1WEPA6eq+IqXp7bUqJclDnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 009/149] wifi: mac80211: increase scan_ies_len for S1G
Date: Mon, 22 Sep 2025 21:28:29 +0200
Message-ID: <20250922192413.125848631@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lachlan Hodges <lachlan.hodges@morsemicro.com>

[ Upstream commit 7e2f3213e85eba00acb4cfe6d71647892d63c3a1 ]

Currently the S1G capability element is not taken into account
for the scan_ies_len, which leads to a buffer length validation
failure in ieee80211_prep_hw_scan() and subsequent WARN in
__ieee80211_start_scan(). This prevents hw scanning from functioning.
To fix ensure we accommodate for the S1G capability length.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20250826085437.3493-1-lachlan.hodges@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 1bad353d8a772..35c6755b817a8 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1136,7 +1136,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	int result, i;
 	enum nl80211_band band;
 	int channels, max_bitrates;
-	bool supp_ht, supp_vht, supp_he, supp_eht;
+	bool supp_ht, supp_vht, supp_he, supp_eht, supp_s1g;
 	struct cfg80211_chan_def dflt_chandef = {};
 
 	if (ieee80211_hw_check(hw, QUEUE_CONTROL) &&
@@ -1252,6 +1252,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	supp_vht = false;
 	supp_he = false;
 	supp_eht = false;
+	supp_s1g = false;
 	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		const struct ieee80211_sband_iftype_data *iftd;
 		struct ieee80211_supported_band *sband;
@@ -1299,6 +1300,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 			max_bitrates = sband->n_bitrates;
 		supp_ht = supp_ht || sband->ht_cap.ht_supported;
 		supp_vht = supp_vht || sband->vht_cap.vht_supported;
+		supp_s1g = supp_s1g || sband->s1g_cap.s1g;
 
 		for_each_sband_iftype_data(sband, i, iftd) {
 			u8 he_40_mhz_cap;
@@ -1432,6 +1434,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		local->scan_ies_len +=
 			2 + sizeof(struct ieee80211_vht_cap);
 
+	if (supp_s1g)
+		local->scan_ies_len += 2 + sizeof(struct ieee80211_s1g_cap);
+
 	/*
 	 * HE cap element is variable in size - set len to allow max size */
 	if (supp_he) {
-- 
2.51.0



