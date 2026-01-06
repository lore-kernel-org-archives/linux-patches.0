Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F15B2EBDEB;
	Tue,  6 Jan 2026 18:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722525; cv=none; b=o11mL70MzTKqMDQx4jUetJ/Kw5XmyvHHZXeR+afu7dcrjcI2MZCMemEBjU2bzgko/p8H/wvvil+OqiTC4hPBv0+pA8YKkTNJ9f4ADUTB1Xq5lYzvvpG6rDjODFOPzVW6ubLdGKpvtrmlzKJGx+Qf5wTM86J+NjeRTd/++jHdbF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722525; c=relaxed/simple;
	bh=Z889l61eOuQ/rspS/fU8ui7w8bY5XoeJXftHMLBJ7XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b/AQLzjP1bQBtI/N1Sj6/ZE6UceZZYEt7yal0bEdJe1LcBOcbd0+1ZSXNbqxY4qyDnAtZAGkYfkaKK3ZWcyYkLteMU/P1FNKo060BnS7u96y4tcD6HprDX/J8WM68NAFV1kR5756LrIeo1U6KD1+DElebL293KHfeL05cJrRWFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JmpYKCee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JmpYKCee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE46C116C6;
	Tue,  6 Jan 2026 18:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722525;
	bh=Z889l61eOuQ/rspS/fU8ui7w8bY5XoeJXftHMLBJ7XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmpYKCeeeeaB2borzvTAxp0CXqBKFVY0HEp70SRSDJUqEDeOjMAF7oeCRShNkjx7g
	 H2iMx7uuiyVN/rvgyHH4NgAR7Rx+a2pTR6hEKh0tTSHBTRENj1WHOI03Dl6NMk7ZCs
	 /fpVmKnACxi7OmKvmKDLZtjVjLIqVemcJrskrcEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	stable@kernel.org,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.18 290/312] drm/mgag200: Fix big-endian support
Date: Tue,  6 Jan 2026 18:06:04 +0100
Message-ID: <20260106170558.344668943@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -161,6 +161,30 @@ static void mgag200_set_startadd(struct
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
@@ -496,6 +520,7 @@ void mgag200_primary_plane_helper_atomic
 	struct drm_atomic_helper_damage_iter iter;
 	struct drm_rect damage;
 
+	mgag200_set_datasiz(mdev, fb->format->format);
 	drm_atomic_helper_damage_iter_init(&iter, old_plane_state, plane_state);
 	drm_atomic_for_each_plane_damage(&iter, &damage) {
 		mgag200_handle_damage(mdev, shadow_plane_state->data, fb, &damage);


