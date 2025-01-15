Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700E3248BD0;
	Wed, 15 Jan 2025 10:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938663; cv=none; b=LwYKVUPYlkx7/0QDFOpBAJRE2T1XgB26kYnCeV0vhLHLvjOxp7iOHc64kI6EQH9g1OXEa+fKdFg9SqH8Wygy2vDQ/mSNBROuthSz5B66fXWPowuYETuLwSzfrfHfR0/JAMBEFkHjHo45pfCduQ99VNlo6zOz5CI5aC2E/R9weKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938663; c=relaxed/simple;
	bh=yljkLy9QFeJ7ouJ6yEjiKnaGOFDzcnkXYPyEa6bmHKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUu6BDEo0jAmTukh9z+S5vLdH/Q6xRW3QeYwBgWtHh+h2Lvzb7J0NHgqgJpUtBkHTkg+Is5GPWcuW/AHtk+h6XS2PsGL3vWzmQmKMXkF5Drm1WxAs5uNywUm1vHu+JaiVt2NTWKi/xOMtP5Mv8M6zJvY3ctNcfujKwjOxNG5tRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bcuo5sAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bcuo5sAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D565AC4CEDF;
	Wed, 15 Jan 2025 10:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938663;
	bh=yljkLy9QFeJ7ouJ6yEjiKnaGOFDzcnkXYPyEa6bmHKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bcuo5sAPiNlhq9ioPila1SexFnDFvy1+fVuthKLbzi0aveSGR6vqB2OhWZVdLuPIv
	 wGDguog0CCeyjiqP1Nv+VKpXbXha6YogvAzrKyJWcHxcUMdRrOOwbPQWgZNvB9M3Pa
	 kY4KtC/e03ekZoXaPyyvfsdsZOXvhvMRSyJf1E94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Amit Pundir <amit.pundir@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.6 059/129] scsi: ufs: qcom: Power off the PHY if it was already powered on in ufs_qcom_power_up_sequence()
Date: Wed, 15 Jan 2025 11:37:14 +0100
Message-ID: <20250115103556.724489969@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit 7bac65687510038390a0a54cbe14fba08d037e46 upstream.

PHY might already be powered on during ufs_qcom_power_up_sequence() in a
couple of cases:

 1. During UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH quirk

 2. Resuming from spm_lvl = 5 suspend

In those cases, it is necessary to call phy_power_off() and phy_exit() in
ufs_qcom_power_up_sequence() function to power off the PHY before calling
phy_init() and phy_power_on().

Case (1) is doing it via ufs_qcom_reinit_notify() callback, but case (2) is
not handled. So to satisfy both cases, call phy_power_off() and phy_exit()
if the phy_count is non-zero. And with this change, the reinit_notify()
callback is no longer needed.

This fixes the below UFS resume failure with spm_lvl = 5:

ufshcd-qcom 1d84000.ufshc: Enabling the controller failed
ufshcd-qcom 1d84000.ufshc: Enabling the controller failed
ufshcd-qcom 1d84000.ufshc: Enabling the controller failed
ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
ufshcd-qcom 1d84000.ufshc: Enabling the controller failed
ufshcd-qcom 1d84000.ufshc: Enabling the controller failed
ufshcd-qcom 1d84000.ufshc: Enabling the controller failed
ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
ufshcd-qcom 1d84000.ufshc: Enabling the controller failed
ufshcd-qcom 1d84000.ufshc: Enabling the controller failed
ufshcd-qcom 1d84000.ufshc: Enabling the controller failed
ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
ufshcd-qcom 1d84000.ufshc: Enabling the controller failed
ufshcd-qcom 1d84000.ufshc: Enabling the controller failed
ufshcd-qcom 1d84000.ufshc: Enabling the controller failed
ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
ufshcd-qcom 1d84000.ufshc: Enabling the controller failed
ufshcd-qcom 1d84000.ufshc: Enabling the controller failed
ufshcd-qcom 1d84000.ufshc: Enabling the controller failed
ufshcd-qcom 1d84000.ufshc: ufshcd_host_reset_and_restore: Host init failed -5
ufs_device_wlun 0:0:0:49488: ufshcd_wl_resume failed: -5
ufs_device_wlun 0:0:0:49488: PM: dpm_run_callback(): scsi_bus_resume returns -5
ufs_device_wlun 0:0:0:49488: PM: failed to resume async: error -5

Cc: stable@vger.kernel.org # 6.3
Fixes: baf5ddac90dc ("scsi: ufs: ufs-qcom: Add support for reinitializing the UFS device")
Reported-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
Tested-by: Amit Pundir <amit.pundir@linaro.org> # on SM8550-HDK
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20241219-ufs-qcom-suspend-fix-v3-1-63c4b95a70b9@linaro.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd-priv.h |    6 ------
 drivers/ufs/core/ufshcd.c      |    1 -
 drivers/ufs/host/ufs-qcom.c    |   13 +++++--------
 include/ufs/ufshcd.h           |    2 --
 4 files changed, 5 insertions(+), 17 deletions(-)

--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -242,12 +242,6 @@ static inline void ufshcd_vops_config_sc
 		hba->vops->config_scaling_param(hba, p, data);
 }
 
-static inline void ufshcd_vops_reinit_notify(struct ufs_hba *hba)
-{
-	if (hba->vops && hba->vops->reinit_notify)
-		hba->vops->reinit_notify(hba);
-}
-
 static inline int ufshcd_vops_mcq_config_resource(struct ufs_hba *hba)
 {
 	if (hba->vops && hba->vops->mcq_config_resource)
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8795,7 +8795,6 @@ static int ufshcd_probe_hba(struct ufs_h
 		ufshcd_device_reset(hba);
 		ufs_put_device_desc(hba);
 		ufshcd_hba_stop(hba);
-		ufshcd_vops_reinit_notify(hba);
 		ret = ufshcd_hba_enable(hba);
 		if (ret) {
 			dev_err(hba->dev, "Host controller enable failed\n");
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -455,6 +455,11 @@ static int ufs_qcom_power_up_sequence(st
 		dev_warn(hba->dev, "%s: host reset returned %d\n",
 				  __func__, ret);
 
+	if (phy->power_count) {
+		phy_power_off(phy);
+		phy_exit(phy);
+	}
+
 	/* phy initialization - calibrate the phy */
 	ret = phy_init(phy);
 	if (ret) {
@@ -1638,13 +1643,6 @@ static void ufs_qcom_config_scaling_para
 }
 #endif
 
-static void ufs_qcom_reinit_notify(struct ufs_hba *hba)
-{
-	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
-
-	phy_power_off(host->generic_phy);
-}
-
 /* Resources */
 static const struct ufshcd_res_info ufs_res_info[RES_MAX] = {
 	{.name = "ufs_mem",},
@@ -1887,7 +1885,6 @@ static const struct ufs_hba_variant_ops
 	.device_reset		= ufs_qcom_device_reset,
 	.config_scaling_param = ufs_qcom_config_scaling_param,
 	.program_key		= ufs_qcom_ice_program_key,
-	.reinit_notify		= ufs_qcom_reinit_notify,
 	.mcq_config_resource	= ufs_qcom_mcq_config_resource,
 	.get_hba_mac		= ufs_qcom_get_hba_mac,
 	.op_runtime_config	= ufs_qcom_op_runtime_config,
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -324,7 +324,6 @@ struct ufs_pwr_mode_info {
  * @config_scaling_param: called to configure clock scaling parameters
  * @program_key: program or evict an inline encryption key
  * @event_notify: called to notify important events
- * @reinit_notify: called to notify reinit of UFSHCD during max gear switch
  * @mcq_config_resource: called to configure MCQ platform resources
  * @get_hba_mac: called to get vendor specific mac value, mandatory for mcq mode
  * @op_runtime_config: called to config Operation and runtime regs Pointers
@@ -369,7 +368,6 @@ struct ufs_hba_variant_ops {
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
 	void	(*event_notify)(struct ufs_hba *hba,
 				enum ufs_event_type evt, void *data);
-	void	(*reinit_notify)(struct ufs_hba *);
 	int	(*mcq_config_resource)(struct ufs_hba *hba);
 	int	(*get_hba_mac)(struct ufs_hba *hba);
 	int	(*op_runtime_config)(struct ufs_hba *hba);


