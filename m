Received: from n169-110.mail.139.com (n169-110.mail.139.com [120.232.169.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FC132ED34
	for <patches@lists.linux.dev>; Wed, 28 Jan 2026 03:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769570842; cv=none; b=TmLgCy50W6VSj1Eps6F0P61rfaLwlO+aVEIt8VKMfsQDxxeY4rD3CPwVxr5wJwcaDkKb59eTvv70FijcV3UpyOcpPUTj946xi4OMrYto5Mn9Lw61kEV08tyia4j/1ByHFRtU7CB4h2LYBcv1NvUITapXKiiB+dL5sfjz4zcIGns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769570842; c=relaxed/simple;
	bh=vRJB2Coe4Kpd0P6nT/IWmv61J5HCax6++NWfn/2jZtg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BaKDfkcF4FIzEyqZOgPlsDSJ22o/Ded7CJBKAZAu4HbBan0ynMauTAFP/dgwVDYmvwLuZLWHpqM/60RxPx+YPRCipumbfUxG7lk0POm91QwiB52OQOrSqdCAiOMS3a6DPm+vf6uBvrGIHao9Aff1eLd3HoS8q3Hm+tnhg94B6ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=bi7C/Xfy; arc=none smtp.client-ip=120.232.169.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="bi7C/Xfy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=bi7C/XfyYJRDA+TU92t+IQb/KN4DmRcGqH27twgmkalh+9Dtv9WQ7uJ03ypbDD4uq1h14KS0Zc9+e
	 ctHcM/O/dteIpkDq7e4g4CY105VS2ykjDXmpZVQX2oyqVefl0jjIZV8DPzTwjEzf9TNkhA3SVpv+03
	 +SdeonLlE/6tIDDw=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-05-12083 (RichMail) with SMTP id 2f33697981da662-0066a;
	Wed, 28 Jan 2026 11:26:20 +0800 (CST)
X-RM-TRANSID:2f33697981da662-0066a
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	quic_ppranees@quicinc.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	quic_kangyang@quicinc.com,
	kvalo@kernel.org,
	quic_jjohnson@quicinc.com,
	jeff.johnson@oss.qualcomm.com,
	jjohnson@kernel.org,
	quic_msinada@quicinc.com,
	rmanohar@codeaurora.org,
	julia.lawall@lip6.fr,
	quic_pradeepc@quicinc.com,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org
Subject: [PATCH 6.6.y] wifi: ath11k: fix RCU stall while reaping monitor destination ring
Date: Wed, 28 Jan 2026 11:27:15 +0800
Message-Id: <20260128032715.1183385-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit 16c6c35c03ea73054a1f6d3302a4ce4a331b427d ]

While processing the monitor destination ring, MSDUs are reaped from the
link descriptor based on the corresponding buf_id.

However, sometimes the driver cannot obtain a valid buffer corresponding
to the buf_id received from the hardware. This causes an infinite loop
in the destination processing, resulting in a kernel crash.

kernel log:
ath11k_pci 0000:58:00.0: data msdu_pop: invalid buf_id 309
ath11k_pci 0000:58:00.0: data dp_rx_monitor_link_desc_return failed
ath11k_pci 0000:58:00.0: data msdu_pop: invalid buf_id 309
ath11k_pci 0000:58:00.0: data dp_rx_monitor_link_desc_return failed

Fix this by skipping the problematic buf_id and reaping the next entry,
replacing the break with the next MSDU processing.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.30
Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Signed-off-by: Kang Yang <quic_kangyang@quicinc.com>
Acked-by: Kalle Valo <kvalo@kernel.org>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Link: https://patch.msgid.link/20241219110531.2096-2-quic_kangyang@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Li hongliang <1468888505@139.com>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 8cc51ab699de..dc54ea16c12a 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -4728,7 +4728,7 @@ ath11k_dp_rx_mon_mpdu_pop(struct ath11k *ar, int mac_id,
 			if (!msdu) {
 				ath11k_dbg(ar->ab, ATH11K_DBG_DATA,
 					   "msdu_pop: invalid buf_id %d\n", buf_id);
-				break;
+				goto next_msdu;
 			}
 			rxcb = ATH11K_SKB_RXCB(msdu);
 			if (!rxcb->unmapped) {
@@ -5362,7 +5362,7 @@ ath11k_dp_rx_full_mon_mpdu_pop(struct ath11k *ar,
 					   "full mon msdu_pop: invalid buf_id %d\n",
 					    buf_id);
 				spin_unlock_bh(&rx_ring->idr_lock);
-				break;
+				goto next_msdu;
 			}
 			idr_remove(&rx_ring->bufs_idr, buf_id);
 			spin_unlock_bh(&rx_ring->idr_lock);
-- 
2.34.1


