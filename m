Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1D32F548E;
	Fri, 10 Oct 2025 13:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102347; cv=none; b=KnC+Kx43iwzN1xQ4PdwlB423Qdr+2pcYTMg/r8U/wJCaxZjezsOf8VNoQLcL9EqKo+9QHGj3ln5ZN0w2Q9SCQjBT4jXslHrlkGxU2EBiks35+dS2i+QsMd6CxsD3wnKerPbHy3Hqc/GvfiIo1sO60ux+PWAYWHtUWodYc+k+YXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102347; c=relaxed/simple;
	bh=XK/bv7yt1MkwhSvQ9zOcxEpaT2D3QW+61K/nNdSwifg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjIj4cfbel3RzotcZ4ou/FDPGUW9NqW9iiRiv41tZaoSz61jF/F1YP4d7L0eMaSMOTYoOfZQOxVci2NvO9z+zvaNpu+Jywn7Q61/M5xfSFXeanxlUI8E8C4w4YSg2itcVYY1ywlxSexMrBFAdsnGc3R7Ts4BGwSniZpOFn8kqaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNbgu8al; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNbgu8al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179ECC4CEF1;
	Fri, 10 Oct 2025 13:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102347;
	bh=XK/bv7yt1MkwhSvQ9zOcxEpaT2D3QW+61K/nNdSwifg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNbgu8al4bMC2fJlfvupLH3SoI2+O9shOaJ8nyZYcrgbycPlcuMgwkj9W8tUkRhql
	 UtCN3xkrUfWlXsVRfjon0QthwOZl/g1DLm52mlrrdPRWBjbGnwQIyi8GokcALWb+1V
	 FoxUflZHSh89FZkpXQZWdwMqmP38CcsZILyJValE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 24/41] iommufd: WARN if an object is aborted with an elevated refcount
Date: Fri, 10 Oct 2025 15:16:12 +0200
Message-ID: <20251010131334.294671518@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 53d0584eeb2c85a46c83656246d61a89558d74b3 ]

If something holds a refcount then it is at risk of UAFing. For abort
paths we expect the caller to never share the object with a parallel
thread and to clean up any refcounts it obtained on its own.

Add the missing dec inside iommufd_hwpt_paging_alloc() during error unwind
by making iommufd_hw_pagetable_attach/detach() proper pairs.

Link: https://patch.msgid.link/r/2-v1-02cd136829df+31-iommufd_syz_fput_jgg@nvidia.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/device.c          | 3 ++-
 drivers/iommu/iommufd/iommufd_private.h | 3 +--
 drivers/iommu/iommufd/main.c            | 4 ++++
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 86244403b5320..674f9f244f7b4 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -661,6 +661,8 @@ iommufd_hw_pagetable_detach(struct iommufd_device *idev, ioasid_t pasid)
 		iopt_remove_reserved_iova(&hwpt_paging->ioas->iopt, idev->dev);
 	mutex_unlock(&igroup->lock);
 
+	iommufd_hw_pagetable_put(idev->ictx, hwpt);
+
 	/* Caller must destroy hwpt */
 	return hwpt;
 }
@@ -1007,7 +1009,6 @@ void iommufd_device_detach(struct iommufd_device *idev, ioasid_t pasid)
 	hwpt = iommufd_hw_pagetable_detach(idev, pasid);
 	if (!hwpt)
 		return;
-	iommufd_hw_pagetable_put(idev->ictx, hwpt);
 	refcount_dec(&idev->obj.users);
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_device_detach, "IOMMUFD");
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 9ccc83341f321..e68d8d63076a8 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -390,9 +390,8 @@ static inline void iommufd_hw_pagetable_put(struct iommufd_ctx *ictx,
 	if (hwpt->obj.type == IOMMUFD_OBJ_HWPT_PAGING) {
 		struct iommufd_hwpt_paging *hwpt_paging = to_hwpt_paging(hwpt);
 
-		lockdep_assert_not_held(&hwpt_paging->ioas->mutex);
-
 		if (hwpt_paging->auto_domain) {
+			lockdep_assert_not_held(&hwpt_paging->ioas->mutex);
 			iommufd_object_put_and_try_destroy(ictx, &hwpt->obj);
 			return;
 		}
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 62a3469bbd37e..2b26747ac2021 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -62,6 +62,10 @@ void iommufd_object_abort(struct iommufd_ctx *ictx, struct iommufd_object *obj)
 	old = xas_store(&xas, NULL);
 	xa_unlock(&ictx->objects);
 	WARN_ON(old != XA_ZERO_ENTRY);
+
+	if (WARN_ON(!refcount_dec_and_test(&obj->users)))
+		return;
+
 	kfree(obj);
 }
 
-- 
2.51.0



