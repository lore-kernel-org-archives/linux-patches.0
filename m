Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3F93BE642;
	Wed, 30 Sep 2026 18:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792983; cv=none; b=CKFRqWTyFZ2dt13wVlK+zIZRF54PzGkGbe1FYsk1iF/45MiaTBmuvjOqgvUGN9u3O4ooAeq7JmKshIshjYVzSJWANYnY0tj7CWDCWUzSIEa1aF+UcTQQecq6NcrDucqeM+St5Nz0sis6JEkycdEvbukhsIfmEVLHr2sB/cKJ6DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792983; c=relaxed/simple;
	bh=rZzKdb6MJZnK3Uib3Tz22fqjYpx0kTACz9xh+N+ESBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uekOQq/kErEGB5zqEvSU9dZZSDXTeZAczXxX8OHIf3Je/W1FXX7nyvZNHXvuRRs7qoKRqqV5m6+ohNOQRF5LxOEZb72eNkjsTga7nypE/CaE1XAaEkWAXOBSLkXAaixW16GjWRRAloT2eSUU7tV9/JhJaQBlwAQHBz24QCmsyL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dj2KbF0s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dj2KbF0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5770F1F000FF;
	Wed, 30 Sep 2026 18:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792981;
	bh=p9EXgK12OW8nC1XpItizcCl/mkueEwzMjkJtovsbWX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dj2KbF0sd4IWtYGOn6Qhst99usrO08vQNe/BhiAGD/Li4hvM3TORv5X1cTh2qrWBU
	 lxgK0VMaoyI+mJSR1OC0mg11Xuza6PuipARYie0vG78rP2n4ljpHZzZyagR4UPlkY+
	 5KabqJcz+WJHEN3Hr13KNeSRAU+FF2Pstu3sAe+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 094/395] drm/virtio: release the GEM object on virtio_gpu_vram_create() errors
Date: Wed, 30 Sep 2026 17:25:56 +0200
Message-ID: <20260930152342.674174830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 036d28db1818af2f9d80db771f5405da84d7732d ]

virtio_gpu_vram_create() frees the object with a bare kfree(vram) on
both error paths after drm_gem_private_object_init() has run, and on the
second one after drm_gem_create_mmap_offset() has linked obj->vma_node
into the device's VMA offset manager. The freed object stays in that
interval tree, so a later lookup or insertion walks freed memory, and
the dma_resv and gpuva lock are never destroyed.

Call drm_gem_object_release() before kfree() on both paths.

Fixes: 16845c5d5409 ("drm/virtio: implement blob resources: implement vram object")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/20260915-fixes-v2-4-a0d799e4db66@outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_vram.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_vram.c b/drivers/gpu/drm/virtio/virtgpu_vram.c
index 5ad3b7c6f73c3..f955779d5ea0e 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vram.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vram.c
@@ -205,16 +205,12 @@ int virtio_gpu_vram_create(struct virtio_gpu_device *vgdev,
 
 	/* Create fake offset */
 	ret = drm_gem_create_mmap_offset(obj);
-	if (ret) {
-		kfree(vram);
-		return ret;
-	}
+	if (ret)
+		goto err_release_obj;
 
 	ret = virtio_gpu_resource_id_get(vgdev, &vram->base.hw_res_handle);
-	if (ret) {
-		kfree(vram);
-		return ret;
-	}
+	if (ret)
+		goto err_release_obj;
 
 	virtio_gpu_cmd_resource_create_blob(vgdev, &vram->base, params, NULL,
 					    0);
@@ -228,4 +224,9 @@ int virtio_gpu_vram_create(struct virtio_gpu_device *vgdev,
 
 	*bo_ptr = &vram->base;
 	return 0;
+
+err_release_obj:
+	drm_gem_object_release(obj);
+	kfree(vram);
+	return ret;
 }
-- 
2.53.0



