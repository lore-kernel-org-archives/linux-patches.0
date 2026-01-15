Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6DC2D7DED;
	Thu, 15 Jan 2026 17:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497641; cv=none; b=aeiHy8Hf89AE2Z0qam6qtJ6EKU7jbPoJbFEHyf938Yl013q5MAiuxeQRT6CrnsoWedWRbY0doGrnkD9ZiVMGHcWXdxgBBZAYrnTze7oTR7HUd7pgZek1EGY5QORLEdmU+vwtJou7S7uTaMxulNiKMjK2BX1OzxrHJncrUS02LLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497641; c=relaxed/simple;
	bh=ZBYi6MMzTzC5P4VnVBZ0gcBdWfCTT1e2so1RClWnPHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwGLQhXruereq3DNBoXaExufnNYKezVK506pJhe0sjnXoW2Y4q4/N4vxm8e5NSQ/TNtjHKTTYQAU5mNyx9HmHWber9mJe33Pi76e4xddmY3omuIrXXNGQN0gzKcBLB4CtQmszYikl6C9AnVSyJh+p8V7o+ph/GbrsjD7/YWrUms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Msno+Wy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Msno+Wy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E00C2BC86;
	Thu, 15 Jan 2026 17:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497641;
	bh=ZBYi6MMzTzC5P4VnVBZ0gcBdWfCTT1e2so1RClWnPHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Msno+Wy6jiAdLMUDDuhIBOaDN4QCT+C23Dayv0V145oQxpgz3RlbvadiX+mRJbPR9
	 8yki3wWnSrueuN3S/JrCdnvOgwwUL2+65KrPrOceNMvGow2oGYnbkmi+6yV59gk/Nx
	 IX5MSvWRibw683yF1TQB/tejB3M8qMfGkyGBsPTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eli Cohen <elic@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/554] vdpa: Sync calls set/get config/status with cf_mutex
Date: Thu, 15 Jan 2026 17:43:38 +0100
Message-ID: <20260115164251.765657379@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit 73bc0dbb591baea322a7319c735e5f6c7dba9cfb ]

Add wrappers to get/set status and protect these operations with
cf_mutex to serialize these operations with respect to get/set config
operations.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20220105114646.577224-4-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: e40b6abe0b12 ("virtio_vdpa: fix misleading return in void function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa.c          | 19 +++++++++++++++++++
 drivers/vhost/vdpa.c         |  7 +++----
 drivers/virtio/virtio_vdpa.c |  3 +--
 include/linux/vdpa.h         |  3 +++
 4 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index b12fc70510bb7..58eb448bf5b0c 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -22,6 +22,25 @@ static LIST_HEAD(mdev_head);
 static DEFINE_MUTEX(vdpa_dev_mutex);
 static DEFINE_IDA(vdpa_index_ida);
 
+u8 vdpa_get_status(struct vdpa_device *vdev)
+{
+	u8 status;
+
+	mutex_lock(&vdev->cf_mutex);
+	status = vdev->config->get_status(vdev);
+	mutex_unlock(&vdev->cf_mutex);
+	return status;
+}
+EXPORT_SYMBOL(vdpa_get_status);
+
+void vdpa_set_status(struct vdpa_device *vdev, u8 status)
+{
+	mutex_lock(&vdev->cf_mutex);
+	vdev->config->set_status(vdev, status);
+	mutex_unlock(&vdev->cf_mutex);
+}
+EXPORT_SYMBOL(vdpa_set_status);
+
 static struct genl_family vdpa_nl_family;
 
 static int vdpa_dev_probe(struct device *d)
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 0f61ca0598b71..802c84e296e21 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -143,10 +143,9 @@ static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
 static long vhost_vdpa_get_status(struct vhost_vdpa *v, u8 __user *statusp)
 {
 	struct vdpa_device *vdpa = v->vdpa;
-	const struct vdpa_config_ops *ops = vdpa->config;
 	u8 status;
 
-	status = ops->get_status(vdpa);
+	status = vdpa_get_status(vdpa);
 
 	if (copy_to_user(statusp, &status, sizeof(status)))
 		return -EFAULT;
@@ -165,7 +164,7 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 	if (copy_from_user(&status, statusp, sizeof(status)))
 		return -EFAULT;
 
-	status_old = ops->get_status(vdpa);
+	status_old = vdpa_get_status(vdpa);
 
 	/*
 	 * Userspace shouldn't remove status bits unless reset the
@@ -183,7 +182,7 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 		if (ret)
 			return ret;
 	} else
-		ops->set_status(vdpa, status);
+		vdpa_set_status(vdpa, status);
 
 	if ((status & VIRTIO_CONFIG_S_DRIVER_OK) && !(status_old & VIRTIO_CONFIG_S_DRIVER_OK))
 		for (i = 0; i < nvqs; i++)
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index b5ab5f59f96ac..a85a10d65973f 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -91,9 +91,8 @@ static u8 virtio_vdpa_get_status(struct virtio_device *vdev)
 static void virtio_vdpa_set_status(struct virtio_device *vdev, u8 status)
 {
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
-	const struct vdpa_config_ops *ops = vdpa->config;
 
-	return ops->set_status(vdpa, status);
+	return vdpa_set_status(vdpa, status);
 }
 
 static void virtio_vdpa_reset(struct virtio_device *vdev)
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index d26f5777f30f7..c0c8ed2c62fd8 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -394,6 +394,9 @@ void vdpa_get_config(struct vdpa_device *vdev, unsigned int offset,
 		     void *buf, unsigned int len);
 void vdpa_set_config(struct vdpa_device *dev, unsigned int offset,
 		     const void *buf, unsigned int length);
+u8 vdpa_get_status(struct vdpa_device *vdev);
+void vdpa_set_status(struct vdpa_device *vdev, u8 status);
+
 /**
  * struct vdpa_mgmtdev_ops - vdpa device ops
  * @dev_add: Add a vdpa device using alloc and register
-- 
2.51.0



