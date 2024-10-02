Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71CB29CE7;
	Wed,  2 Oct 2024 13:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875870; cv=none; b=jnimagPLzLTPygIhRKGhNrb75seG0Jh165NlGtRUKKp0yn+AEPUTrLEh1BZucBW7AZ40oEscJ+cmUF0paWPJqqyLYoc4VcSdZkGiWcENLcjw/UTkiFpx93xA1RrhCNXOay9DiaUTtJCZJOn6rWJv28yCWtuhiLbuoxbicOfdv8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875870; c=relaxed/simple;
	bh=RqEMeUhb/k37Bf2xXxD/LhJUKboGVtPKldI0KlXcdzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdSYebBrf5vTbf6dywA0cE8yVAthb3WZmJe69/f9/S70jjSjtCztl6NY9eJ9X9oQkILTXoSGzm5qtwTfZKpRywYMDJN31ca+wISbgleyg+jIVEPSckKi3kXoE9H5Vea78mU2/1wmO6Lp7NccLkLTrZ8Jh7BrYkPj200+7/S0pB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slRpU5Xs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slRpU5Xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8AAC4CEC5;
	Wed,  2 Oct 2024 13:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875870;
	bh=RqEMeUhb/k37Bf2xXxD/LhJUKboGVtPKldI0KlXcdzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slRpU5XsCWQ+Nj1QydEBBOqWCfgjvJeWc0T8DirRZGSbBzjyPMxCyNf2arCZ4Y8XK
	 J2kf/bXrMDWXen9I+vPT2LhmK+wiSk7gudUr+uv9YNm8UM+sFSEVdEvrLDAxJqyGZj
	 eiuJllDL3R6W/Oj+miaMlolP5cIH2iqSAegWagQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 222/695] drm/mediatek: Use spin_lock_irqsave() for CRTC event lock
Date: Wed,  2 Oct 2024 14:53:40 +0200
Message-ID: <20241002125831.319504294@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



