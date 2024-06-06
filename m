Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02EC1AC24F;
	Thu,  6 Jun 2024 14:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683330; cv=none; b=SAiCVRk1CVAHOWhU4M+GiEnWC1hBlZR6pH3kbJd1HrsKNZdgcXYGVAN0qtw06Q7O0Hf+tWBAW24R6XYEk8JCKHeZJHt0It/OZP9WLdCW7dI2GREip7U3l/Yhvsvb73M6Nygr0/mU9g6xK3MMf7VjOQZzImR9wpcuO/fR/FHIUh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683330; c=relaxed/simple;
	bh=Q4/gLcdvaBmAJjs5ltWiMROBMsCNlZVHICS4lelOOjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+Sks7qqnwUvekJlItU4aCryRVzMCgchxQVj59YDaHQFFAU1cPXRtasJO1QrtHAhJ0Ds8bI4cVlGoPZgKg1QsZVNbYOGJHv3g+kEYzZZwITsfTwOXb2ZlgaGkJmRwUgmU/v6Z+Et19DyUzpEYEUFircSIBzt2bwVm1oGY26plLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Xud/jHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Xud/jHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD270C2BD10;
	Thu,  6 Jun 2024 14:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683329;
	bh=Q4/gLcdvaBmAJjs5ltWiMROBMsCNlZVHICS4lelOOjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Xud/jHlDI20Jeox6bRMB4/qted4QXKdflvHkM+eui8PPhRsnpWlP6Fp4p4oyzDuR
	 RLF6o+PtOS4XjdaDSWHAeoLrpBzmtsh6jzLrblYurzvyxcxKREkabtOQlZa3P9lrpD
	 emGNfHzzZRK7b33bIOSg9ltFZHBpIitqiqmvJhu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tony Lindgren <tony@atomide.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 271/744] drm/omapdrm: Fix console by implementing fb_dirty
Date: Thu,  6 Jun 2024 15:59:03 +0200
Message-ID: <20240606131741.063469209@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 632bac50544c0929ced9eed41e7d04c08adecbb0 ]

The framebuffer console stopped updating with commit f231af498c29
("drm/fb-helper: Disconnect damage worker from update logic").

Let's fix the issue by implementing fb_dirty similar to what was done
with commit 039a72ce7e57 ("drm/i915/fbdev: Implement fb_dirty for intel
custom fb helper").

Fixes: f231af498c29 ("drm/fb-helper: Disconnect damage worker from update logic")
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240228063540.4444-2-tony@atomide.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/omap_fbdev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/omapdrm/omap_fbdev.c b/drivers/gpu/drm/omapdrm/omap_fbdev.c
index 6b08b137af1ad..7c5af3de1e727 100644
--- a/drivers/gpu/drm/omapdrm/omap_fbdev.c
+++ b/drivers/gpu/drm/omapdrm/omap_fbdev.c
@@ -238,8 +238,20 @@ static int omap_fbdev_create(struct drm_fb_helper *helper,
 	return ret;
 }
 
+static int omap_fbdev_dirty(struct drm_fb_helper *helper, struct drm_clip_rect *clip)
+{
+	if (!(clip->x1 < clip->x2 && clip->y1 < clip->y2))
+		return 0;
+
+	if (helper->fb->funcs->dirty)
+		return helper->fb->funcs->dirty(helper->fb, NULL, 0, 0, clip, 1);
+
+	return 0;
+}
+
 static const struct drm_fb_helper_funcs omap_fb_helper_funcs = {
 	.fb_probe = omap_fbdev_create,
+	.fb_dirty = omap_fbdev_dirty,
 };
 
 static struct drm_fb_helper *get_fb(struct fb_info *fbi)
-- 
2.43.0



