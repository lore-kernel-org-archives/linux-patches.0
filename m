Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14B73074AC;
	Mon, 27 Oct 2025 19:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592239; cv=none; b=SWO4F8dtDg8ofvVmBsB/G8NVUqxfaJ18QmoynwJz3xjl4HJgn/tXYIz/BHdnmfJr9UqpTQicwWdZQAoEbpQ/3cbcO+dbxUZw9kzMD27/RD26n8Vycdbx5NIre6NK0Ck7Xp097R5zc6C7RQTKtXPO4ZHChhzscfpW5GoVa8OeuM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592239; c=relaxed/simple;
	bh=s0v90wifCFchSXyIw1JCGGLhKiLQqN2RIgbla+zE2C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glx/C1dWfaoFvc8F9y1BztVjkeYkyPfwqUWSu5jTREX/+uRYN9Prr25tPrS9te7PaZyixQY2gDs1+RZ5gFkpaHcbNXQi5cQstgX2RH/Jd205Nz5kIDb1MYjcyTZfPC6VgCcnxpN1lD56sfN5sJY2gJDVV8PLSDQq38R5He6aJ0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/40FfQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/40FfQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C2DC4CEF1;
	Mon, 27 Oct 2025 19:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592239;
	bh=s0v90wifCFchSXyIw1JCGGLhKiLQqN2RIgbla+zE2C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/40FfQ2Rp6MuZFvuMWaxZbTrhC1okTvaP9YO/CZWAPvrS6oRpu4Pxwfu14SPiRX3
	 fKZQqodqjjhEUVpkRIflb3DMAmeW5WKE7UJ8B4i8QKS5BuUQjVP+t+uAF1l27AiV+b
	 gSmDQ65Xv8+rc0pMFdFsT8B0cyXSiHFbfGxLVSjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/157] drm/exynos: exynos7_drm_decon: fix uninitialized crtc reference in functions
Date: Mon, 27 Oct 2025 19:34:35 +0100
Message-ID: <20251027183501.647134876@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -82,10 +82,8 @@ static const enum drm_plane_type decon_w
 	DRM_PLANE_TYPE_CURSOR,
 };
 
-static void decon_wait_for_vblank(struct exynos_drm_crtc *crtc)
+static void decon_wait_for_vblank(struct decon_context *ctx)
 {
-	struct decon_context *ctx = crtc->ctx;
-
 	if (ctx->suspended)
 		return;
 
@@ -101,9 +99,8 @@ static void decon_wait_for_vblank(struct
 		DRM_DEV_DEBUG_KMS(ctx->dev, "vblank wait timed out.\n");
 }
 
-static void decon_clear_channels(struct exynos_drm_crtc *crtc)
+static void decon_clear_channels(struct decon_context *ctx)
 {
-	struct decon_context *ctx = crtc->ctx;
 	unsigned int win, ch_enabled = 0;
 
 	/* Check if any channel is enabled. */
@@ -119,7 +116,7 @@ static void decon_clear_channels(struct
 
 	/* Wait for vsync, as disable channel takes effect at next vsync */
 	if (ch_enabled)
-		decon_wait_for_vblank(ctx->crtc);
+		decon_wait_for_vblank(ctx);
 }
 
 static int decon_ctx_initialize(struct decon_context *ctx,
@@ -127,7 +124,7 @@ static int decon_ctx_initialize(struct d
 {
 	ctx->drm_dev = drm_dev;
 
-	decon_clear_channels(ctx->crtc);
+	decon_clear_channels(ctx);
 
 	return exynos_drm_register_dma(drm_dev, ctx->dev, &ctx->dma_priv);
 }


