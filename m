Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD1E168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842C7C433EF;
	Mon,  8 May 2023 10:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542591;
	bh=4TEmajR8fIFI1ReSA48F4F7ESgwf1iVTFHwUC1OI8ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdMwYJtxpF/mGAFfk19y4moci4OjQDTmNUAE4imNq9Ov9TmUFdRUay+XMUH0j9KAC
	 m325+bkXGtSH0HG1TqP6gwhZiw7swRKHsMnaltbl8RP+cuwlUk4LvLHeHzYDSvHdLo
	 T5C/ZmMkDHlrXi7idYn0m5xh49DtbmFyO5/tdsAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 483/663] drm/panel: novatek-nt35950: Only unregister DSI1 if it exists
Date: Mon,  8 May 2023 11:45:09 +0200
Message-Id: <20230508094444.031463672@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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
index 4359b02754aac..5d04957b1144f 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt35950.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt35950.c
@@ -594,7 +594,8 @@ static int nt35950_probe(struct mipi_dsi_device *dsi)
 
 	ret = drm_panel_of_backlight(&nt->panel);
 	if (ret) {
-		mipi_dsi_device_unregister(nt->dsi[1]);
+		if (num_dsis == 2)
+			mipi_dsi_device_unregister(nt->dsi[1]);
 
 		return dev_err_probe(dev, ret, "Failed to get backlight\n");
 	}
@@ -614,7 +615,8 @@ static int nt35950_probe(struct mipi_dsi_device *dsi)
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



