Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747053B71B6;
	Wed, 30 Sep 2026 18:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792974; cv=none; b=l4I3S1VkdCZ+AJjlVlcaDAi4ECzpzv8TFeZk/QX2f4z6S1GoPRzWvIC1gYgicSIxlwRdmxotRx65QdcH2d87alaJK6hEToFAulv9/k8Qx1HUK5MW8JZ/PCJlDmOUQgMxGJtjBMRef/kMAe5x/hYGvDKLO/0bZOdEskw3MIIScdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792974; c=relaxed/simple;
	bh=t+GCcpHfvZBx+RbyJn659srLJqgkn+UyeWfzo+VMlEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuygKTIBiuOd3VUeRJWG+VAFmhHofzT+Cxp/6tMGFbCEkjtE95DCYj2a//fvM2TmsjbMbkPqFEYCEMNB+278qiRofWVZc+1hPYh6lL0v3T0pwFZFmQZzvEM2zxGFF0K2VTsWfdo4jNQUAwHCW9orrN4rRjaR2tdz0WvhKG9Kj30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvD5V2k/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvD5V2k/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08D21F000FF;
	Wed, 30 Sep 2026 18:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792973;
	bh=pVfEKKpEn1+bv34xZtVhaj7YD15A3rZcC5VUkzku990=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JvD5V2k/uvaydIVcnP2hVYLct7szc0yr2eIA+Yumsqp6ZXYW+2C7Ex1QLO4FRZNoy
	 jAxfuyEK3bA2+94qkXlkRrIpxYwj8UOmrQNwKNl7a9TSrZaYHevEglmZ3bVfVaImSA
	 Su4e9fZ3CyjRLVf+Yjl8XIYAKyqAiKUFLsyHysgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 092/395] drm/virtio: fix object leak in virtio_gpu_resource_create_ioctl()
Date: Wed, 30 Sep 2026 17:25:54 +0200
Message-ID: <20260930152342.630639223@linuxfoundation.org>
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

[ Upstream commit 477bc3068fc3777b9d8ffd79e265b0dfdf2d3a6b ]

virtio_gpu_resource_create_ioctl() calls drm_gem_object_release() on the
drm_gem_handle_create() error path instead of dropping the reference it
owns, so obj->funcs->free() never runs and the virtio_gpu_object, its
pages and sg table, the resource id and the host-side resource are
leaked.

Use drm_gem_object_put() instead.

Fixes: 62fb7a5e1096 ("virtio-gpu: add 3d/virgl support")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/20260915-fixes-v2-2-a0d799e4db66@outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index c33c057365f85..2d5cd7fb70e22 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -180,7 +180,7 @@ static int virtio_gpu_resource_create_ioctl(struct drm_device *dev, void *data,
 
 	ret = drm_gem_handle_create(file, obj, &handle);
 	if (ret) {
-		drm_gem_object_release(obj);
+		drm_gem_object_put(obj);
 		return ret;
 	}
 
-- 
2.53.0



