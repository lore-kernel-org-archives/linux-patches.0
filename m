Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E858462;
	Thu, 17 Apr 2025 18:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913767; cv=none; b=n+6sWUK4VvZ2tijJWOQDR901SIk3KFRPKn5R4n6r+7H8M8Dn9uukqT1om57NPlLXjuYYXKNgSw0TIoZk8xFtAi13CR44QxIrULjPwIXrQee+AypoZ8li49q/c4S2w9LOq+k13+G0v0tSTNLHwJYH7HWu6rPEwiet3QgguQCJLfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913767; c=relaxed/simple;
	bh=zM4UfUdN77AHaM9azH+7e0lWRfdKT5Yk1e6h0ji4VN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fE5g1tiyhFeoTJjydHDKaMAt3YvF+yzk48CuJM+6+MFhL3cbCRQf5kZ/v81cqGd9Y7ZWDAq4MiW8eZQDdCoN9CN4sGYSFu2Xht2M897I1RBjBLEWvvNwIt6BXFrD+fGYpcGPq4/SKZWMfpe3fNokSncKuxVcqXRK0HnwXHxykxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9k3MwVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9k3MwVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8918C4CEE4;
	Thu, 17 Apr 2025 18:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913767;
	bh=zM4UfUdN77AHaM9azH+7e0lWRfdKT5Yk1e6h0ji4VN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9k3MwVdaDwhgYPu1s2QZuUAyf9mrVhM7NKHN41J12JA29w4fOKcQW6Aejx+inUZf
	 +lskTK0x7+kK3EcBw5PgDuVP0ApivXQsyvnGB43J81h5JlOpYSNbkTis5dKRYDFeuC
	 MNTsK6K3mLIdCT4wYKcUboybtbdbpDFszGR0DLgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.14 446/449] iommufd: Make attach_handle generic than fault specific
Date: Thu, 17 Apr 2025 19:52:14 +0200
Message-ID: <20250417175136.268837259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

commit fb21b1568adaa76af7a8c853f37c60fba8b28661 upstream.

"attach_handle" was added exclusively for the iommufd_fault_iopf_handler()
used by IOPF/PRI use cases. Now, both the MSI and PASID series require to
reuse the attach_handle for non-fault cases.

Add a set of new attach/detach/replace helpers that does the attach_handle
allocation/releasing/replacement in the common path and also handles those
fault specific routines such as iopf enabling/disabling and auto response.

This covers both non-fault and fault cases in a clean way, replacing those
inline helpers in the header. The following patch will clean up those old
helpers in the fault.c file.

Link: https://patch.msgid.link/r/32687df01c02291d89986a9fca897bbbe2b10987.1738645017.git.nicolinc@nvidia.com
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/device.c          |  105 ++++++++++++++++++++++++++++++++
 drivers/iommu/iommufd/fault.c           |    8 +-
 drivers/iommu/iommufd/iommufd_private.h |   33 +---------
 3 files changed, 113 insertions(+), 33 deletions(-)

--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -352,6 +352,111 @@ iommufd_device_attach_reserved_iova(stru
 	return 0;
 }
 
+/* The device attach/detach/replace helpers for attach_handle */
+
+static int iommufd_hwpt_attach_device(struct iommufd_hw_pagetable *hwpt,
+				      struct iommufd_device *idev)
+{
+	struct iommufd_attach_handle *handle;
+	int rc;
+
+	lockdep_assert_held(&idev->igroup->lock);
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	if (hwpt->fault) {
+		rc = iommufd_fault_iopf_enable(idev);
+		if (rc)
+			goto out_free_handle;
+	}
+
+	handle->idev = idev;
+	rc = iommu_attach_group_handle(hwpt->domain, idev->igroup->group,
+				       &handle->handle);
+	if (rc)
+		goto out_disable_iopf;
+
+	return 0;
+
+out_disable_iopf:
+	if (hwpt->fault)
+		iommufd_fault_iopf_disable(idev);
+out_free_handle:
+	kfree(handle);
+	return rc;
+}
+
+static struct iommufd_attach_handle *
+iommufd_device_get_attach_handle(struct iommufd_device *idev)
+{
+	struct iommu_attach_handle *handle;
+
+	lockdep_assert_held(&idev->igroup->lock);
+
+	handle =
+		iommu_attach_handle_get(idev->igroup->group, IOMMU_NO_PASID, 0);
+	if (IS_ERR(handle))
+		return NULL;
+	return to_iommufd_handle(handle);
+}
+
+static void iommufd_hwpt_detach_device(struct iommufd_hw_pagetable *hwpt,
+				       struct iommufd_device *idev)
+{
+	struct iommufd_attach_handle *handle;
+
+	handle = iommufd_device_get_attach_handle(idev);
+	iommu_detach_group_handle(hwpt->domain, idev->igroup->group);
+	if (hwpt->fault) {
+		iommufd_auto_response_faults(hwpt, handle);
+		iommufd_fault_iopf_disable(idev);
+	}
+	kfree(handle);
+}
+
+static int iommufd_hwpt_replace_device(struct iommufd_device *idev,
+				       struct iommufd_hw_pagetable *hwpt,
+				       struct iommufd_hw_pagetable *old)
+{
+	struct iommufd_attach_handle *handle, *old_handle =
+		iommufd_device_get_attach_handle(idev);
+	int rc;
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	if (hwpt->fault && !old->fault) {
+		rc = iommufd_fault_iopf_enable(idev);
+		if (rc)
+			goto out_free_handle;
+	}
+
+	handle->idev = idev;
+	rc = iommu_replace_group_handle(idev->igroup->group, hwpt->domain,
+					&handle->handle);
+	if (rc)
+		goto out_disable_iopf;
+
+	if (old->fault) {
+		iommufd_auto_response_faults(hwpt, old_handle);
+		if (!hwpt->fault)
+			iommufd_fault_iopf_disable(idev);
+	}
+	kfree(old_handle);
+
+	return 0;
+
+out_disable_iopf:
+	if (hwpt->fault && !old->fault)
+		iommufd_fault_iopf_disable(idev);
+out_free_handle:
+	kfree(handle);
+	return rc;
+}
+
 int iommufd_hw_pagetable_attach(struct iommufd_hw_pagetable *hwpt,
 				struct iommufd_device *idev)
 {
--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -17,7 +17,7 @@
 #include "../iommu-priv.h"
 #include "iommufd_private.h"
 
-static int iommufd_fault_iopf_enable(struct iommufd_device *idev)
+int iommufd_fault_iopf_enable(struct iommufd_device *idev)
 {
 	struct device *dev = idev->dev;
 	int ret;
@@ -50,7 +50,7 @@ static int iommufd_fault_iopf_enable(str
 	return ret;
 }
 
-static void iommufd_fault_iopf_disable(struct iommufd_device *idev)
+void iommufd_fault_iopf_disable(struct iommufd_device *idev)
 {
 	mutex_lock(&idev->iopf_lock);
 	if (!WARN_ON(idev->iopf_enabled == 0)) {
@@ -98,8 +98,8 @@ int iommufd_fault_domain_attach_dev(stru
 	return ret;
 }
 
-static void iommufd_auto_response_faults(struct iommufd_hw_pagetable *hwpt,
-					 struct iommufd_attach_handle *handle)
+void iommufd_auto_response_faults(struct iommufd_hw_pagetable *hwpt,
+				  struct iommufd_attach_handle *handle)
 {
 	struct iommufd_fault *fault = hwpt->fault;
 	struct iopf_group *group, *next;
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -504,35 +504,10 @@ int iommufd_fault_domain_replace_dev(str
 				     struct iommufd_hw_pagetable *hwpt,
 				     struct iommufd_hw_pagetable *old);
 
-static inline int iommufd_hwpt_attach_device(struct iommufd_hw_pagetable *hwpt,
-					     struct iommufd_device *idev)
-{
-	if (hwpt->fault)
-		return iommufd_fault_domain_attach_dev(hwpt, idev);
-
-	return iommu_attach_group(hwpt->domain, idev->igroup->group);
-}
-
-static inline void iommufd_hwpt_detach_device(struct iommufd_hw_pagetable *hwpt,
-					      struct iommufd_device *idev)
-{
-	if (hwpt->fault) {
-		iommufd_fault_domain_detach_dev(hwpt, idev);
-		return;
-	}
-
-	iommu_detach_group(hwpt->domain, idev->igroup->group);
-}
-
-static inline int iommufd_hwpt_replace_device(struct iommufd_device *idev,
-					      struct iommufd_hw_pagetable *hwpt,
-					      struct iommufd_hw_pagetable *old)
-{
-	if (old->fault || hwpt->fault)
-		return iommufd_fault_domain_replace_dev(idev, hwpt, old);
-
-	return iommu_group_replace_domain(idev->igroup->group, hwpt->domain);
-}
+int iommufd_fault_iopf_enable(struct iommufd_device *idev);
+void iommufd_fault_iopf_disable(struct iommufd_device *idev);
+void iommufd_auto_response_faults(struct iommufd_hw_pagetable *hwpt,
+				  struct iommufd_attach_handle *handle);
 
 static inline struct iommufd_viommu *
 iommufd_get_viommu(struct iommufd_ucmd *ucmd, u32 id)


