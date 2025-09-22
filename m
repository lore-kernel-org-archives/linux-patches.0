Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4684A25F780;
	Mon, 22 Sep 2025 19:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569822; cv=none; b=DHuUnfqL6hj4DIt6RCFQVHIADQYUmRH8leIEWNNs0qWbE+1ojElV+bpYzVwz89lu/tQFauatpumrsNF/FduHRaNF6jkvcOnzV/d5HNHXYIfFyNY9zITG57HqnQvWgefjTGDsUXFFOCZl6bpIknT9GmZzy6hKNGRJL4dZ5b3nQ1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569822; c=relaxed/simple;
	bh=/fML+1WBD3Kv+jBrkAB6pAoicYcANecAIkeNihrhohY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuFOabhBU3li6O2oGHNIeKPC8qDFSDmklLioDrRi0LNRqFPVK0aub/bCL9i2Av59ZiT4SmVTIKg+W3kT9morWwi8A7sD988AaS3uavYBcKTlc/nE8EBQar7N9wpPqYaJq0DQGi+wtXO149qP5nf17tz2FPmBoFCjz8z9pCwyLDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kz5EAI3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kz5EAI3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C4EC4CEF0;
	Mon, 22 Sep 2025 19:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569822;
	bh=/fML+1WBD3Kv+jBrkAB6pAoicYcANecAIkeNihrhohY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kz5EAI3cbv+le1YPDw1NB8z3kqoWavtRjSVKlr/TysPbQkTP8t5TFQj653QkBx4kz
	 IfH/4JsPwu1asUa0ats3XhsKk4fAUS9UwcJx41JbUjXaaff3uhYl89vZ6wamAJoTgH
	 k93ZOtOSvwEOUY1N31FNsEKVH7aWjrEL38F5M8w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/105] wifi: mac80211: increase scan_ies_len for S1G
Date: Mon, 22 Sep 2025 21:28:47 +0200
Message-ID: <20250922192409.024756437@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index caedc939eea19..c745de0aae776 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1120,7 +1120,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	int result, i;
 	enum nl80211_band band;
 	int channels, max_bitrates;
-	bool supp_ht, supp_vht, supp_he, supp_eht;
+	bool supp_ht, supp_vht, supp_he, supp_eht, supp_s1g;
 	struct cfg80211_chan_def dflt_chandef = {};
 
 	if (ieee80211_hw_check(hw, QUEUE_CONTROL) &&
@@ -1236,6 +1236,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	supp_vht = false;
 	supp_he = false;
 	supp_eht = false;
+	supp_s1g = false;
 	for (band = 0; band < NUM_NL80211_BANDS; band++) {
 		const struct ieee80211_sband_iftype_data *iftd;
 		struct ieee80211_supported_band *sband;
@@ -1283,6 +1284,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 			max_bitrates = sband->n_bitrates;
 		supp_ht = supp_ht || sband->ht_cap.ht_supported;
 		supp_vht = supp_vht || sband->vht_cap.vht_supported;
+		supp_s1g = supp_s1g || sband->s1g_cap.s1g;
 
 		for_each_sband_iftype_data(sband, i, iftd) {
 			u8 he_40_mhz_cap;
@@ -1411,6 +1413,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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



