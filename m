Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9250B1EABB9;
	Tue, 15 Oct 2024 11:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993129; cv=none; b=CDXACi/7GfrGEwgfHfxJ8XV5+dUQkdxYmAN+Nml1+1s2zRmumQshYGpsaUaJeFO2dAj5xVOzoM7hmoEjz8g2j+co7FCmBv9BAHeGr2K4BdPv48fj4o9I2kmCrB9k17DyAFpeh0yO/DtvRwF2IsPlN+A9oeL7VxUTsVQsicOJ4oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993129; c=relaxed/simple;
	bh=mz5GLQongPpf/BjRpIHiDsa5iGWlrwEZ8RgzoRgGHOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7d7IDbDLSQFqqc0+GuuauStcaLv4/xjMF5AOmF4EBLCPLRaTH2ng6+C04PTYgGBvCEbjbO81JaeeBBDDAedayB0t4h9SiFSQhRY1tkA/Q1/ffTOhX5EER7FkxtXn9tV2moMadBjFMC0+nvfFck0XPws5bzwTfVq+R5ZcWRWjyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnCY2vfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnCY2vfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060C3C4CEC6;
	Tue, 15 Oct 2024 11:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993129;
	bh=mz5GLQongPpf/BjRpIHiDsa5iGWlrwEZ8RgzoRgGHOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnCY2vfLtfVpjrIB6gHVY2gLn/lU5Qr0JIS7vnmIz0pmhXvqerH4+WQ/zHE0stL0g
	 xVldPjrWjsqb+/Q1t+cRlNOalU9DNgMGYAQUPhDd0nQ/2E41W5g0fIr62kPUEz6ivZ
	 NU1NU8/sGUw/ir4OEmwlFZjpTu7smshnnEInxToY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yongji <xieyongji@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 278/691] vdpa: Add eventfd for the vdpa callback
Date: Tue, 15 Oct 2024 13:23:46 +0200
Message-ID: <20241015112451.378335404@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 019e8c9bedffb..1dc11ba0922d2 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -432,9 +432,11 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
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
index 72eaef2caeb14..1c29446aafb44 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -182,6 +182,7 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 	/* Setup virtqueue callback */
 	cb.callback = virtio_vdpa_virtqueue_cb;
 	cb.private = info;
+	cb.trigger = NULL;
 	ops->set_vq_cb(vdpa, index, &cb);
 	ops->set_vq_num(vdpa, index, virtqueue_get_vring_size(vq));
 
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 3972ab765de18..4fb198c8dbf61 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -11,10 +11,16 @@
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



