Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D913BE642;
	Wed, 30 Sep 2026 18:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792977; cv=none; b=Nwny3mtVv9ozz3OsrzZgpHrzhrSlmiuj88BlngvsUDu2qcBrNOAL3Wx5I2s2sEjt/ouj9c+SDVuMRewsDuQaStUG0Ou5ultkusziHNE3XyIGa0Lg2akesHM/Si3bJq7m48yFDOHzwAGHf+JFBf/+jywrXZljqJnK5lwCaaNyW/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792977; c=relaxed/simple;
	bh=8Q3JHq8kBECffJY5+xzgbRqScbnI3KYakr7TC9C8MRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgPejlOAEFtOdewrR4+8LmgU/UDL9LoCHz6GK2KP7+8G21LFxnTvWYGCdrwQVBss4bZnX56JOvzg/jrig52SRWv4CF9HWJUbLCYkguJrufeiVRvcuTCHdx2JflI9VbKpBt2cfRZw5Syv8LKcDBg3u/SATyCVOFVO7Y1jEaMam1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2B4TkkgL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2B4TkkgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87701F00898;
	Wed, 30 Sep 2026 18:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792976;
	bh=VhgRTVSUiWf8827GKdDNpAxit9RQgVwxrQiHatsGpjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2B4TkkgLT+rV7L2ucgjPWFNX89luWORbrYjykX81Kmapk3G+Ufl16maClY2WtmO+Y
	 3GhwDSmcpH2ovwnT/gsM+b01DokKjBcShFiaT0zW7FuqThxLzcU+hVPQB4QrNVCC6+
	 TY2/cnX+ANFRaCAZmwXCBK0kNfQGivc1p+yKcCXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/395] drm/virtio: fix object leaks in virtio_gpu_resource_create_blob_ioctl()
Date: Wed, 30 Sep 2026 17:25:55 +0200
Message-ID: <20260930152342.653096942@linuxfoundation.org>
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
index 2d5cd7fb70e22..bb3f8ebcf4dc1 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -546,14 +546,14 @@ static int virtio_gpu_resource_create_blob_ioctl(struct drm_device *dev,
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



