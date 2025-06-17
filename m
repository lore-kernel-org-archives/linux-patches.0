Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438CD2FA626;
	Tue, 17 Jun 2025 16:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179281; cv=none; b=qf4VDqTCy/2x0/m50X8ynSLUf7e6n2LgbRQkd0LQ47Obi0PdfTrgNUROv3ZHuH4zniyPPsqcZxLKYAnOgP7pteKDP1tYHpgVZhh4iFMXvCoV6FE9KhADskHElg4NHb7cMC6Uq9lOBr6T5Tyj7McxhctUp8phNxKEyimGgpPsPuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179281; c=relaxed/simple;
	bh=0iaFt0wYADB/0e1/GoR+TMk2rupVID6FsJSiS7ZW8Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnClG+wnwgSU7TSvnNW+4NUGk+unoknFCRvTL7UhXYaTPQe1aXOxCsd32FMezSnaUy3MjLqxAoxk/CjWNTmvKDwJF+3nVa9sNNCab3i4p1BTSfrA8g/IN/44TuEb+Xe/ADOGKsBJYNbPIPQe+HHimqt2lPxvD+uYzjQcX9Icgdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3Iod9CJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3Iod9CJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75551C4CEE3;
	Tue, 17 Jun 2025 16:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179281;
	bh=0iaFt0wYADB/0e1/GoR+TMk2rupVID6FsJSiS7ZW8Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3Iod9CJUczJaNkFe1b2zcubp1fhkt3Lbv2QXmwXfDJCJCBxXLovOqRlpJjCze/zH
	 eQr5CoHpxAj4PAM3xfek1dfL2jhj2g3u9yqavIokAKaS6AJwvMKexE2NeU8L3SikAQ
	 rBo8SBRpM9kQc7i37aM/osPv/E9jDMXNl1CxTiNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 674/780] wifi: ath11k: dont wait when there is no vdev started
Date: Tue, 17 Jun 2025 17:26:22 +0200
Message-ID: <20250617152518.917524084@linuxfoundation.org>
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



