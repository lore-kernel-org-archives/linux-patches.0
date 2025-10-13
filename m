Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE1C30ACED;
	Mon, 13 Oct 2025 14:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367190; cv=none; b=IrFEvl5SofSG2yViMDMk/nOOLeEwC5xKjZ52dyCzf9Nrplt1T8JgAN5ENZWW24LV7H5F+QR/uojl1eGCDOI/2PlLlbAAPWrnWbe7vsKfvR1C4KbLwDkwhvPpeKk/1uFuCjxaA2bhfuXpXqx+xICjouhEOOhlVrOudqMcCfMrYgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367190; c=relaxed/simple;
	bh=T0YKKcwbdluc1qleqSsIRso61JsupwuAdqdNyP30E+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDeY/WDR5mgpbJYwzk3qtsduLiGZTOB65/x5HEvgDC1ThzUKk7tDmMwRza8K+5XpQlq3E7X5ERreQ9mGsNn6aNFdDHrsjZoPfIzz6LmpwHdEcJ1r91ak2SCGVHkBplvmDcp4TRM1v7cuzxuBnYzS3h0u3wZBNrbVfvsAq1Uyo0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhQbZKvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhQbZKvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278C9C4CEE7;
	Mon, 13 Oct 2025 14:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367189;
	bh=T0YKKcwbdluc1qleqSsIRso61JsupwuAdqdNyP30E+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhQbZKvOhFiHX5a18uX2E6t6AH+nf4Hwv3VK070zae+ZI2nJhdDKTN5m3y5n8qeqm
	 7hTwBSHtN//BXIUs9eCSIi6ar9apqmr2QkzDDIR7+XteumnLKWa6hhMyrhkFh2Lmn9
	 9+UIy245i+RLvCzgAp/a08gA5uMHNSxoElPN/fLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Brigham Campbell <me@brighamcampbell.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/196] drm/panel: novatek-nt35560: Fix invalid return value
Date: Mon, 13 Oct 2025 16:44:23 +0200
Message-ID: <20251013144317.827205446@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brigham Campbell <me@brighamcampbell.com>

[ Upstream commit 125459e19ec654924e472f3ff5aeea40358dbebf ]

Fix bug in nt35560_set_brightness() which causes the function to
erroneously report an error. mipi_dsi_dcs_write() returns either a
negative value when an error occurred or a positive number of bytes
written when no error occurred. The buggy code reports an error under
either condition.

Fixes: 8152c2bfd780 ("drm/panel: Add driver for Sony ACX424AKP panel")
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Brigham Campbell <me@brighamcampbell.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250731032343.1258366-2-me@brighamcampbell.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-novatek-nt35560.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-novatek-nt35560.c b/drivers/gpu/drm/panel/panel-novatek-nt35560.c
index cc7f96d708263..52df7e776fae0 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt35560.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt35560.c
@@ -162,7 +162,7 @@ static int nt35560_set_brightness(struct backlight_device *bl)
 		par = 0x00;
 		ret = mipi_dsi_dcs_write(dsi, MIPI_DCS_WRITE_CONTROL_DISPLAY,
 					 &par, 1);
-		if (ret) {
+		if (ret < 0) {
 			dev_err(nt->dev, "failed to disable display backlight (%d)\n", ret);
 			return ret;
 		}
-- 
2.51.0



