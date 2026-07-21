Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E732C46D093;
	Tue, 21 Jul 2026 17:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656193; cv=none; b=Hv6ox4RZI90QdUyKwlOIRg0zL+6GqVPBPuurqbNVG9jMb6UGqY4UkeM+1c09B/lfgAq9xqwyO1ceX23458/KvZEtq6TKQlOEQm6hC+1MLEtoM1/b4QpVEth4PrEvKfrmRH9ghWZJ6032P7Gwl/r4jQveyHGHMiJvpGmiQWuiC9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656193; c=relaxed/simple;
	bh=C25thbk2yzaRKQ6xPgNjSSf9Un+RXkedeujG0ggNjdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+pZLwXdAFRpzeD8DuWZc3APhebj2+MgASsEbrRdEGSQFAVY4RmzUvaIkGxHdl1N76kwPFBAk22AfckX3NdTHJ/aUEMAyVxglEazL58kcux+I+kIExTL4cMGbWx4qTjNGHSfgUxgBBLSoKi/j7GWu72Lik9QOFsS/NTPLsJtLxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1D9LB04r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1D9LB04r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DF31F000E9;
	Tue, 21 Jul 2026 17:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656191;
	bh=Fc/53r8JXTcRZvzgaALaPBIheMLovM6PnXOI61wQYP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1D9LB04rRZ/JS22ynGHb+zm1ljKs/i2YC6qQqpquL36p+ATSICPzGnTmp8Qd+RU5Y
	 XGpE+TUSGD2qmA3e6QPbfj44qBG8iuYJDh38+6qGTVY/n7uODHmJfj4BwVMHsBVH9f
	 xp32Ozx751dq11aoIQZC7fNz6s0htqCjQYJ7kMQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kwan Lai Chee Hou <laicheehou9@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0295/1611] wifi: ath12k: fix incorrect HT/VHT/HE/EHT MCS reporting in monitor mode
Date: Tue, 21 Jul 2026 17:06:51 +0200
Message-ID: <20260721152521.704724783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 009c495021489d..4aaaccca9412d8 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -1905,13 +1905,14 @@ ath12k_dp_mon_fill_rx_rate(struct ath12k *ar,
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
 			sband = &ar->mac.sbands[rx_status->band];
@@ -2254,13 +2255,10 @@ static void ath12k_dp_mon_update_radiotap(struct ath12k *ar,
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
 		rxs->encoding = RX_ENC_LEGACY;
 		sband = &ar->mac.sbands[rxs->band];
-- 
2.53.0



