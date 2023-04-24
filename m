Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6FD7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3923C433D2;
	Mon, 24 Apr 2023 13:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342822;
	bh=ehsUc5/em0JzuMLl5lf7UnhWnu5DDaeOarARG3z1yxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZtL9cMOBssoBnlAwQWsaloH8CR8G91nE9xJSe2RBANjvDDqYpT7i3496TRNjLCOJ
	 pHTCZ4BS140sSrB7QdULk7i0ju+qeWKuL9bTibcNlxCF/NdyA8MZO6VEy77uZkdxEj
	 YiEkr3clTeFz7JsPfQMQIm/1Q1jhlZDMOhDzLa5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.1 70/98] drm/rockchip: vop2: fix suspend/resume
Date: Mon, 24 Apr 2023 15:17:33 +0200
Message-Id: <20230424131136.570561671@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
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

commit afa965a45e01e541cdbe5c8018226eff117610f0 upstream.

During a suspend/resume cycle the VO power domain will be disabled and
the VOP2 registers will reset to their default values. After that the
cached register values will be out of sync and the read/modify/write
operations we do on the window registers will result in bogus values
written. Fix this by re-initializing the register cache each time we
enable the VOP2. With this the VOP2 will show a picture after a
suspend/resume cycle whereas without this the screen stays dark.

Fixes: 604be85547ce4 ("drm/rockchip: Add VOP2 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Tested-by: Chris Morgan <macromorgan@hotmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230413144347.3506023-1-s.hauer@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -216,6 +216,8 @@ struct vop2 {
 	struct vop2_win win[];
 };
 
+static const struct regmap_config vop2_regmap_config;
+
 static struct vop2_video_port *to_vop2_video_port(struct drm_crtc *crtc)
 {
 	return container_of(crtc, struct vop2_video_port, crtc);
@@ -840,6 +842,12 @@ static void vop2_enable(struct vop2 *vop
 		return;
 	}
 
+	ret = regmap_reinit_cache(vop2->map, &vop2_regmap_config);
+	if (ret) {
+		drm_err(vop2->drm, "failed to reinit cache: %d\n", ret);
+		return;
+	}
+
 	if (vop2->data->soc_id == 3566)
 		vop2_writel(vop2, RK3568_OTP_WIN_EN, 1);
 


