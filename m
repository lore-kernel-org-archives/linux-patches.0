Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80841C8E6;
	Mon, 22 Sep 2025 19:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569489; cv=none; b=hIABBr0RYTb4jg44Z8kzU8NZhUjeJhEQVtrpEzSFce+JYywJPj/mB75Rat1aPjVKcAMLn7IqvNhqOdTMfHwCioawlO3ybAueYL1s82iqdX9/YCfbtBAqRQj0xwJTFd60yy3R+c23vPAAnFJRh0k54wIlzWPVXpuAsXeBK7kFqq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569489; c=relaxed/simple;
	bh=jpYcgXkORW60bwABTCGkbvBFkIXsnTtoAmuWzELggUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OR92xYUlSn9flTqerox2lsEqKAbFPlZnG0wpYil77idAqZXXlcZWnmshtxHLySjVGiJihDreYSDrE+c9k0hHxh/2T/yy8/7dGgb8vSGrtbY5y4CegXRUIx+lGOrfY8T5P3FHO53rVmNAy7e/u8fwo9YG8+Hgxvp24A8k60yHCSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mvlcpugk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mvlcpugk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953ACC4CEF0;
	Mon, 22 Sep 2025 19:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569489;
	bh=jpYcgXkORW60bwABTCGkbvBFkIXsnTtoAmuWzELggUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MvlcpugkmzXfYxKof6XbUCSVzVVlTAJ2gVUoaDoF9otaX79UxwphJ6/Atf4j3DKld
	 ZNAGgRsla4I2vVK30e+XwlfzA6SgSSWwp++OAI6S1IVSKwNjDDdGyDtlE8V7zHZOUy
	 youGokV0rd1uH/5JLe5rJ2dWVtlkJ7NZsSVrq2XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 02/61] wifi: mac80211: increase scan_ies_len for S1G
Date: Mon, 22 Sep 2025 21:28:55 +0200
Message-ID: <20250922192403.606433750@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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
index 683301d9f5084..7831e412c7b9d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -945,7 +945,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	int result, i;
 	enum nl80211_band band;
 	int channels, max_bitrates;
-	bool supp_ht, supp_vht, supp_he, supp_eht;
+	bool supp_ht, supp_vht, supp_he, supp_eht, supp_s1g;
 	struct cfg80211_chan_def dflt_chandef = {};
 
 	if (ieee80211_hw_check(hw, QUEUE_CONTROL) &&
@@ -1061,6 +1061,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	supp_vht = false;
 	supp_he = false;
 	supp_eht = false;
+	supp_s1g = false;
 	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		struct ieee80211_supported_band *sband;
 
@@ -1097,6 +1098,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 			max_bitrates = sband->n_bitrates;
 		supp_ht = supp_ht || sband->ht_cap.ht_supported;
 		supp_vht = supp_vht || sband->vht_cap.vht_supported;
+		supp_s1g = supp_s1g || sband->s1g_cap.s1g;
 
 		for (i = 0; i < sband->n_iftype_data; i++) {
 			const struct ieee80211_sband_iftype_data *iftd;
@@ -1219,6 +1221,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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



