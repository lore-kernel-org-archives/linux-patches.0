Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3812D17A311;
	Tue,  8 Apr 2025 12:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116316; cv=none; b=ki7Q4CtS/2QPtIMzo7DdjxsJvxV02kg2OgUjvBgGn8Vwjxt4DdamGS9quPmgO7rnUoTx1S2AT5gUlsgUMuU67MP58ECwQ0O6EkmbZsDVHYfdRA2UerC5gqJ76osIkA31E77Tt3UxqwD2sUmzbYQDkkEvnDrJ5ygBmE2+0Cwi4Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116316; c=relaxed/simple;
	bh=3mI36GI+OixFSITRAaXBiN0h2hKGPu40apwPAUNcln4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pg7MzlT6EASUSy2vWh6PleKrTtwOaV0koD/HpGcI6KGFphoEEZGdmT8fxb5JSFc2i35UxLenUJZLbomc1IVrEth/O7nSZJLGL1uLAZU/ahdTfmIRh5teVhBt/idk9TyvsegHt2TU6CDpay14XnU/1Ue+xG8bORysquj3zxPv9us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+u1shpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+u1shpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD9AC4CEE5;
	Tue,  8 Apr 2025 12:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116316;
	bh=3mI36GI+OixFSITRAaXBiN0h2hKGPu40apwPAUNcln4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+u1shpzdt7Xpm4HN+BAC0z3UHNBjCHeeef2BAz80XdDC2pgY1R3SWtdBAN7DYarz
	 Z1n5c2AGdWtd5mDAXS5OyWzQmGj23j2x408xkkfiJFRoQOOv1ztaRIgDrxMGxDW7lx
	 ZuGXJwjRKn3i2zT+5TF3CKLEWgaPYkuXMy9vY3tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/423] gpu: cdns-mhdp8546: fix call balance of mhdp->clk handling routines
Date: Tue,  8 Apr 2025 12:46:21 +0200
Message-ID: <20250408104847.032457291@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitalii Mordan <mordan@ispras.ru>

[ Upstream commit f65727be3fa5f252c8d982d15023aab8255ded19 ]

If the clock mhdp->clk was not enabled in cdns_mhdp_probe(), it should not
be disabled in any path.

The return value of clk_prepare_enable() is not checked. If mhdp->clk was
not enabled, it may be disabled in the error path of cdns_mhdp_probe()
(e.g., if cdns_mhdp_load_firmware() fails) or in cdns_mhdp_remove() after
a successful cdns_mhdp_probe() call.

Use the devm_clk_get_enabled() helper function to ensure proper call
balance for mhdp->clk.

Found by Linux Verification Center (linuxtesting.org) with Klever.

Fixes: fb43aa0acdfd ("drm: bridge: Add support for Cadence MHDP8546 DPI/DP bridge")
Signed-off-by: Vitalii Mordan <mordan@ispras.ru>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250214154632.1907425-1-mordan@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
index 41f72d458487f..9ba2a667a1f3a 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -2463,9 +2463,9 @@ static int cdns_mhdp_probe(struct platform_device *pdev)
 	if (!mhdp)
 		return -ENOMEM;
 
-	clk = devm_clk_get(dev, NULL);
+	clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(clk)) {
-		dev_err(dev, "couldn't get clk: %ld\n", PTR_ERR(clk));
+		dev_err(dev, "couldn't get and enable clk: %ld\n", PTR_ERR(clk));
 		return PTR_ERR(clk);
 	}
 
@@ -2504,14 +2504,12 @@ static int cdns_mhdp_probe(struct platform_device *pdev)
 
 	mhdp->info = of_device_get_match_data(dev);
 
-	clk_prepare_enable(clk);
-
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
 		dev_err(dev, "pm_runtime_resume_and_get failed\n");
 		pm_runtime_disable(dev);
-		goto clk_disable;
+		return ret;
 	}
 
 	if (mhdp->info && mhdp->info->ops && mhdp->info->ops->init) {
@@ -2590,8 +2588,6 @@ static int cdns_mhdp_probe(struct platform_device *pdev)
 runtime_put:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
-clk_disable:
-	clk_disable_unprepare(mhdp->clk);
 
 	return ret;
 }
@@ -2632,8 +2628,6 @@ static void cdns_mhdp_remove(struct platform_device *pdev)
 	cancel_work_sync(&mhdp->modeset_retry_work);
 	flush_work(&mhdp->hpd_work);
 	/* Ignoring mhdp->hdcp.check_work and mhdp->hdcp.prop_work here. */
-
-	clk_disable_unprepare(mhdp->clk);
 }
 
 static const struct of_device_id mhdp_ids[] = {
-- 
2.39.5



