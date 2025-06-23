Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E783F1E22E6;
	Mon, 23 Jun 2025 22:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716437; cv=none; b=Obxi0RBb44Jwj/XiaX/e84EqZM5CJ9dpKgBorgCliSJNAwBLBfSzxjUL4GG7r4BBiXNWN8g0egYtpzNvfxGD1gACLycCHXpfze8WIBtVXTftUrdJ2Sjqjwazxyhs3eTyMBVN91rvb8k4AfgtQ+7ll7tKlSSuQP2k+4mYDHe9JxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716437; c=relaxed/simple;
	bh=BAJLHlwU0JVwpPjdWYkYw21IpNIZRB5TUib7DDNI1NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0YwY2xOaSYSoIo/7M6G9MU2ltc/o6TmZc/X09d/GkyQhu04f0fnrxHfhsD48/pGS+h2WiLApihSV2ZSeNeOmR8uBt5xi2GzAHZ3+8s3dUTw5LJpGyaaro24OGbufaKE5CTyAu+uC7Mrs+/+sLPVgJF7Lw70lWCWxU0a2ENIwcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+jRMHSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+jRMHSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72596C4CEEA;
	Mon, 23 Jun 2025 22:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716436;
	bh=BAJLHlwU0JVwpPjdWYkYw21IpNIZRB5TUib7DDNI1NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+jRMHSuAiw+DHi/+Yi8EZb/XCS7ePFsz/ZIm5HOqm4QmeBQkGUHxRcg9KhJtY4wA
	 P1G8vYhnf6PWdjB5xgyTSCUWTxKwmpJ2Q5YHhrpWaXbKPlBtoj8sTV0rcEWTHrfmr6
	 bBHXP40/h7lkfHJX/dHo8WMWKxiRwYGPmeeO3ndk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <quic_miaoqing@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Steev Klimaszewski <steev@kali.org>,
	Jens Glathe <jens.glathe@oldschoolsolutions.biz>,
	Clayton Craft <clayton@craftyguy.net>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.1 302/508] wifi: ath11k: fix ring-buffer corruption
Date: Mon, 23 Jun 2025 15:05:47 +0200
Message-ID: <20250623130652.733009233@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 6d037a372f817e9fcb56482f37917545596bd776 upstream.

Users of the Lenovo ThinkPad X13s have reported that Wi-Fi sometimes
breaks and the log fills up with errors like:

    ath11k_pci 0006:01:00.0: HTC Rx: insufficient length, got 1484, expected 1492
    ath11k_pci 0006:01:00.0: HTC Rx: insufficient length, got 1460, expected 1484

which based on a quick look at the driver seemed to indicate some kind
of ring-buffer corruption.

Miaoqing Pan tracked it down to the host seeing the updated destination
ring head pointer before the updated descriptor, and the error handling
for that in turn leaves the ring buffer in an inconsistent state.

Add the missing memory barrier to make sure that the descriptor is read
after the head pointer to address the root cause of the corruption while
fixing up the error handling in case there are ever any (ordering) bugs
on the device side.

Note that the READ_ONCE() are only needed to avoid compiler mischief in
case the ring-buffer helpers are ever inlined.

Tested-on: WCN6855 hw2.1 WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.41

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218623
Link: https://lore.kernel.org/20250310010217.3845141-3-quic_miaoqing@quicinc.com
Cc: Miaoqing Pan <quic_miaoqing@quicinc.com>
Cc: stable@vger.kernel.org	# 5.6
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Miaoqing Pan <quic_miaoqing@quicinc.com>
Tested-by: Steev Klimaszewski <steev@kali.org>
Tested-by: Jens Glathe <jens.glathe@oldschoolsolutions.biz>
Tested-by: Clayton Craft <clayton@craftyguy.net>
Link: https://patch.msgid.link/20250321094916.19098-1-johan+linaro@kernel.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/ce.c  |   11 +++++------
 drivers/net/wireless/ath/ath11k/hal.c |    4 ++--
 2 files changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/ce.c
+++ b/drivers/net/wireless/ath/ath11k/ce.c
@@ -393,11 +393,10 @@ static int ath11k_ce_completed_recv_next
 		goto err;
 	}
 
+	/* Make sure descriptor is read after the head pointer. */
+	dma_rmb();
+
 	*nbytes = ath11k_hal_ce_dst_status_get_length(desc);
-	if (*nbytes == 0) {
-		ret = -EIO;
-		goto err;
-	}
 
 	*skb = pipe->dest_ring->skb[sw_index];
 	pipe->dest_ring->skb[sw_index] = NULL;
@@ -430,8 +429,8 @@ static void ath11k_ce_recv_process_cb(st
 		dma_unmap_single(ab->dev, ATH11K_SKB_RXCB(skb)->paddr,
 				 max_nbytes, DMA_FROM_DEVICE);
 
-		if (unlikely(max_nbytes < nbytes)) {
-			ath11k_warn(ab, "rxed more than expected (nbytes %d, max %d)",
+		if (unlikely(max_nbytes < nbytes || nbytes == 0)) {
+			ath11k_warn(ab, "unexpected rx length (nbytes %d, max %d)",
 				    nbytes, max_nbytes);
 			dev_kfree_skb_any(skb);
 			continue;
--- a/drivers/net/wireless/ath/ath11k/hal.c
+++ b/drivers/net/wireless/ath/ath11k/hal.c
@@ -601,7 +601,7 @@ u32 ath11k_hal_ce_dst_status_get_length(
 		(struct hal_ce_srng_dst_status_desc *)buf;
 	u32 len;
 
-	len = FIELD_GET(HAL_CE_DST_STATUS_DESC_FLAGS_LEN, desc->flags);
+	len = FIELD_GET(HAL_CE_DST_STATUS_DESC_FLAGS_LEN, READ_ONCE(desc->flags));
 	desc->flags &= ~HAL_CE_DST_STATUS_DESC_FLAGS_LEN;
 
 	return len;
@@ -802,7 +802,7 @@ void ath11k_hal_srng_access_begin(struct
 		srng->u.src_ring.cached_tp =
 			*(volatile u32 *)srng->u.src_ring.tp_addr;
 	} else {
-		srng->u.dst_ring.cached_hp = *srng->u.dst_ring.hp_addr;
+		srng->u.dst_ring.cached_hp = READ_ONCE(*srng->u.dst_ring.hp_addr);
 
 		/* Try to prefetch the next descriptor in the ring */
 		if (srng->flags & HAL_SRNG_FLAGS_CACHED)


