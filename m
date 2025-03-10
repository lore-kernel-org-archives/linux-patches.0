Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA8D23237F;
	Mon, 10 Mar 2025 17:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629412; cv=none; b=mqhUIKcFfruaeiyIALCfx6uLc5IeHKBJZensP//2TzVleMOV4tCTKbxFLvPbNy1K9Fjns33JwhYoW03ngmtOg64kdcFbNwlmeLdBry0Ku0qq/IAAY4T6tb5qgJ5Cpu8d83HqV4EjG99o36glerY+nyy7nY6aAOjPHmui7agRR84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629412; c=relaxed/simple;
	bh=UE249EzahVNNMVGWQ1Ar+qa1J8dMBPk1Ayq61xQTxUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kL8o053yR55HsLoOxkDCPZCKRPZEU8o1/ZSeWkXP69P+o/ENTE2Bjv3lCL/BRb4cDd7baZyA5fhjzY60b2h7ZGGwhVBdUIoRowG0oTPHJ74YDMgCkMLCMBayTqBARrzn+kD2ZY3tVqt4aTPrzzQbvM6MN5IqpEm+oyp6Xp0NVbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcO6ZVm7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcO6ZVm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FF7C4CEE5;
	Mon, 10 Mar 2025 17:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629411;
	bh=UE249EzahVNNMVGWQ1Ar+qa1J8dMBPk1Ayq61xQTxUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcO6ZVm79oT1LKFF2+hHszGD/6nVpc2u9COMTH17+pdiG5W0CyjKPhlGwWCE2eyDd
	 b65p9XNYjBtgzPRQF1Myspd58JyqdV8T7W+6OpQyjaoiQrGjtfQ/jrn7h5wboOrWnj
	 tWHJ0tkaJVxxhoGhiBchOUIk12NlwACNyyuRJmBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maarten Lankhorst <dev@lankhorst.se>
Subject: [PATCH 5.15 254/620] drm/modeset: Handle tiled displays in pan_display_atomic.
Date: Mon, 10 Mar 2025 18:01:40 +0100
Message-ID: <20250310170555.650623380@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1407,14 +1407,14 @@ int drm_fb_helper_set_par(struct fb_info
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
@@ -1423,16 +1423,18 @@ static int pan_display_atomic(struct fb_
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


