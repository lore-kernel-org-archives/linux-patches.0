Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D040122D9E3;
	Mon,  2 Jun 2025 15:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877295; cv=none; b=OPif13XG9vC2cI03yNjYsDEBj5wEdsS8kVOyBOEzgRXl8HPxnGcKuiqc9kiHoqbC7UJmiOjzsXBxQ2SrxKZZM6yRdFzpTOFUaVYBmtTtuBLg6lBR2YEc+kGNKH8YuygRNySXKOPhChCvtgCTdV+HucmYr+SgWYLMs0FnZq0jsBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877295; c=relaxed/simple;
	bh=envWMiSRLDSR0s+ObDvzvWHgNq59/+PQuDjClTYHezo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBFfpH9Xco1xQU8HwoNwOWLp+FCZCZVnRS05i6sEs5OR1uYwMZ4FZiTZqIUSgrUtPfyeoEEEf7x7RqNSr/AfKQi+odtURwh909Uau+GJtFTsG0YrSdHPI4Z8L3b3BTeSTxvkIMVm91lmN3OR4Sr5wgYmnnb2o0ur/SDcqzZDAco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCdaONoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCdaONoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C814C4CEEB;
	Mon,  2 Jun 2025 15:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877295;
	bh=envWMiSRLDSR0s+ObDvzvWHgNq59/+PQuDjClTYHezo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCdaONoVUbX+2rSNuT6Fvg55HvUqGuipGsFCwstYZBilxS6o7hrNe8G50e4pkN/5p
	 auIAxrV0dST13eEGc+dH3cQR78+9/R4xhGL4hZ9imNxLUruXOPdNTSaufVii6gnEsi
	 ebOIUZ6WZJ0xrnRW4t7lpC/7X1DqWHqh5tzeQVPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Tony Luck <tony.luck@intel.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 232/325] dmaengine: idxd: add idxd_copy_cr() to copy user completion record during page fault handling
Date: Mon,  2 Jun 2025 15:48:28 +0200
Message-ID: <20250602134329.206272197@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit b022f59725f0ae846191abbd6d2e611d7f60f826 ]

Define idxd_copy_cr() to copy completion record to fault address in
user address that is found by work queue (wq) and PASID.

It will be used to write the user's completion record that the hardware
device is not able to write due to user completion record page fault.

An xarray is added to associate the PASID and mm with the
struct idxd_user_context so mm can be found by PASID and wq.

It is called when handling the completion record fault in a kernel thread
context. Switch to the mm using kthread_use_vm() and copy the
completion record to the mm via copy_to_user(). Once the copy is
completed, switch back to the current mm using kthread_unuse_mm().

Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Suggested-by: Tony Luck <tony.luck@intel.com>
Tested-by: Tony Zhu <tony.zhu@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20230407203143.2189681-9-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 8dfa57aabff6 ("dmaengine: idxd: Fix allowing write() from different address spaces")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c  | 107 +++++++++++++++++++++++++++++++++++++--
 drivers/dma/idxd/idxd.h  |   6 +++
 drivers/dma/idxd/init.c  |   2 +
 drivers/dma/idxd/sysfs.c |   1 +
 4 files changed, 111 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index e2a89873c6e1a..c7aa47f01df02 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -12,7 +12,9 @@
 #include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/iommu.h>
+#include <linux/highmem.h>
 #include <uapi/linux/idxd.h>
+#include <linux/xarray.h>
 #include "registers.h"
 #include "idxd.h"
 
@@ -35,6 +37,7 @@ struct idxd_user_context {
 	struct idxd_wq *wq;
 	struct task_struct *task;
 	unsigned int pasid;
+	struct mm_struct *mm;
 	unsigned int flags;
 	struct iommu_sva *sva;
 };
@@ -69,6 +72,19 @@ static inline struct idxd_wq *inode_wq(struct inode *inode)
 	return idxd_cdev->wq;
 }
 
+static void idxd_xa_pasid_remove(struct idxd_user_context *ctx)
+{
+	struct idxd_wq *wq = ctx->wq;
+	void *ptr;
+
+	mutex_lock(&wq->uc_lock);
+	ptr = xa_cmpxchg(&wq->upasid_xa, ctx->pasid, ctx, NULL, GFP_KERNEL);
+	if (ptr != (void *)ctx)
+		dev_warn(&wq->idxd->pdev->dev, "xarray cmpxchg failed for pasid %u\n",
+			 ctx->pasid);
+	mutex_unlock(&wq->uc_lock);
+}
+
 static int idxd_cdev_open(struct inode *inode, struct file *filp)
 {
 	struct idxd_user_context *ctx;
@@ -109,20 +125,26 @@ static int idxd_cdev_open(struct inode *inode, struct file *filp)
 
 		pasid = iommu_sva_get_pasid(sva);
 		if (pasid == IOMMU_PASID_INVALID) {
-			iommu_sva_unbind_device(sva);
 			rc = -EINVAL;
-			goto failed;
+			goto failed_get_pasid;
 		}
 
 		ctx->sva = sva;
 		ctx->pasid = pasid;
+		ctx->mm = current->mm;
+
+		mutex_lock(&wq->uc_lock);
+		rc = xa_insert(&wq->upasid_xa, pasid, ctx, GFP_KERNEL);
+		mutex_unlock(&wq->uc_lock);
+		if (rc < 0)
+			dev_warn(dev, "PASID entry already exist in xarray.\n");
 
 		if (wq_dedicated(wq)) {
 			rc = idxd_wq_set_pasid(wq, pasid);
 			if (rc < 0) {
 				iommu_sva_unbind_device(sva);
 				dev_err(dev, "wq set pasid failed: %d\n", rc);
-				goto failed;
+				goto failed_set_pasid;
 			}
 		}
 	}
@@ -131,7 +153,13 @@ static int idxd_cdev_open(struct inode *inode, struct file *filp)
 	mutex_unlock(&wq->wq_lock);
 	return 0;
 
- failed:
+failed_set_pasid:
+	if (device_user_pasid_enabled(idxd))
+		idxd_xa_pasid_remove(ctx);
+failed_get_pasid:
+	if (device_user_pasid_enabled(idxd))
+		iommu_sva_unbind_device(sva);
+failed:
 	mutex_unlock(&wq->wq_lock);
 	kfree(ctx);
 	return rc;
@@ -162,8 +190,10 @@ static int idxd_cdev_release(struct inode *node, struct file *filep)
 		}
 	}
 
-	if (ctx->sva)
+	if (ctx->sva) {
 		iommu_sva_unbind_device(ctx->sva);
+		idxd_xa_pasid_remove(ctx);
+	}
 	kfree(ctx);
 	mutex_lock(&wq->wq_lock);
 	idxd_wq_put(wq);
@@ -496,3 +526,70 @@ void idxd_cdev_remove(void)
 		ida_destroy(&ictx[i].minor_ida);
 	}
 }
+
+/**
+ * idxd_copy_cr - copy completion record to user address space found by wq and
+ *		  PASID
+ * @wq:		work queue
+ * @pasid:	PASID
+ * @addr:	user fault address to write
+ * @cr:		completion record
+ * @len:	number of bytes to copy
+ *
+ * This is called by a work that handles completion record fault.
+ *
+ * Return: number of bytes copied.
+ */
+int idxd_copy_cr(struct idxd_wq *wq, ioasid_t pasid, unsigned long addr,
+		 void *cr, int len)
+{
+	struct device *dev = &wq->idxd->pdev->dev;
+	int left = len, status_size = 1;
+	struct idxd_user_context *ctx;
+	struct mm_struct *mm;
+
+	mutex_lock(&wq->uc_lock);
+
+	ctx = xa_load(&wq->upasid_xa, pasid);
+	if (!ctx) {
+		dev_warn(dev, "No user context\n");
+		goto out;
+	}
+
+	mm = ctx->mm;
+	/*
+	 * The completion record fault handling work is running in kernel
+	 * thread context. It temporarily switches to the mm to copy cr
+	 * to addr in the mm.
+	 */
+	kthread_use_mm(mm);
+	left = copy_to_user((void __user *)addr + status_size, cr + status_size,
+			    len - status_size);
+	/*
+	 * Copy status only after the rest of completion record is copied
+	 * successfully so that the user gets the complete completion record
+	 * when a non-zero status is polled.
+	 */
+	if (!left) {
+		u8 status;
+
+		/*
+		 * Ensure that the completion record's status field is written
+		 * after the rest of the completion record has been written.
+		 * This ensures that the user receives the correct completion
+		 * record information once polling for a non-zero status.
+		 */
+		wmb();
+		status = *(u8 *)cr;
+		if (put_user(status, (u8 __user *)addr))
+			left += status_size;
+	} else {
+		left += status_size;
+	}
+	kthread_unuse_mm(mm);
+
+out:
+	mutex_unlock(&wq->uc_lock);
+
+	return len - left;
+}
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 5dbb67ff1c0cb..c3ace4aed0fc5 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -215,6 +215,10 @@ struct idxd_wq {
 	char name[WQ_NAME_SIZE + 1];
 	u64 max_xfer_bytes;
 	u32 max_batch_size;
+
+	/* Lock to protect upasid_xa access. */
+	struct mutex uc_lock;
+	struct xarray upasid_xa;
 };
 
 struct idxd_engine {
@@ -666,6 +670,8 @@ void idxd_cdev_remove(void);
 int idxd_cdev_get_major(struct idxd_device *idxd);
 int idxd_wq_add_cdev(struct idxd_wq *wq);
 void idxd_wq_del_cdev(struct idxd_wq *wq);
+int idxd_copy_cr(struct idxd_wq *wq, ioasid_t pasid, unsigned long addr,
+		 void *buf, int len);
 
 /* perfmon */
 #if IS_ENABLED(CONFIG_INTEL_IDXD_PERFMON)
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 7cb76db5ad600..ea651d5cf332d 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -218,6 +218,8 @@ static int idxd_setup_wqs(struct idxd_device *idxd)
 			}
 			bitmap_copy(wq->opcap_bmap, idxd->opcap_bmap, IDXD_MAX_OPCAP_BITS);
 		}
+		mutex_init(&wq->uc_lock);
+		xa_init(&wq->upasid_xa);
 		idxd->wqs[i] = wq;
 	}
 
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index c811757d0f97f..0689464c4816a 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1315,6 +1315,7 @@ static void idxd_conf_wq_release(struct device *dev)
 
 	bitmap_free(wq->opcap_bmap);
 	kfree(wq->wqcfg);
+	xa_destroy(&wq->upasid_xa);
 	kfree(wq);
 }
 
-- 
2.39.5



