Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DCD1A239A;
	Tue, 26 Aug 2025 13:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214859; cv=none; b=em92swRT9Y8eXXu0Fa/Of44qfDDcGNGrZYWN3dGH8E8oPqpG8KoBeOVVOgcu2xH3DnW9U1ih360WWnF2tbmw1qGUJTPkW9Ha3R/OX7Y89wPYJX2BVTGANXmjCzaaHeopCRxBdUhRa6y0ldB1vlA3wJ5NlkDXgbDej3Qa9mrq9vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214859; c=relaxed/simple;
	bh=AVKEzNQB/e48vMAwpEYRZdPAR+cdrzcHGoXajPggj68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tjm0MNkc8RK5yaDKimSg0cptcwxBDMErw/SYSWImQIvJkgjoJqUCaky0y5F812yBhKRUx7ebaOHXDry361KiQCHbIPW5m3mF5aOZKtUNpaxLm3YVxHk7DUDIerrhTZ5C92j1DGT8yEM37rm/OIuSVTxoMNbJAjO5UtRd5EMq82I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rt8uoi1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rt8uoi1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8778C113CF;
	Tue, 26 Aug 2025 13:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214859;
	bh=AVKEzNQB/e48vMAwpEYRZdPAR+cdrzcHGoXajPggj68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rt8uoi1MAgg/sWHqym4gCZ0iAjop0pTwaMOOp+5OYs/boiDyXOgHegzlTcarO6Zzu
	 emK+IcpmVhtElhrbByl+Cv4ntXjMtnYKZRBL9+TUJF8lqNokiONR4zpnXw6/PALXIb
	 zCs4uY2V2hBvfKkAUw9JA+4KG7tkdMUDrEcfFxRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.1 297/482] wifi: ath11k: fix source ring-buffer corruption
Date: Tue, 26 Aug 2025 13:09:10 +0200
Message-ID: <20250826110938.132791420@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

commit 6efa0df54022c6c9fd4d294b87622c7fcdc418c8 upstream.

Add the missing memory barrier to make sure that LMAC source ring
descriptors are written before updating the head pointer to avoid
passing stale data to the firmware on weakly ordered architectures like
aarch64.

Note that non-LMAC rings use MMIO write accessors which have the
required write memory barrier.

Tested-on: WCN6855 hw2.1 WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.41

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org      # 5.6
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://patch.msgid.link/20250604143457.26032-5-johan+linaro@kernel.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/hal.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath11k/hal.c
+++ b/drivers/net/wireless/ath/ath11k/hal.c
@@ -835,7 +835,11 @@ void ath11k_hal_srng_access_end(struct a
 		if (srng->ring_dir == HAL_SRNG_DIR_SRC) {
 			srng->u.src_ring.last_tp =
 				*(volatile u32 *)srng->u.src_ring.tp_addr;
-			*srng->u.src_ring.hp_addr = srng->u.src_ring.hp;
+			/* Make sure descriptor is written before updating the
+			 * head pointer.
+			 */
+			dma_wmb();
+			WRITE_ONCE(*srng->u.src_ring.hp_addr, srng->u.src_ring.hp);
 		} else {
 			srng->u.dst_ring.last_hp = *srng->u.dst_ring.hp_addr;
 			*srng->u.dst_ring.tp_addr = srng->u.dst_ring.tp;
@@ -844,6 +848,10 @@ void ath11k_hal_srng_access_end(struct a
 		if (srng->ring_dir == HAL_SRNG_DIR_SRC) {
 			srng->u.src_ring.last_tp =
 				*(volatile u32 *)srng->u.src_ring.tp_addr;
+			/* Assume implementation use an MMIO write accessor
+			 * which has the required wmb() so that the descriptor
+			 * is written before the updating the head pointer.
+			 */
 			ath11k_hif_write32(ab,
 					   (unsigned long)srng->u.src_ring.hp_addr -
 					   (unsigned long)ab->mem,


