Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8E4184553;
	Tue, 30 Jul 2024 16:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356428; cv=none; b=jAW6LzgKu9bARCrbAbbLMSVgJ69tV6M9esAEmUeg3QzHNtLVkmyQomdVKF3J/fYKkVHXu5QtEG2y9YSc870birRPAf7Y5pFXzgTnVmEgU92F79Aew9CL2gGTKHkwD2HLEfcIwNMPxrRzhaZKrVP9AlHpjwzZx4HZzSPNfcCcU64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356428; c=relaxed/simple;
	bh=zgWVLYCnXOrbPiryuhGRZBPDIMuINdFBVg/T4VPjQVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U41ozjQFxqor/t0bLUdaYl8je3+LrwHLA+2fIZKFHs/B+KCnYBo8Ui79bKSaIE57oGA6AFWSAZhuASAMKn1oZ83SuxXusBGSWp7QhhMZxV5kKeECF2Gv1Bz3YQRlnEUW6/PKj6hu5dVeY4o2CxOqYIxsreFFuNaPsrz0k1l62qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=btWe4C6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="btWe4C6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B4EC32782;
	Tue, 30 Jul 2024 16:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356428;
	bh=zgWVLYCnXOrbPiryuhGRZBPDIMuINdFBVg/T4VPjQVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btWe4C6uoi0PHqXHIe/zjBb6gq6fFfD2J7KBbQDrNDPJLWKCv8GSJdoM1zyJLtRgp
	 rV5VjQeegFx3reegk1vO8tGi+txImahV0yJAr98qKGVVuadG2vz7f/paVzRgIT9D7s
	 aIqXwROcN1r5ZgtErVHPpVOzuISlWlFBjn1ZpiM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Kathirvel <quic_kathirve@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 149/809] wifi: ath12k: drop failed transmitted frames from metric calculation.
Date: Tue, 30 Jul 2024 17:40:25 +0200
Message-ID: <20240730151730.492103560@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>

[ Upstream commit 50971dc6694c0845fcddfe337ea39c5b723d5a92 ]

In mesh node traffic, internal firmware-transmitted failures are
reported as transmitted failures in mesh metric calculation, leading
to the breakage of the mesh link.

Fix the issue by dropping the internal firmware-transmitted failures
before updating the TX completion status to mac80211, in order to
prevent false failure averaging in mesh metric calculation.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240430074313.885807-3-quic_kathirve@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c    | 38 ++++++++++++++++------
 drivers/net/wireless/ath/ath12k/hal_desc.h | 22 ++++++++++++-
 2 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index 81a85d5946f5a..a7c7a868c14ce 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -482,18 +482,36 @@ static void ath12k_dp_tx_complete_msdu(struct ath12k *ar,
 	/* skip tx rate update from ieee80211_status*/
 	info->status.rates[0].idx = -1;
 
-	if (ts->status == HAL_WBM_TQM_REL_REASON_FRAME_ACKED &&
-	    !(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
-		info->flags |= IEEE80211_TX_STAT_ACK;
-		info->status.ack_signal = ATH12K_DEFAULT_NOISE_FLOOR +
-					  ts->ack_rssi;
-		info->status.flags = IEEE80211_TX_STATUS_ACK_SIGNAL_VALID;
+	switch (ts->status) {
+	case HAL_WBM_TQM_REL_REASON_FRAME_ACKED:
+		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
+			info->flags |= IEEE80211_TX_STAT_ACK;
+			info->status.ack_signal = ATH12K_DEFAULT_NOISE_FLOOR +
+						  ts->ack_rssi;
+			info->status.flags = IEEE80211_TX_STATUS_ACK_SIGNAL_VALID;
+		}
+		break;
+	case HAL_WBM_TQM_REL_REASON_CMD_REMOVE_TX:
+		if (info->flags & IEEE80211_TX_CTL_NO_ACK) {
+			info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
+			break;
+		}
+		fallthrough;
+	case HAL_WBM_TQM_REL_REASON_CMD_REMOVE_MPDU:
+	case HAL_WBM_TQM_REL_REASON_DROP_THRESHOLD:
+	case HAL_WBM_TQM_REL_REASON_CMD_REMOVE_AGED_FRAMES:
+		/* The failure status is due to internal firmware tx failure
+		 * hence drop the frame; do not update the status of frame to
+		 * the upper layer
+		 */
+		ieee80211_free_txskb(ah->hw, msdu);
+		goto exit;
+	default:
+		ath12k_dbg(ab, ATH12K_DBG_DP_TX, "tx frame is not acked status %d\n",
+			   ts->status);
+		break;
 	}
 
-	if (ts->status == HAL_WBM_TQM_REL_REASON_CMD_REMOVE_TX &&
-	    (info->flags & IEEE80211_TX_CTL_NO_ACK))
-		info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
-
 	/* NOTE: Tx rate status reporting. Tx completion status does not have
 	 * necessary information (for example nss) to build the tx rate.
 	 * Might end up reporting it out-of-band from HTT stats.
diff --git a/drivers/net/wireless/ath/ath12k/hal_desc.h b/drivers/net/wireless/ath/ath12k/hal_desc.h
index 63340256d3f64..814c02f876d64 100644
--- a/drivers/net/wireless/ath/ath12k/hal_desc.h
+++ b/drivers/net/wireless/ath/ath12k/hal_desc.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: BSD-3-Clause-Clear */
 /*
  * Copyright (c) 2018-2021 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2022, 2024 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 #include "core.h"
 
@@ -2048,6 +2048,19 @@ struct hal_wbm_release_ring {
  *	fw with fw_reason2.
  * @HAL_WBM_TQM_REL_REASON_CMD_REMOVE_RESEAON3: Remove command initiated by
  *	fw with fw_reason3.
+ * @HAL_WBM_TQM_REL_REASON_CMD_DISABLE_QUEUE: Remove command initiated by
+ *	fw with disable queue.
+ * @HAL_WBM_TQM_REL_REASON_CMD_TILL_NONMATCHING: Remove command initiated by
+ *	fw to remove all mpdu until 1st non-match.
+ * @HAL_WBM_TQM_REL_REASON_DROP_THRESHOLD: Dropped due to drop threshold
+ *	criteria
+ * @HAL_WBM_TQM_REL_REASON_DROP_LINK_DESC_UNAVAIL: Dropped due to link desc
+ *	not available
+ * @HAL_WBM_TQM_REL_REASON_DROP_OR_INVALID_MSDU: Dropped due drop bit set or
+ *	null flow
+ * @HAL_WBM_TQM_REL_REASON_MULTICAST_DROP: Dropped due mcast drop set for VDEV
+ * @HAL_WBM_TQM_REL_REASON_VDEV_MISMATCH_DROP: Dropped due to being set with
+ *	'TCL_drop_reason'
  */
 enum hal_wbm_tqm_rel_reason {
 	HAL_WBM_TQM_REL_REASON_FRAME_ACKED,
@@ -2058,6 +2071,13 @@ enum hal_wbm_tqm_rel_reason {
 	HAL_WBM_TQM_REL_REASON_CMD_REMOVE_RESEAON1,
 	HAL_WBM_TQM_REL_REASON_CMD_REMOVE_RESEAON2,
 	HAL_WBM_TQM_REL_REASON_CMD_REMOVE_RESEAON3,
+	HAL_WBM_TQM_REL_REASON_CMD_DISABLE_QUEUE,
+	HAL_WBM_TQM_REL_REASON_CMD_TILL_NONMATCHING,
+	HAL_WBM_TQM_REL_REASON_DROP_THRESHOLD,
+	HAL_WBM_TQM_REL_REASON_DROP_LINK_DESC_UNAVAIL,
+	HAL_WBM_TQM_REL_REASON_DROP_OR_INVALID_MSDU,
+	HAL_WBM_TQM_REL_REASON_MULTICAST_DROP,
+	HAL_WBM_TQM_REL_REASON_VDEV_MISMATCH_DROP,
 };
 
 struct hal_wbm_buffer_ring {
-- 
2.43.0



