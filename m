Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D4C3570D4;
	Wed,  3 Dec 2025 16:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779746; cv=none; b=kiYtM369wYUm2gIsGo0Tq1+W+qo2NzInXcHvzeRHqdrbM7zLL/5XggcSg5VCRjJnzIRHNdbAk/NLAjv2Hxz/sqvkRynwcBqD4/AJ3rvLhop6EopZYqz4xGjsaBaoOdjdXixD260X5o2EBn5nPxt6czjECflJ2HF1fiukJVN2uhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779746; c=relaxed/simple;
	bh=KYG7KpxVfl+PQ5Mm5CDfK+j9g2iS2L6QEsNmBm+KVw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0Fjll6HIyzzMVYObP7jeWIvz9dJnJG89AvnQXVZd/BcE5oMQlgVXvVpIzq3W7McPtVRomzqQ3R2HP8u8G0ykIKDpJ28Myc/4EAZzJRRfKAUWEUSMiE/t6dH0ELFuywm6L5LwaieaxeDrblhXxQbYw040EPn5+2+gFmiZBcofrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9gEGiVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9gEGiVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9239BC4CEF5;
	Wed,  3 Dec 2025 16:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779746;
	bh=KYG7KpxVfl+PQ5Mm5CDfK+j9g2iS2L6QEsNmBm+KVw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9gEGiVwBLaAwGExBKe5i8OzC2C63ioU1o2nqv26Ki80S7zVMVBP7rPrJ4f0qzCE7
	 ZH4NtAcAW1UhvPO3f5bEQqW5Bq0Qgcy0vUQvO8NkPMIlh3eq1aDwzBP4ZFSQ/StQ7A
	 J6+i9W4u7wcoh9iRFQOlgHk7IlJWcoykiG4Pgc5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abinaya Kalaiselvan <quic_akalaise@quicinc.com>,
	Maharaja Kennadyrajan <quic_mkenna@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 347/568] wifi: ath11k: Add tx ack signal support for management packets
Date: Wed,  3 Dec 2025 16:25:49 +0100
Message-ID: <20251203152453.413877704@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abinaya Kalaiselvan <quic_akalaise@quicinc.com>

[ Upstream commit 01c6c9fccbd51c1d9eab0f5794b0271b026178df ]

Add support to notify tx ack signal values for management
packets to userspace through nl80211 interface.

Advertise NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT flag
to enable this feature and it will be used for data
packets as well.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1

Signed-off-by: Abinaya Kalaiselvan <quic_akalaise@quicinc.com>
Signed-off-by: Maharaja Kennadyrajan <quic_mkenna@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221219053844.4084486-1-quic_mkenna@quicinc.com
Stable-dep-of: 9065b9687523 ("wifi: ath11k: zero init info->status in wmi_process_mgmt_tx_comp()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/hw.c  |  1 +
 drivers/net/wireless/ath/ath11k/mac.c |  5 +++++
 drivers/net/wireless/ath/ath11k/wmi.c | 27 ++++++++++++++++-----------
 drivers/net/wireless/ath/ath11k/wmi.h |  3 +++
 4 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/hw.c b/drivers/net/wireless/ath/ath11k/hw.c
index dbcc0c4035b62..332664643c7b4 100644
--- a/drivers/net/wireless/ath/ath11k/hw.c
+++ b/drivers/net/wireless/ath/ath11k/hw.c
@@ -201,6 +201,7 @@ static void ath11k_init_wmi_config_ipq8074(struct ath11k_base *ab,
 	config->twt_ap_pdev_count = ab->num_radios;
 	config->twt_ap_sta_count = 1000;
 	config->flag1 |= WMI_RSRC_CFG_FLAG1_BSS_CHANNEL_INFO_64;
+	config->flag1 |= WMI_RSRC_CFG_FLAG1_ACK_RSSI;
 }
 
 static int ath11k_hw_mac_id_to_pdev_id_ipq8074(struct ath11k_hw_params *hw,
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 8be42227dd943..4cab480f85a8d 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -9045,6 +9045,11 @@ static int __ath11k_mac_register(struct ath11k *ar)
 		goto err_free_if_combs;
 	}
 
+	if (test_bit(WMI_TLV_SERVICE_TX_DATA_MGMT_ACK_RSSI,
+		     ar->ab->wmi_ab.svc_map))
+		wiphy_ext_feature_set(ar->hw->wiphy,
+				      NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT);
+
 	ar->hw->queues = ATH11K_HW_MAX_QUEUES;
 	ar->hw->wiphy->tx_queue_len = ATH11K_QUEUE_LEN;
 	ar->hw->offchannel_tx_hw_queue = ATH11K_HW_MAX_QUEUES - 1;
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 38756ed48082c..1b58979bdfdc6 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5221,8 +5221,8 @@ static int ath11k_pull_mgmt_rx_params_tlv(struct ath11k_base *ab,
 	return 0;
 }
 
-static int wmi_process_mgmt_tx_comp(struct ath11k *ar, u32 desc_id,
-				    u32 status)
+static int wmi_process_mgmt_tx_comp(struct ath11k *ar,
+				    struct wmi_mgmt_tx_compl_event *tx_compl_param)
 {
 	struct sk_buff *msdu;
 	struct ieee80211_tx_info *info;
@@ -5230,24 +5230,29 @@ static int wmi_process_mgmt_tx_comp(struct ath11k *ar, u32 desc_id,
 	int num_mgmt;
 
 	spin_lock_bh(&ar->txmgmt_idr_lock);
-	msdu = idr_find(&ar->txmgmt_idr, desc_id);
+	msdu = idr_find(&ar->txmgmt_idr, tx_compl_param->desc_id);
 
 	if (!msdu) {
 		ath11k_warn(ar->ab, "received mgmt tx compl for invalid msdu_id: %d\n",
-			    desc_id);
+			    tx_compl_param->desc_id);
 		spin_unlock_bh(&ar->txmgmt_idr_lock);
 		return -ENOENT;
 	}
 
-	idr_remove(&ar->txmgmt_idr, desc_id);
+	idr_remove(&ar->txmgmt_idr, tx_compl_param->desc_id);
 	spin_unlock_bh(&ar->txmgmt_idr_lock);
 
 	skb_cb = ATH11K_SKB_CB(msdu);
 	dma_unmap_single(ar->ab->dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 
 	info = IEEE80211_SKB_CB(msdu);
-	if ((!(info->flags & IEEE80211_TX_CTL_NO_ACK)) && !status)
+	if ((!(info->flags & IEEE80211_TX_CTL_NO_ACK)) &&
+	    !tx_compl_param->status) {
 		info->flags |= IEEE80211_TX_STAT_ACK;
+		if (test_bit(WMI_TLV_SERVICE_TX_DATA_MGMT_ACK_RSSI,
+			     ar->ab->wmi_ab.svc_map))
+			info->status.ack_signal = tx_compl_param->ack_rssi;
+	}
 
 	ieee80211_tx_status_irqsafe(ar->hw, msdu);
 
@@ -5259,7 +5264,7 @@ static int wmi_process_mgmt_tx_comp(struct ath11k *ar, u32 desc_id,
 
 	ath11k_dbg(ar->ab, ATH11K_DBG_WMI,
 		   "wmi mgmt tx comp pending %d desc id %d\n",
-		   num_mgmt, desc_id);
+		   num_mgmt, tx_compl_param->desc_id);
 
 	if (!num_mgmt)
 		wake_up(&ar->txmgmt_empty_waitq);
@@ -5292,6 +5297,7 @@ static int ath11k_pull_mgmt_tx_compl_param_tlv(struct ath11k_base *ab,
 	param->pdev_id = ev->pdev_id;
 	param->desc_id = ev->desc_id;
 	param->status = ev->status;
+	param->ack_rssi = ev->ack_rssi;
 
 	kfree(tb);
 	return 0;
@@ -7062,13 +7068,12 @@ static void ath11k_mgmt_tx_compl_event(struct ath11k_base *ab, struct sk_buff *s
 		goto exit;
 	}
 
-	wmi_process_mgmt_tx_comp(ar, tx_compl_param.desc_id,
-				 tx_compl_param.status);
+	wmi_process_mgmt_tx_comp(ar, &tx_compl_param);
 
 	ath11k_dbg(ab, ATH11K_DBG_MGMT,
-		   "mgmt tx compl ev pdev_id %d, desc_id %d, status %d",
+		   "mgmt tx compl ev pdev_id %d, desc_id %d, status %d ack_rssi %d",
 		   tx_compl_param.pdev_id, tx_compl_param.desc_id,
-		   tx_compl_param.status);
+		   tx_compl_param.status, tx_compl_param.ack_rssi);
 
 exit:
 	rcu_read_unlock();
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index 8f2c07d70a4a2..31d14e15ebc1d 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -2309,6 +2309,7 @@ struct wmi_init_cmd {
 } __packed;
 
 #define WMI_RSRC_CFG_FLAG1_BSS_CHANNEL_INFO_64 BIT(5)
+#define WMI_RSRC_CFG_FLAG1_ACK_RSSI BIT(18)
 
 struct wmi_resource_config {
 	u32 tlv_header;
@@ -4541,6 +4542,8 @@ struct wmi_mgmt_tx_compl_event {
 	u32 desc_id;
 	u32 status;
 	u32 pdev_id;
+	u32 ppdu_id;
+	u32 ack_rssi;
 } __packed;
 
 struct wmi_scan_event {
-- 
2.51.0



