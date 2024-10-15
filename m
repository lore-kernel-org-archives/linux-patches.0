Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD961D9A42;
	Tue, 15 Oct 2024 11:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992640; cv=none; b=ebyEszeAOESmHhR/kbBGyf0xJLpghBK0QfGJAU2wD5CWg9Gn7yWK4Qh0RSQg7vn8s6npchaRFaAwAkAJJYgBfHRYYAMA+FnyBif/TUxQpGDw6FRghJS5N97U+wjFSuW21C2jewWR9NuQNr+RfYDCU1px0PbgVyC11JuWF3VIZMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992640; c=relaxed/simple;
	bh=FhbP/fHI76ij+EB8Lqo43qseyGGZ4fXF96faT+UmakE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlpFuakrwxjUihvQGTKZ5/70eFcC/5kxoB8TOr55mJ1gFeMQRuyzoZlb9RIuhkcvE4kDCqVWI82wsrcJu8y66YO9OXioR7ZVXLSqSBRzF15Pa+WANAzNylxk6HfzDLlMi/sAlCp9+vZ0b0ihYfTM21Tqsu8yInioiM224kqaep4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/X2fnSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/X2fnSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E087C4CEC6;
	Tue, 15 Oct 2024 11:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992640;
	bh=FhbP/fHI76ij+EB8Lqo43qseyGGZ4fXF96faT+UmakE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/X2fnSXQSwckjbCVBMgogXhPQcUNeIYRSMWNiou22Yi+dVO2OGxSZ0Oiiz9b8Qpy
	 8pZFphotP1xuRteAqFPl9vHIkRfkjx2TNhtrks7M8Scn4RMcFUvUCdiYCAJdnkTOSj
	 k173Qc0xxAWFC09rV0NoyUplGZWxxnXZpQgJ5880=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 174/691] drm/mediatek: Use spin_lock_irqsave() for CRTC event lock
Date: Tue, 15 Oct 2024 13:22:02 +0200
Message-ID: <20241015112447.271678690@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index 1a038fa004668..27f3e91425580 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -386,6 +386,7 @@ static void mtk_crtc_ddp_hw_fini(struct mtk_drm_crtc *mtk_crtc)
 {
 	struct drm_device *drm = mtk_crtc->base.dev;
 	struct drm_crtc *crtc = &mtk_crtc->base;
+	unsigned long flags;
 	int i;
 
 	for (i = 0; i < mtk_crtc->ddp_comp_nr; i++) {
@@ -412,10 +413,10 @@ static void mtk_crtc_ddp_hw_fini(struct mtk_drm_crtc *mtk_crtc)
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



