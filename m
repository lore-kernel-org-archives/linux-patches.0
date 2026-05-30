Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B949534E745;
	Sat, 30 May 2026 16:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159803; cv=none; b=ZOiW8d/tnNzp7h9pGzN+pI2G62zNYJll74+aVXAfDFlHe3SPTvDwG9GwUDJCwHb6FwJaoMCcEgoE8EuqKH7rM1XcnrAU7gZUM1N12Ljt3nXg009rjmqp6INull1cvNJjZ30uZyG6EP8ftKf1q4D/+7dAI1Qfr+gGKiyxtLoaGPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159803; c=relaxed/simple;
	bh=oxw4r1RwmGmPlke0aG0AlkEsCboYFBAlgIjv9fw0PIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M7GJgFzuKVeifkEUwPLax+aG0/69MbsE5DiYBdHI2i3hcbMflIYUQhu1r1aEr2EhCllXHp7uQKAnObl0e/AMKBPGeLBwDv8NwZAw4ULGea4XbX0V6pzaqFZ9LkIp0mDOLQ0SsByPJ9QTSe/28Rl7SusVXCoMFXOvHTKbv1QIZ/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efLhPXMc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efLhPXMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C5B1F00898;
	Sat, 30 May 2026 16:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159802;
	bh=1C5FO3SJwCU80rLVroOoawflgxCwNBu59dc7BiYQVBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=efLhPXMcd1ThxcqPItaHmuCtQFodk4jiRav7KzKWFgW+05cF7RhOpXOeBA6FQONVi
	 h5NCguhLw08aZuzwqOj4y7tSNAHz764zkqFnYLenrJCPXxSagWVHIaT9K8vuJkKz/F
	 f7I6mpo3ZZjmqaIo+fPmDN2OosYlkZKThgaGzYZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	=?UTF-8?q?Andr=E9=20Draszik?= <andre.draszik@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bean Huo <beanhuo@micron.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 6.1 135/969] scsi: ufs: core: Fix use-after free in init error and remove paths
Date: Sat, 30 May 2026 17:54:19 +0200
Message-ID: <20260530160304.296123392@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit f8fb2403ddebb5eea0033d90d9daae4c88749ada ]

devm_blk_crypto_profile_init() registers a cleanup handler to run when
the associated (platform-) device is being released. For UFS, the
crypto private data and pointers are stored as part of the ufs_hba's
data structure 'struct ufs_hba::crypto_profile'. This structure is
allocated as part of the underlying ufshcd and therefore Scsi_host
allocation.

During driver release or during error handling in ufshcd_pltfrm_init(),
this structure is released as part of ufshcd_dealloc_host() before the
(platform-) device associated with the crypto call above is released.
Once this device is released, the crypto cleanup code will run, using
the just-released 'struct ufs_hba::crypto_profile'. This causes a
use-after-free situation:

  Call trace:
   kfree+0x60/0x2d8 (P)
   kvfree+0x44/0x60
   blk_crypto_profile_destroy_callback+0x28/0x70
   devm_action_release+0x1c/0x30
   release_nodes+0x6c/0x108
   devres_release_all+0x98/0x100
   device_unbind_cleanup+0x20/0x70
   really_probe+0x218/0x2d0

In other words, the initialisation code flow is:

  platform-device probe
    ufshcd_pltfrm_init()
      ufshcd_alloc_host()
        scsi_host_alloc()
          allocation of struct ufs_hba
          creation of scsi-host devices
    devm_blk_crypto_profile_init()
      devm registration of cleanup handler using platform-device

and during error handling of ufshcd_pltfrm_init() or during driver
removal:

  ufshcd_dealloc_host()
    scsi_host_put()
      put_device(scsi-host)
        release of struct ufs_hba
  put_device(platform-device)
    crypto cleanup handler

To fix this use-after free, change ufshcd_alloc_host() to register a
devres action to automatically cleanup the underlying SCSI device on
ufshcd destruction, without requiring explicit calls to
ufshcd_dealloc_host(). This way:

    * the crypto profile and all other ufs_hba-owned resources are
      destroyed before SCSI (as they've been registered after)
    * a memleak is plugged in tc-dwc-g210-pci.c remove() as a
      side-effect
    * EXPORT_SYMBOL_GPL(ufshcd_dealloc_host) can be removed fully as
      it's not needed anymore
    * no future drivers using ufshcd_alloc_host() could ever forget
      adding the cleanup

Fixes: cb77cb5abe1f ("blk-crypto: rename blk_keyslot_manager to blk_crypto_profile")
Fixes: d76d9d7d1009 ("scsi: ufs: use devm_blk_ksm_init()")
Cc: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/20250124-ufshcd-fix-v4-1-c5d0144aae59@linaro.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[ Delete modifications about ufshcd_parse_operating_points() for it's added from
commit 72208ebe181e3("scsi: ufs: core: Add support for parsing OPP")
and that in ufshcd_pltfrm_remove() for it's added from commit
897df60c16d54("scsi: ufs: pltfrm: Dellocate HBA during ufshcd_pltfrm_remove()"). ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c        |   31 +++++++++++++++++++++----------
 drivers/ufs/host/ufshcd-pci.c    |    2 --
 drivers/ufs/host/ufshcd-pltfrm.c |   25 ++++++++-----------------
 include/ufs/ufshcd.h             |    1 -
 4 files changed, 29 insertions(+), 30 deletions(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9662,16 +9662,6 @@ void ufshcd_remove(struct ufs_hba *hba)
 EXPORT_SYMBOL_GPL(ufshcd_remove);
 
 /**
- * ufshcd_dealloc_host - deallocate Host Bus Adapter (HBA)
- * @hba: pointer to Host Bus Adapter (HBA)
- */
-void ufshcd_dealloc_host(struct ufs_hba *hba)
-{
-	scsi_host_put(hba->host);
-}
-EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
-
-/**
  * ufshcd_set_dma_mask - Set dma mask based on the controller
  *			 addressing capability
  * @hba: per adapter instance
@@ -9690,10 +9680,24 @@ static int ufshcd_set_dma_mask(struct uf
 }
 
 /**
+ * ufshcd_devres_release - devres cleanup handler, invoked during release of
+ *			   hba->dev
+ * @host: pointer to SCSI host
+ */
+static void ufshcd_devres_release(void *host)
+{
+	scsi_host_put(host);
+}
+
+/**
  * ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
  * @dev: pointer to device handle
  * @hba_handle: driver private handle
  * Returns 0 on success, non-zero value on failure
+ *
+ * NOTE: There is no corresponding ufshcd_dealloc_host() because this function
+ * keeps track of its allocations using devres and deallocates everything on
+ * device removal automatically.
  */
 int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 {
@@ -9715,6 +9719,13 @@ int ufshcd_alloc_host(struct device *dev
 		err = -ENOMEM;
 		goto out_error;
 	}
+
+	err = devm_add_action_or_reset(dev, ufshcd_devres_release,
+				       host);
+	if (err)
+		return dev_err_probe(dev, err,
+				     "failed to add ufshcd dealloc action\n");
+
 	host->nr_maps = HCTX_TYPE_POLL + 1;
 	hba = shost_priv(host);
 	hba->host = host;
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -629,7 +629,6 @@ static void ufshcd_pci_remove(struct pci
 	pm_runtime_forbid(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 	ufshcd_remove(hba);
-	ufshcd_dealloc_host(hba);
 }
 
 /**
@@ -674,7 +673,6 @@ ufshcd_pci_probe(struct pci_dev *pdev, c
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
 	if (err) {
 		dev_err(&pdev->dev, "Initialization failed\n");
-		ufshcd_dealloc_host(hba);
 		return err;
 	}
 
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -343,21 +343,17 @@ int ufshcd_pltfrm_init(struct platform_d
 	struct device *dev = &pdev->dev;
 
 	mmio_base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(mmio_base)) {
-		err = PTR_ERR(mmio_base);
-		goto out;
-	}
+	if (IS_ERR(mmio_base))
+		return PTR_ERR(mmio_base);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		err = irq;
-		goto out;
-	}
+	if (irq < 0)
+		return irq;
 
 	err = ufshcd_alloc_host(dev, &hba);
 	if (err) {
 		dev_err(dev, "Allocation failed\n");
-		goto out;
+		return err;
 	}
 
 	hba->vops = vops;
@@ -366,13 +362,13 @@ int ufshcd_pltfrm_init(struct platform_d
 	if (err) {
 		dev_err(dev, "%s: clock parse failed %d\n",
 				__func__, err);
-		goto dealloc_host;
+		return err;
 	}
 	err = ufshcd_parse_regulator_info(hba);
 	if (err) {
 		dev_err(dev, "%s: regulator init failed %d\n",
 				__func__, err);
-		goto dealloc_host;
+		return err;
 	}
 
 	ufshcd_init_lanes_per_dir(hba);
@@ -380,18 +376,13 @@ int ufshcd_pltfrm_init(struct platform_d
 	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
 		dev_err(dev, "Initialization failed\n");
-		goto dealloc_host;
+		return err;
 	}
 
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
 	return 0;
-
-dealloc_host:
-	ufshcd_dealloc_host(hba);
-out:
-	return err;
 }
 EXPORT_SYMBOL_GPL(ufshcd_pltfrm_init);
 
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1063,7 +1063,6 @@ static inline void ufshcd_rmwl(struct uf
 }
 
 int ufshcd_alloc_host(struct device *, struct ufs_hba **);
-void ufshcd_dealloc_host(struct ufs_hba *);
 int ufshcd_hba_enable(struct ufs_hba *hba);
 int ufshcd_init(struct ufs_hba *, void __iomem *, unsigned int);
 int ufshcd_link_recovery(struct ufs_hba *hba);


