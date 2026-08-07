Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1947D2F5337;
	Fri,  7 Aug 2026 15:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115979; cv=none; b=r2D8FZB8yshWlNZZO/V+kwdLZMUIkGDMhy8GWatQ/XIknuvqZ1VYzWcT2K+A0aXOsnYHUE69qA68YDa/i4IH0dSoFWL+yepMcNWbvJDnhrZKjo1YYsu7MIZ/w+iM7uO5lFVYPWSkFyVpAin0qmrSHPmIpzt5ktQROnWsCfrWFqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115979; c=relaxed/simple;
	bh=2xwCZDrEAy3iMZ5FHEyI1yI4Hh4k5z4YfJVwJLrWGnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuvpNxTT3N++HEPYlsiDeQqtNxEdq9BF9Wzkfm649eAfyZqe2xVQoggnHbsm58tQ2NUAGHN7T/Xfxi0+J+yjI97glTAdPGEEesr9a7LkJuz6dILLd5foWDZqVoaQb7bj5osr+67dACk+X8N4bWne46sVes4gxByYLT+QCP+QaWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8ahKKtA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8ahKKtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA591F000E9;
	Fri,  7 Aug 2026 15:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115977;
	bh=GfMPihMoRft5HtpppiBlUf7Xah7GacvDmCc9ZgvuV3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8ahKKtAXhRjt4yEQLV41vo0DxfVapD8+mm8Z/bkt5/zs/B0q6+PcaFPp3EAodV3j
	 66zS/7Oy96bIxTDqzNeA4LDwS+Dk36jj0/0XFpV7A/H9NeI3X7usTtoScI3ghfL+dL
	 oOrBMKdeyZJA9mcVM/9Jj4z9jEScdeJpA/UrVvW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/261] drm/mediatek: Check CRTC state before freeing
Date: Fri,  7 Aug 2026 16:36:21 +0200
Message-ID: <20260807143415.892721965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
index 659112da47b69..859dffe451372 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -185,10 +185,10 @@ static void mtk_drm_crtc_reset(struct drm_crtc *crtc)
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



