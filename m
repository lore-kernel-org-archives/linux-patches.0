Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5C35349BA;
	Wed, 30 Sep 2026 17:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789727; cv=none; b=qrQcjIPsfyQroURzjM0k16GJwUpQaTJJFZXfsUCUCXQDathwF3AqJYefD2ELU0T3R3yXoddatZ2JUuHR5MB+VP/xF25ywnstG8qVnbupuDYH6w42ZR71d2Rca9hT97g+oVR6aMmast29SsUWxy9egpBzOzql5qLtbbygJm/5py0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789727; c=relaxed/simple;
	bh=S+VpHYb07qYb+ArIe8q17vRYDVbBYrP1EW5sPWqvGzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6THsb9vVXppLz0ZD7Q96DTvG4hSo+AUe7CC9lbJQEKm0/BfCzAbY6KfLu5KMZQ+PNL3nxJDn8rrgvH5UD58xjS0xLJEjhdUpXcqa6FFBis67DMsghCY7wtwCGBIh0NpVqUxPcNDJvVSDKxTqFCnGc9SnsSKTfLFG+V1C2Lf+QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z42DB6wQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z42DB6wQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F851F008BC;
	Wed, 30 Sep 2026 17:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789723;
	bh=LojCq2f1EqiSjPjA7bE6Abqk8kcW7zqhxwvGS1TYjQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z42DB6wQmKooSiw7SiKo94qOSg+cWOVxZeqHnbXOeFJlSmh7LidanXCUozuiS8her
	 BxdUYPMW48z2AXVPWshNv0/M5ObSov6dOivbkA+dec1A7fOW8kNR9lDJzw++r/MpAe
	 6KOiwqj75UMZ3gqa246TWmnHD33YUVclXd+1nDoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 577/877] iommufd: Pass @pasid through the device attach/replace path
Date: Wed, 30 Sep 2026 17:24:48 +0200
Message-ID: <20260930152427.094326165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <yi.l.liu@intel.com>

[ Upstream commit 03c9b102bea6f4f0b517c841fe1d2f9c616c95b9 ]

Most of the core logic before conducting the actual device attach/
replace operation can be shared with pasid attach/replace. So pass
@pasid through the device attach/replace helpers to prepare adding
pasid attach/replace.

So far the @pasid should only be IOMMU_NO_PASID. No functional change.

Link: https://patch.msgid.link/r/20250321171940.7213-4-yi.l.liu@intel.com
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 8c07df7cdfcf ("iommufd: Fix UAF in selftest IOPF reporting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/device.c          |   70 ++++++++++++++++++--------------
 drivers/iommu/iommufd/hw_pagetable.c    |   13 +++--
 drivers/iommu/iommufd/iommufd_private.h |    8 +--
 3 files changed, 52 insertions(+), 39 deletions(-)

--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -367,7 +367,8 @@ static bool iommufd_device_is_attached(s
 }
 
 static int iommufd_hwpt_attach_device(struct iommufd_hw_pagetable *hwpt,
-				      struct iommufd_device *idev)
+				      struct iommufd_device *idev,
+				      ioasid_t pasid)
 {
 	struct iommufd_attach_handle *handle;
 	int rc;
@@ -385,6 +386,7 @@ static int iommufd_hwpt_attach_device(st
 	}
 
 	handle->idev = idev;
+	WARN_ON(pasid != IOMMU_NO_PASID);
 	rc = iommu_attach_group_handle(hwpt->domain, idev->igroup->group,
 				       &handle->handle);
 	if (rc)
@@ -401,25 +403,28 @@ out_free_handle:
 }
 
 static struct iommufd_attach_handle *
-iommufd_device_get_attach_handle(struct iommufd_device *idev)
+iommufd_device_get_attach_handle(struct iommufd_device *idev, ioasid_t pasid)
 {
 	struct iommu_attach_handle *handle;
 
 	lockdep_assert_held(&idev->igroup->lock);
 
 	handle =
-		iommu_attach_handle_get(idev->igroup->group, IOMMU_NO_PASID, 0);
+		iommu_attach_handle_get(idev->igroup->group, pasid, 0);
 	if (IS_ERR(handle))
 		return NULL;
 	return to_iommufd_handle(handle);
 }
 
 static void iommufd_hwpt_detach_device(struct iommufd_hw_pagetable *hwpt,
-				       struct iommufd_device *idev)
+				       struct iommufd_device *idev,
+				       ioasid_t pasid)
 {
 	struct iommufd_attach_handle *handle;
 
-	handle = iommufd_device_get_attach_handle(idev);
+	WARN_ON(pasid != IOMMU_NO_PASID);
+
+	handle = iommufd_device_get_attach_handle(idev, pasid);
 	iommu_detach_group_handle(hwpt->domain, idev->igroup->group);
 	if (hwpt->fault) {
 		iommufd_auto_response_faults(hwpt, handle);
@@ -429,13 +434,17 @@ static void iommufd_hwpt_detach_device(s
 }
 
 static int iommufd_hwpt_replace_device(struct iommufd_device *idev,
+				       ioasid_t pasid,
 				       struct iommufd_hw_pagetable *hwpt,
 				       struct iommufd_hw_pagetable *old)
 {
-	struct iommufd_attach_handle *handle, *old_handle =
-		iommufd_device_get_attach_handle(idev);
+	struct iommufd_attach_handle *handle, *old_handle;
 	int rc;
 
+	WARN_ON(pasid != IOMMU_NO_PASID);
+
+	old_handle = iommufd_device_get_attach_handle(idev, pasid);
+
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
 	if (!handle)
 		return -ENOMEM;
@@ -470,7 +479,7 @@ out_free_handle:
 }
 
 int iommufd_hw_pagetable_attach(struct iommufd_hw_pagetable *hwpt,
-				struct iommufd_device *idev)
+				struct iommufd_device *idev, ioasid_t pasid)
 {
 	struct iommufd_hwpt_paging *hwpt_paging = find_hwpt_paging(hwpt);
 	int rc;
@@ -496,7 +505,7 @@ int iommufd_hw_pagetable_attach(struct i
 	 * attachment.
 	 */
 	if (list_empty(&idev->igroup->device_list)) {
-		rc = iommufd_hwpt_attach_device(hwpt, idev);
+		rc = iommufd_hwpt_attach_device(hwpt, idev, pasid);
 		if (rc)
 			goto err_unresv;
 		idev->igroup->hwpt = hwpt;
@@ -514,7 +523,7 @@ err_unlock:
 }
 
 struct iommufd_hw_pagetable *
-iommufd_hw_pagetable_detach(struct iommufd_device *idev)
+iommufd_hw_pagetable_detach(struct iommufd_device *idev, ioasid_t pasid)
 {
 	struct iommufd_hw_pagetable *hwpt = idev->igroup->hwpt;
 	struct iommufd_hwpt_paging *hwpt_paging = find_hwpt_paging(hwpt);
@@ -522,7 +531,7 @@ iommufd_hw_pagetable_detach(struct iommu
 	mutex_lock(&idev->igroup->lock);
 	list_del(&idev->group_item);
 	if (list_empty(&idev->igroup->device_list)) {
-		iommufd_hwpt_detach_device(hwpt, idev);
+		iommufd_hwpt_detach_device(hwpt, idev, pasid);
 		idev->igroup->hwpt = NULL;
 	}
 	if (hwpt_paging)
@@ -534,12 +543,12 @@ iommufd_hw_pagetable_detach(struct iommu
 }
 
 static struct iommufd_hw_pagetable *
-iommufd_device_do_attach(struct iommufd_device *idev,
+iommufd_device_do_attach(struct iommufd_device *idev, ioasid_t pasid,
 			 struct iommufd_hw_pagetable *hwpt)
 {
 	int rc;
 
-	rc = iommufd_hw_pagetable_attach(hwpt, idev);
+	rc = iommufd_hw_pagetable_attach(hwpt, idev, pasid);
 	if (rc)
 		return ERR_PTR(rc);
 	return NULL;
@@ -588,7 +597,7 @@ err_unresv:
 }
 
 static struct iommufd_hw_pagetable *
-iommufd_device_do_replace(struct iommufd_device *idev,
+iommufd_device_do_replace(struct iommufd_device *idev, ioasid_t pasid,
 			  struct iommufd_hw_pagetable *hwpt)
 {
 	struct iommufd_hwpt_paging *hwpt_paging = find_hwpt_paging(hwpt);
@@ -622,7 +631,7 @@ iommufd_device_do_replace(struct iommufd
 			goto err_unlock;
 	}
 
-	rc = iommufd_hwpt_replace_device(idev, hwpt, old_hwpt);
+	rc = iommufd_hwpt_replace_device(idev, pasid, hwpt, old_hwpt);
 	if (rc)
 		goto err_unresv;
 
@@ -655,7 +664,8 @@ err_unlock:
 }
 
 typedef struct iommufd_hw_pagetable *(*attach_fn)(
-	struct iommufd_device *idev, struct iommufd_hw_pagetable *hwpt);
+	struct iommufd_device *idev, ioasid_t pasid,
+	struct iommufd_hw_pagetable *hwpt);
 
 /*
  * When automatically managing the domains we search for a compatible domain in
@@ -663,7 +673,7 @@ typedef struct iommufd_hw_pagetable *(*a
  * Automatic domain selection will never pick a manually created domain.
  */
 static struct iommufd_hw_pagetable *
-iommufd_device_auto_get_domain(struct iommufd_device *idev,
+iommufd_device_auto_get_domain(struct iommufd_device *idev, ioasid_t pasid,
 			       struct iommufd_ioas *ioas, u32 *pt_id,
 			       attach_fn do_attach)
 {
@@ -692,7 +702,7 @@ iommufd_device_auto_get_domain(struct io
 		hwpt = &hwpt_paging->common;
 		if (!iommufd_lock_obj(&hwpt->obj))
 			continue;
-		destroy_hwpt = (*do_attach)(idev, hwpt);
+		destroy_hwpt = (*do_attach)(idev, pasid, hwpt);
 		if (IS_ERR(destroy_hwpt)) {
 			iommufd_put_object(idev->ictx, &hwpt->obj);
 			/*
@@ -710,8 +720,8 @@ iommufd_device_auto_get_domain(struct io
 		goto out_unlock;
 	}
 
-	hwpt_paging = iommufd_hwpt_paging_alloc(idev->ictx, ioas, idev, 0,
-						immediate_attach, NULL);
+	hwpt_paging = iommufd_hwpt_paging_alloc(idev->ictx, ioas, idev, pasid,
+						0, immediate_attach, NULL);
 	if (IS_ERR(hwpt_paging)) {
 		destroy_hwpt = ERR_CAST(hwpt_paging);
 		goto out_unlock;
@@ -719,7 +729,7 @@ iommufd_device_auto_get_domain(struct io
 	hwpt = &hwpt_paging->common;
 
 	if (!immediate_attach) {
-		destroy_hwpt = (*do_attach)(idev, hwpt);
+		destroy_hwpt = (*do_attach)(idev, pasid, hwpt);
 		if (IS_ERR(destroy_hwpt))
 			goto out_abort;
 	} else {
@@ -740,8 +750,9 @@ out_unlock:
 	return destroy_hwpt;
 }
 
-static int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
-				    attach_fn do_attach)
+static int iommufd_device_change_pt(struct iommufd_device *idev,
+				    ioasid_t pasid,
+				    u32 *pt_id, attach_fn do_attach)
 {
 	struct iommufd_hw_pagetable *destroy_hwpt;
 	struct iommufd_object *pt_obj;
@@ -756,7 +767,7 @@ static int iommufd_device_change_pt(stru
 		struct iommufd_hw_pagetable *hwpt =
 			container_of(pt_obj, struct iommufd_hw_pagetable, obj);
 
-		destroy_hwpt = (*do_attach)(idev, hwpt);
+		destroy_hwpt = (*do_attach)(idev, pasid, hwpt);
 		if (IS_ERR(destroy_hwpt))
 			goto out_put_pt_obj;
 		break;
@@ -765,8 +776,8 @@ static int iommufd_device_change_pt(stru
 		struct iommufd_ioas *ioas =
 			container_of(pt_obj, struct iommufd_ioas, obj);
 
-		destroy_hwpt = iommufd_device_auto_get_domain(idev, ioas, pt_id,
-							      do_attach);
+		destroy_hwpt = iommufd_device_auto_get_domain(idev, pasid, ioas,
+							      pt_id, do_attach);
 		if (IS_ERR(destroy_hwpt))
 			goto out_put_pt_obj;
 		break;
@@ -803,7 +814,8 @@ int iommufd_device_attach(struct iommufd
 {
 	int rc;
 
-	rc = iommufd_device_change_pt(idev, pt_id, &iommufd_device_do_attach);
+	rc = iommufd_device_change_pt(idev, IOMMU_NO_PASID, pt_id,
+				      &iommufd_device_do_attach);
 	if (rc)
 		return rc;
 
@@ -833,7 +845,7 @@ EXPORT_SYMBOL_NS_GPL(iommufd_device_atta
  */
 int iommufd_device_replace(struct iommufd_device *idev, u32 *pt_id)
 {
-	return iommufd_device_change_pt(idev, pt_id,
+	return iommufd_device_change_pt(idev, IOMMU_NO_PASID, pt_id,
 					&iommufd_device_do_replace);
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_device_replace, IOMMUFD);
@@ -849,7 +861,7 @@ void iommufd_device_detach(struct iommuf
 {
 	struct iommufd_hw_pagetable *hwpt;
 
-	hwpt = iommufd_hw_pagetable_detach(idev);
+	hwpt = iommufd_hw_pagetable_detach(idev, IOMMU_NO_PASID);
 	iommufd_hw_pagetable_put(idev->ictx, hwpt);
 	refcount_dec(&idev->obj.users);
 }
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -87,6 +87,7 @@ iommufd_hwpt_paging_enforce_cc(struct io
  * @ictx: iommufd context
  * @ioas: IOAS to associate the domain with
  * @idev: Device to get an iommu_domain for
+ * @pasid: PASID to get an iommu_domain for
  * @flags: Flags from userspace
  * @immediate_attach: True if idev should be attached to the hwpt
  * @user_data: The user provided driver specific data describing the domain to
@@ -102,8 +103,8 @@ iommufd_hwpt_paging_enforce_cc(struct io
  */
 struct iommufd_hwpt_paging *
 iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
-			  struct iommufd_device *idev, u32 flags,
-			  bool immediate_attach,
+			  struct iommufd_device *idev, ioasid_t pasid,
+			  u32 flags, bool immediate_attach,
 			  const struct iommu_user_data *user_data)
 {
 	const u32 valid_flags = IOMMU_HWPT_ALLOC_NEST_PARENT |
@@ -183,7 +184,7 @@ iommufd_hwpt_paging_alloc(struct iommufd
 	 * sequence. Once those drivers are fixed this should be removed.
 	 */
 	if (immediate_attach) {
-		rc = iommufd_hw_pagetable_attach(hwpt, idev);
+		rc = iommufd_hw_pagetable_attach(hwpt, idev, pasid);
 		if (rc)
 			goto out_abort;
 	}
@@ -196,7 +197,7 @@ iommufd_hwpt_paging_alloc(struct iommufd
 
 out_detach:
 	if (immediate_attach)
-		iommufd_hw_pagetable_detach(idev);
+		iommufd_hw_pagetable_detach(idev, pasid);
 out_abort:
 	iommufd_object_abort_and_destroy(ictx, &hwpt->obj);
 	return ERR_PTR(rc);
@@ -299,8 +300,8 @@ int iommufd_hwpt_alloc(struct iommufd_uc
 		ioas = container_of(pt_obj, struct iommufd_ioas, obj);
 		mutex_lock(&ioas->mutex);
 		hwpt_paging = iommufd_hwpt_paging_alloc(
-			ucmd->ictx, ioas, idev, cmd->flags, false,
-			user_data.len ? &user_data : NULL);
+			ucmd->ictx, ioas, idev, IOMMU_NO_PASID, cmd->flags,
+			false, user_data.len ? &user_data : NULL);
 		if (IS_ERR(hwpt_paging)) {
 			rc = PTR_ERR(hwpt_paging);
 			goto out_unlock;
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -365,13 +365,13 @@ int iommufd_hwpt_get_dirty_bitmap(struct
 
 struct iommufd_hwpt_paging *
 iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
-			  struct iommufd_device *idev, u32 flags,
-			  bool immediate_attach,
+			  struct iommufd_device *idev, ioasid_t pasid,
+			  u32 flags, bool immediate_attach,
 			  const struct iommu_user_data *user_data);
 int iommufd_hw_pagetable_attach(struct iommufd_hw_pagetable *hwpt,
-				struct iommufd_device *idev);
+				struct iommufd_device *idev, ioasid_t pasid);
 struct iommufd_hw_pagetable *
-iommufd_hw_pagetable_detach(struct iommufd_device *idev);
+iommufd_hw_pagetable_detach(struct iommufd_device *idev, ioasid_t pasid);
 void iommufd_hwpt_paging_destroy(struct iommufd_object *obj);
 void iommufd_hwpt_paging_abort(struct iommufd_object *obj);
 void iommufd_hwpt_nested_destroy(struct iommufd_object *obj);


