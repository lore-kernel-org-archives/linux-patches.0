Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEF231BC84;
	Mon, 27 Oct 2025 19:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591876; cv=none; b=Bms48d9If1yeEZEUj9XcNSxBDgeUey9LZP9C6We67uVMD1Aw9xaH8pD94Cw4M+8A8CxL7TZY9tKfHKL6mBm1mYPfsDV9Qf4hXHm7zSKbrVZmxYRc45IHel2RQeQlVjYF/SEtfE3UJhuEwCzeqosxzhRpJEGDZsZLliPiji8XjnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591876; c=relaxed/simple;
	bh=1qFLx/Qj69ZSGOwMXn4KvAMhZqWvaY/1/vz05fFuzrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQiVQ6pGwzu070K+XLA1Cc7mbUIfVhZZwd7TT/aiIU48XsxXHw2KWH2VWQi0T0MyNkiXZVsSQg1/xJQyLv+fsyUU+wzGLhwEdFSa5XQtiDqUSS0MMh5Omkl7gTxNU9C+hABx7ZLVUKUJpJLN+2Xy9StG5B6DdS9FVV+GiQKr1Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USglgS/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USglgS/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B1CC4CEF1;
	Mon, 27 Oct 2025 19:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591875;
	bh=1qFLx/Qj69ZSGOwMXn4KvAMhZqWvaY/1/vz05fFuzrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USglgS/rX0Pl93En+sLDJLSHycbyyFsbQGgG1RxI6BGhV4LnPjv4Qj0VxAXNmQftu
	 ZWqgL5i4TTNSlBM+yV+2NTy13LecesHnN/N1Tv48lf57f5YIKFSeiIluxRUPvwLdJe
	 Woz+IqUb2uBLrou1RPjOofBzEwsNrL3ijVDMraOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/123] drm/exynos: exynos7_drm_decon: fix uninitialized crtc reference in functions
Date: Mon, 27 Oct 2025 19:34:49 +0100
Message-ID: <20251027183446.644838549@linuxfoundation.org>
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

[ Upstream commit d31bbacf783daf1e71fbe5c68df93550c446bf44 ]

Modify the functions to accept a pointer to struct decon_context
instead.

Signed-off-by: Kaustabh Chakraborty <kauschluss@disroot.org>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Stable-dep-of: e1361a4f1be9 ("drm/exynos: exynos7_drm_decon: remove ctx->suspended")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/exynos/exynos7_drm_decon.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/exynos/exynos7_drm_decon.c
+++ b/drivers/gpu/drm/exynos/exynos7_drm_decon.c
@@ -81,10 +81,8 @@ static const enum drm_plane_type decon_w
 	DRM_PLANE_TYPE_CURSOR,
 };
 
-static void decon_wait_for_vblank(struct exynos_drm_crtc *crtc)
+static void decon_wait_for_vblank(struct decon_context *ctx)
 {
-	struct decon_context *ctx = crtc->ctx;
-
 	if (ctx->suspended)
 		return;
 
@@ -100,9 +98,8 @@ static void decon_wait_for_vblank(struct
 		DRM_DEV_DEBUG_KMS(ctx->dev, "vblank wait timed out.\n");
 }
 
-static void decon_clear_channels(struct exynos_drm_crtc *crtc)
+static void decon_clear_channels(struct decon_context *ctx)
 {
-	struct decon_context *ctx = crtc->ctx;
 	unsigned int win, ch_enabled = 0;
 
 	/* Check if any channel is enabled. */
@@ -118,7 +115,7 @@ static void decon_clear_channels(struct
 
 	/* Wait for vsync, as disable channel takes effect at next vsync */
 	if (ch_enabled)
-		decon_wait_for_vblank(ctx->crtc);
+		decon_wait_for_vblank(ctx);
 }
 
 static int decon_ctx_initialize(struct decon_context *ctx,
@@ -126,7 +123,7 @@ static int decon_ctx_initialize(struct d
 {
 	ctx->drm_dev = drm_dev;
 
-	decon_clear_channels(ctx->crtc);
+	decon_clear_channels(ctx);
 
 	return exynos_drm_register_dma(drm_dev, ctx->dev, &ctx->dma_priv);
 }


