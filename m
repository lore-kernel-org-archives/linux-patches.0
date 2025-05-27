Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C766227A131;
	Tue, 27 May 2025 17:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368222; cv=none; b=G1XrO7qBqsz3pejRPG6U+jxkmeFrEr/dp4RJPkxIlmFqPg06YP27JiyYSha4SSYOi3hgGb6BdbylDJu1qThiXmIyAayHqqE3ZUihVFHP3vG27V1ld7ubz1YXLH1hbXrtAUlgMgyZ2R3JDohWBDua6/l61SBxTeBIZAhScuLlCuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368222; c=relaxed/simple;
	bh=evBSgS0BNfNS+k2gvm7fvnIXqhCGCGNw9+bFAhWtSfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIZuJZ1K8Cl6BDcbLRXuGtgHTuHoYFKklrCKDVb4fVesJL7Gum1250Ne/kYX7eXtGNC+17PahyizikR5USxcnIscAhS0yxqXNAY2DPCc+QPP0pHpJCwb2Slch25fVkzxg+Wb/MAuid1dMsv/GpwiyPWKHdyEnwAtRSytzLHSkwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OEryUVYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OEryUVYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89E9C4CEEA;
	Tue, 27 May 2025 17:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368222;
	bh=evBSgS0BNfNS+k2gvm7fvnIXqhCGCGNw9+bFAhWtSfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OEryUVYaN9JUeCWyqoScFhfsIdA6TBpLy0PJSYlyluaLb2aSVamkjtRHTkUn0zAaS
	 8ZGQCXVmKij8vrgBZedCc9PZsVq5+Lmo4bQ4EBx2/xZDxbg8Hu/LWdpfGcVenUCN33
	 Kh9z442HBZQM0EOvda19UuB0wOKRo1emxPTcJU9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lingbo Kong <quic_lingbok@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 610/783] wifi: ath12k: report station mode receive rate for IEEE 802.11be
Date: Tue, 27 May 2025 18:26:47 +0200
Message-ID: <20250527162537.993046227@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lingbo Kong <quic_lingbok@quicinc.com>

[ Upstream commit 5e73276c814fc1a5a1bce6be743e1a07baa6d4bc ]

Currently, the receive rate of EHT of "iw dev xxx station dump" command
always show an invalid value.

This is because ath12k does not pass information about the rx_status of EHT
to mac80211. So, mac80211 not calculate the receive rate.

To address this issue, add logic for handling rx_status of EHT to the
ath12k_dp_rx_h_rate() function.

After that, "iw dev xxx station dump" show the correct receive rate.
Such as:

Station 00:03:7f:12:03:03 (on wlo1)
        inactive time:  48 ms
        rx bytes:       59226
        rx packets:     320
        tx bytes:       26556
        tx packets:     191
        tx retries:     99
        tx failed:      0
        beacon loss:    0
        beacon rx:      79
        rx drop misc:   68
        signal:         -95 dBm
        beacon signal avg:      -20 dBm
        tx bitrate:     688.2 MBit/s 40MHz EHT-MCS 13 EHT-NSS 2 EHT-GI 0
        tx duration:    0 us
        rx bitrate:     619.5 MBit/s 40MHz EHT-MCS 8 EHT-NSS 3 EHT-GI 0

This patch affects the station mode of WCN7850 and QCN9274.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.1.1-00214-QCAHKSWPL_SILICONZ-1

Signed-off-by: Lingbo Kong <quic_lingbok@quicinc.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219715
Link: https://patch.msgid.link/20250115063537.35797-3-quic_lingbok@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c   | 22 ++++++++++++++++++++--
 drivers/net/wireless/ath/ath12k/rx_desc.h |  2 ++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index ae6608b10bb57..ff6a709b5042c 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2021 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <linux/ieee80211.h>
@@ -2392,6 +2392,23 @@ static void ath12k_dp_rx_h_rate(struct ath12k *ar, struct hal_rx_desc *rx_desc,
 		rx_status->he_gi = ath12k_he_gi_to_nl80211_he_gi(sgi);
 		rx_status->bw = ath12k_mac_bw_to_mac80211_bw(bw);
 		break;
+	case RX_MSDU_START_PKT_TYPE_11BE:
+		rx_status->rate_idx = rate_mcs;
+
+		if (rate_mcs > ATH12K_EHT_MCS_MAX) {
+			ath12k_warn(ar->ab,
+				    "Received with invalid mcs in EHT mode %d\n",
+				    rate_mcs);
+			break;
+		}
+
+		rx_status->encoding = RX_ENC_EHT;
+		rx_status->nss = nss;
+		rx_status->eht.gi = ath12k_mac_eht_gi_to_nl80211_eht_gi(sgi);
+		rx_status->bw = ath12k_mac_bw_to_mac80211_bw(bw);
+		break;
+	default:
+		break;
 	}
 }
 
@@ -2486,7 +2503,7 @@ static void ath12k_dp_rx_deliver_msdu(struct ath12k *ar, struct napi_struct *nap
 	spin_unlock_bh(&ab->base_lock);
 
 	ath12k_dbg(ab, ATH12K_DBG_DATA,
-		   "rx skb %p len %u peer %pM %d %s sn %u %s%s%s%s%s%s%s%s%s rate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i amsdu-more %i\n",
+		   "rx skb %p len %u peer %pM %d %s sn %u %s%s%s%s%s%s%s%s%s%s rate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i amsdu-more %i\n",
 		   msdu,
 		   msdu->len,
 		   peer ? peer->addr : NULL,
@@ -2497,6 +2514,7 @@ static void ath12k_dp_rx_deliver_msdu(struct ath12k *ar, struct napi_struct *nap
 		   (status->encoding == RX_ENC_HT) ? "ht" : "",
 		   (status->encoding == RX_ENC_VHT) ? "vht" : "",
 		   (status->encoding == RX_ENC_HE) ? "he" : "",
+		   (status->encoding == RX_ENC_EHT) ? "eht" : "",
 		   (status->bw == RATE_INFO_BW_40) ? "40" : "",
 		   (status->bw == RATE_INFO_BW_80) ? "80" : "",
 		   (status->bw == RATE_INFO_BW_160) ? "160" : "",
diff --git a/drivers/net/wireless/ath/ath12k/rx_desc.h b/drivers/net/wireless/ath/ath12k/rx_desc.h
index 10366bbe99999..fc1eceb2d99bb 100644
--- a/drivers/net/wireless/ath/ath12k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath12k/rx_desc.h
@@ -637,6 +637,8 @@ enum rx_msdu_start_pkt_type {
 	RX_MSDU_START_PKT_TYPE_11N,
 	RX_MSDU_START_PKT_TYPE_11AC,
 	RX_MSDU_START_PKT_TYPE_11AX,
+	RX_MSDU_START_PKT_TYPE_11BA,
+	RX_MSDU_START_PKT_TYPE_11BE,
 };
 
 enum rx_msdu_start_sgi {
-- 
2.39.5



