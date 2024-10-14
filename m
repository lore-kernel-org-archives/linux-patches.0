Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194671C304F;
	Mon, 14 Oct 2024 15:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919763; cv=none; b=A13QYhGz4W7z21UtdAEM7sH/DiPAhLNbMgzqUB4NHKebBaMNw+kw6tFaKxDVa+fUG5Kniq1cbxdJzWwNznX4jFN1MZeP8dhK7YyBXoO1Lw7ufW5kI+j2rzc94OAaOWNKK1O6ADaAWaP9tVeLvdvUNeBe68wcvUhyNA0t31rGigI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919763; c=relaxed/simple;
	bh=eVi0j1tS2ibpH5Yonu64a8iVde4QE4o3XLWD97kreUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxw2S6Bm8Qn7CXgaBZ5BA6DBXtYjf9H/yGBRtVWCAkh9q3g09jx9drHZbeXZ8AkN9vGUu3eOUSZe2ZRrxkqh3yDUvtgKPd26/bazdD+zMduboUmnl9Yy1dTr6HTXFGzi5JF+AmdYR0ji9RY1ekOCy5JvvBsxEZ6vZt7utbDceEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQN9AVDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQN9AVDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0AEC4CEC7;
	Mon, 14 Oct 2024 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919762;
	bh=eVi0j1tS2ibpH5Yonu64a8iVde4QE4o3XLWD97kreUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQN9AVDsJ2O1C11MhshXr/VYEkllrur+349sL9F9rerrm3+Cc/hSd45gBwioAQ02v
	 Wg5VVxfdxiWAwBKPRQRzgN0PpO4dObUAVw5EjvR8d6yAeR+5DTpTOh0A5UFtoiVGff
	 OjCs1kXLSO78fyNycG3LSEj3wyu2L9pH+Ql9Hg9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 669/798] drm/crtc: fix uninitialized variable use even harder
Date: Mon, 14 Oct 2024 16:20:23 +0200
Message-ID: <20241014141244.346875701@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit b6802b61a9d0e99dcfa6fff7c50db7c48a9623d3 ]

DRM_MODESET_LOCK_ALL_BEGIN() has a hidden trap-door (aka retry loop),
which means we can't rely too much on variable initializers.

Fixes: 6e455f5dcdd1 ("drm/crtc: fix uninitialized variable use")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org> # sc7180, sdm845
Link: https://patchwork.freedesktop.org/patch/msgid/20240212215534.190682-1-robdclark@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_crtc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index cb90e70d85e86..65f9f66933bba 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -904,6 +904,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	connector_set = NULL;
 	fb = NULL;
 	mode = NULL;
+	num_connectors = 0;
 
 	DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
 
-- 
2.43.0



