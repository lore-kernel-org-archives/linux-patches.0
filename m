Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C638E320A
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45637C433EF;
	Mon,  8 May 2023 11:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544823;
	bh=xaEc9e6ounUsuVMZvjCaiMGFrtCG5d4bhbYlcKaW9PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZS6SP8OwwQK92jPZ3jOqygy35jTXqRbGTWzCW1BvE+FnLkEaTM/EOzd72WqMaWhix
	 Qftg7agSmSjiEvVa0YvghQYzVRZSLQJmDu6RhLt4XU48DbxP4elEh82/fvj4AgRODB
	 MCI81Ga8pZdFG8CB8HljGvy8WQY/RWbCAYXoHqRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 534/694] drm/panel: novatek-nt35950: Improve error handling
Date: Mon,  8 May 2023 11:46:09 +0200
Message-Id: <20230508094451.715252372@linuxfoundation.org>
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

[ Upstream commit 5dd45b66742a1f3cfa9a92dc0ac8714c7708ee6c ]

In a very peculiar case when probing and registering with the secondary
DSI host succeeds, but the OF backlight or DSI attachment fails, the
primary DSI device is automatically cleaned up, but the secondary one
is not, leading to -EEXIST when the driver core tries to handle
-EPROBE_DEFER.

Unregister the DSI1 device manually on failure to prevent that.

Fixes: 623a3531e9cf ("drm/panel: Add driver for Novatek NT35950 DSI DriverIC panels")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230415-konrad-longbois-next-v1-1-ce695dc9df84@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-novatek-nt35950.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-novatek-nt35950.c b/drivers/gpu/drm/panel/panel-novatek-nt35950.c
index abf752b36a523..7498fc6258bb0 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt35950.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt35950.c
@@ -585,8 +585,11 @@ static int nt35950_probe(struct mipi_dsi_device *dsi)
 		       DRM_MODE_CONNECTOR_DSI);
 
 	ret = drm_panel_of_backlight(&nt->panel);
-	if (ret)
+	if (ret) {
+		mipi_dsi_device_unregister(nt->dsi[1]);
+
 		return dev_err_probe(dev, ret, "Failed to get backlight\n");
+	}
 
 	drm_panel_add(&nt->panel);
 
@@ -602,6 +605,9 @@ static int nt35950_probe(struct mipi_dsi_device *dsi)
 
 		ret = mipi_dsi_attach(nt->dsi[i]);
 		if (ret < 0) {
+			/* If we fail to attach to either host, we're done */
+			mipi_dsi_device_unregister(nt->dsi[1]);
+
 			return dev_err_probe(dev, ret,
 					     "Cannot attach to DSI%d host.\n", i);
 		}
-- 
2.39.2



