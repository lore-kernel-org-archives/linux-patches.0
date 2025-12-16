Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B0E34B412;
	Tue, 16 Dec 2025 11:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885245; cv=none; b=Uoj0NfrMrpbCwGBGUUBoCdSjOuPLJkwhuS7kp52kxcjRSyHsQRmj85HkvwXu7x2OFxbEMEbB09ljjlBZdB92dUJOAtE9b63wfWN5Hy2GB455RnLWtijPqxuBoXzcaMYLlBZskXA9z3qjcz0pJjD4IE2a8bzpzg+CZf20N0fuEso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885245; c=relaxed/simple;
	bh=YOEIRfhVX6hx2/bjRp7ovjdvm3BWrCMe1yVoKL1EAgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzz4cMtr7oYis+i+WyCXpPT9rfxywyQkqbqDIVvz91xbJNxMACWlAJQ25M/DT5TiVrAr/iN8HkyzZ9WVOCJoo7vf2uwIRDDbVs7ecRs3FwcOj/lzco8Jx9xI12zbABq/S2Cyp7Q+eCMYKGoBUOGRwJKlcIT3CJmxb7BHF7hD8mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFyAz2WS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFyAz2WS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254D1C4CEF5;
	Tue, 16 Dec 2025 11:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885245;
	bh=YOEIRfhVX6hx2/bjRp7ovjdvm3BWrCMe1yVoKL1EAgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFyAz2WS7CiX1t5/ur2bovsqU9Lg28ubxyn1wTpguy9qD7M43oWeNw58em+MxVJOt
	 mRh+lh8lh+aYzuUj47biYBBhkoVP3UnRvjR0AJhc95BLnysdJlPZf7uQvdtpMx0/43
	 zcxcknjC7vXQhTaA7sydJWhHypX/mWdgXehMPuZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 081/507] wifi: ath11k: fix VHT MCS assignment
Date: Tue, 16 Dec 2025 12:08:42 +0100
Message-ID: <20251216111348.474778577@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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
index 0e41b5a91d66d..49c639d73d58d 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2235,9 +2235,9 @@ static void ath11k_peer_assoc_h_vht(struct ath11k *ar,
 	arg->peer_nss = min(sta->deflink.rx_nss, max_nss);
 	arg->rx_max_rate = __le16_to_cpu(vht_cap->vht_mcs.rx_highest);
 	arg->rx_mcs_set = __le16_to_cpu(vht_cap->vht_mcs.rx_mcs_map);
+	arg->rx_mcs_set = ath11k_peer_assoc_h_vht_limit(arg->rx_mcs_set, vht_mcs_mask);
 	arg->tx_max_rate = __le16_to_cpu(vht_cap->vht_mcs.tx_highest);
-	arg->tx_mcs_set = ath11k_peer_assoc_h_vht_limit(
-		__le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map), vht_mcs_mask);
+	arg->tx_mcs_set = __le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map);
 
 	/* In IPQ8074 platform, VHT mcs rate 10 and 11 is enabled by default.
 	 * VHT mcs rate 10 and 11 is not supported in 11ac standard.
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index e3b444333deed..649839d243293 100644
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



