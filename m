Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04303211A2A;
	Wed,  7 May 2025 18:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644020; cv=none; b=I1stN2i9QqjtIPsys3EvCxZSEg9TnIre80lq7t6opOASUA5knGzYzJFQTggGKSL0d+Mr+yR8+Fj7r6E3vurA6K0nOEyKm/PK1PGsb61mb7CAVUbXO2Ym2vmla4Kn+I04f+0K6NvuU+tGbMZ74q3ydaDhs6qNGvaNKjyLj4w402E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644020; c=relaxed/simple;
	bh=V6ryQeHdrx5+itd6b1ru/+5IMyJEU3XUPNiOkB6d2Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqs/F5vYUiS365ECqDK5iPSlcPRh1BPfoCffc6tTlBRSICDBb5v19OKww39LhnuiV0KGztNEyO4GD5L6mGU2K0D14r7rma6QHMEs8ZUDvgxnIe3OWF/M+j8YsybjRAPXVvoj0JIPsrtueJjOAojnGk5qlbno4pL06z53LWoNgFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpdXfXZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpdXfXZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A6AC4CEEB;
	Wed,  7 May 2025 18:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644019;
	bh=V6ryQeHdrx5+itd6b1ru/+5IMyJEU3XUPNiOkB6d2Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpdXfXZZmYjf3BCer0L0ZljtGkV1WMjtwz6JRP4tO5FbEgeQ7CTsLKrqcjif0awMZ
	 0+gFe3pFkBf7TsrOdp3Wg7uFL6mMMioPb9Nzdkw2LmfPbH4S13C+uf4+tsgnO9LrkU
	 ANmKxgzHCwLDLohcZyK5RNFRJ18dnNY8YvjaeACM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 094/183] pds_core: specify auxiliary_device to be created
Date: Wed,  7 May 2025 20:38:59 +0200
Message-ID: <20250507183828.631767202@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit b699bdc720c0255d1bb76cecba7382c1f2107af5 ]

In preparation for adding a new auxiliary_device for the PF,
make the vif type an argument to pdsc_auxbus_dev_add().  Pass in
the address of the padev pointer so that the caller can specify
where to save it and keep the mutex usage within the function.

Link: https://patch.msgid.link/r/20250320194412.67983-3-shannon.nelson@amd.com
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: dfd76010f8e8 ("pds_core: remove write-after-free of client_id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/auxbus.c  | 37 ++++++++++-----------
 drivers/net/ethernet/amd/pds_core/core.h    |  7 ++--
 drivers/net/ethernet/amd/pds_core/devlink.c |  5 +--
 drivers/net/ethernet/amd/pds_core/main.c    | 11 +++---
 4 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
index d53b2124b1498..4d3387bebe6a4 100644
--- a/drivers/net/ethernet/amd/pds_core/auxbus.c
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -172,29 +172,32 @@ static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *cf,
 	return padev;
 }
 
-void pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf)
+void pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf,
+			 struct pds_auxiliary_dev **pd_ptr)
 {
 	struct pds_auxiliary_dev *padev;
 
+	if (!*pd_ptr)
+		return;
+
 	mutex_lock(&pf->config_lock);
 
-	padev = pf->vfs[cf->vf_id].padev;
-	if (padev) {
-		pds_client_unregister(pf, padev->client_id);
-		auxiliary_device_delete(&padev->aux_dev);
-		auxiliary_device_uninit(&padev->aux_dev);
-		padev->client_id = 0;
-	}
-	pf->vfs[cf->vf_id].padev = NULL;
+	padev = *pd_ptr;
+	pds_client_unregister(pf, padev->client_id);
+	auxiliary_device_delete(&padev->aux_dev);
+	auxiliary_device_uninit(&padev->aux_dev);
+	padev->client_id = 0;
+	*pd_ptr = NULL;
 
 	mutex_unlock(&pf->config_lock);
 }
 
-int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf)
+int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf,
+			enum pds_core_vif_types vt,
+			struct pds_auxiliary_dev **pd_ptr)
 {
 	struct pds_auxiliary_dev *padev;
 	char devname[PDS_DEVNAME_LEN];
-	enum pds_core_vif_types vt;
 	unsigned long mask;
 	u16 vt_support;
 	int client_id;
@@ -203,6 +206,9 @@ int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf)
 	if (!cf)
 		return -ENODEV;
 
+	if (vt >= PDS_DEV_TYPE_MAX)
+		return -EINVAL;
+
 	mutex_lock(&pf->config_lock);
 
 	mask = BIT_ULL(PDSC_S_FW_DEAD) |
@@ -214,17 +220,10 @@ int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf)
 		goto out_unlock;
 	}
 
-	/* We only support vDPA so far, so it is the only one to
-	 * be verified that it is available in the Core device and
-	 * enabled in the devlink param.  In the future this might
-	 * become a loop for several VIF types.
-	 */
-
 	/* Verify that the type is supported and enabled.  It is not
 	 * an error if there is no auxbus device support for this
 	 * VF, it just means something else needs to happen with it.
 	 */
-	vt = PDS_DEV_TYPE_VDPA;
 	vt_support = !!le16_to_cpu(pf->dev_ident.vif_types[vt]);
 	if (!(vt_support &&
 	      pf->viftype_status[vt].supported &&
@@ -250,7 +249,7 @@ int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf)
 		err = PTR_ERR(padev);
 		goto out_unlock;
 	}
-	pf->vfs[cf->vf_id].padev = padev;
+	*pd_ptr = padev;
 
 out_unlock:
 	mutex_unlock(&pf->config_lock);
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 08b8280437dcf..becd3104473c2 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -303,8 +303,11 @@ void pdsc_health_thread(struct work_struct *work);
 int pdsc_register_notify(struct notifier_block *nb);
 void pdsc_unregister_notify(struct notifier_block *nb);
 void pdsc_notify(unsigned long event, void *data);
-int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf);
-void pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf);
+int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf,
+			enum pds_core_vif_types vt,
+			struct pds_auxiliary_dev **pd_ptr);
+void pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf,
+			 struct pds_auxiliary_dev **pd_ptr);
 
 void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index 48a7c22fe3320..d8dc39da4161f 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -57,9 +57,10 @@ int pdsc_dl_enable_set(struct devlink *dl, u32 id,
 		struct pdsc *vf = pdsc->vfs[vf_id].vf;
 
 		if (ctx->val.vbool)
-			err = pdsc_auxbus_dev_add(vf, pdsc);
+			err = pdsc_auxbus_dev_add(vf, pdsc, vt_entry->vif_id,
+						  &pdsc->vfs[vf_id].padev);
 		else
-			pdsc_auxbus_dev_del(vf, pdsc);
+			pdsc_auxbus_dev_del(vf, pdsc, &pdsc->vfs[vf_id].padev);
 	}
 
 	return err;
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 660268ff95623..a3a68889137b6 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -190,7 +190,8 @@ static int pdsc_init_vf(struct pdsc *vf)
 	devl_unlock(dl);
 
 	pf->vfs[vf->vf_id].vf = vf;
-	err = pdsc_auxbus_dev_add(vf, pf);
+	err = pdsc_auxbus_dev_add(vf, pf, PDS_DEV_TYPE_VDPA,
+				  &pf->vfs[vf->vf_id].padev);
 	if (err) {
 		devl_lock(dl);
 		devl_unregister(dl);
@@ -417,7 +418,7 @@ static void pdsc_remove(struct pci_dev *pdev)
 
 		pf = pdsc_get_pf_struct(pdsc->pdev);
 		if (!IS_ERR(pf)) {
-			pdsc_auxbus_dev_del(pdsc, pf);
+			pdsc_auxbus_dev_del(pdsc, pf, &pf->vfs[pdsc->vf_id].padev);
 			pf->vfs[pdsc->vf_id].vf = NULL;
 		}
 	} else {
@@ -482,7 +483,8 @@ static void pdsc_reset_prepare(struct pci_dev *pdev)
 
 		pf = pdsc_get_pf_struct(pdsc->pdev);
 		if (!IS_ERR(pf))
-			pdsc_auxbus_dev_del(pdsc, pf);
+			pdsc_auxbus_dev_del(pdsc, pf,
+					    &pf->vfs[pdsc->vf_id].padev);
 	}
 
 	pdsc_unmap_bars(pdsc);
@@ -527,7 +529,8 @@ static void pdsc_reset_done(struct pci_dev *pdev)
 
 		pf = pdsc_get_pf_struct(pdsc->pdev);
 		if (!IS_ERR(pf))
-			pdsc_auxbus_dev_add(pdsc, pf);
+			pdsc_auxbus_dev_add(pdsc, pf, PDS_DEV_TYPE_VDPA,
+					    &pf->vfs[pdsc->vf_id].padev);
 	}
 }
 
-- 
2.39.5



