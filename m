Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515BB1DF26B;
	Wed,  6 Nov 2024 12:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895477; cv=none; b=jxM2tXCjw2lfgvbvAvdzWOugWZt/CFuwLEdmQpDKIDsPIyNMbPwtThmDd5Qs22QPyo4rAgTSvkAlGoFVK+jQn6J8TNurKN7JJ/Wt49ujlEkYYMINZWDnlsiom2NDonirw2PgVZRNF4+7zsJYzmccKmumF0bfUz1F/r7EDTT+xFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895477; c=relaxed/simple;
	bh=J21+04kNg4B3WbNB25/F7+yhlOlfE3bqIuRkSdXPpIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAs0g8BkP/bhIROBloYqfAybuTjjOFRWzVRs+pjLLGn56qzrtcdkuPyuGlLyZ+vgAEn2qB0xdpyFV0TFfGAapxmXYz0egnWSYVr92FnTlSv7UV59XcpihYIByxruCxr9pYGMOXcSCElosplC1YPn+VhNwpbHJnYd8k/lt/yxUrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUz2qGUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUz2qGUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE8FC4CECD;
	Wed,  6 Nov 2024 12:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895477;
	bh=J21+04kNg4B3WbNB25/F7+yhlOlfE3bqIuRkSdXPpIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUz2qGUEL9aLFyA6MyjgYP0qbR/myaHl0nhFUiO280sTNnafvXkVIK5SV2DE/oeO8
	 7fN+Im66/yCmfN//DN5mC3kqCQpdt5JDf+Qn9rzlVYV96DJ5rYc+7THFtlO4hWN153
	 Fo+o+Ik9FWl+8ajo/qmL355oV3L+/wr0dLh7Sw50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 231/350] drm/crtc: fix uninitialized variable use even harder
Date: Wed,  6 Nov 2024 13:02:39 +0100
Message-ID: <20241106120326.680362912@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 82ad38ee3fea7..e8d5fc8408c59 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -768,6 +768,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	connector_set = NULL;
 	fb = NULL;
 	mode = NULL;
+	num_connectors = 0;
 
 	if (ret == -EDEADLK) {
 		ret = drm_modeset_backoff(&ctx);
-- 
2.43.0



