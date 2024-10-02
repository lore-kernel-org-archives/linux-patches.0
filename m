Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB861474BC;
	Wed,  2 Oct 2024 14:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879541; cv=none; b=aiyKpEg8a5ylfppM/lLLVDSaaxE1kKvOlhkkLrzVrckZq7Ymdf2w+Ktd0C/aDnoMyO08zdUBdK2wbobGjMYaXjXoGPUj/y9p6KMJVfqtyeP4oy+am9xVzDeYPwKbVtxkgaKDqxPbAop6jH6f9n6Q9OfeMhD1WF2/yO/9zjYR1E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879541; c=relaxed/simple;
	bh=x8bIje8Q/FQw7eKMSU494be7wqaIruLit8g1tKgdix4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWKSH3/ZoGg8paG30rtnKbs2h+zpjqR9QvimUMQsj/oCE0IBDbGP4jBjKo074TmilCnDJ9bBojwFFnOywNsdqU3+KvxLDWenvR4qN16oaxJVH7/dh8sjEs5C9wOBmHdavqgicSb2NioEOJmu91iglQY8c6IKZmQC5eHpf8s15Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjtKwyH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjtKwyH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12A5C4CEC2;
	Wed,  2 Oct 2024 14:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879541;
	bh=x8bIje8Q/FQw7eKMSU494be7wqaIruLit8g1tKgdix4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjtKwyH806/KSdxIQLowo38/qlVmyxtK5jMKPrL8ZbaDw2oQcYOouIRjcxVpp8uVf
	 7bAPqlzh3UnBAv/5PMBj0ridacHDpIqlQy45F+1coLdIiD5VN+SpvYscnDk8bWuL4O
	 oLm1JavCB9o3ZxmF5+idfXUNbwiRU4hnM4RjhaWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/538] drm/mediatek: Use spin_lock_irqsave() for CRTC event lock
Date: Wed,  2 Oct 2024 14:56:33 +0200
Message-ID: <20241002125758.333055928@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5a1c8b26f1bb1..659112da47b69 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -450,6 +450,7 @@ static void mtk_crtc_ddp_hw_fini(struct mtk_drm_crtc *mtk_crtc)
 {
 	struct drm_device *drm = mtk_crtc->base.dev;
 	struct drm_crtc *crtc = &mtk_crtc->base;
+	unsigned long flags;
 	int i;
 
 	for (i = 0; i < mtk_crtc->ddp_comp_nr; i++) {
@@ -481,10 +482,10 @@ static void mtk_crtc_ddp_hw_fini(struct mtk_drm_crtc *mtk_crtc)
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



