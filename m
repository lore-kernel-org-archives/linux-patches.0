Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C895D4156C6;
	Tue, 13 Oct 2026 12:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894373; cv=none; b=hCdFob+EN1z7TSOoo4i9IP65rQp55UuYs/RXSy96psjodfQxgOlc5f7aGUKAZcFgDEbe4ISWLQSZj4NK9KkRaknAWxgSu6RJPStwTLNZ7nPo2fNgVpAm4nsEDO8KlrIT6kKlZwMmyiFP9uiov+Vm1GZsWyLhsO8h/fw/SbMboQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894373; c=relaxed/simple;
	bh=rbNKInB4wRCZOZ3BVu+9q0gFMGHyfuoYNjz+qDrv/WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIWkGPhF5EeDoTLAEZ5Pu/R7mm2f2AzqZDAvr1F4pv9+4FJOD22U82lzrORC5vvTFi1XIB8SKbwLyzGbo3qjoI14+OuAhBdAS1VAsSiGMGDGKt8e2eyH2WBK51jj72b2KxrEiXRGRBpvNuIZZ0jxmyLYQG59eoWw8HUn+NWy4M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=miNdQtTg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="miNdQtTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F561F000FF;
	Tue, 13 Oct 2026 12:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894370;
	bh=lHKDn+7H4GLf2/ktg/DEtILIhhEJNzsGk+zKG3ZPgzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=miNdQtTgscbhjtSNaKFW4xbtQCbVP8bEotQZMsVJBHwqrUy0TSQlaxGExFGjDSxCK
	 a5SLNhQAzl01gaX33bMVHkRzuGjcicESfjojA+p3DoblDLOFvEI8rCZjZDCSSm2YXx
	 uFevxwqOhnSn05zvpvd05U9zl5R9pWJSClAlADuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 539/621] drm/aspeed: Balance the display clock enable on teardown
Date: Tue, 13 Oct 2026 13:38:54 +0200
Message-ID: <20261013112933.610849673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit ecce445c6489895463b7ddec2af66338287fee4c ]

aspeed_gfx_load() enables the display clock without checking the return
value and never disables it on probe failure or removal. devm_clk_get()
only releases the clock reference, leaving the enable unbalanced.

Use devm_clk_get_enabled() to handle enable failures and automatically
disable and unprepare the clock on probe failure or removal.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 4f2a8f5898ec ("drm: Add ASPEED GFX driver")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Assisted-by: OpenAI:GPT-5.6
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260913223019.89651-1-mhun512@gmail.com
Link: https://patch.msgid.link/20260905080426.34224-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/aspeed/aspeed_gfx_drv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c b/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c
index 46094cca29747..a226eb2fbbe69 100644
--- a/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c
+++ b/drivers/gpu/drm/aspeed/aspeed_gfx_drv.c
@@ -190,13 +190,12 @@ static int aspeed_gfx_load(struct drm_device *drm)
 	}
 	reset_control_deassert(priv->rst);
 
-	priv->clk = devm_clk_get(drm->dev, NULL);
+	priv->clk = devm_clk_get_enabled(drm->dev, NULL);
 	if (IS_ERR(priv->clk)) {
 		dev_err(&pdev->dev,
-			"missing or invalid clk device tree entry");
+			"failed to get and enable clock\n");
 		return PTR_ERR(priv->clk);
 	}
-	clk_prepare_enable(priv->clk);
 
 	/* Sanitize control registers */
 	writel(0, priv->base + CRT_CTRL1);
-- 
2.53.0



