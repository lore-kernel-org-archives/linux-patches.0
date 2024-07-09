Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72F21586C7;
	Tue,  9 Jul 2024 11:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524216; cv=none; b=estW7LJE9BNa+CJUGbNOmMlt+aMJIl7YqXv900OvIFUJRbJ63w6hTwkzrAtU3bFv87RUTl8m8za86saqaxDfuOQWjcRyLji0NByymEcxSAqyghpkCVnYl6OFDujmHXAUnDoKU53aMg0WhBRAH1z2zhiumVAXyDFuMy8XZe3uVMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524216; c=relaxed/simple;
	bh=d7fLHmZWaRChp06HBNkntC8FM2Ps6Jhb0TVWzbdyPsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4k8d2QZ7ucukEb9uWgnhbpIwqlYBktOrUMw6L/14Qop1/OEzXqeuJuHHlqlyfFv4ICr7eses8+DKqLo/93gLVJ2PfwZ0N9Tp04zN6WVdaJzuL8a4jLcP+2uT5kuRlBIq+wy7v7LpKIqvuC+G+9WS+em1dxl59lsrPil7TG1noQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PefptlMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PefptlMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC83C3277B;
	Tue,  9 Jul 2024 11:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524216;
	bh=d7fLHmZWaRChp06HBNkntC8FM2Ps6Jhb0TVWzbdyPsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PefptlMjbAfBPEUVtRtK6h5c+teQ1rX/bE7Z8dqftaL8DI/8EWtrz4HCFfBdI+UkW
	 8LB8K7E/AZch1O7U7oLjZDQ/5AtGhZl6nZmbybDpxpIfey8xvMuh9BU5t67jS465QB
	 DTkIpXpTgcYhkgvi7+c3D2JD51WoAU42Y+hTUlxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 110/197] drm/fbdev-generic: Fix framebuffer on big endian devices
Date: Tue,  9 Jul 2024 13:09:24 +0200
Message-ID: <20240709110713.213943752@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

From: Thomas Huth <thuth@redhat.com>

[ Upstream commit 740b8dad05bee39e1e3b926f05bb4a8274b8ba49 ]

Starting with kernel 6.7, the framebuffer text console is not working
anymore with the virtio-gpu device on s390x hosts. Such big endian fb
devices are usinga different pixel ordering than little endian devices,
e.g. DRM_FORMAT_BGRX8888 instead of DRM_FORMAT_XRGB8888.

This used to work fine as long as drm_client_buffer_addfb() was still
calling drm_mode_addfb() which called drm_driver_legacy_fb_format()
internally to get the right format. But drm_client_buffer_addfb() has
recently been reworked to call drm_mode_addfb2() instead with the
format value that has been passed to it as a parameter (see commit
6ae2ff23aa43 ("drm/client: Convert drm_client_buffer_addfb() to drm_mode_addfb2()").

That format parameter is determined in drm_fbdev_generic_helper_fb_probe()
via the drm_mode_legacy_fb_format() function - which only generates
formats suitable for little endian devices. So to fix this issue
switch to drm_driver_legacy_fb_format() here instead to take the
device endianness into consideration.

Fixes: 6ae2ff23aa43 ("drm/client: Convert drm_client_buffer_addfb() to drm_mode_addfb2()")
Closes: https://issues.redhat.com/browse/RHEL-45158
Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240627173530.460615-1-thuth@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fbdev_generic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_fbdev_generic.c b/drivers/gpu/drm/drm_fbdev_generic.c
index b4659cd6285ab..cbb7418b789f8 100644
--- a/drivers/gpu/drm/drm_fbdev_generic.c
+++ b/drivers/gpu/drm/drm_fbdev_generic.c
@@ -84,7 +84,8 @@ static int drm_fbdev_generic_helper_fb_probe(struct drm_fb_helper *fb_helper,
 		    sizes->surface_width, sizes->surface_height,
 		    sizes->surface_bpp);
 
-	format = drm_mode_legacy_fb_format(sizes->surface_bpp, sizes->surface_depth);
+	format = drm_driver_legacy_fb_format(dev, sizes->surface_bpp,
+					     sizes->surface_depth);
 	buffer = drm_client_framebuffer_create(client, sizes->surface_width,
 					       sizes->surface_height, format);
 	if (IS_ERR(buffer))
-- 
2.43.0



