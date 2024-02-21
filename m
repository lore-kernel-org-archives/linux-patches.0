Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755F57E777;
	Wed, 21 Feb 2024 13:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523991; cv=none; b=lNWjkVUCq+ThonHmywwsLjOhtAP79nC0Z6xesD5bKF1KxZ4E+5e95AauRMV/6F+sRg+g8L9QkCmrdIlf2/9wUKuQnjMmY4cz9dBVNwDdLmSd7+YPmLUjjTzIGbWcB5Hqr0/yoSdS/lQ7RxvjP//LDK8qi2+z5MVeOVpUEx7Fx94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523991; c=relaxed/simple;
	bh=Dhbk9KsJVh1bu9sDaO5nqkgRTi4Tgnk2O88N6QOXom8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFhA0FVvwapg1EkxphpMFGCe9+qDsq+AmJczKCZ7VATOaqmMjw+CJTyPFu+zV6qqHUUMyqPHBpThxStkQFd/LWq0ZvIwlR/SL1d6JY6uTribxQRbRyxOIKfk3+3I/Uo51bSGyi3QM3395UEILpM5PcjX3YPcSWstx4juNzMaF/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsDiCUUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsDiCUUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C17EC433C7;
	Wed, 21 Feb 2024 13:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523991;
	bh=Dhbk9KsJVh1bu9sDaO5nqkgRTi4Tgnk2O88N6QOXom8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsDiCUUCP4tQZrgZpOchBdTG4BNU4zfRMcwYSf8W2kKcLwMGZ44etxm9Dmr8a7n2Q
	 Tz6sJRgQVY3jF/GTag1d/YIBnhb9Og6vzNwshN8qlml76Qpv5OA+cA+U1RbvZdy9fF
	 EYVQSRzHkXH+uLBDfKeuwPDBRE6XlBJkNl6akTdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/379] drm/exynos: fix accidental on-stack copy of exynos_drm_plane
Date: Wed, 21 Feb 2024 14:04:33 +0100
Message-ID: <20240221125957.684569544@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c277d2fc50c6..e43dfea09527 100644
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
index bb67cad8371f..c045330f9c48 100644
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



