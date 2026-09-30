Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D5E364059;
	Wed, 30 Sep 2026 17:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789134; cv=none; b=PDiWjfabTXK/nBVNPU10ypcUE7gu3DS7azpYlOqlyD9NYgj8f7Gkjymbi9oJQ+Qar0mWqig90gp97zdo8haFi9yDE1vjR2jn0uf73mnGIO8P/LV6UIdNEUA2I5TflhjqQUHZtZn1pig50uj4Cq2c6c1L9b2XZoYK4Z9WumYzinc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789134; c=relaxed/simple;
	bh=FgMo5k0DUZZy4SSVC1JNfwj8j5UWhIpJM5AWYkdLFOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTxNzK8/XvrNPMpE7zWftqvdoam2F7Sbrpj0DJWHW0Yd8o54scMmsY8hS5RVSNvv/fAkjJ67r7rD8goTCcIERgPF50CQDfaQCg0cv6KmvRX50hvIbbSFZEEmOXC7HkSf3RIL3FLNiSulN4dZWx+5Rk8WTAEsZieXcDeYbKnMXHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiE0bla8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiE0bla8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1321F000FF;
	Wed, 30 Sep 2026 17:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789133;
	bh=/kI4ykHaqS6fUE00gHqHWgPsngHl8hj2bz7XrfNUdGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZiE0bla8P5uAN/DeDqr1DVJS5Ues5vVu0/G5q0plc6HjqHuiWeQIu2OwDGRueNP0a
	 qYSJTYTVvgOpipgc0MWgtnDnxfPoTj8gaNuLmwn+dH2I11myqgLXRWYJsH27L5uRwT
	 y87qrggcAgIFnd2eUYHC/uupGJFylPN1LjXIA/z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 370/877] drm/virtio: fix object leak in virtio_gpu_resource_create_ioctl()
Date: Wed, 30 Sep 2026 17:21:21 +0200
Message-ID: <20260930152422.661886850@linuxfoundation.org>
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
index e4f76f3155504..60e5146ddefec 100644
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



