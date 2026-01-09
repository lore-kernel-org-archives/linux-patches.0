Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9D33176E4;
	Fri,  9 Jan 2026 12:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961065; cv=none; b=ZbeV5a7KJz+WNjAGUfxugCVSP4BE9sgigfkmdNaPyCBwmkYFA6JYaMX7O0KdIQ6CvP/mWi24WKQeyE25ok9fTIL5wJMAP4hi3P9hSLGB0GEaRR9y0YUJRRjI2cEUwEiF3+MhNhlMKB2VIkcz5B+1SU3s98OPMNGq8oOM5MRKusU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961065; c=relaxed/simple;
	bh=boGJAPNZ7xtC0nAPw2coLm+GCLfb7JKuvmv2salNpy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZFYLUiAKYMRCHLgGq/eiNu67/DdgM0H8qUOI4JO0jwLFk6j5+xiBaj9nenTK5EP9mr5aHbuXE+yIFNOPnpIvnyxg4vO7wwtvAK+eZq1XIzf/A42RsuDvIDMlIbzMQWWLBF9qYxlqNUji2lG3bkzTrAu03b5fggU4cItkL15ltt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lyngal5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lyngal5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F537C4CEF1;
	Fri,  9 Jan 2026 12:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961065;
	bh=boGJAPNZ7xtC0nAPw2coLm+GCLfb7JKuvmv2salNpy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lyngal5q310PijQ6t27blA9hQ3i6N+DKZz7oQwL+mj0fL9/khY4CXeT3J+wPPNn5A
	 7dDJbjxwISGHyH510fnmGGd4Af33LFgWod2X8b6AbtuxODXc/tNNoxlit1grS490pA
	 h4c/avgsTNAm4wLkEEgtNVlLpZEavRC9WKt+cfNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	stable@kernel.org,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.6 622/737] drm/mgag200: Fix big-endian support
Date: Fri,  9 Jan 2026 12:42:41 +0100
Message-ID: <20260109112157.400327792@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: René Rebe <rene@exactco.de>

commit 6cb31fba137d45e682ce455b8ea364f44d5d4f98 upstream.

Unlike the original, deleted Matrox mga driver, the new mgag200 driver
has the XRGB frame-buffer byte swapped on big-endian "RISC"
systems. Fix by enabling byte swapping "PowerPC" OPMODE for any
__BIG_ENDIAN config.

Fixes: 414c45310625 ("mgag200: initial g200se driver (v2)")
Signed-off-by: René Rebe <rene@exactco.de>
Cc: stable@kernel.org
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20251208.141827.965103015954471168.rene@exactco.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -173,6 +173,30 @@ static void mgag200_set_startadd(struct
 	WREG_ECRT(0x00, crtcext0);
 }
 
+/*
+ * Set the opmode for the hardware swapper for Big-Endian processor
+ * support for the frame buffer aperture and DMAWIN space.
+ */
+static void mgag200_set_datasiz(struct mga_device *mdev, u32 format)
+{
+#if defined(__BIG_ENDIAN)
+	u32 opmode = RREG32(MGAREG_OPMODE);
+
+	opmode &= ~(GENMASK(17, 16) | GENMASK(9, 8) | GENMASK(3, 2));
+
+	/* Big-endian byte-swapping */
+	switch (format) {
+	case DRM_FORMAT_RGB565:
+		opmode |= 0x10100;
+		break;
+	case DRM_FORMAT_XRGB8888:
+		opmode |= 0x20200;
+		break;
+	}
+	WREG32(MGAREG_OPMODE, opmode);
+#endif
+}
+
 void mgag200_init_registers(struct mga_device *mdev)
 {
 	u8 crtc11, misc;
@@ -502,6 +526,7 @@ void mgag200_primary_plane_helper_atomic
 	struct drm_atomic_helper_damage_iter iter;
 	struct drm_rect damage;
 
+	mgag200_set_datasiz(mdev, fb->format->format);
 	drm_atomic_helper_damage_iter_init(&iter, old_plane_state, plane_state);
 	drm_atomic_for_each_plane_damage(&iter, &damage) {
 		mgag200_handle_damage(mdev, shadow_plane_state->data, fb, &damage);


