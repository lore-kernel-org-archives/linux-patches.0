Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7644A1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBB5C433D2;
	Wed, 28 Dec 2022 14:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239316;
	bh=dFXC/ABF4qD/kQ/+FO+hc/5QahOtsfa6J+G1j6QWqek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kpry8aOsMCKlLLysY+tshHglGfr6ThYX1sitmWQzrUDq/PTSWtkHaPlPP+uNWoSf5
	 sy1/y4aViAQmIhbJ5uv3C/3nPM2B/ssLyYMGeh9+3kuuXYM2mWuDRoUAWlqmILXNv8
	 TXaAM9vxASfvIo1QV5gYx7+bHvA347JLUuPQ+K2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 175/731] drm/panel/panel-sitronix-st7701: Remove panel on DSI attach failure
Date: Wed, 28 Dec 2022 15:34:42 +0100
Message-Id: <20221228144301.636401197@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 320a2a8fd459..098955526b68 100644
--- a/drivers/gpu/drm/panel/panel-sitronix-st7701.c
+++ b/drivers/gpu/drm/panel/panel-sitronix-st7701.c
@@ -384,7 +384,15 @@ static int st7701_dsi_probe(struct mipi_dsi_device *dsi)
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



