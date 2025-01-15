Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC38248BA6;
	Wed, 15 Jan 2025 10:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938113; cv=none; b=ZX/JYLWQ/i7rpsWJsR5G1fJXnX3REAAyGgrLt9rvb229SwClpdI04rI+ahWRq8PMitfz3nD0ViWaXGXtLExMIV2A5dRzoVpsB/k9G2Is483cEAD4IX7r6NAy1O7AYNsMrXtwL0kVOkGVFpHQdM/zumGzw7d9jpcQi2cLIo62m3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938113; c=relaxed/simple;
	bh=q1vG5iypZufICtxkinPzlxLFwQo7RVPnO7O0hVMoocA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acAsPsme3whfQT0LBpXPZn9NdELetCiuwf9TUziY9fiFd8968TbRRG4LMkabfbGOccepeeEQgzhUWISV9waZ//oUjnIzYjacB+cPSjUV1UrYBFgQ1FIdmpMqRiqRDgu+u9IiCePt85uUBgG3JiPDXjApz4MXhg1SiJhKUrR4jIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oneMgTS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oneMgTS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75566C4CEDF;
	Wed, 15 Jan 2025 10:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938112;
	bh=q1vG5iypZufICtxkinPzlxLFwQo7RVPnO7O0hVMoocA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oneMgTS+YDgd1G/9Sko48Vqa8Y11PKNUMa2XP8Yt3NfXiyiwsDx6IHlYN8j2ldBq7
	 psYE4wpc8Emyfxk/7rxpYFnm8rJlZqi7uZhlcPIoI8BTUiDqckfp1++QYMpD/kxFKY
	 rKZF4jwUIV2Q99X0XLobbyhTz5BVh9oMeHv0Z3TE=
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
Subject: [PATCH 6.12 086/189] scsi: ufs: qcom: Power off the PHY if it was already powered on in ufs_qcom_power_up_sequence()
Date: Wed, 15 Jan 2025 11:36:22 +0100
Message-ID: <20250115103609.766959670@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -237,12 +237,6 @@ static inline void ufshcd_vops_config_sc
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
@@ -8881,7 +8881,6 @@ static int ufshcd_probe_hba(struct ufs_h
 		ufshcd_device_reset(hba);
 		ufs_put_device_desc(hba);
 		ufshcd_hba_stop(hba);
-		ufshcd_vops_reinit_notify(hba);
 		ret = ufshcd_hba_enable(hba);
 		if (ret) {
 			dev_err(hba->dev, "Host controller enable failed\n");
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -368,6 +368,11 @@ static int ufs_qcom_power_up_sequence(st
 	if (ret)
 		return ret;
 
+	if (phy->power_count) {
+		phy_power_off(phy);
+		phy_exit(phy);
+	}
+
 	/* phy initialization - calibrate the phy */
 	ret = phy_init(phy);
 	if (ret) {
@@ -1562,13 +1567,6 @@ static void ufs_qcom_config_scaling_para
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
@@ -1807,7 +1805,6 @@ static const struct ufs_hba_variant_ops
 	.device_reset		= ufs_qcom_device_reset,
 	.config_scaling_param = ufs_qcom_config_scaling_param,
 	.program_key		= ufs_qcom_ice_program_key,
-	.reinit_notify		= ufs_qcom_reinit_notify,
 	.mcq_config_resource	= ufs_qcom_mcq_config_resource,
 	.get_hba_mac		= ufs_qcom_get_hba_mac,
 	.op_runtime_config	= ufs_qcom_op_runtime_config,
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -329,7 +329,6 @@ struct ufs_pwr_mode_info {
  * @program_key: program or evict an inline encryption key
  * @fill_crypto_prdt: initialize crypto-related fields in the PRDT
  * @event_notify: called to notify important events
- * @reinit_notify: called to notify reinit of UFSHCD during max gear switch
  * @mcq_config_resource: called to configure MCQ platform resources
  * @get_hba_mac: reports maximum number of outstanding commands supported by
  *	the controller. Should be implemented for UFSHCI 4.0 or later
@@ -381,7 +380,6 @@ struct ufs_hba_variant_ops {
 				    void *prdt, unsigned int num_segments);
 	void	(*event_notify)(struct ufs_hba *hba,
 				enum ufs_event_type evt, void *data);
-	void	(*reinit_notify)(struct ufs_hba *);
 	int	(*mcq_config_resource)(struct ufs_hba *hba);
 	int	(*get_hba_mac)(struct ufs_hba *hba);
 	int	(*op_runtime_config)(struct ufs_hba *hba);


