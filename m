Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC7627F1D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27536C433C8;
	Fri, 21 Jul 2023 18:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965437;
	bh=P/QOKet2IXFOzQDsvn9iswRk0oX6SAGOSiSlBmr2c1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOQbXXe+vOf07qnHiUArTZvWQ68g/YShfRgmED2gaRHaSiItzxeTmGZOWfgWO3Q00
	 DnmqgNgWpJaGXP3NtMlGTbQtr9/u6f2pK/6KbmzhGwmXW38kECUx0VxaXcUqvjJNru
	 iH4Mlsx5csCwwqymxQ3AOm7UIUIfVKA+jbU2aO58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Subject: [PATCH 6.4 255/292] accel/ivpu: Clear specific interrupt status bits on C0
Date: Fri, 21 Jul 2023 18:06:04 +0200
Message-ID: <20230721160539.894596981@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Karol Wachowski <karol.wachowski@linux.intel.com>

commit 7f34e01f77f811ecb2ef83e60301b38cf89af466 upstream.

MTL C0 stepping fixed issue related to butrress interrupt status clearing,
to clear an interrupt status it is required to write 1 to specific
status bit field. This allows to execute read, modify and write routine.

Writing 0 will not clear the interrupt and will cause interrupt storm.

Fixes: 35b137630f08 ("accel/ivpu: Introduce a new DRM driver for Intel VPU")
Cc: stable@vger.kernel.org # 6.3.x
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230703080725.2065635-2-stanislaw.gruszka@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_drv.h    |    1 +
 drivers/accel/ivpu/ivpu_hw_mtl.c |   18 ++++++++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/accel/ivpu/ivpu_drv.h
+++ b/drivers/accel/ivpu/ivpu_drv.h
@@ -75,6 +75,7 @@ struct ivpu_wa_table {
 	bool punit_disabled;
 	bool clear_runtime_mem;
 	bool d3hot_after_power_off;
+	bool interrupt_clear_with_0;
 };
 
 struct ivpu_hw_info;
--- a/drivers/accel/ivpu/ivpu_hw_mtl.c
+++ b/drivers/accel/ivpu/ivpu_hw_mtl.c
@@ -101,6 +101,9 @@ static void ivpu_hw_wa_init(struct ivpu_
 	vdev->wa.punit_disabled = ivpu_is_fpga(vdev);
 	vdev->wa.clear_runtime_mem = false;
 	vdev->wa.d3hot_after_power_off = true;
+
+	if (ivpu_device_id(vdev) == PCI_DEVICE_ID_MTL && ivpu_revision(vdev) < 4)
+		vdev->wa.interrupt_clear_with_0 = true;
 }
 
 static void ivpu_hw_timeouts_init(struct ivpu_device *vdev)
@@ -973,12 +976,15 @@ static u32 ivpu_hw_mtl_irqb_handler(stru
 		schedule_recovery = true;
 	}
 
-	/*
-	 * Clear local interrupt status by writing 0 to all bits.
-	 * This must be done after interrupts are cleared at the source.
-	 * Writing 1 triggers an interrupt, so we can't perform read update write.
-	 */
-	REGB_WR32(MTL_BUTTRESS_INTERRUPT_STAT, 0x0);
+	/* This must be done after interrupts are cleared at the source. */
+	if (IVPU_WA(interrupt_clear_with_0))
+		/*
+		 * Writing 1 triggers an interrupt, so we can't perform read update write.
+		 * Clear local interrupt status by writing 0 to all bits.
+		 */
+		REGB_WR32(MTL_BUTTRESS_INTERRUPT_STAT, 0x0);
+	else
+		REGB_WR32(MTL_BUTTRESS_INTERRUPT_STAT, status);
 
 	/* Re-enable global interrupt */
 	REGB_WR32(MTL_BUTTRESS_GLOBAL_INT_MASK, 0x0);


