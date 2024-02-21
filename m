Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D10F69962;
	Wed, 21 Feb 2024 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525074; cv=none; b=iYNeySWuwpbXwv5k2lhvsM9p+iHBBnPZUgmZ6bX3y2WHVZSXUC2CzpOFSPPbXKK+nHYiCOaWvw8FNdZpLZl9cjzqIfAOneDG7o8MlAAHmP23gZb0lq0sWEt8D4Z1bHUQSFE+czbkfpVbvG/N9cGRYv2wXoTKPYe/b7rbibqKsBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525074; c=relaxed/simple;
	bh=KJwSdWXVXUybMgll1kA3gG4a9fjZJ5jBQp+muUUmiGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrphNU+m5eccqhbZ0I75+WQ0fswIocw2JLsjfWr+Cx+P74PL/O+WaL6Cccwki+t9Qs9IfbEF+I0GLApHyJz/QJTq7A8ug5pUzgW8w35tr1clJ2QQ/uuaGjWsZJpZqzdfjg7HAIJw8uZmNo9xFa1CXEV/QJmQJsqrshQcN5lF8CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ssm/yc40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ssm/yc40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943CCC43390;
	Wed, 21 Feb 2024 14:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525074;
	bh=KJwSdWXVXUybMgll1kA3gG4a9fjZJ5jBQp+muUUmiGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ssm/yc40dBeoLowhmeGiJQFUMAwUK8sF0/bkqAQZXcpdDB+t2Ne7SDHgb+XLMTWjn
	 BN9HJC1ufanBtaD1nq4kXutcCw2TqFY/c0AXkEhCsaXKj1Hux83FSD16T47NlyNZ2x
	 UdeDrbFNuiVKi3QxnvEqkP+RgEp6+1VEbF8oQI58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/267] drm/exynos: fix accidental on-stack copy of exynos_drm_plane
Date: Wed, 21 Feb 2024 14:06:35 +0100
Message-ID: <20240221125941.704205027@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1061430aced2..78c934a21bd7 100644
--- a/drivers/gpu/drm/exynos/exynos5433_drm_decon.c
+++ b/drivers/gpu/drm/exynos/exynos5433_drm_decon.c
@@ -318,9 +318,9 @@ static void decon_win_set_bldmod(struct decon_context *ctx, unsigned int win,
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
index 34e6b22173fa..4fe4ca41665b 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -637,9 +637,9 @@ static void fimd_win_set_bldmod(struct fimd_context *ctx, unsigned int win,
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



