Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210D61C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BE7C433D7;
	Wed, 23 Nov 2022 09:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197407;
	bh=72+UI+ShCGzRSSfVYFVEB550oGrxiU/USo3+v9GyINs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHaBjpjN7jkw8IvuwTUE/tWA5pUWc8TZg56Dq3KvXCDDMm1AqDAuZtx/ShPWM15em
	 CUcV9B52uXSSW4wPyb4ZwxoZmiUjPJ1bq8YZTbouuqPGwHvrugypYPM0mL7YT7qCr0
	 Ml4pHRMtFCC2uLvsMtD3A5oDtulO4up1T5iUhfFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 286/314] vfio: Split the register_device ops call into functions
Date: Wed, 23 Nov 2022 09:52:11 +0100
Message-Id: <20221123084638.498345686@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 9446162e740aefff95c324ac0887f0b68c739695 ]

This is a container item.

A following patch will move the vfio_container functions to their own .c
file.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/7-v3-297af71838d2+b9-vfio_container_split_jgg@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Stable-dep-of: 7fdba0011157 ("vfio: Fix container device registration life cycle")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_main.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index c555d497e9e8..48ceca04d9b8 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1086,9 +1086,28 @@ static void vfio_device_unassign_container(struct vfio_device *device)
 	up_write(&device->group->group_rwsem);
 }
 
+static void vfio_device_container_register(struct vfio_device *device)
+{
+	struct vfio_iommu_driver *iommu_driver =
+		device->group->container->iommu_driver;
+
+	if (iommu_driver && iommu_driver->ops->register_device)
+		iommu_driver->ops->register_device(
+			device->group->container->iommu_data, device);
+}
+
+static void vfio_device_container_unregister(struct vfio_device *device)
+{
+	struct vfio_iommu_driver *iommu_driver =
+		device->group->container->iommu_driver;
+
+	if (iommu_driver && iommu_driver->ops->unregister_device)
+		iommu_driver->ops->unregister_device(
+			device->group->container->iommu_data, device);
+}
+
 static struct file *vfio_device_open(struct vfio_device *device)
 {
-	struct vfio_iommu_driver *iommu_driver;
 	struct file *filep;
 	int ret;
 
@@ -1119,12 +1138,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 			if (ret)
 				goto err_undo_count;
 		}
-
-		iommu_driver = device->group->container->iommu_driver;
-		if (iommu_driver && iommu_driver->ops->register_device)
-			iommu_driver->ops->register_device(
-				device->group->container->iommu_data, device);
-
+		vfio_device_container_register(device);
 		up_read(&device->group->group_rwsem);
 	}
 	mutex_unlock(&device->dev_set->lock);
@@ -1162,10 +1176,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	if (device->open_count == 1 && device->ops->close_device) {
 		device->ops->close_device(device);
 
-		iommu_driver = device->group->container->iommu_driver;
-		if (iommu_driver && iommu_driver->ops->unregister_device)
-			iommu_driver->ops->unregister_device(
-				device->group->container->iommu_data, device);
+		vfio_device_container_unregister(device);
 	}
 err_undo_count:
 	up_read(&device->group->group_rwsem);
@@ -1361,7 +1372,6 @@ static const struct file_operations vfio_group_fops = {
 static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_device *device = filep->private_data;
-	struct vfio_iommu_driver *iommu_driver;
 
 	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
@@ -1369,10 +1379,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	if (device->open_count == 1 && device->ops->close_device)
 		device->ops->close_device(device);
 
-	iommu_driver = device->group->container->iommu_driver;
-	if (iommu_driver && iommu_driver->ops->unregister_device)
-		iommu_driver->ops->unregister_device(
-			device->group->container->iommu_data, device);
+	vfio_device_container_unregister(device);
 	up_read(&device->group->group_rwsem);
 	device->open_count--;
 	if (device->open_count == 0)
-- 
2.35.1



