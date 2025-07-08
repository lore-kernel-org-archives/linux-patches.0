Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AC02E659;
	Tue,  8 Jul 2025 16:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992004; cv=none; b=pdng17cY70EBuhYqKFAJwU2Yieoqo/bp/5KoSM7xPBt1r5v0pleIFWqLrMRW3dkLw9vK0tt/UM3DlPb9Ngd2b4SG/VvlNi0n4j8StsUu2AYIsqkrMzd+7KIiRdjzUlduPDW3PBmY4tq96BZ8Ss8mEyKsBw7J9PKG7iFa0Mzq7IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992004; c=relaxed/simple;
	bh=3FDB5FCdqpP4n/slqYxn4oZDOGdxQ+H6YyJWOgyJu6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDOZxDHjL1CggrI+EPQWsGgpwT1T1ADEZafrRL7RzZ8SjGrkhgaYj4OHmzVkjmUbDSKHZ6E0gczGpLyOwnlp414am5QC8j58gtHQU+FGkPHsKzUog15kc0RhRT496XLZp4uz/qa1sLdxLulF7+CmVXVGpIBl+yH8gD4qVrEzWsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSnRQ+bZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSnRQ+bZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3941EC4CEED;
	Tue,  8 Jul 2025 16:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992004;
	bh=3FDB5FCdqpP4n/slqYxn4oZDOGdxQ+H6YyJWOgyJu6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iSnRQ+bZZXFNNS9DIaIqrYCc3vS9KoXgCDWdbLOEtHzmiLGnNNFbD2o3kelc/BcmT
	 l5+or02zcyQmTdsioim3rpMBsndWC9xBMZSv+EWs/xfugdZsXFrGdCpz3hc9mvf7uJ
	 EVIdOY11biB8Q8HVxyutnWwvGiUZIxkH02G15ibQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 29/81] drm/exynos: fimd: Guard display clock control with runtime PM calls
Date: Tue,  8 Jul 2025 18:23:21 +0200
Message-ID: <20250708162225.866836027@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 5d91394f236167ac624b823820faf4aa928b889e ]

Commit c9b1150a68d9 ("drm/atomic-helper: Re-order bridge chain pre-enable
and post-disable") changed the call sequence to the CRTC enable/disable
and bridge pre_enable/post_disable methods, so those bridge methods are
now called when CRTC is not yet enabled.

This causes a lockup observed on Samsung Peach-Pit/Pi Chromebooks. The
source of this lockup is a call to fimd_dp_clock_enable() function, when
FIMD device is not yet runtime resumed. It worked before the mentioned
commit only because the CRTC implemented by the FIMD driver was always
enabled what guaranteed the FIMD device to be runtime resumed.

This patch adds runtime PM guards to the fimd_dp_clock_enable() function
to enable its proper operation also when the CRTC implemented by FIMD is
not yet enabled.

Fixes: 196e059a8a6a ("drm/exynos: convert clock_enable crtc callback to pipeline clock")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 529033b980b20..0816714b1e581 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -188,6 +188,7 @@ struct fimd_context {
 	u32				i80ifcon;
 	bool				i80_if;
 	bool				suspended;
+	bool				dp_clk_enabled;
 	wait_queue_head_t		wait_vsync_queue;
 	atomic_t			wait_vsync_event;
 	atomic_t			win_updated;
@@ -1048,7 +1049,18 @@ static void fimd_dp_clock_enable(struct exynos_drm_clk *clk, bool enable)
 	struct fimd_context *ctx = container_of(clk, struct fimd_context,
 						dp_clk);
 	u32 val = enable ? DP_MIE_CLK_DP_ENABLE : DP_MIE_CLK_DISABLE;
+
+	if (enable == ctx->dp_clk_enabled)
+		return;
+
+	if (enable)
+		pm_runtime_resume_and_get(ctx->dev);
+
+	ctx->dp_clk_enabled = enable;
 	writel(val, ctx->regs + DP_MIE_CLKCON);
+
+	if (!enable)
+		pm_runtime_put(ctx->dev);
 }
 
 static const struct exynos_drm_crtc_ops fimd_crtc_ops = {
-- 
2.39.5



