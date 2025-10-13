Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF1B239562;
	Mon, 13 Oct 2025 15:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370361; cv=none; b=aq12zT6nanoCAYXEcAS5QIagGmkORwTxrjJWmoSbm48HRDOjqkz1UI6fwXBz4eT/a1pMd19xuoNsGhypO0ICSxtNRqbPqp4Y+FXqUwkrjXlirhjfEQUp+bGBE8+GyHm396UyyUUAb/aRjH6LgKHIsf/GUxwNcnhqzjEMu3VZKNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370361; c=relaxed/simple;
	bh=QsnSZG33xeU78i1znCdCyWjQxXoHhmUnGSAqGRysCBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8MvfTiO+k2386n70FhNiIA/tCd/ao71Ls0A32z6dzjphx9hGSPPyzBV+rCabNPBQro9AMiZ5T5sKD9DoseWT/BF0fVzXbcz/8MlpOOPOoKlIYSTOVrRbHhGbMUKXZy52d5Rz+5QYBkcdCGcEOtSKUgKQ7ByL4chIuYd07Bs8yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNsGMNt7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNsGMNt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A01C4CEE7;
	Mon, 13 Oct 2025 15:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370361;
	bh=QsnSZG33xeU78i1znCdCyWjQxXoHhmUnGSAqGRysCBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNsGMNt715SNPTThdiEmXAmT5pTE26AAaQAgLUudWfv2xoib8J0aPLFUIE/IPq3yE
	 alX91LdYSLnG8rLP26AcMg1qoienPWJSklgmHJk6HytjehnjePdWghV2YDuyGASkCO
	 9EOflwnfJlbbV8gPVS/+K2h5iF/rNDgLHIa9cgxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.17 562/563] scsi: ufs: core: Fix PM QoS mutex initialization
Date: Mon, 13 Oct 2025 16:47:03 +0200
Message-ID: <20251013144431.663629270@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 0ba7a254afd037cfc2b656f379c54b43c6e574e8 upstream.

hba->pm_qos_mutex is used very early as a part of ufshcd_init(), so it
need to be initialized before that call. This fixes the following
warning:

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(lock->magic != lock)
WARNING: kernel/locking/mutex.c:577 at __mutex_lock+0x268/0x894, CPU#4: kworker/u32:4/72
Modules linked in:
CPU: 4 UID: 0 PID: 72 Comm: kworker/u32:4 Not tainted 6.17.0-rc7-next-20250926+ #11223 PREEMPT
Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
Workqueue: events_unbound deferred_probe_work_func
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __mutex_lock+0x268/0x894
lr : __mutex_lock+0x268/0x894
...
Call trace:
 __mutex_lock+0x268/0x894 (P)
 mutex_lock_nested+0x24/0x30
 ufshcd_pm_qos_update+0x30/0x78
 ufshcd_setup_clocks+0x2d4/0x3c4
 ufshcd_init+0x234/0x126c
 ufshcd_pltfrm_init+0x62c/0x82c
 ufs_qcom_probe+0x20/0x58
 platform_probe+0x5c/0xac
 really_probe+0xbc/0x298
 __driver_probe_device+0x78/0x12c
 driver_probe_device+0x40/0x164
 __device_attach_driver+0xb8/0x138
 bus_for_each_drv+0x80/0xdc
 __device_attach+0xa8/0x1b0
 device_initial_probe+0x14/0x20
 bus_probe_device+0xb0/0xb4
 deferred_probe_work_func+0x8c/0xc8
 process_one_work+0x208/0x60c
 worker_thread+0x244/0x388
 kthread+0x150/0x228
 ret_from_fork+0x10/0x20
irq event stamp: 57267
hardirqs last  enabled at (57267): [<ffffd761485e868c>] _raw_spin_unlock_irqrestore+0x74/0x78
hardirqs last disabled at (57266): [<ffffd76147b13c44>] clk_enable_lock+0x7c/0xf0
softirqs last  enabled at (56270): [<ffffd7614734446c>] handle_softirqs+0x4c4/0x4dc
softirqs last disabled at (56265): [<ffffd76147290690>] __do_softirq+0x14/0x20
---[ end trace 0000000000000000 ]---

Fixes: 79dde5f7dc7c ("scsi: ufs: core: Fix data race in CPU latency PM QoS request handling")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Message-Id: <20250929112730.3782765-1-m.szyprowski@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10674,6 +10674,9 @@ int ufshcd_init(struct ufs_hba *hba, voi
 	 */
 	spin_lock_init(&hba->clk_gating.lock);
 
+	/* Initialize mutex for PM QoS request synchronization */
+	mutex_init(&hba->pm_qos_mutex);
+
 	/*
 	 * Set the default power management level for runtime and system PM.
 	 * Host controller drivers can override them in their
@@ -10762,9 +10765,6 @@ int ufshcd_init(struct ufs_hba *hba, voi
 
 	mutex_init(&hba->wb_mutex);
 
-	/* Initialize mutex for PM QoS request synchronization */
-	mutex_init(&hba->pm_qos_mutex);
-
 	init_rwsem(&hba->clk_scaling_lock);
 
 	ufshcd_init_clk_gating(hba);


