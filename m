Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F733A0B38;
	Sat, 17 Oct 2026 17:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258094; cv=none; b=WR+9AT5pQDuyRO8keT3IsDZRPxdjTXk4JYOxkXlGFfR27ji0O9xzPMNX1XwLODEaq18Vx/9z5wE8Z0JljES1XDujUGJIJn9kddRWGN8ltkxtOleTwJXi3TbkA97xaNIM3sm29YRGgZFDzg9FZeQWDoLQbuLcd1Qdpcri1Anr8Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258094; c=relaxed/simple;
	bh=VS8xmjKD22yzAgZDiqZth6EMaoJkCFsDaCkIoze4GtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8jkEdKgU8GC9uXyP9y4X/J1M0DgYfGrr8dKJPRdL0vD8tRzDFY0VBV0GeuhNKLa9asMhcPELUBNTWyxRMrL5MtldcZ0aJngmApeZeWCuUEU1QfEgBKUq9ImEjuwnV0ta+vwYQ4AIDn+DNj8D5+YV+EIIyubeCywmw0DefG0RBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1UrHOV50; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1UrHOV50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA93D1F000C4;
	Sat, 17 Oct 2026 17:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258093;
	bh=IcaiOnaD4Dq09gk9WBKsF/a4J2ur9MV6lvTJwDO9lak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1UrHOV50qGrupWvSii6fPQWkQKU+093FdbNToImVtdxCmW5eZN+YMubzoen/0lefj
	 woVhLynjFKGRJpYVjdBaMHLIPOyaoSfImbgJa4QLJSTsdVvJ8qLZuxNjmucHjRSN+t
	 tR2NteKND2GhIyjmE8BfZozeURgAUKT/AeEYZuWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0770/1674] wifi: ath11k: mac: fix struct ieee80211_sband_iftype_data handling
Date: Sat, 17 Oct 2026 17:50:42 +0200
Message-ID: <20261017160450.868739810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalle Valo <quic_kvalo@quicinc.com>

[ Upstream commit 9e61589ac3c2d23c528d3ffd44604d98553ea1cb ]

Commit e8c1841278a7 ("wifi: cfg80211: annotate iftype_data pointer with
sparse") added sparse checks for struct ieee80211_sband_iftype_data handling
which immediately found an issue in ath11k:

drivers/net/wireless/ath/ath11k/mac.c:7952:22: warning: incorrect type in argument 1 (different address spaces)
drivers/net/wireless/ath/ath11k/mac.c:7952:22:    expected struct ieee80211_sta_he_cap const *he_cap
drivers/net/wireless/ath/ath11k/mac.c:7952:22:    got struct ieee80211_sta_he_cap const [noderef] __iftype_data *

The problem here is that we are accessing sband->iftype_data directly even
though we should use for_each_sband_iftype_data() or similar. Fortunately
there's ieee80211_get_he_iftype_cap_vif() which is just what we need here so
use it to get HE capabilities.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.23

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230927142708.2897504-2-kvalo@kernel.org
Stable-dep-of: 65c12b104cb9 ("wifi: ath11k: fix sleeping-in-atomic in ath11k_mac_op_set_bitrate_mask()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 4e36a2ba18204..a9525c2543884 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -7763,12 +7763,14 @@ ath11k_mac_get_tx_mcs_map(const struct ieee80211_sta_he_cap *he_cap)
 
 static bool
 ath11k_mac_bitrate_mask_get_single_nss(struct ath11k *ar,
+				       struct ath11k_vif *arvif,
 				       enum nl80211_band band,
 				       const struct cfg80211_bitrate_mask *mask,
 				       int *nss)
 {
 	struct ieee80211_supported_band *sband = &ar->mac.sbands[band];
 	u16 vht_mcs_map = le16_to_cpu(sband->vht_cap.vht_mcs.tx_mcs_map);
+	const struct ieee80211_sta_he_cap *he_cap;
 	u16 he_mcs_map = 0;
 	u8 ht_nss_mask = 0;
 	u8 vht_nss_mask = 0;
@@ -7799,7 +7801,11 @@ ath11k_mac_bitrate_mask_get_single_nss(struct ath11k *ar,
 			return false;
 	}
 
-	he_mcs_map = le16_to_cpu(ath11k_mac_get_tx_mcs_map(&sband->iftype_data->he_cap));
+	he_cap = ieee80211_get_he_iftype_cap_vif(sband, arvif->vif);
+	if (!he_cap)
+		return false;
+
+	he_mcs_map = le16_to_cpu(ath11k_mac_get_tx_mcs_map(he_cap));
 
 	for (i = 0; i < ARRAY_SIZE(mask->control[band].he_mcs); i++) {
 		if (mask->control[band].he_mcs[i] == 0)
@@ -8215,7 +8221,7 @@ ath11k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 		ieee80211_iterate_stations_atomic(ar->hw,
 						  ath11k_mac_disable_peer_fixed_rate,
 						  arvif);
-	} else if (ath11k_mac_bitrate_mask_get_single_nss(ar, band, mask,
+	} else if (ath11k_mac_bitrate_mask_get_single_nss(ar, arvif, band, mask,
 							  &single_nss)) {
 		rate = WMI_FIXED_RATE_NONE;
 		nss = single_nss;
-- 
2.53.0



