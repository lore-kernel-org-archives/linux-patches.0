Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E33546AA6B;
	Tue, 21 Jul 2026 15:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648093; cv=none; b=qqGvUSz3CZ7BX9CojWK7foJD6lwSSpvSQUj21/YS65iEHT+7as8IJZN1JO5aqsOxFp2/7KiH/D7V1+dsTBurdV+gLSQzF2Kzgci0ePjADtfrAj8+ifzpMpg6PMvCDWJrF8YNTBL7wGPsPP3fdDPJ580DH83ck0HFMGJg5YQoaaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648093; c=relaxed/simple;
	bh=bfn2IjIplq1c/WRrD3bg7CGIUAtyW+zfBDw1QDz4yws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPPYiUKyA3WaAyAx7BoR5srIku8+ZhWwwiRCrXq//8jrs3xYQUMZzTWE2iy/9Ut+diMtNGu7C/ULsmmSpwQLOT1Id+fvZqS0mAwqoxqxn0EUdLgEXDenZzq26ZP5CLoo2/g8Opm1AJ4Zy6Y8oJLHX9VTo0SvLOkgU5Y4nbZv8rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXW8tLLs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXW8tLLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED111F000E9;
	Tue, 21 Jul 2026 15:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648092;
	bh=i+u+R4oL4xfF1d3YGaI3+GkwvnhXZVMHEoF80JSkDWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXW8tLLs0HgIWfiIVQeNcbsYsKIO7W1OcYQm70uvf23xct61LsvUAmyJECKyAz/TE
	 2ZPqKCBJauC3CdyPmnmke9wVV+/jvr3uG4YvMFDQHIng1uIvjBvCZjAqZ7ubiZGaMI
	 XHAsGK5r5SsI6Jw2Rf76EP8nXel6mVKnxzv68jI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0068/2077] wifi: ath12k: Fix invalid IRQ requests during AHB probe
Date: Tue, 21 Jul 2026 16:55:41 +0200
Message-ID: <20260721152554.295453985@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit 590182b72213ef04977ab0b16b8dadfcfd25ff73 ]

ath12k_ahb_config_ext_irq() iterates over ATH12K_EXT_IRQ_NUM_MAX (16)
entries while checking TX ring masks, but the tcl_to_wbm_rbm_map array
contains only DP_TCL_NUM_RING_MAX (4) valid elements.

When the iterator (j) is greater than or equal to DP_TCL_NUM_RING_MAX,
it accesses tcl_to_wbm_rbm_map[j] out of bounds. This results in
reading uninitialized memory for wbm_ring_num, causing the driver to
evaluate incorrect BIT() conditions and request IRQs for rings that do
not have an assigned interrupt line or device tree entry.

This leads to request_irq() failures with -ENXIO or -EINVAL during
ath12k AHB probe.

Fix this by splitting the loop into two separate loops: one iterating
over DP_TCL_NUM_RING_MAX for TX ring, and another iterating over
ATH12K_EXT_IRQ_NUM_MAX for remaining IRQ entries.
Also add a bounds check for num_irq.

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01275-QCAHKSWPL_SILICONZ-1

Fixes: 6cee30f0da75 ("wifi: ath12k: add AHB driver support for IPQ5332")
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260414062829.2371761-1-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/ahb.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index 2dcf0a52e4c15b..30733a244454e5 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -583,31 +583,36 @@ static int ath12k_ahb_config_ext_irq(struct ath12k_base *ab)
 		netif_napi_add(irq_grp->napi_ndev, &irq_grp->napi,
 			       ath12k_ahb_ext_grp_napi_poll);
 
-		for (j = 0; j < ATH12K_EXT_IRQ_NUM_MAX; j++) {
-			/* For TX ring, ensure that the ring mask and the
-			 * tcl_to_wbm_rbm_map point to the same ring number.
-			 */
+		for (j = 0; j < DP_TCL_NUM_RING_MAX; j++) {
 			if (ring_mask->tx[i] &
-			    BIT(ab->hal.tcl_to_wbm_rbm_map[j].wbm_ring_num)) {
+			    BIT(ab->hal.tcl_to_wbm_rbm_map[j].wbm_ring_num) &&
+			    num_irq < ATH12K_EXT_IRQ_NUM_MAX) {
 				irq_grp->irqs[num_irq++] =
 					wbm2host_tx_completions_ring1 - j;
 			}
+		}
 
-			if (ring_mask->rx[i] & BIT(j)) {
+		for (j = 0; j < ATH12K_EXT_IRQ_NUM_MAX; j++) {
+			if (ring_mask->rx[i] & BIT(j) &&
+			    num_irq < ATH12K_EXT_IRQ_NUM_MAX) {
 				irq_grp->irqs[num_irq++] =
 					reo2host_destination_ring1 - j;
 			}
 
-			if (ring_mask->rx_err[i] & BIT(j))
+			if (ring_mask->rx_err[i] & BIT(j) &&
+			    num_irq < ATH12K_EXT_IRQ_NUM_MAX)
 				irq_grp->irqs[num_irq++] = reo2host_exception;
 
-			if (ring_mask->rx_wbm_rel[i] & BIT(j))
+			if (ring_mask->rx_wbm_rel[i] & BIT(j) &&
+			    num_irq < ATH12K_EXT_IRQ_NUM_MAX)
 				irq_grp->irqs[num_irq++] = wbm2host_rx_release;
 
-			if (ring_mask->reo_status[i] & BIT(j))
+			if (ring_mask->reo_status[i] & BIT(j) &&
+			    num_irq < ATH12K_EXT_IRQ_NUM_MAX)
 				irq_grp->irqs[num_irq++] = reo2host_status;
 
-			if (ring_mask->rx_mon_dest[i] & BIT(j))
+			if (ring_mask->rx_mon_dest[i] & BIT(j) &&
+			    num_irq < ATH12K_EXT_IRQ_NUM_MAX)
 				irq_grp->irqs[num_irq++] =
 					rxdma2host_monitor_destination_mac1;
 		}
-- 
2.53.0



