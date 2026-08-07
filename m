Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED0A473C63;
	Fri,  7 Aug 2026 15:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117098; cv=none; b=dC9SEaVYYdYmFupTNeFhzDd2tW8zahhRg63Lsgm4ehepdWy+tFDD4GTwS6E7bD1IW2Az+epAAoKuxRFuuQKtTfHMqBq7cI9i8g16YApRpMWzr2SAKDhxU8Q7eLbnNbp3ssTEmK5uU7k+JiUaZS53FBNAxWCwZTi7H+cJThBxCAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117098; c=relaxed/simple;
	bh=9x1KcNpJOi5GYGyr+GgOvGCCOgFH9AwupcG9L74LR+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqH8T85HEztAIlGiFvWDA6KRP3MVwXV/yUxcZXlqHFES4BokocgGv8veyFY9ymQXaGLWjWMUj+cYkyMBElvXFfFlzrOTYcU+xN41qcNaEFtAEjZzd3lxlixebdtjl2ksXTm0QY9rvsDsL4R1lJDCcPqatiXsNGdqwLdtD41NBww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAFTO1Mp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAFTO1Mp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54EA1F000E9;
	Fri,  7 Aug 2026 15:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117097;
	bh=ccY1ZmUjWz0zoESbmyR+4Nh2+Lw/Dtk0gL+0ZGTYrow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UAFTO1MpuXLs/MxQQbLMKopu6JHvL9U0N6NS/xX4LokStRKD8Fo5/05LOPDXsLAzq
	 +FWV/YVc/FqzB3fL3Nna66PDMOxFbAQbgnxPwR4NmHbWA0rf5cyNKhpwfI9Pv9ywce
	 gowHQZ+C9HvL59Imvydd2oCPxIUAzL7dpcI7GB0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.1 198/438] iommufd/viommu: Publish a vDEVICE only after vdevice_init() succeeds
Date: Fri,  7 Aug 2026 16:36:34 +0200
Message-ID: <20260807143432.244662068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 9be311cfbe6154da146a7408e0d5e518a9321ed3 upstream.

iommufd_vdevice_alloc_ioctl() adds the vDEVICE to the viommu->vdevs xarray
with xa_cmpxchg() before the driver's vdevice_init() op runs. That op is
where a driver validates the device and may reject it, but the xarray entry
is already live by then: a concurrent IOMMU_HWPT_INVALIDATE can look it up
with iommufd_viommu_find_dev() and run the driver invalidation path against
a device that vdevice_init() would have refused.

Reserve the index with xa_insert(): it stores a zero entry that reads back
as NULL, and returns -EBUSY on a duplicate virt_id. Run vdevice_init() and
store the vDEVICE pointer only once it succeeds. A failed vdevice_init()
releases the reservation, so lookups observe the vDEVICE only after it is
fully initialized and accepted.

Fixes: ed42eee797ff3 ("iommufd/viommu: Add driver-defined vDEVICE support")
Link: https://patch.msgid.link/r/1e05999347f4bf583edbc6a1312c857d5548708c.1783311134.git.nicolinc@nvidia.com
Cc: stable@vger.kernel.org
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/viommu.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -143,7 +143,7 @@ void iommufd_vdevice_destroy(struct iomm
 int iommufd_vdevice_alloc_ioctl(struct iommufd_ucmd *ucmd)
 {
 	struct iommu_vdevice_alloc *cmd = ucmd->cmd;
-	struct iommufd_vdevice *vdev, *curr;
+	struct iommufd_vdevice *vdev;
 	size_t vdev_size = sizeof(*vdev);
 	struct iommufd_viommu *viommu;
 	struct iommufd_device *idev;
@@ -218,18 +218,28 @@ int iommufd_vdevice_alloc_ioctl(struct i
 	 */
 	idev->vdev = vdev;
 
-	curr = xa_cmpxchg(&viommu->vdevs, virt_id, NULL, vdev, GFP_KERNEL);
-	if (curr) {
-		rc = xa_err(curr) ?: -EEXIST;
+	/*
+	 * Reserve the slot with a zero entry (reads back as NULL) until the
+	 * vdevice_init() op accepts the vDEVICE. Only the xa_* helpers hide a
+	 * reserved entry, so never use a raw xas_* iterator on this xarray.
+	 */
+	rc = xa_insert(&viommu->vdevs, virt_id, NULL, GFP_KERNEL);
+	if (rc) {
+		if (rc == -EBUSY)
+			rc = -EEXIST;
 		goto out_abort;
 	}
 
 	if (viommu->ops && viommu->ops->vdevice_init) {
 		rc = viommu->ops->vdevice_init(vdev);
-		if (rc)
+		if (rc) {
+			xa_release(&viommu->vdevs, virt_id);
 			goto out_abort;
+		}
 	}
 
+	xa_store(&viommu->vdevs, virt_id, vdev, GFP_KERNEL);
+
 	cmd->out_vdevice_id = vdev->obj.id;
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 	if (rc)


