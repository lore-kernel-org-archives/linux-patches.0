Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5EA511E96;
	Wed, 30 Sep 2026 18:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792971; cv=none; b=F2i4JqUZOimwoNSFVDq9m8rs2V2VJP06mr7z2AeZkE7r3ssylMcG25ZzJf/rRdGicf09W8WpszEN1S0F8KPjKoDTKUpV3WkYEbRS7jwDoJQc8ezRFDuQMdIKmppI3eEA3drBuTarcg9vBA2KRPU3inuwObYApmcrAetdA2d80tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792971; c=relaxed/simple;
	bh=dkJd31Fs9Qa7+9YOwiKfVV6z9Laaf6HaDr9yIgyDOR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xv/Wx2eoIa6IW7dBwbkC+0+mtK8OWTvTp2ufsC1t24gLPkSEzBVs+JHVRtj05e/q3L3nAWMBUIezWjy4CIkc2JvvL3AfH+4PttAc/dIMc3FOUeTxeICpzakOpkO2//78pHq+f6vZ5XP2cP1mEkqSbgfsJTpIC8JFP84uGMXIXlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vz15Ft/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vz15Ft/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AA31F000FF;
	Wed, 30 Sep 2026 18:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792970;
	bh=jv1FIgG7EDDY6OZ7Ms3zwSFjIV2Dvm71c0LphDDGt2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1vz15Ft/cNysuuOkekDPY3QN4B1WskA5D82VT/mxoxo2ZI8JVLvDP84K3ROUjT0j4
	 iCkPptqqoB9bHnrZAr3ZSBDuKKzN83/gTayW3R1xhzeyXW06Npua5XNs1rwh2ie80P
	 PLaCky0bgJW/aHuJ4PpievBmR/aWfJl1NpqFEAR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 091/395] drm/virtio: fix object leak when drm_gem_handle_create() fails
Date: Wed, 30 Sep 2026 17:25:53 +0200
Message-ID: <20260930152342.608951720@linuxfoundation.org>
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

[ Upstream commit 36570ef2244cc4d7563b1f0157bc0f032498638c ]

virtio_gpu_gem_create() owns the reference taken by
virtio_gpu_object_create(). On the drm_gem_handle_create() error path it
calls drm_gem_object_release() instead of dropping that reference.

drm_gem_object_release() is the inverse of drm_gem_object_init() and does
not touch the reference count or call obj->funcs->free(), so it is only
correct as the last step of a destructor, as in
virtio_gpu_cleanup_object(). Using it here leaves the bo at refcount 1
with no remaining reference, so virtio_gpu_free_object() never runs and
the shmem pages, sg table and virtio_gpu_object are leaked. Since
virtio_gpu_object_create() has already set bo->created,
VIRTIO_GPU_CMD_RESOURCE_UNREF is not queued either, leaking the host-side
resource and the resource id.

drm_gem_handle_create_tail() drops the handle reference on all of its
internal error paths, so the caller only has to drop its own. Use
drm_gem_object_put(), matching the success path below.

Fixes: dc5698e80cf7 ("Add virtio gpu driver.")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/20260915-fixes-v2-1-a0d799e4db66@outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_gem.c b/drivers/gpu/drm/virtio/virtgpu_gem.c
index 7174086119c51..aea5e1b60e7f3 100644
--- a/drivers/gpu/drm/virtio/virtgpu_gem.c
+++ b/drivers/gpu/drm/virtio/virtgpu_gem.c
@@ -45,7 +45,7 @@ static int virtio_gpu_gem_create(struct drm_file *file,
 
 	ret = drm_gem_handle_create(file, &obj->base.base, &handle);
 	if (ret) {
-		drm_gem_object_release(&obj->base.base);
+		drm_gem_object_put(&obj->base.base);
 		return ret;
 	}
 
-- 
2.53.0



