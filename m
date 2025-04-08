Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32659268694;
	Tue,  8 Apr 2025 11:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111018; cv=none; b=CQf11JJEaY7oHzVJTu0CBKmHljXkpBes47i7QgU0Qi6fVd+DDjk2amope64VSwxCNpuR6mBXLzjBRpGoBwX7Lev36l4zjKM0wq+9hCteAmGndrYmOuqCKO8gRK73M0Zoin2wHeZDz6cvmgDvaKYoLDZBATjjBF5KmIUOMo/OBjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111018; c=relaxed/simple;
	bh=ZsNjbZMWza+GXrsHz/5C5ZqOAGMNic7pzM9QtN6Bt/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kj+4nVh/nmJ4lyqqC3tIkPOCJt+bwIBR+T4m5b9GI48uSAj1l+4z300jbDi0xqh1ls0V9O1AyhNOntUI/6IqH6foTKsVYdGSrUR7IqVlQds0JpeZIUw9Zs23Puhcu9SGoiwnBebMNeVNh/7VlATDRunWLeJODvdK1TUhCXcw1WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAv/Tnrl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAv/Tnrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D6AC4CEE5;
	Tue,  8 Apr 2025 11:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111018;
	bh=ZsNjbZMWza+GXrsHz/5C5ZqOAGMNic7pzM9QtN6Bt/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAv/TnrlUgUI7AWqa+eWRc2DNHA1LTSLZjZmw+6+tmDdDV+zL0u7eO37HkR9pRNi0
	 Gj/6NG3yv73gpa3tgbQWNohY5Ub6d/fGqIhELhYWk5kKShpEmKYtWoOgbcvHkNA+8F
	 NIZJrfipXrNfQk4xblET5fyoqSHmgw9P25brBrT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 279/731] gpu: cdns-mhdp8546: fix call balance of mhdp->clk handling routines
Date: Tue,  8 Apr 2025 12:42:56 +0200
Message-ID: <20250408104920.769363304@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index d081850e3c03e..d4e4f484cbe5e 100644
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



