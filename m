Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2BA39EF16;
	Tue, 21 Jul 2026 15:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649014; cv=none; b=TCu3eJa76o8lRFCf8RCRIir3cxOc3smjBOfMDNM6Dy5b69rT0/wBNh8d7bXEBn3B81DsWcw60p9YJ8XM7ZFmYLN6d7/JXl8/nERSQOTcb/30WPz2++U/Xa/5kUfF5XbnzDrxEj9OJPpYqg8icSCA72kKDSXNdDx4+rDBItX5inM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649014; c=relaxed/simple;
	bh=kQG7Bwv0AeaO+orBNmvE6h5j7pBplezTp0XCBuXYkjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFff8+5esE6maKk9fXRktMlQbS9FhlSoA32uZxfTYXDye6ER4xfx4zRvWJkehY2EUs7AMFSVcYHSatoeIf2XOp+q6gOc8Fgsb0uTtUn4p934YJseCKE0vKbl5aoTz4UIfi7IANmbdF63DN4wpqlYEsNlJ/EwRfErTlXmAQyDWNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsbyPh2V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsbyPh2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEAB1F00A3D;
	Tue, 21 Jul 2026 15:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649012;
	bh=dJ+XxV+d8n3LFhnqYj0Fy7bIWXgRFcSxcAnUu3Ei6WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsbyPh2V8HopZ6lGLQsLvfE4gUGU2ohpwOvuVMNagOnsNuFf1zYvyt8l5tT3uyJyd
	 77FoqOWFh4KS12I8SVeeTnLZJB4vIaz2TR6Vl0DZOl9mM8axbL8+7xenSaKY+XkT6n
	 TxoufR09l9tsolzDWvsAX6jdFNnXk2hKYqdrfeLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kwan Lai Chee Hou <laicheehou9@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0418/2077] wifi: ath12k: fix incorrect HT/VHT/HE/EHT MCS reporting in monitor mode
Date: Tue, 21 Jul 2026 17:01:31 +0200
Message-ID: <20260721152602.596553372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kwan Lai Chee Hou <laicheehou9@gmail.com>

[ Upstream commit 10085a654a4c2331d5f0cdc20bfc839a49fbb886 ]

In monitor mode, the driver incorrectly assigns the legacy rate
to the rate_idx field of the radiotap header for HT/VHT/HE/EHT
frames, ignoring the actual MCS value parsed from the hardware.

This causes packet analyzers (like Wireshark) to display incorrect
MCS values (e.g., legacy base rates instead of the true MCS).

Fix this by assigning ppdu_info->mcs as the default rate_mcs
in ath12k_dp_mon_fill_rx_rate(), and remove rate_idx assignments in
ath12k_dp_mon_update_radiotap() to preserve
the previously calculated MCS values (including the HT NSS offset).

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ

Fixes: 5393dcb45209 ("wifi: ath12k: change the status update in the monitor Rx")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220864
Signed-off-by: Kwan Lai Chee Hou <laicheehou9@gmail.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260507015336.14636-1-laicheehou9@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 737287a9aa4629..44c5cff75f1695 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -115,13 +115,14 @@ ath12k_dp_mon_fill_rx_rate(struct ath12k_pdev_dp *dp_pdev,
 	bool is_cck;
 
 	pkt_type = ppdu_info->preamble_type;
-	rate_mcs = ppdu_info->rate;
+	rate_mcs = ppdu_info->mcs;
 	nss = ppdu_info->nss;
 	sgi = ppdu_info->gi;
 
 	switch (pkt_type) {
 	case RX_MSDU_START_PKT_TYPE_11A:
 	case RX_MSDU_START_PKT_TYPE_11B:
+		rate_mcs = ppdu_info->rate;
 		is_cck = (pkt_type == RX_MSDU_START_PKT_TYPE_11B);
 		if (rx_status->band < NUM_NL80211_BANDS) {
 			struct ath12k *ar = ath12k_pdev_dp_to_ar(dp_pdev);
@@ -471,13 +472,10 @@ void ath12k_dp_mon_update_radiotap(struct ath12k_pdev_dp *dp_pdev,
 		rxs->encoding = RX_ENC_HE;
 		ptr = skb_push(mon_skb, sizeof(struct ieee80211_radiotap_he));
 		ath12k_dp_mon_rx_update_radiotap_he(ppduinfo, ptr);
-		rxs->rate_idx = ppduinfo->rate;
 	} else if (ppduinfo->vht_flags) {
 		rxs->encoding = RX_ENC_VHT;
-		rxs->rate_idx = ppduinfo->rate;
 	} else if (ppduinfo->ht_flags) {
 		rxs->encoding = RX_ENC_HT;
-		rxs->rate_idx = ppduinfo->rate;
 	} else {
 		struct ath12k *ar;
 
-- 
2.53.0



