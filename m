Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355CD17727;
	Mon, 27 May 2024 19:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838406; cv=none; b=UMdNZlQ+5qLrkgxYv9AdYUSRzAiHC0kBYZdK1wU1wQ1nWBmfFDsYLPdM5ZuOZDxmLDJZEIBhnTWWyC7HZ7r942vsPTM345TduA/HhnCg7GkVbH2xqlNirkTvgWLwYhmVlNuEnltZY6a0X5VmfsgnDQp+epPx6XB46+YuPLO6zt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838406; c=relaxed/simple;
	bh=tuOeDlot+2rzG4xqXGP8CqU+erKvhLWdEP3aImsTl3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnBskYRVylW/CZLHk21NmvVCO7orL2cxS2qDDkhLrHY8kZHbFIK0DPIcCqu006QHJfw3YS6DNs6bLtdu+zN5NX4AW6tGsLvAS4n6nTgpG+je3yWyOG5R58o96axJEVmQUVc0GqgtE2vKabtC5SYF/RsEkMXS5BBKJFIDNKMAhVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bM+bmRx7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bM+bmRx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED5BC2BBFC;
	Mon, 27 May 2024 19:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838406;
	bh=tuOeDlot+2rzG4xqXGP8CqU+erKvhLWdEP3aImsTl3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bM+bmRx7liVcxRAp7Pw5lfjxRn04sb/sPNfW3iTaOT4eREYyhMWN7uyjaV8DKFsq9
	 0x3WSB5dcCTBGSLBMEx6Q/tLj0rK9VjtteaMSDb614FGHQGazk2UNXl007P1qNuQg0
	 byZZLfzPU8eU11t+bThd2ZghMJ/pXUvbwVphb5w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tony Lindgren <tony@atomide.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 353/493] drm/omapdrm: Fix console by implementing fb_dirty
Date: Mon, 27 May 2024 20:55:55 +0200
Message-ID: <20240527185641.839121470@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



