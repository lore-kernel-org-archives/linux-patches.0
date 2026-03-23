Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17441A680D;
	Mon, 23 Mar 2026 13:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274143; cv=none; b=Az7OEoAVvtm2uF5FEKuuIS+ogA55ylVVOX8tAPsLxg8YBn3KSOpo+AFPxUC+t3DCkNo7VmsoF7OyFRHugRGLFIZUJ/SlHb62ifufm180vaf+TYCJkg3TWS70iPqE+MFiZO3/HWqAKtaubEcZUat71E43iyhS4m1hRQm9f14VGYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274143; c=relaxed/simple;
	bh=oOhQeBEDwVc5bpF9lSODLhA3e4VNHYcOmG+zpJ1FTdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dr+kDn0wZPKRSDxl0BMJjB/qWAmfYqRcg1N2nwarSK0/k+eNGdX3rKfFwaFsuGd8pblQJ0wYDLGV/aBlyhcR2LttLWU3PspxIbp2inO2Lq8Z6yMGDHCpFDPje0qZZPZrZHa2mUW0kiLFtUGPx9ebAWO/zSKXF8djX8G2Px8lt3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFERbcUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFERbcUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E91C4CEF7;
	Mon, 23 Mar 2026 13:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274143;
	bh=oOhQeBEDwVc5bpF9lSODLhA3e4VNHYcOmG+zpJ1FTdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFERbcUHsUCRCHUQ6hmeOlrvZo5hF3e0IQXSVVvu9zbTdfOpBYnh+HLKuNRCDqK0X
	 hfWE3lLk3PcGBoiuNGP4l7bUHugipLRU9FKm2/trnJxDdHh9FhD+XMokVlCg0YeIUs
	 0dyMeLlg6W8xMKJAhfOMX0wlIFsOGe/O2V+hv3z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Belle <alessio.belle@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>
Subject: [PATCH 6.19 081/220] drm/imagination: Synchronize interrupts before suspending the GPU
Date: Mon, 23 Mar 2026 14:44:18 +0100
Message-ID: <20260323134507.156936677@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessio Belle <alessio.belle@imgtec.com>

commit 2d7f05cddf4c268cc36256a2476946041dbdd36d upstream.

The runtime PM suspend callback doesn't know whether the IRQ handler is
in progress on a different CPU core and doesn't wait for it to finish.

Depending on timing, the IRQ handler could be running while the GPU is
suspended, leading to kernel crashes when trying to access GPU
registers. See example signature below.

In a power off sequence initiated by the runtime PM suspend callback,
wait for any IRQ handlers in progress on other CPU cores to finish, by
calling synchronize_irq().

At the same time, remove the runtime PM resume/put calls in the threaded
IRQ handler. On top of not being the right approach to begin with, and
being at the wrong place as they should have wrapped all GPU register
accesses, the driver would hit a deadlock between synchronize_irq()
being called from a runtime PM suspend callback, holding the device
power lock, and the resume callback requiring the same.

Example crash signature on a TI AM68 SK platform:

  [  337.241218] SError Interrupt on CPU0, code 0x00000000bf000000 -- SError
  [  337.241239] CPU: 0 UID: 0 PID: 112 Comm: irq/234-gpu Tainted: G   M                6.17.7-B2C-00005-g9c7bbe4ea16c #2 PREEMPT
  [  337.241246] Tainted: [M]=MACHINE_CHECK
  [  337.241249] Hardware name: Texas Instruments AM68 SK (DT)
  [  337.241252] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  [  337.241256] pc : pvr_riscv_irq_pending+0xc/0x24
  [  337.241277] lr : pvr_device_irq_thread_handler+0x64/0x310
  [  337.241282] sp : ffff800085b0bd30
  [  337.241284] x29: ffff800085b0bd50 x28: ffff0008070d9eab x27: ffff800083a5ce10
  [  337.241291] x26: ffff000806e48f80 x25: ffff0008070d9eac x24: 0000000000000000
  [  337.241296] x23: ffff0008068e9bf0 x22: ffff0008068e9bd0 x21: ffff800085b0bd30
  [  337.241301] x20: ffff0008070d9e00 x19: ffff0008068e9000 x18: 0000000000000001
  [  337.241305] x17: 637365645f656c70 x16: 0000000000000000 x15: ffff000b7df9ff40
  [  337.241310] x14: 0000a585fe3c0d0e x13: 000000999704f060 x12: 000000000002771a
  [  337.241314] x11: 00000000000000c0 x10: 0000000000000af0 x9 : ffff800085b0bd00
  [  337.241318] x8 : ffff0008071175d0 x7 : 000000000000b955 x6 : 0000000000000003
  [  337.241323] x5 : 0000000000000000 x4 : 0000000000000002 x3 : 0000000000000000
  [  337.241327] x2 : ffff800080e39d20 x1 : ffff800080e3fc48 x0 : 0000000000000000
  [  337.241333] Kernel panic - not syncing: Asynchronous SError Interrupt
  [  337.241337] CPU: 0 UID: 0 PID: 112 Comm: irq/234-gpu Tainted: G   M                6.17.7-B2C-00005-g9c7bbe4ea16c #2 PREEMPT
  [  337.241342] Tainted: [M]=MACHINE_CHECK
  [  337.241343] Hardware name: Texas Instruments AM68 SK (DT)
  [  337.241345] Call trace:
  [  337.241348]  show_stack+0x18/0x24 (C)
  [  337.241357]  dump_stack_lvl+0x60/0x80
  [  337.241364]  dump_stack+0x18/0x24
  [  337.241368]  vpanic+0x124/0x2ec
  [  337.241373]  abort+0x0/0x4
  [  337.241377]  add_taint+0x0/0xbc
  [  337.241384]  arm64_serror_panic+0x70/0x80
  [  337.241389]  do_serror+0x3c/0x74
  [  337.241392]  el1h_64_error_handler+0x30/0x48
  [  337.241400]  el1h_64_error+0x6c/0x70
  [  337.241404]  pvr_riscv_irq_pending+0xc/0x24 (P)
  [  337.241410]  irq_thread_fn+0x2c/0xb0
  [  337.241416]  irq_thread+0x170/0x334
  [  337.241421]  kthread+0x12c/0x210
  [  337.241428]  ret_from_fork+0x10/0x20
  [  337.241434] SMP: stopping secondary CPUs
  [  337.241451] Kernel Offset: disabled
  [  337.241453] CPU features: 0x040000,02002800,20002001,0400421b
  [  337.241456] Memory Limit: none
  [  337.457921] ---[ end Kernel panic - not syncing: Asynchronous SError Interrupt ]---

Fixes: cc1aeedb98ad ("drm/imagination: Implement firmware infrastructure and META FW support")
Fixes: 96822d38ff57 ("drm/imagination: Handle Rogue safety event IRQs")
Cc: stable@vger.kernel.org # see patch description, needs adjustments for < 6.16
Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patch.msgid.link/20260310-drain-irqs-before-suspend-v1-1-bf4f9ed68e75@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_device.c |   17 -----------------
 drivers/gpu/drm/imagination/pvr_power.c  |   11 ++++++++---
 2 files changed, 8 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/imagination/pvr_device.c
+++ b/drivers/gpu/drm/imagination/pvr_device.c
@@ -224,29 +224,12 @@ static irqreturn_t pvr_device_irq_thread
 	}
 
 	if (pvr_dev->has_safety_events) {
-		int err;
-
-		/*
-		 * Ensure the GPU is powered on since some safety events (such
-		 * as ECC faults) can happen outside of job submissions, which
-		 * are otherwise the only time a power reference is held.
-		 */
-		err = pvr_power_get(pvr_dev);
-		if (err) {
-			drm_err_ratelimited(drm_dev,
-					    "%s: could not take power reference (%d)\n",
-					    __func__, err);
-			return ret;
-		}
-
 		while (pvr_device_safety_irq_pending(pvr_dev)) {
 			pvr_device_safety_irq_clear(pvr_dev);
 			pvr_device_handle_safety_events(pvr_dev);
 
 			ret = IRQ_HANDLED;
 		}
-
-		pvr_power_put(pvr_dev);
 	}
 
 	return ret;
--- a/drivers/gpu/drm/imagination/pvr_power.c
+++ b/drivers/gpu/drm/imagination/pvr_power.c
@@ -90,7 +90,7 @@ pvr_power_request_pwr_off(struct pvr_dev
 }
 
 static int
-pvr_power_fw_disable(struct pvr_device *pvr_dev, bool hard_reset)
+pvr_power_fw_disable(struct pvr_device *pvr_dev, bool hard_reset, bool rpm_suspend)
 {
 	if (!hard_reset) {
 		int err;
@@ -106,6 +106,11 @@ pvr_power_fw_disable(struct pvr_device *
 			return err;
 	}
 
+	if (rpm_suspend) {
+		/* Wait for late processing of GPU or firmware IRQs in other cores */
+		synchronize_irq(pvr_dev->irq);
+	}
+
 	return pvr_fw_stop(pvr_dev);
 }
 
@@ -361,7 +366,7 @@ pvr_power_device_suspend(struct device *
 		return -EIO;
 
 	if (pvr_dev->fw_dev.booted) {
-		err = pvr_power_fw_disable(pvr_dev, false);
+		err = pvr_power_fw_disable(pvr_dev, false, true);
 		if (err)
 			goto err_drm_dev_exit;
 	}
@@ -527,7 +532,7 @@ pvr_power_reset(struct pvr_device *pvr_d
 			queues_disabled = true;
 		}
 
-		err = pvr_power_fw_disable(pvr_dev, hard_reset);
+		err = pvr_power_fw_disable(pvr_dev, hard_reset, false);
 		if (!err) {
 			if (hard_reset) {
 				pvr_dev->fw_dev.booted = false;


