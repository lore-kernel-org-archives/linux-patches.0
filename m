Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7ABE4E1C7E;
	Wed, 30 Sep 2026 15:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783432; cv=none; b=Iyq6QQUJ+sLkk8gxryN+l3CRx7chbRX6fRMCrozIXEUw1q/9hIi6RRcV8MjjwNIgr4J8982+de7ld/UnzRkpwJgOaQX3fOQzAAbWWm4CBivceNHkbcrjUu6Jhs4w4oa9FDa228tK6iPJVBmM0C35vl9HOb+Kz9gRCgqBlSamUTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783432; c=relaxed/simple;
	bh=PbxtwgYUQq/SbJW8/uOn0vYCRgGD01Il5eNvwXPy13c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+AFDVa/nbIoM2yVKtP3VXGl0qDj26t2X6vOqMxvwCBlJyRNaR2YXD9RY/DPJIPz3GKhE7tloRS55A2ADcjid1JtpIo1LSWVBfjcu8R/cxI3YECru6k8uEUVXz5lPuPHt2mYdBwuc4qBBjt/JZQhRGPcQp497Kg/HI7XnS2pK8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vj9N2LGl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vj9N2LGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C895E1F00893;
	Wed, 30 Sep 2026 15:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783424;
	bh=EQNb/37nyIWGl9DRGbJJd3HTdPCyK65gD701bP/E71Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vj9N2LGlXlZ12PlxbD1Ka/cpRm7ddyg6rpMgW2hxbhkgErChdx2KAdYV1YCkzHczj
	 LyChMRTcG2l2RYar2IefxqnhQlY4oPMwAaezQkmjZr4kFLjeYG+7D7fYBL7ck1dKT+
	 OI/Yxk5gEVV1IeNzKbSUp7Wgo6GBxUP9UkpXxAyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Melissa Wen <mwen@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 392/595] drm: Fix drm_pending_vblank_event leak in error path for out_fence_ptr
Date: Wed, 30 Sep 2026 17:24:45 +0200
Message-ID: <20260930152356.105572466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit 9eb1a393c89a79c4210230d23e7d88d239c61d7b ]

When an out_fence_ptr is provided but DRM_MODE_PAGE_FLIP_EVENT is not
set, a drm_pending_vblank_event will be allocated. If later, there is an
allocation failure or another failure at setup_out_fence(), that event
will not have base.fence set and it will not be released at
complete_signaling().

Release the event and set crtc_state->event to NULL just like in the
DRM_MODE_PAGE_FLIP_EVENT case when there is a failure at
drm_event_reserve_init(). That is, prepare_signaling() releases the
event and there is nothing to be done at complete_signaling(). Use
drm_event_cancel_free() as that will also undo drm_event_reserve_init()
in case it has been called.

Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260727-drm_crtc_atomic_commit_leak-v1-1-23d9948a9d7c@igalia.com?part=1
Fixes: 92c715fca907 ("drm/atomic: Fix double free in drm_atomic_state_default_clear")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Reviewed-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Melissa Wen <mwen@igalia.com>
Link: https://patch.msgid.link/20260826-drm_pending_vblank_event_leak-v4-1-f8de8b996b9d@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_uapi.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic_uapi.c b/drivers/gpu/drm/drm_atomic_uapi.c
index 5873b37f0d26e..f6e3ba4091218 100644
--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -1163,10 +1163,12 @@ static int prepare_signaling(struct drm_device *dev,
 			struct dma_fence *fence;
 			struct drm_out_fence_state *f;
 
+			ret = -ENOMEM;
+
 			f = krealloc(*fence_state, sizeof(**fence_state) *
 				     (*num_fences + 1), GFP_KERNEL);
 			if (!f)
-				return -ENOMEM;
+				goto err_free_event;
 
 			memset(&f[*num_fences], 0, sizeof(*f));
 
@@ -1175,12 +1177,12 @@ static int prepare_signaling(struct drm_device *dev,
 
 			fence = drm_crtc_create_fence(crtc);
 			if (!fence)
-				return -ENOMEM;
+				goto err_free_event;
 
 			ret = setup_out_fence(&f[(*num_fences)++], fence);
 			if (ret) {
 				dma_fence_put(fence);
-				return ret;
+				goto err_free_event;
 			}
 
 			crtc_state->event->base.fence = fence;
@@ -1234,6 +1236,11 @@ static int prepare_signaling(struct drm_device *dev,
 		return -EINVAL;
 
 	return 0;
+
+err_free_event:
+	drm_event_cancel_free(dev, &crtc_state->event->base);
+	crtc_state->event = NULL;
+	return ret;
 }
 
 static void complete_signaling(struct drm_device *dev,
-- 
2.53.0



