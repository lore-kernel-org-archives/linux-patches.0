Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B314052B7;
	Wed, 30 Sep 2026 19:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796725; cv=none; b=tcQapEcRe/0WBj6w+bI3HzlaJp+ZImxFLNfEZuoFK+a2BAH8YgmCVkWU+rmv/Lp0kWWRsPwXq7YR2pV4XdbuShRcakgVBd2v1pb+uB3jiZoez05pYfoo22crDTzoAoJc/nnf1VOnEz02JisEIN6I7DU26u99d6d1qBYN+6sClEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796725; c=relaxed/simple;
	bh=atnJ5vfanRr/P9c/GYIGwKwoJptyb6iUzIHgyuUopLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kn2n50/cRq6W1goa8J7lpQYqWc/XmiCa5QW5vYlQzLsN6YcTN/Mjq1PHZHzY0fd64cBqOnRG3LQgp2U2DgM9undDI9YBO084eBsWvJ1EfahtUtVMcGEg1vemggevcPagLROwQTI9qW990BbxUH502X8f3IrKELpL04C3njdTQ+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCB2NsQR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCB2NsQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3EB1F000FF;
	Wed, 30 Sep 2026 19:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796723;
	bh=SraS302gUclHCuAp9I+NJHp7yjmO45+OFtWj+sboUjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCB2NsQRRAMguUVZs4yq3O6LQwGolyF3wE0nDbFfL4IaegCS4QKEs+Q3mqdldUGyF
	 XdwzatoHMtAbZYMHEYw6Pvljvkdj1lzvDhO22PVjXHKLjlZUTM48cGbK14ovb7UJOx
	 C4cravc/W8RDUYbL+5716YPxk6htheDdR+mSoBLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1015/1193] drm/virtio: fix object leaks in virtio_gpu_resource_create_blob_ioctl()
Date: Wed, 30 Sep 2026 17:28:19 +0200
Message-ID: <20260930152456.794273621@linuxfoundation.org>
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
index 55b9076287601..ce7e310a61fc0 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -536,14 +536,14 @@ static int virtio_gpu_resource_create_blob_ioctl(struct drm_device *dev,
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



