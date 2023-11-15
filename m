Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD4A31730
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lI9YqiAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F161C433C7;
	Wed, 15 Nov 2023 19:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077603;
	bh=J2MIBoQSJacSAkojynG0tAxou8mXDwNbPMu3mlLhoVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lI9YqiAbJheQO6E8ZTl3NHe7ZKpwPyU8mDqBXMdPmQ8QACrWVhL5+IqF5iCQTyMti
	 kQrQZCpR/gHN1r/7JwB4yaVAYV0DM/U13MIY2eHheuiY5fQM+Mt6Vttrj2h3J7Kd5I
	 hp4nK/Up5zTNKDUYNl/EFMTOxCPiZUwYNHHuNA6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Tero Kristo <tero.kristo@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 404/603] crypto: qat - fix ring to service map for QAT GEN4
Date: Wed, 15 Nov 2023 14:15:49 -0500
Message-ID: <20231115191640.991662940@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit a238487f7965d102794ed9f8aff0b667cd2ae886 ]

The 4xxx drivers hardcode the ring to service mapping. However, when
additional configurations where added to the driver, the mappings were
not updated. This implies that an incorrect mapping might be reported
through pfvf for certain configurations.

Add an algorithm that computes the correct ring to service mapping based
on the firmware loaded on the device.

Fixes: 0cec19c761e5 ("crypto: qat - add support for compression for 4xxx")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 54 +++++++++++++++++++
 .../intel/qat/qat_common/adf_accel_devices.h  |  1 +
 .../crypto/intel/qat/qat_common/adf_init.c    |  3 ++
 3 files changed, 58 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 44b732fb80bca..a5691ba0b7244 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -423,6 +423,59 @@ static const struct adf_fw_config *get_fw_config(struct adf_accel_dev *accel_dev
 	}
 }
 
+enum adf_rp_groups {
+	RP_GROUP_0 = 0,
+	RP_GROUP_1,
+	RP_GROUP_COUNT
+};
+
+static u16 get_ring_to_svc_map(struct adf_accel_dev *accel_dev)
+{
+	enum adf_cfg_service_type rps[RP_GROUP_COUNT];
+	const struct adf_fw_config *fw_config;
+	u16 ring_to_svc_map;
+	int i, j;
+
+	fw_config = get_fw_config(accel_dev);
+	if (!fw_config)
+		return 0;
+
+	for (i = 0; i < RP_GROUP_COUNT; i++) {
+		switch (fw_config[i].ae_mask) {
+		case ADF_AE_GROUP_0:
+			j = RP_GROUP_0;
+			break;
+		case ADF_AE_GROUP_1:
+			j = RP_GROUP_1;
+			break;
+		default:
+			return 0;
+		}
+
+		switch (fw_config[i].obj) {
+		case ADF_FW_SYM_OBJ:
+			rps[j] = SYM;
+			break;
+		case ADF_FW_ASYM_OBJ:
+			rps[j] = ASYM;
+			break;
+		case ADF_FW_DC_OBJ:
+			rps[j] = COMP;
+			break;
+		default:
+			rps[j] = 0;
+			break;
+		}
+	}
+
+	ring_to_svc_map = rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_0_SHIFT |
+			  rps[RP_GROUP_1] << ADF_CFG_SERV_RING_PAIR_1_SHIFT |
+			  rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_2_SHIFT |
+			  rps[RP_GROUP_1] << ADF_CFG_SERV_RING_PAIR_3_SHIFT;
+
+	return ring_to_svc_map;
+}
+
 static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num,
 				const char * const fw_objs[], int num_objs)
 {
@@ -519,6 +572,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->uof_get_ae_mask = uof_get_ae_mask;
 	hw_data->set_msix_rttable = set_msix_default_rttable;
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
+	hw_data->get_ring_to_svc_map = get_ring_to_svc_map;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->ring_pair_reset = adf_gen4_ring_pair_reset;
 	hw_data->enable_pm = adf_gen4_enable_pm;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 1e84ff309ed3b..79d5a1535eda3 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -182,6 +182,7 @@ struct adf_hw_device_data {
 	void (*get_arb_info)(struct arb_info *arb_csrs_info);
 	void (*get_admin_info)(struct admin_info *admin_csrs_info);
 	enum dev_sku_info (*get_sku)(struct adf_hw_device_data *self);
+	u16 (*get_ring_to_svc_map)(struct adf_accel_dev *accel_dev);
 	int (*alloc_irq)(struct adf_accel_dev *accel_dev);
 	void (*free_irq)(struct adf_accel_dev *accel_dev);
 	void (*enable_error_correction)(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 7323a9f1f11c8..0f9e2d59ce385 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -97,6 +97,9 @@ static int adf_dev_init(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
+	if (hw_data->get_ring_to_svc_map)
+		hw_data->ring_to_svc_map = hw_data->get_ring_to_svc_map(accel_dev);
+
 	if (adf_ae_init(accel_dev)) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to initialise Acceleration Engine\n");
-- 
2.42.0



