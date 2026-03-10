Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3672BF3E2;
	Tue, 10 Mar 2026 11:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141194; cv=none; b=H7RJZNe2Y68AiHsmrKZjo9BXuq21K9/QY2IrK3r6EwQwSMAY79QGFTr02pZpqjQ4oI4D/PHRfccC1Q3aZKEIJ0Z4P/YFuB0x7UPMonnuGGkpIi56BnirScUUHbZRC0fZTD5fQ2iwmrXNfqjqy0gJkS7gOaN+wK7OOWGoK4SytLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141194; c=relaxed/simple;
	bh=TPwbEBjVjiM+pKKF1ZhxLyGNvHYE7/oL69BfXc23wg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRFJLc8JB5zu5gHldAatoWKC56cyRSvi1fRMvx896zRIxWj63BC4VQ2bGxxTzkuHxVPLorDMDCU/dlJutq3fzj+EQr0r65BKgIf3eXRnFQdZPfRb0euyVmvTSdHUdV6EmyFmRLZn4HTMnefoFtaWup80zs/azqou30K+r9Wr+Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fvzv80Wh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fvzv80Wh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E950C2BC86;
	Tue, 10 Mar 2026 11:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141194;
	bh=TPwbEBjVjiM+pKKF1ZhxLyGNvHYE7/oL69BfXc23wg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvzv80WhE4ho557onktmmGniAapjg6wgZs0trQH+6ESWa1GsGYEP/4eEvdAsxg7VE
	 OzJt4oT1dII5dXt4DgwHG/B4GT0fhcGA9sjVw2USudflNlDsO5KMaW78Kn+eF1MVYR
	 XrZNYJX3/MMRGKPgKon2pt64NbQ3LQQWzpy1VEmltE7NTJ5X6IVuvVuEWMLnUwS37Z
	 NhXYlnygn+y11dYX0qLR7XOjTNa1hP+NWOqRZjOZdCEpKgQEK3tJnWrH/hmRFTNWZ0
	 snPtm244mMgpvVettaJubu9K2XhnYm1oRC/O8Ne4vpx1nr7CKZeR8En+dd4uicdR8S
	 2mRYuR/klnWKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aaron Ma <aaron.ma@canonical.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 195/311] ice: recap the VSI and QoS info after rebuild
Date: Tue, 10 Mar 2026 07:04:02 -0400
Message-ID: <481a9b7669171a9d8267bb49e2c2dc3154108344.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit 6aa07e23dd3ccd35a0100c06fcb6b6c3b01e7965 ]

Fix IRDMA hardware initialization timeout (-110) after resume by
separating VSI-dependent configuration from RDMA resource allocation,
ensuring VSI is rebuilt before IRDMA accesses it.

After resume from suspend, IRDMA hardware initialization fails:
  ice: IRDMA hardware initialization FAILED init_state=4 status=-110

Separate RDMA initialization into two phases:
1. ice_init_rdma() - Allocate resources only (no VSI/QoS access, no plug)
2. ice_rdma_finalize_setup() - Assign VSI/QoS info and plug device

This allows:
- ice_init_rdma() to stay in ice_resume() (mirrors ice_deinit_rdma()
  in ice_suspend())
- VSI assignment deferred until after ice_vsi_rebuild() completes
- QoS info updated after ice_dcb_rebuild() completes
- Device plugged only when control queues, VSI, and DCB are all ready

Fixes: bc69ad74867db ("ice: avoid IRQ collision to fix init failure on ACPI S3 resume")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_idc.c  | 44 +++++++++++++++++------
 drivers/net/ethernet/intel/ice/ice_main.c |  7 +++-
 3 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 00f75d87c73f9..15a7fcd888b26 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -990,6 +990,7 @@ int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
 int ice_plug_aux_dev(struct ice_pf *pf);
 void ice_unplug_aux_dev(struct ice_pf *pf);
+void ice_rdma_finalize_setup(struct ice_pf *pf);
 int ice_init_rdma(struct ice_pf *pf);
 void ice_deinit_rdma(struct ice_pf *pf);
 bool ice_is_wol_supported(struct ice_hw *hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 420d45c2558b6..ded029aa71d7d 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -360,6 +360,39 @@ void ice_unplug_aux_dev(struct ice_pf *pf)
 	auxiliary_device_uninit(adev);
 }
 
+/**
+ * ice_rdma_finalize_setup - Complete RDMA setup after VSI is ready
+ * @pf: ptr to ice_pf
+ *
+ * Sets VSI-dependent information and plugs aux device.
+ * Must be called after ice_init_rdma(), ice_vsi_rebuild(), and
+ * ice_dcb_rebuild() complete.
+ */
+void ice_rdma_finalize_setup(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct iidc_rdma_priv_dev_info *privd;
+	int ret;
+
+	if (!ice_is_rdma_ena(pf) || !pf->cdev_info)
+		return;
+
+	privd = pf->cdev_info->iidc_priv;
+	if (!privd || !pf->vsi || !pf->vsi[0] || !pf->vsi[0]->netdev)
+		return;
+
+	/* Assign VSI info now that VSI is valid */
+	privd->netdev = pf->vsi[0]->netdev;
+	privd->vport_id = pf->vsi[0]->vsi_num;
+
+	/* Update QoS info after DCB has been rebuilt */
+	ice_setup_dcb_qos_info(pf, &privd->qos_info);
+
+	ret = ice_plug_aux_dev(pf);
+	if (ret)
+		dev_warn(dev, "Failed to plug RDMA aux device: %d\n", ret);
+}
+
 /**
  * ice_init_rdma - initializes PF for RDMA use
  * @pf: ptr to ice_pf
@@ -398,22 +431,14 @@ int ice_init_rdma(struct ice_pf *pf)
 	}
 
 	cdev->iidc_priv = privd;
-	privd->netdev = pf->vsi[0]->netdev;
 
 	privd->hw_addr = (u8 __iomem *)pf->hw.hw_addr;
 	cdev->pdev = pf->pdev;
-	privd->vport_id = pf->vsi[0]->vsi_num;
 
 	pf->cdev_info->rdma_protocol |= IIDC_RDMA_PROTOCOL_ROCEV2;
-	ice_setup_dcb_qos_info(pf, &privd->qos_info);
-	ret = ice_plug_aux_dev(pf);
-	if (ret)
-		goto err_plug_aux_dev;
+
 	return 0;
 
-err_plug_aux_dev:
-	pf->cdev_info->adev = NULL;
-	xa_erase(&ice_aux_id, pf->aux_idx);
 err_alloc_xa:
 	kfree(privd);
 err_privd_alloc:
@@ -432,7 +457,6 @@ void ice_deinit_rdma(struct ice_pf *pf)
 	if (!ice_is_rdma_ena(pf))
 		return;
 
-	ice_unplug_aux_dev(pf);
 	xa_erase(&ice_aux_id, pf->aux_idx);
 	kfree(pf->cdev_info->iidc_priv);
 	kfree(pf->cdev_info);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d04605d3e61af..dddf1ae31952d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5138,6 +5138,9 @@ int ice_load(struct ice_pf *pf)
 	if (err)
 		goto err_init_rdma;
 
+	/* Finalize RDMA: VSI already created, assign info and plug device */
+	ice_rdma_finalize_setup(pf);
+
 	ice_service_task_restart(pf);
 
 	clear_bit(ICE_DOWN, pf->state);
@@ -5169,6 +5172,7 @@ void ice_unload(struct ice_pf *pf)
 
 	devl_assert_locked(priv_to_devlink(pf));
 
+	ice_unplug_aux_dev(pf);
 	ice_deinit_rdma(pf);
 	ice_deinit_features(pf);
 	ice_tc_indir_block_unregister(vsi);
@@ -5595,6 +5599,7 @@ static int ice_suspend(struct device *dev)
 	 */
 	disabled = ice_service_task_stop(pf);
 
+	ice_unplug_aux_dev(pf);
 	ice_deinit_rdma(pf);
 
 	/* Already suspended?, then there is nothing to do */
@@ -7803,7 +7808,7 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 
 	ice_health_clear(pf);
 
-	ice_plug_aux_dev(pf);
+	ice_rdma_finalize_setup(pf);
 	if (ice_is_feature_supported(pf, ICE_F_SRIOV_LAG))
 		ice_lag_rebuild(pf);
 
-- 
2.51.0

