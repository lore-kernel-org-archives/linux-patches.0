Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49BF336EDB;
	Fri, 17 Oct 2025 15:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715352; cv=none; b=dNZfRjtU+othSpR5N0faFmG7Fx3YLNeC9rLxRgmlxSQ3D9Kzvb3glGwq4tBUNSF0+2VOZM7hUMzy2g4JvwduSND949qXPocT+Lgoh7erhvWIErsitzvIN9f/LWiOZD3/9uu0/8jyaym413KgtaFEAWBiYVAMLaiWjPa/TeO7z6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715352; c=relaxed/simple;
	bh=KKcSrJ0SkdiDYWTwP8eHtpy0/hLJ7ngSol1+jW+V8ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcrfcpTUtnxNpzRb9bA5by6g5Wit1isWElEet1auxdpbIdLW8t5GNFGZshmU8fzlg6puMlXrEs9hX9bcngULoaVhhiNqN/qV/w9181zPJPc+l/OUj5nXzbtg2DdCPvWSWHZcK/ocHd62vWGi+f55p11Tj/H+VgDrtx2zgfCIzQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2+PiHSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2+PiHSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3007EC4CEE7;
	Fri, 17 Oct 2025 15:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715352;
	bh=KKcSrJ0SkdiDYWTwP8eHtpy0/hLJ7ngSol1+jW+V8ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2+PiHSatZ91HOlIqd+0lnc3Q+o17Fx4wAh9nf2ETPdFYSjvsvYK4h7IpYc0bXvS6
	 Fixt90cGDVUKMqPOvO2a8i30faoDXsVa8WEnktrPjLgYcmrpfNBKSFX/fuDdz1+1K4
	 mJlUoNli/YGJodieCPErpHe6z1tXbHT1bLRNfWJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inki Dae <inki.dae@samsung.com>,
	Kaustabh Chakraborty <kauschluss@disroot.org>
Subject: [PATCH 6.17 186/371] drm/exynos: exynos7_drm_decon: remove ctx->suspended
Date: Fri, 17 Oct 2025 16:52:41 +0200
Message-ID: <20251017145208.653903544@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaustabh Chakraborty <kauschluss@disroot.org>

commit e1361a4f1be9cb69a662c6d7b5ce218007d6e82b upstream.

Condition guards are found to be redundant, as the call flow is properly
managed now, as also observed in the Exynos5433 DECON driver. Since
state checking is no longer necessary, remove it.

This also fixes an issue which prevented decon_commit() from
decon_atomic_enable() due to an incorrect state change setting.

Fixes: 96976c3d9aff ("drm/exynos: Add DECON driver")
Cc: stable@vger.kernel.org
Suggested-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kaustabh Chakraborty <kauschluss@disroot.org>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/exynos/exynos7_drm_decon.c |   36 -----------------------------
 1 file changed, 36 deletions(-)

--- a/drivers/gpu/drm/exynos/exynos7_drm_decon.c
+++ b/drivers/gpu/drm/exynos/exynos7_drm_decon.c
@@ -69,7 +69,6 @@ struct decon_context {
 	void __iomem			*regs;
 	unsigned long			irq_flags;
 	bool				i80_if;
-	bool				suspended;
 	wait_queue_head_t		wait_vsync_queue;
 	atomic_t			wait_vsync_event;
 
@@ -132,9 +131,6 @@ static void decon_shadow_protect_win(str
 
 static void decon_wait_for_vblank(struct decon_context *ctx)
 {
-	if (ctx->suspended)
-		return;
-
 	atomic_set(&ctx->wait_vsync_event, 1);
 
 	/*
@@ -210,9 +206,6 @@ static void decon_commit(struct exynos_d
 	struct drm_display_mode *mode = &crtc->base.state->adjusted_mode;
 	u32 val, clkdiv;
 
-	if (ctx->suspended)
-		return;
-
 	/* nothing to do if we haven't set the mode yet */
 	if (mode->htotal == 0 || mode->vtotal == 0)
 		return;
@@ -274,9 +267,6 @@ static int decon_enable_vblank(struct ex
 	struct decon_context *ctx = crtc->ctx;
 	u32 val;
 
-	if (ctx->suspended)
-		return -EPERM;
-
 	if (!test_and_set_bit(0, &ctx->irq_flags)) {
 		val = readl(ctx->regs + VIDINTCON0);
 
@@ -299,9 +289,6 @@ static void decon_disable_vblank(struct
 	struct decon_context *ctx = crtc->ctx;
 	u32 val;
 
-	if (ctx->suspended)
-		return;
-
 	if (test_and_clear_bit(0, &ctx->irq_flags)) {
 		val = readl(ctx->regs + VIDINTCON0);
 
@@ -404,9 +391,6 @@ static void decon_atomic_begin(struct ex
 	struct decon_context *ctx = crtc->ctx;
 	int i;
 
-	if (ctx->suspended)
-		return;
-
 	for (i = 0; i < WINDOWS_NR; i++)
 		decon_shadow_protect_win(ctx, i, true);
 }
@@ -427,9 +411,6 @@ static void decon_update_plane(struct ex
 	unsigned int pitch = fb->pitches[0];
 	unsigned int vidw_addr0_base = ctx->data->vidw_buf_start_base;
 
-	if (ctx->suspended)
-		return;
-
 	/*
 	 * SHADOWCON/PRTCON register is used for enabling timing.
 	 *
@@ -517,9 +498,6 @@ static void decon_disable_plane(struct e
 	unsigned int win = plane->index;
 	u32 val;
 
-	if (ctx->suspended)
-		return;
-
 	/* protect windows */
 	decon_shadow_protect_win(ctx, win, true);
 
@@ -538,9 +516,6 @@ static void decon_atomic_flush(struct ex
 	struct decon_context *ctx = crtc->ctx;
 	int i;
 
-	if (ctx->suspended)
-		return;
-
 	for (i = 0; i < WINDOWS_NR; i++)
 		decon_shadow_protect_win(ctx, i, false);
 	exynos_crtc_handle_event(crtc);
@@ -568,9 +543,6 @@ static void decon_atomic_enable(struct e
 	struct decon_context *ctx = crtc->ctx;
 	int ret;
 
-	if (!ctx->suspended)
-		return;
-
 	ret = pm_runtime_resume_and_get(ctx->dev);
 	if (ret < 0) {
 		DRM_DEV_ERROR(ctx->dev, "failed to enable DECON device.\n");
@@ -584,8 +556,6 @@ static void decon_atomic_enable(struct e
 		decon_enable_vblank(ctx->crtc);
 
 	decon_commit(ctx->crtc);
-
-	ctx->suspended = false;
 }
 
 static void decon_atomic_disable(struct exynos_drm_crtc *crtc)
@@ -593,9 +563,6 @@ static void decon_atomic_disable(struct
 	struct decon_context *ctx = crtc->ctx;
 	int i;
 
-	if (ctx->suspended)
-		return;
-
 	/*
 	 * We need to make sure that all windows are disabled before we
 	 * suspend that connector. Otherwise we might try to scan from
@@ -605,8 +572,6 @@ static void decon_atomic_disable(struct
 		decon_disable_plane(crtc, &ctx->planes[i]);
 
 	pm_runtime_put_sync(ctx->dev);
-
-	ctx->suspended = true;
 }
 
 static const struct exynos_drm_crtc_ops decon_crtc_ops = {
@@ -727,7 +692,6 @@ static int decon_probe(struct platform_d
 		return -ENOMEM;
 
 	ctx->dev = dev;
-	ctx->suspended = true;
 	ctx->data = of_device_get_match_data(dev);
 
 	i80_if_timings = of_get_child_by_name(dev->of_node, "i80-if-timings");


