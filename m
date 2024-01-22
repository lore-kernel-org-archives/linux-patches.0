Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F8E12DD8D;
	Tue, 23 Jan 2024 00:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971487; cv=none; b=DEj6Hb4vLHWEOYBFJwnngEybt4RVGzF6n1MHuLHXeBm3tFCqzZeCSSPI8wSlbiKUi51R7Lh7JELjbGuv9QphTA2o5L3SMetHvGOPZYmLkGoNXazQKmbLwEwHu/4W3qzS4QIFgc4+miRpL0y15gxP7PoWROHOh+RdRe9yojlpNmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971487; c=relaxed/simple;
	bh=GxFNJzwfkajCDi+mjtSwtqhTzXvwbCDHPoR02bHF4CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNb8AhI8D5sj3em8EuQcey6p3lbHABOMlwNfWas+zoLc/gyt0H3K6ZjrKClf8029TQ5XbWUsopaqwNMv8cylJmx3It6zurom26m7c+mVbrMBKU4mk+OUQwaTNBJ3Xu2DiPknBKNy9bKIEUFq2AmjxU4IoRYuIcUArE7fPHbaAQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZRFhGPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZRFhGPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4F3C43390;
	Tue, 23 Jan 2024 00:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971486;
	bh=GxFNJzwfkajCDi+mjtSwtqhTzXvwbCDHPoR02bHF4CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZRFhGPkDCG2WA74tDrdDcoMBVco28HsLJZ38BtAQRnw21asy6BfjovQ3Qia1NBjG
	 LSKp3NHD7YkfKLLtBVZTzmUC8w42RLlbhSZ7r1+LD3MoosEA5t5zrtAnT9rRTaToYT
	 mrULbCmemQU7BzTx7851mz4jM4T+yrWRDHqlloYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/286] drm/drv: propagate errors from drm_modeset_register_all()
Date: Mon, 22 Jan 2024 15:57:45 -0800
Message-ID: <20240122235738.293737963@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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
index 4ca995ce19af..10831d8d7148 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -892,8 +892,11 @@ int drm_dev_register(struct drm_device *dev, unsigned long flags)
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
 
@@ -905,6 +908,9 @@ int drm_dev_register(struct drm_device *dev, unsigned long flags)
 
 	goto out_unlock;
 
+err_unload:
+	if (dev->driver->unload)
+		dev->driver->unload(dev);
 err_minors:
 	remove_compat_control_link(dev);
 	drm_minor_unregister(dev, DRM_MINOR_PRIMARY);
-- 
2.43.0



