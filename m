Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08E03624B0;
	Wed,  8 Apr 2026 18:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673745; cv=none; b=mOcPja20+GKsGvG2SyA3xmrDGgxq7+04jyzD0gPXpejTiJuwjD/jz4xSOyq8lqitgvP4LJAVf1IqRdtmFqvFDcX6tteueJujogfdF8xi3pvCP33IA/McAKqqDCsKg68uce5p+Q839kw3SjRJxldci/ilKJqFhvAivAOHwZqtHmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673745; c=relaxed/simple;
	bh=/sOa9BpRRMy91Q4ZSGPIyR4UKs8DeGOYo0LwRU6JkTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQ61qWNHiBSAn4yKz2XOcwtFjp5B58sc3Tcsrh1DzClFZtdftY7oYeZ5eWZL1mhwKPpLzMaUXwIFkC8rl9aNBV9EGffT0T82SuMhXqJF7J1HMWv7CvRk3TgRsqay5WLvbmYv7r984p7mVLp9ndU1IzEdQOQ8zBYzn498zkCoUzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDtNWSxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDtNWSxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41898C19421;
	Wed,  8 Apr 2026 18:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673745;
	bh=/sOa9BpRRMy91Q4ZSGPIyR4UKs8DeGOYo0LwRU6JkTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDtNWSxWDI0CsmQJrZBYKu+e30SwRrizxw6EWMM5GjffYp10a7KixUqydDLtFTIYQ
	 ac0TmiOX4qOH9Gwy9cMN1AKVAut3rl3ArftmczLyHwwd4r+x2h+2Ok4Oyvb0LLYap4
	 3h1VsPDTn95fdp0oVNKmYqm3U0GR5fTCmTfIrxQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/242] wifi: ath11k: Pass the correct value of each TID during a stop AMPDU session
Date: Wed,  8 Apr 2026 20:01:21 +0200
Message-ID: <20260408175928.609464962@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>

[ Upstream commit e225b36f83d7926c1f2035923bb0359d851fdb73 ]

During ongoing traffic, a request to stop an AMPDU session
for one TID could incorrectly affect other active sessions.
This can happen because an incorrect TID reference would be
passed when updating the BA session state, causing the wrong
session to be stopped. As a result, the affected session would
be reduced to a minimal BA size, leading to a noticeable
throughput degradation.

Fix this issue by passing the correct argument from
ath11k_dp_rx_ampdu_stop() to ath11k_peer_rx_tid_reo_update()
during a stop AMPDU session. Instead of passing peer->tx_tid, which
is the base address of the array, corresponding to TID 0; pass
the value of &peer->rx_tid[params->tid], where the different TID numbers
are accounted for.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f2895 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260319065608.2408179-1-reshma.rajkumar@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index ff97c2649ce52..e3eabd9e223aa 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
 #include <linux/ieee80211.h>
@@ -1110,9 +1110,8 @@ int ath11k_dp_rx_ampdu_stop(struct ath11k *ar,
 	struct ath11k_base *ab = ar->ab;
 	struct ath11k_peer *peer;
 	struct ath11k_sta *arsta = ath11k_sta_to_arsta(params->sta);
+	struct dp_rx_tid *rx_tid;
 	int vdev_id = arsta->arvif->vdev_id;
-	dma_addr_t paddr;
-	bool active;
 	int ret;
 
 	spin_lock_bh(&ab->base_lock);
@@ -1124,15 +1123,14 @@ int ath11k_dp_rx_ampdu_stop(struct ath11k *ar,
 		return -ENOENT;
 	}
 
-	paddr = peer->rx_tid[params->tid].paddr;
-	active = peer->rx_tid[params->tid].active;
+	rx_tid = &peer->rx_tid[params->tid];
 
-	if (!active) {
+	if (!rx_tid->active) {
 		spin_unlock_bh(&ab->base_lock);
 		return 0;
 	}
 
-	ret = ath11k_peer_rx_tid_reo_update(ar, peer, peer->rx_tid, 1, 0, false);
+	ret = ath11k_peer_rx_tid_reo_update(ar, peer, rx_tid, 1, 0, false);
 	spin_unlock_bh(&ab->base_lock);
 	if (ret) {
 		ath11k_warn(ab, "failed to update reo for rx tid %d: %d\n",
@@ -1141,7 +1139,8 @@ int ath11k_dp_rx_ampdu_stop(struct ath11k *ar,
 	}
 
 	ret = ath11k_wmi_peer_rx_reorder_queue_setup(ar, vdev_id,
-						     params->sta->addr, paddr,
+						     params->sta->addr,
+						     rx_tid->paddr,
 						     params->tid, 1, 1);
 	if (ret)
 		ath11k_warn(ab, "failed to send wmi to delete rx tid %d\n",
-- 
2.53.0



