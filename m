Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946FC2DEA95;
	Wed, 30 Sep 2026 18:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794618; cv=none; b=N1dhEIsErJU1g6oKd/WzJGowVtLodtghy2ssh+F4/Hqp9+pnC5dtjPpLDQfudZVJi5JRfzWltnq1UVj7B1LO3R6+H5tfvonE3EzwSN0hGZrPADyDup8YhLqcdU/cvcc/Sll2P7VXCCIe5AHVbTnnsnLqtbjomg0NZtlVMBUxBEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794618; c=relaxed/simple;
	bh=BIyhJRrlKoY5u7Gbrr+NaLotfTXoAx2ks63E69+2cCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZgLsM3nYQCCkVdU46E3n/0zvZA+bWBas4nlyagLsW5uKZmsdKc+Ey8smtW4cBVUTLWhNsk7acIhvxuj0b6HZITchZ1XvKsFeFBzgpo6rj1gwdDJkmT23LUXTdIjJx8ZF80MOqSwEdO8uS/dv7lb+c5tu03wldCI+yqnC2Vrekbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PEEJj5Gg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PEEJj5Gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08DA1F000FF;
	Wed, 30 Sep 2026 18:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794617;
	bh=IhgjiNF/EvfFRscBY0spTuQ1qgGFummQ7VLCqFTuupw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PEEJj5GgDItUmk1b8PrLWlxDklhytTiAum3GdI3FISGVXe6/2okzGfZxOPKdyr2Gb
	 1FW3Zjx8Q46SP/sflSTE9BK2gsk7uLDdwteePbWNqoAQBqnfOwhU1yHupZSDcTIg3i
	 g5q7ci4cEcBGGtlAIFt6EUfeJbPkvoHOCtDG/c9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Gustavo=20Kenji=20Mendon=C3=A7a=20Kaneko?= <kaneko.dev@pm.me>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0272/1193] drm/arm/malidp: use clk_bulk API in runtime PM resume and suspend
Date: Wed, 30 Sep 2026 17:15:56 +0200
Message-ID: <20260930152440.209241254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>

[ Upstream commit 46f715a16989f4e7bbbc2eb41447051874b027f3 ]

malidp_runtime_pm_resume() calls clk_prepare_enable() three times
without checking the return value. If any clock fails to enable, the
driver silently proceeds with unclocked hardware, leading to undefined
behavior.

Convert both the resume and suspend paths to use the clk_bulk API:
clk_bulk_prepare_enable() in resume checks the return value and rolls
back any successfully enabled clocks on failure;
clk_bulk_disable_unprepare() in suspend keeps the two paths symmetric.

This issue was found by code review without access to Mali DP hardware.

Signed-off-by: Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260609130812.1065699-1-kaneko.dev@pm.me
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/malidp_drv.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/arm/malidp_drv.c b/drivers/gpu/drm/arm/malidp_drv.c
index 62329d5dd992e..457bd7669806b 100644
--- a/drivers/gpu/drm/arm/malidp_drv.c
+++ b/drivers/gpu/drm/arm/malidp_drv.c
@@ -668,6 +668,11 @@ static int malidp_runtime_pm_suspend(struct device *dev)
 	struct drm_device *drm = dev_get_drvdata(dev);
 	struct malidp_drm *malidp = drm_to_malidp(drm);
 	struct malidp_hw_device *hwdev = malidp->dev;
+	struct clk_bulk_data clks[] = {
+		{ .clk = hwdev->pclk },
+		{ .clk = hwdev->aclk },
+		{ .clk = hwdev->mclk },
+	};
 
 	/* we can only suspend if the hardware is in config mode */
 	WARN_ON(!hwdev->hw->in_config_mode(hwdev));
@@ -675,9 +680,7 @@ static int malidp_runtime_pm_suspend(struct device *dev)
 	malidp_se_irq_fini(hwdev);
 	malidp_de_irq_fini(hwdev);
 	hwdev->pm_suspended = true;
-	clk_disable_unprepare(hwdev->mclk);
-	clk_disable_unprepare(hwdev->aclk);
-	clk_disable_unprepare(hwdev->pclk);
+	clk_bulk_disable_unprepare(ARRAY_SIZE(clks), clks);
 
 	return 0;
 }
@@ -687,10 +690,17 @@ static int malidp_runtime_pm_resume(struct device *dev)
 	struct drm_device *drm = dev_get_drvdata(dev);
 	struct malidp_drm *malidp = drm_to_malidp(drm);
 	struct malidp_hw_device *hwdev = malidp->dev;
+	struct clk_bulk_data clks[] = {
+		{ .clk = hwdev->pclk },
+		{ .clk = hwdev->aclk },
+		{ .clk = hwdev->mclk },
+	};
+	int err;
+
+	err = clk_bulk_prepare_enable(ARRAY_SIZE(clks), clks);
+	if (err)
+		return err;
 
-	clk_prepare_enable(hwdev->pclk);
-	clk_prepare_enable(hwdev->aclk);
-	clk_prepare_enable(hwdev->mclk);
 	hwdev->pm_suspended = false;
 	malidp_de_irq_hw_init(hwdev);
 	malidp_se_irq_hw_init(hwdev);
-- 
2.53.0



