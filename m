Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A98C51354E;
	Wed, 30 Sep 2026 16:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786405; cv=none; b=S9uKPSi4nZWLajKuFk/JI8wlLvc9Q+mZrRUvYUMiFarGwXLPx0Kt/o+hdUAblOXDB4GJE/LjCm08YdrefjEca72LNxEwcK3WJs8q6TP02+53IKOIY49uIpCZogBYltpXbvuLTpgmSRINcZy/fenvV9jG9CKjg1AVTDT92wUYYMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786405; c=relaxed/simple;
	bh=Icl827Wce5cJ5Uk2MdHfcCS5BiG6hBgauA1fJ2/FK+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpeN9/+XKD0ucZ5ZIhQM/WK5SLqJJYJbGSiHFid3zGy4W9yI9Ftd0ZPa0mjDnJZvgzoPB7jMYi9PghsfPsQCIx13ehPJee7ylGEYGwBbpCULbO2PbNjyBEF9CPutsIeo2Wo4TMfuBoqxEe6qbLy2ygfMjc7Oe5tW+Lr3Snj6j5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAmhF+S3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAmhF+S3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57501F000FF;
	Wed, 30 Sep 2026 16:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786404;
	bh=9MnAnEj7puym2784fNSXjUSJEwpTzGJwGUAkO49bgAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nAmhF+S3sx2I6HZawt6gAaOMM7UeofSqNGD8DumY97qNpINUJxp06yfR/a4//8Rid
	 RTi56JdrbLUOqm/N1XL6Xi6LhdlLLTNBtmKri1DNVO4mliUC8jt4y5I2a555eR9JNQ
	 PLe7d5MfQf6bLrMaKqswP0dlYhhVbRdndTeFBvaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 850/982] drm/virtio: fix object leaks in virtio_gpu_resource_create_blob_ioctl()
Date: Wed, 30 Sep 2026 17:26:26 +0200
Message-ID: <20260930152435.006887058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 24b6d5c7641412c9ebef0d4c8b888d49a0e6b880 ]

virtio_gpu_resource_create_blob_ioctl() calls drm_gem_object_release() on
both the virtio_gpu_resource_assign_uuid() and drm_gem_handle_create()
error paths instead of dropping the reference it owns, so
obj->funcs->free() never runs and the virtio_gpu_object, the resource id
and the host-side resource are leaked.

Use drm_gem_object_put() instead.

Fixes: 897b4d1acaf5 ("drm/virtio: implement blob resources: resource create blob ioctl")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/20260915-fixes-v2-3-a0d799e4db66@outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index df6edae131139..ef83b4f400697 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -724,14 +724,14 @@ static int virtio_gpu_resource_create_blob_ioctl(struct drm_device *dev,
 	if (params.blob_flags & VIRTGPU_BLOB_FLAG_USE_CROSS_DEVICE) {
 		ret = virtio_gpu_resource_assign_uuid(vgdev, bo);
 		if (ret) {
-			drm_gem_object_release(obj);
+			drm_gem_object_put(obj);
 			return ret;
 		}
 	}
 
 	ret = drm_gem_handle_create(file, obj, &handle);
 	if (ret) {
-		drm_gem_object_release(obj);
+		drm_gem_object_put(obj);
 		return ret;
 	}
 
-- 
2.53.0



