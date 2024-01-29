Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8784E15956D;
	Mon, 29 Jan 2024 17:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548396; cv=none; b=VoaIzo0aeJSsJnYe1rWQYUezFy5YSF6lhXbbv7IHtbCPR9PhXEIvIqvJyXw5q+37lmKRDeh282s5LJ769acGvQUPVX++2bXK6W9cjIrSqoszA4kJyhQtqQBa/Qfw2tmMH26exYyMYOEjARfahQKKWYCR6kJfzqWidcFboaU6el0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548396; c=relaxed/simple;
	bh=TpNoPv3nCSU9QythnbneCv28oicqznz5sbMGs2LOG7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdZAjK9wt3vqVe/3xQr60yCDtqC9SdFZoVGxIqmQ+iYdGRUNBNV0g8uqs3Xw5JluyZ9TJV2uBpfa42+WPtHKrTIechir8GrfYtG+dvTOVranjlnXluKENXHRwNmiiQ8fL1Krp86lDpibikdDghqjGDJeLtakUcc3aF0g9852fgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikfBhobc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikfBhobc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B64C433F1;
	Mon, 29 Jan 2024 17:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548396;
	bh=TpNoPv3nCSU9QythnbneCv28oicqznz5sbMGs2LOG7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikfBhobcnuJ5pnxtSA0CwyoY7/WqIdQjnQGAp+CsDdH3Ipqo4i9MvYlU2XJhLozMa
	 MoLcfNr4Vp2Ckhy3FyBRntIHHs2xILIO1jS+mJ4T5XQM/TZ52EeKQCdkBRe+ilfr8s
	 S01CTRrtOMyeVxe4/x4BrX454Ui1fVK1VGW9HQV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/185] drm/exynos: fix accidental on-stack copy of exynos_drm_plane
Date: Mon, 29 Jan 2024 09:06:13 -0800
Message-ID: <20240129170004.148259556@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8155d7e650f1..4bc5d9470acd 100644
--- a/drivers/gpu/drm/exynos/exynos5433_drm_decon.c
+++ b/drivers/gpu/drm/exynos/exynos5433_drm_decon.c
@@ -319,9 +319,9 @@ static void decon_win_set_bldmod(struct decon_context *ctx, unsigned int win,
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
index ae6636e6658e..529033b980b2 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -662,9 +662,9 @@ static void fimd_win_set_bldmod(struct fimd_context *ctx, unsigned int win,
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



