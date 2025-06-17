Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4757A2DFF3C;
	Tue, 17 Jun 2025 16:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178017; cv=none; b=XxbzrVaQSEUsju6TypGivTdd79LVbxDxJt1ChloQjkgXsttIw99PCsqNFw2acQRbhHRWL54Woxvy7Zc0qaNYxBDcgsPiuOVTJx8XVpC31Ufhc5YlRwPvGqTyNgWx2SX+oOIT1jkTrehUjbpyBPZ1kt50AyekrcYifv0yLSUUBOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178017; c=relaxed/simple;
	bh=lAspYPpuXZvRL+19LOABBwkS8yo5eRIt3LtPzdCePhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jz47UuTyk0x08O8iDijgqzpd/CIUuAJg6znkYyal3JsTG4V6UWt/332zedCbHUmOnXLGh5CAsDQsFrm55RoYK4L/I21p1nAaBuVh4M2abuFeBZ88rK8EI6COZqBwRINFezf17cDynz0QXUgh/HaVG4MOymuASZNHnfiuHE/VJjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nijUAIi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nijUAIi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B56C4CEF0;
	Tue, 17 Jun 2025 16:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178016;
	bh=lAspYPpuXZvRL+19LOABBwkS8yo5eRIt3LtPzdCePhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nijUAIi93FmcUyMxfOqN8DGaRduJhL/OUTLhYCFTF/uvtYd6UFzaf3LeSLJMhtj1z
	 jQwxxeZuwld9mC/ADdJhSebe1jmyf89seyAXlvBGCrxSlTgWiw1GSxE+MM5Jg/6JXS
	 FqTmrGV8+xy2SlxqylJLlIQaMH6qsF+eOnz0R9cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 432/512] wifi: ath11k: dont wait when there is no vdev started
Date: Tue, 17 Jun 2025 17:26:38 +0200
Message-ID: <20250617152437.077264558@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 3b6d00fa883075dcaf49221538230e038a9c0b43 ]

For WMI_REQUEST_VDEV_STAT request, firmware might split response into
multiple events dut to buffer limit, hence currently in
ath11k_debugfs_fw_stats_process() we wait until all events received.
In case there is no vdev started, this results in that below condition
would never get satisfied

	((++ar->fw_stats.num_vdev_recvd) == total_vdevs_started)

finally the requestor would be blocked until wait time out.

The same applies to WMI_REQUEST_BCN_STAT request as well due to:

	((++ar->fw_stats.num_bcn_recvd) == ar->num_started_vdevs)

Change to check the number of started vdev first: if it is zero, finish
wait directly; if not, follow the old way.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.37

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250220082448.31039-4-quic_bqiang@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/debugfs.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 27c93c0b4c223..ccf0e62c7d7ae 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -107,7 +107,7 @@ void ath11k_debugfs_fw_stats_process(struct ath11k *ar, struct ath11k_fw_stats *
 {
 	struct ath11k_base *ab = ar->ab;
 	struct ath11k_pdev *pdev;
-	bool is_end;
+	bool is_end = true;
 	size_t total_vdevs_started = 0;
 	int i;
 
@@ -132,7 +132,9 @@ void ath11k_debugfs_fw_stats_process(struct ath11k *ar, struct ath11k_fw_stats *
 				total_vdevs_started += ar->num_started_vdevs;
 		}
 
-		is_end = ((++ar->fw_stats.num_vdev_recvd) == total_vdevs_started);
+		if (total_vdevs_started)
+			is_end = ((++ar->fw_stats.num_vdev_recvd) ==
+				  total_vdevs_started);
 
 		list_splice_tail_init(&stats->vdevs,
 				      &ar->fw_stats.vdevs);
@@ -151,7 +153,9 @@ void ath11k_debugfs_fw_stats_process(struct ath11k *ar, struct ath11k_fw_stats *
 		/* Mark end until we reached the count of all started VDEVs
 		 * within the PDEV
 		 */
-		is_end = ((++ar->fw_stats.num_bcn_recvd) == ar->num_started_vdevs);
+		if (ar->num_started_vdevs)
+			is_end = ((++ar->fw_stats.num_bcn_recvd) ==
+				  ar->num_started_vdevs);
 
 		list_splice_tail_init(&stats->bcn,
 				      &ar->fw_stats.bcn);
-- 
2.39.5



