Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBD433D6FD;
	Wed, 30 Sep 2026 16:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785841; cv=none; b=aXcFrTDXnjz+1lNnES3hzyFVh9ZVANN1BpUqc4nhg54kxmL10+bBpZGUYbZwRRk8EZSiG3v6EpLtIqe/V2bqrFqKyKBiIzF3yzauVqdCuzMPN5w1lJ0mt9Mf9QtcLDSu4TeB6T8ao3MtH3Y2/moMG0bAus7dcRmPSZW4h3JpzG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785841; c=relaxed/simple;
	bh=9LDoYwvmqtsydaEj5JNjfYRmp/FXOK9xPZtjY+JEOVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaZLNDFL8sAP51fVE3rrg8v5p1n9EW0ypBYFKuUNqMsldFujQB7TFkwuBLo97kpL8CZ4wMjYl9zQys3dAMTFcCQ+JaqVc85UIYSlK88xFWnbKiKPj1piWSPnOaJ4IJq0gzJ/WnoqdkhVCGNLDzUg0R63XJ7r0Xxd5FrmK2nCZAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLRNtTgR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLRNtTgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8241F00893;
	Wed, 30 Sep 2026 16:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785838;
	bh=8c0LMurmWjp/bMDFJi9fZdGlR9ndBXn/fS/gJMZcjDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLRNtTgRrGN7tBdTDbPYvxFy+W/sbNoloLuVIvIdXDHRgdqeclOf+arXnKdzfDkIz
	 CsuZP6vgWf3/hZgl5nyXUjolgagC0K1WSMmxpzJWcjcfuU6/B0b0VvOMflv2KcQO1F
	 LD5Oc5Y7xwD05OoVqvJ9DMDF0X+s5PsxClDipyXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Melissa Wen <mwen@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 651/982] drm: Fix drm_pending_vblank_event leak in error path for out_fence_ptr
Date: Wed, 30 Sep 2026 17:23:07 +0200
Message-ID: <20260930152430.748903522@linuxfoundation.org>
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
index 38f94b7543a70..c2e0c6dab99db 100644
--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -1159,10 +1159,12 @@ static int prepare_signaling(struct drm_device *dev,
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
 
@@ -1171,12 +1173,12 @@ static int prepare_signaling(struct drm_device *dev,
 
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
@@ -1230,6 +1232,11 @@ static int prepare_signaling(struct drm_device *dev,
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



