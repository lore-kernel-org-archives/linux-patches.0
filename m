Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7629285047;
	Tue, 17 Jun 2025 16:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176654; cv=none; b=U/4lBUXkvfCKf3UFO6kvJA2BhELo53AkLGlfwiEkKPgVrt8x4DDY2P+DM7r1OJyNR8HD06/LvY2fhUIn7N5yGipp6KLOBk2sf0nAUoaLxcOAWzqy3fKdvCxBzBy3hwFw3Hiytn7WbcGewsXjmHocb459Yc0YrjchWSOEOS7DLtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176654; c=relaxed/simple;
	bh=gd4KhyasyusT9/oGWVqpUXhKKIL5mr5yImb8Qte+USc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0YQ36Z20m0GvWajznArL1EPwm9CpQ8xfWmDzId/vfCbLrEX/o2FoESRi8MZGalsW/5Afa9h6WY8mAMLPx3edpYxOtAEGv6I/A/wmkbRSzh2KaghASM/msSkX2zq86sNjKGiZeuDpfWex/vZyUmw9l6tWt8l8P9IcuudwsRbE9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMqoqlge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMqoqlge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AD0C4CEE3;
	Tue, 17 Jun 2025 16:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176654;
	bh=gd4KhyasyusT9/oGWVqpUXhKKIL5mr5yImb8Qte+USc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMqoqlgewkFiFixHqTYMSoBACRLB1pJVWYku3hm4bTdSWOVMRu2ci4+n6PeSfWUvS
	 nreo6dQEoD5bzwotky5xPd+msrp2ZDLNMpZNuiY+TTFmu5rsSc4PenTCB+fQSVXECc
	 0514vSEZ7O2O9dd3fbYcOCOx7CA2LoJTlDwdUwzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 301/356] wifi: ath11k: dont wait when there is no vdev started
Date: Tue, 17 Jun 2025 17:26:56 +0200
Message-ID: <20250617152350.287904337@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5a375d6680594..50bc17127e68a 100644
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



