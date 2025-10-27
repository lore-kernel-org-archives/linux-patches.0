Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D890531D72B;
	Mon, 27 Oct 2025 19:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591819; cv=none; b=KBE3nrVTAQK+sCEi3nLYVoLnjW9qPL9YgQG+uGHTUDunJXA+R/nQ6YryuZRa0E9cR2TfSkT2B7zwWC4gF90Vp8HkAKWg2qAci5DJLpdPRLd4qC+ermHFNLvaGBCpg+LZrpTFDGHJiu1uxKDgSqt/xBiSuDsi/2MZhQIFmZd8v4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591819; c=relaxed/simple;
	bh=LrtG8R/66jWEdc6PnQKjgbpWEteIHbR/QWe1jY/YcLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcwKTDhQp6Z33q1yguE9KHC0N1pSIFF1BphYVBHsH+yKe8rPF2AwrhkLtChCem/WOa2ii7cMwFNnf16J1+yiUI7/gl3XEANr3Tf4WkZ6vJS4vV7St8UMSisChzIGUKeFOhRud6hvYqMa4P3WphQmaMlUuSNvSD9BncgQ8ZH7Z+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgUHcVS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgUHcVS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E319C4CEF1;
	Mon, 27 Oct 2025 19:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591818;
	bh=LrtG8R/66jWEdc6PnQKjgbpWEteIHbR/QWe1jY/YcLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HgUHcVS4c5GM6r7pyx1cB9qehfhMzSznMYxfQLH6BdPTLGJfl+niPgRQaXHTjRdZ6
	 woHkiZKfIPYdmqWDtl6p9ODlyUQQ0Dm7D4PN24C6ZnsHmY4Mj6sB3JjCYznsZlskR2
	 GtRCxnpWP/6rhuNOx2BCho4JSS86qGRhxvObgSK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/123] drm/exynos: exynos7_drm_decon: properly clear channels during bind
Date: Mon, 27 Oct 2025 19:34:50 +0100
Message-ID: <20251027183446.673140380@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


