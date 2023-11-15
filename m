Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCFC3DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CkT+hINx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075C6C433C9;
	Wed, 15 Nov 2023 19:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078188;
	bh=OkDdJTNBc61j8SSbAVkt777l6QR3IcwPYqbknpwLPUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkT+hINxlT79e1lV5IUy0WSVGPzYe5pbKLi8DHvofF3n2gUUCDtl/XHQcy/n1Rqnr
	 WUuQvOvg71dC3TULe47q6YY/e8EywiqINeS3lr34gg2J3Vs+NMEiZNCUyNrYfNbyfr
	 DAY9IaYqgd1+UpxW5ywfE+xPrgOzMXa+Ad8B4x8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/379] drm/mediatek: Fix iommu fault by swapping FBs after updating plane state
Date: Wed, 15 Nov 2023 14:23:36 -0500
Message-ID: <20231115192653.461010457@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Jason-JH.Lin <jason-jh.lin@mediatek.com>

[ Upstream commit 3ec71e05ae6e7f46512e568ed81c92be589003dd ]

According to the comment in drm_atomic_helper_async_commit(),
we should make sure FBs have been swapped, so that cleanups in the
new_state performs a cleanup in the old FB.

So we should move swapping FBs after calling mtk_plane_update_new_state(),
to avoid using the old FB which could be freed.

Fixes: 1a64a7aff8da ("drm/mediatek: Fix cursor plane no update")
Signed-off-by: Jason-JH.Lin <jason-jh.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20230809125722.24112-2-jason-jh.lin@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_plane.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_plane.c b/drivers/gpu/drm/mediatek/mtk_drm_plane.c
index 2f5e007dd3800..c4a0203d17e38 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_plane.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_plane.c
@@ -157,9 +157,9 @@ static void mtk_plane_atomic_async_update(struct drm_plane *plane,
 	plane->state->src_y = new_state->src_y;
 	plane->state->src_h = new_state->src_h;
 	plane->state->src_w = new_state->src_w;
-	swap(plane->state->fb, new_state->fb);
 
 	mtk_plane_update_new_state(new_state, new_plane_state);
+	swap(plane->state->fb, new_state->fb);
 	wmb(); /* Make sure the above parameters are set before update */
 	new_plane_state->pending.async_dirty = true;
 	mtk_drm_crtc_async_update(new_state->crtc, plane, state);
-- 
2.42.0



