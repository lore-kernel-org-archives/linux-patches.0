Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8A826B747;
	Tue, 26 Aug 2025 13:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215077; cv=none; b=sK8v+vHkgl+i1PgGh5xk1YrylQv6i+sL+WT6UHXD7fTI6RIsw1hEAZ5Cp35R3PPHWaQdU7rQI9ie/mGHUXCGPquMTv4sbn9CkA+9XVWW/kSeTJsOQtmRm8WYmFP7tB53C0LNrTju92GeT1rLTJK1b4xs6PSY83AotG5u7xf/VhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215077; c=relaxed/simple;
	bh=pWnSvxKokleudL3eYbWUeNyibYsbzX/+m//BvnnSfSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loJkpLhggZYEoJlt5VyHUe3YCJJJqTK/FmDne4C4b4N7MhW7syXwC2mIrdR1uySD4esNxBTJf4gSddcCE6GMXvCkydiiU6lLTH35AO/3KVesUqMpa6YvdQLAAc0NrQZietuIkgzAeBxj+VcJtJmcg18wEn+B/qiin1qN9hZc9Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3NeKk/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3NeKk/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B07C113D0;
	Tue, 26 Aug 2025 13:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215077;
	bh=pWnSvxKokleudL3eYbWUeNyibYsbzX/+m//BvnnSfSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3NeKk/MYQoWkruhIAu2p45SUZVyHwEnjAigbdzC45Wc1GzirdtiV/uy6+9iCxnoN
	 tVfP6vRV9TF/SLysXBKfmkDWRWf4niFGCdXPffYI1DqkExLrWbHVySoXdmvhgHPBEc
	 hgWPoLIkPvQppSmqrmJ3/1c9vP+47kDsTNBsBt/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Tero Kristo <tero.kristo@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH 6.1 378/482] crypto: qat - fix ring to service map for QAT GEN4
Date: Tue, 26 Aug 2025 13:10:31 +0200
Message-ID: <20250826110940.167333371@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

commit a238487f7965d102794ed9f8aff0b667cd2ae886 upstream.

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
[Giovanni: backport to 6.1.y, conflict resolved simplifying the logic
in the function get_ring_to_svc_map() as the QAT driver in v6.1 supports
only limited configurations (crypto only and compression).  Differs from
upstream as the ring to service mapping is hardcoded rather than being
dynamically computed.]
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Tested-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |   13 +++++++++++++
 drivers/crypto/qat/qat_common/adf_accel_devices.h |    1 +
 drivers/crypto/qat/qat_common/adf_gen4_hw_data.h  |    6 ++++++
 drivers/crypto/qat/qat_common/adf_init.c          |    3 +++
 4 files changed, 23 insertions(+)

--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -297,6 +297,18 @@ static char *uof_get_name(struct adf_acc
 	return NULL;
 }
 
+static u16 get_ring_to_svc_map(struct adf_accel_dev *accel_dev)
+{
+	switch (get_service_enabled(accel_dev)) {
+	case SVC_CY:
+		return ADF_GEN4_DEFAULT_RING_TO_SRV_MAP;
+	case SVC_DC:
+		return ADF_GEN4_DEFAULT_RING_TO_SRV_MAP_DC;
+	}
+
+	return 0;
+}
+
 static u32 uof_get_ae_mask(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
 	switch (get_service_enabled(accel_dev)) {
@@ -353,6 +365,7 @@ void adf_init_hw_data_4xxx(struct adf_hw
 	hw_data->uof_get_ae_mask = uof_get_ae_mask;
 	hw_data->set_msix_rttable = set_msix_default_rttable;
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
+	hw_data->get_ring_to_svc_map = get_ring_to_svc_map;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->ring_pair_reset = adf_gen4_ring_pair_reset;
 	hw_data->enable_pm = adf_gen4_enable_pm;
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -176,6 +176,7 @@ struct adf_hw_device_data {
 	void (*get_arb_info)(struct arb_info *arb_csrs_info);
 	void (*get_admin_info)(struct admin_info *admin_csrs_info);
 	enum dev_sku_info (*get_sku)(struct adf_hw_device_data *self);
+	u16 (*get_ring_to_svc_map)(struct adf_accel_dev *accel_dev);
 	int (*alloc_irq)(struct adf_accel_dev *accel_dev);
 	void (*free_irq)(struct adf_accel_dev *accel_dev);
 	void (*enable_error_correction)(struct adf_accel_dev *accel_dev);
--- a/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
@@ -95,6 +95,12 @@ do { \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
 		   ADF_RING_CSR_RING_SRV_ARB_EN, (value))
 
+#define ADF_GEN4_DEFAULT_RING_TO_SRV_MAP_DC \
+	(COMP << ADF_CFG_SERV_RING_PAIR_0_SHIFT | \
+	 COMP << ADF_CFG_SERV_RING_PAIR_1_SHIFT | \
+	 COMP << ADF_CFG_SERV_RING_PAIR_2_SHIFT | \
+	 COMP << ADF_CFG_SERV_RING_PAIR_3_SHIFT)
+
 /* Default ring mapping */
 #define ADF_GEN4_DEFAULT_RING_TO_SRV_MAP \
 	(ASYM << ADF_CFG_SERV_RING_PAIR_0_SHIFT | \
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -95,6 +95,9 @@ int adf_dev_init(struct adf_accel_dev *a
 		return -EFAULT;
 	}
 
+	if (hw_data->get_ring_to_svc_map)
+		hw_data->ring_to_svc_map = hw_data->get_ring_to_svc_map(accel_dev);
+
 	if (adf_ae_init(accel_dev)) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to initialise Acceleration Engine\n");


