Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0324D5BA;
	Wed, 21 Feb 2024 13:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522368; cv=none; b=j48vaxmILa/ifn6Ii75JkQg8m1F5Sre0Up7eEw+8r+9OiZDmsn1rL7xdkwmfLdEhNwnPRyUe4OA1vHDNUvSQ7SKE+yjV3bAxeFLbwFHa0CNHP9u+yZPrVCQ1rL4mhnnEo9rn1V1Ddw+4MH0f9vzkghUKRLYKcwyN/2WZ0tEo6DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522368; c=relaxed/simple;
	bh=2Vl9XYEeTd18ofx6UKl/6gJE40BlZ50gBRd171tqqe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fk+lbiJJgEruH+W9+yf79edD8OuDL84r/B645iWYfKwp5UVft/Pb7NLZijaUVHtJB6rga9UZuJR5WKSVfbH2QQXexrJSAxSFnJ+ZcbAMhm0I1F1ZR3jTnF4QwvRBdkCT2vMeX64STRJE/H2S02wetE+oDIadeP39Q9POinxEQqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e79HuJ31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e79HuJ31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F414C433C7;
	Wed, 21 Feb 2024 13:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522368;
	bh=2Vl9XYEeTd18ofx6UKl/6gJE40BlZ50gBRd171tqqe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e79HuJ31sxoYvHDeWpsQnfQdDohev3r0ITx+s4ERAY+m3HvpCwwR9PrWOpqGE+pDj
	 Hwg4sTxDx0uPrTXmQi6vmlpUWlteamRj2zQAVyeXB8gRDPy63egjUK9HEXFsO4KdmX
	 2+erA86kzo0/PHKgpFjAGBVmUK0Js3OotSMw4ZIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/476] drm/exynos: fix accidental on-stack copy of exynos_drm_plane
Date: Wed, 21 Feb 2024 14:02:48 +0100
Message-ID: <20240221130012.312827593@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 960b537e91725bcb17dd1b19e48950e62d134078 ]

gcc rightfully complains about excessive stack usage in the fimd_win_set_pixfmt()
function:

drivers/gpu/drm/exynos/exynos_drm_fimd.c: In function 'fimd_win_set_pixfmt':
drivers/gpu/drm/exynos/exynos_drm_fimd.c:750:1: error: the frame size of 1032 bytes is larger than 1024 byte
drivers/gpu/drm/exynos/exynos5433_drm_decon.c: In function 'decon_win_set_pixfmt':
drivers/gpu/drm/exynos/exynos5433_drm_decon.c:381:1: error: the frame size of 1032 bytes is larger than 1024 bytes

There is really no reason to copy the large exynos_drm_plane
structure to the stack before using one of its members, so just
use a pointer instead.

Fixes: 6f8ee5c21722 ("drm/exynos: fimd: Make plane alpha configurable")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos5433_drm_decon.c | 4 ++--
 drivers/gpu/drm/exynos/exynos_drm_fimd.c      | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos5433_drm_decon.c b/drivers/gpu/drm/exynos/exynos5433_drm_decon.c
index b5001db7a95c..2f6a5995b53f 100644
--- a/drivers/gpu/drm/exynos/exynos5433_drm_decon.c
+++ b/drivers/gpu/drm/exynos/exynos5433_drm_decon.c
@@ -317,9 +317,9 @@ static void decon_win_set_bldmod(struct decon_context *ctx, unsigned int win,
 static void decon_win_set_pixfmt(struct decon_context *ctx, unsigned int win,
 				 struct drm_framebuffer *fb)
 {
-	struct exynos_drm_plane plane = ctx->planes[win];
+	struct exynos_drm_plane *plane = &ctx->planes[win];
 	struct exynos_drm_plane_state *state =
-		to_exynos_plane_state(plane.base.state);
+		to_exynos_plane_state(plane->base.state);
 	unsigned int alpha = state->base.alpha;
 	unsigned int pixel_alpha;
 	unsigned long val;
diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index c735e53939d8..f25e112a92ed 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -644,9 +644,9 @@ static void fimd_win_set_bldmod(struct fimd_context *ctx, unsigned int win,
 static void fimd_win_set_pixfmt(struct fimd_context *ctx, unsigned int win,
 				struct drm_framebuffer *fb, int width)
 {
-	struct exynos_drm_plane plane = ctx->planes[win];
+	struct exynos_drm_plane *plane = &ctx->planes[win];
 	struct exynos_drm_plane_state *state =
-		to_exynos_plane_state(plane.base.state);
+		to_exynos_plane_state(plane->base.state);
 	uint32_t pixel_format = fb->format->format;
 	unsigned int alpha = state->base.alpha;
 	u32 val = WINCONx_ENWIN;
-- 
2.43.0



