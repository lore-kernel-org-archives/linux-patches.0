Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F85320A37;
	Wed, 30 Sep 2026 19:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797152; cv=none; b=uLrv52LPWcS0rFylYSbiGNMWd66RW0X6GObBxezXajvCXEVyeTtcN7xisWBncZoy4us53ZpR76owxfHTUKcS89FNDJJUGO7wIDCOCbw0X+Mj1cScGZ438BoOTIvZ1t5XtaXZTSc5hTmktbk+DDyRbsWQeFEZ1VhmkUiEJxwSAZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797152; c=relaxed/simple;
	bh=eXuiWV1A5neveCOD3KLbraqDwxUUj8qL621KGpXVk6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgjhgskxSOJ2+i7Gntze8+hgYvylPY3PRHH7CN8sATsHBMhNyJo5YOWyW8sTvCVqIftuHSE9VjwM34XAEwxA35A/YgYqRVaHT8HvN0Q2N04KxZCFf6WvkAQNKN75xZKJR1csGVn+qRzf7lCXOSSSl/wetZ0bDCjU8C3v/GV3MVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbDwrcd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbDwrcd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887DC1F000FF;
	Wed, 30 Sep 2026 19:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797151;
	bh=tRnKqq+TSore2QtmJ7P12OS9+aQenN9nP0Rpwmn7jWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HbDwrcd4rhZ40zW5sOHvR2GdvJR5QS04smGa1w6QLNDRP2wypVBFLck5FDcC0GHfL
	 UvzEAVlxzVRXiNhdsR09HQIwdKC5wiab5b+OkgYWTmMx6hG2wgFbnVyr/TGE7GU/Ki
	 7q+mRk9SVtwtxbaQOH6hWsDRh+GVhWIBJUMAWhxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1165/1193] drm/mediatek: Fix potential NULL dereference in mtk_crtc_destroy()
Date: Wed, 30 Sep 2026 17:30:49 +0200
Message-ID: <20260930152500.128230624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 4018651ba5c409034149f297d3dd3328b91561fd ]

In mtk_crtc_create(), if the call to mbox_request_channel() fails then we
set the "mtk_crtc->cmdq_client.chan" pointer to NULL.  In that situation,
we do not call cmdq_pkt_create().

During the cleanup, we need to check if the "mtk_crtc->cmdq_client.chan"
is NULL first before calling cmdq_pkt_destroy().  Calling
cmdq_pkt_destroy() is unnecessary if we didn't call cmdq_pkt_create() and
it will result in a NULL pointer dereference.

[ Backport to 6.6.y: used the older Mediatek CRTC file and helper names. ]

Fixes: 7627122fd1c0 ("drm/mediatek: Add cmdq_handle in mtk_crtc")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/cc537bd6-837f-4c85-a37b-1a007e268310@stanley.mountain/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index 859dffe451372..1e8052a0425ee 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -163,9 +163,8 @@ static void mtk_drm_crtc_destroy(struct drm_crtc *crtc)
 
 	mtk_mutex_put(mtk_crtc->mutex);
 #if IS_REACHABLE(CONFIG_MTK_CMDQ)
-	mtk_drm_cmdq_pkt_destroy(&mtk_crtc->cmdq_handle);
-
 	if (mtk_crtc->cmdq_client.chan) {
+		mtk_drm_cmdq_pkt_destroy(&mtk_crtc->cmdq_handle);
 		mbox_free_channel(mtk_crtc->cmdq_client.chan);
 		mtk_crtc->cmdq_client.chan = NULL;
 	}
-- 
2.53.0



