Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA1034D903;
	Tue, 16 Dec 2025 11:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885583; cv=none; b=ZeyOJvTOMEnrNpOCu4MIB0AeWGS5marYTiB8O7YV9OEPp1Ip7BOBhuJ3f7SKS0YtBQ0ffWEVejYCjBNYvjcYcPznob+WVWP9Xu6cyuk2S9Xx2KyRor9Q1ZC0Xbt0bHZ3SGN+tr1GUfWs8CSZP4JsmfBgWyJphPx/2r8GHcghjBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885583; c=relaxed/simple;
	bh=atcNpFlFvhjLRiqYLVhlOZeWy+6bavROg/7J+Alxe9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCrZFg6HxPOBwE8K18W1gjYS4VMVIGMQQWywO1vHJENpeMSBZ2goHI/oLRCSKGze0TWnEQU7qU8s20ko9o9L95YmDpzxO6HZACH2RPxmRRtExaocKKwRAbAxGkXFN5A6jqdSbc0pX4h0ucZdr0qVG/y1cReUn1uwLw+MaZewFBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Utxb7mJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Utxb7mJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93FCC4CEF1;
	Tue, 16 Dec 2025 11:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885583;
	bh=atcNpFlFvhjLRiqYLVhlOZeWy+6bavROg/7J+Alxe9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Utxb7mJRaq+NP4t0MLPPp4k6KcE6H1CaMkbvIIwUZTgNuzT0Vee6wTTBc+Cim3KHC
	 fY35RZ+xUWsZKVRLEcfpo4R+4lErDCie1WXrbKc1UmlQ2yjTTFMu+W7RvoiN2R0S5k
	 S5IlcA/hpSbyNz1bB/T1PBsFgQZM5i46fgavINSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 183/507] wifi: ath12k: Fix timeout error during beacon stats retrieval
Date: Tue, 16 Dec 2025 12:10:24 +0100
Message-ID: <20251216111352.145380811@linuxfoundation.org>
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

From: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>

[ Upstream commit 2977567b244f056d86658160659f06cd6c78ba3d ]

Currently, for beacon_stats, ath12k_mac_get_fw_stats() is called
for each started BSS on the specified hardware.
ath12k_mac_get_fw_stats() will wait for the fw_stats_done completion
after fetching the requested data from firmware. For the beacon_stats,
fw_stats_done completion will be set only when stats are received for
all BSSes. However, for other stats like vdev_stats or pdev_stats, there
is one request to the firmware for all enabled BSSes. Since beacon_stats
is fetched individually for all BSSes enabled in that pdev, waiting for
the completion event results in a timeout error when multiple BSSes are
enabled.

Avoid this by completing the fw_stats_done immediately after
updating the requested BSS's beacon stats in the list. Subsequently,
this list will be used to display the beacon stats for all enabled
BSSes in the requested pdev.

Additionally, remove 'num_bcn_recvd' from the ath12k_fw_stats struct
as it is no longer needed.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Fixes: 9fe4669ae919 ("wifi: ath12k: Request beacon stats from firmware")
Signed-off-by: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20251031-beacon_stats-v1-2-f52fce7b03ac@qti.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c |  2 --
 drivers/net/wireless/ath/ath12k/core.h |  1 -
 drivers/net/wireless/ath/ath12k/wmi.c  | 10 +---------
 3 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index a2137b363c2fe..cc352eef19399 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2021 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
  * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
@@ -1250,7 +1249,6 @@ void ath12k_fw_stats_reset(struct ath12k *ar)
 	spin_lock_bh(&ar->data_lock);
 	ath12k_fw_stats_free(&ar->fw_stats);
 	ar->fw_stats.num_vdev_recvd = 0;
-	ar->fw_stats.num_bcn_recvd = 0;
 	spin_unlock_bh(&ar->data_lock);
 }
 
diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index 519f826f56c8e..65b75cae1fb99 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -640,7 +640,6 @@ struct ath12k_fw_stats {
 	struct list_head vdevs;
 	struct list_head bcn;
 	u32 num_vdev_recvd;
-	u32 num_bcn_recvd;
 };
 
 struct ath12k_dbg_htt_stats {
diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index c69be688e189c..82d0773b0380d 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -8298,18 +8298,10 @@ static void ath12k_wmi_fw_stats_process(struct ath12k *ar,
 			ath12k_warn(ab, "empty beacon stats");
 			return;
 		}
-		/* Mark end until we reached the count of all started VDEVs
-		 * within the PDEV
-		 */
-		if (ar->num_started_vdevs)
-			is_end = ((++ar->fw_stats.num_bcn_recvd) ==
-				  ar->num_started_vdevs);
 
 		list_splice_tail_init(&stats->bcn,
 				      &ar->fw_stats.bcn);
-
-		if (is_end)
-			complete(&ar->fw_stats_done);
+		complete(&ar->fw_stats_done);
 	}
 }
 
-- 
2.51.0



