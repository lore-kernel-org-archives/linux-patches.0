Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73397C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCBEC433D2;
	Mon, 24 Apr 2023 13:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343119;
	bh=H32sTgX9vqAPxCmefmZDXQ3k5KLYCVqgbjxNg/JxO/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oysg+KoNdNvm+UXZW39JGwlkwGEUnNHGXKpg5ktKZVi+aiX/4iPPZ6qqN2ViCA7qP
	 Cg27FtJEEl7eQXC7bqqZHLRSP5iQobI7sgfmGQA3nOG24OMv4v+TyLCaEc+ek91yob
	 qyfweOqOonS9vq57DgLyEUkprR4IFY/Qrsg/vgTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.2 084/110] drm/rockchip: vop2: Use regcache_sync() to fix suspend/resume
Date: Mon, 24 Apr 2023 15:17:46 +0200
Message-Id: <20230424131139.637110466@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sascha Hauer <s.hauer@pengutronix.de>

commit b63a553e8f5aa6574eeb535a551817a93c426d8c upstream.

afa965a45e01 ("drm/rockchip: vop2: fix suspend/resume") uses
regmap_reinit_cache() to fix the suspend/resume issue with the VOP2
driver. During discussion it came up that we should rather use
regcache_sync() instead. As the original patch is already applied
fix this up in this follow-up patch.

Fixes: afa965a45e01 ("drm/rockchip: vop2: fix suspend/resume")
Cc: stable@vger.kernel.org
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230417123747.2179695-1-s.hauer@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -216,8 +216,6 @@ struct vop2 {
 	struct vop2_win win[];
 };
 
-static const struct regmap_config vop2_regmap_config;
-
 static struct vop2_video_port *to_vop2_video_port(struct drm_crtc *crtc)
 {
 	return container_of(crtc, struct vop2_video_port, crtc);
@@ -842,11 +840,7 @@ static void vop2_enable(struct vop2 *vop
 		return;
 	}
 
-	ret = regmap_reinit_cache(vop2->map, &vop2_regmap_config);
-	if (ret) {
-		drm_err(vop2->drm, "failed to reinit cache: %d\n", ret);
-		return;
-	}
+	regcache_sync(vop2->map);
 
 	if (vop2->data->soc_id == 3566)
 		vop2_writel(vop2, RK3568_OTP_WIN_EN, 1);
@@ -876,6 +870,8 @@ static void vop2_disable(struct vop2 *vo
 
 	pm_runtime_put_sync(vop2->dev);
 
+	regcache_mark_dirty(vop2->map);
+
 	clk_disable_unprepare(vop2->aclk);
 	clk_disable_unprepare(vop2->hclk);
 }


