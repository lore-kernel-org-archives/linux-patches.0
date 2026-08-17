Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778AF3EC2CD;
	Mon, 17 Aug 2026 15:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979828; cv=none; b=AqRWbhyfoUZrTXlW94xlee7ac/J6hNden9iB2BVk9AmtpAtgjuNmVNDE/k/9iGh8U7Vr+c7RQ7cSjBqj1VuGY9X/qY3qeTY0/ZLKUpUuRBcKvAcFbM/RMwYDinj1PmM6q7m3En2HVj4uEwhyt/gtQGSR6dfk4NBvwhXG6/wviBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979828; c=relaxed/simple;
	bh=Z+3K/ONnjecoPd/U7Otu+pNQGFPaHssVG9dT0h+oOWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZx35MQjii95ehP9+U6GQ4EWRL1n0b7uDF/Lc149cYb10mU1nM5Jba8YSaqhu+yxIwIW8bmZvvxfLI9DGkXPpceuCRzr519tOGZPB9EyIOB9T4H7cYS0jrjd93qoHtjRCbPEpmCuwjOHj3WY+yj56WT6xwdZu6iXNT+UXV0xQEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6BnZPSB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6BnZPSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16DC1F00A3A;
	Mon, 17 Aug 2026 15:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979827;
	bh=PA6SbF+yZBqB1opz/r+mvtQtFU5wqWrPaDdqZuaq7H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6BnZPSBAllZ2uLOiKv6Gu5YC+fXGiZBlGOoQSvbeKcbZPpoCG31V8X1hsPyzG2SB
	 0Na6uu9jUIZO3ic4guOFkDmjEH2gM4iQPMYq13/+63q0TMY3HEUygvGtjIdXkeU8nd
	 oInleHP77ErB7CX46N+MlYUhfiZWXUJkyjsaBFyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 322/609] drm/mediatek: Check CRTC state before freeing
Date: Mon, 17 Aug 2026 15:30:18 +0200
Message-ID: <20260817132555.003831257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 233a4d3a39fc1585f5e271b2adab43c6af025ae0 ]

mtk_crtc_reset() destroys the current CRTC state only when crtc->state
is non-NULL, but it always converts crtc->state to struct mtk_crtc_state
and passes the result to kfree().

When reset is called without an existing state, container_of(NULL, ...)
does not produce NULL. Keep the mtk state free in the same crtc->state
guard as the helper state destruction.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 2d267b81898e ("drm/mtk: Use __drm_atomic_helper_crtc_reset")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20260707150528.2270739-1-ruoyuw560@gmail.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index aba26ec9a1425..59b310f7327c8 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -183,10 +183,10 @@ static void mtk_drm_crtc_reset(struct drm_crtc *crtc)
 {
 	struct mtk_crtc_state *state;
 
-	if (crtc->state)
+	if (crtc->state) {
 		__drm_atomic_helper_crtc_destroy_state(crtc->state);
-
-	kfree(to_mtk_crtc_state(crtc->state));
+		kfree(to_mtk_crtc_state(crtc->state));
+	}
 	crtc->state = NULL;
 
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
-- 
2.53.0



