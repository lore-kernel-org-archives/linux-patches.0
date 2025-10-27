Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB32932ED46;
	Mon, 27 Oct 2025 18:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590721; cv=none; b=RqsJUUZeBT1Z+P+LanaHEEkxOqG5VKk9IM911vdR341+NAxV/EdmRssvQAaDkQOSGpMYHltSs6nDZBXadVaBycaW88tauQR3XQbG9/y1cv3aJmec7TZFBsQCVmauy8vuXtRQMmB41d4du3lU9VEjO+NrzDb+yyysI122XotcteM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590721; c=relaxed/simple;
	bh=pfPC7i0UClbAVagW+HPVcJXMT59y+Yz6ZgPMpMOwj3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6+MTQuu9uYwlUp7tN6eJryflQDorKYPUl9AHMMxJo4gEuwoSKNXBOunjSkC1oNvc4fnpgHac+OBxJTaPPjxhjm4lMhBst/mej+WCxZ0pXRF9f0bD7FdR+qrpN4A6mkBBvxtbSAyUCQyAfx6eT29Ho1i2JQxn97VdHTwGx9hgvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bU6deFPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bU6deFPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF21C4CEFD;
	Mon, 27 Oct 2025 18:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590721;
	bh=pfPC7i0UClbAVagW+HPVcJXMT59y+Yz6ZgPMpMOwj3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bU6deFPCok8rzi9XI/JAWsbbdWNGPvtjNJUcUNiaNnrIgSpfugWOnedQnGtlvMg3R
	 KO5GN77HqH+nXYZS1L8twtL8y4IlxDSRiz7C04LuWQj+TFkOYvUKFmev4goBBQ9j0P
	 SMOt80NVJJ7oPVUBGx8P1bbTijiWiubC09T4DTyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inki Dae <inki.dae@samsung.com>,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 152/224] drm/exynos: exynos7_drm_decon: remove ctx->suspended
Date: Mon, 27 Oct 2025 19:34:58 +0100
Message-ID: <20251027183513.025770968@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaustabh Chakraborty <kauschluss@disroot.org>

[ Upstream commit e1361a4f1be9cb69a662c6d7b5ce218007d6e82b ]

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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/exynos/exynos7_drm_decon.c |   36 -----------------------------
 1 file changed, 36 deletions(-)

--- a/drivers/gpu/drm/exynos/exynos7_drm_decon.c
+++ b/drivers/gpu/drm/exynos/exynos7_drm_decon.c
@@ -51,7 +51,6 @@ struct decon_context {
 	void __iomem			*regs;
 	unsigned long			irq_flags;
 	bool				i80_if;
-	bool				suspended;
 	wait_queue_head_t		wait_vsync_queue;
 	atomic_t			wait_vsync_event;
 
@@ -85,9 +84,6 @@ static void decon_wait_for_vblank(struct
 {
 	struct decon_context *ctx = crtc->ctx;
 
-	if (ctx->suspended)
-		return;
-
 	atomic_set(&ctx->wait_vsync_event, 1);
 
 	/*
@@ -155,9 +151,6 @@ static void decon_commit(struct exynos_d
 	struct drm_display_mode *mode = &crtc->base.state->adjusted_mode;
 	u32 val, clkdiv;
 
-	if (ctx->suspended)
-		return;
-
 	/* nothing to do if we haven't set the mode yet */
 	if (mode->htotal == 0 || mode->vtotal == 0)
 		return;
@@ -219,9 +212,6 @@ static int decon_enable_vblank(struct ex
 	struct decon_context *ctx = crtc->ctx;
 	u32 val;
 
-	if (ctx->suspended)
-		return -EPERM;
-
 	if (!test_and_set_bit(0, &ctx->irq_flags)) {
 		val = readl(ctx->regs + VIDINTCON0);
 
@@ -244,9 +234,6 @@ static void decon_disable_vblank(struct
 	struct decon_context *ctx = crtc->ctx;
 	u32 val;
 
-	if (ctx->suspended)
-		return;
-
 	if (test_and_clear_bit(0, &ctx->irq_flags)) {
 		val = readl(ctx->regs + VIDINTCON0);
 
@@ -369,9 +356,6 @@ static void decon_atomic_begin(struct ex
 	struct decon_context *ctx = crtc->ctx;
 	int i;
 
-	if (ctx->suspended)
-		return;
-
 	for (i = 0; i < WINDOWS_NR; i++)
 		decon_shadow_protect_win(ctx, i, true);
 }
@@ -391,9 +375,6 @@ static void decon_update_plane(struct ex
 	unsigned int cpp = fb->format->cpp[0];
 	unsigned int pitch = fb->pitches[0];
 
-	if (ctx->suspended)
-		return;
-
 	/*
 	 * SHADOWCON/PRTCON register is used for enabling timing.
 	 *
@@ -481,9 +462,6 @@ static void decon_disable_plane(struct e
 	unsigned int win = plane->index;
 	u32 val;
 
-	if (ctx->suspended)
-		return;
-
 	/* protect windows */
 	decon_shadow_protect_win(ctx, win, true);
 
@@ -502,9 +480,6 @@ static void decon_atomic_flush(struct ex
 	struct decon_context *ctx = crtc->ctx;
 	int i;
 
-	if (ctx->suspended)
-		return;
-
 	for (i = 0; i < WINDOWS_NR; i++)
 		decon_shadow_protect_win(ctx, i, false);
 	exynos_crtc_handle_event(crtc);
@@ -531,9 +506,6 @@ static void decon_enable(struct exynos_d
 {
 	struct decon_context *ctx = crtc->ctx;
 
-	if (!ctx->suspended)
-		return;
-
 	pm_runtime_get_sync(ctx->dev);
 
 	decon_init(ctx);
@@ -543,8 +515,6 @@ static void decon_enable(struct exynos_d
 		decon_enable_vblank(ctx->crtc);
 
 	decon_commit(ctx->crtc);
-
-	ctx->suspended = false;
 }
 
 static void decon_disable(struct exynos_drm_crtc *crtc)
@@ -552,9 +522,6 @@ static void decon_disable(struct exynos_
 	struct decon_context *ctx = crtc->ctx;
 	int i;
 
-	if (ctx->suspended)
-		return;
-
 	/*
 	 * We need to make sure that all windows are disabled before we
 	 * suspend that connector. Otherwise we might try to scan from
@@ -564,8 +531,6 @@ static void decon_disable(struct exynos_
 		decon_disable_plane(crtc, &ctx->planes[i]);
 
 	pm_runtime_put_sync(ctx->dev);
-
-	ctx->suspended = true;
 }
 
 static const struct exynos_drm_crtc_ops decon_crtc_ops = {
@@ -687,7 +652,6 @@ static int decon_probe(struct platform_d
 		return -ENOMEM;
 
 	ctx->dev = dev;
-	ctx->suspended = true;
 
 	i80_if_timings = of_get_child_by_name(dev->of_node, "i80-if-timings");
 	if (i80_if_timings)


