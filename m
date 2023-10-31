Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842DB208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkPGU/rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007D2C433CA;
	Tue, 31 Oct 2023 17:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774415;
	bh=BKe36PPZXho+4TXSgMWLLH1Lc6whtvqfJl4KaANrJeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkPGU/rhPKE3c4p6zxRx8SggwTvKpx1g+lZNQrRZZ2uMVH1KhKxicdcuxJw6yWOdK
	 DEkGaSkByOeeS0dgNy1DRD21jHAKccIqaHO2KFu4U4wk4hGHUUbG/nNfUb1HHhq9SA
	 PNXBfftjv4PNVA95WiyBfUndXrFlFPEJDtMKaSJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Subject: [PATCH 6.5 039/112] accel/ivpu: Dont enter d0i3 during FLR
Date: Tue, 31 Oct 2023 18:00:40 +0100
Message-ID: <20231031165902.545506963@linuxfoundation.org>
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

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit 828d63042aeca132a93938b98dc7f1a6c97bbc51 upstream.

Avoid HW bug on some platforms where we enter D0i3 state
and CPU is in low power states (C8 or above).

Fixes: 852be13f3bd3 ("accel/ivpu: Add PM support")
Cc: stable@vger.kernel.org
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231003064213.1527327-1-stanislaw.gruszka@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_drv.c    |   11 ++++++++---
 drivers/accel/ivpu/ivpu_drv.h    |    1 +
 drivers/accel/ivpu/ivpu_hw.h     |    8 ++++++++
 drivers/accel/ivpu/ivpu_hw_mtl.c |    1 +
 drivers/accel/ivpu/ivpu_pm.c     |    3 ++-
 5 files changed, 20 insertions(+), 4 deletions(-)

--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -343,14 +343,19 @@ int ivpu_boot(struct ivpu_device *vdev)
 	return 0;
 }
 
-int ivpu_shutdown(struct ivpu_device *vdev)
+void ivpu_prepare_for_reset(struct ivpu_device *vdev)
 {
-	int ret;
-
 	ivpu_hw_irq_disable(vdev);
 	disable_irq(vdev->irq);
 	ivpu_ipc_disable(vdev);
 	ivpu_mmu_disable(vdev);
+}
+
+int ivpu_shutdown(struct ivpu_device *vdev)
+{
+	int ret;
+
+	ivpu_prepare_for_reset(vdev);
 
 	ret = ivpu_hw_power_down(vdev);
 	if (ret)
--- a/drivers/accel/ivpu/ivpu_drv.h
+++ b/drivers/accel/ivpu/ivpu_drv.h
@@ -144,6 +144,7 @@ void ivpu_file_priv_put(struct ivpu_file
 
 int ivpu_boot(struct ivpu_device *vdev);
 int ivpu_shutdown(struct ivpu_device *vdev);
+void ivpu_prepare_for_reset(struct ivpu_device *vdev);
 
 static inline bool ivpu_is_mtl(struct ivpu_device *vdev)
 {
--- a/drivers/accel/ivpu/ivpu_hw.h
+++ b/drivers/accel/ivpu/ivpu_hw.h
@@ -13,6 +13,7 @@ struct ivpu_hw_ops {
 	int (*power_up)(struct ivpu_device *vdev);
 	int (*boot_fw)(struct ivpu_device *vdev);
 	int (*power_down)(struct ivpu_device *vdev);
+	int (*reset)(struct ivpu_device *vdev);
 	bool (*is_idle)(struct ivpu_device *vdev);
 	void (*wdt_disable)(struct ivpu_device *vdev);
 	void (*diagnose_failure)(struct ivpu_device *vdev);
@@ -90,6 +91,13 @@ static inline int ivpu_hw_power_down(str
 	return vdev->hw->ops->power_down(vdev);
 };
 
+static inline int ivpu_hw_reset(struct ivpu_device *vdev)
+{
+	ivpu_dbg(vdev, PM, "HW reset\n");
+
+	return vdev->hw->ops->reset(vdev);
+};
+
 static inline void ivpu_hw_wdt_disable(struct ivpu_device *vdev)
 {
 	vdev->hw->ops->wdt_disable(vdev);
--- a/drivers/accel/ivpu/ivpu_hw_mtl.c
+++ b/drivers/accel/ivpu/ivpu_hw_mtl.c
@@ -1041,6 +1041,7 @@ const struct ivpu_hw_ops ivpu_hw_mtl_ops
 	.power_up = ivpu_hw_mtl_power_up,
 	.is_idle = ivpu_hw_mtl_is_idle,
 	.power_down = ivpu_hw_mtl_power_down,
+	.reset = ivpu_hw_mtl_reset,
 	.boot_fw = ivpu_hw_mtl_boot_fw,
 	.wdt_disable = ivpu_hw_mtl_wdt_disable,
 	.diagnose_failure = ivpu_hw_mtl_diagnose_failure,
--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -260,7 +260,8 @@ void ivpu_pm_reset_prepare_cb(struct pci
 
 	ivpu_dbg(vdev, PM, "Pre-reset..\n");
 	atomic_set(&vdev->pm->in_reset, 1);
-	ivpu_shutdown(vdev);
+	ivpu_prepare_for_reset(vdev);
+	ivpu_hw_reset(vdev);
 	ivpu_pm_prepare_cold_boot(vdev);
 	ivpu_jobs_abort_all(vdev);
 	ivpu_dbg(vdev, PM, "Pre-reset done.\n");


