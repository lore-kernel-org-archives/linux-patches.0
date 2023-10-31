Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF85208CF
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7kDKGuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD14AC433C7;
	Tue, 31 Oct 2023 17:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774630;
	bh=/WhrXBozo3fDBTD0n8HtPSes2fKtG6j5LLjZM3z4P3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7kDKGuCCOcdG0aSHWLKeIeyaylkm2Fxwxeoc8GLJSOsvQwMLY2aB3GlACGRnENmq
	 cQxeWRr81ssfKAjJLmUT3xxWO3bCOwk4h55x8vjYnrL88Rk6mPdYuDYbgj2A7yiLXH
	 b+vGNGI/EbMPiCpdtjwevCldDyKXtt9SL79yIBNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Subject: [PATCH 6.5 112/112] accel/ivpu/37xx: Fix missing VPUIP interrupts
Date: Tue, 31 Oct 2023 18:01:53 +0100
Message-ID: <20231031165904.797819526@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@linux.intel.com>

commit b132ac51d7a50c37683be56c96ff64f8c887930f upstream.

Move sequence of masking and unmasking global interrupts from buttress
interrupt handler to generic one that handles both VPUIP and BTRS
interrupts. Unmasking global interrupts will re-trigger MSI for any
pending interrupts.

Lack of this sequence will cause the driver to miss any
VPUIP interrupt that comes after reading VPU_37XX_HOST_SS_ICB_STATUS_0
and before clearing all active interrupt sources.

Fixes: 35b137630f08 ("accel/ivpu: Introduce a new DRM driver for Intel VPU")
Cc: stable@vger.kernel.org
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231024161952.759914-1-stanislaw.gruszka@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_hw_mtl.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/accel/ivpu/ivpu_hw_mtl.c
+++ b/drivers/accel/ivpu/ivpu_hw_mtl.c
@@ -953,9 +953,6 @@ static u32 ivpu_hw_mtl_irqb_handler(stru
 	if (status == 0)
 		return 0;
 
-	/* Disable global interrupt before handling local buttress interrupts */
-	REGB_WR32(MTL_BUTTRESS_GLOBAL_INT_MASK, 0x1);
-
 	if (REG_TEST_FLD(MTL_BUTTRESS_INTERRUPT_STAT, FREQ_CHANGE, status))
 		ivpu_dbg(vdev, IRQ, "FREQ_CHANGE irq: %08x", REGB_RD32(MTL_BUTTRESS_CURRENT_PLL));
 
@@ -986,9 +983,6 @@ static u32 ivpu_hw_mtl_irqb_handler(stru
 	else
 		REGB_WR32(MTL_BUTTRESS_INTERRUPT_STAT, status);
 
-	/* Re-enable global interrupt */
-	REGB_WR32(MTL_BUTTRESS_GLOBAL_INT_MASK, 0x0);
-
 	if (schedule_recovery)
 		ivpu_pm_schedule_recovery(vdev);
 
@@ -1000,9 +994,14 @@ static irqreturn_t ivpu_hw_mtl_irq_handl
 	struct ivpu_device *vdev = ptr;
 	u32 ret_irqv, ret_irqb;
 
+	REGB_WR32(MTL_BUTTRESS_GLOBAL_INT_MASK, 0x1);
+
 	ret_irqv = ivpu_hw_mtl_irqv_handler(vdev, irq);
 	ret_irqb = ivpu_hw_mtl_irqb_handler(vdev, irq);
 
+	/* Re-enable global interrupts to re-trigger MSI for pending interrupts */
+	REGB_WR32(MTL_BUTTRESS_GLOBAL_INT_MASK, 0x0);
+
 	return IRQ_RETVAL(ret_irqb | ret_irqv);
 }
 


