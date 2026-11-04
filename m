Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829328;
	b=eUw3Q38V2YvvWQ7kkNo6cQPQhzDYFQEWT/0KsjVI8U9+uaCX1O0hZgRQ9SBb2LEXmJCe
	 Irv24vNDpdJbiXUS/fZwolLYJq3Oj/J/MAKMsNC7bJ/PSEybkU8iQraU4IWTorh19GgJS
	 patm1sCbTD8PKpgNYN7rCDgInlm9wc0NZngdGf7Z7hewA1N7zte0TlHwCSI2Vi5aA83FP
	 w/zxk3Wf3GPuUYa24w3KTrfnj8SSOt1819qcXL+bc7XEmdIxZEFOn8uPysIcNnBkmgW4a
	 ha2F5fZmCKneHJm/J4wrq4aG5pOnfEgGz+xZKJpKj3LBs8Fmi4rxs3mrx4E31J7cEdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YDjLEBmNaC72TJ0CMOATsyCcafrviz40Wm3i6ZoOA+0=;
	b=Rt6KyForh9FbVe3ws1H7JHWkQyO4BM3cyyZ+O62OvWhST6D6Yt0VJ5tKwNN48ODumS0q
	 f8etSIQXMRNGuOvIbmc2r0CJPooyopOBGfcajw6DKDZdjybL8vTAQYZwZ0KclSn3axdQg
	 W07sfHRE7LnTso8dqoR+LoiDv/JSa3pi8DiYcBHMuy0RHkMttIrRwYP11hcZr8XLUfDyn
	 Sqn82Nmq4k7ON+lsdw/mD53kZOhxDTIo5r3Bi1x5/RfVd5PQ5Uw1MEEkeGmaXZ08TMFgm
	 xv6MIHMu0u9UL2ykQF+6mfyQv5G8tYJUncVVHrrOd6jqpnKbz8QCZt53AwXZrKnfK4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nahv0c2g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D276086624;
	Wed,  4 Nov 2026 21:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nahv0c2g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7681F00A15;
	Wed,  4 Nov 2026 21:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829327;
	bh=YDjLEBmNaC72TJ0CMOATsyCcafrviz40Wm3i6ZoOA+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nahv0c2g079G4l6D+W0eS251W2QvG18KMg3t1exZk4ItUumXL93uJYi/KTWQegMyg
	 7dlRL7mP910pnII1dUGqHbUwQRvaSiYC2JXZy9sV37TgoRWWAk6LgJzpM+z9JDT8Sx
	 mk9tHddk3FXfOabOpNqjbtZ3ztpVWTTC3CFHkPl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0016/1005] drm/virtio: abort virtqueue wait on device removal to avoid hung task
Date: Wed,  4 Nov 2026 15:55:49 -0500
Message-ID: <20261104211043.999028707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryosuke Yasuoka <ryasuoka@redhat.com>

[ Upstream commit a46991b334f663fa0e0e9c051e50587ef977ac8b ]

virtio_gpu_queue_ctrl_sgs() and virtio_gpu_queue_cursor() use
wait_event() without any abort condition when waiting for virtqueue
space. If the host device stops processing commands, these waits block
indefinitely inside a drm_dev_enter/exit() critical section. Since
drm_dev_unplug(), which is called in device removal and system shutdown
call path, blocks on synchronize_srcu() until all critical sections
complete, device removal and system shutdown also hang.

Add a vqs_released flag to virtio_gpu_device and include it in the
wait_event() condition. Set the flag and wake up both queues in a new
virtio_gpu_release_vqs() helper, called before drm_dev_unplug() in both
virtio_gpu_remove() and virtio_gpu_shutdown(). When the flag is set, the
wait returns immediately and the command is aborted, following the same
cleanup path as drm_dev_enter() failure.

Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/20260601-virtio-gpu_wait_event-v3-1-89530517a98a@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_drv.c | 15 +++++++++++++++
 drivers/gpu/drm/virtio/virtgpu_drv.h |  1 +
 drivers/gpu/drm/virtio/virtgpu_vq.c  | 23 +++++++++++++++++++++--
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.c b/drivers/gpu/drm/virtio/virtgpu_drv.c
index d9556e1b67b10..78cc388b434d9 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.c
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.c
@@ -118,10 +118,24 @@ static int virtio_gpu_probe(struct virtio_device *vdev)
 	return ret;
 }
 
+/*
+ * Release pending virtqueue waits so the drm_dev_enter/exit() critical
+ * sections complete before drm_dev_unplug() blocks on synchronize_srcu().
+ */
+static void virtio_gpu_release_vqs(struct drm_device *dev)
+{
+	struct virtio_gpu_device *vgdev = dev->dev_private;
+
+	vgdev->vqs_released = true;
+	wake_up_all(&vgdev->ctrlq.ack_queue);
+	wake_up_all(&vgdev->cursorq.ack_queue);
+}
+
 static void virtio_gpu_remove(struct virtio_device *vdev)
 {
 	struct drm_device *dev = vdev->priv;
 
+	virtio_gpu_release_vqs(dev);
 	drm_dev_unplug(dev);
 
 	if (drm_core_check_feature(dev, DRIVER_ATOMIC))
@@ -135,6 +149,7 @@ static void virtio_gpu_shutdown(struct virtio_device *vdev)
 {
 	struct drm_device *dev = vdev->priv;
 
+	virtio_gpu_release_vqs(dev);
 	/* stop talking to the device */
 	drm_dev_unplug(dev);
 }
diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.h b/drivers/gpu/drm/virtio/virtgpu_drv.h
index 8575c7787fc36..51b78f8a8aa2e 100644
--- a/drivers/gpu/drm/virtio/virtgpu_drv.h
+++ b/drivers/gpu/drm/virtio/virtgpu_drv.h
@@ -260,6 +260,7 @@ struct virtio_gpu_device {
 
 	struct virtio_gpu_queue ctrlq;
 	struct virtio_gpu_queue cursorq;
+	bool vqs_released;
 	struct kmem_cache *vbufs;
 
 	atomic_t pending_commands;
diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 592ad4f9b100d..244a791ab915e 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -422,7 +422,19 @@ static int virtio_gpu_queue_ctrl_sgs(struct virtio_gpu_device *vgdev,
 	if (vq->num_free < elemcnt) {
 		spin_unlock(&vgdev->ctrlq.qlock);
 		virtio_gpu_notify(vgdev);
-		wait_event(vgdev->ctrlq.ack_queue, vq->num_free >= elemcnt);
+		wait_event(vgdev->ctrlq.ack_queue,
+			   vq->num_free >= elemcnt || vgdev->vqs_released);
+		/*
+		 * Set by virtio_gpu_release_vqs() to unblock
+		 * synchronize_srcu() wait in drm_dev_unplug().
+		 */
+		if (vgdev->vqs_released) {
+			if (fence && vbuf->objs)
+				virtio_gpu_array_unlock_resv(vbuf->objs);
+			free_vbuf(vgdev, vbuf);
+			drm_dev_exit(idx);
+			return -ENODEV;
+		}
 		goto again;
 	}
 
@@ -592,7 +604,14 @@ static void virtio_gpu_queue_cursor(struct virtio_gpu_device *vgdev,
 	ret = virtqueue_add_sgs(vq, sgs, outcnt, 0, vbuf, GFP_ATOMIC);
 	if (ret == -ENOSPC) {
 		spin_unlock(&vgdev->cursorq.qlock);
-		wait_event(vgdev->cursorq.ack_queue, vq->num_free >= outcnt);
+		wait_event(vgdev->cursorq.ack_queue,
+			   vq->num_free >= outcnt || vgdev->vqs_released);
+		/* See comment in virtio_gpu_queue_ctrl_sgs(). */
+		if (vgdev->vqs_released) {
+			free_vbuf(vgdev, vbuf);
+			drm_dev_exit(idx);
+			return;
+		}
 		spin_lock(&vgdev->cursorq.qlock);
 		goto retry;
 	} else {
-- 
2.53.0



