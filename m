Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FDB1E9B0D;
	Mon, 13 Oct 2025 15:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369865; cv=none; b=O6Skwd6l7/q6Wp/cPkUZuJOWX5unmCvA/0xpcRGMSGtPWAuq7GZC2oVYavfoP5URDPxJ1SMlPCjOil9LAh6nTGczxENdba8h4YWydpU+Uqd9ppDIJmlBjVTcSHi+qqRFolmdfJvZwsY6R2YFKb+Jnrp1Cw6Rkz9cX5jyFgDWYjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369865; c=relaxed/simple;
	bh=nzW55T/pVpg+30YMS+y+GAAiLqAdXJ2R6xLt7sfBQAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmM8DUHjydIN2LBc4H8WiKZs3kr0OzKJuU72qG7zSn8KHITL+g0z9yfk90gkBy1Vfr6S7LfxhCQ/67M5tEg33FbtwNnUtp4C4YUd5XJ6JLfhEeOJaPqarB185tcnNCXi7p/zNSTe5F6MkFZdJuzH/Jz9q1qMsI7dGOq76o/TBwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuximC+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuximC+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7702AC4CEE7;
	Mon, 13 Oct 2025 15:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369864;
	bh=nzW55T/pVpg+30YMS+y+GAAiLqAdXJ2R6xLt7sfBQAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuximC+RFeLvwHgmi0YQYgd70ik5F1tNgmmswhTQwEMscdfdOFoJng79ipkp7iQzV
	 nQPAYX+SVYSQZgRhVlgUNAsXl/wZ3j4JHzJP/j1CIrZfvl2owoUFklTWN/nO0Z2aHS
	 KpcN9RLe1zk9byknwNMwFDW67UsE7BakjXpB5ar0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriram R <quic_srirrama@quicinc.com>,
	Vinith Kumar R <quic_vinithku@quicinc.com>,
	Aishwarya R <aishwarya.r@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 395/563] wifi: ath12k: Add fallback for invalid channel number in PHY metadata
Date: Mon, 13 Oct 2025 16:44:16 +0200
Message-ID: <20251013144425.593893341@linuxfoundation.org>
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

From: Sriram R <quic_srirrama@quicinc.com>

[ Upstream commit 26f8fc0b24fd1a9dba1000bc9b5f2b199b7775a0 ]

Currently, ath12k_dp_rx_h_ppdu() determines the band and frequency
based on the channel number and center frequency from the RX descriptor's
PHY metadata. However, in rare cases, it is observed that frequency
retrieved from the metadata may be invalid or unexpected especially for
6 GHz frames.
This can result in a NULL sband, which prevents proper frequency assignment
in rx_status and potentially leading to incorrect RX packet classification.

To fix this potential issue, add a fallback mechanism that uses
ar->rx_channel to populate the band and frequency when the derived
sband is invalid or missing.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Sriram R <quic_srirrama@quicinc.com>
Co-developed-by: Vinith Kumar R <quic_vinithku@quicinc.com>
Signed-off-by: Vinith Kumar R <quic_vinithku@quicinc.com>
Signed-off-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250723190651.699828-1-aishwarya.r@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 8ab91273592c8..adb0cfe109e67 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -2533,6 +2533,8 @@ void ath12k_dp_rx_h_ppdu(struct ath12k *ar, struct ath12k_dp_rx_info *rx_info)
 	channel_num = meta_data;
 	center_freq = meta_data >> 16;
 
+	rx_status->band = NUM_NL80211_BANDS;
+
 	if (center_freq >= ATH12K_MIN_6GHZ_FREQ &&
 	    center_freq <= ATH12K_MAX_6GHZ_FREQ) {
 		rx_status->band = NL80211_BAND_6GHZ;
@@ -2541,21 +2543,33 @@ void ath12k_dp_rx_h_ppdu(struct ath12k *ar, struct ath12k_dp_rx_info *rx_info)
 		rx_status->band = NL80211_BAND_2GHZ;
 	} else if (channel_num >= 36 && channel_num <= 173) {
 		rx_status->band = NL80211_BAND_5GHZ;
-	} else {
+	}
+
+	if (unlikely(rx_status->band == NUM_NL80211_BANDS ||
+		     !ath12k_ar_to_hw(ar)->wiphy->bands[rx_status->band])) {
+		ath12k_warn(ar->ab, "sband is NULL for status band %d channel_num %d center_freq %d pdev_id %d\n",
+			    rx_status->band, channel_num, center_freq, ar->pdev_idx);
+
 		spin_lock_bh(&ar->data_lock);
 		channel = ar->rx_channel;
 		if (channel) {
 			rx_status->band = channel->band;
 			channel_num =
 				ieee80211_frequency_to_channel(channel->center_freq);
+			rx_status->freq = ieee80211_channel_to_frequency(channel_num,
+									 rx_status->band);
+		} else {
+			ath12k_err(ar->ab, "unable to determine channel, band for rx packet");
 		}
 		spin_unlock_bh(&ar->data_lock);
+		goto h_rate;
 	}
 
 	if (rx_status->band != NL80211_BAND_6GHZ)
 		rx_status->freq = ieee80211_channel_to_frequency(channel_num,
 								 rx_status->band);
 
+h_rate:
 	ath12k_dp_rx_h_rate(ar, rx_info);
 }
 
-- 
2.51.0



