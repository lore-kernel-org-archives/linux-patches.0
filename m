Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852C98F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC3FC433C7;
	Sun, 16 Jul 2023 20:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537790;
	bh=h3CBeke6BN2KMMEmGF4X7sLsNn5zhHMuRoUGiMuYAME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gr1vd4t7RchWLTKR81aMrP7gyZlky+RPz80xYIPwsBY5EB9j/0ZcSXe4/ASCan5b9
	 1225hfq6wQ15j4aeMmoMmMOK5vC8rzIHJQa6YcKDap7AVmfS8ZHZfsrUJjuYZruaaT
	 IahyP/LjYVwEB24MrUf1I+o/B7sieMN58zQDyDb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 222/800] drm/imx/lcdc: fix a NULL vs IS_ERR() bug in probe
Date: Sun, 16 Jul 2023 21:41:15 +0200
Message-ID: <20230716194954.248741691@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit dae2f7b89a8436351a2982d0d96a8a56accca576 ]

The devm_drm_dev_alloc() function returns error pointers.  It never
returns NULL.  Fix the check.

Fixes: c87e859cdeb5 ("drm/imx/lcdc: Implement DRM driver for imx25")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/d0a1fc55-3ef6-444e-b3ef-fdc937d8d57a@kili.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/lcdc/imx-lcdc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/imx/lcdc/imx-lcdc.c b/drivers/gpu/drm/imx/lcdc/imx-lcdc.c
index 8e6d457917daf..277ead6a459a4 100644
--- a/drivers/gpu/drm/imx/lcdc/imx-lcdc.c
+++ b/drivers/gpu/drm/imx/lcdc/imx-lcdc.c
@@ -400,8 +400,8 @@ static int imx_lcdc_probe(struct platform_device *pdev)
 
 	lcdc = devm_drm_dev_alloc(dev, &imx_lcdc_drm_driver,
 				  struct imx_lcdc, drm);
-	if (!lcdc)
-		return -ENOMEM;
+	if (IS_ERR(lcdc))
+		return PTR_ERR(lcdc);
 
 	drm = &lcdc->drm;
 
-- 
2.39.2



