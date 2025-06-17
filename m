Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036DF2DFF1B;
	Tue, 17 Jun 2025 16:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176200; cv=none; b=bqLe9dii2Qn928ftClHTpkBbI+HiMtzrrf0NZCoFaGCgMH3Izqj4jU3W2q7w2wunvOs9Peh7NxS+b6DFA3dAIPGGlTV4jItppCBYKKsQOwYzo/8Ew+S71Yr8pNKMdgRW+sd0aM8A8qiO2Amrmsegkxx8zsZvkU86Rx2ehVZ8eAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176200; c=relaxed/simple;
	bh=WQpOpqiwbHrLBf/3tR/Ad1ZfO+qnR8Rev63TPFOgi8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkrjNwM2EPu9WyfZmn0l5+KdvjtS0aG4AAILAel/BkuysM8bzbEsaDKeZhNk6P2GCRfHB3Suir9B+P6GiCSTrdVvljJrCIJiKispwBjBUPNBUpn3Ef9FiizPkz8vJqS1pf6SvsKSs9w3N0Cwn1fMipTtQ+c98NsYrCzRVSgOXCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ruQ7Rrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ruQ7Rrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674A1C4CEE3;
	Tue, 17 Jun 2025 16:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176199;
	bh=WQpOpqiwbHrLBf/3tR/Ad1ZfO+qnR8Rev63TPFOgi8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ruQ7RrpAJzW7KS/pf8DfNizh2G8kX4eMwRxN0qDpNQxhsxTxVkrQte69FATDQsxZ
	 etxAHcoiDGv6p/rrAHkMoHQwO18PTsSosAztMzV6bC2TfBsWl5pXup4n/TAVXju8Gg
	 YcEJiWZ1S25Ev0qwegyTbd/84W9M/gGOS4fyffDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <praneesh.p@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 164/780] wifi: ath12k: Fix memory leak during vdev_id mismatch
Date: Tue, 17 Jun 2025 17:17:52 +0200
Message-ID: <20250617152458.164798055@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: P Praneesh <praneesh.p@oss.qualcomm.com>

[ Upstream commit 75ec94db880b1e4b4f9182885d60db0db6e2ee56 ]

Currently driver enables vdev_id check as part of the bank configuration
in ath12k_dp_tx_get_vdev_bank_config(). This check ensures that the vdev_id
configured in the bank register aligns with the vdev_id in the packet's
address search table within the firmware. If there is a mismatch, the
firmware forwards the packet with the HTT status
HAL_WBM_REL_HTT_TX_COMP_STATUS_VDEVID_MISMATCH. Since driver does not
handle this vdev_id mismatch HTT status, the corresponding buffers are not
freed properly, causing a memory leak. Fix this issue by adding handling to
free the buffers when a vdev_id mismatch HTT status is encountered.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: P Praneesh <praneesh.p@oss.qualcomm.com>
Link: https://patch.msgid.link/20250402174032.2651221-1-praneesh.p@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c    | 1 +
 drivers/net/wireless/ath/ath12k/hal_desc.h | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index ced232bf4aed0..1e2788df476c2 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -585,6 +585,7 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_base *ab,
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_TTL:
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_REINJ:
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_INSPECT:
+	case HAL_WBM_REL_HTT_TX_COMP_STATUS_VDEVID_MISMATCH:
 		ath12k_dp_tx_free_txbuf(ab, msdu, mac_id, tx_ring);
 		break;
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_MEC_NOTIFY:
diff --git a/drivers/net/wireless/ath/ath12k/hal_desc.h b/drivers/net/wireless/ath/ath12k/hal_desc.h
index 3e8983b85de86..63d279fab3224 100644
--- a/drivers/net/wireless/ath/ath12k/hal_desc.h
+++ b/drivers/net/wireless/ath/ath12k/hal_desc.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: BSD-3-Clause-Clear */
 /*
  * Copyright (c) 2018-2021 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2022, 2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2022, 2024-2025 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 #include "core.h"
 
@@ -1298,6 +1298,7 @@ enum hal_wbm_htt_tx_comp_status {
 	HAL_WBM_REL_HTT_TX_COMP_STATUS_REINJ,
 	HAL_WBM_REL_HTT_TX_COMP_STATUS_INSPECT,
 	HAL_WBM_REL_HTT_TX_COMP_STATUS_MEC_NOTIFY,
+	HAL_WBM_REL_HTT_TX_COMP_STATUS_VDEVID_MISMATCH,
 	HAL_WBM_REL_HTT_TX_COMP_STATUS_MAX,
 };
 
-- 
2.39.5



