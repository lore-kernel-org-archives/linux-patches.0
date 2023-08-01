Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730FF1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8BBC433C8;
	Tue,  1 Aug 2023 09:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883149;
	bh=jwfB92qjYPQYhwAGu4V09nVlFbDk+S5HKLIPKs935BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ag/zlnI484Tm6QIQuVNlp+V1U73VI0tDaIzRanPaEmfS8ZaqQql8p1lUGBxUkNXlD
	 CGzty9zFViXjvsaz9gFbAf+ByIguO8r6SpbOi1Rh4Fk7h99BAEpUVfAZ6W5NZgqEiB
	 7bKy0do7n55d/yuljWfJBmkt//Bs6kt2klTqbsQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 133/239] drm/msm: Disallow submit with fence id 0
Date: Tue,  1 Aug 2023 11:19:57 +0200
Message-ID: <20230801091930.501352244@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 1b5d0ddcb34a605835051ae2950d5cfed0373dd8 ]

A fence id of zero is expected to be invalid, and is not removed from
the fence_idr table.  If userspace is requesting to specify the fence
id with the FENCE_SN_IN flag, we need to reject a zero fence id value.

Fixes: 17154addc5c1 ("drm/msm: Add MSM_SUBMIT_FENCE_SN_IN")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/549180/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 10cad7b99bac8..1bd78041b4d0d 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -902,7 +902,7 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 	 * after the job is armed
 	 */
 	if ((args->flags & MSM_SUBMIT_FENCE_SN_IN) &&
-			idr_find(&queue->fence_idr, args->fence)) {
+			(!args->fence || idr_find(&queue->fence_idr, args->fence))) {
 		spin_unlock(&queue->idr_lock);
 		idr_preload_end();
 		ret = -EINVAL;
-- 
2.40.1



