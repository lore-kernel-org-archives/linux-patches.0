Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10F6259C9F;
	Thu, 17 Apr 2025 17:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912528; cv=none; b=oFy9+cofvFwvc7NxG+t1q6WnUz7qDu6bFPN3U/tgnStXBdN6MpzppY87om5s/ySlPcLOSJaVbldZ9bLZoqFj9I+ieEfgfeHLk/UEqYxO4KdhH3NYpjHEsRZXH2tAk1jC3rJ6kBaJ3R1Hpur8KhPDWaQOy1mdwEpPDgZa9B94uFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912528; c=relaxed/simple;
	bh=Pxevej0T/R7yEIfdsQv2pxeaDm6zhXz/YTuWYcjz9Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6CnV0IcXC8SkVGUxPD5Tj9f9piJ0uL9YB+GBZuWit1RVPsTMM0ZdMzxbhWYsuITr7du6m8Ck1oZxtoZhdpEqZQ3CTgIaMMOM78XyIX4QjhcN5msyqFsKr0jQPTqjb8XZqk4GdHRKpt7XY5vIxzZp9yTmrNJq5lq+8ogdO9byLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xp6q7KjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xp6q7KjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CA5C4CEE4;
	Thu, 17 Apr 2025 17:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912527;
	bh=Pxevej0T/R7yEIfdsQv2pxeaDm6zhXz/YTuWYcjz9Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xp6q7KjRG67rHoVDXFi0bvipkwjzJeap+hiF50fr+FA8NBbmqDmXWrzAEXxVzVRIx
	 NIr62OD2lrJKZaAIM/Y9SD7wLNjrXUaeLNcCgbq0acrZWjzD+oMVPrPxGCUFBWE9gt
	 DLZf007rEozqrDkMrTk0B2e+OCtNDc3kwLbse2+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 009/449] drm/virtio: Fix flickering issue seen with imported dmabufs
Date: Thu, 17 Apr 2025 19:44:57 +0200
Message-ID: <20250417175118.359112644@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Vivek Kasireddy <vivek.kasireddy@intel.com>

[ Upstream commit 3d50e61a17b642af060566acb0eabe3c0eb3ef1f ]

We need to save the reservation object pointer associated with the
imported dmabuf in the newly created GEM object to allow
drm_gem_plane_helper_prepare_fb() to extract the exclusive fence
from it and attach it to the plane state during prepare phase.
This is needed to ensure that drm_atomic_helper_wait_for_fences()
correctly waits for the relevant fences (move, etc) associated with
the reservation object, thereby implementing proper synchronization.

Otherwise, artifacts or slight flickering can be seen when apps
are dragged across the screen when running Gnome (Wayland). This
problem is mostly seen with dGPUs in the case where the FBs are
allocated in VRAM but need to be migrated to System RAM as they
are shared with virtio-gpu.

Fixes: ca77f27a2665 ("drm/virtio: Import prime buffers from other devices as guest blobs")
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Cc: Gurchetan Singh <gurchetansingh@chromium.org>
Cc: Chia-I Wu <olvaffe@gmail.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
[dmitry.osipenko@collabora.com: Moved assignment before object_init()]
Link: https://patchwork.freedesktop.org/patch/msgid/20250325201021.1315080-1-vivek.kasireddy@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_prime.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/virtio/virtgpu_prime.c b/drivers/gpu/drm/virtio/virtgpu_prime.c
index f92133a01195a..d28d1c45a703b 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -319,6 +319,7 @@ struct drm_gem_object *virtgpu_gem_prime_import(struct drm_device *dev,
 		return ERR_PTR(-ENOMEM);
 
 	obj = &bo->base.base;
+	obj->resv = buf->resv;
 	obj->funcs = &virtgpu_gem_dma_buf_funcs;
 	drm_gem_private_object_init(dev, obj, buf->size);
 
-- 
2.39.5



