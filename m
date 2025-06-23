Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007412417C3;
	Mon, 23 Jun 2025 13:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684387; cv=none; b=n3wiaRBkGQwpkUwkILEAAAhByVjO4N1pPFDhZjIurWmtWccitrUKtM4PAjzCNOugknP59aRea07jzY9ETJuV5HuB4P8sORGONF4NXV3ewbrTlxu1FSQKcLtupPcKdaWR7eMl7A9BCR24OzLjzSpf0YRqAACopw1v/XtEbOXFPH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684387; c=relaxed/simple;
	bh=NE7i7V6WfdJxReti5v52Axj6NUekTWLB3eFLTzP0g+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1nNnBb8+YU4R7OLJ7WcCSLgdXLrVg59goySkFP+3tAuuOY0CtMdJT8mrkzvDFCozUw0iHzqpwXfiKkSGyF+5Dalw6rTVgjnirNh5lG2mp/Z7hDW7SLuGWxycDg5LiwwJa3yDFCMADIVzls6L5oou3wD/yEeObE+cqS+kFA2PCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0IC5Ve+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0IC5Ve+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87ECBC4CEEA;
	Mon, 23 Jun 2025 13:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684386;
	bh=NE7i7V6WfdJxReti5v52Axj6NUekTWLB3eFLTzP0g+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0IC5Ve+TWCzIN6KDJ2mh81BNbDUA+kzcGTbGXI+GfEMOm+iaII0Hr2YPInZa5HxI
	 SFqNLcc6B6mdbioBQb02DkRAlkqTCwWf0owU34xSvpit9Ak/RkN3xM7fp0g/slMvY/
	 m789Zcv2+H0Haphg2k03kGeVo/HWT5P+KeIMRD44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <quic_miaoqing@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.15 049/592] wifi: ath12k: fix ring-buffer corruption
Date: Mon, 23 Jun 2025 15:00:07 +0200
Message-ID: <20250623130701.413660095@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 6b67d2cf14ea997061f61e9c8afd4e1c0f22acb9 upstream.

Users of the Lenovo ThinkPad X13s have reported that Wi-Fi sometimes
breaks and the log fills up with errors like:

    ath11k_pci 0006:01:00.0: HTC Rx: insufficient length, got 1484, expected 1492
    ath11k_pci 0006:01:00.0: HTC Rx: insufficient length, got 1460, expected 1484

which based on a quick look at the ath11k driver seemed to indicate some
kind of ring-buffer corruption.

Miaoqing Pan tracked it down to the host seeing the updated destination
ring head pointer before the updated descriptor, and the error handling
for that in turn leaves the ring buffer in an inconsistent state.

While this has not yet been observed with ath12k, the ring-buffer
implementation is very similar to the ath11k one and it suffers from the
same bugs.

Add the missing memory barrier to make sure that the descriptor is read
after the head pointer to address the root cause of the corruption while
fixing up the error handling in case there are ever any (ordering) bugs
on the device side.

Note that the READ_ONCE() are only needed to avoid compiler mischief in
case the ring-buffer helpers are ever inlined.

Tested-on: WCN7850 hw2.0 WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Cc: stable@vger.kernel.org	# 6.3
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218623
Link: https://lore.kernel.org/20250310010217.3845141-3-quic_miaoqing@quicinc.com
Cc: Miaoqing Pan <quic_miaoqing@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Miaoqing Pan <quic_miaoqing@quicinc.com>
Link: https://patch.msgid.link/20250321095219.19369-1-johan+linaro@kernel.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/ce.c  |   11 +++++------
 drivers/net/wireless/ath/ath12k/hal.c |    4 ++--
 2 files changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/ath/ath12k/ce.c
+++ b/drivers/net/wireless/ath/ath12k/ce.c
@@ -343,11 +343,10 @@ static int ath12k_ce_completed_recv_next
 		goto err;
 	}
 
+	/* Make sure descriptor is read after the head pointer. */
+	dma_rmb();
+
 	*nbytes = ath12k_hal_ce_dst_status_get_length(desc);
-	if (*nbytes == 0) {
-		ret = -EIO;
-		goto err;
-	}
 
 	*skb = pipe->dest_ring->skb[sw_index];
 	pipe->dest_ring->skb[sw_index] = NULL;
@@ -380,8 +379,8 @@ static void ath12k_ce_recv_process_cb(st
 		dma_unmap_single(ab->dev, ATH12K_SKB_RXCB(skb)->paddr,
 				 max_nbytes, DMA_FROM_DEVICE);
 
-		if (unlikely(max_nbytes < nbytes)) {
-			ath12k_warn(ab, "rxed more than expected (nbytes %d, max %d)",
+		if (unlikely(max_nbytes < nbytes || nbytes == 0)) {
+			ath12k_warn(ab, "unexpected rx length (nbytes %d, max %d)",
 				    nbytes, max_nbytes);
 			dev_kfree_skb_any(skb);
 			continue;
--- a/drivers/net/wireless/ath/ath12k/hal.c
+++ b/drivers/net/wireless/ath/ath12k/hal.c
@@ -1943,7 +1943,7 @@ u32 ath12k_hal_ce_dst_status_get_length(
 {
 	u32 len;
 
-	len = le32_get_bits(desc->flags, HAL_CE_DST_STATUS_DESC_FLAGS_LEN);
+	len = le32_get_bits(READ_ONCE(desc->flags), HAL_CE_DST_STATUS_DESC_FLAGS_LEN);
 	desc->flags &= ~cpu_to_le32(HAL_CE_DST_STATUS_DESC_FLAGS_LEN);
 
 	return len;
@@ -2113,7 +2113,7 @@ void ath12k_hal_srng_access_begin(struct
 		srng->u.src_ring.cached_tp =
 			*(volatile u32 *)srng->u.src_ring.tp_addr;
 	else
-		srng->u.dst_ring.cached_hp = *srng->u.dst_ring.hp_addr;
+		srng->u.dst_ring.cached_hp = READ_ONCE(*srng->u.dst_ring.hp_addr);
 }
 
 /* Update cached ring head/tail pointers to HW. ath12k_hal_srng_access_begin()


