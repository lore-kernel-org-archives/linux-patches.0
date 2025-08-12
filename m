Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CE02D4802;
	Tue, 12 Aug 2025 19:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026525; cv=none; b=uW5jeLNM7UfxHLnbRyGagn5D5ENJqtYBGQtbyPl01yJl7G8Inmh7xEwIrjRSJKx0eDH1GDSxuupob2KtWDdoDn04CAFfZLSLHYHj3vf5fc+dDrfCP74KpFc07YKJb/xHoEuLxdDksSIokdbyu+rxjHUjqVU+k0xPn/9/+5hpH9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026525; c=relaxed/simple;
	bh=O8wr7ZCPkh/S/flVUBAtOoMf+emTpzc6taNmiKw8duI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ty+LyGPow3M4fPVQhAZpAdPPVupyX8SfrDvcMnNkBTtyY6POz0VJstM4MMkukXzKauR6MZBG55S+m8WXTMyI6mm1hQ2t/42bdx8qVjS050B3t2SEHRHJs+stu0YqZq+dexvk+giTIM5qyEiHiIMkC7gU21O9hQJOgmgybJa/i74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoNr7GrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoNr7GrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D9FC4CEF0;
	Tue, 12 Aug 2025 19:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026525;
	bh=O8wr7ZCPkh/S/flVUBAtOoMf+emTpzc6taNmiKw8duI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoNr7GrZxMPFJo7csjcoXMB5mCXMuPDYFS9AQ7VLCh3vebooMh6/TqYOIei9s+juA
	 UuTdkmgF99hse+kczN9NVvLYANplEq1NuCTCEnbMpGfhB8j+AIrAGke2U4KHcbGmqe
	 0v1uuvQoboUdXcPiGGSWToLgsUVB7T4Btm0fOTwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 362/480] vfio: Fix unbalanced vfio_df_close call in no-iommu mode
Date: Tue, 12 Aug 2025 19:49:30 +0200
Message-ID: <20250812174412.360501721@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Pan <jacob.pan@linux.microsoft.com>

[ Upstream commit b25e271b377999191b12f0afbe1861edcf57e3fe ]

For devices with no-iommu enabled in IOMMUFD VFIO compat mode, the group open
path skips vfio_df_open(), leaving open_count at 0. This causes a warning in
vfio_assert_device_open(device) when vfio_df_close() is called during group
close.

The correct behavior is to skip only the IOMMUFD bind in the device open path
for no-iommu devices. Commit 6086efe73498 omitted vfio_df_open(), which was
too broad. This patch restores the previous behavior, ensuring
the vfio_df_open is called in the group open path.

Fixes: 6086efe73498 ("vfio-iommufd: Move noiommu compat validation out of vfio_iommufd_bind()")
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jacob Pan <jacob.pan@linux.microsoft.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20250618234618.1910456-1-jacob.pan@linux.microsoft.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/group.c   | 7 +++----
 drivers/vfio/iommufd.c | 4 ++++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index c321d442f0da..c376a6279de0 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -192,11 +192,10 @@ static int vfio_df_group_open(struct vfio_device_file *df)
 		 * implies they expected translation to exist
 		 */
 		if (!capable(CAP_SYS_RAWIO) ||
-		    vfio_iommufd_device_has_compat_ioas(device, df->iommufd))
+		    vfio_iommufd_device_has_compat_ioas(device, df->iommufd)) {
 			ret = -EPERM;
-		else
-			ret = 0;
-		goto out_put_kvm;
+			goto out_put_kvm;
+		}
 	}
 
 	ret = vfio_df_open(df);
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index c8c3a2d53f86..a38d262c6028 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -25,6 +25,10 @@ int vfio_df_iommufd_bind(struct vfio_device_file *df)
 
 	lockdep_assert_held(&vdev->dev_set->lock);
 
+	/* Returns 0 to permit device opening under noiommu mode */
+	if (vfio_device_is_noiommu(vdev))
+		return 0;
+
 	return vdev->ops->bind_iommufd(vdev, ictx, &df->devid);
 }
 
-- 
2.39.5



