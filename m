Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94C630F95D;
	Tue, 16 Dec 2025 12:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887394; cv=none; b=tYsfG/jnZfQj4lqKDEONgXPYKgseB+T7knN3la3zPLrZNDCI4VT6lvS1TynM4CdwFA131SsaV4VmtI4V01EWYxJldGqcfeJJ2nUTEl9ymrkC/bYbFRDy11QpGGGJuF77d+t2GJbvJ3mq8ofHEJchjUtG6KBOzqp0byHdMD7phyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887394; c=relaxed/simple;
	bh=ol1qmJZaLi6vMKF++elfDgUjpPVIje4JcKgjZd+6jC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1ex8y9RQIR1K6Oy5/apuhw0hSQeo0wbrXxkE1w5QPrT9uvTfD12TTHMLWRdSkIvTdSgx2Zxh0SYDG9UwZz0xs9+XabxXNpIQgbdb5dkBiW/G+vyi3KvtQORjB+lPd3ZOnDOu8hejhJMJ/c7Fa7/2sr5d+0fht06g0QSHt+zxic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4gyslTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4gyslTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E666DC4CEF1;
	Tue, 16 Dec 2025 12:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887394;
	bh=ol1qmJZaLi6vMKF++elfDgUjpPVIje4JcKgjZd+6jC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4gyslTlPapLjwPV4S2YPCldt/3Ikth+eOfXZ0dI3I4Re2kUdaE4a86fWuwFTdkmB
	 BRg/2iHV2kbB4YhWQ6Bl2LACaiGFBiiNbKN14B3Qdg47w4uiQCJVqEcMuWWZWc6aoG
	 EuRQ3IFN0PS7JDJ27oTEZ957QmFIxjUDiJBY/Yzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 217/614] wifi: ath12k: Fix timeout error during beacon stats retrieval
Date: Tue, 16 Dec 2025 12:09:44 +0100
Message-ID: <20251216111409.237670828@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index 3d1956966a485..d7688b383f62c 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -644,7 +644,6 @@ struct ath12k_fw_stats {
 	struct list_head vdevs;
 	struct list_head bcn;
 	u32 num_vdev_recvd;
-	u32 num_bcn_recvd;
 };
 
 struct ath12k_dbg_htt_stats {
diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index e76275bd6916f..e647b842a6a1c 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -8418,18 +8418,10 @@ static void ath12k_wmi_fw_stats_process(struct ath12k *ar,
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



