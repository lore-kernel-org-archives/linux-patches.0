Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E54724291D;
	Thu, 13 Feb 2025 14:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457512; cv=none; b=d9Fhjvjep5wDoHWmZZ3C9JbfKB9zyVhfzdP+C5qOar7V9+9gVvo3oQox81hlMOwGwUQQHmKt4oEQ8lMf88zDF4O7XAJyxKXlKYQFfFUujUNd/DF5Y7Mx/WK899nXWcQWqjvXa9ffwU7VtojMijuxLWAcUM79y9M5siGHsQ8rOyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457512; c=relaxed/simple;
	bh=zONAxminnkW0rA0ReafGpGssknWCwSEbFJJfOcbAlOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQL77AY4EtwtJVKKiPoheX7mmPIzFKXsrb0vHWTzJWzne76oD6IOwlcHGLEOXf9GAnVTAfsE07WoKhoCyY3o4CEFltsVOTO/QncTavJZoVDcKGjeF5nmQR9skMkFbaR1I/MXpVdOm2KHoGXxutKsKwrHJWBajsg+F/Wv3BU5pSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfExtW2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfExtW2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CE0C4CED1;
	Thu, 13 Feb 2025 14:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457512;
	bh=zONAxminnkW0rA0ReafGpGssknWCwSEbFJJfOcbAlOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfExtW2qvWuSuYGUBy+HlTlvUO5RsyydTg/fQ1c1xqxpI/f0LqEceBmOyt6H4x2TB
	 As77HFgGtH1wP8xoHQ4Boj4rmYllRAfghfuTfblqHnp3BDLnZKDm+2XkGlJbf2ElAe
	 wrDZFZktCTak9SF9nxXD315Fz+6+AJnLnYUfjP14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maarten Lankhorst <dev@lankhorst.se>
Subject: [PATCH 6.12 133/422] drm/modeset: Handle tiled displays in pan_display_atomic.
Date: Thu, 13 Feb 2025 15:24:42 +0100
Message-ID: <20250213142441.682304199@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <dev@lankhorst.se>

commit f4a9dd57e549a17a7dac1c1defec26abd7e5c2d4 upstream.

Tiled displays have a different x/y offset to begin with. Instead of
attempting to remember this, just apply a delta instead.

This fixes the first tile being duplicated on other tiles when vt
switching.

Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20250116142825.3933-1-dev@lankhorst.se
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_fb_helper.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1348,14 +1348,14 @@ int drm_fb_helper_set_par(struct fb_info
 }
 EXPORT_SYMBOL(drm_fb_helper_set_par);
 
-static void pan_set(struct drm_fb_helper *fb_helper, int x, int y)
+static void pan_set(struct drm_fb_helper *fb_helper, int dx, int dy)
 {
 	struct drm_mode_set *mode_set;
 
 	mutex_lock(&fb_helper->client.modeset_mutex);
 	drm_client_for_each_modeset(mode_set, &fb_helper->client) {
-		mode_set->x = x;
-		mode_set->y = y;
+		mode_set->x += dx;
+		mode_set->y += dy;
 	}
 	mutex_unlock(&fb_helper->client.modeset_mutex);
 }
@@ -1364,16 +1364,18 @@ static int pan_display_atomic(struct fb_
 			      struct fb_info *info)
 {
 	struct drm_fb_helper *fb_helper = info->par;
-	int ret;
+	int ret, dx, dy;
 
-	pan_set(fb_helper, var->xoffset, var->yoffset);
+	dx = var->xoffset - info->var.xoffset;
+	dy = var->yoffset - info->var.yoffset;
+	pan_set(fb_helper, dx, dy);
 
 	ret = drm_client_modeset_commit_locked(&fb_helper->client);
 	if (!ret) {
 		info->var.xoffset = var->xoffset;
 		info->var.yoffset = var->yoffset;
 	} else
-		pan_set(fb_helper, info->var.xoffset, info->var.yoffset);
+		pan_set(fb_helper, -dx, -dy);
 
 	return ret;
 }


