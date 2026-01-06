Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6AC2DF13B;
	Tue,  6 Jan 2026 17:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721233; cv=none; b=SQUSFP9Ld0L229oeSSYrhp4S6IDpdfXAQBXy47CZDhy8aUiP37gvP8BeEWqLm5ai7YGoFG79i8frDq4abI7o5risuU4OkyX0aAiKvp/62ctH+yoj9XQanE38G0AFoVv9diOCd1MnncoO3HorCnZFU4AbpWWlAe/AfqGfy07Stp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721233; c=relaxed/simple;
	bh=jUx37cv3Qeb04lO6JdMmyZkoRG5/x8I3iwSuTN305ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C5zoNeVAvIgNdVGpOYRHxa+7Z43nR6wY8sbNHXcn65xh2eAE5nBfwXghc8jsn5F7EDwpZAZxEdzgHfdL0YAS7r0AfK7OGhTZXfzSDMHIBfrattesAUR1nVhkd5HtlWI+mFcb98jrRpRDuPbZN9+5Dg10DX72S86Ce/mZBe2RiyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYjkCzla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYjkCzla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A17FC116C6;
	Tue,  6 Jan 2026 17:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721232;
	bh=jUx37cv3Qeb04lO6JdMmyZkoRG5/x8I3iwSuTN305ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYjkCzlaM0EQw40/gaPXGRjV/ES+/TPnnOP/WZaFyc0njg915V/GLFnHZeCNz9FXF
	 KtCjVW9ZI32ep4gybNTlbjW1hgpS+xrgx3bR/OcWVvFzt9rPF1l2gyTv9+8VSyeHgw
	 UxO2GlxQNzWmaHBxejhml4Wlk4a+17CAyl2t7kV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	stable@kernel.org,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.12 475/567] drm/mgag200: Fix big-endian support
Date: Tue,  6 Jan 2026 18:04:17 +0100
Message-ID: <20260106170508.924707707@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -175,6 +175,30 @@ static void mgag200_set_startadd(struct
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
@@ -510,6 +534,7 @@ void mgag200_primary_plane_helper_atomic
 	struct drm_atomic_helper_damage_iter iter;
 	struct drm_rect damage;
 
+	mgag200_set_datasiz(mdev, fb->format->format);
 	drm_atomic_helper_damage_iter_init(&iter, old_plane_state, plane_state);
 	drm_atomic_for_each_plane_damage(&iter, &damage) {
 		mgag200_handle_damage(mdev, shadow_plane_state->data, fb, &damage);


