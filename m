Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DE8273D7B;
	Tue, 21 Oct 2025 19:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076403; cv=none; b=sw8tQxtnB42x2xIH5OESFv9shW86SH+bSq5i9zgEsVZjOcnva1KNzPnN4jR8X0B8VmbR5P6tx2jUK+nFQpPnyJAx2GpK+S88yg9KBQcy7/an+eP0wcRflN9Zkpl438AeF8Jr2SvYhVEzMPkZzbsFe7AlAEfX0hfLX+fmkJH228U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076403; c=relaxed/simple;
	bh=CuGcTrz6KDWdsdK4JqmtHVT4bUFVNMR0LKBsZj+9/3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eo3pRj48563d1vpPhnlnoAFXRDM+LOdNikB/BroJwWHfbvkrPpvdCbIwU1W5ok4D6mlKhs+ir69ltj+YS2ZI3NH7w42NRkbamsfnjw/sSsz20K0LGOQyE+GQxxsVG1OfPgiKsgtMxLFpjQtI580RrPZPaCH/GQMKaaxZ/9pk/Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnsLzuFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnsLzuFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE85C4CEF1;
	Tue, 21 Oct 2025 19:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076402;
	bh=CuGcTrz6KDWdsdK4JqmtHVT4bUFVNMR0LKBsZj+9/3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnsLzuFjVzVaQoam+kW0u+1YxeEjkJO1GZUtdvGmnafNV0eCjG8gSD1ci/Y34KBDB
	 piMbURfUqkUcZzgJZDHPVQolK8/wYAyLnXgnbS5IpH2C4eac1Lzgi+kTi61ybJ0hSO
	 N7IxHYQ+sqdoa7YdGqDdHVJS7XHsnCYJfN8U+0n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/105] drm/exynos: exynos7_drm_decon: properly clear channels during bind
Date: Tue, 21 Oct 2025 21:50:33 +0200
Message-ID: <20251021195022.274271000@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaustabh Chakraborty <kauschluss@disroot.org>

[ Upstream commit 5f1a453974204175f20b3788824a0fe23cc36f79 ]

The DECON channels are not cleared properly as the windows aren't
shadow protected. When accompanied with an IOMMU, it pagefaults, and
the kernel panics.

Implement shadow protect/unprotect, along with a standalone update,
for channel clearing to properly take effect.

Signed-off-by: Kaustabh Chakraborty <kauschluss@disroot.org>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Stable-dep-of: e1361a4f1be9 ("drm/exynos: exynos7_drm_decon: remove ctx->suspended")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/exynos/exynos7_drm_decon.c |   55 ++++++++++++++++-------------
 1 file changed, 32 insertions(+), 23 deletions(-)

--- a/drivers/gpu/drm/exynos/exynos7_drm_decon.c
+++ b/drivers/gpu/drm/exynos/exynos7_drm_decon.c
@@ -81,6 +81,28 @@ static const enum drm_plane_type decon_w
 	DRM_PLANE_TYPE_CURSOR,
 };
 
+/**
+ * decon_shadow_protect_win() - disable updating values from shadow registers at vsync
+ *
+ * @ctx: display and enhancement controller context
+ * @win: window to protect registers for
+ * @protect: 1 to protect (disable updates)
+ */
+static void decon_shadow_protect_win(struct decon_context *ctx,
+				     unsigned int win, bool protect)
+{
+	u32 bits, val;
+
+	bits = SHADOWCON_WINx_PROTECT(win);
+
+	val = readl(ctx->regs + SHADOWCON);
+	if (protect)
+		val |= bits;
+	else
+		val &= ~bits;
+	writel(val, ctx->regs + SHADOWCON);
+}
+
 static void decon_wait_for_vblank(struct decon_context *ctx)
 {
 	if (ctx->suspended)
@@ -101,18 +123,27 @@ static void decon_wait_for_vblank(struct
 static void decon_clear_channels(struct decon_context *ctx)
 {
 	unsigned int win, ch_enabled = 0;
+	u32 val;
 
 	/* Check if any channel is enabled. */
 	for (win = 0; win < WINDOWS_NR; win++) {
-		u32 val = readl(ctx->regs + WINCON(win));
+		val = readl(ctx->regs + WINCON(win));
 
 		if (val & WINCONx_ENWIN) {
+			decon_shadow_protect_win(ctx, win, true);
+
 			val &= ~WINCONx_ENWIN;
 			writel(val, ctx->regs + WINCON(win));
 			ch_enabled = 1;
+
+			decon_shadow_protect_win(ctx, win, false);
 		}
 	}
 
+	val = readl(ctx->regs + DECON_UPDATE);
+	val |= DECON_UPDATE_STANDALONE_F;
+	writel(val, ctx->regs + DECON_UPDATE);
+
 	/* Wait for vsync, as disable channel takes effect at next vsync */
 	if (ch_enabled)
 		decon_wait_for_vblank(ctx);
@@ -340,28 +371,6 @@ static void decon_win_set_colkey(struct
 	writel(keycon1, ctx->regs + WKEYCON1_BASE(win));
 }
 
-/**
- * decon_shadow_protect_win() - disable updating values from shadow registers at vsync
- *
- * @ctx: display and enhancement controller context
- * @win: window to protect registers for
- * @protect: 1 to protect (disable updates)
- */
-static void decon_shadow_protect_win(struct decon_context *ctx,
-				     unsigned int win, bool protect)
-{
-	u32 bits, val;
-
-	bits = SHADOWCON_WINx_PROTECT(win);
-
-	val = readl(ctx->regs + SHADOWCON);
-	if (protect)
-		val |= bits;
-	else
-		val &= ~bits;
-	writel(val, ctx->regs + SHADOWCON);
-}
-
 static void decon_atomic_begin(struct exynos_drm_crtc *crtc)
 {
 	struct decon_context *ctx = crtc->ctx;


