Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B411A617E;
	Tue, 30 Jul 2024 16:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356474; cv=none; b=UaV6zWbjFJ/xEC9xXYi5fkT81pUpkQq79aeQv7ZkQEIbN0l5JJnLPdh3FtIbiRengIf3FhWHulso4bA9q6UMkMVPvWcLAe7xnPImeUrdwCWp60Ev+0dA5llCHN6HZgVpf4Gqf461HBpye3wyfreP21DhGZhevKVRRPUBiCGU8PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356474; c=relaxed/simple;
	bh=PEHzIsz9fjsDI2ETDOViTB5fUleU+9l0sJINEg0X16o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSBCEKNivrrNyHWZUd4xQuNfzsIyn4u6vjJGRjrQfUeaMqYMdZ088Q5XXvQSJLhCv4lcSocMaKEiZnmSO7Y7LO/hGFiFa9OmelLAhkoJtfFxoLrS0gBkkajaTpNNu+NXMikRm/245TFTB+pgLwdDU8nzkNviUkmymbkdrodwZMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEHEwoXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEHEwoXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40180C32782;
	Tue, 30 Jul 2024 16:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356474;
	bh=PEHzIsz9fjsDI2ETDOViTB5fUleU+9l0sJINEg0X16o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEHEwoXCPHFBuDCmFuAGkt2K2eLFjy2xTyue0L9sdEDyBeF7VWH1pEWykCUHYY3qM
	 w+rZy53Q91bZOmlT14N0PVJQK6g8xiD3o2tcTc58FGzrudYL7+6WuB6FCJ82Bq2kSE
	 eC8D8mEKFFZxumYtyUnqqVonhU9grfczepmw3V9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nithyanantham Paramasivam <quic_nithp@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 153/809] wifi: ath12k: Fix tx completion ring (WBM2SW) setup failure
Date: Tue, 30 Jul 2024 17:40:29 +0200
Message-ID: <20240730151730.647788934@linuxfoundation.org>
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

From: Nithyanantham Paramasivam <quic_nithp@quicinc.com>

[ Upstream commit 0ce9ab2785e4e9ca0752390d8e5ab65bd08f0e78 ]

We observe intermittent ping failures from the access point (AP) to
station (STA) in any mode (AP-STA or Mesh) configured. Specifically,
the transmission completion status is not received at tx completion
ring id 4 (WBM2SW ring4) for the packets transmitted via TCL DATA
ring id 3. This prevents freeing up tx descriptors and leads
to buffer exhaustion.

Currently, during initialization of the WBM2SW ring, we are directly
mapping the ring number to the ring mask to obtain the ring mask
group index. This approach is causing setup failures for WBM2SW
ring 4. Similarly, during runtime, when receiving incoming
transmission completion status, the validation of the ring number by
mapping the interrupted ring mask. This is resulting in
validation failure. Thereby preventing entry into the completion
handler ath12k_dp_tx_completion_handler().

The existing design assumed that the ring numbers would always be
sequential and could be directly mapped with the ring mask. However,
this assumption does not hold true for WBM2SW ring 4. Therefore,
modify the design such that, instead of mapping the ring number,
the ring ID is mapped with the ring mask.

According to this design:

1. During initialization of the WBM2SW ring, mapping the ring ID
to the ring mask will ensure obtaining the correct ring mask group
ID.

2. During runtime, validating the interrupted ring mask group ID
within the transmission completion group is sufficient. This
approach allows the ring ID to be derived from the interrupted ring
mask and enables entry into the completion handler.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Nithyanantham Paramasivam <quic_nithp@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240510070427.206152-1-quic_nithp@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.c | 18 +++++++++++++-----
 drivers/net/wireless/ath/ath12k/hw.c |  2 +-
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.c b/drivers/net/wireless/ath/ath12k/dp.c
index 7843c76a82c17..90476f38e8d46 100644
--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -132,7 +132,9 @@ static int ath12k_dp_srng_find_ring_in_mask(int ring_num, const u8 *grp_mask)
 static int ath12k_dp_srng_calculate_msi_group(struct ath12k_base *ab,
 					      enum hal_ring_type type, int ring_num)
 {
+	const struct ath12k_hal_tcl_to_wbm_rbm_map *map;
 	const u8 *grp_mask;
+	int i;
 
 	switch (type) {
 	case HAL_WBM2SW_RELEASE:
@@ -140,6 +142,14 @@ static int ath12k_dp_srng_calculate_msi_group(struct ath12k_base *ab,
 			grp_mask = &ab->hw_params->ring_mask->rx_wbm_rel[0];
 			ring_num = 0;
 		} else {
+			map = ab->hw_params->hal_ops->tcl_to_wbm_rbm_map;
+			for (i = 0; i < ab->hw_params->max_tx_ring; i++) {
+				if (ring_num == map[i].wbm_ring_num) {
+					ring_num = i;
+					break;
+				}
+			}
+
 			grp_mask = &ab->hw_params->ring_mask->tx[0];
 		}
 		break;
@@ -881,11 +891,9 @@ int ath12k_dp_service_srng(struct ath12k_base *ab,
 	enum dp_monitor_mode monitor_mode;
 	u8 ring_mask;
 
-	while (i < ab->hw_params->max_tx_ring) {
-		if (ab->hw_params->ring_mask->tx[grp_id] &
-			BIT(ab->hw_params->hal_ops->tcl_to_wbm_rbm_map[i].wbm_ring_num))
-			ath12k_dp_tx_completion_handler(ab, i);
-		i++;
+	if (ab->hw_params->ring_mask->tx[grp_id]) {
+		i = fls(ab->hw_params->ring_mask->tx[grp_id]) - 1;
+		ath12k_dp_tx_completion_handler(ab, i);
 	}
 
 	if (ab->hw_params->ring_mask->rx_err[grp_id]) {
diff --git a/drivers/net/wireless/ath/ath12k/hw.c b/drivers/net/wireless/ath/ath12k/hw.c
index f4c8270158215..5ed06c0d90e2b 100644
--- a/drivers/net/wireless/ath/ath12k/hw.c
+++ b/drivers/net/wireless/ath/ath12k/hw.c
@@ -580,8 +580,8 @@ static const struct ath12k_hw_ring_mask ath12k_hw_ring_mask_qcn9274 = {
 static const struct ath12k_hw_ring_mask ath12k_hw_ring_mask_wcn7850 = {
 	.tx  = {
 		ATH12K_TX_RING_MASK_0,
+		ATH12K_TX_RING_MASK_1,
 		ATH12K_TX_RING_MASK_2,
-		ATH12K_TX_RING_MASK_4,
 	},
 	.rx_mon_dest = {
 	},
-- 
2.43.0



