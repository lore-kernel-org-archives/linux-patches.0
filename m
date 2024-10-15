Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F06D3399F;
	Tue, 15 Oct 2024 13:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998400; cv=none; b=DO/Ym1MdS8NDRc9yZvQwyL5AWICCt6Dy57g5m3RqC/8O+WxHXgJL4VboPSNc7vRDbnAaWLT7pg5xaUURwpsFvqqDawimKaParIwcSJ4nmNhD6Kz6G3fpAAc2tPIzztl9gJVWs+ic3FgTOfTfIi7Aqp14ZD8cVYu7I+HIElONPkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998400; c=relaxed/simple;
	bh=TlyN+Fth75uGtkA6ob/ZnH86f3Y56k3XF2eh0MRv5Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIQKOs9e1baG4kB2prUq/0aYTabxl3Bc55CucwQISLWb215Ye1o/i5Zzopw2sxh+gOkXZWSASUqILNPQYis4Metg7d5pHheGhf6N/ISbW10s5/F85cFsNybRXOnJzZ7wLgQzt51JGxX3Eo1wTxe79XW1+Cce1C7SnA0qM043/CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkBO6tze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkBO6tze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0810BC4CEC6;
	Tue, 15 Oct 2024 13:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998400;
	bh=TlyN+Fth75uGtkA6ob/ZnH86f3Y56k3XF2eh0MRv5Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YkBO6tzeEmErAciyT6uPaT3qaQNNlnjbkGV12RXWH5U/dR675nU8LILpOplSik8yk
	 QyoemNqY1+Isey7nfc/0L6N+wIxEgDsvgCrbbQt3u6U/QirACVvCCJx1bL65kMEoIy
	 7b4elWtEVsH0KKgW33SX21G4c6HTQQTOyYj9T09k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 439/518] drm/crtc: fix uninitialized variable use even harder
Date: Tue, 15 Oct 2024 14:45:43 +0200
Message-ID: <20241015123933.949212086@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4ed3fc28d4dab..5d2cbff02df12 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -754,6 +754,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	connector_set = NULL;
 	fb = NULL;
 	mode = NULL;
+	num_connectors = 0;
 
 	DRM_MODESET_LOCK_ALL_END(dev, ctx, ret);
 
-- 
2.43.0



