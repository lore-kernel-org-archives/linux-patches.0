Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE38D1C07DB;
	Tue, 15 Oct 2024 13:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997495; cv=none; b=KESBnahH2NsSV7JvQugzOYRJdU3xCZgOijzLIEBBJna9VguQk7O9lwFQeQSTVxBd8zIb4vHzfG/2Qoimj085yVxU5yfNIrPM2H6n3KKGh9tZC8K4+8PMJ34rAzUmUSu/LP+zos3j6tFj86AvAir4zUwHSm3iY+G6k0c5dReCc9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997495; c=relaxed/simple;
	bh=NFOxru1amJuws0m6tX+C2awm3S23ApdM3whlKehvDL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trq7Qdq9urHgNHi5RyN+HOXj+mav4qULnc9jkYZVcT2SFDAYRXmvlJPJvZbUhmbls/cE0OJaSjSSO+1x5PYH7SIS+oUqxqF4G2TQVS55DXEp+y2o8FaePBAs+OvLzOUPsdzezq5pSBKC/69nZurk78FQOLLFVHQjR/qXgtldx5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNRL1cLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNRL1cLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE63C4CEC6;
	Tue, 15 Oct 2024 13:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997494;
	bh=NFOxru1amJuws0m6tX+C2awm3S23ApdM3whlKehvDL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNRL1cLkERYjGNiaM/CfK5lUasHaXQ9FTir9LfHz1yTrdl1ov9SoScwdwEXdkaPq2
	 1do/2OUUfSeW3TRXmikFE/0ut9RLgTl/gffGAe6Oor0viq6+jX+beM4xRytFNTvJ6b
	 JJLmuTb3zNzD/hYCJvtgCq2JRcA9b84L6md/QpoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yongji <xieyongji@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/518] vdpa: Add eventfd for the vdpa callback
Date: Tue, 15 Oct 2024 14:41:42 +0200
Message-ID: <20241015123924.627011341@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit 5e68470f4e80a4120e9ecec408f6ab4ad386bd4a ]

Add eventfd for the vdpa callback so that user
can signal it directly instead of triggering the
callback. It will be used for vhost-vdpa case.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Message-Id: <20230323053043.35-9-xieyongji@bytedance.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Stable-dep-of: 02e9e9366fef ("vhost_vdpa: assign irq bypass producer token correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c         | 2 ++
 drivers/virtio/virtio_vdpa.c | 1 +
 include/linux/vdpa.h         | 6 ++++++
 3 files changed, 9 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index c9f585db1553c..fdd175730d327 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -422,9 +422,11 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		if (vq->call_ctx.ctx) {
 			cb.callback = vhost_vdpa_virtqueue_cb;
 			cb.private = vq;
+			cb.trigger = vq->call_ctx.ctx;
 		} else {
 			cb.callback = NULL;
 			cb.private = NULL;
+			cb.trigger = NULL;
 		}
 		ops->set_vq_cb(vdpa, idx, &cb);
 		vhost_vdpa_setup_vq_irq(v, idx);
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 3f95dedcccebe..7b2c37a3880f8 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -180,6 +180,7 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 	/* Setup virtqueue callback */
 	cb.callback = virtio_vdpa_virtqueue_cb;
 	cb.private = info;
+	cb.trigger = NULL;
 	ops->set_vq_cb(vdpa, index, &cb);
 	ops->set_vq_num(vdpa, index, virtqueue_get_vring_size(vq));
 
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 30bc7a7223bb7..2ee60c7c1eb04 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -11,10 +11,16 @@
  * vDPA callback definition.
  * @callback: interrupt callback function
  * @private: the data passed to the callback function
+ * @trigger: the eventfd for the callback (Optional).
+ *           When it is set, the vDPA driver must guarantee that
+ *           signaling it is functional equivalent to triggering
+ *           the callback. Then vDPA parent can signal it directly
+ *           instead of triggering the callback.
  */
 struct vdpa_callback {
 	irqreturn_t (*callback)(void *data);
 	void *private;
+	struct eventfd_ctx *trigger;
 };
 
 /**
-- 
2.43.0



