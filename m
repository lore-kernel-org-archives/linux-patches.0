Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F076426AC5;
	Sat, 12 Sep 2026 15:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228732; cv=none; b=cL0yFQik7arwBsOxPIMl+1Qqe6urRDJeyQYhHXrdR3P1QxdUbJJN1m/jZHvEEVdCXsXDjnD+mefXyzA41IoimNqKwzED78xfLaEeBBT2K+7lrjag3zaV7r0MO/bu+SQG9nDpMcqPmLZQiz0fAe8rmV9tfM+VWmHVYsNa9pZA38w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228732; c=relaxed/simple;
	bh=llMVa8uHOHsK93aP0IT8EdNOMLerAznzkrLDLSat4KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKU/UoMIfNwSOFNStneXyhrPIWI/pE0fZN1ZK73TMHPmOuwk23lsTFpdLH1at17Nr0o0g83Nd0ydVVk4bfu3yxnp8uPqIHeBwJpJa0Uwo9k9QhyG/Emjaf5uX2fI64mh6E2CYAd0WFCwkRLBpk5A66t/R0YWjyeZXNqSMnWYrmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUJgU/vS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUJgU/vS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0136B1F000FF;
	Sat, 12 Sep 2026 15:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228730;
	bh=zCgnH6Z10u2bbWBi0z2OF5sEDMgTaO1/FhkF4cOKYjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zUJgU/vSMwTUJdJLBa2JQp7eiuUoIewUMZKUdevEc1BLLECnnGZ/3py6914pFiafP
	 G9XA4sJ4JRoJSXLpXNUSrO0Cex4O0898zk+41a6zI8dp2/cidgMXwYvUjSYCDC8b+E
	 0CiXUNIwUcAwMwCnOmVeelif6iVL07an0zp8T67M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Kang Yang <quic_kangyang@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0445/1191] wifi: ath11k: fix RCU stall while reaping monitor destination ring
Date: Sat, 12 Sep 2026 08:52:53 +0200
Message-ID: <20260912065558.227213301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index ac9796e8cd595..8064e505aad5e 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -4714,7 +4714,7 @@ ath11k_dp_rx_mon_mpdu_pop(struct ath11k *ar, int mac_id,
 			if (!msdu) {
 				ath11k_dbg(ar->ab, ATH11K_DBG_DATA,
 					   "msdu_pop: invalid buf_id %d\n", buf_id);
-				break;
+				goto next_msdu;
 			}
 			rxcb = ATH11K_SKB_RXCB(msdu);
 			if (!rxcb->unmapped) {
@@ -5348,7 +5348,7 @@ ath11k_dp_rx_full_mon_mpdu_pop(struct ath11k *ar,
 					   "full mon msdu_pop: invalid buf_id %d\n",
 					    buf_id);
 				spin_unlock_bh(&rx_ring->idr_lock);
-				break;
+				goto next_msdu;
 			}
 			idr_remove(&rx_ring->bufs_idr, buf_id);
 			spin_unlock_bh(&rx_ring->idr_lock);
-- 
2.53.0



