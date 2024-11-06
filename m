Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5721E0DB1;
	Wed,  6 Nov 2024 13:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898624; cv=none; b=b0psWZZIiisSFp9iJe/YN4D3RU1dOuW11FRNJlDSfcopt+76God4xYfSkfK+RWfXlkxZhREh5PCTdcFZ5M4vN/0fxde7vi6MlrNY1KzoXlk5her6VaLW3LJIX1OQVaGMLhS5QZNO1LW8pEI9RBqLT6YGj0sGtknhChgCb/3sIxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898624; c=relaxed/simple;
	bh=YD26CNvXMIm9ODsxDr7auAmdfDoTWnZHkOu2bEGgC6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfUCnxLn2gVTuYirp/QRLmkYokelUnwoUquGeB/5lwnTOdTAsHHOvA9XF/FKPLAS1lu+ySkONzdGIKsxQS1BUeaXraoQtmGAqiOPbm3U300QgnuzI8NOfdTq9H1Oh+DOiC0XWd+ozExW5/tJeioCEE5aC9uVX40xFDhvZOpHTec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+nv8VYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+nv8VYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261FBC4CECD;
	Wed,  6 Nov 2024 13:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898624;
	bh=YD26CNvXMIm9ODsxDr7auAmdfDoTWnZHkOu2bEGgC6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+nv8VYz9FaTzRSzLFRCK38SvP2FSfLfmRElZ93OUB/Wuwm2URIqQgBeypl4VPPhF
	 hT/UN+CtmRq5JXVenLB3EGSgqynLhrQYkXkesQQJmWzcoE7HgXPDykPKA4z0DDYfVC
	 s0bKgbsxy6al4TVLCPQkCy0hgwDwQUaBD5hlqqYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 299/462] drm/crtc: fix uninitialized variable use even harder
Date: Wed,  6 Nov 2024 13:03:12 +0100
Message-ID: <20241106120338.914445910@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 85d85a0ba85f9..da45cfd2939cf 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -727,6 +727,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	connector_set = NULL;
 	fb = NULL;
 	mode = NULL;
+	num_connectors = 0;
 
 	DRM_MODESET_LOCK_ALL_END(ctx, ret);
 	mutex_unlock(&crtc->dev->mode_config.mutex);
-- 
2.43.0



