Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932C5248F41;
	Tue, 20 May 2025 14:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750424; cv=none; b=JvTK09fYUz1WdKphwSRtD6hC/N+p6jLjGu/6zeXQrq69bDNyt4T68O6SV40iOoT+f+5GMoL6fVeR6m+LJgcyfIEd/KbmdEm2HX0K/ODLPzrA/PQFHw2gCAouiV5dTdlzg9n3jDm2uzp2Csbpt2mL2U+yXDxl2Zsqa0hwbbyo9Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750424; c=relaxed/simple;
	bh=9FZED7vHY7AXHiu6JZK5sOXIgcaUI/4xZgHV/K60xmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcWbhAxUwm0WeLhThYC7cdZL7Vrr549H5Gy0BQ+jSpkOdE1dqf//EkeQ9+643Znnw/4cfq0JK9A/773eD1WNcxTXmCcXHwkWh+mm3/CEEv2hZ6wDdEd/XLBrwRiPZSaRvLR+VnJ2v98IMAz/yrSIIOGUqh0osaCtlhWDdFZGiRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPE6NI7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPE6NI7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0189C4CEE9;
	Tue, 20 May 2025 14:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750424;
	bh=9FZED7vHY7AXHiu6JZK5sOXIgcaUI/4xZgHV/K60xmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPE6NI7v/Z5oCNcGDQVK++7z9A5tkfhY1l6IbM0e9TGWJB/iDRdnSaSSTNw1E/B1m
	 T6tl95y8Yi9qOGqWo3rAZgNV69KIcskfvfP30M5n3pTJh5pbffIsFJwc2J1XHyc2T/
	 Qa/V8Vrq+f9bvDgIKsR6FnZcIoxytblbsquoc9zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 6.12 140/143] drm/tiny: panel-mipi-dbi: Use drm_client_setup_with_fourcc()
Date: Tue, 20 May 2025 15:51:35 +0200
Message-ID: <20250520125815.520289974@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Fabio Estevam <festevam@denx.de>

commit 9c1798259b9420f38f1fa1b83e3d864c3eb1a83e upstream.

Since commit 559358282e5b ("drm/fb-helper: Don't use the preferred depth
for the BPP default"), RGB565 displays such as the CFAF240320X no longer
render correctly: colors are distorted and the content is shown twice
horizontally.

This regression is due to the fbdev emulation layer defaulting to 32 bits
per pixel, whereas the display expects 16 bpp (RGB565). As a result, the
framebuffer data is incorrectly interpreted by the panel.

Fix the issue by calling drm_client_setup_with_fourcc() with a format
explicitly selected based on the display's bits-per-pixel value. For 16
bpp, use DRM_FORMAT_RGB565; for other values, fall back to the previous
behavior. This ensures that the allocated framebuffer format matches the
hardware expectations, avoiding color and layout corruption.

Tested on a CFAF240320X display with an RGB565 configuration, confirming
correct colors and layout after applying this patch.

Cc: stable@vger.kernel.org
Fixes: 559358282e5b ("drm/fb-helper: Don't use the preferred depth for the BPP default")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250417103458.2496790-1-festevam@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/panel-mipi-dbi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/tiny/panel-mipi-dbi.c
+++ b/drivers/gpu/drm/tiny/panel-mipi-dbi.c
@@ -390,7 +390,10 @@ static int panel_mipi_dbi_spi_probe(stru
 
 	spi_set_drvdata(spi, drm);
 
-	drm_client_setup(drm, NULL);
+	if (bpp == 16)
+		drm_client_setup_with_fourcc(drm, DRM_FORMAT_RGB565);
+	else
+		drm_client_setup_with_fourcc(drm, DRM_FORMAT_RGB888);
 
 	return 0;
 }


