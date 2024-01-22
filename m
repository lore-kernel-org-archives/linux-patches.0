Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EFB42A8D;
	Tue, 23 Jan 2024 00:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968454; cv=none; b=G2ngHrPiW+DPxQs+cJbC12Iy3fLnlmvg7SvjKsOlvvbVJfVOu0LOpdygUKi8JBPjtdn9luMYbpWxls+9AvQKNDKQbuN1ro6DoYTeZEqP3Ee3MNTSNPt/rRsm1XRQ3MdXI8Xrog5EmKZtm3MB0ThzFZkaH1QTLVdWZD6dsFjy0+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968454; c=relaxed/simple;
	bh=ImMqXOAmep9+3UdKkatyqWnuoDoeCYTHgGatAH5o5BU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJdj6jHBcjE6c3ZLWDrSbJCfXrO8jQDd1Y1DdoBvf/s8RQ2O3QyYbWKrbL104x6MYnGGd8p9nsCzaoJk0fnGLfd12BMftaZNpLnBiNKbBrS/QtQXU6vxWnI/J2EqVvfLGoCZLCDCwitwaMsWa7Uvt7uV4zVRU0CpOjrtak5GwFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZZeOKAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZZeOKAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DCBC43390;
	Tue, 23 Jan 2024 00:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968454;
	bh=ImMqXOAmep9+3UdKkatyqWnuoDoeCYTHgGatAH5o5BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZZeOKAYjfr7qJRcv6hAGD65K6Um31aibhvpK7OJLnofRN/DP9cQ215xZKN2Gj214
	 BpVVlxlOJ6ovHLNsixZG+ZVNd/oWF3OYfa52pi6+cM/6Zx6X2slwWqOophK//jSV23
	 NseXaGRpaETRbD/Y5M6Th48HfQEKdzNC0E9TCLHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 096/148] drm/drv: propagate errors from drm_modeset_register_all()
Date: Mon, 22 Jan 2024 15:57:32 -0800
Message-ID: <20240122235716.270624063@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 5f8dec200923a76dc57187965fd59c1136f5d085 ]

In case the drm_modeset_register_all() function fails, its error code
will be ignored. Instead make the drm_dev_register() bail out in case of
such an error.

Fixes: 79190ea2658a ("drm: Add callbacks for late registering")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231202225552.1283638-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_drv.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index d8ae4ca129c7..e0c54de615fd 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -818,8 +818,11 @@ int drm_dev_register(struct drm_device *dev, unsigned long flags)
 			goto err_minors;
 	}
 
-	if (drm_core_check_feature(dev, DRIVER_MODESET))
-		drm_modeset_register_all(dev);
+	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
+		ret = drm_modeset_register_all(dev);
+		if (ret)
+			goto err_unload;
+	}
 
 	ret = 0;
 
@@ -831,6 +834,9 @@ int drm_dev_register(struct drm_device *dev, unsigned long flags)
 
 	goto out_unlock;
 
+err_unload:
+	if (dev->driver->unload)
+		dev->driver->unload(dev);
 err_minors:
 	remove_compat_control_link(dev);
 	drm_minor_unregister(dev, DRM_MINOR_PRIMARY);
-- 
2.43.0



