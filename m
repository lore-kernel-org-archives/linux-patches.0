Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099BC51AEEE;
	Wed, 30 Sep 2026 17:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789137; cv=none; b=XaraPdjGYY8a1DSPgh5OXj/rJcGUh07gwKhg5UiTmOLMXpNlFiQCyM+GlsQf/F3FEWOnz2Y3DgEJr6WFOESrH2xKRteP9VRLbmP4rd2HQWkKPPMCsPVuTAB1MbrEsENaHP4lpy4+0ycQWGTajA5kq841oLwttut4+q0fSOjVQCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789137; c=relaxed/simple;
	bh=jPRXnghLOVhU2EVXpAGKNQomADdgY3wQR+9Rl5pzXC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvUIR+oIea4IqOd3onzJETmvBBS/qPocarMVrlyUDU0qCU9eUCis4/VM+/5rBLJ5eNpCJDrh2MgtNWGZSCEvfagFpvus96RuFKNMvDwVjmNFrNu8wOa2YatHGf6ms2x3FdkYyjVgWGz1qfTUemQ0jtJm56+8s/9fjC6DtDaRqpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDZGQIaC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDZGQIaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F561F000FF;
	Wed, 30 Sep 2026 17:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789135;
	bh=uZ0oWDaHeaS/XDSGndiujK4l7Ph835flDxbxoWuMm+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDZGQIaCSvcWgWEe63hd2uziN/qRzrWePTE23yKgbQLhILWM7j6QPKLjtGhJuKsn6
	 xndD7XEhQpz91hEkQWk2L1OSe9JMb+AZuW5m0/R7GO8hmoAfPRzFlZApwO8iOPUGuB
	 4fyYkR34rOQ+VX4KY8JhirWKM4UNhLP/Ru4cvp0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 371/877] drm/virtio: fix object leaks in virtio_gpu_resource_create_blob_ioctl()
Date: Wed, 30 Sep 2026 17:21:22 +0200
Message-ID: <20260930152422.682571679@linuxfoundation.org>
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
index 60e5146ddefec..d8aec5112b326 100644
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



