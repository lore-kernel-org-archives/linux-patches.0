Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FB5168CD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C088C433D2;
	Mon,  8 May 2023 11:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544832;
	bh=anD215Zbt0wu9yV4FLpWw8tnntdUTqsuMwEFPPdpUKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RG8XDOA9/b3zYYlOeUGdV/zKgxX6iiJmms0xVFRIQ64FVol7Fxa5iYv7upPteiSpz
	 JPvxpBcUw0aXEmaIRxH4/N1GoMsDJdpiynUimSn5V9IV5FaskLXZ6kdNIkDFLK2i5b
	 /ym0LuXyjvyWOuOYkGQl36nFZ7FkT7j5iJB+ptmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 537/694] drm/panel: novatek-nt35950: Only unregister DSI1 if it exists
Date: Mon,  8 May 2023 11:46:12 +0200
Message-Id: <20230508094451.840435022@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit a50be876f4fe2349dc8b056a49d87f69c944570f ]

Commit 5dd45b66742a ("drm/panel: novatek-nt35950: Improve error handling")
introduced logic to unregister DSI1 on any sort of probe failure, as
that's not done automatically by kernel APIs.

It did not however account for cases where only one DSI host is used.
Fix that.

Fixes: 5dd45b66742a ("drm/panel: novatek-nt35950: Improve error handling")
Reported-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230417-topic-maple_panel_fixup-v1-1-07c8db606f5e@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-novatek-nt35950.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-novatek-nt35950.c b/drivers/gpu/drm/panel/panel-novatek-nt35950.c
index 7498fc6258bb0..8b108ac80b556 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt35950.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt35950.c
@@ -586,7 +586,8 @@ static int nt35950_probe(struct mipi_dsi_device *dsi)
 
 	ret = drm_panel_of_backlight(&nt->panel);
 	if (ret) {
-		mipi_dsi_device_unregister(nt->dsi[1]);
+		if (num_dsis == 2)
+			mipi_dsi_device_unregister(nt->dsi[1]);
 
 		return dev_err_probe(dev, ret, "Failed to get backlight\n");
 	}
@@ -606,7 +607,8 @@ static int nt35950_probe(struct mipi_dsi_device *dsi)
 		ret = mipi_dsi_attach(nt->dsi[i]);
 		if (ret < 0) {
 			/* If we fail to attach to either host, we're done */
-			mipi_dsi_device_unregister(nt->dsi[1]);
+			if (num_dsis == 2)
+				mipi_dsi_device_unregister(nt->dsi[1]);
 
 			return dev_err_probe(dev, ret,
 					     "Cannot attach to DSI%d host.\n", i);
-- 
2.39.2



