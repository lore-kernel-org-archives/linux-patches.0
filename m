Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A7F1487E9;
	Tue, 25 Jun 2024 09:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309538; cv=none; b=ERqHfd05E1JNWiGNWhT5Q7yB4LFv1HkZ2a0iI1SZmEWoihnKe3FO/pL6zDyRLAdlhzhByDcPNWKlqj7UxhlUWzDnJoaaCOgSDMgHJMm37AgaisVW1WswEUpoh1WkgorYDbT8TngieHpwrrErl9DVGm5iR0nwsGRC8/ds2gS5Gw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309538; c=relaxed/simple;
	bh=dI1KTV3dwdTXNYjvZruw5kOCrmt86PBFFCYfGs9P1Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGmXLZzS3M8cloQlh4IHK8GdZuIB/P7hOqtfdaLoEMPkyD66Zqm7hLeBcAO2WNQCDjbikvTC76mqDFd2ikxHBwj5hzqDpVV8PY+Rh7OJkzrQeCfuHpxvaq/lYnFazqDPferUI0HV2paabxBVzHWbRfy6ddrLC9JHyf1MBYw3nLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNG8rYw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNG8rYw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F289FC32781;
	Tue, 25 Jun 2024 09:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309538;
	bh=dI1KTV3dwdTXNYjvZruw5kOCrmt86PBFFCYfGs9P1Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNG8rYw2T5TxaE84Pkleg2H7pAT9o/fjWm4C67ByaysBZ/W6pwWA5gKGRCBC+qCqI
	 +HdRXXTHQZJL/n6ELxYgbN1U7jGv0LCH8M6j2e263VUc0q407+jNv9PmQkfM5Jw3gA
	 4TCj89FivvmAvqNj1RNxRcN1ZjvN+zhGsnLz2+UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Dave Ertman <david.m.ertman@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/131] ice: move RDMA init to ice_idc.c
Date: Tue, 25 Jun 2024 11:33:25 +0200
Message-ID: <20240625085527.852372933@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 2b8db6afbc95258175da69f31c9bfbea539aaa74 ]

Simplify probe flow by moving all RDMA related code to ice_init_rdma().
Unroll irq allocation if RDMA initialization fails.

Implement ice_deinit_rdma() and use it in remove flow.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Acked-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: bc69ad74867d ("ice: avoid IRQ collision to fix init failure on ACPI S3 resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_idc.c  | 52 ++++++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_main.c | 29 +++----------
 3 files changed, 57 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 6d75e5638f665..1fe9cccf18d2f 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -901,6 +901,7 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
 int ice_plug_aux_dev(struct ice_pf *pf);
 void ice_unplug_aux_dev(struct ice_pf *pf);
 int ice_init_rdma(struct ice_pf *pf);
+void ice_deinit_rdma(struct ice_pf *pf);
 const char *ice_aq_str(enum ice_aq_err aq_err);
 bool ice_is_wol_supported(struct ice_hw *hw);
 void ice_fdir_del_all_fltrs(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 895c32bcc8b5e..579d2a433ea12 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -6,6 +6,8 @@
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
 
+static DEFINE_IDA(ice_aux_ida);
+
 /**
  * ice_get_auxiliary_drv - retrieve iidc_auxiliary_drv struct
  * @pf: pointer to PF struct
@@ -245,6 +247,17 @@ static int ice_reserve_rdma_qvector(struct ice_pf *pf)
 	return 0;
 }
 
+/**
+ * ice_free_rdma_qvector - free vector resources reserved for RDMA driver
+ * @pf: board private structure to initialize
+ */
+static void ice_free_rdma_qvector(struct ice_pf *pf)
+{
+	pf->num_avail_sw_msix -= pf->num_rdma_msix;
+	ice_free_res(pf->irq_tracker, pf->rdma_base_vector,
+		     ICE_RES_RDMA_VEC_ID);
+}
+
 /**
  * ice_adev_release - function to be mapped to AUX dev's release op
  * @dev: pointer to device to free
@@ -331,12 +344,47 @@ int ice_init_rdma(struct ice_pf *pf)
 	struct device *dev = &pf->pdev->dev;
 	int ret;
 
+	if (!ice_is_rdma_ena(pf)) {
+		dev_warn(dev, "RDMA is not supported on this device\n");
+		return 0;
+	}
+
+	pf->aux_idx = ida_alloc(&ice_aux_ida, GFP_KERNEL);
+	if (pf->aux_idx < 0) {
+		dev_err(dev, "Failed to allocate device ID for AUX driver\n");
+		return -ENOMEM;
+	}
+
 	/* Reserve vector resources */
 	ret = ice_reserve_rdma_qvector(pf);
 	if (ret < 0) {
 		dev_err(dev, "failed to reserve vectors for RDMA\n");
-		return ret;
+		goto err_reserve_rdma_qvector;
 	}
 	pf->rdma_mode |= IIDC_RDMA_PROTOCOL_ROCEV2;
-	return ice_plug_aux_dev(pf);
+	ret = ice_plug_aux_dev(pf);
+	if (ret)
+		goto err_plug_aux_dev;
+	return 0;
+
+err_plug_aux_dev:
+	ice_free_rdma_qvector(pf);
+err_reserve_rdma_qvector:
+	pf->adev = NULL;
+	ida_free(&ice_aux_ida, pf->aux_idx);
+	return ret;
+}
+
+/**
+ * ice_deinit_rdma - deinitialize RDMA on PF
+ * @pf: ptr to ice_pf
+ */
+void ice_deinit_rdma(struct ice_pf *pf)
+{
+	if (!ice_is_rdma_ena(pf))
+		return;
+
+	ice_unplug_aux_dev(pf);
+	ice_free_rdma_qvector(pf);
+	ida_free(&ice_aux_ida, pf->aux_idx);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 3117f65253b37..9f71cbf62b141 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -45,7 +45,6 @@ MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all), hw debug_mask (0x8XXXX
 MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all)");
 #endif /* !CONFIG_DYNAMIC_DEBUG */
 
-static DEFINE_IDA(ice_aux_ida);
 DEFINE_STATIC_KEY_FALSE(ice_xdp_locking_key);
 EXPORT_SYMBOL(ice_xdp_locking_key);
 
@@ -4971,30 +4970,16 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	/* ready to go, so clear down state bit */
 	clear_bit(ICE_DOWN, pf->state);
-	if (ice_is_rdma_ena(pf)) {
-		pf->aux_idx = ida_alloc(&ice_aux_ida, GFP_KERNEL);
-		if (pf->aux_idx < 0) {
-			dev_err(dev, "Failed to allocate device ID for AUX driver\n");
-			err = -ENOMEM;
-			goto err_devlink_reg_param;
-		}
-
-		err = ice_init_rdma(pf);
-		if (err) {
-			dev_err(dev, "Failed to initialize RDMA: %d\n", err);
-			err = -EIO;
-			goto err_init_aux_unroll;
-		}
-	} else {
-		dev_warn(dev, "RDMA is not supported on this device\n");
+	err = ice_init_rdma(pf);
+	if (err) {
+		dev_err(dev, "Failed to initialize RDMA: %d\n", err);
+		err = -EIO;
+		goto err_devlink_reg_param;
 	}
 
 	ice_devlink_register(pf);
 	return 0;
 
-err_init_aux_unroll:
-	pf->adev = NULL;
-	ida_free(&ice_aux_ida, pf->aux_idx);
 err_devlink_reg_param:
 	ice_devlink_unregister_params(pf);
 err_netdev_reg:
@@ -5106,9 +5091,7 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_service_task_stop(pf);
 
 	ice_aq_cancel_waiting_tasks(pf);
-	ice_unplug_aux_dev(pf);
-	if (pf->aux_idx >= 0)
-		ida_free(&ice_aux_ida, pf->aux_idx);
+	ice_deinit_rdma(pf);
 	ice_devlink_unregister_params(pf);
 	set_bit(ICE_DOWN, pf->state);
 
-- 
2.43.0



