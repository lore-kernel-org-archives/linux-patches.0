Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE2F4CDEC;
	Mon, 14 Oct 2024 15:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918240; cv=none; b=mulWvr33c3zkfUpCA6LNaK532HnQakWqqrDUl4R6XKvsnVCte4Vn2F3vqaMP0HyRFQU1ysM+hibbI5aGLf4+SVpxR+6k/0aNvRiPloRmmKDXSIY8JdvZ1y9kYP5lWe4iZH6rt9MvBITYEArCAbk3kfL0n8zy5yARpNh9CDF5YLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918240; c=relaxed/simple;
	bh=yqRGUNNB0RqNu6A4wgT0NM2JbNPt/f5atU25z8ZyUHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D77IHJDpFKhRzFMPqBW3wSzBmsxFaVYvzX4sOHbfdOHjvGCtlY1oCP7unG1b0NPyFSrEzwkTUCWEQyHiDe7A8z2PV0fwotXcQ4aVGbQd2+uHWrcKFtLYuR4LPf/H2RggLYEKD4Mgafwm5uRp45H8RFucDKdrLYosVrAmLJT6ASo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbghRw/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbghRw/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B92C4CEC3;
	Mon, 14 Oct 2024 15:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918240;
	bh=yqRGUNNB0RqNu6A4wgT0NM2JbNPt/f5atU25z8ZyUHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbghRw/uSYHxk4ukEGd94thKULe4Y8x9RMUAvhTAcTDmp9Ym6kvH/3lTI+WXAgPft
	 vPYLPm3167BDoE88X5AkdX+JyrEYrC7jY+1K//R378I2XgDLDQZ7xXYDEUU7NailPR
	 gngmFl+1dwyGE3TA9IpUm4EvBVVD2s4BDtuOtFMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yongji <xieyongji@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 257/798] vdpa: Add eventfd for the vdpa callback
Date: Mon, 14 Oct 2024 16:13:31 +0200
Message-ID: <20241014141228.031999125@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 55f88eeb78a72..ef9e845a5a5c5 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -602,9 +602,11 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
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
index 9670cc79371d8..056ba6c5bb083 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -188,6 +188,7 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 	/* Setup virtqueue callback */
 	cb.callback = callback ? virtio_vdpa_virtqueue_cb : NULL;
 	cb.private = info;
+	cb.trigger = NULL;
 	ops->set_vq_cb(vdpa, index, &cb);
 	ops->set_vq_num(vdpa, index, virtqueue_get_vring_size(vq));
 
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 6d0f5e4e82c25..41bc78b3b8360 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -13,10 +13,16 @@
  * struct vdpa_calllback - vDPA callback definition.
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



