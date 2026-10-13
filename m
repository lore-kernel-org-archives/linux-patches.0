Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C5D282F2A;
	Tue, 13 Oct 2026 12:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894613; cv=none; b=TDo3TbjLQGBkhoIWpSeOJdmjvEJkFuCFPnCYdsc3DbzUS2AlMKk9I6x1M+KmgNZlAzszOLyQWvjemw7gPifR1EGplS6MTSvkGgIpm/oZ88CSBcka6udh7O4VGfsQgCxNZSfkIt39BqjwmEE/FKlrv6feHW87m9qTLK+a+0QY4Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894613; c=relaxed/simple;
	bh=nZKgALRC2zdr2WlNuAapMXULFZGxduHoxFwX5tsf4ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncmb2AC/1MKdEmezWoIfsS0bNttGF0MveWXG4pCDL+6DvnCM2fZ9ulOG2ihwuES37lwI3Xqs3iv/7j2VYx4tR7OTySqZZYEF2eeCN3Dv2g6c9+YBs2qxvylW4JcPaDgiE5fuF1/VSXUf47Y+1q4IpM4GC9ykmDJB+PNbjQkJaDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEINWmA3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEINWmA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74DD1F00893;
	Tue, 13 Oct 2026 12:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894612;
	bh=H8VEwjmNC9lZ/C0uTTMPOhO12vtV0N4nCL6k5ycOWrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BEINWmA3ikTqN+vHRfubdAbLIFUXsncCjQPuwbNlBOh+skxXakJ15Q8jjwxDsJvd2
	 lNK4ekagEvqe+maN98+hWXq6aghiDE3cUs3CbJT/pgHYHs8RRaM7kY2HX3OoYckw8k
	 i24kW/GO+EXdLYXKKyLj/fa4GmPkmo/xt1AuyMPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>
Subject: [PATCH 6.18 617/621] accel/amdxdna: Fix race condition when checking rpm_on
Date: Tue, 13 Oct 2026 13:40:12 +0200
Message-ID: <20261013112935.441640626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

commit 00ffe45ece80160aef446d74ded906352f21dd72 upstream.

When autosuspend is triggered, driver rpm_on flag is set to indicate that
a suspend/resume is already in progress. However, when a userspace
application submits a command during this narrow window,
amdxdna_pm_resume_get() may incorrectly skip the resume operation because
the rpm_on flag is still set. This results in commands being submitted
while the device has not actually resumed, causing unexpected behavior.

The set_dpm() is called by suspend/resume, it relied on rpm_on flag to
avoid calling into rpm suspend/resume recursivly. So to fix this, remove
the use of the rpm_on flag entirely. Instead, introduce aie2_pm_set_dpm()
which explicitly resumes the device before invoking set_dpm(). With this
change, set_dpm() is called directly inside the suspend or resume execution
path. Otherwise, aie2_pm_set_dpm() is called.

Fixes: 063db451832b ("accel/amdxdna: Enhance runtime power management")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20251208165356.1549237-1-lizhi.hou@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/amdxdna/aie2_message.c    |    1 -
 drivers/accel/amdxdna/aie2_pci.c        |    2 +-
 drivers/accel/amdxdna/aie2_pci.h        |    1 +
 drivers/accel/amdxdna/aie2_pm.c         |   17 ++++++++++++++++-
 drivers/accel/amdxdna/aie2_smu.c        |   27 ++++-----------------------
 drivers/accel/amdxdna/amdxdna_pci_drv.h |    1 -
 drivers/accel/amdxdna/amdxdna_pm.c      |   22 ++--------------------
 7 files changed, 24 insertions(+), 47 deletions(-)

--- a/drivers/accel/amdxdna/aie2_message.c
+++ b/drivers/accel/amdxdna/aie2_message.c
@@ -37,7 +37,6 @@ static int aie2_send_mgmt_msg_wait(struc
 	if (!ndev->mgmt_chann)
 		return -ENODEV;
 
-	drm_WARN_ON(&xdna->ddev, xdna->rpm_on && !mutex_is_locked(&xdna->dev_lock));
 	ret = xdna_send_msg_wait(xdna, ndev->mgmt_chann, msg);
 	if (ret == -ETIME)
 		aie2_destroy_mgmt_chann(ndev);
--- a/drivers/accel/amdxdna/aie2_pci.c
+++ b/drivers/accel/amdxdna/aie2_pci.c
@@ -306,7 +306,7 @@ static int aie2_xrs_set_dft_dpm_level(st
 	if (ndev->pw_mode != POWER_MODE_DEFAULT || ndev->dpm_level == dpm_level)
 		return 0;
 
-	return ndev->priv->hw_ops.set_dpm(ndev, dpm_level);
+	return aie2_pm_set_dpm(ndev, dpm_level);
 }
 
 static struct xrs_action_ops aie2_xrs_actions = {
--- a/drivers/accel/amdxdna/aie2_pci.h
+++ b/drivers/accel/amdxdna/aie2_pci.h
@@ -247,6 +247,7 @@ int npu4_set_dpm(struct amdxdna_dev_hdl
 /* aie2_pm.c */
 int aie2_pm_init(struct amdxdna_dev_hdl *ndev);
 int aie2_pm_set_mode(struct amdxdna_dev_hdl *ndev, enum amdxdna_power_mode_type target);
+int aie2_pm_set_dpm(struct amdxdna_dev_hdl *ndev, u32 dpm_level);
 
 /* aie2_psp.c */
 struct psp_device *aie2m_psp_create(struct drm_device *ddev, struct psp_config *conf);
--- a/drivers/accel/amdxdna/aie2_pm.c
+++ b/drivers/accel/amdxdna/aie2_pm.c
@@ -10,6 +10,7 @@
 
 #include "aie2_pci.h"
 #include "amdxdna_pci_drv.h"
+#include "amdxdna_pm.h"
 
 #define AIE2_CLK_GATING_ENABLE	1
 #define AIE2_CLK_GATING_DISABLE	0
@@ -26,6 +27,20 @@ static int aie2_pm_set_clk_gating(struct
 	return 0;
 }
 
+int aie2_pm_set_dpm(struct amdxdna_dev_hdl *ndev, u32 dpm_level)
+{
+	int ret;
+
+	ret = amdxdna_pm_resume_get(ndev->xdna);
+	if (ret)
+		return ret;
+
+	ret = ndev->priv->hw_ops.set_dpm(ndev, dpm_level);
+	amdxdna_pm_suspend_put(ndev->xdna);
+
+	return ret;
+}
+
 int aie2_pm_init(struct amdxdna_dev_hdl *ndev)
 {
 	int ret;
@@ -94,7 +109,7 @@ int aie2_pm_set_mode(struct amdxdna_dev_
 		return -EOPNOTSUPP;
 	}
 
-	ret = ndev->priv->hw_ops.set_dpm(ndev, dpm_level);
+	ret = aie2_pm_set_dpm(ndev, dpm_level);
 	if (ret)
 		return ret;
 
--- a/drivers/accel/amdxdna/aie2_smu.c
+++ b/drivers/accel/amdxdna/aie2_smu.c
@@ -11,7 +11,6 @@
 
 #include "aie2_pci.h"
 #include "amdxdna_pci_drv.h"
-#include "amdxdna_pm.h"
 
 #define SMU_RESULT_OK		1
 
@@ -67,16 +66,12 @@ int npu1_set_dpm(struct amdxdna_dev_hdl
 	u32 freq;
 	int ret;
 
-	ret = amdxdna_pm_resume_get(ndev->xdna);
-	if (ret)
-		return ret;
-
 	ret = aie2_smu_exec(ndev, AIE2_SMU_SET_MPNPUCLK_FREQ,
 			    ndev->priv->dpm_clk_tbl[dpm_level].npuclk, &freq);
 	if (ret) {
 		XDNA_ERR(ndev->xdna, "Set npu clock to %d failed, ret %d\n",
 			 ndev->priv->dpm_clk_tbl[dpm_level].npuclk, ret);
-		goto suspend_put;
+		return ret;
 	}
 	ndev->npuclk_freq = freq;
 
@@ -85,10 +80,9 @@ int npu1_set_dpm(struct amdxdna_dev_hdl
 	if (ret) {
 		XDNA_ERR(ndev->xdna, "Set h clock to %d failed, ret %d\n",
 			 ndev->priv->dpm_clk_tbl[dpm_level].hclk, ret);
-		goto suspend_put;
+		return ret;
 	}
 
-	amdxdna_pm_suspend_put(ndev->xdna);
 	ndev->hclk_freq = freq;
 	ndev->dpm_level = dpm_level;
 	ndev->max_tops = 2 * ndev->total_col;
@@ -98,35 +92,26 @@ int npu1_set_dpm(struct amdxdna_dev_hdl
 		 ndev->npuclk_freq, ndev->hclk_freq);
 
 	return 0;
-
-suspend_put:
-	amdxdna_pm_suspend_put(ndev->xdna);
-	return ret;
 }
 
 int npu4_set_dpm(struct amdxdna_dev_hdl *ndev, u32 dpm_level)
 {
 	int ret;
 
-	ret = amdxdna_pm_resume_get(ndev->xdna);
-	if (ret)
-		return ret;
-
 	ret = aie2_smu_exec(ndev, AIE2_SMU_SET_HARD_DPMLEVEL, dpm_level, NULL);
 	if (ret) {
 		XDNA_ERR(ndev->xdna, "Set hard dpm level %d failed, ret %d ",
 			 dpm_level, ret);
-		goto suspend_put;
+		return ret;
 	}
 
 	ret = aie2_smu_exec(ndev, AIE2_SMU_SET_SOFT_DPMLEVEL, dpm_level, NULL);
 	if (ret) {
 		XDNA_ERR(ndev->xdna, "Set soft dpm level %d failed, ret %d",
 			 dpm_level, ret);
-		goto suspend_put;
+		return ret;
 	}
 
-	amdxdna_pm_suspend_put(ndev->xdna);
 	ndev->npuclk_freq = ndev->priv->dpm_clk_tbl[dpm_level].npuclk;
 	ndev->hclk_freq = ndev->priv->dpm_clk_tbl[dpm_level].hclk;
 	ndev->dpm_level = dpm_level;
@@ -137,10 +122,6 @@ int npu4_set_dpm(struct amdxdna_dev_hdl
 		 ndev->npuclk_freq, ndev->hclk_freq);
 
 	return 0;
-
-suspend_put:
-	amdxdna_pm_suspend_put(ndev->xdna);
-	return ret;
 }
 
 int aie2_smu_init(struct amdxdna_dev_hdl *ndev)
--- a/drivers/accel/amdxdna/amdxdna_pci_drv.h
+++ b/drivers/accel/amdxdna/amdxdna_pci_drv.h
@@ -100,7 +100,6 @@ struct amdxdna_dev {
 	struct amdxdna_fw_ver		fw_ver;
 	struct rw_semaphore		notifier_lock; /* for mmu notifier*/
 	struct workqueue_struct		*notifier_wq;
-	bool				rpm_on;
 };
 
 /*
--- a/drivers/accel/amdxdna/amdxdna_pm.c
+++ b/drivers/accel/amdxdna/amdxdna_pm.c
@@ -15,14 +15,9 @@ int amdxdna_pm_suspend(struct device *de
 {
 	struct amdxdna_dev *xdna = to_xdna_dev(dev_get_drvdata(dev));
 	int ret = -EOPNOTSUPP;
-	bool rpm;
 
-	if (xdna->dev_info->ops->suspend) {
-		rpm = xdna->rpm_on;
-		xdna->rpm_on = false;
+	if (xdna->dev_info->ops->suspend)
 		ret = xdna->dev_info->ops->suspend(xdna);
-		xdna->rpm_on = rpm;
-	}
 
 	XDNA_DBG(xdna, "Suspend done ret %d", ret);
 	return ret;
@@ -32,14 +27,9 @@ int amdxdna_pm_resume(struct device *dev
 {
 	struct amdxdna_dev *xdna = to_xdna_dev(dev_get_drvdata(dev));
 	int ret = -EOPNOTSUPP;
-	bool rpm;
 
-	if (xdna->dev_info->ops->resume) {
-		rpm = xdna->rpm_on;
-		xdna->rpm_on = false;
+	if (xdna->dev_info->ops->resume)
 		ret = xdna->dev_info->ops->resume(xdna);
-		xdna->rpm_on = rpm;
-	}
 
 	XDNA_DBG(xdna, "Resume done ret %d", ret);
 	return ret;
@@ -50,9 +40,6 @@ int amdxdna_pm_resume_get(struct amdxdna
 	struct device *dev = xdna->ddev.dev;
 	int ret;
 
-	if (!xdna->rpm_on)
-		return 0;
-
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret) {
 		XDNA_ERR(xdna, "Resume failed: %d", ret);
@@ -66,9 +53,6 @@ void amdxdna_pm_suspend_put(struct amdxd
 {
 	struct device *dev = xdna->ddev.dev;
 
-	if (!xdna->rpm_on)
-		return;
-
 	pm_runtime_put_autosuspend(dev);
 }
 
@@ -81,14 +65,12 @@ void amdxdna_pm_init(struct amdxdna_dev
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_allow(dev);
 	pm_runtime_put_autosuspend(dev);
-	xdna->rpm_on = true;
 }
 
 void amdxdna_pm_fini(struct amdxdna_dev *xdna)
 {
 	struct device *dev = xdna->ddev.dev;
 
-	xdna->rpm_on = false;
 	pm_runtime_get_noresume(dev);
 	pm_runtime_forbid(dev);
 }


