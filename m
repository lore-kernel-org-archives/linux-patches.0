Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733BE2571A2;
	Thu, 17 Apr 2025 18:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914128; cv=none; b=JyLChlTDhfHkdtkw0QpuEcMvfuEf8QCvD4LruVBuC2kisA5/qpZxZWNVwuXMbh7XUImkunRbTw7xojWbPGttYrMVmgINMC9xWAlbxiAQVqB7JhDMJvi0NkLiP2urK2PwWXZ+nZWeUjQgfmTKk7M52Vf++80C/MqeZeiPlYvGyUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914128; c=relaxed/simple;
	bh=FO0fk/PEsns2J5juiQTGTfmDoJpynr09PWkXW5aetBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcT1+s9zygYCQHDSZLeNYiSrXM9uVejWV9KPODbqkedNRvG7t82kyfsmQPlsRyEzoxiQ38sKZG+0atV8LQZNUj7qhQaAS7TqqMwg4oM2q1o+NeYRwfv0yG2dDcO0j9E/0wF079MXJxKd26IVGZltA5gm+McnOd5vmM8qnR4hZ7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ks+cT6tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ks+cT6tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E404C4CEE7;
	Thu, 17 Apr 2025 18:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914127;
	bh=FO0fk/PEsns2J5juiQTGTfmDoJpynr09PWkXW5aetBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ks+cT6tjhscHmmHh+oq2j5gyHthtiJUH0PCUraWKSUdKUGwbJ1+fC12NThYy52wPD
	 M6GHjcoWTNN0aG9vSRjCWYM+gv6XqVcCVxuvsFrVG0FAQDH/sySywfDx5uNzd/87OO
	 fEs0ngb/jdVQVoo+I7tZXELArrZylZSQrafY6Res=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 086/414] wifi: ath12k: Fix invalid entry fetch in ath12k_dp_mon_srng_process
Date: Thu, 17 Apr 2025 19:47:24 +0200
Message-ID: <20250417175114.900824006@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit 63fdc4509bcf483e79548de6bc08bf3c8e504bb3 ]

Currently, ath12k_dp_mon_srng_process uses ath12k_hal_srng_src_get_next_entry
to fetch the next entry from the destination ring. This is incorrect because
ath12k_hal_srng_src_get_next_entry is intended for source rings, not destination
rings. This leads to invalid entry fetches, causing potential data corruption or
crashes due to accessing incorrect memory locations. This happens because the
source ring and destination ring have different handling mechanisms and using
the wrong function results in incorrect pointer arithmetic and ring management.

To fix this issue, replace the call to ath12k_hal_srng_src_get_next_entry with
ath12k_hal_srng_dst_get_next_entry in ath12k_dp_mon_srng_process. This ensures
that the correct function is used for fetching entries from the destination
ring, preventing invalid memory accesses.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Link: https://patch.msgid.link/20241223060132.3506372-7-quic_ppranees@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 494984133a919..a168640c27625 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -2545,7 +2545,7 @@ int ath12k_dp_mon_rx_process_stats(struct ath12k *ar, int mac_id,
 		dest_idx = 0;
 move_next:
 		ath12k_dp_mon_buf_replenish(ab, buf_ring, 1);
-		ath12k_hal_srng_src_get_next_entry(ab, srng);
+		ath12k_hal_srng_dst_get_next_entry(ab, srng);
 		num_buffs_reaped++;
 	}
 
-- 
2.39.5



