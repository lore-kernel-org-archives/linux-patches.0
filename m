Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE7426B096;
	Thu, 13 Feb 2025 15:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459027; cv=none; b=bWvsK7FBJOjHsPBx0MDPLlQaLtoko7Z1L5wY4+bLb2AMpTZGT9j4H3wd8TLzTmC/8hSNB2gQ2M5ztWTeoJu4+/iX14P0/pXNv9Obg/y0fJHzPrIqopI2zJXYL9ga03mB+Nr5psnt/X2sn7kHM27kMdYhLlFQH5jeDR9Vk5RzAcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459027; c=relaxed/simple;
	bh=mcpXKa/PnI9r2OWy0tJKdQy1eE1o4J6l+sr8lQ1ZGio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUkvOWtjmvvGa+s4+Rvd0w56UKXqdL1uiVxjrvrhOr0tONDI72u5DQQG2h1AocRuezQKStCNweVCMf8Mj4u8D66PCOEKuSmuWHoJQGAQkSS2cqdvHpUzYV2TxDyI0KIlN80KANiNz2l6eJ6GNiZz9Gzqhi5INQ/wuZI9BPpk66o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtpO5pbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtpO5pbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4365EC4CEE4;
	Thu, 13 Feb 2025 15:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459026;
	bh=mcpXKa/PnI9r2OWy0tJKdQy1eE1o4J6l+sr8lQ1ZGio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtpO5pbBGvCg9keAcMrsJ2swL2XbXtcN6OuRNL3gIq8unPEzH0UAIIF8ZJm6lof12
	 Qymy2BJ69lkeLbHlcEqvPOrUKrx3pT26k2+zrE0/JNhUIKOd5ARDr6Mhy2+rRRXoKg
	 Z3CQ9R11SN4jV3f9zqTEJ8eu1J3vwcp9BAtKtmHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maarten Lankhorst <dev@lankhorst.se>
Subject: [PATCH 6.13 147/443] drm/modeset: Handle tiled displays in pan_display_atomic.
Date: Thu, 13 Feb 2025 15:25:12 +0100
Message-ID: <20250213142446.271292776@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1354,14 +1354,14 @@ int drm_fb_helper_set_par(struct fb_info
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
@@ -1370,16 +1370,18 @@ static int pan_display_atomic(struct fb_
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


