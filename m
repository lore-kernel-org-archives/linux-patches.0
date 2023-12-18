Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975EB37883;
	Mon, 18 Dec 2023 14:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRuhg8hI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDBCC433C8;
	Mon, 18 Dec 2023 14:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908319;
	bh=hEOgg5hc+x9KbQ8aB9+CABH2yPTUxd1t7cvHSODWjk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRuhg8hIMVb27Gfd1ttPKA3kGev8my7SV/5hK2jOvHczzxol11nbOWNuiJc8tlPG4
	 XijBjJYqJY6blnUKZTmqAkNuCoMVnNkH0PbaUt8XVG6i2pm1D1VAhM6vl/rEFkQ1gs
	 MytH4szD4pndTRy4zpIWrPFuFO/28IoPmVm4jbcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Lee <stuart.lee@mediatek.com>,
	AngeloGioacchino DEl Regno <angelogioacchino.delregno@collabora.com>,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.6 134/166] drm/mediatek: Fix access violation in mtk_drm_crtc_dma_dev_get
Date: Mon, 18 Dec 2023 14:51:40 +0100
Message-ID: <20231218135111.080041709@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Stuart Lee <stuart.lee@mediatek.com>

commit b6961d187fcd138981b8707dac87b9fcdbfe75d1 upstream.

Add error handling to check NULL input in
mtk_drm_crtc_dma_dev_get function.

While display path is not configured correctly, none of crtc is
established. So the caller of mtk_drm_crtc_dma_dev_get may pass
input parameter *crtc as NULL, Which may cause coredump when
we try to get the container of NULL pointer.

Fixes: cb1d6bcca542 ("drm/mediatek: Add dma dev get function")
Signed-off-by: Stuart Lee <stuart.lee@mediatek.com>
Cc: stable@vger.kernel.org
Reviewed-by: AngeloGioacchino DEl Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Macpaul Lin <macpaul.lin@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20231110012914.14884-2-stuart.lee@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -885,7 +885,14 @@ static int mtk_drm_crtc_init_comp_planes
 
 struct device *mtk_drm_crtc_dma_dev_get(struct drm_crtc *crtc)
 {
-	struct mtk_drm_crtc *mtk_crtc = to_mtk_crtc(crtc);
+	struct mtk_drm_crtc *mtk_crtc = NULL;
+
+	if (!crtc)
+		return NULL;
+
+	mtk_crtc = to_mtk_crtc(crtc);
+	if (!mtk_crtc)
+		return NULL;
 
 	return mtk_crtc->dma_dev;
 }


