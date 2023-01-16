Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D706FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A87C433D2;
	Mon, 16 Jan 2023 16:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888396;
	bh=jQsmk5tXJjKHtfAkhU8on6qMEORHH56xYvg9DKxlLh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A343nVCijuAQakap3e+eo9zW6/HRIoX6804M5jNkfZ8D5JreJJTGrfzOy5wjhFbq1
	 l7lJzJuuKGW6w9HuJHiHAKQRenR/oHtqjS/Q54hv06ODzq36LmbLEYY26Q5wKqi/if
	 fLK8cBWug3S1Jh1i5zJNyyzc4/1SFzNWt7iWiNHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 512/521] drm/virtio: Fix GEM handle creation UAF
Date: Mon, 16 Jan 2023 16:52:54 +0100
Message-Id: <20230116154910.109110575@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 52531258318ed59a2dc5a43df2eaf0eb1d65438e ]

Userspace can guess the handle value and try to race GEM object creation
with handle close, resulting in a use-after-free if we dereference the
object after dropping the handle's reference.  For that reason, dropping
the handle's reference must be done *after* we are done dereferencing
the object.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Fixes: 62fb7a5e1096 ("virtio-gpu: add 3d/virgl support")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221216233355.542197-2-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 8d2f5ded86d6..a539843a03ba 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -309,7 +309,6 @@ static int virtio_gpu_resource_create_ioctl(struct drm_device *dev, void *data,
 		}
 		return ret;
 	}
-	drm_gem_object_put_unlocked(obj);
 
 	rc->res_handle = res_id; /* similiar to a VM address */
 	rc->bo_handle = handle;
@@ -318,6 +317,15 @@ static int virtio_gpu_resource_create_ioctl(struct drm_device *dev, void *data,
 		virtio_gpu_unref_list(&validate_list);
 		dma_fence_put(&fence->f);
 	}
+
+	/*
+	 * The handle owns the reference now.  But we must drop our
+	 * remaining reference *after* we no longer need to dereference
+	 * the obj.  Otherwise userspace could guess the handle and
+	 * race closing it from another thread.
+	 */
+	drm_gem_object_put_unlocked(obj);
+
 	return 0;
 fail_unref:
 	if (vgdev->has_virgl_3d) {
-- 
2.35.1



