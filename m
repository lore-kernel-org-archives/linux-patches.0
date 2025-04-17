Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CE725744A;
	Thu, 17 Apr 2025 18:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915046; cv=none; b=ZziE3Zjl74NVaaIUfwx6qTrBXync2kD4IVbdpbbag573FMakUmy+hfjo7cdUSJiQGcqNnw56PWgnfWMOyqIq9cZEvJy8AOZMiq2pUhxOcjql4wzz87lt36c+C+gLQDz+FliV+skGyHhq2tybOeONU9jFSDo9Zb5pBg+EYnc3lxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915046; c=relaxed/simple;
	bh=VhRqcnmhwyGJQShJA92tOJn3FVtBi2BCVpmpQGgug5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuCbB3jj1NICXkXrB4rhw+sBZlxctRidUddzgT19WEB5W7WEBje1Eh3DvZOTSW99hEQPk8Osai2VLj2bQz/e6QiLqJ+fFMDaK2E+ONtnoF1Ak7YvsiNKzreGIkc82HMGhz0hjXv95dbx6cg2i0dJbjXFDzW/fvdEsEiy4t+0ye8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1X6obe7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1X6obe7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9666C4CEE4;
	Thu, 17 Apr 2025 18:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915046;
	bh=VhRqcnmhwyGJQShJA92tOJn3FVtBi2BCVpmpQGgug5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1X6obe7OctrzNgn/W8ULZFZN4/PzWdJYVl0uIo8Ownk+p0kZScbgjmpe9+pAMIkg7
	 pQICyQC2Od1pdpAHtY8rnQnjHEdEG6yFurwZMUKi7Xf46ch19VoeEMlUvjfVt1s8ST
	 Uj6IwPAeoB+uRmjuf6pBubnSNIJYokvdc7KWBmPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.13 406/414] iommufd: Fail replace if device has not been attached
Date: Thu, 17 Apr 2025 19:52:44 +0200
Message-ID: <20250417175127.811055369@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


