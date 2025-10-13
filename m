Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC27307AD6;
	Mon, 13 Oct 2025 15:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369859; cv=none; b=S8zdi5abOyj8EuVmXbzoQEVHckMwLEgxzMSijJra78AecJSy0QHW7tBQ2R/yuGCovhhkdJ+eOyR9QQfaN+ibHhNC3SAQ1Hxrxz32YtR0z/oHKare9v4eRxFhDi0jBtT3t74Mg9qI+9T/57fvJVqgLUKwT3urfnB4pOT1VIRo14g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369859; c=relaxed/simple;
	bh=z1o9Jr6xR/a/tgjrvQqSHFOfmyGi5o+onPaPpJnppCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXCfkQRhfy1z4ZiPa/vhOZOtoliTm4uXQd0SFlndwvgRgTYLJa82TZmMkKlALhKrCQlatlxaTJHq5okiMtMdsC+EpsjFKPyfhhgY4OnV3UUaHwkMzgamN6D8E328OPeD2eVYHGfCAtWGCbhNqj2WX4h23tHzsAGt81Lrqd0+jCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bomraiyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bomraiyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC20AC4CEE7;
	Mon, 13 Oct 2025 15:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369859;
	bh=z1o9Jr6xR/a/tgjrvQqSHFOfmyGi5o+onPaPpJnppCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bomraiyy1gtq2774CthHkqAy0cQXcH8vF4VfIC7b4Df9ULnc325SRuH/mXiGDCWQv
	 jPP2UA3bNY5PRTZPgiPx/zQdsoNGltona4nWvPop6zpxQOahC06X52MAlEGV57DHFc
	 rQjmvH4WhQAulvEzRfKMIYpxdwxFOTCCQ2UawtMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 394/563] wifi: ath12k: fix the fetching of combined rssi
Date: Mon, 13 Oct 2025 16:44:15 +0200
Message-ID: <20251013144425.557789671@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kang Yang <kang.yang@oss.qualcomm.com>

[ Upstream commit 7695fa71c1d50a375e54426421acbc8d457bc5a3 ]

Currently, host fetches combined rssi from rssi_comb in struct
hal_rx_phyrx_rssi_legacy_info.

rssi_comb is 8th to 15th bits of the second to last variable.
rssi_comb_ppdu is the 0th to 7th of the last variable.

When bandwidth = 20MHz, rssi_comb = rssi_comb_ppdu. But when bandwidth >
20MHz, rssi_comb < rssi_comb_ppdu because rssi_comb only includes power
of primary 20 MHz while rssi_comb_ppdu includes power of active
RUs/subchannels. So should fetch combined rssi from rssi_comb_ppdu.

Also related macro definitions are too long, rename them.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250722095934.67-4-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 8 ++++----
 drivers/net/wireless/ath/ath12k/hal_rx.h | 9 +++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index e93ede5e6197c..abd611ac37f06 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -1655,18 +1655,18 @@ ath12k_dp_mon_rx_parse_status_tlv(struct ath12k *ar,
 		const struct hal_rx_phyrx_rssi_legacy_info *rssi = tlv_data;
 
 		info[0] = __le32_to_cpu(rssi->info0);
-		info[1] = __le32_to_cpu(rssi->info1);
+		info[2] = __le32_to_cpu(rssi->info2);
 
 		/* TODO: Please note that the combined rssi will not be accurate
 		 * in MU case. Rssi in MU needs to be retrieved from
 		 * PHYRX_OTHER_RECEIVE_INFO TLV.
 		 */
 		ppdu_info->rssi_comb =
-			u32_get_bits(info[1],
-				     HAL_RX_PHYRX_RSSI_LEGACY_INFO_INFO1_RSSI_COMB);
+			u32_get_bits(info[2],
+				     HAL_RX_RSSI_LEGACY_INFO_INFO2_RSSI_COMB_PPDU);
 
 		ppdu_info->bw = u32_get_bits(info[0],
-					     HAL_RX_PHYRX_RSSI_LEGACY_INFO_INFO0_RX_BW);
+					     HAL_RX_RSSI_LEGACY_INFO_INFO0_RX_BW);
 		break;
 	}
 	case HAL_PHYRX_COMMON_USER_INFO: {
diff --git a/drivers/net/wireless/ath/ath12k/hal_rx.h b/drivers/net/wireless/ath/ath12k/hal_rx.h
index 801a5f6d3458b..d1ad7747b82c4 100644
--- a/drivers/net/wireless/ath/ath12k/hal_rx.h
+++ b/drivers/net/wireless/ath/ath12k/hal_rx.h
@@ -483,15 +483,16 @@ enum hal_rx_ul_reception_type {
 	HAL_RECEPTION_TYPE_FRAMELESS
 };
 
-#define HAL_RX_PHYRX_RSSI_LEGACY_INFO_INFO0_RECEPTION	GENMASK(3, 0)
-#define HAL_RX_PHYRX_RSSI_LEGACY_INFO_INFO0_RX_BW	GENMASK(7, 5)
-#define HAL_RX_PHYRX_RSSI_LEGACY_INFO_INFO1_RSSI_COMB	GENMASK(15, 8)
+#define HAL_RX_RSSI_LEGACY_INFO_INFO0_RECEPTION		GENMASK(3, 0)
+#define HAL_RX_RSSI_LEGACY_INFO_INFO0_RX_BW		GENMASK(7, 5)
+#define HAL_RX_RSSI_LEGACY_INFO_INFO1_RSSI_COMB		GENMASK(15, 8)
+#define HAL_RX_RSSI_LEGACY_INFO_INFO2_RSSI_COMB_PPDU	GENMASK(7, 0)
 
 struct hal_rx_phyrx_rssi_legacy_info {
 	__le32 info0;
 	__le32 rsvd0[39];
 	__le32 info1;
-	__le32 rsvd1;
+	__le32 info2;
 } __packed;
 
 #define HAL_RX_MPDU_START_INFO0_PPDU_ID			GENMASK(31, 16)
-- 
2.51.0



