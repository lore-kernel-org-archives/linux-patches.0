Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7115029114A;
	Wed, 23 Apr 2025 15:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421455; cv=none; b=nWj6rPyasoLNzm+L06QbZGnj+owpS/aZmDdOqyXzNkQs+6FHgrq8wEC5fVKZdXMiCtqB+h28O9iS+sJwO56ilJez8fSTQkH795Q/ek9eui6PfcWgJTMUgo4focWm7k7z96+2E4AQNnsibMVi8FQ8qKAYZmUlp4gKp6pmUKWw1a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421455; c=relaxed/simple;
	bh=YfINHVez/PryaHaNSBaxfb6HTkf43eMFWIf4f2JmgaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQsQ3JPJt0oaiDfH8peLs8ioQEkyOYixmv3lhBzQL1pSooXuOVgidyqQjEAOoA2rpYYSyn7c6OFigDfmfmXMHDog1PdSw8YaaxKwFaK7tkihSVo4fajCfV8sEwXNNXu3dG5/PRUQuLjI6+x/aqFOYCT4DuNdCe5q4+DXoqqg5tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EC0YlDKI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EC0YlDKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02295C4CEE2;
	Wed, 23 Apr 2025 15:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421455;
	bh=YfINHVez/PryaHaNSBaxfb6HTkf43eMFWIf4f2JmgaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EC0YlDKIyuD+if8QXw0ZgI7BWb+aJpEiar5B9vkJ9NZlsD5JpL2LutuI6EMDBf2QC
	 7Pqn4HPnhG5U4N8pBXel5b5IC7dhgnppuoYbPwgPYrIL68U6hp2WrZLlAJufedGemA
	 hpIdqHMTd20mD2a5sY4jE6aCv9CntVxYzoCpUDF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Rob Clark <robdclark@gmail.com>
Subject: [PATCH 6.14 191/241] drm/virtio: Dont attach GEM to a non-created context in gem_object_open()
Date: Wed, 23 Apr 2025 16:44:15 +0200
Message-ID: <20250423142628.320664688@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit 7cf6dd467e87664f5b3f4ca7be324569464edf0b upstream.

The vfpriv->ctx_id is always initialized to a non-zero value. Check whether
context was created before attaching GEM to this context ID. This left
unnoticed previously because host silently skips attachment if context
doesn't exist, still we shouldn't do that for consistency.

Fixes: 086b9f27f0ab ("drm/virtio: Don't create a context with default param if context_init is supported")
Cc: <stable@vger.kernel.org> # v6.14+
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Link: https://lore.kernel.org/r/20250401123842.2232205-1-dmitry.osipenko@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_gem.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_gem.c b/drivers/gpu/drm/virtio/virtgpu_gem.c
index 5aab588fc400..3d6aa26fdb53 100644
--- a/drivers/gpu/drm/virtio/virtgpu_gem.c
+++ b/drivers/gpu/drm/virtio/virtgpu_gem.c
@@ -115,13 +115,14 @@ int virtio_gpu_gem_object_open(struct drm_gem_object *obj,
 	if (!vgdev->has_context_init)
 		virtio_gpu_create_context(obj->dev, file);
 
-	objs = virtio_gpu_array_alloc(1);
-	if (!objs)
-		return -ENOMEM;
-	virtio_gpu_array_add_obj(objs, obj);
+	if (vfpriv->context_created) {
+		objs = virtio_gpu_array_alloc(1);
+		if (!objs)
+			return -ENOMEM;
+		virtio_gpu_array_add_obj(objs, obj);
 
-	if (vfpriv->ctx_id)
 		virtio_gpu_cmd_context_attach_resource(vgdev, vfpriv->ctx_id, objs);
+	}
 
 out_notify:
 	virtio_gpu_notify(vgdev);
-- 
2.49.0



