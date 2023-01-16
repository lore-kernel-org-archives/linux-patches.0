Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2294C46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C84DC433D2;
	Mon, 16 Jan 2023 16:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885609;
	bh=+uu0PwB9lsmN4vCpKbduM73AybgmqwhJPD1L8xcPIfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXfSBcVgEu0sAD6Xh8ayVBBarsLN0Vu8yvOnG89fqyXDhTgH1Bw+gE1yQY+4nhpHU
	 NP1Vko7yC55sYA3P5PvEHRZEZVCoIA8wZJHLMHWRYHSEcI5pNibtkI5Na4M20o6jpG
	 nXKz7dSEr37rIkP5SnKzXbFWHdfwlXW6ZWVlKIzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/658] drm/panel/panel-sitronix-st7701: Remove panel on DSI attach failure
Date: Mon, 16 Jan 2023 16:43:24 +0100
Message-Id: <20230116154914.804274188@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit c62102165dd79284d42383d2f7ed17301bd8e629 ]

In case mipi_dsi_attach() fails, call drm_panel_remove() to
avoid memory leak.

Fixes: 849b2e3ff969 ("drm/panel: Add Sitronix ST7701 panel driver")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221014231106.468063-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-sitronix-st7701.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-sitronix-st7701.c b/drivers/gpu/drm/panel/panel-sitronix-st7701.c
index 09c5d9a6f9fa..638f605acb2d 100644
--- a/drivers/gpu/drm/panel/panel-sitronix-st7701.c
+++ b/drivers/gpu/drm/panel/panel-sitronix-st7701.c
@@ -392,7 +392,15 @@ static int st7701_dsi_probe(struct mipi_dsi_device *dsi)
 	st7701->dsi = dsi;
 	st7701->desc = desc;
 
-	return mipi_dsi_attach(dsi);
+	ret = mipi_dsi_attach(dsi);
+	if (ret)
+		goto err_attach;
+
+	return 0;
+
+err_attach:
+	drm_panel_remove(&st7701->panel);
+	return ret;
 }
 
 static int st7701_dsi_remove(struct mipi_dsi_device *dsi)
-- 
2.35.1



