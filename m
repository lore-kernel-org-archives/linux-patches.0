Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B213594D;
	Thu, 17 Apr 2025 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913770; cv=none; b=kswGDTR72+rETHaQmJpeXZGnBjrKoFhy2LTIvERsrjKy4TDhbIC3mWnbvx3A2iomEoGkgB5y7ah1J72dpzTs1nooQjEGy7jclSdxwsOWAk6M1pMISIIMloYpJM+pjmfDA/0OKz4UwO4FSdUtOtKJV6RY74C+0haJDb29hjN9jkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913770; c=relaxed/simple;
	bh=y5ACSK0pnU8yOubcyjbo+9ICMg672+qNNPYxNEPjPbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAOGIfLk7FWfWAQllYY+ddFDwNbxlSAGHsKjGoCfYVIvfDBDeyFHdaDepaQ/YqEsH9dytREKWycu2Z6R93zOGnYW1yadmJlXKylXsgHWwS5Ey0p08SJEHY/Zw8BeJ6vF+6X4MUgps2an5UjtbvnJIfi6m7ospK792uU9pZhH9s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+GmuMeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+GmuMeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D284C4CEE4;
	Thu, 17 Apr 2025 18:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913770;
	bh=y5ACSK0pnU8yOubcyjbo+9ICMg672+qNNPYxNEPjPbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+GmuMeBP4C5T3rtH4Me1nV6GxAD3p3jDASyAjhG4RqqMhYg9EaHC48JOxXx8PUOP
	 KeEHCZfqMAU1Ytt/YETDTpKA4eQqo/tKkIhd0SKhT5dgi6PUKDaBazMkNNA6OzVOT0
	 1fS7W3oMV52mhaR9YDMWnfNH2Wh/x0pdyXwcnpaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.14 447/449] iommufd: Fail replace if device has not been attached
Date: Thu, 17 Apr 2025 19:52:15 +0200
Message-ID: <20250417175136.314165169@linuxfoundation.org>
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
@@ -354,6 +354,17 @@ iommufd_device_attach_reserved_iova(stru
 
 /* The device attach/detach/replace helpers for attach_handle */
 
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
 static int iommufd_hwpt_attach_device(struct iommufd_hw_pagetable *hwpt,
 				      struct iommufd_device *idev)
 {
@@ -592,6 +603,11 @@ iommufd_device_do_replace(struct iommufd
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


