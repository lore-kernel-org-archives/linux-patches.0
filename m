Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5C81D2F6E;
	Wed,  2 Oct 2024 14:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877794; cv=none; b=L20VlKVPB7IwF0KtQL0y3a9pIQI77TOGOVJH7TF2+lN7p+KeDakd0NhsJZ+guD8+Q0xPJu3nGv/Z4pGuUHJGBkUPjWtKv1d9TSbpqA4O9LqV0SJefiSTUJoTFZ5zRKaf8xK1Vj/9NKuG/BcxhVeI+vBr+pdxW7QQqDKvJnPOrLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877794; c=relaxed/simple;
	bh=FycatTYOxYEIiq6k4+Qr1RXD6uzTaK/qDwDmRtWcxdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVQ4gaAt5X6uIAmc7/QDQSyPA37PF+UYYGybqR2VeWSkiMAZ7ZsJAAEVL7j3OMSuPeuf54qXG/VS32Xgxm94faooG/G1SzOktM5b4kpEMkPFNyK32zZzQJhyxVTBnjKe+YzKOEzJ9ayNM2YW9uj/dNFRhSMz6kTh7MKknH4UjwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pd7MZHpS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pd7MZHpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5BDC4CED4;
	Wed,  2 Oct 2024 14:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877793;
	bh=FycatTYOxYEIiq6k4+Qr1RXD6uzTaK/qDwDmRtWcxdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pd7MZHpSLjnX5wwg03vRIWWcxg/VmgYHx1tRtK7mHagR/DRBsbG1AAjFdVT1nsRKQ
	 zlHLNhb4epSNA2jv1arpyPEKSSgE1K4szX94KimW67tUhKJU//sffn/EV7EBrbmWiE
	 XeGiE9wJRgqYQvYQGyqTG7QeB1PkFTvEkTWjqXcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 195/634] drm/mediatek: Use spin_lock_irqsave() for CRTC event lock
Date: Wed,  2 Oct 2024 14:54:55 +0200
Message-ID: <20241002125818.802068424@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fei Shao <fshao@chromium.org>

[ Upstream commit be03b30b7aa99aca876fbc7c1c1b73b2d0339321 ]

Use the state-aware spin_lock_irqsave() and spin_unlock_irqrestore()
to avoid unconditionally re-enabling the local interrupts.

Fixes: 411f5c1eacfe ("drm/mediatek: handle events when enabling/disabling crtc")
Signed-off-by: Fei Shao <fshao@chromium.org>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240828101511.3269822-1-fshao@chromium.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_crtc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_crtc.c b/drivers/gpu/drm/mediatek/mtk_crtc.c
index d7f0926f896d6..a90504359e8d2 100644
--- a/drivers/gpu/drm/mediatek/mtk_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_crtc.c
@@ -467,6 +467,7 @@ static void mtk_crtc_ddp_hw_fini(struct mtk_crtc *mtk_crtc)
 {
 	struct drm_device *drm = mtk_crtc->base.dev;
 	struct drm_crtc *crtc = &mtk_crtc->base;
+	unsigned long flags;
 	int i;
 
 	for (i = 0; i < mtk_crtc->ddp_comp_nr; i++) {
@@ -498,10 +499,10 @@ static void mtk_crtc_ddp_hw_fini(struct mtk_crtc *mtk_crtc)
 	pm_runtime_put(drm->dev);
 
 	if (crtc->state->event && !crtc->state->active) {
-		spin_lock_irq(&crtc->dev->event_lock);
+		spin_lock_irqsave(&crtc->dev->event_lock, flags);
 		drm_crtc_send_vblank_event(crtc, crtc->state->event);
 		crtc->state->event = NULL;
-		spin_unlock_irq(&crtc->dev->event_lock);
+		spin_unlock_irqrestore(&crtc->dev->event_lock, flags);
 	}
 }
 
-- 
2.43.0



