Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141F852F26B;
	Thu, 17 Sep 2026 17:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664866; cv=none; b=a4b6x4e5TjACl8PQIgJmi8pYTi5JhoFDjQpdzGU9AvVsl22cOpveHTyStKxCTdhJBM46VIpRo7u//UNVFiTfghBXyQyWez6bimJs6VzYIS/FwkdKM7BzfBTcFzz+PlTzkhbRukA78G9fgO8xCm89EAs7i+/SQF8azfUvBUjm/qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664866; c=relaxed/simple;
	bh=tvF06ec5nWEg86nkFFE3M7salZH3OVW3krCh1eVIv88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ReRDqnDTdeoNn9mDsDAWjCkVs7+RBECg4FjxvzbS3V29FNUR1rmsNIyMYV1xSDgwoXbqPVW1sHP2i6P0Cd4h3hwdeanQ9cCSTOyd/k1Ohcvyb7tElbNlnh/7kMjfKU1UQMk2RiEeisyo/fPiYktetVsOWXkJvqH4Uz708Dho11o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZJia2yp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZJia2yp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D731F0089E;
	Thu, 17 Sep 2026 17:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664864;
	bh=dnIjm+ZUk/NNCoJ3kqQ0STK9Y9ah19NYi6/2xn+6EgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZJia2ypNoUw2SPs+DL14ViLnWBrjpauq3JdCoCCOgg5bdtEi0B3oo1nCU/0SOiM6
	 P18a8RNkpAS8QcfheyVLOl8qqXLsHCFK8NTGopbgNXL18NgYdwg/MtOCq2k53yEiDk
	 FpzvLOy7UsQME5/FfaVyf+7sxS0sYEm2ftJJCsI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Gustavo=20Kenji=20Mendon=C3=A7a=20Kaneko?= <kaneko.dev@pm.me>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0476/1250] drm/arm/malidp: use clk_bulk API in runtime PM resume and suspend
Date: Thu, 17 Sep 2026 16:04:31 +0100
Message-ID: <20260917151604.871336080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bc5f5e9798c32..2bf4a647e4b28 100644
--- a/drivers/gpu/drm/arm/malidp_drv.c
+++ b/drivers/gpu/drm/arm/malidp_drv.c
@@ -669,6 +669,11 @@ static int malidp_runtime_pm_suspend(struct device *dev)
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
@@ -676,9 +681,7 @@ static int malidp_runtime_pm_suspend(struct device *dev)
 	malidp_se_irq_fini(hwdev);
 	malidp_de_irq_fini(hwdev);
 	hwdev->pm_suspended = true;
-	clk_disable_unprepare(hwdev->mclk);
-	clk_disable_unprepare(hwdev->aclk);
-	clk_disable_unprepare(hwdev->pclk);
+	clk_bulk_disable_unprepare(ARRAY_SIZE(clks), clks);
 
 	return 0;
 }
@@ -688,10 +691,17 @@ static int malidp_runtime_pm_resume(struct device *dev)
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



