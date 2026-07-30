Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11030399350;
	Thu, 30 Jul 2026 15:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424283; cv=none; b=Dw9UQ0Dbn/lPJrfm/fkLo+3xUdvDEgU5oq+bGHwnXMW8jVMNZjSsa99XUt7s2qeZ1g/cUEotdOJPYV8MqTcBmTT+YpwF9noVJA1heQKTcTj3JvhdQW4G3Y/phB+rw3JEIe9SWqr7JLu8a/P2qfMd8yHgNl07TPS/+1zHoanykW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424283; c=relaxed/simple;
	bh=wkaukcQKULziB32q1I2EGPP/EK/ELnpvioipicX8F6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8uvgaEFRNWtTVba5FQzo090yUtsstCU1znyqyPtsSjclfLegOgpW7O9pJaGt3JBg9gQ21IRywoO1j3939I3D+bHergATr5ybdX29QWa3FelETbQrL7hUpRQvTpyfbUydbnAximOA0o/a2ybIwMgAqSLiYd0L8ZDPtsa3Uz1zZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5LiqKfI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5LiqKfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC0E1F000E9;
	Thu, 30 Jul 2026 15:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424282;
	bh=S5nT4p+W+fiZG8YzGrDNWskWXjm43Go6BNvcitWKmq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q5LiqKfITrvO6vZEAHNVXizU86nIQCdQ3FnUegqN9M8alCI+L54aACrLx/U1B2W4Q
	 hogB7dNx+T9yjK5Fao0CUK4AAlxR2hPVc7dGui4zE8gwG1uOUfF5TB3ynXsEDQk3mX
	 XJR9Or8O+dmgaNh9Og3dYylN5U1Yb8okzzh0Y5Ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sashiko <sashiko-bot@kernel.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.18 339/675] drm/sysfb: Avoid possible truncation with calculating visible size
Date: Thu, 30 Jul 2026 16:11:09 +0200
Message-ID: <20260730141452.335909908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit b771974988ec7ce077a7246fa0fa588c246fe581 upstream.

Calculating the visible size of the system framebuffer can result in
truncation of the result. The calculation uses 32-bit arithmetics,
which can overflow if the values for height and stride are large. Fix
the issue by multiplying with mul_u32_u32().

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 32ae90c66fb6 ("drm/sysfb: Add efidrm for EFI displays")
Fixes: a84eb6abe2b6 ("drm/sysfb: Add vesadrm for VESA displays")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/dri-devel/20260617114027.1F2A71F000E9@smtp.kernel.org/
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.16+
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patch.msgid.link/20260618084327.46567-3-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sysfb/drm_sysfb_screen_info.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/sysfb/drm_sysfb_screen_info.c
+++ b/drivers/gpu/drm/sysfb/drm_sysfb_screen_info.c
@@ -2,6 +2,7 @@
 
 #include <linux/export.h>
 #include <linux/limits.h>
+#include <linux/math64.h>
 #include <linux/minmax.h>
 #include <linux/screen_info.h>
 
@@ -73,7 +74,7 @@ EXPORT_SYMBOL(drm_sysfb_get_stride_si);
 u64 drm_sysfb_get_visible_size_si(struct drm_device *dev, const struct screen_info *si,
 				  unsigned int height, unsigned int stride, u64 size)
 {
-	u64 vsize = height * stride;
+	u64 vsize = mul_u32_u32(height, stride);
 
 	return drm_sysfb_get_validated_size0(dev, "visible size", vsize, size);
 }


