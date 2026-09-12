Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1FE18A93F;
	Sat, 12 Sep 2026 14:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223235; cv=none; b=i140nZE0JNZBIIvCQ5rxkj9xJva5/67h/hF5nePUkXLn8QxQEGVQ2f8houc22TRCVHUjDW+q0XeUfMBMiKrZdgT5q9B9gBUGtN0BBJtmnETssPi1Nw0zRin2VH/7fcxF1fwQHEr50iZNdRBEzSPFQad3Dn7WbVFW6+5YBBfmhKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223235; c=relaxed/simple;
	bh=JOw1/sOt+2xkGbFudHchrjNuZHoBVpMb92oPyksrMbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLTyF6KTp/caV59KUuDy3Zqe4VfHmCdGsFVbB6RC4fjr+AS/ZWd8FAonXJm+XDyBlgGOyd3CUJhJbaQtlUfsLH7k1cTJXV+LwpJ2455dJZNhGTnT5ypwGQeEZ3e9Q6WbToCfn6+n8FvxA+N/tK03zDX7hDJLxxWgyjn5OcRMQNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IEyWAbTH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IEyWAbTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0376D1F00893;
	Sat, 12 Sep 2026 14:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223233;
	bh=S1EoZ9ZzzMoitMFbSTEaBhr+VOpTGGYxhYWH04Sg4fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IEyWAbTHvB0arUsP1aTV2MdLhDG62t0ojacp/cke54LD1AP3/FhxV57nqPgW2shQx
	 16TcBB5W23TC0W/ZFeFXGMquuhojczyAJiuq3tm+Fbtl6zzulwt3jhQTpzBLJjfOTv
	 nqN0E5kvVegB9LahecK9y4KkW8DnM0FvICAfMuyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0748/1424] wifi: ath11k: cap out-of-range rx MCS instead of leaving bogus rate
Date: Sat, 12 Sep 2026 08:53:00 +0200
Message-ID: <20260912065624.047957129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 12b09e478aa7459b7893a695ef77682202f2da83 ]

ath11k can receive HT/VHT/HE frames whose reported MCS is above the
maximum that can be expressed in the corresponding mac80211 rate space
(e.g. an HE frame reported with MCS 12, while HE tops out at MCS 11).

The frame itself is valid and decodes correctly, but for such a frame
ath11k_dp_rx_h_rate() leaves rx_status->rate_idx set to the out-of-range
value and never assigns rx_status->encoding, so it stays RX_ENC_LEGACY
from the ath11k_dp_rx_h_ppdu() initialization. Once that frame reaches
mac80211 it trips the rate sanity check and the frame is dropped with a
splat:

  ath11k_pci 0000:03:00.0: Received with invalid mcs in HE mode 12
  WARNING: CPU: 0 PID: 0 at net/mac80211/rx.c:5433 ieee80211_rx_list+0xb0a/0xe90 [mac80211]

Dropping the frame would discard otherwise valid data, so instead cap the
reported MCS to the maximum the rate space can express and deliver the
frame. Set rx_status->encoding before the range check and assign rate_idx
from the capped value, so a frame with an out-of-range MCS no longer
leaves partial or bogus rate metadata behind. Also downgrade the logging
level since they are not treated as invalid frames now. The only loss is
that such a frame is reported as the capped MCS in the rx rate statistics.

Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.41

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260701-ath11k-invalid-he-mcs-v1-1-7d963080c079@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 30 ++++++++++++-------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 23771abb3acec..7e9a5de2776c6 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2335,10 +2335,10 @@ static void ath11k_dp_rx_h_rate(struct ath11k *ar, struct hal_rx_desc *rx_desc,
 	case RX_MSDU_START_PKT_TYPE_11N:
 		rx_status->encoding = RX_ENC_HT;
 		if (rate_mcs > ATH11K_HT_MCS_MAX) {
-			ath11k_warn(ar->ab,
-				    "Received with invalid mcs in HT mode %d\n",
-				     rate_mcs);
-			break;
+			ath11k_dbg(ar->ab, ATH11K_DBG_DP_RX,
+				   "Received HT frame with out-of-range mcs %d, capping to %d\n",
+				   rate_mcs, ATH11K_HT_MCS_MAX);
+			rate_mcs = ATH11K_HT_MCS_MAX;
 		}
 		rx_status->rate_idx = rate_mcs + (8 * (nss - 1));
 		if (sgi)
@@ -2347,13 +2347,13 @@ static void ath11k_dp_rx_h_rate(struct ath11k *ar, struct hal_rx_desc *rx_desc,
 		break;
 	case RX_MSDU_START_PKT_TYPE_11AC:
 		rx_status->encoding = RX_ENC_VHT;
-		rx_status->rate_idx = rate_mcs;
 		if (rate_mcs > ATH11K_VHT_MCS_MAX) {
-			ath11k_warn(ar->ab,
-				    "Received with invalid mcs in VHT mode %d\n",
-				     rate_mcs);
-			break;
+			ath11k_dbg(ar->ab, ATH11K_DBG_DP_RX,
+				   "Received VHT frame with out-of-range mcs %d, capping to %d\n",
+				   rate_mcs, ATH11K_VHT_MCS_MAX);
+			rate_mcs = ATH11K_VHT_MCS_MAX;
 		}
+		rx_status->rate_idx = rate_mcs;
 		rx_status->nss = nss;
 		if (sgi)
 			rx_status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
@@ -2363,14 +2363,14 @@ static void ath11k_dp_rx_h_rate(struct ath11k *ar, struct hal_rx_desc *rx_desc,
 			rx_status->enc_flags |= RX_ENC_FLAG_LDPC;
 		break;
 	case RX_MSDU_START_PKT_TYPE_11AX:
-		rx_status->rate_idx = rate_mcs;
+		rx_status->encoding = RX_ENC_HE;
 		if (rate_mcs > ATH11K_HE_MCS_MAX) {
-			ath11k_warn(ar->ab,
-				    "Received with invalid mcs in HE mode %d\n",
-				    rate_mcs);
-			break;
+			ath11k_dbg(ar->ab, ATH11K_DBG_DP_RX,
+				   "Received HE frame with out-of-range mcs %d, capping to %d\n",
+				   rate_mcs, ATH11K_HE_MCS_MAX);
+			rate_mcs = ATH11K_HE_MCS_MAX;
 		}
-		rx_status->encoding = RX_ENC_HE;
+		rx_status->rate_idx = rate_mcs;
 		rx_status->nss = nss;
 		rx_status->he_gi = ath11k_mac_he_gi_to_nl80211_he_gi(sgi);
 		rx_status->bw = ath11k_mac_bw_to_mac80211_bw(bw);
-- 
2.53.0



