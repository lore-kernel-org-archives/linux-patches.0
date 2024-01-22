Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DC422062;
	Tue, 23 Jan 2024 00:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971114; cv=none; b=DogfXswew8xmFtRnTqNg8ymWXi5T459bzlq1OZA5m9m6NZ3WrnZg7JGkaVjfzyO8LWsxGQKvCw8SvZuCNtNN1VEVa2jV1K6jOIXjY4ENUdqYXN0uAkEuyfD4BAKHQqbEvgOlMoxH1oABNZ4ff4rAE7F45czxwIxAXFAZYB1W3Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971114; c=relaxed/simple;
	bh=9nmvXxSNLbLQUrwHm3s0TtMZBVk0MWRj4B1P69QUT/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYiCF+D6Q3R165fv319iR9LqWqjEI4+Yr4EJH+kCLZObsW/fTigTIxDSh2W1jfvLqNkwM21+mN8nf1j/yWve2B/OSVC+gcpJ5iIKNwlZAeefn8fUdSFUk8QLG2O1vQeey4z4IQmPhC9fRyJ6RY+F44MdzyORyl+Xkk2iA0v1Ry8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnrodDOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnrodDOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E45C43390;
	Tue, 23 Jan 2024 00:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971114;
	bh=9nmvXxSNLbLQUrwHm3s0TtMZBVk0MWRj4B1P69QUT/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnrodDOC3MMoh+sfkp9KHaI4gIrZMaDWQfDBmDspQ7rqjLJVtKzHAGXVvxVXB3rCE
	 QSMNDfURNzVz29Z4mGhoJPG974w474IingEcU9lIQ34wrn8z6FnYAHly8WYZQQV3GF
	 51tla/KAo/fTYxlDxvz/d47pZNzgHAj4JqUdN6zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 183/417] drm/drv: propagate errors from drm_modeset_register_all()
Date: Mon, 22 Jan 2024 15:55:51 -0800
Message-ID: <20240122235758.209203769@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index 203bf8d6c34c..d41a5eaa3e89 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -895,8 +895,11 @@ int drm_dev_register(struct drm_device *dev, unsigned long flags)
 			goto err_minors;
 	}
 
-	if (drm_core_check_feature(dev, DRIVER_MODESET))
-		drm_modeset_register_all(dev);
+	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
+		ret = drm_modeset_register_all(dev);
+		if (ret)
+			goto err_unload;
+	}
 
 	DRM_INFO("Initialized %s %d.%d.%d %s for %s on minor %d\n",
 		 driver->name, driver->major, driver->minor,
@@ -906,6 +909,9 @@ int drm_dev_register(struct drm_device *dev, unsigned long flags)
 
 	goto out_unlock;
 
+err_unload:
+	if (dev->driver->unload)
+		dev->driver->unload(dev);
 err_minors:
 	remove_compat_control_link(dev);
 	drm_minor_unregister(dev, DRM_MINOR_PRIMARY);
-- 
2.43.0



