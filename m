Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EBB2957B6;
	Wed, 23 Apr 2025 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421981; cv=none; b=HJeqj7o6a1DYBfqw76eQ8iLGRoIz87DtPjz0kriUnaXT9dx3ESKk5gIylkD6zo5sqbQBxWrakfQt0UBA4vySrgLVSDfbK+OojC8v9Z2uROOKUr0tgumPP7QtGg/gw9ELotQ0sIF8gSRA89SeHy5mryB76ryOC9JMSsY28QPzebQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421981; c=relaxed/simple;
	bh=LPDkn8s2EHSpX2fOGMSVNcEOK0ESIyNtrmMkZCJJlVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMtwClrZNt4O6CqyNarAdAaMq+6dNzznjkPaBBNdX2BBohBVZnptqKcu+3K3VXL+j54ilw3+r4+FIFKzjpeBkMne3t3zt9C1YryKsWVxPDMP6mkVBZElqkLsI/7BmnlwBobHDRl9X73kdTiU3VmRspAHJUo84NIvx0eidSRzE3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1d7vaHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1d7vaHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548BAC4CEE2;
	Wed, 23 Apr 2025 15:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421981;
	bh=LPDkn8s2EHSpX2fOGMSVNcEOK0ESIyNtrmMkZCJJlVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1d7vaHaKPrg+SQM97cX2e8Sbf9pnfLho7FPgp7QEMDgWNTq2YjzD3gvuCFa7PJLS
	 /CEOIRGlmh/Wz8VFbTk2uMxI3Teoh6VGyoZFYynyfd+KbVK111CUGNw8jPUd21rYyC
	 AiS1cA1HywbNZRvy3qigV+Lmowbx2TO3ef6glnfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.6 235/393] iommufd: Fail replace if device has not been attached
Date: Wed, 23 Apr 2025 16:42:11 +0200
Message-ID: <20250423142653.095384134@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Liu <yi.l.liu@intel.com>

commit 55c85fa7579dc2e3f5399ef5bad67a44257c1a48 upstream.

The current implementation of iommufd_device_do_replace() implicitly
assumes that the input device has already been attached. However, there
is no explicit check to verify this assumption. If another device within
the same group has been attached, the replace operation might succeed,
but the input device itself may not have been attached yet.

As a result, the input device might not be tracked in the
igroup->device_list, and its reserved IOVA might not be added. Despite
this, the caller might incorrectly assume that the device has been
successfully replaced, which could lead to unexpected behavior or errors.

To address this issue, add a check to ensure that the input device has
been attached before proceeding with the replace operation. This check
will help maintain the integrity of the device tracking system and prevent
potential issues arising from incorrect assumptions about the device's
attachment status.

Fixes: e88d4ec154a8 ("iommufd: Add iommufd_device_replace()")
Link: https://patch.msgid.link/r/20250306034842.5950-1-yi.l.liu@intel.com
Cc: stable@vger.kernel.org
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/device.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -407,6 +407,17 @@ iommufd_device_do_attach(struct iommufd_
 	return NULL;
 }
 
+/* Check if idev is attached to igroup->hwpt */
+static bool iommufd_device_is_attached(struct iommufd_device *idev)
+{
+	struct iommufd_device *cur;
+
+	list_for_each_entry(cur, &idev->igroup->device_list, group_item)
+		if (cur == idev)
+			return true;
+	return false;
+}
+
 static struct iommufd_hw_pagetable *
 iommufd_device_do_replace(struct iommufd_device *idev,
 			  struct iommufd_hw_pagetable *hwpt)
@@ -423,6 +434,11 @@ iommufd_device_do_replace(struct iommufd
 		rc = -EINVAL;
 		goto err_unlock;
 	}
+
+	if (!iommufd_device_is_attached(idev)) {
+		rc = -EINVAL;
+		goto err_unlock;
+	}
 
 	if (hwpt == igroup->hwpt) {
 		mutex_unlock(&idev->igroup->lock);


