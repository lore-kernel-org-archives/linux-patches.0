Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58A635B138;
	Fri,  9 Jan 2026 12:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962846; cv=none; b=YYnsU33l4rYF35RBHqaMPtgJKkwekpEJoSCAicCGEDFhmE8tWY+p73e0gyMcCeFYUaUHimOXme28HgXVpSKOwmZGOYmt07/KEck+evK5eenzLe9ohIckDwY240/kiwQckWCFINfunG8iPIhC+sTOyDL4goMIjzQjE7mOlaPRIQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962846; c=relaxed/simple;
	bh=eTGiundHwuXVLq7M0d8QX+uf9ziD2sYS5kUmcGTkZD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JuyVPL8DTP++AoscNUZiFKHe/FIDeOgSnUBozdPxdJKkMjIx4pO4e0PapENHtSHUIvd+kmHY9hmJQNKHDoxhQIa+I2bx4M1GL8j5YyO7gwxVty/+Uespr8qAXh25Z4v7I/pi+lW8w3aC7vD1n9HuMT8UAKyXPlg+fmqv8BwZgdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRlyHIKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRlyHIKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DEFC4CEF1;
	Fri,  9 Jan 2026 12:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962846;
	bh=eTGiundHwuXVLq7M0d8QX+uf9ziD2sYS5kUmcGTkZD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRlyHIKZkosBQhZ56lg+jrYNWl7cbsRj1ZIYW86mIQUU86oU/GkWBljRm4Dn8kPRS
	 QgD3T+6PunTJ0U51HkgHvhdkrCxAefkQSd9nljpPXUc++FZNyCor1BnDtT61QCAJkB
	 SoubPbdD0VJpbjQVMbebPu89KzZs0Spt4jPrYzeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	stable@kernel.org,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.1 508/634] drm/mgag200: Fix big-endian support
Date: Fri,  9 Jan 2026 12:43:06 +0100
Message-ID: <20260109112136.666772275@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -506,6 +530,7 @@ void mgag200_primary_plane_helper_atomic
 	if (!fb)
 		return;
 
+	mgag200_set_datasiz(mdev, fb->format->format);
 	drm_atomic_helper_damage_iter_init(&iter, old_plane_state, plane_state);
 	drm_atomic_for_each_plane_damage(&iter, &damage) {
 		mgag200_handle_damage(mdev, shadow_plane_state->data, fb, &damage);


