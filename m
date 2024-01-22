Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467E912BF3D;
	Tue, 23 Jan 2024 00:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968954; cv=none; b=Sscjm5yXwXxgxVEYnnsgIBRx/aoNfV3glUu/nduCk8c5pky4Nt9sTS3B15MCNQzMyQLF4rzFj6e+YDwL39CcukZQhcQdOcr5Nk6a5eX6jSyRN648OCTHS0ZAc0mFZYPR51ov9uJadQxXpJ/Muv3KNtWhJiCI6laRxuvb8voI6sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968954; c=relaxed/simple;
	bh=Iji4IUNsfvdBLTX6JX77wPG6hDs2B2FxWEz2i6Cuq0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRinB4TaVMPRqkjeA23Z85iRiIWHX1G4Re5akSTPgFBSzbFDQbPfWtfk8U2OapTCdyy11v3eTFy1+3W3gPxuKHnJdUGwPfoo52ujh1xmlZDorfXKu65Nf8IoVJB0n6/s8XQqJKmi3CXGV/lBB1uoHaVeq6yckZL4Z0S96kTSthA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqoOrtup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqoOrtup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D773AC43390;
	Tue, 23 Jan 2024 00:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968954;
	bh=Iji4IUNsfvdBLTX6JX77wPG6hDs2B2FxWEz2i6Cuq0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqoOrtupgjafF7JuxyHtztGU/h+V8/3uvWNaLziMYg08IrFTBCFkbuUOT16GpvaU6
	 X1BV3dhBYVr3OR4aQgy8cSDYkFmsSv6wxvx6r2TUlxdDHT/pU1DxWxPf/kHneIVGK9
	 Uy9rH3JHzeV+LlzETWFfrr4LB9Qh52TLSZl1qNGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/194] drm/drv: propagate errors from drm_modeset_register_all()
Date: Mon, 22 Jan 2024 15:57:30 -0800
Message-ID: <20240122235724.372404284@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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
index 769feefeeeef..c9529a808b8e 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -984,8 +984,11 @@ int drm_dev_register(struct drm_device *dev, unsigned long flags)
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
 
@@ -997,6 +1000,9 @@ int drm_dev_register(struct drm_device *dev, unsigned long flags)
 
 	goto out_unlock;
 
+err_unload:
+	if (dev->driver->unload)
+		dev->driver->unload(dev);
 err_minors:
 	remove_compat_control_link(dev);
 	drm_minor_unregister(dev, DRM_MINOR_PRIMARY);
-- 
2.43.0



