Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B6C11C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DA9C433C7;
	Thu, 24 Aug 2023 15:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889300;
	bh=8b9ucScws4hp3uNwv4Ms+1DZBrRPXIDIr+1UVZfdkLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdK/zdJYQJ9wBxTdSOn/DRHs96OD22SF81P26MF+w0PFru5RgDu4wc54Z9PKAenoD
	 +vEV9s0xY8FFSqK8VIInPv0B9GzUgBNn1yxd1YDVvne+M1bKtEAGZn09IoW/tIr1wn
	 /MIt/D0W0RlxZsnSa3pAqEPargrKMX0TT49NCtC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/135] drm/panel: simple: Fix AUO G121EAN01 panel timings according to the docs
Date: Thu, 24 Aug 2023 16:50:28 +0200
Message-ID: <20230824145030.575445553@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

[ Upstream commit e8470c0a7bcaa82f78ad34282d662dd7bd9630c2 ]

Commit 03e909acd95a ("drm/panel: simple: Add support for AUO G121EAN01.4
panel") added support for this panel model, but the timings it implements
are very different from what the datasheet describes. I checked both the
G121EAN01.0 datasheet from [0] and the G121EAN01.4 one from [1] and they
all have the same timings: for example the LVDS clock typical value is 74.4
MHz, not 66.7 MHz as implemented.

Replace the timings with the ones from the documentation. These timings
have been tested and the clock frequencies verified with an oscilloscope to
ensure they are correct.

Also use struct display_timing instead of struct drm_display_mode in order
to also specify the minimum and maximum values.

[0] https://embedded.avnet.com/product/g121ean01-0/
[1] https://embedded.avnet.com/product/g121ean01-4/

Fixes: 03e909acd95a ("drm/panel: simple: Add support for AUO G121EAN01.4 panel")
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230804151239.835216-1-luca.ceresoli@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 7b69f81444ebd..e40321d798981 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1010,21 +1010,21 @@ static const struct panel_desc auo_g104sn02 = {
 	},
 };
 
-static const struct drm_display_mode auo_g121ean01_mode = {
-	.clock = 66700,
-	.hdisplay = 1280,
-	.hsync_start = 1280 + 58,
-	.hsync_end = 1280 + 58 + 8,
-	.htotal = 1280 + 58 + 8 + 70,
-	.vdisplay = 800,
-	.vsync_start = 800 + 6,
-	.vsync_end = 800 + 6 + 4,
-	.vtotal = 800 + 6 + 4 + 10,
+static const struct display_timing auo_g121ean01_timing = {
+	.pixelclock = { 60000000, 74400000, 90000000 },
+	.hactive = { 1280, 1280, 1280 },
+	.hfront_porch = { 20, 50, 100 },
+	.hback_porch = { 20, 50, 100 },
+	.hsync_len = { 30, 100, 200 },
+	.vactive = { 800, 800, 800 },
+	.vfront_porch = { 2, 10, 25 },
+	.vback_porch = { 2, 10, 25 },
+	.vsync_len = { 4, 18, 50 },
 };
 
 static const struct panel_desc auo_g121ean01 = {
-	.modes = &auo_g121ean01_mode,
-	.num_modes = 1,
+	.timings = &auo_g121ean01_timing,
+	.num_timings = 1,
 	.bpc = 8,
 	.size = {
 		.width = 261,
-- 
2.40.1



