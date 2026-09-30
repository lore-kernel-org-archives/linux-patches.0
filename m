Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419D04CA784;
	Wed, 30 Sep 2026 16:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787225; cv=none; b=mc4bpFojwZTu9gto6iENGvUg2kldfRZ50cU+/HbfY3/kH4wyxpDCPsp1SxlgSVqryUU2ExFHhYdAEuaF3rtpEhBrfBxD7oIj297CAh3bQOqVM8INq8oZP+TXhDnUZzjueRkgWR6fY3ttmOGTOcLVH6jYdE19TqPTWu6Qr5to344=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787225; c=relaxed/simple;
	bh=T2bEzJWCi2ZN4KgCmfs7gK81lVPzX4wilGmaihTAad0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DiMcFNDvbSdscRXK1DCO1JAFtstV5I3c1kfDSe0Vix9eOxedwV++s5SxzPPO6ym4wMdu1A+uit14p/FK7amXa0Z5q6Der3lIoJ8uucwryzhwrbTr5MRtANAxA8+JK2RZgZDxLAeTAC6jVCchx6T9YO01iiW/feTa74SJCOJJ0sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnWbHMU8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnWbHMU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9941F00898;
	Wed, 30 Sep 2026 16:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787223;
	bh=s41pItIGk4clNWaWN6sOKWeCs5OT2TtDKAT0rfiRvX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EnWbHMU8qUyCqPkNpQRelRpKA5K4uI/mkr5WJ10jxixgaYMXCbCrdwS1NsdiuPeRF
	 4k9sV8N4XxnL9xKKh/DnVCztyz4mJrmEJxmKDjvASYSy4cYM5BDosFXdajxHiGV9+N
	 leF3mYUERsZ1I+uQV+Xcp940cWHc0LJ0nmaHVB94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 110/457] drm/virtio: fix object leaks in virtio_gpu_resource_create_blob_ioctl()
Date: Wed, 30 Sep 2026 17:23:35 +0200
Message-ID: <20260930152348.427943398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d16f07abb266a..fcdb07a37972c 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -557,14 +557,14 @@ static int virtio_gpu_resource_create_blob_ioctl(struct drm_device *dev,
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



