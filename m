Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEB2227BA4;
	Tue, 26 Aug 2025 13:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213503; cv=none; b=GW2HoiscrxKbFhfluAsV/lqx74z2XPOrFrRW3z+iqZ7Z+6jFWDyFsJOCxqOBwyb2esBqskVbZ62b1BFuZ0a+H9RZ5gRAAkntyNEaomOVA3pJniDyz3CiWJgeWI8EIaBqDo5czk1BFGn4grIulnloZPyo1QU6tE1ZzHWlElv8MO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213503; c=relaxed/simple;
	bh=78cQdAaYG6NWkAbrAW9Lp8k7nlNCPwSe7nFhwbGcGWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWclq+HUEFbFae5ojE7YpIA/0ILYnisq+3TLfuJNsuUbwrl1Teo65f9w3fSkz/vpNPVWRiu38+Uv9kzBW/TNDQEaP+XFYCiEcxjFytP+dxqVHtG4hgRdsDcmIaV7VZQ4GjzPCe88tBeSZ3+1OilWtEZAdGYYTbizWidMRd5dnQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yU6bs47V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yU6bs47V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57778C4CEF1;
	Tue, 26 Aug 2025 13:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213503;
	bh=78cQdAaYG6NWkAbrAW9Lp8k7nlNCPwSe7nFhwbGcGWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yU6bs47VE6vibxdJxMGdyTCOmldhD+9jkTnE36nBHSY3i+VmJF+F6pJWEJOv/duYc
	 DFNfZQhB0bBmUJdRIoqk9oPTjUnHDIrj4KqkKhwucmZqsFTJkjiiOtm+C90db/mlSg
	 GwLrLpf1bsp7Y6isMZ5lb4bAbbNntldEfVP0r6FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.6 371/587] wifi: ath12k: fix source ring-buffer corruption
Date: Tue, 26 Aug 2025 13:08:40 +0200
Message-ID: <20250826111002.345287043@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit e834da4cbd6fe1d24f89368bf0c80adcad212726 upstream.

Add the missing memory barrier to make sure that LMAC source ring
descriptors are written before updating the head pointer to avoid
passing stale data to the firmware on weakly ordered architectures like
aarch64.

Note that non-LMAC rings use MMIO write accessors which have the
required write memory barrier.

Tested-on: WCN7850 hw2.0 WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Cc: stable@vger.kernel.org      # 6.3
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Baochen Qiang <quic_bqiang@quicinc.com>
Link: https://patch.msgid.link/20250617084402.14475-4-johan+linaro@kernel.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/hal.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath12k/hal.c
+++ b/drivers/net/wireless/ath/ath12k/hal.c
@@ -1763,7 +1763,11 @@ void ath12k_hal_srng_access_end(struct a
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
@@ -1772,6 +1776,10 @@ void ath12k_hal_srng_access_end(struct a
 		if (srng->ring_dir == HAL_SRNG_DIR_SRC) {
 			srng->u.src_ring.last_tp =
 				*(volatile u32 *)srng->u.src_ring.tp_addr;
+			/* Assume implementation use an MMIO write accessor
+			 * which has the required wmb() so that the descriptor
+			 * is written before the updating the head pointer.
+			 */
 			ath12k_hif_write32(ab,
 					   (unsigned long)srng->u.src_ring.hp_addr -
 					   (unsigned long)ab->mem,


