Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBCE1F757D;
	Tue,  3 Dec 2024 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239530; cv=none; b=EQqvKaWAWoc3EcHGJafZFfFIxBm/Ww8w2tbmamFduWF2dJ66VRHSHA2mcP/PBwRsStr+rFOSbxWl56cG/guXHBTyKX45wGXPit4rEO8z5yW42ISvKSRiHqFWZ6Eo44kanfg3kdqv/DEQmuJSdr5XIZc0zGK00cjWxpUKchNbWbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239530; c=relaxed/simple;
	bh=tf6OoA5Km87pwR/SGca1DeqmzT7Oit/qui5I//Cno00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFR5nsDXvKgLVugfEwBT+XQZhmz5M7FV7ycT3AaqU2bDLk1NFsPpiwXc0UTaRYlAUY+7phWeQTdqxkkPflLSVcVzmwmxSuJtpVy2j5NKZmOmyEm0Mhn9EleGwHDUuEyjeqXvKlCrb35t7ZpCpi1KiQ42NpFG8JoINZU24gTk2cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwQdcC1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwQdcC1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E435AC4CECF;
	Tue,  3 Dec 2024 15:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239530;
	bh=tf6OoA5Km87pwR/SGca1DeqmzT7Oit/qui5I//Cno00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwQdcC1vJMdwKE1N6tS5IhAn71FGhr12lyUnViwwY8VDgVSSwo39nlSK8FYFEwzwp
	 W9og7qvLVHbO+F56RtyioL+FtUDrUkrnwjMAaWvtYdtztjJftGu4fL66kRMc61YjaH
	 up9Co930Igb9jfZb4w0VvBZ9wxsFBMn/sSE6/gok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Wu Hoi Pok <wuhoipok@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 614/817] drm/radeon: add helper rdev_to_drm(rdev)
Date: Tue,  3 Dec 2024 15:43:06 +0100
Message-ID: <20241203144019.900184194@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wu Hoi Pok <wuhoipok@gmail.com>

[ Upstream commit a6e23bec8ed184ed2a11080b28cdbd7a3024f0c0 ]

Add helper rdev_to_drm(rdev), similar to amdgpu, most function should
access the "drm_device" with "rdev_to_drm(rdev)" instead, where amdgpu has
"adev_to_drm(adev)". It also makes changing from "*drm_device" to "drm_device"
in "radeon_devicce" later on easier.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Wu Hoi Pok <wuhoipok@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 7037bb04265e ("drm/radeon: Fix spurious unplug event on radeon HDMI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 0999c8eaae94a..ae35c102a487e 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -2476,6 +2476,11 @@ void r100_io_wreg(struct radeon_device *rdev, u32 reg, u32 v);
 u32 cik_mm_rdoorbell(struct radeon_device *rdev, u32 index);
 void cik_mm_wdoorbell(struct radeon_device *rdev, u32 index, u32 v);
 
+static inline struct drm_device *rdev_to_drm(struct radeon_device *rdev)
+{
+	return rdev->ddev;
+}
+
 /*
  * Cast helper
  */
-- 
2.43.0



