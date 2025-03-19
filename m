Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDE81B0F32;
	Wed, 19 Mar 2025 14:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394855; cv=none; b=GElQOD7XcKuZ6bEs9m7TpvfmUo0K7xCSjQ39imdG6h9WvdfD5Pk9AsQ2JK0L1Vr/PPYaXWrqSKgQkPJE26U45XJw6Vu7gLx7BxFV6uivZKrgy1CNgn/6uTjGbM4DOgZpsEJ/yhdFwBRaNMAk4Kn8PyX8MCu83gORVzgg+97og5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394855; c=relaxed/simple;
	bh=Vs04rKv5Cc2os1UZWBb1hOJ6zV5pgiMUCnF6AvJkF/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvvLhVHGfpltsZ24YAdmi8DBe6/kBvTgHdBaezzAZD/12g9ihvn4MfPtFCHz17/TRor77vs36COKZqvsnvkMpTHTTPDIyGN3x03q27WPP8krz74rWD528JJLk0X2e8Jl2p9jhIOu59f8LKudF7FTjItTBFWt7wP4Gw7BvSNFCQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urhQrl6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urhQrl6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539DCC4CEE8;
	Wed, 19 Mar 2025 14:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394855;
	bh=Vs04rKv5Cc2os1UZWBb1hOJ6zV5pgiMUCnF6AvJkF/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urhQrl6E3mAPeUL2Viy3LG2xIVzydaj2DvSXzke2pMZ2k9qNKmJmgVIdU3aKg20h3
	 p8Mpu2u6ydtl0cc1Qw4Ob5N8VQGcHkIrmIIfP/Ugj+DE14iLJQKFiR9Xmenxjy02B+
	 fAmNxdW6L99d4IVzCLfsbyJOeMLLlUp5LRkiiN8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 043/241] wifi: mac80211: fix MPDU length parsing for EHT 5/6 GHz
Date: Wed, 19 Mar 2025 07:28:33 -0700
Message-ID: <20250319143028.786253831@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 8ae227f8a7749eec92fc381dfbe213429c852278 ]

The MPDU length is only configured using the EHT capabilities element on
2.4 GHz. On 5/6 GHz it is configured using the VHT or HE capabilities
respectively.

Fixes: cf0079279727 ("wifi: mac80211: parse A-MSDU len from EHT capabilities")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://patch.msgid.link/20250311121704.0634d31f0883.I28063e4d3ef7d296b7e8a1c303460346a30bf09c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/eht.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/eht.c b/net/mac80211/eht.c
index 7a3116c36df9f..fd41046e3b681 100644
--- a/net/mac80211/eht.c
+++ b/net/mac80211/eht.c
@@ -2,7 +2,7 @@
 /*
  * EHT handling
  *
- * Copyright(c) 2021-2024 Intel Corporation
+ * Copyright(c) 2021-2025 Intel Corporation
  */
 
 #include "ieee80211_i.h"
@@ -76,6 +76,13 @@ ieee80211_eht_cap_ie_to_sta_eht_cap(struct ieee80211_sub_if_data *sdata,
 	link_sta->cur_max_bandwidth = ieee80211_sta_cap_rx_bw(link_sta);
 	link_sta->pub->bandwidth = ieee80211_sta_cur_vht_bw(link_sta);
 
+	/*
+	 * The MPDU length bits are reserved on all but 2.4 GHz and get set via
+	 * VHT (5 GHz) or HE (6 GHz) capabilities.
+	 */
+	if (sband->band != NL80211_BAND_2GHZ)
+		return;
+
 	switch (u8_get_bits(eht_cap->eht_cap_elem.mac_cap_info[0],
 			    IEEE80211_EHT_MAC_CAP0_MAX_MPDU_LEN_MASK)) {
 	case IEEE80211_EHT_MAC_CAP0_MAX_MPDU_LEN_11454:
-- 
2.39.5



