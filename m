Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD0643C7C2;
	Thu, 30 Jul 2026 14:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423391; cv=none; b=lGnVo1oKO6tTzVkf24vy332Aj3MTwS5whWToACwqlBvPRu5NoqoiHru9/BUeGBj21yf641yS3Xg83xrxTD37O4A3ipTOIL5Mr9Dw3+SACPEWriiI8dpyiGB4yHIbrgtlr8mJiZSrrgC7o11NzNTcCfs3iQD7tjk57xRErVqrJL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423391; c=relaxed/simple;
	bh=y8WyXDazt8em5RDur2RCW0x9TMx9wnOxAI/WqlvLxL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWKNKleh6VBuflx1P+R4HcOARdMHF9U8V30VhlsvHNsxqW9mXv5QpDh9lNoKhYH47iv+BBqJhu7Aj611LTwBXxqv30MiajHi4zmAPG04TAxoZxye1S924K4QW+3m+baVq4+mWQpJNmC9mO02/pRqTCENzzqHNHZkscY4mJiIH78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Up9IOatj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Up9IOatj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEB11F000E9;
	Thu, 30 Jul 2026 14:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423390;
	bh=qbrV03dMxlc1XUIcyNO5m1bm0RCY5ziZGJdmgWUIIks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Up9IOatjTIhXXsF2QeT2iqmbpbE8i/JSioFvjZXv2AF25MFuXC+/D3yMSoDlgxCds
	 U3VgDrDP7YIwMy3dz6ss5V9vcWBx7OaD110Je2ixmWYm1cVJ6bznP5xIrZfnL0sfHv
	 pE2pRsqYiPMPNLkJcABPCpvFXQzRx4tbfT3prWMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/675] drm/virtio: fix deadlock in display_info_cb by removing hotplug from dequeue worker
Date: Thu, 30 Jul 2026 16:05:37 +0200
Message-ID: <20260730141445.272563639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryosuke Yasuoka <ryasuoka@redhat.com>

[ Upstream commit d1b894c5bbb3fee0012bd14356286dc2384e8213 ]

A probe-time deadlock can occur between the dequeue worker and
drm_client_register(). During probe, drm_client_register() holds
clientlist_mutex and calls the fbdev hotplug callback, which triggers an
atomic commit that ends up sleeping in virtio_gpu_queue_ctrl_sgs()
waiting for virtqueue space. The dequeue worker that would free that
space calls virtio_gpu_cmd_get_display_info_cb(), which invokes
drm_kms_helper_hotplug_event() -> drm_client_dev_hotplug(), attempting
to acquire the same clientlist_mutex. Since wake_up() is only called
after the resp_cb loop, the probe thread is never woken and both threads
deadlock.

Fix this by removing the hotplug notification from
virtio_gpu_cmd_get_display_info_cb(). The display data (outputs[i].info)
is still updated synchronously in the callback.

For the init path, drm_client_register() already fires an initial
hotplug when the client is registered, which picks up the connector
state updated by display_info_cb.

For the runtime config_changed path, add a wait_event_timeout() in
config_changed_work_func() so that display_info_cb updates the connector
data before the hotplug notification is sent. Also replace
drm_helper_hpd_irq_event() with drm_kms_helper_hotplug_event() since
virtio-gpu never calls drm_kms_helper_poll_init() and thus
drm_helper_hpd_irq_event() always returns false without doing anything.

Fixes: 27655b9bb9f0 ("drm/client: Send hotplug event after registering a client")
Closes: https://syzkaller.appspot.com/bug?id=d6dd6f86d3aaf7eebe7406e45c1c6e549453f224
Closes: https://syzkaller.appspot.com/bug?id=908bd910da5dd79b88de4cf7baf376cc873a922e
Suggested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/20260713-virtiogpu_syzbot-v2-1-2958fa37d46d@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_kms.c | 5 ++++-
 drivers/gpu/drm/virtio/virtgpu_vq.c  | 3 ---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_kms.c b/drivers/gpu/drm/virtio/virtgpu_kms.c
index 1c15cbf326b78c..4a25347734fda4 100644
--- a/drivers/gpu/drm/virtio/virtgpu_kms.c
+++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
@@ -48,7 +48,10 @@ static void virtio_gpu_config_changed_work_func(struct work_struct *work)
 				virtio_gpu_cmd_get_edids(vgdev);
 			virtio_gpu_cmd_get_display_info(vgdev);
 			virtio_gpu_notify(vgdev);
-			drm_helper_hpd_irq_event(vgdev->ddev);
+			wait_event_timeout(vgdev->resp_wq,
+					   !vgdev->display_info_pending,
+					   5 * HZ);
+			drm_kms_helper_hotplug_event(vgdev->ddev);
 		}
 		events_clear |= VIRTIO_GPU_EVENT_DISPLAY;
 	}
diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
index 8181b22b9b46a1..412384e16daea4 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -839,9 +839,6 @@ static void virtio_gpu_cmd_get_display_info_cb(struct virtio_gpu_device *vgdev,
 	vgdev->display_info_pending = false;
 	spin_unlock(&vgdev->display_info_lock);
 	wake_up(&vgdev->resp_wq);
-
-	if (!drm_helper_hpd_irq_event(vgdev->ddev))
-		drm_kms_helper_hotplug_event(vgdev->ddev);
 }
 
 static void virtio_gpu_cmd_get_capset_info_cb(struct virtio_gpu_device *vgdev,
-- 
2.53.0



