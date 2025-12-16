Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3583341AD6;
	Tue, 16 Dec 2025 11:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884108; cv=none; b=g4CEgYYAYsutGx/+vW7CIf3d7SCLFAkuJ2CdfeGY9c4zu+ykYnMKVClP8qetCxy0ZeyylYSd3aaL/hjCKByd+PghCXFUoZJlK7BYqPgO0heF9zLBVYpeBAhsMY4MC40iZ9cRKNBdAomgkoVQxVatoI0fmHSLlJgOvCmkKpCPMNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884108; c=relaxed/simple;
	bh=mGwJ3hudlrKSqQqL9biwPMdZG9A4wbYelk3gsUlIvgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEDTgeF623BMqAk56DZRHLzxMMDF+9vVqU1sitSsZ/bojw6PS8Q8I/Vy/k93A7rVpfR99MYqliOIIASTFdoEUC5L1WgoRZMUuGteghFTldge0pNxFBJDFuLMFpZP+9c/4ezKw1AlgBIUyCDHLiD+NhUXOeHLEDJH0i07BHaowhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQ8ppx9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQ8ppx9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AD3C16AAE;
	Tue, 16 Dec 2025 11:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884107;
	bh=mGwJ3hudlrKSqQqL9biwPMdZG9A4wbYelk3gsUlIvgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQ8ppx9PtzRs/d4BisnW1lAdDrcvahcmClLnWIu0IZKCvQWx29YJAc4xOgO0PIubf
	 Ezj846ETqb2iVsBlVIE6+dkIfhA8FkAvR2qMMJ5gAwvvLJ5MvtHAdSs64ipGxfuJAr
	 h9EA3KP5CYfxRy6+tP/ApL1mlchaBd7LeMAKHRT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/354] wifi: ath11k: fix VHT MCS assignment
Date: Tue, 16 Dec 2025 12:10:33 +0100
Message-ID: <20251216111323.318489556@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 47d0cd6bccb4604192633cc8d29511e85d811fc0 ]

While associating, firmware needs to know peer's receive capability to
calculate its own VHT transmit MCS, currently host sends this information
to firmware via mcs->rx_mcs_set field, this is wrong as firmware actually
takes it from mcs->tx_mcs_set field. Till now there is no failure seen
due to this, most likely because almost all peers are advertising the
same capability for both transmit and receive. Swap the assignment to
fix it.

Besides, rate control mask is meant to limit our own transmit MCS, hence
need to go via mcs->tx_mcs_set field. With the aforementioned swapping
done, change is needed as well to apply it to the peer's receive
capability rather than transmit capability.

Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.41
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20251017-ath11k-mcs-assignment-v1-1-da40825c1783@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c |  4 ++--
 drivers/net/wireless/ath/ath11k/wmi.c | 13 ++++++++-----
 drivers/net/wireless/ath/ath11k/wmi.h |  2 ++
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 419c9497800af..9521fcb2c11ce 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2225,9 +2225,9 @@ static void ath11k_peer_assoc_h_vht(struct ath11k *ar,
 	arg->peer_nss = min(sta->deflink.rx_nss, max_nss);
 	arg->rx_max_rate = __le16_to_cpu(vht_cap->vht_mcs.rx_highest);
 	arg->rx_mcs_set = __le16_to_cpu(vht_cap->vht_mcs.rx_mcs_map);
+	arg->rx_mcs_set = ath11k_peer_assoc_h_vht_limit(arg->rx_mcs_set, vht_mcs_mask);
 	arg->tx_max_rate = __le16_to_cpu(vht_cap->vht_mcs.tx_highest);
-	arg->tx_mcs_set = ath11k_peer_assoc_h_vht_limit(
-		__le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map), vht_mcs_mask);
+	arg->tx_mcs_set = __le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map);
 
 	/* In IPQ8074 platform, VHT mcs rate 10 and 11 is enabled by default.
 	 * VHT mcs rate 10 and 11 is not suppoerted in 11ac standard.
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index bfca9d3639810..6f1fd7d661a89 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 #include <linux/skbuff.h>
 #include <linux/ctype.h>
@@ -2061,10 +2061,13 @@ int ath11k_wmi_send_peer_assoc_cmd(struct ath11k *ar,
 	cmd->peer_bw_rxnss_override |= param->peer_bw_rxnss_override;
 
 	if (param->vht_capable) {
-		mcs->rx_max_rate = param->rx_max_rate;
-		mcs->rx_mcs_set = param->rx_mcs_set;
-		mcs->tx_max_rate = param->tx_max_rate;
-		mcs->tx_mcs_set = param->tx_mcs_set;
+		/* firmware interprets mcs->tx_mcs_set field as peer's
+		 * RX capability
+		 */
+		mcs->tx_max_rate = param->rx_max_rate;
+		mcs->tx_mcs_set = param->rx_mcs_set;
+		mcs->rx_max_rate = param->tx_max_rate;
+		mcs->rx_mcs_set = param->tx_mcs_set;
 	}
 
 	/* HE Rates */
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index 9fcffaa2f383c..6e9354297e71d 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -4133,8 +4133,10 @@ struct wmi_rate_set {
 struct wmi_vht_rate_set {
 	u32 tlv_header;
 	u32 rx_max_rate;
+	/* MCS at which the peer can transmit */
 	u32 rx_mcs_set;
 	u32 tx_max_rate;
+	/* MCS at which the peer can receive */
 	u32 tx_mcs_set;
 	u32 tx_max_mcs_nss;
 } __packed;
-- 
2.51.0



