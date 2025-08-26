Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875941A256B;
	Tue, 26 Aug 2025 11:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207262; cv=none; b=K3SZ1qoZnMAbJEs3425m8CvkQpUbLicb3zR2dt2gvvW25m7QshQWtVt2ewL5wotWRVIWFuIvMfFcySgxgu1U1AtQBBzWYtsUnutSfEeWsj9o1/nJscdMyVoWVn8ULuZzWR0j4FiFmy3EQEAjlOxpAft/J1S3X80pviJMKrgyB/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207262; c=relaxed/simple;
	bh=nydIqm+vr5UsQWtiRszQMXtbfvE6HSM2QhPrZeTvXZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmLEgSiQfoJoq3067aahgQzQDQYc/D3LQM3jdwiqNqFEw5XfBZ3epbN2TaoA/wO82SBiGPz5BelUGU2vs1cTfTC22L3nrAmS0ZKzJVE5TDQP8metEo8eC5x5nJnBej2q7UoZRtZuhIg0eSifAyseRS72Q2BXMKlVVlv75Cs1J0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6LfhOp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6LfhOp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A74C4CEF1;
	Tue, 26 Aug 2025 11:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207262;
	bh=nydIqm+vr5UsQWtiRszQMXtbfvE6HSM2QhPrZeTvXZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6LfhOp2ulnQtX6THM7xyGsaL7cxL05XrbgspQVAbQOQGMqDg4VWQkyMDmnZFCopr
	 De1q2RXnwA70xA3k7groQTyNurPQiguL8A04aHy7O5xuz+4EIgzM0Diy6z+u+uTVR+
	 k4zwZbgYLaZIHAp6Y67WG0X66GjF/34sa7wcA2b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.16 082/457] wifi: ath12k: fix source ring-buffer corruption
Date: Tue, 26 Aug 2025 13:06:06 +0200
Message-ID: <20250826110939.403655518@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2178,7 +2178,11 @@ void ath12k_hal_srng_access_end(struct a
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
@@ -2187,6 +2191,10 @@ void ath12k_hal_srng_access_end(struct a
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


