Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E456C17E90E;
	Mon, 27 May 2024 19:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837127; cv=none; b=PjyWZiuYIbfskrZomj8n/KLBOuq07fpb4HKDGUc1aEDvjLTM9VC12oolnoy4rGE2k9B6CWCJxCHLfQSTduVQYmAmVkmuZ2iwW8XYKvBoIHY+tgWQDXKzvu+dK9wRtrHyS0sB+trseKD/ZGfNW14BqOI8axViuhcJ8L5yVlc5dOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837127; c=relaxed/simple;
	bh=yeJaWIFz80pvd5PVcaGbXhgjURd7ZlC4pTPUKVKVOyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9x4L8VRiblvX5Kt5y/2WiZmpMWjB3PofhOv8C+PsFm0lPz0fZ/Wv2MbquLzEy04AtKyKgUKrted01DEF97y/olbUNDFky1KYAeMos+KA2bVGZaNTofwwmb1IDggBQxedaf+cfnmyAiULq3mNcujkBsK7CzNDSma6lGNKC6Yh9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxpDzZ34; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxpDzZ34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CF2C2BBFC;
	Mon, 27 May 2024 19:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837126;
	bh=yeJaWIFz80pvd5PVcaGbXhgjURd7ZlC4pTPUKVKVOyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxpDzZ346UvybpTFDoAkSPTH9RSD/TViZAc0rLf8lrNfWfcvFaKeiCRgP0sFgcT0W
	 m+1xwgV4QkGSatDBDjuPeLpGorJ/T/xofulWWTtrKjtwW+cTurNpOzwCMi1vx3vvNt
	 LzbEOCiGbT4GMirgNDXxE3ilr8CylkEqSDU6F/ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tony Lindgren <tony@atomide.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 278/427] drm/omapdrm: Fix console by implementing fb_dirty
Date: Mon, 27 May 2024 20:55:25 +0200
Message-ID: <20240527185628.468723272@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



