Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF0A51AFD2;
	Wed, 30 Sep 2026 17:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789140; cv=none; b=GX4s5+cX/GVEqcpAhPU53QXXHozhUY84AhiUThg4dKPjHsYOVh05+oJCC5TwlPdxj1pPTLffS5mJM3F7Ro5hutS+3tT3DMq2qvCbaSf8QYDVMTgj3JESSh3FyoHVUWUcNTs6LnBGf4K5WHrtHPZ3v8jd4x4YS06t6FAhYTNCq/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789140; c=relaxed/simple;
	bh=4jGBqnbhAYp2EVM3EX4gbEAGHpzJHypxbAEuohVixbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKhvpCWq6IQH6htlo8gbETi9QDcS3GlG7S7Cm+TNNrWV3UUtW8jLbcFwVcu+DwnAESo7T2PBbbeUJdsLzhbsyIHxL2Eu/+wK6IZzRARjLsmbGEnGPlX7Kj18irWUD/e1Yb1aBv6RmlQuNEgSleViG7WWD2+oO0hpcpgmD/nIRN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I997qXEY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I997qXEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439311F00899;
	Wed, 30 Sep 2026 17:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789138;
	bh=YjhvwOZXfZKT9uXdJ5hGX5oDUWXB2dvQj+rKPaz4JZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I997qXEYRX1j0lCQ3utB+M5pCgp2cC5gP17C4UScQ1KalIqmuhjTI7WbBcu3bjarQ
	 MnGZcT6oTaOspF6Vmd5B+gCT7EMmNLWQfrJ15eoaPh2yKRG8S8nuDuvbZpXAQpKSwZ
	 UDeDxXTXq2HSuW0Wcpmt5ELp7t3SCGgMEa8XKjhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 372/877] drm/virtio: release the GEM object on virtio_gpu_vram_create() errors
Date: Wed, 30 Sep 2026 17:21:23 +0200
Message-ID: <20260930152422.703595336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 25df81c027837..47a886824cd71 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vram.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vram.c
@@ -202,16 +202,12 @@ int virtio_gpu_vram_create(struct virtio_gpu_device *vgdev,
 
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
@@ -225,4 +221,9 @@ int virtio_gpu_vram_create(struct virtio_gpu_device *vgdev,
 
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



