Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCBC1D4154;
	Tue, 15 Oct 2024 11:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993018; cv=none; b=TL2uU85JnBW/KPad0AI/KaUOtwir8BlpumX1YkAoriHyYYWgq1LmzEFsTuIg3rb1vCP5CA5ORZhPVTcE2CwrtGc2EcwiClXjIkEF/9qXy3qeMK5oWeItQ/4QjC2eSHCWjsaTamzfmfB0+Yh0jDXcIZM8sr0lNA7DGTYsOb4kB5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993018; c=relaxed/simple;
	bh=W32hfL0m2bL8+PvxO+YTwmv/IZvYovztD96jEBaFHAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+oVtHN4iWdKZCoaF83gCcTD8NemiJyNPENeACSINAyKAMt3ElmcUxzO3Ix3zxukaqgeFDM7RwZB7v6elG0GVChfnv0BygyynlzlCGVTIRjQyQb+jPJLaK+Et9dGB4bBqlhWRvD2MeWBsg1JeTHudzGLWkaKcWO/hQb1sML0iQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LavqkVYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LavqkVYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213ACC4CEC6;
	Tue, 15 Oct 2024 11:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993018;
	bh=W32hfL0m2bL8+PvxO+YTwmv/IZvYovztD96jEBaFHAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LavqkVYgVqKHrkUqF6l09MPz0UfzEzyUltrb/maX/GnQ4xxDaCFmwsJEOxXN57fhD
	 nXpS8N12Riqsmigs+gXP0BWakoy1vERNZ099gsVwa+G6AbjEmB84Wt4h2xCDYKbIbi
	 X3wTMN3u3wGPqU7fmmxFduCOlt/1VACY3djKgqZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 279/691] vhost_vdpa: assign irq bypass producer token correctly
Date: Tue, 15 Oct 2024 13:23:47 +0200
Message-ID: <20241015112451.418953511@linuxfoundation.org>
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

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 02e9e9366fefe461719da5d173385b6685f70319 ]

We used to call irq_bypass_unregister_producer() in
vhost_vdpa_setup_vq_irq() which is problematic as we don't know if the
token pointer is still valid or not.

Actually, we use the eventfd_ctx as the token so the life cycle of the
token should be bound to the VHOST_SET_VRING_CALL instead of
vhost_vdpa_setup_vq_irq() which could be called by set_status().

Fixing this by setting up irq bypass producer's token when handling
VHOST_SET_VRING_CALL and un-registering the producer before calling
vhost_vring_ioctl() to prevent a possible use after free as eventfd
could have been released in vhost_vring_ioctl(). And such registering
and unregistering will only be done if DRIVER_OK is set.

Reported-by: Dragos Tatulea <dtatulea@nvidia.com>
Tested-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Fixes: 2cf1ba9a4d15 ("vhost_vdpa: implement IRQ offloading in vhost_vdpa")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20240816031900.18013-1-jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 1dc11ba0922d2..58ba684037f9e 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -100,11 +100,9 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
 	if (irq < 0)
 		return;
 
-	irq_bypass_unregister_producer(&vq->call_ctx.producer);
 	if (!vq->call_ctx.ctx)
 		return;
 
-	vq->call_ctx.producer.token = vq->call_ctx.ctx;
 	vq->call_ctx.producer.irq = irq;
 	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
 	if (unlikely(ret))
@@ -401,6 +399,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			vq->last_avail_idx = vq_state.split.avail_index;
 		}
 		break;
+	case VHOST_SET_VRING_CALL:
+		if (vq->call_ctx.ctx) {
+			if (ops->get_status(vdpa) &
+			    VIRTIO_CONFIG_S_DRIVER_OK)
+				vhost_vdpa_unsetup_vq_irq(v, idx);
+			vq->call_ctx.producer.token = NULL;
+		}
+		break;
 	}
 
 	r = vhost_vring_ioctl(&v->vdev, cmd, argp);
@@ -433,13 +439,16 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			cb.callback = vhost_vdpa_virtqueue_cb;
 			cb.private = vq;
 			cb.trigger = vq->call_ctx.ctx;
+			vq->call_ctx.producer.token = vq->call_ctx.ctx;
+			if (ops->get_status(vdpa) &
+			    VIRTIO_CONFIG_S_DRIVER_OK)
+				vhost_vdpa_setup_vq_irq(v, idx);
 		} else {
 			cb.callback = NULL;
 			cb.private = NULL;
 			cb.trigger = NULL;
 		}
 		ops->set_vq_cb(vdpa, idx, &cb);
-		vhost_vdpa_setup_vq_irq(v, idx);
 		break;
 
 	case VHOST_SET_VRING_NUM:
@@ -990,6 +999,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	for (i = 0; i < nvqs; i++) {
 		vqs[i] = &v->vqs[i];
 		vqs[i]->handle_kick = handle_vq_kick;
+		vqs[i]->call_ctx.ctx = NULL;
 	}
 	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
 		       vhost_vdpa_process_iotlb_msg);
-- 
2.43.0



