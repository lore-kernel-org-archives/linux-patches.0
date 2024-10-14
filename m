Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16AB44C77;
	Mon, 14 Oct 2024 14:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917886; cv=none; b=ZPn9jscBOKom+gKr5Se5wg+2mSa7TlTo86d6F18//weFfTksQiC39MT+2hcvuhqld37yjYG4SbXnMyFWDFW5LRlJL0jwNzphyx/74wZ/XlQKf4uFIopwSFq2W9F1MguSQ+0mi8uz6bJZycc4GxkkbjQGHBibCR6ZkHqutmR5XNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917886; c=relaxed/simple;
	bh=OI5wV2QMBEEH/Q+IcC7vfwkJxoXg6OYtvXDKiJlPrHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2iU7X6YDu0M/h8syKUXpEIsIGc4eUsVlu86L7WPN2sv6MJJmePLDnd3Kn6KJ3cdKc/pCUWG9aA0Z3dxEKaD0uI14meUmCfcvmlNWcg5SJk6gfk4Mpx0LzfKDywf+2eFT8t+oIH9XBNWLLZ0MptIjf5Q2JDzkQLOxWMn7AvJE7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlAmPGzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlAmPGzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E18C4CEC7;
	Mon, 14 Oct 2024 14:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917885;
	bh=OI5wV2QMBEEH/Q+IcC7vfwkJxoXg6OYtvXDKiJlPrHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlAmPGzTXO3jxEG52sM0A28AUFeEGO9W2EOJWAfJdRFfxEce/SGC8nMmQRd2hqYe0
	 34DqG3cSH26o3akDtYgSqiH6J7Z96x18mMqXEcrFdcq8oqiTocCkJT3msiiKHqbP4Q
	 Eeecy0sM80laXiaAl+Tiy47iebvKrldsr+j5E7f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/798] drm/mediatek: Use spin_lock_irqsave() for CRTC event lock
Date: Mon, 14 Oct 2024 16:11:15 +0200
Message-ID: <20241014141222.674404971@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index e00c8e0a21027..aba26ec9a1425 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -444,6 +444,7 @@ static void mtk_crtc_ddp_hw_fini(struct mtk_drm_crtc *mtk_crtc)
 {
 	struct drm_device *drm = mtk_crtc->base.dev;
 	struct drm_crtc *crtc = &mtk_crtc->base;
+	unsigned long flags;
 	int i;
 
 	for (i = 0; i < mtk_crtc->ddp_comp_nr; i++) {
@@ -470,10 +471,10 @@ static void mtk_crtc_ddp_hw_fini(struct mtk_drm_crtc *mtk_crtc)
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



