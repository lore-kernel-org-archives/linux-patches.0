Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DA45519A9;
	Wed,  9 Sep 2026 14:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963211; cv=none; b=CpKwOHztYqBjHfXAI1y25IHVlj/MFtI4WtY+Kg3OYTPwNBoT267sYPn8IY0a1x1KbR/jc2FMG8sKkIOuhRRj3B/bGcRNGFsXqqGskkoxGiLj9hvNU0EZK7h+FSEBjCoJmNuJLflQYNdinTfazmSKbvnr5CJadX4BhTLdPkSBFU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963211; c=relaxed/simple;
	bh=NtQyogMNIkJgJyqMUXb1JOa/PrgTR/EP5S1YZ+DKwdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yv1Naw0qBoSVsmoAknzOpO3qt6d0sH98zem3KxQWppcSUt2SioIqquchRN141Ueob+zqVYVl3D7u3PB1FAvXYZ0UEIK04zvd1UX/b7e3+1JGlrUykjp6T+SInSx0cGtZGQ6SX92ivz+cJy5Y8DSi4b0wCgW2TT0K7S0amh3jGb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnHSvXhB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnHSvXhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594641F00ACA;
	Wed,  9 Sep 2026 14:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963209;
	bh=P5CAZCT0HoSBsauYKmW9VIM40x4CPWrmlsejoutinx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jnHSvXhBfxSZW7gfjcIv9bqOu49lbaHgFuMgcH1spoFvwT+6qCPFJtJgD3n+KiDfi
	 Ti6tpJOQ9c4tgaUVRzGklxiMrgmACufs5OrfMXvGGLo/bm6YrT76usFSy4EgvVGrbu
	 n2Mc43AqYdLHYf5RjDzn2nFOOIvRYJTnIi4lHUNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Thierry Reding <treding@nvidia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 7.2 520/556] drm/sysfb: simpledrm: Improve framebuffer-size validation
Date: Wed,  9 Sep 2026 15:43:20 +0200
Message-ID: <20260909134248.716805190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 03f1a3545b721fa7fdadd00080e237519a286a97 upstream.

Validate the framebuffer size from the firmware against the
limitations of struct drm_display_mode. The type only stores sizes
in 16-bit fields. Fail probing on errors.

v2:
- remove unused function simplefb_get_validated_int0() (Sashiko)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Cc: <stable@vger.kernel.org> # v5.14+
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Link: https://patch.msgid.link/20260625094509.157581-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sysfb/simpledrm.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/sysfb/simpledrm.c
+++ b/drivers/gpu/drm/sysfb/simpledrm.c
@@ -48,13 +48,6 @@ simplefb_get_validated_int(struct drm_de
 	return drm_sysfb_get_validated_int(dev, name, value, INT_MAX);
 }
 
-static int
-simplefb_get_validated_int0(struct drm_device *dev, const char *name,
-			    uint32_t value)
-{
-	return drm_sysfb_get_validated_int0(dev, name, value, INT_MAX);
-}
-
 static const struct drm_format_info *
 simplefb_get_validated_format(struct drm_device *dev, const char *format_name)
 {
@@ -88,14 +81,14 @@ static int
 simplefb_get_width_pd(struct drm_device *dev,
 		      const struct simplefb_platform_data *pd)
 {
-	return simplefb_get_validated_int0(dev, "width", pd->width);
+	return drm_sysfb_get_validated_int0(dev, "width", pd->width, U16_MAX);
 }
 
 static int
 simplefb_get_height_pd(struct drm_device *dev,
 		       const struct simplefb_platform_data *pd)
 {
-	return simplefb_get_validated_int0(dev, "height", pd->height);
+	return drm_sysfb_get_validated_int0(dev, "height", pd->height, U16_MAX);
 }
 
 static int
@@ -144,7 +137,7 @@ simplefb_get_width_of(struct drm_device
 
 	if (ret)
 		return ret;
-	return simplefb_get_validated_int0(dev, "width", width);
+	return drm_sysfb_get_validated_int0(dev, "width", width, U16_MAX);
 }
 
 static int
@@ -155,7 +148,7 @@ simplefb_get_height_of(struct drm_device
 
 	if (ret)
 		return ret;
-	return simplefb_get_validated_int0(dev, "height", height);
+	return drm_sysfb_get_validated_int0(dev, "height", height, U16_MAX);
 }
 
 static int


