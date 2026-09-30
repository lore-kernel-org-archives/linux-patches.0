Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7293BBFDD;
	Wed, 30 Sep 2026 19:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796059; cv=none; b=LhNvBts0QJmO4WPRWOGtqXo8Or2SbC+hcrw5FrmvHn+yjzaAgVXKYnS+l3qSljUUX0G2VRVYLtmy+G6BgxMV4m2oFtfl/lArA8hhFtgqo6/ue4eW2K/TD5ErNrmlhqlOUP6cEe+FxH5Eme4GEVOe983T7qm+wp9ujLEC5Hbk5aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796059; c=relaxed/simple;
	bh=2L1rZYvDaq4uFoWCkNUx+DbOWKbjH1OelUAzxEH7yxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuDo+N82VG2GwWjLWE3Jb1xgHjAYt1DebJWYYGa5u/Jq+rLj44UsfMO3mVw7uyLRUPusWdpRgBsHrnM9slcHR41CRKHmWSA5X2kIrcnGgymboJZu6DYoIdMWvNsBPl+r8zs++lzQ3XcPP5nmSqooGtegKxuXv6K7VT7zdhG6vuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKfO7SbZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKfO7SbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096131F000FF;
	Wed, 30 Sep 2026 19:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796057;
	bh=58YYnFbC5EGelZbfYX5ho/paVBz6Bhziz+QB6wpfHmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKfO7SbZUVNpWpqRXW4w72y6sCoE9xYLaI6MfVQOLyITHsxqEkELF1R1Fm4+fx3FS
	 o+TKx83I6lYdffLE8UcPDxpFyMQmkm5rAKp4OnBufLHJaiJNrldO6su5ePM86bNuyY
	 3ZJ0z7DMW9kL8OdmcaEShylhZlWwk979+F0jryfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Melissa Wen <mwen@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0779/1193] drm: Fix drm_pending_vblank_event leak in error path for out_fence_ptr
Date: Wed, 30 Sep 2026 17:24:23 +0200
Message-ID: <20260930152451.560227269@linuxfoundation.org>
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
index edf34aaec2434..7393a1885e2cc 100644
--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -1202,10 +1202,12 @@ static int prepare_signaling(struct drm_device *dev,
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
 
@@ -1214,12 +1216,12 @@ static int prepare_signaling(struct drm_device *dev,
 
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
@@ -1275,6 +1277,11 @@ static int prepare_signaling(struct drm_device *dev,
 	}
 
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



