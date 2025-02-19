Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246DA1E25E3;
	Wed, 19 Feb 2025 08:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954651; cv=none; b=WnROq+VIJqNa57+ei5LxF+jNtuyjvhNBzWgjAxp2duSiBza8YFnk4Fc5OF33nKJe+EGgpX5jbGZbpRpWsc1ws41PjB1ZQ603bE2dvuuYFgfeVKBgTz+AugLkTCfsi0n+vuvH0rLVjIV8b8GslL+jaLBkRQOwDOUuyvmi1V106tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954651; c=relaxed/simple;
	bh=MHhzs2wZXiJPNIf5nIJEF+p23/2XhT+v/I+u9hHZa/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZMTjVft3vLAhztYNWUiKRCO3vzCl3maPG/ndl0dhi6UgtmRjNyrQ135MUhCsqWeJOB2hWzJJCtxa+tYmi3V3gHlT3pqf5Zg+8INL2LzUBlOyI2bxCk27xlTE2dtVPF953cofgreGPG/SayinZ/+BVCehZwenuJ5sLJx36UDHho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSORAdcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSORAdcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B81C4CEE6;
	Wed, 19 Feb 2025 08:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954651;
	bh=MHhzs2wZXiJPNIf5nIJEF+p23/2XhT+v/I+u9hHZa/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSORAdcPdrKBCUoSDdpPnFiL8239CJkq/iHdrK8RAf4Iecb1KqDji/VvqdSV0yTSY
	 MwkAivbhiK/hjTYngLlK1hapiVCCylTcj5C58LexYfhryTRRIDWlgZyEgN4XYhbNqp
	 5DLINALhUdt09rsnzhA8SYnJSyqK8QwYKyTac6cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.13 269/274] scsi: ufs: core: Ensure clk_gating.lock is used only after initialization
Date: Wed, 19 Feb 2025 09:28:43 +0100
Message-ID: <20250219082620.115651346@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avri Altman <avri.altman@wdc.com>

commit 3d4114a1d34413dfffa0094c2eb7b95e61087abd upstream.

Address a lockdep warning triggered by the use of the clk_gating.lock before
it is properly initialized. The warning is as follows:

[    4.388838] INFO: trying to register non-static key.
[    4.395673] The code is fine but needs lockdep annotation, or maybe
[    4.402118] you didn't initialize this object before use?
[    4.407673] turning off the locking correctness validator.
[    4.413334] CPU: 5 UID: 0 PID: 58 Comm: kworker/u32:1 Not tainted 6.12-rc1 #185
[    4.413343] Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
[    4.413362] Call trace:
[    4.413364]  show_stack+0x18/0x24 (C)
[    4.413374]  dump_stack_lvl+0x90/0xd0
[    4.413384]  dump_stack+0x18/0x24
[    4.413392]  register_lock_class+0x498/0x4a8
[    4.413400]  __lock_acquire+0xb4/0x1b90
[    4.413406]  lock_acquire+0x114/0x310
[    4.413413]  _raw_spin_lock_irqsave+0x60/0x88
[    4.413423]  ufshcd_setup_clocks+0x2c0/0x490
[    4.413433]  ufshcd_init+0x198/0x10ec
[    4.413437]  ufshcd_pltfrm_init+0x600/0x7c0
[    4.413444]  ufs_qcom_probe+0x20/0x58
[    4.413449]  platform_probe+0x68/0xd8
[    4.413459]  really_probe+0xbc/0x268
[    4.413466]  __driver_probe_device+0x78/0x12c
[    4.413473]  driver_probe_device+0x40/0x11c
[    4.413481]  __device_attach_driver+0xb8/0xf8
[    4.413489]  bus_for_each_drv+0x84/0xe4
[    4.413495]  __device_attach+0xfc/0x18c
[    4.413502]  device_initial_probe+0x14/0x20
[    4.413510]  bus_probe_device+0xb0/0xb4
[    4.413517]  deferred_probe_work_func+0x8c/0xc8
[    4.413524]  process_scheduled_works+0x250/0x658
[    4.413534]  worker_thread+0x15c/0x2c8
[    4.413542]  kthread+0x134/0x200
[    4.413550]  ret_from_fork+0x10/0x20

To fix this issue, ensure that the spinlock is only used after it has been
properly initialized before using it in ufshcd_setup_clocks().  Do that
unconditionally as initializing a spinlock is a fast operation.

Fixes: 209f4e43b806 ("scsi: ufs: core: Introduce a new clock_gating lock")
Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20250128071207.75494-2-avri.altman@wdc.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2126,8 +2126,6 @@ static void ufshcd_init_clk_gating(struc
 	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
 	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
 
-	spin_lock_init(&hba->clk_gating.lock);
-
 	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(
 		"ufs_clk_gating_%d", WQ_MEM_RECLAIM | WQ_HIGHPRI,
 		hba->host->host_no);
@@ -10490,6 +10488,12 @@ int ufshcd_init(struct ufs_hba *hba, voi
 	hba->irq = irq;
 	hba->vps = &ufs_hba_vps;
 
+	/*
+	 * Initialize clk_gating.lock early since it is being used in
+	 * ufshcd_setup_clocks()
+	 */
+	spin_lock_init(&hba->clk_gating.lock);
+
 	err = ufshcd_hba_init(hba);
 	if (err)
 		goto out_error;


