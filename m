Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1C22F0C62;
	Wed, 20 May 2026 16:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294533; cv=none; b=LjrrZkqo6ummjyqQ5V8fZPq7GW2bbMLt0O7cfrvET6gTl6m4nVAfVuCXYoTnvbbTEjNWmefEZWN2ng5JlFLSbge2Q8lB0q2vtbECijNul0cfA42D8F708FjR4xCGTesemjB1xI70ds8Cr21iNv37tT/wFD6j7sV82LDDdsW6MXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294533; c=relaxed/simple;
	bh=/xUh0bIj6reN96g8YS7lIMTurLBYQXqilVq6aVcmpLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsGas3KL4hXkdzOIZdNEs6xons0J0ZBlaYSG8bhU0MmG7wjB//YHL8PC5hDpUKuqghr7bR1Mslc5Xbyw8CkO6QMwb7LEUgDgrXoxIDzY5SV+y8RftEWPM9LVAtB97YKqHlEm5qlZ4Q2Ko9lKZPO06soyQ75D3AlCyY+Lqkq4Myk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Udv0Tf53; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Udv0Tf53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B186F1F000E9;
	Wed, 20 May 2026 16:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294532;
	bh=8PgoReTN2XLYEa2rhyDguwxWGnViR/nWpk1Bz90qRi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Udv0Tf532qG2V9mgY9rB++aDeChkkMBg+bC/tgFMd3N3Y4HubOQROnmXpjbtDxOqv
	 oGhIzopLrJDffxIz1g5JIStJXcE6fD8BQL1CnCO1c+j0GF03+LftH/9Lrktv0AJicb
	 UyY9DDAAR3I/Pm0c4Mg/i15el6QX/Y6AWU6SLRCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <sarika.sharma@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0074/1146] wifi: ath12k: account TX stats only when ACK/BA status is present
Date: Wed, 20 May 2026 18:05:24 +0200
Message-ID: <20260520162150.031011930@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarika Sharma <sarika.sharma@oss.qualcomm.com>

[ Upstream commit 1635ecc61a24597f893d057d004051a535c1c643 ]

The fields tx_retry_failed, tx_retry_count, and tx_duration are
currently updated outside the HTT_PPDU_STATS_TAG_USR_COMPLTN_ACK_BA_STATUS
flag check. In certain scenarios, firmware delivers multiple PPDU
statistics for the same PPDU, first without BA/ACK information, and
later with BA/ACK status once it becomes available. As the same PPDU
is processed again, these counters are updated a second time,
resulting in duplicate TX statistics.

To address this, move the accounting of tx_retry_failed and
tx_retry_count under the ACK/BA status flag check, and similarly gate
tx_duration on the same path. This ensures that each PPDU contributes
to these counters exactly once, avoids double counting, and provides
consistent reporting in userspace tools such as station dump.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Fixes: a0b963e1da5b ("wifi: ath12k: fetch tx_retry and tx_failed from htt_ppdu_stats_user_cmpltn_common_tlv")
Signed-off-by: Sarika Sharma <sarika.sharma@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260226051947.1379716-1-sarika.sharma@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_htt.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_htt.c b/drivers/net/wireless/ath/ath12k/dp_htt.c
index e71bb71a6020e..9c19d9707abfb 100644
--- a/drivers/net/wireless/ath/ath12k/dp_htt.c
+++ b/drivers/net/wireless/ath/ath12k/dp_htt.c
@@ -205,16 +205,9 @@ ath12k_update_per_peer_tx_stats(struct ath12k_pdev_dp *dp_pdev,
 	if (!(usr_stats->tlv_flags & BIT(HTT_PPDU_STATS_TAG_USR_RATE)))
 		return;
 
-	if (usr_stats->tlv_flags & BIT(HTT_PPDU_STATS_TAG_USR_COMPLTN_COMMON)) {
+	if (usr_stats->tlv_flags & BIT(HTT_PPDU_STATS_TAG_USR_COMPLTN_COMMON))
 		is_ampdu =
 			HTT_USR_CMPLTN_IS_AMPDU(usr_stats->cmpltn_cmn.flags);
-		tx_retry_failed =
-			__le16_to_cpu(usr_stats->cmpltn_cmn.mpdu_tried) -
-			__le16_to_cpu(usr_stats->cmpltn_cmn.mpdu_success);
-		tx_retry_count =
-			HTT_USR_CMPLTN_LONG_RETRY(usr_stats->cmpltn_cmn.flags) +
-			HTT_USR_CMPLTN_SHORT_RETRY(usr_stats->cmpltn_cmn.flags);
-	}
 
 	if (usr_stats->tlv_flags &
 	    BIT(HTT_PPDU_STATS_TAG_USR_COMPLTN_ACK_BA_STATUS)) {
@@ -223,10 +216,19 @@ ath12k_update_per_peer_tx_stats(struct ath12k_pdev_dp *dp_pdev,
 					  HTT_PPDU_STATS_ACK_BA_INFO_NUM_MSDU_M);
 		tid = le32_get_bits(usr_stats->ack_ba.info,
 				    HTT_PPDU_STATS_ACK_BA_INFO_TID_NUM);
-	}
 
-	if (common->fes_duration_us)
-		tx_duration = le32_to_cpu(common->fes_duration_us);
+		if (usr_stats->tlv_flags & BIT(HTT_PPDU_STATS_TAG_USR_COMPLTN_COMMON)) {
+			tx_retry_failed =
+				__le16_to_cpu(usr_stats->cmpltn_cmn.mpdu_tried) -
+				__le16_to_cpu(usr_stats->cmpltn_cmn.mpdu_success);
+			tx_retry_count =
+				HTT_USR_CMPLTN_LONG_RETRY(usr_stats->cmpltn_cmn.flags) +
+				HTT_USR_CMPLTN_SHORT_RETRY(usr_stats->cmpltn_cmn.flags);
+		}
+
+		if (common->fes_duration_us)
+			tx_duration = le32_to_cpu(common->fes_duration_us);
+	}
 
 	user_rate = &usr_stats->rate;
 	flags = HTT_USR_RATE_PREAMBLE(user_rate->rate_flags);
-- 
2.53.0



