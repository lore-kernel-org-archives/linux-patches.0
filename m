Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D1110A1F;
	Mon,  4 Mar 2024 21:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587714; cv=none; b=IzDwkZvi06FZQu/JEiVYauJWw+RjaxldcGoJ9i/d9T88UV4w6pHEfoqaJRP4HQFNEo7ynsklCoEa3q16xt8JmXRlc23BrS96xCqksmr9kTHLINhtlzdQYeuuiJk/68q53r8SivNvPLd2N0dWSDXW9wXz821FBKhpM9sRnD6mIIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587714; c=relaxed/simple;
	bh=JWJpJcF1FnieVMGraMIWIl5Kr6JULoTwvwjEQLiAG4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAyXr8lacVTE0wiqBFsXDz57u0CJjRzs57C3jxGB5dJueAO+gJcPEdtXy9VtLHsyQw/sSQFbyy4B7LKauVJnAAVOBR9XzsyXwRM6YRy/fl7xpM5KzRV80xLl37vJCsWSRn0pDHbuVo32MS0Lw4A2zxd3sTeaA6MxFMdbUi1IiOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MRoRHFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MRoRHFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6DDC433F1;
	Mon,  4 Mar 2024 21:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587713;
	bh=JWJpJcF1FnieVMGraMIWIl5Kr6JULoTwvwjEQLiAG4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MRoRHFz+UYOi9KbJTSGBr+Oz7sxs6Fsym9zbdIXovsUeTdOA3A1ODDpUGn6C17dC
	 PRXeE3WczjBB9bIH0X2wyWOWrpNvkoM4ZCx4wGzVHKOBQGhMQSZnsv1y/XY5PkrxK7
	 GPPP+jv0JQHlYB8HBf9PaxWmhQlvrdkJOcIRrHRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 061/162] drm/tegra: Remove existing framebuffer only if we support display
Date: Mon,  4 Mar 2024 21:22:06 +0000
Message-ID: <20240304211553.797339515@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 86bf8cfda6d2a6720fa2e6e676c98f0882c9d3d7 ]

Tegra DRM doesn't support display on Tegra234 and later, so make sure
not to remove any existing framebuffers in that case.

v2: - add comments explaining how this situation can come about
    - clear DRIVER_MODESET and DRIVER_ATOMIC feature bits

Fixes: 6848c291a54f ("drm/aperture: Convert drivers to aperture interfaces")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240223150333.1401582-1-thierry.reding@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/drm.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index ff36171c8fb70..373bcd79257e0 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -1242,9 +1242,26 @@ static int host1x_drm_probe(struct host1x_device *dev)
 
 	drm_mode_config_reset(drm);
 
-	err = drm_aperture_remove_framebuffers(&tegra_drm_driver);
-	if (err < 0)
-		goto hub;
+	/*
+	 * Only take over from a potential firmware framebuffer if any CRTCs
+	 * have been registered. This must not be a fatal error because there
+	 * are other accelerators that are exposed via this driver.
+	 *
+	 * Another case where this happens is on Tegra234 where the display
+	 * hardware is no longer part of the host1x complex, so this driver
+	 * will not expose any modesetting features.
+	 */
+	if (drm->mode_config.num_crtc > 0) {
+		err = drm_aperture_remove_framebuffers(&tegra_drm_driver);
+		if (err < 0)
+			goto hub;
+	} else {
+		/*
+		 * Indicate to userspace that this doesn't expose any display
+		 * capabilities.
+		 */
+		drm->driver_features &= ~(DRIVER_MODESET | DRIVER_ATOMIC);
+	}
 
 	err = drm_dev_register(drm, 0);
 	if (err < 0)
-- 
2.43.0



