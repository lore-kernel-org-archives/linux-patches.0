Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D14352094;
	Tue, 26 Aug 2025 13:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216611; cv=none; b=hscALfXASS4VA4qGqS0x/5n1i3DVavNq1tMka6BuNruqeRBZ4UEXSjlHfLlb5IF3eqAihzwT0ivgvUkBMvMmuyWEqLFO/E0JUmjoOK3d3fsd0TzrlyKLV2Rcfva7uFVlpWVbqjhJqf2Ug84ram+cPVPmToM0yM1bZNyaNQyhhcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216611; c=relaxed/simple;
	bh=JmTF03advMPIK9GZgWd8Cw8LWqB845VLGYIFl+/bjXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxJky8zeDnu8sCSkTLeKp+ljbTR8AIzL1MtdDMEOKHVgRZgFLwB/kL4lKkLi+PB6TH9Fgjv2RQqLXPut7bCQm3+XkIGgwXYNDzu7JIugg1If184un3Jf2YxvNaOPpeWWy2LCVWTSPmN7hplJbgyNIOxPumU7x9cGue/Xll67C1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geLzRPQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geLzRPQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2812EC4CEF1;
	Tue, 26 Aug 2025 13:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216611;
	bh=JmTF03advMPIK9GZgWd8Cw8LWqB845VLGYIFl+/bjXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geLzRPQry1PNxVrlFCIALK/hS53qCtakQhvEJ0tfjtdh5xJV+IkgQ8PxfcvOYAagO
	 0kd+kShk1fXiFCXGwZQFDSD3ZxOWQTlWaWWjiD0fYROIDt8oow3NeBUIPk4CQR9bmc
	 PR0WMSJY3WcTmtcqQK62OddI/X0gGJplmTMUZTdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 5.15 477/644] wifi: ath11k: fix source ring-buffer corruption
Date: Tue, 26 Aug 2025 13:09:28 +0200
Message-ID: <20250826110958.305223230@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -797,7 +797,11 @@ void ath11k_hal_srng_access_end(struct a
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
@@ -806,6 +810,10 @@ void ath11k_hal_srng_access_end(struct a
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


