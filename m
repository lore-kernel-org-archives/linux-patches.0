Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AAA40B6D4;
	Wed, 30 Sep 2026 19:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796732; cv=none; b=kPq9ZQJw9im5bsX2T6QSWAoSJz+boAeiHupWFzTnXgF4R2KB3qNLLGm9/Xz1GJUXi9uo7URXEY5A4hlTPbg2a7oDTI4hRMPDhf7Z1oJERL5Yu8zzhbQUnwwvuoEFodJeguGKWZ+A9I6icySYK5mu1lTvVr4TPHmxkP25CHjbsPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796732; c=relaxed/simple;
	bh=f7tMxS5A9fPOA9YbelrNwGMUrU3FV065pZMoB+vefco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSR6VTyv3T0UahLv/4OfrGr5g2HdyZ7CJx2RqVaHnxFj1jRVPBD3ixE70bhZJl4UzUpra2DGQoOoYU1wCvRt85C/6JPQhvXKWXgAccCHsm/qUbrIVwjZjVmg7flZqwMXj2y9D1piV6/JNtZpLjsgMrEFegnLUgc16py2BZOV6VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ml9i7V9c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ml9i7V9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E875E1F000FF;
	Wed, 30 Sep 2026 19:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796729;
	bh=K79S72AuaFI9n8QL+T2bNcgcjAoD+Bln0Gz/ZulFCCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ml9i7V9cDwQvmg9lkf/ybsJFmCATrlzhikl3QULes3kTYPaRkj0OU1behJ9D9lVyL
	 3bzo1PF+7BwRdnDUxHMohE/7KrZP19riUE7ItyMSaIXRcMgl3Ac3GrFyBY/uxeRaJy
	 qU6nCJ75dIWqIBZXOgMEUyLIINKUdyz/7FvcAWL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1016/1193] drm/virtio: release the GEM object on virtio_gpu_vram_create() errors
Date: Wed, 30 Sep 2026 17:28:20 +0200
Message-ID: <20260930152456.815496918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



