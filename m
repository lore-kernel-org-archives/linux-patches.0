Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A4838655E;
	Fri,  7 Aug 2026 15:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115111; cv=none; b=lNXV2R2AvH6p2udY9BuzwECLmU8MI0a2CkSQ0nOVgi8Ok4E3jKnz6vi59YGaK/6DKWsYHpHKK8vjJfSXHqFWsKl6wGfFQV7mluydx/pJkKt6+PGkr+mvC57Xq5JpKE2kZXVZow8847eIS6IPO5N7e8CUa4axmHp8WwIK2D5xyqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115111; c=relaxed/simple;
	bh=c9tQNcFQEaALVAm72Z+4yxsOo76IDJWlcAKMWP6Dy50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZ+XbWHfufs9HQ+agwvdckRE2/f0JBi2EsGrk+tlrckzds3rTmnlUNiwon9iMJMmpJvE656R0nC8vA66+XhmYw7MHKYw36b32gotaq1kF8Z/ZOUcfumZtBEIRdNDAFtf+knKPKAp7zfmJdfiqNsnl4Dwscm3WrfthoQvvmu1+SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14JAynjn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14JAynjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A391F000E9;
	Fri,  7 Aug 2026 15:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115110;
	bh=8+umLwAvwnfzYU2VfOTOFfX/5nZ7C5/byO6C2hGN9Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14JAynjn7j0+ZwdDK0T6cDZ/QD2zgqSC0kPIoRUTWufRSjAJhYUUe9s30bCx8zCl4
	 fZN5FqCbcxiFtHzB3jhcMufxBOIIkHcdzx8mq6PQXGV7Y06xiKHS8TTqtK3sJBVICM
	 XN3PcphZiSeTZUJ6t33IeCQ64/z4SeoAxN0v9jzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 161/396] iommufd/viommu: Publish a vDEVICE only after vdevice_init() succeeds
Date: Fri,  7 Aug 2026 16:35:21 +0200
Message-ID: <20260807143427.778272728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/iommu/iommufd/viommu.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
index 0c12c7e352a1..fc13cf4737ea 100644
--- a/drivers/iommu/iommufd/viommu.c
+++ b/drivers/iommu/iommufd/viommu.c
@@ -143,7 +143,7 @@ void iommufd_vdevice_destroy(struct iommufd_object *obj)
 int iommufd_vdevice_alloc_ioctl(struct iommufd_ucmd *ucmd)
 {
 	struct iommu_vdevice_alloc *cmd = ucmd->cmd;
-	struct iommufd_vdevice *vdev, *curr;
+	struct iommufd_vdevice *vdev;
 	size_t vdev_size = sizeof(*vdev);
 	struct iommufd_viommu *viommu;
 	struct iommufd_device *idev;
@@ -218,18 +218,28 @@ int iommufd_vdevice_alloc_ioctl(struct iommufd_ucmd *ucmd)
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
-- 
2.55.0



