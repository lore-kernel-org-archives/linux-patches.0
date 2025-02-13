Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EF115E5D4;
	Thu, 13 Feb 2025 15:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460346; cv=none; b=o60meGYnWT593YRMoIwqFN8STcPcaGgT6pPIg6JLpMLIyqMaBbQnT1xhibp0peoTkWq2GrolU6s5wsayiaxdtMCIbZsp913EcpPfGHPLnh0Kz4sbzU5VpZB9jt3UGB1rGTYD1qBsc1CLLU+Gr2JfDPifYePsHoJyCGKG/DXuuws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460346; c=relaxed/simple;
	bh=MH6qSubAfp4PYdvwl2doHd0whV65h/txaEQUJPVH67o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCGOrqt3Shm5LqT+ZIWOQPcrhx1qiP/vigJ/9lKotT4AKTR/XwXfdxMMVpisSm4DCsWMkKdJwwGzma08nzPD74LrkXIksWVc9bhgC/U2MgTcwJMAPr2IVzXmfuSRsi/IBNn5hrULYjpGsbCV9U8yWLNFAPgCb3I39UdTsqkwjYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nqx5xPGI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nqx5xPGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA2DC4CED1;
	Thu, 13 Feb 2025 15:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460346;
	bh=MH6qSubAfp4PYdvwl2doHd0whV65h/txaEQUJPVH67o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nqx5xPGIWIQi5MQjcK0voKGyUAZ1F+/ZbX6wh+FIrzPsB93YMdH++8pBCUc+Z+byn
	 T7SheD8Io5y+TcddzZMQ07kk5hcOlhAErRVmS+Y/O9MlYJVFNfq0hh64KmC8WezTH1
	 vuHxyYCp0QRE96TLssENBYlpFu3tzb+kmgCQk2Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maarten Lankhorst <dev@lankhorst.se>
Subject: [PATCH 6.6 084/273] drm/modeset: Handle tiled displays in pan_display_atomic.
Date: Thu, 13 Feb 2025 15:27:36 +0100
Message-ID: <20250213142410.664813995@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1361,14 +1361,14 @@ int drm_fb_helper_set_par(struct fb_info
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
@@ -1377,16 +1377,18 @@ static int pan_display_atomic(struct fb_
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


